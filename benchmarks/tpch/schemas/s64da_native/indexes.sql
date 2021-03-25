CREATE INDEX IDX_SUPPLIER_NATION_KEY ON SUPPLIER (S_NATIONKEY);
CREATE INDEX IDX_PARTSUPP_PARTKEY ON PARTSUPP (PS_PARTKEY);
CREATE INDEX IDX_PARTSUPP_SUPPKEY ON PARTSUPP (PS_SUPPKEY);
CREATE INDEX IDX_CUSTOMER_NATIONKEY ON CUSTOMER (C_NATIONKEY);
CREATE INDEX IDX_ORDERS_CUSTKEY ON ORDERS (O_CUSTKEY);
CREATE INDEX IDX_LINEITEM_ORDERKEY ON LINEITEM (L_ORDERKEY);
CREATE INDEX IDX_LINEITEM_PART_SUPP ON LINEITEM (L_PARTKEY,L_SUPPKEY);
-- PSQL is able to traverse 'IDX_LINEITEM_PART_SUPP' for 'L_PARTKEY' only
-- CREATE INDEX IDX_LINEITEM_PART ON LINEITEM (L_PARTKEY);
CREATE INDEX IDX_LINEITEM_SUPP ON LINEITEM (L_SUPPKEY);
CREATE INDEX IDX_NATION_REGIONKEY ON NATION (N_REGIONKEY);

CREATE INDEX IDX_LINEITEM_SHIPDATE ON LINEITEM (L_SHIPDATE);
CREATE INDEX IDX_LINEITEM_COMMITDATE ON LINEITEM (L_COMMITDATE);
CREATE INDEX IDX_LINEITEM_RECEIPTDATE ON LINEITEM (L_RECEIPTDATE);
CREATE INDEX IDX_ORDERS_ORDERDATE ON ORDERS (O_ORDERDATE);

CREATE INDEX customer_columnstore_idx ON customer USING columnstore (
    c_custkey,
    c_name,
    c_address,
    c_nationkey,
    c_phone,
    c_acctbal,
    c_mktsegment,
    c_comment
);

CREATE INDEX orders_columnstore_idx ON orders USING columnstore (
    o_orderkey,
    o_custkey,
    o_orderstatus,
    o_totalprice,
    o_orderdate,
    o_orderpriority,
    o_clerk,
    o_shippriority,
    o_comment
);

CREATE INDEX part_columnstore_idx ON part USING columnstore (
    p_partkey,
    p_name,
    p_mfgr,
    p_brand,
    p_type,
    p_size,
    p_container,
    p_retailprice,
    p_comment
);

CREATE INDEX partsupp_columnstore_idx ON partsupp USING columnstore (
    ps_partkey,
    ps_suppkey,
    ps_availqty,
    ps_supplycost,
    ps_comment
);

CREATE INDEX lineitem_columnstore_idx ON lineitem USING columnstore (
    l_orderkey,
    l_partkey,
    l_suppkey,
    l_linenumber,
    l_quantity,
    l_extendedprice,
    l_discount,
    l_tax,
    l_returnflag,
    l_linestatus,
    l_shipdate,
    l_commitdate,
    l_receiptdate,
    l_shipinstruct,
    l_shipmode,
    l_comment
);
