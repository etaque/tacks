CREATE TABLE time_trials (
  id                UUID        NOT NULL PRIMARY KEY,
  track_id          UUID        NOT NULL,
  period            TEXT        NOT NULL,
  creation_time     TIMESTAMPTZ NOT NULL
);
