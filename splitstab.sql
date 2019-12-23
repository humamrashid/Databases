-- SQL for creating table splitstab from cts data.

use mydb;

create table if not exists splitstab (
    tdate date,
    symbol varchar(18),
    post numeric(18,8),
    pre numeric(18,8)
);
