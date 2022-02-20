CREATE USER "test-admin-user";
CREATE DATABASE "test_db";

CREATE TABLE orders (
    id          serial primary key,
    "наименование" text NOT NULL,
    "цена"         integer NOT NULL
);

CREATE TABLE clients (
    id          serial primary key,
    "фамилия" text NOT NULL,
    "страна проживания" text,
    "заказ" integer ,
    FOREIGN KEY ("заказ") REFERENCES orders (id)
);

CREATE INDEX country on clients ("страна проживания");

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";

CREATE USER "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "test-simple-user";

