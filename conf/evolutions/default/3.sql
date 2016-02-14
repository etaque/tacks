# --- !Ups

CREATE TABLE forum_topics (
  id                UUID        NOT NULL PRIMARY KEY,
  title             TEXT        NOT NULL,
  post_id           UUID        NULL
);

CREATE TABLE forum_posts (
  id                UUID        NOT NULL PRIMARY KEY,
  topic_id          UUID        NOT NULL REFERENCES forum_topics(id),
  user_id           UUID        NOT NULL REFERENCES users(id),
  content           TEXT        NOT NULL,
  creation_time     TIMESTAMPTZ NOT NULL,
  update_time       TIMESTAMPTZ NOT NULL
);

ALTER TABLE forum_topics
ADD FOREIGN KEY(post_id) REFERENCES forum_posts(id);


# --- !Downs

ALTER TABLE forum_topics
DROP CONSTRAINT forum_topics_post_id_fk;

DROP TABLE forum_posts;

DROP TABLE forum_topics;
