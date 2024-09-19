CREATE CATALOG nessie_catalog WITH (
  'type'='iceberg',
  'catalog-impl'='org.apache.iceberg.nessie.NessieCatalog',
  'io-impl'='org.apache.iceberg.aws.s3.S3FileIO',
  'uri'='http://nessie:19120/api/v2',
  'warehouse' = 's3://warehouse',
  's3.endpoint'='http://minio:9000'
);

USE CATALOG nessie_catalog;

CREATE DATABASE IF NOT EXISTS `default`;

CREATE TABLE IF NOT EXISTS orders
(
   order_timestamp TIMESTAMP,
   order_date      STRING,
   id              BIGINT,
   customer_id     BIGINT
) PARTITIONED BY (order_date);

CREATE TABLE IF NOT EXISTS products
(
   id            BIGINT,
   name          STRING,
   product_category TINYINT,
   current_prise DECIMAL(15, 2)
);

CREATE TABLE IF NOT EXISTS order_items
(
   id         BIGINT,
   order_id   BIGINT,
   product_id BIGINT,
   quantity   BIGINT,
   unit_prise DECIMAL(15, 2)
);

CREATE TABLE IF NOT EXISTS product_orders_report
(
   report_id            BIGINT,
   report_timestamp     TIMESTAMP,
   report_year_month    STRING,
   product_id           BIGINT,
   product_quantity_sum BIGINT
) PARTITIONED BY (report_year_month);

INSERT INTO products (id, name, product_category, current_prise)
VALUES (1, 'Basic Widget', 0, 9.99),
      (2, 'Premium Widget', 1, 19.99),
      (3, 'Basic Gadget', 0, 14.99),
      (4, 'Premium Gadget', 1, 29.99),
      (5, 'Basic Tool', 0, 24.99),
      (6, 'Premium Tool', 1, 49.99);

INSERT INTO orders (order_timestamp, order_date, id, customer_id)
VALUES (TO_TIMESTAMP('2024-09-12 14:25:30'), '2024-09-12', 1001, 2001),
      (TO_TIMESTAMP('2024-09-12 15:10:45'), '2024-09-12', 1002, 2002),
      (TO_TIMESTAMP('2q024-09-13 09:20:10'), '2024-09-13', 1003, 2003),
      (TO_TIMESTAMP('2024-09-13 10:30:05'), '2024-09-13', 1004, 2004),
      (TO_TIMESTAMP('2024-09-13 12:15:22'), '2024-09-13', 1005, 2001),
      (TO_TIMESTAMP('2024-09-14 14:50:00'), '2024-09-14', 1006, 2002);

INSERT INTO order_items (id, order_id, product_id, quantity, unit_prise)
VALUES (10001, 1001, 1, 2, 9.99), -- Order 1001 contains 2 Basic Widgets
      (10002, 1001, 3, 1, 14.99), -- Order 1001 also contains 1 Basic Gadget
      (10003, 1002, 2, 1, 19.99), -- Order 1002 contains 1 Premium Widget
      (10004, 1003, 3, 3, 14.99), -- Order 1003 contains 3 Basic Gadgets
      (10005, 1004, 4, 1, 29.99), -- Order 1004 contains 1 Premium Gadget
      (10006, 1005, 5, 4, 24.99), -- Order 1005 contains 4 Basic Tools
      (10007, 1006, 6, 2, 49.99);
