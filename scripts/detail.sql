with CTE1 as (
select datname, pid, wait_event, client_addr, query,backend_start,state,
extract(day
from
	NOW() - pg_stat_activity.query_start) days,
	extract(hour
from
	NOW() - pg_stat_activity.query_start) hours,
	extract(minute
from
	NOW() - pg_stat_activity.query_start) minutes
from
	pg_catalog.pg_stat_activity
)
select CONCAT((days::varchar), ' days') days,
CONCAT((hours::varchar), ' hours') hours,
CONCAT((minutes::varchar), ' minutes') minutes, datname, pid, wait_event, client_addr, query
from CTE1 as cte
where 1=1
and backend_start <= NOW() - INTERVAL '10 minutes'
and state in ('idle in transaction', 'idle in transaction (aborted)');
