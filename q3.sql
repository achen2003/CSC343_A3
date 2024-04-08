SET SEARCH_PATH TO A3Conference, public;

-- Papers which have been accepted
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

-- Conferences with the most accepted submissions
CREATE VIEW ConferenceWithMostAcceptedPapers AS 
    SELECT conference_name
    FROM TotalAcceptedPapers
    ORDER BY total_accepted_papers DESC
    LIMIT 1;

-- Query for reporting the first authors of papers from conferences with the most number of accepted papers
SELECT DISTINCT ON (cwmap.conference_name, ap.first_author_id)
    cwmap.conference_name,
    ap.first_author_id,
    a.auth_name AS author_name
FROM ConferenceWithMostAcceptedPapers cwmap
JOIN AcceptedPapers ap ON cwmap.conference_name = ap.conference_name
JOIN Author a ON ap.first_author_id = a.auth_id;