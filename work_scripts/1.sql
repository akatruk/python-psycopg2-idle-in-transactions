begin transaction;

INSERT INTO public.stats
(stat_repository_type, stat_repository_id, stat_holder_type, stat_holder_id, stat_coverage_type, stat_coverage_id, context)
VALUES('', 0, '', 0, '', 0, '');

delete from public.stats where id >= '1000';

select * from stats
where stat_repository_type = 'test'

rollback