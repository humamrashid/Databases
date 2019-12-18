-- Humam Rashid
-- CISC 7510X, Fall 2019

-- First step:
-- My computer couldn't handle the large dataset after repeated attempts so I
-- limited the dataset to daily percentages for companies dealing in at least 1
-- billion over December 2013. This is the table daily_prcnt_1b. On a better
-- equipped machince just changing the value to 10 million should achieve better
-- results (assuming my code is correct of course).
create table DAILY_PRCNT_1B as
    with DATA as (
        select
            a.TDATE,
            a.SYMBOL,
            a.CLOSE,
            lag(a.CLOSE) over (partition by a.SYMBOL order by a.TDATE)
                LAST_CLOSE,
            coalesce (PRE, 1) PRE,
            coalesce (POST, 1) POST,
            coalesce (AMOUNT, 0) DIV
        from CTSTAB a
            left outer join DIVTAB b
                on a.TDATE = b.TDATE and a.SYMBOL = b.SYMBOL
            left outer join SPLITSTAB c
                on a.TDATE = c.TDATE and a.SYMBOL = c.SYMBOL
        where (a.CLOSE*a.VOLUME)>=1000000000
            and
            (a.TDATE between '2013-12-01' and '2013-12-31')
    )
    select
        TDATE,
        SYMBOL,
        (case when ((LAST_CLOSE-DIV)*(PRE/POST::float))=0 then null else
            ((CLOSE/((LAST_CLOSE-DIV)*(PRE/POST::float)))-1) end) * 100.0
            AS DAILY_PRCNT
    from DATA
    order by TDATE;


-- Second step, getting the correlation, numbers are really off for the
-- coefficients it seems but some of the companies (like Oracle and IBM)
-- correlating kind of makes sense.
with top as (
    select
        a.symbol as asym,
        b.symbol as bsym,
        (case when (stddev_pop(trunc(a.daily_prcnt::numeric, 3)) *
        stddev_pop(trunc(b.daily_prcnt::numeric,3)))=0 then null else
        ((avg(trunc(a.daily_prcnt::numeric,3) * trunc(b.daily_prcnt::numeric,3)) -
        (avg(trunc(a.daily_prcnt::numeric,3)) * avg(trunc(b.daily_prcnt::numeric,3)))) /
        (stddev_pop(trunc(a.daily_prcnt::numeric,3)) *
        stddev_pop(trunc(b.daily_prcnt::numeric,3)))) end) as correl
    from daily_prcnt_1b a
        join daily_prcnt_1b b on a.symbol!=b.symbol
    where a.daily_prcnt is not null and b.daily_prcnt is not null
    group by a.symbol, b.symbol
    order by correl desc
) 
select asym, bsym, correl
from top
where correl is not null
limit 20; 
-- Formatting may be off in the above since I has postgresql print out the
-- command history and then formatted it by hand.

-- Second step output:

 asym | bsym |                 correl                 
------+------+----------------------------------------
 ORCL | IBM  | 0.000000000000000046028583312467695732
 IBM  | ORCL | 0.000000000000000046028583312467695732
 NFLX | TT-L | 0.000000000000000035121636939620442304
 TT-L | NFLX | 0.000000000000000035121636939620442304
 GOOG | F-PK | 0.000000000000000034237698294684847366
 GOOG | F    | 0.000000000000000034237698294684847366
 GOOG | F-OB | 0.000000000000000034237698294684847366
 F-PK | GOOG | 0.000000000000000034237698294684847366
 F-OB | GOOG | 0.000000000000000034237698294684847366
 F    | GOOG | 0.000000000000000034237698294684847366
 NFLX | GE   | 0.000000000000000029514110324480528684
 GE   | NFLX | 0.000000000000000029514110324480528684
 GM   | TT-L | 0.000000000000000026465043063272902968
 TT-L | GM   | 0.000000000000000026465043063272902968
 TT-L | XOM  | 0.000000000000000026225860285541310691
 XOM  | TT-L | 0.000000000000000026225860285541310691
 V    | ORCL | 0.000000000000000026128155527279527221
 V-OB | ORCL | 0.000000000000000026128155527279527221
 ORCL | V    | 0.000000000000000026128155527279527221
 V-PK | ORCL | 0.000000000000000026128155527279527221
(20 rows)

-- Eliminating the repeated parts and limiting to 10 gives:

 asym | bsym |                 correl                 
------+------+----------------------------------------
 ORCL | IBM  | 0.000000000000000046028583312467695732
 NFLX | TT-L | 0.000000000000000035121636939620442304
 GOOG | F-PK | 0.000000000000000034237698294684847366
 GOOG | F    | 0.000000000000000034237698294684847366
 GOOG | F-OB | 0.000000000000000034237698294684847366
 NFLX | GE   | 0.000000000000000029514110324480528684
 GM   | TT-L | 0.000000000000000026465043063272902968
 TT-L | XOM  | 0.000000000000000026225860285541310691
 V    | ORCL | 0.000000000000000026128155527279527221
 V-OB | ORCL | 0.000000000000000026128155527279527221

-- EOF.
