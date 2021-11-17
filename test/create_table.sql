create table db1.table1 (id number(10));create table db1.table1 (id number(10), name varchar2(255));

CREATE TABLE "TEST"."T1"
(
    "ID" NUMBER(*,0)
) SEGMENT CREATION IMMEDIATE PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "SYSTEM";

create table db1.table1 (id number(10) primary key);

create table db1.table1 (id number(10), unique (id) enable);

create table db1.table1 (id number(10), primary key (id) enable);

create table db1.table1 (id number(10), CONSTRAINT pk primary key (id) enable);

create table db1.table1 (id number(10), primary key (id)  using index enable);

create table db1.table1 (id number(10,3) primary key);

CREATE TABLE test."persons" ( NUMERIC_NAME NUMERIC ( 15, 2 ), Decimal_NAME DECIMAL ( 15, 2 ), Dec_NAME DEC ( 15, 2 ), INTEGER_NAME INTEGER );

create table TEST.T21 (t CHAR(255));
