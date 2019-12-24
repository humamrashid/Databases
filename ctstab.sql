-- SQL for creating table ctstab from cts data.

use mydb;

create table if not exists ctstab (
    tdate str_to_date(date,
    symbol varchar(18),
    open numeric(18,8),
    high numeric(18,8),
    low numeric(18,8),
    close numeric(18,8),
    volume bigint
);
