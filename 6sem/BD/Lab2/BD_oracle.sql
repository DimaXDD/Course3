CREATE SEQUENCE seq_������������ START WITH 1;
CREATE SEQUENCE seq_���� START WITH 1;
CREATE SEQUENCE seq_������ START WITH 1;
CREATE SEQUENCE seq_����� START WITH 1;
CREATE SEQUENCE seq_���������_����� START WITH 1;

drop SEQUENCE seq_������������;
drop SEQUENCE seq_����;
drop SEQUENCE seq_������;
drop SEQUENCE seq_�����;
drop SEQUENCE seq_���������_�����;

drop table ���������_�����;
drop table �����;
drop table ������;
drop table ����;
drop table ������������;

-- ERROR: ���� ��������� ������, ��� ������ ������ �������� �� ��������,
-- ������� ����������� SYS, �� ������:
-- 1) ������������ �� ��� SYS (���������)
-- 2) ����� ���� ������� �����, ���� ����� � ������� ��� �� �� (��� ������)
-- 3) ���� ��������� default (����� � ���� � ���� ����� ������ ��������)

CREATE TABLE ������������ (
    ID NUMBER PRIMARY KEY,
    ��� NVARCHAR2(100) NOT NULL,
    ������� NVARCHAR2(100) NOT NULL,
    email NVARCHAR2(100) NOT NULL,
    ������ NVARCHAR2(100) NOT NULL,
    ���� NVARCHAR2(20) CHECK (���� IN ('�������', '�������������', '�������������')) NOT NULL,
    ������ NVARCHAR2(100)
);

CREATE TRIGGER trg_������������
BEFORE INSERT ON ������������
FOR EACH ROW
BEGIN
  SELECT seq_������������.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE ���� (
    ID NUMBER PRIMARY KEY,
    �������� NVARCHAR2(100) NOT NULL,
    �������� NVARCHAR2(255) NOT NULL,
    ������� NVARCHAR2(100) NOT NULL,
	ID_������������ NUMBER REFERENCES ������������(ID) NOT NULL
);

CREATE TRIGGER trg_����
BEFORE INSERT ON ����
FOR EACH ROW
BEGIN
  SELECT seq_����.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE ������ (
    ID NUMBER PRIMARY KEY,
    ����� NVARCHAR2(255) NOT NULL,
    ID_����� NUMBER REFERENCES ����(ID) NOT NULL
);

CREATE TRIGGER trg_������
BEFORE INSERT ON ������
FOR EACH ROW
BEGIN
  SELECT seq_������.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE ����� (
    ID NUMBER PRIMARY KEY,
    ����� NVARCHAR2(255) NOT NULL,
    ���������� NUMBER(1) NOT NULL,
    ID_������� NUMBER REFERENCES ������(ID) NOT NULL
);

CREATE TRIGGER trg_�����
BEFORE INSERT ON �����
FOR EACH ROW
BEGIN
  SELECT seq_�����.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE ���������_����� (
    ID NUMBER PRIMARY KEY,
    ID_������������ NUMBER REFERENCES ������������(ID) NOT NULL,
    ID_����� NUMBER REFERENCES ����(ID) NOT NULL,
    ����_�_����� DATE NOT NULL,
    ��������_���� FLOAT NOT NULL
);

CREATE TRIGGER trg_���������_�����
BEFORE INSERT ON ���������_�����
FOR EACH ROW
BEGIN
  SELECT seq_���������_�����.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE INDEX IX_������������_���_������� ON ������������ (���, �������);
CREATE INDEX IX_����_������� ON ���� (�������);
CREATE INDEX IX_������_ID_����� ON ������ (ID_�����);
CREATE INDEX IX_�����_ID_������� ON ����� (ID_�������);
CREATE INDEX IX_���������_�����_ID_������������ ON ���������_����� (ID_������������);

-- INFO: ����� �� � ����� ��� ������ ����������� �������, �� ���� ���, ��
-- ��������� ������� ���� � ������ ����� ������ ����� (��������� �� SYS)
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO C##TDS;

-- �������� (���� 1 - �� ���������, ���� 0 - �� ���)
SELECT COUNT(*)
FROM all_objects
WHERE object_name = 'DBMS_CRYPTO' AND object_type = 'PACKAGE';
-- ============================== ����������� ==============================
CREATE OR REPLACE PROCEDURE ����������� (
    p_��� IN ������������.���%TYPE,
    p_������� IN ������������.�������%TYPE,
    p_Email IN ������������.Email%TYPE,
    p_������ IN ������������.������%TYPE,
    p_���� IN ������������.����%TYPE,
    p_������ IN ������������.������%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���������������������� NUMBER;
    v_���_������ VARCHAR2(100); -- �������� �� VARCHAR2 � ������������ ������ 100 ��������
BEGIN
    SELECT COUNT(*)
    INTO v_����������������������
    FROM ������������
    WHERE Email = p_Email;

    IF v_���������������������� = 0 THEN
        IF REGEXP_LIKE(p_Email, '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            IF p_���� IN ('�������', '�������������', '�������������') THEN
                v_���_������ := SUBSTR(UTL_RAW.CAST_TO_RAW(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_������, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256)), 1, 100);
                INSERT INTO ������������ (���, �������, Email, ������, ����, ������)
                VALUES (p_���, p_�������, p_Email, v_���_������, p_����, p_������);
                p_Result := 1;
                p_Message := '����������� ������ �������.';
            ELSE
                p_Result := 0;
                p_Message := '������������ ����. ���� ������ ���� ���� �������, ���� �������������, ���� �������������.';
            END IF;
        ELSE
            p_Result := 0;
            p_Message := '������������ ������ email.';
        END IF;
    ELSE
        p_Result := 0;
        p_Message := '������������ � ����� email ��� ����������.';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END �����������;
/

-- ============================== ����������� ==============================
CREATE OR REPLACE PROCEDURE ����������� (
    p_Email IN ������������.Email%TYPE,
    p_������ IN ������������.������%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���_������ VARCHAR2(100); -- �������� �� VARCHAR2 � ������������ ������ 100 ��������
BEGIN
    SELECT ������
    INTO v_���_������
    FROM ������������
    WHERE Email = p_Email;

    IF SUBSTR(UTL_RAW.CAST_TO_RAW(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_������, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256)), 1, 100) = v_���_������ THEN
        p_Result := 1;
        p_Message := '����������� ������ �������.';
    ELSE
        p_Result := 0;
        p_Message := '�������� email ��� ������.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := '�������� email ��� ������.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END �����������;
/

-- ============================== ������� ����������� � ����������� ==============================
DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    �����������('Dmitry', 'Trubach', 'dima1@mail.ru', 'dima123', '�������', '���� 1', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    
    v_Result := NULL; -- �������� ���������� ����� ��������� �������
    v_Message := NULL;
    
    �����������('Prepod', 'Prepod', 'dima2@mail.ru', 'dima1234', '�������������', '���� 2', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    
    v_Result := NULL;
    v_Message := NULL;
    
    �����������('��������', '������', 'dima3@mail.ru', 'dima12345', '�������������', '���� 3', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    
    v_Result := NULL;
    v_Message := NULL;
    
    �����������('admin', 'admin', 'dima4@mail.ru', 'dima123456', '�������������', '���� 3', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

SELECT * FROM ������������;

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    �����������('dima1@mail.ru', 'dima123', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

-- ============================== ����������, �������������� � �������� ����� ==============================

-- ============================== �������� ���������� �������� (<=5) ==============================
CREATE OR REPLACE TRIGGER ��������_����������_��������
BEFORE INSERT ON ������
FOR EACH ROW
DECLARE
    ����������_�������� NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO ����������_��������
    FROM ������
    WHERE ID_����� = :NEW.ID_�����;

    IF ����������_�������� >= 5 THEN
        RAISE_APPLICATION_ERROR(-20001, '������������ ���������� �������� � ����� ���������� 5.');
    END IF;
END;
/

-- ============================== �������� ���� ==============================
CREATE OR REPLACE PROCEDURE ��������_���� (
    p_ID IN ����.ID%TYPE,
    p_�������� IN ����.��������%TYPE,
    p_�������� IN ����.��������%TYPE,
    p_������� IN ����.�������%TYPE,
    p_ID_������������ IN ����.ID_������������%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���� ������������.����%TYPE;
BEGIN
    SELECT ����
    INTO v_����
    FROM ������������
    WHERE ID = p_ID_������������;

    IF v_���� = '�������������' THEN
        INSERT INTO ���� (ID, ��������, ��������, �������, ID_������������)
        VALUES (p_ID, p_��������, p_��������, p_�������, p_ID_������������);
        p_Result := 1;
        p_Message := '���� ������� ��������.';
    ELSE
        p_Result := 0;
        p_Message := '������������ ���� ��� ���������� �����.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := '������������ ���� ��� ���������� �����.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END ��������_����;
/

-- ============================== ������������� ���� ==============================
CREATE OR REPLACE PROCEDURE �������������_���� (
    p_ID IN ����.ID%TYPE,
    p_�������� IN ����.��������%TYPE,
    p_�������� IN ����.��������%TYPE,
    p_������� IN ����.�������%TYPE,
    p_ID_������������ IN ����.ID_������������%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���� ������������.����%TYPE;
BEGIN
    SELECT ����
    INTO v_����
    FROM ������������
    WHERE ID = p_ID_������������;

    IF v_���� = '�������������' THEN
        UPDATE ����
        SET �������� = p_��������, �������� = p_��������, ������� = p_�������
        WHERE ID = p_ID;
        p_Result := 1;
        p_Message := '���� ������� ��������������.';
    ELSE
        p_Result := 0;
        p_Message := '������������ ���� ��� �������������� �����.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := '������������ ���� ��� �������������� �����.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END �������������_����;
/

-- ============================== ������� ���� ==============================
CREATE OR REPLACE PROCEDURE �������_���� (
    p_ID IN ����.ID%TYPE,
    p_ID_������������ IN ����.ID_������������%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���� ������������.����%TYPE;
BEGIN
    SELECT ����
    INTO v_����
    FROM ������������
    WHERE ID = p_ID_������������;

    IF v_���� = '�������������' THEN
        DELETE FROM ����
        WHERE ID = p_ID;
        p_Result := 1;
        p_Message := '���� ������� ������.';
    ELSE
        p_Result := 0;
        p_Message := '������������ ���� ��� �������� �����.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := '������������ ���� ��� �������� �����.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END �������_����;
/

-- ============================== �������� ���� ������ ==============================
CREATE OR REPLACE VIEW ���_����� AS
SELECT ID, ��������, ��������, �������
FROM ����;


select * from ����; -- ��� ��������� ID

SELECT * FROM ���_�����;


DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    ��������_����(1, '���� �1', '��������', '����������', 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    �������������_����(1, '���������� ���� 1', '���������� �������� ����� 1', '�����������', 1, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    �������_����(1, 1, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/


-- ============================== ���������� ������� ==============================
CREATE OR REPLACE PROCEDURE ��������_������ (
    p_ID IN ������.ID%TYPE,
    p_����� IN ������.�����%TYPE,
    p_ID_����� IN ������.ID_�����%TYPE,
    p_ID_������������ IN ������������.ID%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���� ������������.����%TYPE;
    v_����_�����������_������������ NUMBER;
BEGIN
    SELECT ����
    INTO v_����
    FROM ������������
    WHERE ID = p_ID_������������;

    IF v_���� = '�������������' THEN
        SELECT COUNT(*)
        INTO v_����_�����������_������������
        FROM ����
        WHERE ID = p_ID_����� AND ID_������������ = p_ID_������������;

        IF v_����_�����������_������������ > 0 THEN
            INSERT INTO ������ (ID, �����, ID_�����)
            VALUES (p_ID, p_�����, p_ID_�����);
            p_Result := 1;
            p_Message := '������ ������� ��������.';
        ELSE
            p_Result := 0;
            p_Message := '���� �� ����������� ������� ������������.';
        END IF;
    ELSE
        p_Result := 0;
        p_Message := '������������ ����. ������ ������������� ����� ��������� �������.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := '������������ ����. ������ ������������� ����� ��������� �������.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END ��������_������;
/

-- ============================== ���������� ������ ==============================
CREATE OR REPLACE PROCEDURE ��������_����� (
    p_ID IN �����.ID%TYPE,
    p_����� IN �����.�����%TYPE,
    p_���������� IN �����.����������%TYPE,
    p_ID_������� IN �����.ID_�������%TYPE,
    p_ID_������������ IN ������������.ID%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_���� ������������.����%TYPE;
    v_������_�����������_����� NUMBER;
BEGIN
    SELECT ����
    INTO v_����
    FROM ������������
    WHERE ID = p_ID_������������;

    IF v_���� = '�������������' THEN
        SELECT COUNT(*)
        INTO v_������_�����������_�����
        FROM ������
        JOIN ���� ON ������.ID_����� = ����.ID
        WHERE ������.ID = p_ID_������� AND ����.ID_������������ = p_ID_������������;

        IF v_������_�����������_����� > 0 THEN
            INSERT INTO ����� (ID, �����, ����������, ID_�������)
            VALUES (p_ID, p_�����, p_����������, p_ID_�������);
            p_Result := 1;
            p_Message := '����� ������� ��������.';
        ELSE
            p_Result := 0;
            p_Message := '������ �� ����������� ����� ������� ������������.';
        END IF;
    ELSE
        p_Result := 0;
        p_Message := '������������ ����. ������ ������������� ����� ��������� ������.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := '������������ ����. ������ ������������� ����� ��������� ������.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END ��������_�����;
/

select * from ������;

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(200);
BEGIN
    -- ID, �����, ID_�����, ID_�������
    ��������_������(1, '������ 1, ����� ��', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ������������, ID_�������, ID_�������
    ��������_�����(1, '��', 1, 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    ��������_�����(2, '���', 0, 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ID_�����, ID_�������
    ��������_������(2, '������ 2, ����� ��', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ������������, ID_�������, ID_�������
    ��������_�����(3, '��', 1, 2, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    ��������_�����(4, '���', 0, 2, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ID_�����, ID_�������
    ��������_������(3, '������ 3, ����� ���', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ������������, ID_�������, ID_�������
    ��������_�����(5, '��', 0, 3, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    ��������_�����(6, '���', 1, 3, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ID_�����, ID_�������
    ��������_������(4, '������ 4, ����� ���', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ������������, ID_�������, ID_�������
    ��������_�����(7, '��', 0, 4, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    ��������_�����(8, '���', 1, 4, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ID_�����, ID_�������
    ��������_������(5, '������ 5, ����� ��', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ������������, ID_�������, ID_�������
    ��������_�����(9, '��', 1, 5, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    ��������_�����(10, '���', 0, 5, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
END;
/

-- ���������� 6-�� ������� (�������� ��������)
DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(200);
BEGIN
    -- ID, �����, ID_�����, ID_�������
    ��������_������(6, '������ 6, ����� ���', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, �����, ������������, ID_�������, ID_�������
    ��������_�����(11, '��', 0, 6, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    ��������_�����(12, '���', 1, 6, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
END;
/

-- ============================== ����� ���������� � ����� ==============================
CREATE OR REPLACE FUNCTION ����������_�_����� (p_ID_����� IN NUMBER)
RETURN SYS_REFCURSOR IS
    v_��������� SYS_REFCURSOR;
BEGIN
    OPEN v_��������� FOR
    SELECT ��������, ��������
    FROM ����
    WHERE ID = p_ID_�����;
    
    RETURN v_���������;
END ����������_�_�����;
/


-- ============================== ����� �������� ����� ==============================
CREATE OR REPLACE FUNCTION �������_����� (p_ID_����� IN NUMBER)
RETURN SYS_REFCURSOR IS
    v_��������� SYS_REFCURSOR;
BEGIN
    OPEN v_��������� FOR
    SELECT ID, ����� AS "������"
    FROM ������
    WHERE ID_����� = p_ID_�����;
    
    RETURN v_���������;
END �������_�����;
/

-- ����� �������
DECLARE
    v_��������� SYS_REFCURSOR;
    v_�������� ����.��������%TYPE;
    v_�������� ����.��������%TYPE;
    v_ID ������.ID%TYPE;
    v_������ ������.�����%TYPE;
BEGIN
    -- ����� ������� ����������_�_�����
    v_��������� := ����������_�_�����(1);
    FETCH v_��������� INTO v_��������, v_��������;
    CLOSE v_���������;
    DBMS_OUTPUT.PUT_LINE('��������: ' || v_�������� || ', ��������: ' || v_��������);

    -- ����� ������� �������_�����
    v_��������� := �������_�����(1); -- �������� 1 �� ID �����
    LOOP
        FETCH v_��������� INTO v_ID, v_������;
        EXIT WHEN v_���������%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_ID || ', ������: ' || v_������);
    END LOOP;
    CLOSE v_���������;
END;
/

-- ============================== �������� ������� ==============================
CREATE OR REPLACE PROCEDURE ��������������� (
    ID_����� IN NUMBER,
    ID_������������ IN NUMBER,
    ������ IN VARCHAR2
) AS
    ������������������ NUMBER;
    ���������������� NUMBER;
    ������ NUMBER;
BEGIN
    -- ���������, ��� ���������� ������� ������������� ���������� �������� � �����
    SELECT COUNT(*) INTO ������������������ FROM ������ WHERE ID_����� = ID_�����;
    IF ������������������ <> REGEXP_COUNT(������, ',') + 1 THEN
        DBMS_OUTPUT.PUT_LINE('������: ���������� ������� �� ������������� ���������� �������� � �����.');
        RETURN;
    END IF;

    -- ���������� ������ � ����������� ��������
    FOR i IN 1..������������������ LOOP
        SELECT COUNT(*)
        INTO ����������������
        FROM ������
        INNER JOIN ����� ON ������.ID = �����.ID_�������
        WHERE ������.ID_����� = ID_�����
        AND �����.���������� = CASE
            WHEN REGEXP_SUBSTR(������, '[^,]+', 1, i) = '��' THEN 1
            WHEN REGEXP_SUBSTR(������, '[^,]+', 1, i) = '���' THEN 0
            ELSE NULL
        END;
    END LOOP;

    -- ��������� ������
    IF ���������������� = ������������������ THEN
        ������ := 10.0;
    ELSIF ���������������� = 0 THEN
        ������ := 0.0;
    ELSE
        ������ := 10.0 - ((1.0 / ������������������) * 10.0 * (������������������ - ����������������));
    END IF;

    -- ������� ���������� � ������
    DBMS_OUTPUT.PUT_LINE('������: ' || TO_CHAR(������));

    -- ��������� ���������� � ������� ���������_�����
    INSERT INTO ���������_����� (ID_������������, ID_�����, ����_�_�����, ��������_����)
    VALUES (ID_������������, ID_�����, SYSDATE, ������);
END;
/

BEGIN
    ���������������(1, 1, '��,���,��,��,��');
END;
/

SELECT * FROM ���������_�����;



CREATE OR REPLACE FUNCTION ������������� RETURN SYS_REFCURSOR IS
  rc  SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT ID, ID_������������, ID_�����, ����_�_�����, ��������_���� FROM ���������_�����;
  RETURN rc;
END;
/

CREATE OR REPLACE FUNCTION ���������������������� (p_ID_������������ INT) RETURN SYS_REFCURSOR IS
  rc  SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT ID, ID_������������, ID_�����, ����_�_�����, ��������_���� FROM ���������_����� WHERE ID_������������ = p_ID_������������;
  RETURN rc;
END;
/

CREATE OR REPLACE FUNCTION ��������������� (p_ID_����� INT) RETURN SYS_REFCURSOR IS
  rc  SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT ID, ID_������������, ID_�����, ����_�_�����, ��������_���� FROM ���������_����� WHERE ID_����� = p_ID_�����;
  RETURN rc;
END;
/


DECLARE
  rc  SYS_REFCURSOR;
  row ���������_�����%ROWTYPE;
BEGIN
  rc := �������������();
  DBMS_OUTPUT.PUT_LINE('ID, ID_������������, ID_�����, ����_�_�����, ��������_����');
  LOOP
    FETCH rc INTO row;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(row.ID || ', ' || row.ID_������������ || ', ' || row.ID_����� || ', ' || row.����_�_����� || ', ' || row.��������_����);
  END LOOP;
  CLOSE rc;
END;
/

DECLARE
  rc  SYS_REFCURSOR;
  row ���������_�����%ROWTYPE;
BEGIN
  rc := ����������������������(1);
  DBMS_OUTPUT.PUT_LINE('ID, ID_������������, ID_�����, ����_�_�����, ��������_����');
  LOOP
    FETCH rc INTO row;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(row.ID || ', ' || row.ID_������������ || ', ' || row.ID_����� || ', ' || row.����_�_����� || ', ' || row.��������_����);
  END LOOP;
  CLOSE rc;
END;
/

DECLARE
  rc  SYS_REFCURSOR;
  row ���������_�����%ROWTYPE;
BEGIN
  rc := ���������������(1);
  DBMS_OUTPUT.PUT_LINE('ID, ID_������������, ID_�����, ����_�_�����, ��������_����');
  LOOP
    FETCH rc INTO row;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(row.ID || ', ' || row.ID_������������ || ', ' || row.ID_����� || ', ' || row.����_�_����� || ', ' || row.��������_����);
  END LOOP;
  CLOSE rc;
END;
/

-- ============================== ��������� ������ � ������������ ==============================
CREATE OR REPLACE PROCEDURE ��������������������������(
    p_ID_������������ INT,
    p_ID_�������������� INT,
    p_�������� NVARCHAR2,
    p_������������ NVARCHAR2,
    p_�����Email NVARCHAR2,
    p_����������� NVARCHAR2,
    p_����������� NVARCHAR2
) AS
  v_count INT;
  v_���_������ VARCHAR2(100);
BEGIN
  SELECT COUNT(*) INTO v_count FROM ������������ WHERE ID = p_ID_�������������� AND ���� = '�������������';
  
  IF v_count = 1 THEN
    v_���_������ := SUBSTR(UTL_RAW.CAST_TO_RAW(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_�����������, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256)), 1, 100);
    UPDATE ������������
    SET ��� = p_��������,
        ������� = p_������������,
        email = p_�����Email,
        ������ = v_���_������,
        ������ = p_�����������
    WHERE ID = p_ID_������������;
    
    DBMS_OUTPUT.PUT_LINE('1, ������ ������������ ������� ���������.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('0, ������: ������ ������������� ����� �������� ������ ������������.');
  END IF;
END;
/


DECLARE
BEGIN
  ��������������������������(1, 4, 'Dmitry', 'Trubach', 'dima1@mail.ru', 'dima123', '���� 1');
END;
/

SELECT * FROM ������������;


-- ============================== ��������� ���� ==============================
CREATE OR REPLACE PROCEDURE ������������������������(
    p_ID_������������ IN ������������.ID%TYPE,
    p_ID_�������������� IN ������������.ID%TYPE,
    p_��������� IN ������������.����%TYPE
) AS
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count FROM ������������ WHERE ID = p_ID_�������������� AND ���� = '�������������';
  
  IF v_count = 1 THEN
    UPDATE ������������
    SET ���� = p_���������
    WHERE ID = p_ID_������������;
    
    DBMS_OUTPUT.PUT_LINE('1, ���� ������������ ������� ���������.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('0, ������: ������ ������������� ����� �������� ���� ������������.');
  END IF;
END;
/

DECLARE
  v_Result NUMBER;
  v_Message NVARCHAR2(100);
BEGIN
  ������������������������(2, 4, '�������������');
END;
/

SELECT * FROM ������������;




