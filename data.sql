SET SEARCH_PATH TO A3Conference;

\Copy Attendee FROM 'data/Attendee.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Author FROM 'data/Author.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Conference FROM 'data/Conference.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Submission FROM 'data/Submission.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Contributor FROM 'data/Contributor.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Reviewer FROM 'data/Reviewer.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Review FROM 'data/Review.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Session FROM 'data/Session.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Presentation FROM 'data/Presentation.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Registration FROM 'data/Registration.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Workshop FROM 'data/Workshop.csv' WITH CSV DELIMITER ',' HEADER;

\Copy WorkshopRegistration FROM 'data/WorkshopRegistration.csv' WITH CSV DELIMITER ',' HEADER;

-- \Copy Facilitator FROM 'data/Facilitator.csv' WITH CSV DELIMITER ',' HEADER;

\Copy Committee FROM 'data/Committee.csv' WITH CSV DELIMITER ',' HEADER;

\Copy CommitteeMember FROM 'data/CommitteeMember.csv' WITH CSV DELIMITER ',' HEADER;

\Copy ConferenceChairs FROM 'data/ConferenceChairs.csv' WITH CSV DELIMITER ',' HEADER;

