-- SQL for creating table divstab from cts data.

use mydb;

create table if not exists divtab (
    tdate date,
    symbol varchar(18),
    amount numeric(18,8)
);
