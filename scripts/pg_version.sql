with cte1 as (
select 
	version() t1)
select
	left(t1, 15)
from
	cte1;