select s.sid, s.serial#, s.username, p.name
from v$session s
join v$pdbs p on s.con_id = p.con_id
where s.type = 'USER';