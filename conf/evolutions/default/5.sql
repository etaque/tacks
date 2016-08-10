
# --- !Ups

CREATE TABLE time_trials (
  id                UUID        NOT NULL PRIMARY KEY,
  track_id          UUID        NOT NULL,
  period            TEXT        NOT NULL,
  creation_time     TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX time_trials_period_idx ON time_trials (period);


# --- !Downs

DROP TABLE time_trials;
