alter table db1.table1 add (id number);

alter table db1.table1 add (id number, name varchar(255));

alter table db1.table1 add (id number(*));

alter table db1.table1 add (id number(5));

alter table db1.table1 add (id number(5, 3));

alter table db1.table1 add (id float(*));

alter table db1.table1 add (id float(5));

alter table db1.table1 add (id varchar2(255));

alter table db1.table1 add (id varchar2(255) collate binary_ci);

alter table db1.table1 add (id varchar2(255) sort);

alter table db1.table1 add (id varchar2(255) collate binary_ci sort);

alter table db1.table1 add (id varchar2(255) collate binary_ci invisible);

alter table db1.table1 add (id varchar2(255) collate binary_ci  visible);

alter table db1.table1 add (id varchar2(255) collate binary_ci sort invisible);

alter table db1.table1 add (id varchar2(255) default "test");

alter table db1.table1 add (id number default 123);

alter table db1.table1 add (id number not null, name varchar(255) unique);
