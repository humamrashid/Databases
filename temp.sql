/* Question 1. */
SELECT COUNT(*)
FROM doorlog
WHERE doorid=1 AND event='E';

/* Question 2. */
WITH in_bathroom AS (
    SELECT eventid FROM doorlog WHERE doorid=2 AND event='E'
    MINUS
    SELECT eventid FROM doorlog WHERE doorid=2 AND event='X'
)
SELECT COUNT(*)
FROM in_bathroom;

/* Question 3. */
WITH in_building AS (
    SELECT eventid FROM doorlog
    WHERE (doorid=1 OR doorid=3) AND event='E'
    MINUS
    SELECT eventid FROM doorlog
    WHERE (doorid=1 OR doorid=3) AND event='X'
)
SELECT COUNT(*)
FROM in_building;

/* Question 4. */
WITH in_buildin0704 AS (
    SELECT eventid FROM doorlog
    WHERE
        ((doorid=1 OR doorid=3) AND event='E')
        AND tim <'2019-07-04 22:00:00'
    MINUS
    SELECT eventid FROM doorlog
    WHERE ((doorid=1 OR doorid=3) AND event='X')
        AND tim >='2019-07-04 22:00:01'
)
SELECT COUNT(*)
FROM in_building0704;
