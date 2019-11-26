/* question 1. */
select count(*)
from doorlog
where doorid=1 and event='e';

/* question 2. */
select (select count(eventid)
        from doorlog where doorid=2 and event='e')
        -
       (select count(eventid)
        from doorlog where doorid=2 and event='x');

/* question 3. */
select (select count(eventid)
        from doorlog where event='e' and (doorid='1' or doorid='3'))
        -
       (select count(eventid)
        from doorlog where event='x' and (doorid='1' or doorid='3'))
        
/* question 4. */
with in_buildin0704 as (
    select username from doorlog
    where
        ((doorid=1 or doorid=3) and event='e')
        and tim <'2019-07-04 22:00:00'
    except
    select username from doorlog
    where
        ((doorid=1 or doorid=3) and event='x')
        and tim >'2019-07-04 22:00:00'
)
select count(*)
from in_building0704;

/* question 5. */
with perday as (
    select eventid from doorlog
    where
        (doorid=7 and event='e')
        and

/* question 6. */

/* question 7. */

/* question 8. */

/* question 9. */

/* question 10. */
select username
from doorlog
where event='x' and tim <'2017-07-03 13:00:00';
