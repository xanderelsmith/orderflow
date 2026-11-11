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
CREATE TABLE "customer_orders" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "total" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR orderflow
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('orderflow', '20261111030606426', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261111030606426', "timestamp" = now();

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
