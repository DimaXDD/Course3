create database TDS;
use TDS;
-- DROP TABLE FACULTY
CREATE TABLE FACULTY
  (
   FACULTY      NCHAR(10)      NOT NULL,
   FACULTY_NAME NVARCHAR(50),
   CONSTRAINT PK_FACULTY PRIMARY KEY(FACULTY)
  );

-- delete FACULTY;
insert into FACULTY   (FACULTY,   FACULTY_NAME )
             values  (N'����', N'����������� ���� � ����������');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'����', N'���������� ���������� � �������');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'���', N'����������������� ���������');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'���', N'���������-������������� ���������');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'����', N'���������� � ������� ������ ��������������');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  (N'���', N'���������� ������������ �������');

--------------------------------------------------------------------------------------------
-- DROP TABLE PULPIT
CREATE TABLE PULPIT
(
 PULPIT       NCHAR(10)      NOT NULL,
 PULPIT_NAME  NVARCHAR(100),
 FACULTY      NCHAR(10)      NOT NULL,
 CONSTRAINT FK_PULPIT_FACULTY FOREIGN KEY(FACULTY)   REFERENCES FACULTY(FACULTY),
 CONSTRAINT PK_PULPIT PRIMARY KEY(PULPIT)
 );

-- delete PULPIT;
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY )
             values  (N'����', N'������������� ������ � ���������� ', N'����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY )
             values  (N'������', N'���������������� ������������ � ������ ��������� ���������� ', N'����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
              values  (N'��', N'�����������', N'���') ;
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'��', N'������������', N'���') ;
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'��', N'��������������', N'���');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'�����', N'���������� � ����������������', N'���');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'������', N'������������ �������������� � ������-��������� �������������', N'���');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'��', N'���������� ����', N'����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'�����', N'������ ����� � ���������� �������������', N'����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  (N'��', N'������������ �����', N'���');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                              FACULTY)
             values  (N'��������', N'���������� ���������������� ������� � ����������� ���������� ����������', N'���');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                      FACULTY)
             values  (N'�������', N'���������� �������������� ������� � ����� ���������� ���������� ', N'����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                                         FACULTY)
             values  (N'��������', N'�����, ���������� ����������������� ����������� � ���������� ����������� �������',
                      N'����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                      FACULTY)
             values  (N'����', N'������������� ������ � ����������', N'���');

insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                      FACULTY)
             values  (N'����', N'����������� � ��������� ������������������', N'���');
------------------------------------------------------------------------------------------------------------------------        - DROP  TABLE TEACHER
CREATE TABLE TEACHER
 (
  TEACHER       NCHAR(10) NOT  NULL,
  TEACHER_NAME  NVARCHAR(50),
  PULPIT        NCHAR(10) NOT NULL,
  CONSTRAINT PK_TEACHER  PRIMARY KEY(TEACHER),
  CONSTRAINT FK_TEACHER_PULPIT FOREIGN   KEY(PULPIT)   REFERENCES PULPIT(PULPIT)
 ) ;


-- delete  TEACHER;
insert into  TEACHER    (TEACHER,   TEACHER_NAME, PULPIT )
                       values  (N'����', N'������ �������� �������������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'�����', N'�������� ��������� ��������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'�����', N'���������� ������ ����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������ ���� �����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������� �������� ��������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'�����', N'�������� ������ ���������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'���', N'����� ��������� ����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'���', N'������� ��������� �����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'���', N'��������� ����� ��������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'��������� ������� ����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'������', N'����������� ������� ����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  ('?', N'�����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                      values  (N'���', N'����� ������� ��������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'���', N'����� ������� �������������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'������', N'���������� ��������� �������������', N'������');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'�����', N'������� ������ ����������', N'������');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'������', N'����������� ��������� ��������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������� ��������� ����������', N'����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������ ������ ��������', N'��');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������� ������ ����������', N'������');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'������', N'���������� �������� ��������', N'��');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'���', N'������ ���������� ������������', N'��');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'�����', N'��������� �������� ���������', N'�����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'������', N'���������� �������� ����������', N'��');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )

values  (N'������', N'��������� ������� ���������', N'��������');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'�����', N'�������� ������ ����������', N'��');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'���', N'����� ������ ��������', N'�����');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������ ������� ���������', N'�������');
insert into  TEACHER    (TEACHER,  TEACHER_NAME, PULPIT )
                       values  (N'����', N'������� ���� ����������', N'��������');
---------------------------------------------------------------------------------------------------------------------
-- DROP TABLE SUBJECT
CREATE TABLE SUBJECT
    (
     SUBJECT      NCHAR(10)     NOT NULL,
     SUBJECT_NAME NVARCHAR(50)  NOT NULL,
     PULPIT       NCHAR(10)     NOT NULL,
     CONSTRAINT PK_SUBJECT PRIMARY KEY(SUBJECT),
     CONSTRAINT FK_SUBJECT_PULPIT FOREIGN  KEY(PULPIT)  REFERENCES PULPIT(PULPIT)
    );

-- delete SUBJECT;
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'����', N'������� ���������� ������ ������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT)
                       values (N'��', N'���� ������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'�������������� ����������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'����', N'������ �������������� � ����������������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'������������� ������ � ������������ ��������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'��������������� ������� ����������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'����', N'������������� ������ ��������� ����������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'�������������� �������������� ������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'������������ ��������� ', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'�����', N'��������������� ������, �������� � �������� �����', N'������');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'������������ �������������� �������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'����������� ���������������� ������������', N'������');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,                            PULPIT)
               values (N'��', N'���������� ���������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,                             PULPIT )
               values (N'��', N'�������������� ����������������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,                             PULPIT )
               values (N'����', N'���������� ������ ���', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,                             PULPIT )
               values (N'���', N'��������-��������������� ����������������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'��������� ������������������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'������������� ������', N'����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'������OO', N'�������� ������ ������ � ���� � ���. ������.', N'��');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )

values (N'�������', N'������ ��������������� � ������������� ���������', N'������');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'���������� �������� ', N'��');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'�����������', N'�����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'��', N'������������ �����', N'��');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'���������� ��������� �������', N'��������');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'������ ��������� ����', N'��');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'����', N'���������� � ������������ �������������', N'�����');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'����', N'���������� ���������� �������� ���������� ', N'�������');
insert into SUBJECT   (SUBJECT,   SUBJECT_NAME,        PULPIT )
                       values (N'���', N'���������� ������������', N'��������');
---------------------------------------------------------------------------------------------------------------------
-- DROP TABLE AUDITORIUM_TYPE
create table AUDITORIUM_TYPE
(
  AUDITORIUM_TYPE   NCHAR(10) constraint AUDITORIUM_TYPE_PK  primary key,
  AUDITORIUM_TYPENAME  NVARCHAR(30) constraint AUDITORIUM_TYPENAME_NOT_NULL unique
);

-- delete AUDITORIUM_TYPE;
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,   AUDITORIUM_TYPENAME )
                       values  (N'��', N'����������');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,   AUDITORIUM_TYPENAME )
                       values  (N'��-�', N'������������ �����');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,   AUDITORIUM_TYPENAME )
                       values  (N'��-�', N'���������� � ���. ������������');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,   AUDITORIUM_TYPENAME )
                       values  (N'��-X', N'���������� �����������');
insert into AUDITORIUM_TYPE   (AUDITORIUM_TYPE,   AUDITORIUM_TYPENAME )
                       values  (N'��-��', N'����. ������������ �����');
---------------------------------------------------------------------------------------------------------------------
-- DROP TABLE AUDITORIUM
create table AUDITORIUM
(
 AUDITORIUM           NCHAR(10) primary key,  -- ��� ���������
 AUDITORIUM_NAME      NVARCHAR(200),          -- ���������
 AUDITORIUM_CAPACITY  INTEGER,              -- �����������
 AUDITORIUM_TYPE      NCHAR(10) not null      -- ��� ���������
                      references AUDITORIUM_TYPE(AUDITORIUM_TYPE)
);

-- delete  AUDITORIUM;
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('206-1', '206-1', N'��-�', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
                       values  ('301-1', '301-1', N'��-�', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('236-1', '236-1', N'��', 60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('313-1', '313-1', N'��', 60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('324-1', '324-1', N'��', 50);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('413-1', '413-1', N'��-�', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('423-1', '423-1', N'��-�', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('408-2', '408-2', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('103-4', '103-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('105-4', '105-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('107-4', '107-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('110-4', '110-4', N'��', 30);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('111-4', '111-4', N'��', 30);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                      values  ('114-4', '114-4', N'��-�', 90 );
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values ('132-4', '132-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values (N'02�-4', N'02�-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values ('229-4', '229-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('304-4', '304-4', N'��-�', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('314-4', '314-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('320-4', '320-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('429-4', '429-4', N'��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                        values  ('?', '???', N'��', 90);
-----------------------------------------------------------------------------------------------------------------------
ALTER TABLE AUDITORIUM
ADD CONSTRAINT FK_AUDITORIUM_AUDITORIUM_TYPE FOREIGN KEY (AUDITORIUM_TYPE)
REFERENCES AUDITORIUM_TYPE
ON DELETE CASCADE
GO

ALTER TABLE SUBJECT
DROP CONSTRAINT FK_SUBJECT_PULPIT
GO

ALTER TABLE SUBJECT
ADD CONSTRAINT FK_SUBJECT_PULPIT FOREIGN KEY (PULPIT)
REFERENCES PULPIT
ON DELETE CASCADE
GO

ALTER TABLE TEACHER
DROP CONSTRAINT FK_TEACHER_PULPIT
GO

ALTER TABLE TEACHER
ADD CONSTRAINT FK_TEACHER_PULPIT FOREIGN KEY (PULPIT)
REFERENCES PULPIT
ON DELETE CASCADE
GO

ALTER TABLE PULPIT
DROP CONSTRAINT FK_PULPIT_FACULTY
GO

ALTER TABLE PULPIT
ADD CONSTRAINT FK_PULPIT_FACULTY FOREIGN KEY (FACULTY)
REFERENCES FACULTY
ON DELETE CASCADE
GO