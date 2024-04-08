-- Number of submissions for each submission ID
CREATE VIEW SubmissionCounts AS
    SELECT sub_id, COUNT(*) AS submission_count
    FROM Submission
    GROUP BY sub_id;

-- Number of accepted submissions for each submission ID
CREATE VIEW AcceptedSubmissionCounts AS
    SELECT sub_id, COUNT(*) AS accepted_submission_count
    FROM Review
    WHERE decision = 'accept'
    GROUP BY sub_id;

-- Submissions with the most number of submissions before acceptance
CREATE VIEW MostSubmittedBeforeAccepted AS
    SELECT s.sub_id, s.submission_count - COALESCE(a.accepted_submission_count, 0) AS submission_count_before_accept
    FROM SubmissionCounts s
    LEFT JOIN AcceptedSubmissionCounts a ON s.sub_id = a.sub_id
    ORDER BY submission_count_before_accept DESC
    LIMIT 1;

-- Query for reporting the most submitted before accepted submission
SELECT s.title AS submission_title,
       s.sub_id AS submission_id,
       a.auth_name AS first_author_name,
       m.submission_count_before_accept AS submission_count_before_accept
FROM MostSubmittedBeforeAccepted m
JOIN Submission s ON m.sub_id = s.sub_id
JOIN Contributor c ON s.sub_id = c.sub_id AND c.auth_order = 1
JOIN Author a ON c.auth_id = a.auth_id;