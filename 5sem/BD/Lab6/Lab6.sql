-- 6
-- Без роли restricted session не работает (в Oracle Net Manager),
-- это код из 3 лабы 9 задание,
-- просто запустите его еще раз, но для своего юзера
grant 
    connect, 
    create session,
    restricted session, -- нужно будет для 6 лабы
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##TDS container = all;
 
-- При работе в sqlplus, у меня не видит данные в таблице, когда я вставляю
-- данные (возможно я просто нахожусь в разных сессиях). Я просто создал таблицу
-- через sqlplus и внес данные, и вывел её) !!!Обязательно сделайте commit!!!

-- 10
select * from dba_segments where owner = 'C##TDS';

-- 11
create or replace view segment_summary as
select
    owner,
    segment_type,
    count(*) as segment_count,
    sum(extents) as total_extents,
    sum(blocks) as total_blocks,
    sum(bytes) / 1024 as total_size_kb
from
    dba_segments
group by
    owner,
    segment_type;
    
select * from segment_summary;