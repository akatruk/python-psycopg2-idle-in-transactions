select CONCAT('db name: ',(datname::varchar)) ,
CONCAT('pid: ',(pid::varchar)),
CONCAT('source ip: ',(client_addr::varchar)) 
from pg_catalog.pg_stat_activity
where 1=1
and backend_start <= NOW() - INTERVAL '10 minutes'
and state in ('idle in transaction', 'idle in transaction (aborted)');
