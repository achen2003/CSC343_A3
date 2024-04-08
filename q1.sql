SET SEARCH_PATH TO A3Conference, public;

-- Query for reporting the percentage of accepted submissions for every year each conference has been run
<<<<<<< Updated upstream
-- SELECT
--     c.conf_id,
--     EXTRACT(YEAR FROM c.cstart_date) AS conference_year,
--     COUNT(DISTINCT s.sub_id) AS total_submissions,
--     COUNT(DISTINCT CASE WHEN r.decision = 'accepted' THEN s.sub_id END) AS accepted_submissions,
--     ROUND(
--         100.0 * COUNT(DISTINCT CASE WHEN r.decision = 'accepted' THEN s.sub_id END) /
--         COUNT(DISTINCT s.sub_id),
--         2
--     ) AS acceptance_percentage
-- FROM Conference c
-- LEFT JOIN Submission s ON c.conf_id = s.conf_id
-- LEFT JOIN Review r ON s.sub_id = r.sub_id
-- GROUP BY c.conf_id, EXTRACT(YEAR FROM c.cstart_date)
-- ORDER BY c.conf_id, conference_year;

SELECT 
    c.cname AS conference_name,
    EXTRACT(YEAR FROM c.cstart_date) AS submission_year,
    CASE 
        WHEN COUNT(*) = 0 THEN 0 
        ELSE ROUND(
            100.0 * SUM(CASE WHEN r.decision = 'accept' THEN 1 ELSE 0 END) / COUNT(*),
            2
        ) 
    END AS acceptance_percentage
FROM Conference c
LEFT JOIN Submission s ON c.conf_id = s.conf_id
LEFT JOIN Review r ON s.sub_id = r.sub_id
GROUP BY c.cname, submission_year
ORDER BY c.cname, submission_year;