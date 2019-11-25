-- Humam Rashid
-- CISC 7510X, Fall 2019

create table DAILY_PRCNT_1 as
    with DATA as (
        select
            a.TDATE,
            a.SYMBOL,
            a.CLOSE,
            lag(a.CLOSE) over (partition by a.SYMBOL order by a.TDATE) LAST_CLOSE,
            coalesce (PRE, 1) PRE,
            coalesce (POST, 1) POST,
            coalesce (AMOUNT, 0) DIV
        from CTSTAB a
            left outer join DIVTAB b
                on a.TDATE = b.TDATE and a.SYMBOL = b.SYMBOL
            left outer join SPLITSTAB c
                on a.TDATE = c.TDATE and a.SYMBOL = c.SYMBOL
    )
    select
        TDATE,
        SYMBOL,
        (((CLOSE + DIV) * POST - LAST_CLOSE * PRE) /
            (case when LAST_CLOSE=0 then null else LAST_CLOSE end)) * 100.0 as PRCNT_VAL
    from DATA
    order by TDATE;

create table DAILY_PRCNT_2 as
    with DATA as (
        select
            a.TDATE,
            a.SYMBOL,
            a.CLOSE,
            lag(a.CLOSE) over (partition by a.SYMBOL order by a.TDATE) LAST_CLOSE,
            coalesce (PRE, 1) PRE,
            coalesce (POST, 1) POST,
            coalesce (AMOUNT, 0) DIV
        from CTSTAB a
            left outer join DIVTAB b
                on a.TDATE = b.TDATE and a.SYMBOL = b.SYMBOL
            left outer join SPLITSTAB c
                on a.TDATE = c.TDATE and a.SYMBOL = c.SYMBOL
    )
    select
        TDATE,
        SYMBOL,
        LAST_CLOSE * PRE AS LAST_CLOSE_PRE,
        (CLOSE + DIV) * POST AS CLOSE_DIV_POST,
        (case when (LAST_CLOSE-DIV)=0 then null else
            ((CLOSE/(LAST_CLOSE-DIV))-1) end) * 100.0 AS DAILY_PRCNT
    from DATA
    order by TDATE;

create table DAILY_PRCNT_3 as
    with DATA as (
        select
            a.TDATE,
            a.SYMBOL,
            a.CLOSE,
            lag(a.CLOSE) over (partition by a.SYMBOL order by a.TDATE) LAST_CLOSE,
            coalesce (PRE, 1) PRE,
            coalesce (POST, 1) POST,
            coalesce (AMOUNT, 0) DIV
        from CTSTAB a
            left outer join DIVTAB b
                on a.TDATE = b.TDATE and a.SYMBOL = b.SYMBOL
            left outer join SPLITSTAB c
                on a.TDATE = c.TDATE and a.SYMBOL = c.SYMBOL
    )
    select
        TDATE,
        SYMBOL,
        (case when ((LAST_CLOSE - DIV) * (PRE/POST::float))=0 then null else
            ((CLOSE/((LAST_CLOSE - DIV) * (PRE/POST::float)))-1) end) * 100.0 AS DAILY_PRCNT
    from DATA
    order by TDATE;

-- EOF.
