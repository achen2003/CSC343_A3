SET SEARCH_PATH TO Library;

-- Import Data for Holding
COPY Author FROM 'data/Author.csv' WITH CSV DELIMITER ',' HEADER;

COPY Contributor FROM 'data/Contributor.csv' WITH CSV DELIMITER ',' HEADER;

COPY Submission FROM 'data/Submission.csv' WITH CSV DELIMITER ',' HEADER;

COPY Conference FROM 'data/Conference.csv' WITH CSV DELIMITER ',' HEADER;

COPY Reviewer FROM 'data/Reviewer.csv' WITH CSV DELIMITER ',' HEADER;

COPY Review FROM 'data/Review.csv' WITH CSV DELIMITER ',' HEADER;

COPY Session FROM 'data/Session.csv' WITH CSV DELIMITER ',' HEADER;

COPY Presentation FROM 'data/Presentation.csv' WITH CSV DELIMITER ',' HEADER;

COPY Registration FROM 'data/Registration.csv' WITH CSV DELIMITER ',' HEADER;

COPY Attendee FROM 'data/Attendee.csv' WITH CSV DELIMITER ',' HEADER;

COPY Workshop FROM 'data/Workshop.csv' WITH CSV DELIMITER ',' HEADER;

COPY Facilitator FROM 'data/Facilitator.csv' WITH CSV DELIMITER ',' HEADER;

COPY Committee FROM 'data/Committee.csv' WITH CSV DELIMITER ',' HEADER;

COPY ConferenceChairs FROM 'data/ConferenceChairs.csv' WITH CSV DELIMITER ',' HEADER;


