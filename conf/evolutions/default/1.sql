# --- !Ups

CREATE TABLE users (
  id                UUID        NOT NULL PRIMARY KEY,
  email             TEXT        NOT NULL,
  password          TEXT        NULL,
  handle            TEXT        NOT NULL,
  status            TEXT        NULL,
  vmg_magnet        INT         NULL,
  creation_time     TIMESTAMPTZ NOT NULL
);

CREATE TABLE tracks (
  id                UUID        NOT NULL PRIMARY KEY,
  name              TEXT        NOT NULL,
  creator_id        UUID        NOT NULL,
  course            JSONB       NOT NULL,
  status            TEXT        NOT NULL,
  creation_time     TIMESTAMPTZ NOT NULL,
  update_time       TEXT        NOT NULL
);

CREATE TABLE runs (
  id                UUID        NOT NULL PRIMARY KEY,
  track_id          UUID        NOT NULL,
  race_id           UUID        NOT NULL,
  player_id         UUID        NOT NULL,
  player_handle     UUID        NOT NULL,
  start_time        TIMESTAMPTZ NOT NULL,
  tally             BIGINT[]    NOT NULL,
  duration          BIGINT      NOT NULL
);

CREATE TABLE run_paths (
  id                UUID        NOT NULL PRIMARY KEY,
  run_id            UUID        NOT NULL,
  slices            JSONB       NOT NULL
);

# --- !Downs

DROP TABLE run_paths;
DROP TABLE runs;
DROP TABLE tracks;
DROP TABLE users;
