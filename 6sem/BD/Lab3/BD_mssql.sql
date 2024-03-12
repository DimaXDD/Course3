-- !!! Лучше очистите данные в таблице!!!
CREATE DATABASE TESTING;
USE TESTING;

-- Просто вывел таблицу, которую буду юзать в 3 лабе
CREATE TABLE Пользователь (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Имя NVARCHAR(100) NOT NULL,
    Фамилия NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    Пароль NVARCHAR(100) NOT NULL,
    Роль NVARCHAR(20) CHECK (Роль IN ('Студент', 'Преподаватель', 'Администратор')) NOT NULL,
    Данные NVARCHAR(100)
);

SELECT * FROM Пользователь;

-- 1. Для базы данных в СУБД SQL Server добавить для одной из таблиц столбец данных иерархического типа. 
ALTER TABLE Пользователь ADD HierarchyNode HIERARCHYID;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/') where ID = 1;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/1/') where ID = 2;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/2/') where ID = 3;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/3/') where ID = 4;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/1/1/') where ID = 5;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/1/2/') where ID = 6;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/3/1/') where ID = 7;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/3/2/') where ID = 8;

UPDATE Пользователь
SET HierarchyNode = HIERARCHYID::Parse('/3/3/') where ID = 9;

SELECT *, HierarchyNode.ToString() as HierarchyString FROM Пользователь;


-- 2. Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии (параметр – значение узла).
--drop PROCEDURE DisplaySubordinates

CREATE OR ALTER PROCEDURE DisplaySubordinates
    @NodeHierarchy HIERARCHYID
AS
BEGIN
    SELECT *, HierarchyNode.ToString() AS HierarchyPath
    FROM Пользователь
    WHERE HierarchyNode.IsDescendantOf(@NodeHierarchy) = 1 -- проверка является ли потомком
    ORDER BY HierarchyNode;
END;
GO

DECLARE @NodeHierarchy HIERARCHYID = '/';
EXEC DisplaySubordinates @NodeHierarchy;

SELECT *, HierarchyNode.ToString() as HierarchyString FROM Пользователь;

-- 3. Создать процедуру, которая добавит подчиненный узел (параметр – значение родительского узла).
-- drop PROCEDURE AddSubordinate
CREATE OR ALTER PROCEDURE AddSubordinate
    @ParentNodeHierarchy HIERARCHYID,
    @NewNodeName NVARCHAR(100),
    @NewNodeSurname NVARCHAR(100),
    @NewNodeMail NVARCHAR(100),
    @NewNodePassword NVARCHAR(100),
    @NewNodeRole NVARCHAR(20),
    @NewNodeData NVARCHAR(100)
AS
BEGIN
    DECLARE @NewNode HIERARCHYID;
    DECLARE @LastChild HIERARCHYID;

    BEGIN TRY
        SELECT @LastChild = MAX(HierarchyNode)
        FROM Пользователь
        WHERE HierarchyNode.GetAncestor(1) = @ParentNodeHierarchy;

        SELECT @NewNode = @ParentNodeHierarchy.GetDescendant(@LastChild, NULL)
        FROM Пользователь
        WHERE HierarchyNode = @ParentNodeHierarchy;

        INSERT INTO Пользователь(HierarchyNode, Имя, Фамилия, email, Пароль, Роль, Данные)
        VALUES (@NewNode, @NewNodeName, @NewNodeSurname, @NewNodeMail, HASHBYTES('SHA2_256', @NewNodePassword), @NewNodeRole, @NewNodeData);
    END TRY
    BEGIN CATCH
        PRINT 'Ошибка: Невозможно добавить уже существующую иерархию.';
    END CATCH
END;
GO


DECLARE @ParentNodeHierarchy HIERARCHYID = '/4/';
DECLARE @NewNodeName NVARCHAR(100) = 'Дмитрий';
DECLARE @NewNodeSurname NVARCHAR(100) = 'Денисенко';
DECLARE @NewNodeEmail NVARCHAR(100) = 'test14@mail.ru';
DECLARE @NewNodePassword NVARCHAR(100) = 'test14';
DECLARE @NewNodeRole NVARCHAR(20) = 'Студент';
DECLARE @NewNodeData NVARCHAR(100) = 'Тест 14';

EXEC AddSubordinate @ParentNodeHierarchy, @NewNodeName, @NewNodeSurname, @NewNodeEmail, @NewNodePassword, @NewNodeRole, @NewNodeData;

SELECT *, HierarchyNode.ToString() as HierarchyString FROM Пользователь;

-- 4.  Создать процедуру, которая переместит всех подчиненных (первый параметр – значение родительского узла, 
-- подчиненные которого будут перемещаться, второй параметр – значение нового родительского узла).
CREATE OR ALTER PROCEDURE MoveSubordinates
    @OldParentNodeHierarchy HIERARCHYID,
    @NewParentNodeHierarchy HIERARCHYID
AS
BEGIN
    DECLARE @NewChildNode HIERARCHYID;
    DECLARE @MaxChildNode HIERARCHYID;
    DECLARE @CurrentChildNode HIERARCHYID;
    DECLARE @ChildNodesCursor CURSOR;

    BEGIN TRY
        SET @ChildNodesCursor = CURSOR FOR
        SELECT HierarchyNode
        FROM Пользователь
        WHERE HierarchyNode.GetAncestor(1) = @OldParentNodeHierarchy
        ORDER BY HierarchyNode;

        OPEN @ChildNodesCursor;

        FETCH NEXT FROM @ChildNodesCursor INTO @CurrentChildNode;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @MaxChildNode = MAX(HierarchyNode)
            FROM Пользователь
            WHERE HierarchyNode.GetAncestor(1) = @NewParentNodeHierarchy;

            SET @NewChildNode = @NewParentNodeHierarchy.GetDescendant(@MaxChildNode, NULL);

            UPDATE Пользователь
            SET HierarchyNode = @NewChildNode
            WHERE HierarchyNode = @CurrentChildNode;

            FETCH NEXT FROM @ChildNodesCursor INTO @CurrentChildNode;
        END;

        CLOSE @ChildNodesCursor;
        DEALLOCATE @ChildNodesCursor;

        PRINT 'Узлы успешно перемещены.';
    END TRY
    BEGIN CATCH
        PRINT 'Ошибка: Невозможно переместить узлы.';
    END CATCH
END;
GO

SELECT *, HierarchyNode.ToString() as HierarchyString FROM Пользователь;

DECLARE @OldParentNodeHierarchy HIERARCHYID = '/3/';
DECLARE @NewParentNodeHierarchy HIERARCHYID = '/4/';
EXEC MoveSubordinates @OldParentNodeHierarchy, @NewParentNodeHierarchy;

SELECT *, HierarchyNode.ToString() as HierarchyString FROM Пользователь;