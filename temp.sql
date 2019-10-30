/* Question 1. */
SELECT COUNT(*)
FROM doorlog
WHERE doorid=1 AND event='E';

/* Question 2. */
SELECT (SELECT COUNT(eventid)
        FROM doorlog WHERE doorid=2 AND event='E')
        -
       (SELECT COUNT(eventid)
        FROM doorlog WHERE doorid=2 AND event='X');

/* Question 3. */
SELECT (SELECT COUNT(eventid)
        FROM doorlog WHERE event='E' AND (doorid='1' OR doorid='3'))
        -
       (SELECT COUNT(eventid)
        FROM doorlog WHERE event='X' AND (doorid='1' OR doorid='3'))
        
/* Question 4. */
WITH in_buildin0704 AS (
    SELECT username FROM doorlog
    WHERE
        ((doorid=1 OR doorid=3) AND event='E')
        AND tim <'2019-07-04 22:00:00'
    EXCEPT
    SELECT username FROM doorlog
    WHERE
        ((doorid=1 OR doorid=3) AND event='X')
        AND tim >'2019-07-04 22:00:00'
)
SELECT COUNT(*)
FROM in_building0704;

/* Question 5. */
WITH perday AS (
    SELECT eventid FROM doorlog
    WHERE
        (doorid=7 AND event='E')
        AND

/* Question 6. */

/* Question 7. */

/* Question 8. */

/* Question 9. */

/* Question 10. */
SELECT username
FROM doorlog
WHERE event='X' AND tim <'2017-07-03 13:00:00';
