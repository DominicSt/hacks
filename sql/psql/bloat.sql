# Find all tables and when they were last vacuumed/analyzed, either manually or automatically
SELECT relname, 
       last_vacuum, 
       last_autovacuum, 
       last_analyze, 
       last_autoanalyze 
FROM   pg_stat_all_tables 
WHERE  schemaname = 'public' 
ORDER  BY last_vacuum DESC;

# Find any running processes that are doing autovacuum and which tables they're working on
SELECT   pid, 
         Age(query_start, Clock_timestamp()), 
         usename, 
         query 
FROM     pg_stat_activity 
WHERE    query != '<IDLE>' 
AND      query ilike '%vacuum%' 
ORDER BY query_start ASC;

# Find table/index sizes for all tables in a schema
SELECT *, 
       Pg_size_pretty(total_bytes) AS total, 
       Pg_size_pretty(index_bytes) AS INDEX, 
       Pg_size_pretty(toast_bytes) AS toast, 
       Pg_size_pretty(table_bytes) AS TABLE 
FROM   (SELECT *, 
               total_bytes - index_bytes - Coalesce(toast_bytes, 0) AS 
               table_bytes 
        FROM   (SELECT c.oid, 
                       nspname                               AS table_schema, 
                       relname                               AS TABLE_NAME, 
                       c.reltuples                           AS row_estimate, 
                       Pg_total_relation_size(c.oid)         AS total_bytes, 
                       Pg_indexes_size(c.oid)                AS index_bytes, 
                       Pg_total_relation_size(reltoastrelid) AS toast_bytes 
                FROM   pg_class c 
                       LEFT JOIN pg_namespace n 
                              ON n.oid = c.relnamespace 
                WHERE  relkind = 'r') a 
        WHERE  table_schema = 'public' 
        ORDER  BY total_bytes DESC) a; 
