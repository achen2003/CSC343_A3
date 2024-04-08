SET SEARCH_PATH TO A3Conference, public;

-- -- Papers which have been accepted
-- CREATE VIEW AcceptedPapers AS 
--     SELECT
--         s.conf_id,
--         s.sub_id,
--         sao.auth_id AS first_author_id
--     FROM Submission s
--     INNER JOIN SubmissionAuthorOrder sao ON s.sub_id = sao.sub_id AND sao.author_order = 1
--     INNER JOIN Review r ON s.sub_id = r.sub_id
--     WHERE r.decision = 'accepted';

-- -- Conferences with the most accepted submissions
-- CREATE VIEW ConferenceTopAccepted AS
--     SELECT conf_id,
--         COUNT(sub_id) AS total_accepted_papers
--     FROM AcceptedPapers
--     GROUP BY conf_id
--     ORDER BY total_accepted_papers DESC
--     LIMIT 1;

-- -- Query for reporting the first authors of papers from conferences with the most number of accepted papers
-- SELECT
--     c.conf_id,
--     c.cname AS conference_name,
--     a.auth_id AS first_author_id,
--     a.auth_name AS first_author_name
-- FROM AcceptedPapers ap
-- INNER JOIN Author a ON ap.first_author_id = a.auth_id
-- INNER JOIN ConferenceTopAccepted cta ON ap.conf_id = cta.conf_id
-- INNER JOIN Conference c ON ap.conf_id = c.conf_id;

-- -- Papers which have been accepted
CREATE VIEW AcceptedPapers AS 
    SELECT c.cname AS conference_name, s.sub_id, cma.auth_id AS first_author_id
    FROM Conference c
    JOIN Submission s ON c.conf_id = s.conf_id
    JOIN Review r ON s.sub_id = r.sub_id
    JOIN Contributor cma ON s.sub_id = cma.sub_id
    WHERE r.decision = 'accept' AND cma.auth_order = 1;

CREATE VIEW TotalAcceptedPapers AS 
    SELECT conference_name, COUNT(*) AS total_accepted_papers
    FROM AcceptedPapers
    GROUP BY conference_name;

-- -- Conferences with the most accepted submissions
CREATE VIEW ConferenceWithMostAcceptedPapers AS 
    SELECT conference_name
    FROM TotalAcceptedPapers
    ORDER BY total_accepted_papers DESC
    LIMIT 1;

-- Query for reporting the first authors of papers from conferences with the most number of accepted papers
SELECT cwmap.conference_name, ap.first_author_id, a.auth_name AS first_author_name
FROM ConferenceWithMostAcceptedPapers cwmap
JOIN AcceptedPapers ap ON cwmap.conference_name = ap.conference_name
JOIN Author a ON ap.first_author_id = a.auth_id;