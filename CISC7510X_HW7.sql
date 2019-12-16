-- Humam Rashid
-- CISC 7510X, Fall 2019

with series_a as (
    select symbol, a.daily_prcnt
    from daily_prcnt a
    where
        (a.tdate between '2013-12-01' and '2013-12-31')
        and
        (a.daily_prcnt is not null)
    group by symbol
), series_b as (
    select symbol, b.daily_prcnt
    from daily_prcnt b
    where
        (b.tdate between '2013-12-01' and '2013-12-31')
        and
        (b.daily_prcnt is not null)
    group by symbol
) select *
from series_a a join series_b b
    on a.symbol<>b.symbol
    limit 10;

-- EOF.
