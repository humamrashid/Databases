-- Notes on SQL, not actual SQL code! (Started taking these notes on day 3.)

-- ##### Day 3 #####

-- Overview of basic SQL.

-- SQL (Structured Query Language). Industry and academic standard language for
-- managing relational databses in a DBMS (Database Management System). SQL is
-- NOT case-sensitive.

-- DDL (Data Definition Language). Primary operations include:
    create table;
    drop table;

-- DML (Data Manipulation Language). Primary operations include:
    insert ...
    select ...
    update ...
    delete ...

-- DDL and DML used to perform CRUD (Create, Retrieve, Update and Delete)
-- operations (which all databases are expected to support). Most DBMS support
-- a wider variety of operations beyond this and many differences exist between
-- the operations supported in each.

-- Creating tables and fields. Example:
create table customer (
    custid bigint,
    name varchar(100),
    email varchar(100),
    dob date,
    street varchar(100),
    city varchar(100),
    state varchar(2),
    zip varchar(5)
);
-- KEY IDEA (for creating tables): Don't declare fields as numbers if they're
-- not going to be used for numerical operations, especially if they have a
-- fixed-size. This is why zip code is a 'varchar' (basically a string) rather
-- than an integer type.

-- Inserting data. Example:
insert int customer(custid, name, email)
    values(1, 'John Doe', 'john.doe@gmail.com' ...);
insert int customer(custid, name, email)
    values(2, 'Jane Doe', 'jane.doe@gmail.com' ...);
-- Entries in values must match up with columns the table (as specified when
-- created).
-- Inserts are relatively slow, requiring disk access before the database can be
-- updated. When adding multiple data units, prefer to use database utilities
-- specific to the DBMS you're using.

-- Updating Data. Example:
update customer set dob='2001-01-01' where custid=1;
update customer set zip='10001' where custid=1;
-- Be careful when updating data, don't use if not certain, prefer adding new
-- entry with the modified details.

-- Deleting data. Example:
delete from customer where custid=2;
-- Be careful when deleting data, don't use if not certain.

-- KEY IDEA (for insertion/deletion): Don't treat data as a state, rather
-- consider it as a series of transactions.

-- Querying data. Probably the most common and important task performed in using
-- a databse. Uses the 'SELECT' keyword.
-- Select statements. Examples:
-- Getting everything/everyone:
select * from customer;
-- Getting a single customer:
select * from customer where custid=2;
-- Get customers name 'Doe'.
select * from customer where name like '%Doe';
-- Get count of customers.
select count(*) from customer;
-- Get count of customers named 'Doe'.
select count(*) from customer where name like '%Doe';
-- Get count of customers by state and in descending order:
select state, count(*)
from customer
group by state
order by desc;
-- Get percentage of customers in NY.
select 100 * sum(case when state='NY' then 1.0 else 0.0 end) / sum(1.0)
from customer;
-- Create age group label.
select a.*,
    case when dob >='2001-01-01' then 'TEEN'
         when dob >='1970-01-01' then 'MID'
         when dob >='1950-01-01' then 'ELD'
         else 'SNR'
    end as a egegrp
from customer a;
-- Count customers by age group.
-- Using CTEs: Common Table Expressions.
with agestmt as (
    select a.*,
        case when dob >='2001-01-01' then 'TEEN'
            when dob >='1970-01-01' then 'MID'
            when dob >= '1950-01-01' then 'ELD'
            else 'SNR'
        end as a egegrp
    from customer a
)
select agegrp, count(*)
from agestmt
group by agegrp
order by 2 desc;
-- Everything starting with 'with' to 'order by...' above is a single select
-- statement.
-- Creating tables from queries and querying after.
create table cust_agegrp as
    select a.*,
        case when dob >='2001-01-01' then 'TEEN'
            when dob >='1970-01-01' then 'MID'
            when dob >= '1950-01-01' then 'ELD'
            else 'SNR'
        end as a egegrp
from customer a;
select * from cust_agegrp where agegrp='TEEN';
-- Creating views from queries and querying after.
create table cust_agegrp as
    select a.*,
        case when dob >='2001-01-01' then 'TEEN'
            when dob >='1970-01-01' then 'MID'
            when dob >= '1950-01-01' then 'ELD'
            else 'SNR'
        end as a egegrp
from customer a;
select * from cust_agegrp where agegrp='TEEN';
-- Count customers by age group from the created table.
select agegrp, count(*)
from cust_agegrp
group by agegrp
order by desc;

-- Joins. Very important operation for comparing/matching data between tables.
-- Example tables for representation of purchases.
create table purchase (
    purchaseid bigint,
    custid bigint,
    tim timestamp
);
create table purchase_detail (
    detailid bigint,
    purchaseid bigint,
    productid bigint,
    qty int,
    price numeric(18, 8)
);
-- Get all purchases for custid=1.
select * from purchase where custid=1;
-- Get all purchases for customers in zip '10001'.
select a.*
from purchase a
    inner join customer b
    on a.custid=b.custid
where zip='10001';
-- customer.custid is called 'primary' key.
-- purchase.custid is called 'foreign' key.
-- Count number of purchases by customers in zip '10001'.
select count(*)
from purchase a
    inner join customer b
    on a.custid=b.custid
where zip='10001';
-- purchase counts by state
select count(*)
    inner join purchase b
    on a.custid=b.custid
group by state
order by 2 desc;
-- How many of each product did 'John Doe' who lives in 'NY' purchase?
select productid, sum(c.qty)
from customer a
    inner join purchase b
    on a.custid=b.custid
    inner join purchase_detail c
    on b.purchaseid=c.purchaseid
where a.name='John Doe' and a.state='NY'
group by productid
order by 2 desc;
-- "Natural Joins": use all columns that are named the same.
-- This type of join can be dangerous, use with caution.
select productid, sum(c.qty)
from customer
    natural inner join purchase b
    natural inner join purchase_detail c
where a.name='John Doe' and a.state='NY'
group by productid
order by 2 desc;
-- There are several types of joins.
-- inner join:
-- Example:
select ... from tableA inner join tableB on ...
-- Records in both tableA and tableB have to exist to get a row of output.
-- left outer join:
-- Example:
select ... from tableA left outer join tableB on ...
-- All records from tableA, with potential matches in tableB, if no match
-- available in tableB, then it is null.
select custid, purchaseid
from customer a
    left outer join purchase b
    on a.custid=b.custid
-- Example output:
1, 2135
1, 2324
2, NULL
3, 7350
-- right outer join:
-- Example:
select ... from tableA right outer join tableB on ...
-- All records from tableB, with potential matches in tableA, if no match
-- available in tableA, it is null.
-- full outer join:
-- Example:
select custid, purchaseid
from customer a
    full outer join purchaes b
    on a.custid=b.custid;
-- Example output:
1, 2135
1, 2324
2, NULL
3, 7350
NULL, 5178
NULL, 5312
-- Full outer is join essentially a combination of left and right outer joins.
-- Getting customers who've never purchased anything.
select ...
from customer a
    left outer join purchase b
    on a.custid=b.custid
where b.purchaseid is null
-- Get customers who did purchase something.
select distinct a.custid
from customer a
    inner join purchase b
    on a.custid=b.custid;

-- ##### Day 4 #####

-- So far what we've covered is basically how things were done before 2003.

-- Learning through case studies: database usage in banks.

-- Purpose of banks is to safekeep property/wealth for customers.
-- In terms of databases, records must be kept for customers, accounts,
-- transations, etc. All of these can be arranged by tables.

-- Example setup:

-- Customer table: has customer id, customer name, customer address and customer
-- email address..
customer(cid,name,ssn,,street,city,state,zip,email)

-- Account table: has account id, customer id, and account type.
accnt(aid,cid,type)

-- transaction log table: has transaction id, transaction timestamp, account id,
-- and amount (processed in the transaction).
-- NOTE: a single transaction consists of 1 or more records.
tlog(tlogid,tid,tim,aid,amnt)

-- DDL:
create table customer(
    cid bigint, name varchar(100), ssn varchar(9),
    street varchar(60), city varchar(60), state varchar(2), zip varchar(5),
    email varchar(100)
);
create table accnt(
    aid bigint, cid bigint, type varchar(1)
);
create table tlog(
    tlogid bigint, tid bigint, tim timestamp, aid bigint, amnt numeric(18,8)
);

-- Potential change to support different "things".
-- product(pid,type, -- ...whatever attributes for a particular thing is)
-- tlog(tlogid,tid,tim,aid,qty,pid);

-- DML:

-- Inserting the data:
-- Skipping physical address here.
insert into customer(cid,name,ssn,email)
    values(1,'John Doe','123456789','john.doe@msn.com');
-- Account type can be 'C' for "checking".
insert into accnt(aid,cid,type)
    values(1,1,'C');

-- Scenario 1: John Doe deposits $100.00 into their checking account (aid=1).

-- Put $100 into account 1, during transaction 1.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(1,1,now(),1,100)

-- Take $100 from account 0 (cash account), during transaction 1.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(2,1,now(),0,-100);

-- Most enterprise databases have a concept of 'sequences', essentially a method
-- to generate unique integer values that are not isolated from each other
-- (meaning 2 tables cannot share the same value) and are incremented with each
-- use. Every time a record uses a sequence, the sequence is incremented, which
-- may lead to gaps (for example in transactions with rollbacks).
create sequence tlogid_seq;
create sequence tid_seq;
create sequence cid_seq;
create sequence aid_seq;

-- Inserting the data using sequences:
insert into customer(cid,name,ssn,email)
    values(nextval('cid_seq'),'John Doe','123456789','john.doe@msn.com');
insert into accnt(aid,cid,type)
    values(nextval('aid_seq'),1,'C');
-- The above operations creates a customer record and account record with a
-- sequence so that a unique value does not have to be manually entered by the
-- database admin. each time a new record is created.

-- Scenario 2: John Doe deposits $100.00 into their checking account (aid=1).
-- Transaction is processed using sequences.

-- Put $100.00 into account 1, during transaction 1.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(nextval('tlogid_seq'),nextval('tid_seq'),now(),1,100)

-- Take $100.00 from account 0 (cash account), during transaction 1.
-- Note the currval(...) instead of nextval(...) for transaction id.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(nextval('tlogid_seq'),currval('tid_seq'),now(),0,-100);

-- Query examples on bank data.

-- Find incomplete/corrupt transactions (those that don't sum to 0).
select ...
from tlog
group by tid
having sum(amnt) != 0;
-- Note that 'having' is meant to be used with groups; in practice, several DBMS
-- allow using it in other contexts as well.

-- How much money is in account 1?
select sum(amnt)
from tlog
where aid=1;

-- How much money is in John Doe's ccounts? (Could have more than 1 account!)
-- Note that we are assuming here that only one customer is named John Doe.
select sum(c.amnt)
from customer a
    inner join accnt b
    on a.cid=b.cid
    inner join tlog c
    on b.aid=c.aid
where a.name='John Doe';
-- The above uses 2 inner joins; the first one joins the customer with the
-- account by the customer id field (cid) and the second one joins the
-- transaction log with the account by the account id field (aid). Taken
-- together, we get the transactions according to customer which is summed up.
-- Note that this works because each deposit is a positive value and each
-- withdrawal/charge is a negative value so sum total gives the amount left.

-- Give balance for all cusotmers named John Doe, listed by customer id.
-- Here, we assume there could be more than 1 customer named John Doe.
select cid,sum(c.amnt)
from customer a
    inner join accnt b
    on a.cid=b.cid
    inner join tlog c
    on b.aid=c.aid
where a.name='John Doe'
group by cid;
-- Group by here makes up separate groups according to cid and the query is
-- separately run on each group.

-- Give balance for all customers named John Doe on January 1st, 2019.
-- 'On' a day here means before any transactions on that day.
select cid,sum(c.amnt)
from customer a
    inner join accnt b
    on a.cid=b.cid
    inner join tlog c
    on b.aid=c.aid
where a.name='John Doe' and c.tim <'2019-01-01'
group by cid;
-- As seen above, comparisons operators work on timestamp values.

-- What's the account with the highest balance? (There could be more than 1!)
-- This query uses a CTE, essentially creating a virtual table called 'bals'.
-- 'bals' becomes a table whose records are the results of the query inside the
-- 'with bals as (...)'.
with bals as (
    select aid,sum(amnt) bal
    from tlog
    group by aid
)
select aid
from bals
where bal >=(select max(bal) from bals);
-- This query also uses a subquery (query within a query) which is of the form
-- 'select ... from ... where (select ... from ...)'.
-- Note that in the CTE, each sum is given a name 'bal' so that the super query
-- and subquery both use it in comparing the greatest balance.

-- Get accounts with top 5 balances.
-- Ranking is supported in a similar fashion to CTEs.
with bals as (
    select aid,sum(amnt) bal
    from tlog
    group by aid
),
rank as (
    select a.*, dense_rank() over (order by bal) rnk
    from bals
)
select aid,bal,rnk
from rnks
where rnk <=5;

-- Account type 'S' is savings, add 1% to every savings account.
insert into tlog
    -- get 1% of each balance by account and name that 'amnt'.
    with amnts as (
        select aid,sum(b.amnt)*0.01 amnt
        from accnt a
            inner join tlog b
            on a.aid=b.aid
        where type='S'
        group by aid
    )
    -- take the money out of cash and put into the savings.
    -- no updates happen for any balances, insert implicitly updates the
    -- account.
    select nextval('tlogid_seq'),nextval('tid_seq'),now(),0,-sum(amnt)
    from amnts
    union all
    select nextval('tlogid_seq'),currval('tid_seq'),now(),aid,amnt
    from amnts
;
-- The above 2 queries after the CTE are combined with 'union all' and the
-- records generated are inserted as records into the transaction log.
-- Note that 'union all' preserves duplicate records unlike 'union'.

-- Calculate the tax burden by SSN (total account balance increase between
-- 2018-01-01 and 2019-01-01).
with bals as (
    select ssn,
        sum(case when tim<'2019-01-01' then amnt else 0 end) bal2019,
        sum(case when tim<'2018-01-01' then amnt else 0 end) bal2018
    from customer a
        inner join accnt b
        on a.cid=b.cid
        inner join tlog c
        on b.aid=c.aid
    group by ssn
)
select ssn, bal2019 - bal2018 incamnt
from bals
where bal2019 - bal2018 > 10000;
-- The reported SSNs are only those who balance increased by more than 10000.

-- ##### Day 5 #####

-- Look at notes, not much SQL today.

-- Loading data (Postgresql):
psql
\copy tablename from FILE
\copy tablename to FILE

-- Indexes and Joins.

-- For example, inner joins.
select ...
from tableA a
    inner join tableB b
    on ...
where ...

-- How to do joins with regular programming languages?
-- Join tableA.csv and tableB.csv

-- First attempt, nested loop join (pseudo-code):
for (all records in tableA) {
    for (all records in tableB) {
        if (condition is satisfied)
            output record
    }
}
-- This is very inefficient, O(n^2). For large datasets, it doesn't work (well).

-- Look over provided notes for different types of indexes and joins.

-- ##### Day 6 #####

-- Analytical Functions (also called Windowing Functions) in SQL.
-- Allows for ordering data in a database to get summaries, running totals, etc.
-- Look at notes for analytical functions on website.

-- ##### Day 7 #####

-- Mid-term review.

-- SQL: Structured Query Language.
-- DDL: Data Definition Language.
create table customer(
    custid bigint,
    name varchar(100),
    email varchar(100)
    street varchar(100),
    city varchar(100),
    zip varchar(10)
);
create table purchase(
    purchid bigint,
    custid bigint,
    tim timestamp
);
-- drop table customer;
-- DML: Data Manipulation Language.
-- CRUD: create, retrieve, update delete.
-- insert into customer(custid, name) values(1, 'bob');
-- select * from customer where custid=1;
-- update customer set name='bill' where custid=1;
-- delete from customer where custid=1;

-- CTAS: create table as
create table gmail as
    select *
    from customer
    -- e.g., bob@GMAIL.com
    where lower(email) like '%gmail.com';

-- get all purchases for custid=235 on Oct. 23rd, 2019.
select ...
from purchase
where custid=235 and tim >=cast('2019-10-23' as date)
and tim <to_date('10-24-2019', 'MM/DD/YYYY')

-- cast('2019-10-23' as date) is the same as: '2019-10-23'::date

create table purchase (
    purchid bigint,
    custid bigint,
    .
    .
    .
);

-- aggregate functions.
select count(*)
from customer where email like '%gmail.com'

--- what percentage of our customers have a gmail address?
select 100.0 * sum(case when email like '%gmail.com' then 1 else 0 end) / sum(1.0) as prcnt...

select state, count(*)
from customer
group by state;

-- count customers by state, only output if > 1000
select state, count(*)
from customer
group by state
having count(*) > 1000;

-- count customers by state, only count if state has over 1000 gmail users
select state, count(*)
from customer
group by state
having sum(case when email like '%gmail.com' then 1 else 0 end) > 1000;

--- CTEs: common table expressions
-- count customers by email domain, return records with > 1000 counts.
select a.*,
    substring(email, position('@' in email), 100) as domain, count(*)
from customer a
group by substr(email, position('@' in email),100)
having count(*) > 1000

-- cleaner using CTEs:
with custdomain as (
    select a.*,
        substr(email, position('@' in email), 100) as domain, count(*)
    from customer a
)
select domain, count(*)
from custdomain
group by domain
having count(*) > 1000
order by domain

-- Joins:
create table purchase_detail (
    purchid bigint,
    productid bigint,
    qty int,
);

create table product (
    productid bigint,
    name varchar(100),
    listprice decimal(18, 8)
);

-- name and address of customers who purchased a product named "TV";

select distinct d.name, d.street, d.city, d.state, d.zip
from product a
    inner join purchase_detail b
    on a.productid=b.productid
    inner join purchase c
    on b.purchid=c.purchid
    on inner join customer d
    on c.custid=d.custid
where a.name='TV'

-- inner join

select ...
from customer a
    inner join purchase b
    on a.custid=b.custid;

-- same as:
select a.custid, b.custid, b.tim
from customer a
    natural inner join purchase -- because both tables have custid

-- left outer join
-- names of customers who've never purchased anything.
select ...
from customer a
 left outer join purchase b
 on a.custid=b.custid
where b.custid is null

-- full outer join
-- natural ... (all the above)

-- Indexes

-- clustered vs not
-- btree indexes: b+trees store at the leaves, btrees store at the node.
-- bitmap indexes

-- Analytic/Windowing functions.

-- assign a sequence number to purchases
-- so all purchases for each customer are numberd 1 to N.
select a.*
    row_number() over (partition by custid order by tim) seq
from purchase a

-- find the last purchase record for each customer.
with purchseq as (
    select a.*
        row_number() over (partition by custid order by tim) seq
    from purchase a
)
select *
from purchseq
where seq=1;

-- without analytics (doesn't work).

with purchseq as (
    select custid,max(tim) maxtim
    from purchase a
    group by custid
)
select *
from purchase a
    inner join purchseq b
    on a.custid=b.custid and a.tim>=b.maxtim;

-- Example from hw #5 (CTS)
CTS: consolidated trade summary
tdate,symbol,close
-- figure out the difference percentage gained or lost for every day.
with nextclose as (
    select tdate,symbol,close
        lead(close) over (partition by symbol order by tdate) nextclose
    from cts
)
select tdate,symbol, (nextclose/close)-1 * 100.0
from nextclose

-- e.g.
--close=100
--nextclose=103
-- (103/100-1) * 100.0
-- 1.03 - 1 = 0.03
-- 0.03 * 100 = 3%

-- aggregate functions.
    sum(...)
    product? Not available.

-- what's the return for symbol IBM between 2010-01-01 and 2012-01-01
with gainlass as (
    select tdate,symbol,((nextclose/close)-1)*100.0 as prcnt
    from nextclose
)
select symbol, 1000 * exp(sum(log(1+prcnt/100.0))):-- 1000 is original investment.
from gainloss
where symbol='IBM' and
tdate between '2010-01-01' and '2012-01-01'

-- last term's mid-term available at: theparticle.com/cs/bc/dbsys/midterm20190402.pdf

-- EOF.
