with CTE1 as ( with recursive l as (
select
	pid,
	locktype,
	mode,
	granted,
	row(locktype,
	database,
	relation,
	page,
	tuple,
	virtualxid,
	transactionid,
	classid,
	objid,
	objsubid) obj
from
	pg_locks ),
pairs as (
select
	w.pid waiter,
	l.pid locker,
	l.obj,
	l.mode
from
	l w
join l on
	l.obj is not distinct
from
	w.obj
	and l.locktype = w.locktype
	and not l.pid = w.pid
	and l.granted
where
	not w.granted ),
tree as (
select
	l.locker pid,
	l.locker root,
	null::record obj,
	null as mode,
	0 lvl,
	locker::text path,
	array_agg(l.locker) over () all_pids
from
	(
	select
		distinct locker
	from
		pairs l
	where
		not exists (
		select
			1
		from
			pairs
		where
			waiter = l.locker) ) l
union all
select
	w.waiter pid,
	tree.root,
	w.obj,
	w.mode,
	tree.lvl + 1,
	tree.path || '.' || w.waiter,
	all_pids || array_agg(w.waiter) over ()
from
	tree
join pairs w on
	tree.pid = w.locker
	and not w.waiter = any (all_pids) )
select
	(clock_timestamp() - a.xact_start)::interval(3) as ts_age,
	replace(a.state, 'idle in transaction', 'idletx') state,
	(clock_timestamp() - state_change)::interval(3) as change_age,
	a.datname,
	tree.pid,
	a.usename,
	a.client_addr,
	a.backend_start,
	lvl,
	(
	select
		count(*)
	from
		tree p
	where
		p.path ~ ('^' || tree.path)
			and not p.path = tree.path) blocked,
	repeat(' .', lvl)|| ' ' || left(regexp_replace(query, 's+', ' ', 'g'), 100) query
from
	tree
join pg_stat_activity a
		using (pid)
order by
	path)
select
	CONCAT('select pg_terminate_backend(',(pid::integer), ');')
from
	CTE1;