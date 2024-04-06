SET SEARCH_PATH TO A3Conference, public;

-- Query for reporting the percentage of accepted submissions for every year each conference has been run
SELECT
    c.conf_id,
    EXTRACT(YEAR FROM c.cstart_date) AS conference_year,
    COUNT(DISTINCT s.sub_id) AS total_submissions,
    COUNT(DISTINCT CASE WHEN r.decision = 'accepted' THEN s.sub_id END) AS accepted_submissions,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN r.decision = 'accepted' THEN s.sub_id END) /
        COUNT(DISTINCT s.sub_id),
        2
    ) AS acceptance_percentage
FROM Conference c
LEFT JOIN Submission s ON c.conf_id = s.conf_id
LEFT JOIN Review r ON s.sub_id = r.sub_id
GROUP BY c.conf_id, EXTRACT(YEAR FROM c.cstart_date)
ORDER BY c.conf_id, conference_year;
