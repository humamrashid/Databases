-- Humam Rashid
-- CISC 7510X, Fall 2019

-- Schema:
-- doorlog(eventid,doorid,tim,username,event)

-- question 1.
select count(*)
from doorlog
where doorid=1 and event='E';

-- question 2.
select (select count(eventid)
        from doorlog
        where doorid=2 and event='E')
        -
       (select count(eventid)
        from doorlog
        where doorid=2 and event='X');

-- question 3.
select (select count(eventid)
        from doorlog
        where event='E' and (doorid='1' or doorid='3'))
        -
       (select count(eventid)
        from doorlog
        where event='X' and (doorid='1' or doorid='3'))
        
-- question 4.
with in_build0704 as (
    select username
    from doorlog
    where
        ((doorid=1 or doorid=3) and event='E')
        and tim <'2019-07-04 22:00:00'
)
with out_build0704 as (
    select username
    from doorlog
    where
        ((doorid=1 or doorid=3) and event='X')
        and tim >'2019-07-04 22:00:00'
)
select count(username)
from in_build0704 a
    left outer join out_build0704 b
    on a.username=b.username;

-- question 5.
select count(eventid) over (partition by tdate order by tdate)
from doorlog
where (doorid=7 and (event='E' or event='X'))
    and tim between '2017-01-01' and '2017-12-31';

-- question 6.
select
    avg(count(eventid)) over (partition by tdate order by tdate),
    stddev(count(eventid)) over (partition by tdate order by tdate)
from doorlog
where (doorid=7 and (event='E' or event='X'))
    and tim between '2017-01-01' and '2017-12-31';

-- question 7.

-- question 8.

-- question 9.

-- question 10.
with leftearly as (
    select username
    from doorlog
    where event='X'
        and (tim >'2017-07-03 00:00:00' and tim <'2017-07-03 13:00:00')
)
select username
from leftearly
group by username
having count(*)=1;

-- EOF.