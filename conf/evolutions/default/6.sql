
# --- !Ups

ALTER TABLE runs
ADD COLUMN is_time_trial BOOLEAN DEFAULT false;


# --- !Downs

ALTER TABLE runs
REMOVE COLUMN is_time_trial;
