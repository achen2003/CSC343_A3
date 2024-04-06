SET SEARCH_PATH TO A3Conference, public;

-- Papers which have been accepted
CREATE VIEW AcceptedPapers AS 
    SELECT
        s.conf_id,
        s.sub_id,
        sao.auth_id AS first_author_id
    FROM Submission s
    INNER JOIN SubmissionAuthorOrder sao ON s.sub_id = sao.sub_id AND sao.author_order = 1
    INNER JOIN Review r ON s.sub_id = r.sub_id
    WHERE r.decision = 'accepted';

-- Conferences with the most accepted submissions
CREATE VIEW ConferenceTopAccepted AS
    SELECT conf_id,
        COUNT(sub_id) AS total_accepted_papers
    FROM AcceptedPapers
    GROUP BY conf_id
    ORDER BY total_accepted_papers DESC
    LIMIT 1;

-- Query for reporting the first authors of papers from conferences with the most number of accepted papers
SELECT
    c.conf_id,
    c.cname AS conference_name,
    a.auth_id AS first_author_id,
    a.auth_name AS first_author_name
FROM AcceptedPapers ap
INNER JOIN Author a ON ap.first_author_id = a.auth_id
INNER JOIN ConferenceTopAccepted cta ON ap.conf_id = cta.conf_id
INNER JOIN Conference c ON ap.conf_id = c.conf_id;