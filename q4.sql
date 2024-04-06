SET SEARCH_PATH TO A3Conference, public;

-- Number of submissions for each submission ID
CREATE VIEW SubmissionCount AS
    SELECT sub_id, COUNT(*) AS submission_count
    FROM Submission
    GROUP BY sub_id;

-- Accepted submissions
CREATE VIEW AcceptedSubmissions AS
    SELECT sub_id
    FROM Review
    WHERE decision = 'accepted';

-- Accepted submission that was submitted the most number of times
CREATE VIEW MostSubmittedAcceptedSubmission AS
    SELECT s.sub_id, s.submission_count
    FROM SubmissionCount s
    JOIN AcceptedSubmissions a ON s.sub_id = a.sub_id
    ORDER BY s.submission_count DESC
    LIMIT 1;

-- Query for reporting the most submitted/re-submitted accepted submission
SELECT s.title AS submission_title,
       s.sub_id AS submission_id,
       m.submission_count AS submission_count,
       a.auth_name AS first_author_name
FROM MostSubmittedAcceptedSubmission m
JOIN Submission s ON m.sub_id = s.sub_id
JOIN SubmissionAuthorOrder sao ON s.sub_id = sao.sub_id AND sao.author_order = 1
JOIN Author a ON sao.auth_id = a.auth_id;