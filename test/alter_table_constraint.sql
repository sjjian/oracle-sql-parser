alter table db1.table1 add primary key(id);

alter table db1.table1 drop primary key;

alter table db1.table1 drop unique(name,age);

alter table db1.table1 drop constraint idx_1;

alter table db1.table1 drop primary key drop unique(name,age);

alter table db1.table1 drop primary key drop unique(name,age) drop constraint idx_1;

alter table db1.table1 rename constraint idx_1 to idx_2;

alter table db1.table1 modify primary key using index;

alter table db1.table1 modify primary key rely using index idx_1 enable validate;

alter table db1.table1 drop primary key keep index;

alter table db1.table1 drop primary key keep index drop unique(name,age) drop index;