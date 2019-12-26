-- Humam Rashid
-- CISC 7510X, Fall 2019

-- CORRECTION: mistake in the last version.

-- Schema:
-- file(id int, parentid int, name varchar(1024), size int, type char(1));

with recursive recfiles (id, name) as (
    select id, '/' || name
    from file
    where parentid=0 -- Assuming 0 is root directory,
                     -- get names of all files and directories directly under
                     -- root.
    union all
    select id, b.name || '/' || a.name
    from files a join recfiles b
        inner join on a.parentid=b.id
    where b.type='D'
)
select *
from recfiles;

-- EOF.
