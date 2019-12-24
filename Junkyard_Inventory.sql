--Humam Rashid
--CISC 7510X, Fall 2019.

--Inventory System for Automobile Junkyard
------------------------------------------

--In attempting to design the inventory system, I wasn't sure if the requirements
--were limited to search data only (i.e., data on the available parts only) or the
--entire process of searching, buying, etc. To be safe, I assumed that more or
--less the entire process is required based on my understanding of how typical
--inventory systems (e.g., online bookstores) work. Due to this, my design is an
--amalgamation of the online store DB design discussed in class along with
--management requirements for junkyard automobile parts. The schema are divided
--into sections for ease of reading but its meant to be all in one database
--managed by the overall software system. However, note that all tables in the
--transactions section and some tables in services & processing management section
--would be specific to each junkyard in my design and separated into different
--accounts (one per junkyard), each having its own distinct versions of these
--specific tables (although they are synchronized as needed with the other tables
--which all accounts have some form of access to).

--The following is the schema for the transactions section of section inventory
--system and is based directly on the design discussed in class, adjusted for the
--junkyard-specific use case:

--Transactions
--------------
create table customer(
    customerid bigint       not null,
    name       varchar(100) not null,
    address    varchar(100) not null,
    phone1     varchar(20)  not null,
    phone2     varchar(20),
    email      varchar(100)
);
create table purchase(
    purchaseid bigint    not null,
    customerid bigint    not null,
    ptime      timestamp not null
);
create table purchase_detail(
    purchasedetailid bigint       not null,
    purchaseid       bigint       not null,
    serialnum        varchar(100) not null,
    deliveryid       bigint
);
create table price_history(
    pricehistoryid bigint       not null,
    price          numeric(8,2) not null,
    pctime         timestamp    not null,
    serialnum      varchar(100) not null
);

--The purposes of the above tables were discussed at length in class so I am not
--repeating them here. The table 'products' is left out above in contrast to the
--class notes and instead replaced with 'parts' and 'part_detail' since products
--in the junkyard are of a specific variety. A 'serialnum' field is added to the
--'purchase_detail' and 'price_history' table to track exactly which parts were
--purchased in a given transaction and to uniquely track a specific item's price
--changes, respectively. The inclusion of 'serialnum' also allows for the tracking
--of location of purchase, location of price change (given that two different
--junkyards do not necessarily change prices at the same time for the same part)
--and price change according to specific individual item (rather than item type
--since items of the same type may still be of different conditions, etc.). The
--'price_history' table further has a 'pctime' field to track of when a certain
--price change has occurred for a specific item. Information such as quantity can
--also easily be summed up for any purchase by counting the individual
--'serialnum's in 'purchase_detail' for that 'purchaseid'. A 'deliveryid' field is
--added to 'purchase_detail' in case a particular junkyard has a delivery service.

--The following is the schema for the inventory tracking and search facilities of
--a junkyard business:

--Search & Inventory Management
-------------------------------
create table automobile(
    autoid bigint       not null,
    color  varchar(100) not null,
    make   varchar(100) not null,
    model  varchar(100) not null,
    body   varchar(100) not null,
    year   integer      not null
);
--The 'automobile' table catalogs specific car types that have ever been brought
--into the junkyard or is expected to be (see 'waiting_list' below). An entry is
--added to this table as soon as a new car or part is brought in or a customer
--indicates that he/she is interested in parts for the specific car type. A
--typical insert may look like `insert into automobile values(000001, "Black",
--"Honda", "Accord", "Sedan", 2019)`. Since all junkyards using this software are
--linked through it, it is likely that not all junkyards would have parts
--available for every car cataloged in 'automobile' table. Entries for parts in
--the 'parts' table for which a car type does not yet exist in 'automobile' would
--require a simultaneous entry to that car type in this table. The above implies
--that 'autoid' is used for recognition and tracking of any car types that is or
--may possibly become available in the system.

create table parts(
    partid    bigint       not null,
    autoid    bigint       not null,
    partdesc  varchar(500) not null,
    quantity  integer      not null
);
--The 'parts' table catalogs specific part types relative to specific car types
--that have ever been brought into a junkyard or is expected to be as with
--'automobiles' table. An entry is added to this table as soon as a new part is
--available (e.g., when a new car is brought in and scrapped) or a customer
--indicates he/she is interested in a part (which not being available yet ->
--quantity = 0). The 'partdesc' field indicates name and type with any additional
--info. (e.g., engine, gas tank, left-side mirror, etc.) that is true for all
--parts of this type and car (which may not be physically available currently).
--The 'quantity' field of course indicates the number of such parts available in
--stock. A typical insert may look like `insert into parts values(000001, 000001,
--"Brakes", 2)`. Note that unlike 'part_detail', entries in 'parts' do not
--necessarily imply that these parts are available somewhere in the system,
--instead, like 'automobile' it catalogs the type of item available and/or
--desired. Entries for parts that are not yet available need a simultaneous entry
--into the 'waiting_list' table in case it was a customer request (using the same
--'partid'). The above implies that 'partid' is used for recognition and tracking
--of any parts that is or may possibly become available in the system.

create table part_detail(
    partdetailid bigint        not null,
    partid       bigint        not null,
    serialnum    varchar(100)  not null,
    modid        bigint,
    condition    varchar(20)   not null,
    detaildesc   varchar(500),
    partprice    numeric(8,2)  not null,
    localeid     bigint        not null
);
--The 'part_detail' table catalogs and tracks each individual part that is/was
--available at any junkyard. No two parts being inventoried can share a
--'serialnum' even if they are of the same type and origin. This table is filled
--whenever a new part becomes available anywhere in the system and used for
--tracking of specific individual parts rather than the type of part. A different
--part of the same type would have the same 'partid' but a different 'serialnum'.
--The 'modid' field indicates whether it is a modified part or not (could be null,
--indicating unmodified). The 'condition' field is used for terms like used and
--new and the related 'detaildesc' describes details of the individual part such
--as "broken", "malfunctioning", etc. The 'partprice' is the latest price (last
--value of 'price' from 'price_history' table) and 'localeid' indicates the
--junkyard where it is available. A typical insert may look like `insert into
--part_detail values(000050, 000001, "PSN123456-7890", null, "Used", "No issues",
--20.00, 000018)`. Note that unlike 'parts', entries in 'part_detail' do
--necessarily imply that these parts are available somewhere in the system.

create table compatible(
    compatibleid bigint   not null,
    partid       bigint   not null,
    autoid       bigint   not null,
    moded        boolean,
    localeid     bigint
);
--The 'compatible' table catalogs which entries in the 'parts' table is compatible
--with which entries in the 'automobile' table. It is expected that certain parts
--from some car model for instance, could be compatible with other models as well.
--So brakes from a Black Honda Accord could possibly be used with many other
--sedans regardless of color or model. The 'moded' field indicates whether a
--modification is required to make it compatible (i.e., true -> modification
--required); it is possibly null because modification depends on what the specific
--junkyard and its technicians are capable of and willing to do, and may change
--over time. This is also part of why 'localeid' may be null, as well the
--possibility of the part not being available anywhere (anymore). The other fields
--cannot be null and at least one entry is required for each part, so at least one
--entry is created for this table as soon as an entry is added to the 'parts'
--table. A typical insert may look like `insert into compatible values(987654,
--000001, 000009, null, null)`. Another entry for part 000009 but with a different
--'autoid' indicates that this part is also compatible with this type of car.

create table location(
    localeid bigint         not null,
    shopname varchar(20)    not null,
    street   varchar(20)    not null,
    city     varchar(20)    not null,
    county   varchar(20),
    region   varchar(20)    not null,
    postal   varchar(10)    not null,
    country  varchar(20)    not null,
    phone    varchar(20)    not null,
    email    varchar(100)   not null,
    link     varchar(100)
);
--The 'location' table catalogs the different junkyards that use this same
--software package. The actual shops may be located across the nation or
--internationally. An entry is added to this table whenever a new junkyard starts
--subscribing to this software package. Where an event such as a purchase happens
--or where an object such as a (compatible) part is present, is kept track of
--using this table. The 'link' field is meant for URLs in case the specific
--junkyard has a website, Facebook page, etc. A typical insert may look like
--`insert into location values(000018, "Nassau Junk Parts",
--"20 W. Old Country Rd.", "Oyster Bay", "Nassau", "New York", "11801", "USA",
--"555-555-5555", "nassaujunk@gmail.com", null)`.

--The following is the schema of a limited set of services/processing work that
--might be performed in a typical junkyard (to keep things simple only very basic
--things are included here, other possible tables that might be used include one
--for processing returns and so on):

--Services & Processing Management
----------------------------------
create table modification(
    modid     bigint        not null,
    serialnum varchar(100)  not null,
    original  varchar(500), not null,
    current   varchar(500)  not null
);
--The 'modification' table catalogs parts that have been modified. This is used to
--keep track of modified parts and parts in their original condition. It is also
--used to locate where a certain modified part is available (using the 'serialnum'
--field). The existence of an entry in this table (and hence a 'modid') for a
--specific part indicates that this specific part (and not all parts of this type)
--has been modified. The 'original' and 'current' fields indicate the original and
--latest modified status of the specific part, respectively. Note also that the
--'current' field is the latest value of the 'moddesc' field in 'mod_history'
--table. A typical insert may look like `insert into modification values(002558,
--"PSN123656-9730", "black left-side mirror", "repainted silver")`. Modification
--may require updating/inserting a new 'partid' entry for the modified item since
--it may now be considered a different type.

create table mod_history(
    modhistoryid bigint        not null,
    serialnum    varchar(100)  not null,
    moddesc      varchar(500)  not null,
    mtime        timestamp     not null
);
--The 'mod_history' table is to 'modification' what 'price_history' is to
--'purchase_detail', in that it tracks the modification of a specific part over
--time since a part may undergo multiple modifications. The 'moddesc' field
--describes the change that was made at 'mtime' time. A typical insert may look
--like `insert into mod_history values(850273, "PSN853812-5832", "Fixed small
--crack", "2019-12-02 18:00")`.

create table waiting_list(
    waitinglistid bigint       not null,
    customerid    bigint,
    partid        bigint       not null,
    condition     varchar(20),
    partdesc      varchar(100) not null,
    quantity      integer      not null,
    wstime        timestamp    not null
);
--The 'waiting_list' table catalogs parts that are not currently available but are
--desired. This could mean that a customer has requested it or that a junkyard
--expects there to be customers for this part type (for the former case, a
--'customerid' would be required). The 'waiting_list' table is specific to each
--junkyard account in the system. An addition to this table however requires a
--simultaneous addition into the global 'parts' table in case this is not a part
--type that was cataloged in the system previously. The 'wstime' field indicates
--the time an entry was created. A typical insert may look like `insert into
--waiting_list values(157105, 148588, 008594, null, "Red steering wheel", 1,
--"2018-12-15 15:30")`.

create table waitinglist_detail(
    waitinglistdetailid bigint    not null,
    waitinglistid       bigint    not null,
    wctime              timestamp not null
);
--The 'waitinglist_detail' table is associated with the 'waiting_list' table and
--tracks if and when a waiting list entry was filled. The existence of a
--waitinglistdetailid implies fulfillment. The 'wctime' value is the time of
--fulfillment. This table essentially exists so that updates or deletions are not
--required in the 'waiting_list' table when the item is in possession. A typical
--insert may look like `insert into waitinglist_detail values(145831, 157105,
--"2019-02-23 14:30")`. Like 'waiting_list', 'waitinglist_detail' is specific to
--each junkyard account in the system.

create table delivery(
    deilveryid       bigint       not null,
    purchasedetailid bigint       not null,
    serialnum        varchar(100) not null,
    stime            timestamp    not null,
    tracknum         varchar(100)
);
--Do junkyards have delivery service? I don't really know, but in case they do:
--the 'delivery' table tracks delivery events. An entry is added to this table
--when a customer makes a purchase of an item and requests delivery. Thus, each
--delivery entry is specific to a part and a missing entry for a certain
--'purchasedetailid' indicates delivery was not requested. The 'stime' indicates a
--shipping time (i.e., whenever it was handed over to a shipping service or sent
--out with their own delivery people). The 'tracknum' is therefore only required
--when a shipping service is used. A typical insert may look like `insert into
--delivery values(532707, 753564, "PSN573458-7866", "2017-04-21 07:30", null)`.
--The 'delivery' table is specific to each junkyard account in the system.

create table delivery_detail(
    deliverydetailid bigint    not null,
    deliveryid       bigint    not null,
    dtime            timestamp not null
);
--The 'delivery_detail' table is associated with the 'delivery' table and tracks
--information specific to each delivery that is expected to be added after
--shipment (i.e. time of delivery and delivery confirmation). The existence of a
--deliverydetailid implies delivery confirmation. The 'dtime' value is the time of
--delivery. This table essentially exists so that updates are not required in the
--'delivery' table when a delivery is completed. A typical insert may look like
--`insert into delivery_detail values(175031, 542707, "2017-04-23 14:30")`. Like
--'delivery', 'delivery_detail' is also specific to each junkyard account in the
--system.

--Example Use-Cases
-------------------
--Description of which tables would receive entries when a new junky car arrives
--is given under the relevant table DDLs, especially in the 'Search & Inventory
--Management' section above.

--EOF.
