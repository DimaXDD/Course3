/*9*/
create table TDS_t (
    x number(3) primary key, 
    s varchar(50)
);

/*11*/
insert into TDS_t(x, s) values (1, 'test1');
insert into TDS_t(x, s) values (2, 'test2');
insert into TDS_t(x, s) values (3, 'test3');
commit;
select * from TDS_t;

/*12*/
update TDS_t set x = 20, s = 'test20' where x = 2;
update TDS_t set x = 30, s = 'test30' where x = 3;
commit;
select * from TDS_t;

/*13*/
select s from TDS_t;
select avg(x) from TDS_t;
select count(*) from TDS_t;

/*14*/
delete TDS_t where x = 30;
commit;

/*15*/
create table TDS_t1(
    MyNumber number(3),
    info varchar(50),
    foreign key (MyNumber) references TDS_t(x)
);

insert into TDS_t1(MyNumber, info) values (1, 'test_info');
select * from TDS_t1;
commit;

/*16*/
select * from TDS_t left join TDS_t1 on TDS_t.x = MyNumber;
select * from TDS_t right join TDS_t1 on TDS_t.x = MyNumber;

/*18*/
drop table TDS_t;
drop table TDS_t1;