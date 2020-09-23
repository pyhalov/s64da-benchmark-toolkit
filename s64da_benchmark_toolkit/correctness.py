
import logging
import math
import os

from enum import Enum

import numpy as np
import pandas as pd

from natsort import index_natsorted, order_by_index

LOG = logging.getLogger()


class CorrectnessResult:
    def __init__(self, status, detail=None, truth=[], result=[]):
        self.status = status
        self.detail = detail
        self.truth = truth
        self.result = result

    @classmethod
    def make_mismatch_result(cls, detail, truth, result):
        return cls('MISMATCH', detail=detail, truth=truth, result=result)

    @classmethod
    def make_ok_result(cls):
        return cls('OK')

    @property
    def is_ok(self):
        return self.status == 'OK'

    @property
    def is_mismatch(self):
        return self.status == 'MISMATCH'

    def to_html(self):
        status = self.status
        if self.is_ok:
            return status

        def check_for_empty_df_then_convert_to_html(df):
            if isinstance(df, list) and df == []:
                return 'None'
            else:
                return df.to_html()

        # HTML here, since it'll be used for reporting to HTML
        truth_html = check_for_empty_df_then_convert_to_html(self.truth)
        result_html = check_for_empty_df_then_convert_to_html(self.result)
        return f'{status}<br /><div>{truth_html}</div><br /><div>{result_html}</div>'

    def __repr__(self):
        return self.status


class ResultDetail(Enum):
    OK = 1
    TRUTH_EMPTY = 2
    RESULT_EMPTY = 3
    SHAPE_MISMATCH = 4
    COLUMNS_MISMATCH = 5
    VALUE_MISMATCH = 6


class Correctness:
    def __init__(self, scale_factor, benchmark):
        self.scale_factor = scale_factor
        self.query_output_folder = os.path.join('results', 'query_results')
        self.correctness_results_folder = os.path.join('correctness_results',
                                                       benchmark, f'sf{self.scale_factor}')

    def get_correctness_filepath(self, query_id):
        filepath = os.path.join(self.correctness_results_folder, f'{query_id}.csv')
        return filepath

    def prepare(self, df):
        # Sort columns
        df = df.sort_index(axis=1)
        # Natsort all rows
        df.sort_values(by=list(df.columns), axis=0, inplace=True, na_position='first')
        # Recreate index for comparison later
        df.reset_index(level=0, drop=True, inplace=True)
        return df

    @classmethod
    def is_float64_close(cls, truth_value, result_value):
        if np.isnan(truth_value) and np.isnan(result_value):
            return True
        return math.isclose(truth_value, result_value, abs_tol=0.009, rel_tol=1e-12)


    @classmethod
    def check_for_mismatches(cls, truth, result):
        """Checks for mismatches between truth and result.
           Returns a list with the mismatching indexs.
           Assumptions:
           - truth and result have the same columns.
           - trush and result are both sorted in the same manner.
        """

        merge = truth.merge(result, indicator=True, how='left')
        diff_indexes = merge.index[merge._merge != 'both']
        if diff_indexes.empty:
            return []

        truth_diff = truth.iloc[diff_indexes.to_list()]
        result_diff = result.iloc[diff_indexes.to_list()]

        mismatches = set()
        for column_name, column_type in truth_diff.dtypes.items():
            if column_type == 'float64':
                temp_df = pd.DataFrame(data={'truth': truth_diff[column_name],'result': result_diff[column_name]}, index=truth_diff.index)
                temp_df['isclose'] = temp_df.apply(lambda x: Correctness.is_float64_close(x['truth'], x['result']), axis=1)
                col_comp = temp_df.isclose
            else:
                # Compare the truth and result columns
                col_comp = truth_diff[column_name].compare(result_diff[column_name])
                # Convert the result to a Series object
                col_comp[column_name] = False
                col_comp = col_comp[column_name]

            col_mismatches = col_comp.index[col_comp == False].tolist()
            mismatches.update(col_mismatches)

        return sorted(mismatches)


    def _check_correctness_impl(self, truth, result):
        if truth.empty != result.empty:
            return (ResultDetail.TRUTH_EMPTY, None) if truth.empty else (ResultDetail.RESULT_EMPTY, None)

        if truth.shape != result.shape:
            return (ResultDetail.SHAPE_MISMATCH, None)

        truth = self.prepare(truth)
        result = self.prepare(result)

        # Column names must be same
        if not truth.columns.difference(result.columns).empty:
            return (ResultDetail.COLUMNS_MISMATCH, None)

        mismatch_indices = Correctness.check_for_mismatches(truth, result)
        if mismatch_indices:
            return (ResultDetail.VALUE_MISMATCH, mismatch_indices)

        return (ResultDetail.OK, None)

    def check_correctness(self, stream_id, query_number):
        LOG.debug(f'Checking Stream={stream_id}, Query={query_number}')
        correctness_path = self.get_correctness_filepath(query_number)
        benchmark_path = os.path.join(self.query_output_folder, f'{stream_id}_{query_number}.csv')

        # Reading truth
        try:
            truth = pd.read_csv(correctness_path)
        except pd.errors.EmptyDataError:
            LOG.debug(f'Query {query_number} is empty in correctness results.')
            truth = pd.DataFrame(columns=['col'])
        except FileNotFoundError:
            LOG.debug(f'Correctness results for {query_number} not found. Skipping correctness checking.')
            return CorrectnessResult.make_ok_result()

        # Reading Benchmark results
        try:
            result = pd.read_csv(benchmark_path, float_precision='round_trip')
        except pd.errors.EmptyDataError:
            LOG.debug(f'{stream_id}_{query_number}.csv empty in benchmark results.')
            result = pd.DataFrame(columns=['col'])
        except FileNotFoundError:
            msg = f'Query results for {stream_id}-{query_number} not found. Reporting as mismatch.'
            LOG.debug(msg)
            return CorrectnessResult.make_mismatch_result(
                ResultDetail.RESULT_EMPTY, [], [])

        result_detail, mismatch_indexes = self._check_correctness_impl(truth, result)
        if result_detail == ResultDetail.OK:
            return CorrectnessResult.make_ok_result()

        elif result_detail == ResultDetail.VALUE_MISMATCH:
            truth = self.prepare(truth)
            result = self.prepare(result)
            return CorrectnessResult.make_mismatch_result(
                result_detail,
                truth.loc[mismatch_indexes],
                result.loc[mismatch_indexes])

        return CorrectnessResult.make_mismatch_result(result_detail, [], [])
