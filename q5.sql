SET SEARCH_PATH TO A3Conference, public;

-- Average number of papers in a paper session for each conference
CREATE VIEW AvgPapersPerPaperSession AS
    SELECT s.conf_id, 
           AVG(papers_count) AS avg_papers_per_session
    FROM (
        SELECT s.sess_id, COUNT(p.pres_id) AS papers_count
        FROM Session s
        JOIN Presentation p ON s.sess_id = p.sess_id
        WHERE s.sess_type = 'paper session'
        GROUP BY s.sess_id
    ) AS sub_query
    JOIN Session s ON sub_query.sess_id = s.sess_id
    GROUP BY s.conf_id;

-- Average number of posters in a poster session for each conference
CREATE VIEW AvgPostersPerPosterSession AS
    SELECT s.conf_id, 
           AVG(posters_count) AS avg_posters_per_session
    FROM (
        SELECT s.sess_id, COUNT(p.pres_id) AS posters_count
        FROM Session s
        JOIN Presentation p ON s.sess_id = p.sess_id
        WHERE s.sess_type = 'poster session'
        GROUP BY s.sess_id
    ) AS sub_query
    JOIN Session s ON sub_query.sess_id = s.sess_id
    GROUP BY s.conf_id;

-- Query to report the average number of papers in a paper session and the average number of posters in a poster session for each occurrence of a conference
SELECT c.conf_id,
       c.cname AS conference_name,
       COALESCE(p.avg_papers_per_session, 0) AS avg_papers_per_paper_session,
       COALESCE(pp.avg_posters_per_session, 0) AS avg_posters_per_poster_session
FROM Conference c
LEFT JOIN AvgPapersPerPaperSession p ON c.conf_id = p.conf_id
LEFT JOIN AvgPostersPerPosterSession pp ON c.conf_id = pp.conf_id;