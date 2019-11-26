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
where (doorid=7 and (event='E' or event='X') ) and tim between '2017-01-01'

-- question 6.

-- question 7.

-- question 8.

-- question 9.

-- question 10.
select username
from doorlog
where event='X' and tim <'2017-07-03 13:00:00';
