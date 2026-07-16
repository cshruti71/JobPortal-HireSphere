-- Drop user first if they exist
DROP ROLE IF EXISTS jobportal;

-- Now create user with proper privileges
CREATE ROLE jobportal WITH LOGIN PASSWORD 'jobportal';

-- Create the database owned by the new role
CREATE DATABASE jobportal OWNER jobportal;

GRANT ALL PRIVILEGES ON DATABASE jobportal TO jobportal;
