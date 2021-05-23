select CONCAT('pid ID: ',(pid::varchar)), query 
from pg_catalog.pg_stat_activity
where 1=1
and backend_start <= NOW() - INTERVAL '10 minutes'
and state in ('idle in transaction', 'idle in transaction (aborted)');
