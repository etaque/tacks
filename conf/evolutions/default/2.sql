# --- !Ups

CREATE UNIQUE INDEX users_email_idx ON users (email);
CREATE UNIQUE INDEX users_handle_idx ON users (handle);

# --- !Downs

DROP INDEX users_handle_idx;
DROP INDEX users_email_idx;
