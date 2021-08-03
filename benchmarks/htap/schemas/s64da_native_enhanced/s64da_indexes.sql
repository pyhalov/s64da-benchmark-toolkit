CREATE INDEX idx_customer_cache ON customer USING columnstore (
    c_id
  , c_d_id
  , c_w_id
  , c_nationkey
  , c_last
  , c_city
);

CREATE INDEX idx_orders_cache ON orders USING columnstore (
    o_id
  , o_d_id
  , o_w_id
  , o_c_id
  , o_entry_d
  , o_carrier_id
);

CREATE INDEX idx_order_line_cache ON order_line USING columnstore (
    ol_o_id
  , ol_d_id
  , ol_w_id
  , ol_number
  , ol_i_id
  , ol_supply_w_id
);

CREATE INDEX idx_stock_cache ON stock USING columnstore (
    s_i_id
  , s_w_id
  , s_quantity
  , s_order_cnt
);