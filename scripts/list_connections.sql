select
	state,
 case
		when count(state) = 1 then CONCAT(count(state)::integer, ' ', 'connection')
		else CONCAT(count(state)::integer, ' ', 'connections')
	end
from
	pg_catalog.pg_stat_activity
where
	state is not null
group by
	state;