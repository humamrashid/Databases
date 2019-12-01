-- Humam Rashid
-- CISC 7510X, Fall 2019

-- Schema:
-- file(id int, parentid int, name varchar(1024), size int, type char(1));

with recursive recfiles (id, name) as (
    select id, '/' || name
    from file
    where parentid=0 -- Assuming 0 is root directory,
                     -- get names of all files and directories.
    union all
    select id, b.name || a.name
    from recfiles b join file a
    where a.parentid=b.id
)
select name || 
from recfiles
where id=1
union all
select 

-- EOF.
