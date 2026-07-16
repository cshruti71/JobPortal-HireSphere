-- Run this connected to the "jobportal" database (created in 00-create-user.sql)

DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS job_seeker_apply;
DROP TABLE IF EXISTS job_seeker_save;
DROP TABLE IF EXISTS job_post_activity;
DROP TABLE IF EXISTS recruiter_profile;
DROP TABLE IF EXISTS job_seeker_profile;
DROP TABLE IF EXISTS job_location;
DROP TABLE IF EXISTS job_company;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS users_type;

CREATE TABLE users_type (
  user_type_id SERIAL PRIMARY KEY,
  user_type_name varchar(255) DEFAULT NULL
);

INSERT INTO users_type (user_type_id, user_type_name) VALUES (1,'Recruiter'),(2,'Job Seeker');
SELECT setval('users_type_user_type_id_seq', 3, false);

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  email varchar(255) DEFAULT NULL UNIQUE,
  is_active boolean DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  registration_date timestamp(6) DEFAULT NULL,
  user_type_id int DEFAULT NULL,
  CONSTRAINT fk_users_user_type FOREIGN KEY (user_type_id) REFERENCES users_type (user_type_id)
);

CREATE TABLE job_company (
  id SERIAL PRIMARY KEY,
  logo varchar(255) DEFAULT NULL,
  name varchar(255) DEFAULT NULL
);

CREATE TABLE job_location (
  id SERIAL PRIMARY KEY,
  city varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  state varchar(255) DEFAULT NULL
);

CREATE TABLE job_seeker_profile (
  user_account_id int PRIMARY KEY,
  city varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  employment_type varchar(255) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  profile_photo varchar(255) DEFAULT NULL,
  resume varchar(255) DEFAULT NULL,
  state varchar(255) DEFAULT NULL,
  work_authorization varchar(255) DEFAULT NULL,
  CONSTRAINT fk_job_seeker_profile_user FOREIGN KEY (user_account_id) REFERENCES users (user_id)
);

CREATE TABLE recruiter_profile (
  user_account_id int PRIMARY KEY,
  city varchar(255) DEFAULT NULL,
  company varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  profile_photo varchar(64) DEFAULT NULL,
  state varchar(255) DEFAULT NULL,
  CONSTRAINT fk_recruiter_profile_user FOREIGN KEY (user_account_id) REFERENCES users (user_id)
);

CREATE TABLE job_post_activity (
  job_post_id SERIAL PRIMARY KEY,
  description_of_job varchar(10000) DEFAULT NULL,
  job_title varchar(255) DEFAULT NULL,
  job_type varchar(255) DEFAULT NULL,
  posted_date timestamp(6) DEFAULT NULL,
  remote varchar(255) DEFAULT NULL,
  salary varchar(255) DEFAULT NULL,
  job_company_id int DEFAULT NULL,
  job_location_id int DEFAULT NULL,
  posted_by_id int DEFAULT NULL,
  CONSTRAINT fk_job_post_company FOREIGN KEY (job_company_id) REFERENCES job_company (id),
  CONSTRAINT fk_job_post_location FOREIGN KEY (job_location_id) REFERENCES job_location (id),
  CONSTRAINT fk_job_post_posted_by FOREIGN KEY (posted_by_id) REFERENCES users (user_id)
);

CREATE TABLE job_seeker_save (
  id SERIAL PRIMARY KEY,
  job int DEFAULT NULL,
  user_id int DEFAULT NULL,
  CONSTRAINT uk_job_seeker_save UNIQUE (user_id, job),
  CONSTRAINT fk_job_seeker_save_user FOREIGN KEY (user_id) REFERENCES job_seeker_profile (user_account_id),
  CONSTRAINT fk_job_seeker_save_job FOREIGN KEY (job) REFERENCES job_post_activity (job_post_id)
);

CREATE TABLE job_seeker_apply (
  id SERIAL PRIMARY KEY,
  apply_date timestamp(6) DEFAULT NULL,
  cover_letter varchar(255) DEFAULT NULL,
  job int DEFAULT NULL,
  user_id int DEFAULT NULL,
  CONSTRAINT uk_job_seeker_apply UNIQUE (user_id, job),
  CONSTRAINT fk_job_seeker_apply_job FOREIGN KEY (job) REFERENCES job_post_activity (job_post_id),
  CONSTRAINT fk_job_seeker_apply_user FOREIGN KEY (user_id) REFERENCES job_seeker_profile (user_account_id)
);

CREATE TABLE skills (
  id SERIAL PRIMARY KEY,
  experience_level varchar(255) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  years_of_experience varchar(255) DEFAULT NULL,
  job_seeker_profile int DEFAULT NULL,
  CONSTRAINT fk_skills_job_seeker_profile FOREIGN KEY (job_seeker_profile) REFERENCES job_seeker_profile (user_account_id)
);
