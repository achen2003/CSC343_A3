SET SEARCH_PATH TO A3Conference, public;

-- Number of submissions for each submission ID that were accepted
CREATE VIEW SubmissionCounts AS
    SELECT sub_id, COUNT(*) AS submission_count
    FROM Submission
    GROUP BY sub_id;

CREATE VIEW AcceptedSubmissions AS
    SELECT sub_id
    FROM Review
    WHERE decision = 'accept';

-- Accepted submission that was submitted the most number of times before the acceptance
CREATE VIEW MostSubmittedBeforeAccepted AS
    SELECT s.sub_id, s.submission_count
    FROM SubmissionCounts s
    JOIN AcceptedSubmissions a ON s.sub_id = a.sub_id
    ORDER BY s.submission_count DESC
    LIMIT 1;

-- Query for reporting the most submitted/re-submitted accepted submission
SELECT s.title AS submission_title,
       s.sub_id AS submission_id,
       a.auth_name AS first_author_name,
       m.submission_count AS submission_count
FROM MostSubmittedBeforeAccepted m
JOIN Submission s ON m.sub_id = s.sub_id
JOIN Contributor c ON s.sub_id = c.sub_id AND c.auth_order = 1
JOIN Author a ON c.auth_id = a.auth_id;