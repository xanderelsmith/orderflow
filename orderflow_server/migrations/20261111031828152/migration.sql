BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ledger_entry" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "amount" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_account" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "hashedPassword" text NOT NULL,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    "isActive" boolean NOT NULL
);


--
-- MIGRATION VERSION FOR orderflow
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('orderflow', '20261111031828152', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261111031828152', "timestamp" = now();

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
