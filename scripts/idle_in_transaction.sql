-- All connections with ducation more that 10 min
-- idle in transactions only and idle in transaction (aborted)

select CONCAT('select pg_terminate_backend(',(pid::integer),');') 
from pg_catalog.pg_stat_activity
where 1=1
and state in ('idle in transaction', 'idle in transaction (aborted)');