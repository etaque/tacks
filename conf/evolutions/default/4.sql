# --- !Ups

ALTER TABLE tracks
ADD COLUMN featured BOOLEAN NOT NULL DEFAULT false;

# --- !Downs

ALTER TABLE tracks
DROP COLUMN featured;
