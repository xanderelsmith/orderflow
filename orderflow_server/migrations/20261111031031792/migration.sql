BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_users" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "isActive" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_items" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "sku" text NOT NULL,
    "quantity" bigint NOT NULL,
    "unitPrice" double precision NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_records" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "itemCount" bigint NOT NULL,
    "totalPrice" double precision NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payment_records" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "amount" double precision NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR orderflow
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('orderflow', '20261111031031792', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261111031031792', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
