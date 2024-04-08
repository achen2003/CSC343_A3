SET SEARCH_PATH TO A3Conference, public;

-- Number of submissions for each title
CREATE VIEW SubmissionCounts AS
    SELECT title, COUNT(*) AS submission_count
    FROM Submission
    GROUP BY title;

CREATE VIEW AcceptedSubmissionCounts AS
    SELECT title,
           COUNT(CASE WHEN decision = 'accept' THEN 1 ELSE 0 END) AS accepted_submission_count
    FROM Review r
    JOIN Submission s ON r.sub_id = s.sub_id 
    GROUP BY title;

-- Accepted submission that was submitted the most number of times before the acceptance
CREATE VIEW MostSubmittedBeforeAccepted AS
    SELECT Submission.sub_id, s.submission_count - COALESCE(a.accepted_submission_count, 0) AS submission_count_before_accept
    FROM SubmissionCounts s
    JOIN AcceptedSubmissionCounts a ON s.title = a.title
    JOIN Submission ON Submission.title = s.title
    -- LEFT JOIN AcceptedSubmissionCounts a ON Submission.sub_id = a.sub_id
    ORDER BY submission_count_before_accept DESC
    LIMIT 1;

-- Query for reporting the most submitted/re-submitted accepted submission
SELECT s.title AS submission_title,
       s.sub_id AS submission_id,
       a.auth_name AS first_author_name,
       m.submission_count_before_accept
FROM MostSubmittedBeforeAccepted m
JOIN Submission s ON m.sub_id = s.sub_id
JOIN Contributor c ON s.sub_id = c.sub_id AND c.auth_order = 1
JOIN Author a ON c.auth_id = a.auth_id;