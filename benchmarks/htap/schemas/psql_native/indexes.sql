CREATE INDEX idx_customer ON customer (
    c_w_id
  , c_d_id
  , c_last
);

CREATE INDEX idx_orders ON orders (
    o_w_id
  , o_d_id
  , o_c_id
  , o_id
);

CREATE INDEX fkey_order_line ON order_line (
    ol_supply_w_id
  , ol_i_id
);

CREATE INDEX idx_customer_bogus ON customer (
    c_payment_cnt
);

CREATE INDEX idx_orders_bogus ON orders (
    o_all_local
);

CREATE INDEX idx_order_line_bogus ON order_line (
    ol_amount
);

CREATE INDEX idx_stock_bogus ON stock (
    s_ytd
);