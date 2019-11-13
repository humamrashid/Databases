-- notes on sql, not actual sql code! (started taking these notes on day 3.)

-- ##### day 3 #####

-- overview of basic sql.

-- sql (structured query language). industry and academic standard language for
-- managing relational databses in a dbms (database management system). sql is
-- not case-sensitive.

-- ddl (data definition language). primary operations include:
    create table;
    drop table;

-- dml (data manipulation language). primary operations include:
    insert ...
    select ...
    update ...
    delete ...

-- ddl and dml used to perform crud (create, retrieve, update and delete)
-- operations (which all databases are expected to support). most dbms support
-- a wider variety of operations beyond this and many differences exist between
-- the operations supported in each.

-- creating tables and fields. example:
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
-- key idea (for creating tables): don't declare fields as numbers if they're
-- not going to be used for numerical operations, especially if they have a
-- fixed-size. this is why zip code is a 'varchar' (basically a string) rather
-- than an integer type.

-- inserting data. example:
insert int customer(custid, name, email)
    values(1, 'john doe', 'john.doe@gmail.com' ...);
insert int customer(custid, name, email)
    values(2, 'jane doe', 'jane.doe@gmail.com' ...);
-- entries in values must match up with columns the table (as specified when
-- created).
-- inserts are relatively slow, requiring disk access before the database can be
-- updated. when adding multiple data units, prefer to use database utilities
-- specific to the dbms you're using.

-- updating data. example:
update customer set dob='2001-01-01' where custid=1;
update customer set zip='10001' where custid=1;
-- be careful when updating data, don't use if not certain, prefer adding new
-- entry with the modified details.

-- deleting data. example:
delete from customer where custid=2;
-- be careful when deleting data, don't use if not certain.

-- key idea (for insertion/deletion): don't treat data as a state, rather
-- consider it as a series of transactions.

-- querying data. probably the most common and important task performed in using
-- a databse. uses the 'select' keyword.
-- select statements. examples:
-- getting everything/everyone:
select * from customer;
-- getting a single customer:
select * from customer where custid=2;
-- get customers name 'doe'.
select * from customer where name like '%doe';
-- get count of customers.
select count(*) from customer;
-- get count of customers named 'doe'.
select count(*) from customer where name like '%doe';
-- get count of customers by state and in descending order:
select state, count(*)
from customer
group by state
order by desc;
-- get percentage of customers in ny.
select 100 * sum(case when state='ny' then 1.0 else 0.0 end) / sum(1.0)
from customer;
-- create age group label.
select a.*,
    case when dob >='2001-01-01' then 'teen'
         when dob >='1970-01-01' then 'mid'
         when dob >='1950-01-01' then 'eld'
         else 'snr'
    end as a egegrp
from customer a;
-- count customers by age group.
-- using ctes: common table expressions.
with agestmt as (
    select a.*,
        case when dob >='2001-01-01' then 'teen'
            when dob >='1970-01-01' then 'mid'
            when dob >= '1950-01-01' then 'eld'
            else 'snr'
        end as a egegrp
    from customer a
)
select agegrp, count(*)
from agestmt
group by agegrp
order by 2 desc;
-- everything starting with 'with' to 'order by...' above is a single select
-- statement.
-- creating tables from queries and querying after.
create table cust_agegrp as
    select a.*,
        case when dob >='2001-01-01' then 'teen'
            when dob >='1970-01-01' then 'mid'
            when dob >= '1950-01-01' then 'eld'
            else 'snr'
        end as a egegrp
from customer a;
select * from cust_agegrp where agegrp='teen';
-- creating views from queries and querying after.
create table cust_agegrp as
    select a.*,
        case when dob >='2001-01-01' then 'teen'
            when dob >='1970-01-01' then 'mid'
            when dob >= '1950-01-01' then 'eld'
            else 'snr'
        end as a egegrp
from customer a;
select * from cust_agegrp where agegrp='teen';
-- count customers by age group from the created table.
select agegrp, count(*)
from cust_agegrp
group by agegrp
order by desc;

-- joins. very important operation for comparing/matching data between tables.
-- example tables for representation of purchases.
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
-- get all purchases for custid=1.
select * from purchase where custid=1;
-- get all purchases for customers in zip '10001'.
select a.*
from purchase a
    inner join customer b
    on a.custid=b.custid
where zip='10001';
-- customer.custid is called 'primary' key.
-- purchase.custid is called 'foreign' key.
-- count number of purchases by customers in zip '10001'.
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
-- how many of each product did 'john doe' who lives in 'ny' purchase?
select productid, sum(c.qty)
from customer a
    inner join purchase b
    on a.custid=b.custid
    inner join purchase_detail c
    on b.purchaseid=c.purchaseid
where a.name='john doe' and a.state='ny'
group by productid
order by 2 desc;
-- "natural joins": use all columns that are named the same.
-- this type of join can be dangerous, use with caution.
select productid, sum(c.qty)
from customer
    natural inner join purchase b
    natural inner join purchase_detail c
where a.name='john doe' and a.state='ny'
group by productid
order by 2 desc;
-- there are several types of joins.
-- inner join:
-- example:
select ... from tablea inner join tableb on ...
-- records in both tablea and tableb have to exist to get a row of output.
-- left outer join:
-- example:
select ... from tablea left outer join tableb on ...
-- all records from tablea, with potential matches in tableb, if no match
-- available in tableb, then it is null.
select custid, purchaseid
from customer a
    left outer join purchase b
    on a.custid=b.custid
-- example output:
1, 2135
1, 2324
2, null
3, 7350
-- right outer join:
-- example:
select ... from tablea right outer join tableb on ...
-- all records from tableb, with potential matches in tablea, if no match
-- available in tablea, it is null.
-- full outer join:
-- example:
select custid, purchaseid
from customer a
    full outer join purchaes b
    on a.custid=b.custid;
-- example output:
1, 2135
1, 2324
2, null
3, 7350
null, 5178
null, 5312
-- full outer is join essentially a combination of left and right outer joins.
-- getting customers who've never purchased anything.
select ...
from customer a
    left outer join purchase b
    on a.custid=b.custid
where b.purchaseid is null
-- get customers who did purchase something.
select distinct a.custid
from customer a
    inner join purchase b
    on a.custid=b.custid;

-- ##### day 4 #####

-- so far what we've covered is basically how things were done before 2003.

-- learning through case studies: database usage in banks.

-- purpose of banks is to safekeep property/wealth for customers.
-- in terms of databases, records must be kept for customers, accounts,
-- transations, etc. all of these can be arranged by tables.

-- example setup:

-- customer table: has customer id, customer name, customer address and customer
-- email address..
customer(cid,name,ssn,,street,city,state,zip,email)

-- account table: has account id, customer id, and account type.
accnt(aid,cid,type)

-- transaction log table: has transaction id, transaction timestamp, account id,
-- and amount (processed in the transaction).
-- note: a single transaction consists of 1 or more records.
tlog(tlogid,tid,tim,aid,amnt)

-- ddl:
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

-- potential change to support different "things".
-- product(pid,type, -- ...whatever attributes for a particular thing is)
-- tlog(tlogid,tid,tim,aid,qty,pid);

-- dml:

-- inserting the data:
-- skipping physical address here.
insert into customer(cid,name,ssn,email)
    values(1,'john doe','123456789','john.doe@msn.com');
-- account type can be 'c' for "checking".
insert into accnt(aid,cid,type)
    values(1,1,'c');

-- scenario 1: john doe deposits $100.00 into their checking account (aid=1).

-- put $100 into account 1, during transaction 1.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(1,1,now(),1,100)

-- take $100 from account 0 (cash account), during transaction 1.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(2,1,now(),0,-100);

-- most enterprise databases have a concept of 'sequences', essentially a method
-- to generate unique integer values that are not isolated from each other
-- (meaning 2 tables cannot share the same value) and are incremented with each
-- use. every time a record uses a sequence, the sequence is incremented, which
-- may lead to gaps (for example in transactions with rollbacks).
create sequence tlogid_seq;
create sequence tid_seq;
create sequence cid_seq;
create sequence aid_seq;

-- inserting the data using sequences:
insert into customer(cid,name,ssn,email)
    values(nextval('cid_seq'),'john doe','123456789','john.doe@msn.com');
insert into accnt(aid,cid,type)
    values(nextval('aid_seq'),1,'c');
-- the above operations creates a customer record and account record with a
-- sequence so that a unique value does not have to be manually entered by the
-- database admin. each time a new record is created.

-- scenario 2: john doe deposits $100.00 into their checking account (aid=1).
-- transaction is processed using sequences.

-- put $100.00 into account 1, during transaction 1.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(nextval('tlogid_seq'),nextval('tid_seq'),now(),1,100)

-- take $100.00 from account 0 (cash account), during transaction 1.
-- note the currval(...) instead of nextval(...) for transaction id.
insert into tlog(tlogid,tid,tim,aid,amnt)
    values(nextval('tlogid_seq'),currval('tid_seq'),now(),0,-100);

-- query examples on bank data.

-- find incomplete/corrupt transactions (those that don't sum to 0).
select ...
from tlog
group by tid
having sum(amnt) != 0;
-- note that 'having' is meant to be used with groups; in practice, several dbms
-- allow using it in other contexts as well.

-- how much money is in account 1?
select sum(amnt)
from tlog
where aid=1;

-- how much money is in john doe's ccounts? (could have more than 1 account!)
-- note that we are assuming here that only one customer is named john doe.
select sum(c.amnt)
from customer a
    inner join accnt b
    on a.cid=b.cid
    inner join tlog c
    on b.aid=c.aid
where a.name='john doe';
-- the above uses 2 inner joins; the first one joins the customer with the
-- account by the customer id field (cid) and the second one joins the
-- transaction log with the account by the account id field (aid). taken
-- together, we get the transactions according to customer which is summed up.
-- note that this works because each deposit is a positive value and each
-- withdrawal/charge is a negative value so sum total gives the amount left.

-- give balance for all cusotmers named john doe, listed by customer id.
-- here, we assume there could be more than 1 customer named john doe.
select cid,sum(c.amnt)
from customer a
    inner join accnt b
    on a.cid=b.cid
    inner join tlog c
    on b.aid=c.aid
where a.name='john doe'
group by cid;
-- group by here makes up separate groups according to cid and the query is
-- separately run on each group.

-- give balance for all customers named john doe on january 1st, 2019.
-- 'on' a day here means before any transactions on that day.
select cid,sum(c.amnt)
from customer a
    inner join accnt b
    on a.cid=b.cid
    inner join tlog c
    on b.aid=c.aid
where a.name='john doe' and c.tim <'2019-01-01'
group by cid;
-- as seen above, comparisons operators work on timestamp values.

-- what's the account with the highest balance? (there could be more than 1!)
-- this query uses a cte, essentially creating a virtual table called 'bals'.
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
-- this query also uses a subquery (query within a query) which is of the form
-- 'select ... from ... where (select ... from ...)'.
-- note that in the cte, each sum is given a name 'bal' so that the super query
-- and subquery both use it in comparing the greatest balance.

-- get accounts with top 5 balances.
-- ranking is supported in a similar fashion to ctes.
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

-- account type 's' is savings, add 1% to every savings account.
insert into tlog
    -- get 1% of each balance by account and name that 'amnt'.
    with amnts as (
        select aid,sum(b.amnt)*0.01 amnt
        from accnt a
            inner join tlog b
            on a.aid=b.aid
        where type='s'
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
-- the above 2 queries after the cte are combined with 'union all' and the
-- records generated are inserted as records into the transaction log.
-- note that 'union all' preserves duplicate records unlike 'union'.

-- calculate the tax burden by ssn (total account balance increase between
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
-- the reported ssns are only those who balance increased by more than 10000.

-- ##### day 5 #####

-- look at notes, not much sql today.

-- loading data (postgresql):
psql
\copy tablename from file
\copy tablename to file

-- indexes and joins.

-- for example, inner joins.
select ...
from tablea a
    inner join tableb b
    on ...
where ...

-- how to do joins with regular programming languages?
-- join tablea.csv and tableb.csv

-- first attempt, nested loop join (pseudo-code):
for (all records in tablea) {
    for (all records in tableb) {
        if (condition is satisfied)
            output record
    }
}
-- this is very inefficient, o(n^2). for large datasets, it doesn't work (well).

-- look over provided notes for different types of indexes and joins.

-- ##### day 6 #####

-- analytical functions (also called windowing functions) in sql.
-- allows for ordering data in a database to get summaries, running totals, etc.
-- look at notes for analytical functions on website.

-- ##### day 7 #####

-- mid-term review.

-- sql: structured query language.
-- ddl: data definition language.
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
-- dml: data manipulation language.
-- crud: create, retrieve, update delete.
-- insert into customer(custid, name) values(1, 'bob');
-- select * from customer where custid=1;
-- update customer set name='bill' where custid=1;
-- delete from customer where custid=1;

-- ctas: create table as
create table gmail as
    select *
    from customer
    -- e.g., bob@gmail.com
    where lower(email) like '%gmail.com';

-- get all purchases for custid=235 on oct. 23rd, 2019.
select ...
from purchase
where custid=235 and tim >=cast('2019-10-23' as date)
and tim <to_date('10-24-2019', 'mm/dd/yyyy')
-- cast('2019-10-23' as date) is the same as: '2019-10-23'::date

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

--- ctes: common table expressions
-- count customers by email domain, return records with > 1000 counts.
select a.*,
    substring(email, position('@' in email), 100) as domain, count(*)
from customer a
group by substr(email, position('@' in email),100)
having count(*) > 1000

-- cleaner using ctes:
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

-- joins:
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

-- name and address of customers who purchased a product named "tv";

select distinct d.name, d.street, d.city, d.state, d.zip
from product a
    inner join purchase_detail b
    on a.productid=b.productid
    inner join purchase c
    on b.purchid=c.purchid
    on inner join customer d
    on c.custid=d.custid
where a.name='tv'

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

-- indexes

-- clustered vs not
-- btree indexes: b+trees store at the leaves, btrees store at the node.
-- bitmap indexes

-- analytic/windowing functions.

-- assign a sequence number to purchases
-- so all purchases for each customer are numberd 1 to n.
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

-- example from hw #5 (cts)
cts: consolidated trade summary
tdate,symbol,close
-- figure out the difference percentage gained or lost for every day.
with nextclose as (
    select tdate,symbol,close,
        lead(close) over (partition by symbol order by tdate) nextclose
    from cts
)
select tdate,symbol, ((nextclose/close)-1) * 100.0
from nextclose

-- e.g.
--close=100
--nextclose=103
-- (103/100-1) * 100.0
-- 1.03 - 1 = 0.03
-- 0.03 * 100 = 3%

-- aggregate functions.
    sum(...)
    product? not available.

-- what's the return for symbol ibm between 2010-01-01 and 2012-01-01
with gainloss as (
    select tdate,symbol,((nextclose/close)-1)*100.0 as prcnt
    from nextclose
)
select symbol, 1000 * exp(sum(log(1+prcnt/100.0))):-- 1000 is original investment.
from gainloss
where symbol='ibm' and
tdate between '2010-01-01' and '2012-01-01'

-- last term's mid-term available at: theparticle.com/cs/bc/dbsys/midterm20190402.pdf

-- ##### day 8 #####
-- Midterm.

-- ##### day 9 #####

-- Database Design.

-- Nouns: things (objects and attributes of objects).
-- Verbs: actions (things that happen to objects).

Nouns(Customer, Product)
Verbs(Purchase)

Customer
--------
name
emails
address

Product
-------
description
price

Purchase
--------
price

-- See diagram and notes on notebook.

-- eof.
