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
