ALTER SESSION SET nls_date_format = 'DD-MM-YY';
DROP TABLE ticker;

CREATE TABLE ticker (
        SYMBOL VARCHAR2(10), 
        tstamp DATE, 
        price NUMBER);

INSERT INTO ticker VALUES('ACME', '01-04-23', 12);
INSERT INTO ticker VALUES('GLOBEX', '17-04-23', 8);
INSERT INTO ticker VALUES('GLOBEX', '01-04-23', 11);
INSERT INTO ticker VALUES('OSCORP', '20-04-23', 9);
INSERT INTO ticker VALUES('ACME', '02-04-23', 17);
INSERT INTO ticker VALUES('OSCORP', '19-04-23', 23);
INSERT INTO ticker VALUES('ACME', '03-04-23', 19);
INSERT INTO ticker VALUES('GLOBEX', '03-04-23', 13);
INSERT INTO ticker VALUES('OSCORP', '18-04-23', 12);
INSERT INTO ticker VALUES('GLOBEX', '02-04-23', 12);
INSERT INTO ticker VALUES('ACME', '04-04-23', 21);
INSERT INTO ticker VALUES('GLOBEX', '04-04-23', 12);
INSERT INTO ticker VALUES('OSCORP', '17-04-23', 14);
INSERT INTO ticker VALUES('OSCORP', '15-04-23', 12);
INSERT INTO ticker VALUES('OSCORP', '14-04-23', 15);
INSERT INTO ticker VALUES('OSCORP', '16-04-23', 16);
INSERT INTO ticker VALUES('ACME', '05-04-23', 25);
INSERT INTO ticker VALUES('GLOBEX', '05-04-23', 23);
INSERT INTO ticker VALUES('ACME', '06-04-23', 12);
INSERT INTO ticker VALUES('GLOBEX', '06-04-23', 10);
INSERT INTO ticker VALUES('ACME', '07-04-23', 15);
INSERT INTO ticker VALUES('GLOBEX', '07-04-23', 9);
INSERT INTO ticker VALUES('GLOBEX', '08-04-23', 8);
INSERT INTO ticker VALUES('ACME', '08-04-23', 20);
INSERT INTO ticker VALUES('OSCORP', '13-04-23', 23);
INSERT INTO ticker VALUES('ACME', '13-04-23', 25);
INSERT INTO ticker VALUES('ACME', '10-04-23', 25);
INSERT INTO ticker VALUES('ACME', '23-04-23', 19);
INSERT INTO ticker VALUES('ACME', '09-04-23', 24);
INSERT INTO ticker VALUES('GLOBEX', '09-04-23', 9);
INSERT INTO ticker VALUES('OSCORP', '12-04-23', 12);
INSERT INTO ticker VALUES('GLOBEX', '10-04-23', 9);
INSERT INTO ticker VALUES('OSCORP', '23-04-23', 15);
INSERT INTO ticker VALUES('GLOBEX', '23-04-23', 9);
INSERT INTO ticker VALUES('OSCORP', '10-04-23', 15);
INSERT INTO ticker VALUES('ACME', '12-04-23', 15);
INSERT INTO ticker VALUES('GLOBEX', '12-04-23', 9);
INSERT INTO ticker VALUES('OSCORP', '09-04-23', 16);
INSERT INTO ticker VALUES('GLOBEX', '13-04-23', 10);
INSERT INTO ticker VALUES('OSCORP', '08-04-23', 20);
INSERT INTO ticker VALUES('ACME', '14-04-23', 25);
INSERT INTO ticker VALUES('GLOBEX', '14-04-23', 23);
INSERT INTO ticker VALUES('OSCORP', '07-04-23', 17);
INSERT INTO ticker VALUES('OSCORP', '06-04-23', 20);
INSERT INTO ticker VALUES('ACME', '15-04-23', 14);
INSERT INTO ticker VALUES('GLOBEX', '15-04-23', 12);
INSERT INTO ticker VALUES('ACME', '17-04-23', 14);
INSERT INTO ticker VALUES('ACME', '16-04-23', 12);
INSERT INTO ticker VALUES('GLOBEX', '16-04-23', 23);
INSERT INTO ticker VALUES('OSCORP', '05-04-23', 17);
INSERT INTO ticker VALUES('ACME', '18-04-23', 24);
INSERT INTO ticker VALUES('GLOBEX', '18-04-23', 7);
INSERT INTO ticker VALUES('OSCORP', '04-04-23', 18);
INSERT INTO ticker VALUES('OSCORP', '03-04-23', 19);
INSERT INTO ticker VALUES('ACME', '19-04-23', 23);
INSERT INTO ticker VALUES('GLOBEX', '19-04-23', 5);
INSERT INTO ticker VALUES('OSCORP', '02-04-23', 22);
INSERT INTO ticker VALUES('ACME', '20-04-23', 22);
INSERT INTO ticker VALUES('GLOBEX', '20-04-23', 3);
INSERT INTO ticker VALUES('OSCORP', '01-04-23', 22);

commit;


select * from ticker
match_recognize (
partition by symbol
order by tstamp
measures
A.tstamp as a_time,
B.tstamp as b_time,
C.tstamp as c_time,
D.tstamp as d_time,
E.tstamp as e_time,
A.price as a_price,
B.price as b_price,
C.price as c_price,
D.price as d_price,
E.price as e_price
one row per match
pattern (A B C D E)
define
B as A.price > B.price,
C as B.price < C.price,
D as B.price = D.price,
E as C.price <= E.price
) MR;