create database rus_bel;
use rus_bel;

create table dict_rus_bel (
                              word nvarchar(50),
                              translate nvarchar(50)
);


insert into dict_rus_bel values ('ночь', 'ноч');
insert into dict_rus_bel values ('спасибо', 'дзякуй');
