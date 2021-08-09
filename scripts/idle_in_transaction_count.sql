select count(*)
from pg_catalog.pg_stat_activity
where 1=1
and state in ('idle in transaction', 'idle in transaction (aborted)');