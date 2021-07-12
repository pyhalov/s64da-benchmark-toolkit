CREATE INDEX idx_customer_cache1 ON customer USING BRIN (c_id);
CREATE INDEX idx_customer_cache2 ON customer USING BRIN (c_d_id);
CREATE INDEX idx_customer_cache3 ON customer USING BRIN (c_w_id);
CREATE INDEX idx_customer_cache4 ON customer USING BRIN (c_nationkey);
CREATE INDEX idx_customer_cache5 ON customer USING BRIN (c_last);
CREATE INDEX idx_customer_cache6 ON customer USING BRIN (c_city);
CREATE INDEX idx_customer_cache7 ON customer USING BRIN (c_phone);
CREATE INDEX idx_customer_cache8 ON customer USING BRIN (c_state);
CREATE INDEX idx_customer_cache9 ON customer USING BRIN (c_balance);

CREATE INDEX idx_orders_cache1 ON orders USING BRIN (o_id);
CREATE INDEX idx_orders_cache2 ON orders USING BRIN (o_d_id);
CREATE INDEX idx_orders_cache3 ON orders USING BRIN (o_w_id);
CREATE INDEX idx_orders_cache4 ON orders USING BRIN (o_c_id);
CREATE INDEX idx_orders_cache5 ON orders USING BRIN (o_entry_d);
CREATE INDEX idx_orders_cache6 ON orders USING BRIN (o_carrier_id);
CREATE INDEX idx_orders_cache7 ON orders USING BRIN (o_ol_cnt);
CREATE INDEX idx_orders_cache8 ON orders USING BRIN (o_all_local);

CREATE INDEX idx_order_line_cache1 ON order_line USING BRIN (ol_o_id);
CREATE INDEX idx_order_line_cache2 ON order_line USING BRIN (ol_d_id);
CREATE INDEX idx_order_line_cache3 ON order_line USING BRIN (ol_w_id);
CREATE INDEX idx_order_line_cache4 ON order_line USING BRIN (ol_number);
CREATE INDEX idx_order_line_cache5 ON order_line USING BRIN (ol_i_id);
CREATE INDEX idx_order_line_cache6 ON order_line USING BRIN (ol_supply_w_id);
CREATE INDEX idx_order_line_cache7 ON order_line USING BRIN (ol_delivery_d);
CREATE INDEX idx_order_line_cache8 ON order_line USING BRIN (ol_quantity);
CREATE INDEX idx_order_line_cache9 ON order_line USING BRIN (ol_amount);

CREATE INDEX idx_stock_cache1 ON stock USING BRIN (s_i_id);
CREATE INDEX idx_stock_cache2 ON stock USING BRIN (s_w_id);
CREATE INDEX idx_stock_cache3 ON stock USING BRIN (s_quantity);
CREATE INDEX idx_stock_cache4 ON stock USING BRIN (s_order_cnt);