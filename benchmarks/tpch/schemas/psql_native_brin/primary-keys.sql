create table lineitem_ordered as select * from lineitem order by date_trunc('month', l_shipdate), trunc(l_discount::numeric, 2), l_quantity;
create table orders_ordered as select * from orders order by date_trunc('month', o_orderdate), o_totalprice;
create table customer_ordered as select * from customer order by c_nationkey, c_custkey;
create table partsupp_ordered as select * from partsupp order by ps_partkey/10000, ps_suppkey/10000;
create table supplier_ordered as select * from supplier order by s_suppkey/10000;
create table part_ordered as select * from part order by p_partkey/10000;

drop table lineitem, orders, customer, partsupp, supplier, part;

alter table lineitem_ordered rename to lineitem;
alter table orders_ordered rename to orders;
alter table customer_ordered rename to customer;
alter table partsupp_ordered rename to partsupp;
alter table supplier_ordered rename to supplier;
alter table part_ordered rename to part;

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pk PRIMARY KEY (c_custkey);
ALTER TABLE ONLY lineitem
    ADD CONSTRAINT lineitem_pk PRIMARY KEY (l_linenumber, l_orderkey);
ALTER TABLE ONLY nation
    ADD CONSTRAINT nation_pk PRIMARY KEY (n_nationkey);
ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pk PRIMARY KEY (o_orderkey);
ALTER TABLE ONLY part
    ADD CONSTRAINT part_pk PRIMARY KEY (p_partkey);
ALTER TABLE ONLY partsupp
    ADD CONSTRAINT partsupp_pk PRIMARY KEY (ps_partkey, ps_suppkey);
ALTER TABLE ONLY region
    ADD CONSTRAINT region_pk PRIMARY KEY (r_regionkey);
ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_pk PRIMARY KEY (s_suppkey);
