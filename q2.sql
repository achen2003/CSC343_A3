SET SEARCH_PATH TO A3Conference, public;

-- Query for reporting the number of conferences each person has attended
SELECT
    a.att_id,
    a.att_name,
    COUNT(DISTINCT r.conf_id) AS conference_count
FROM Attendee a
LEFT JOIN Registration r ON a.att_id = r.att_id
GROUP BY a.att_id, a.att_name;

