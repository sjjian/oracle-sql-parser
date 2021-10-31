alter table db1.table1 add primary key(id);

alter table db1.table1 drop primary key;

alter table db1.table1 drop unique(name,age);

alter table db1.table1 drop constraint idx_1;

alter table db1.table1 drop primary key drop unique(name,age);

alter table db1.table1 drop primary key drop unique(name,age) drop constraint idx_1;

alter table db1.table1 rename constraint idx_1 to idx_2;