CREATE DATABASE Lab4;
USE Lab4;

-- Просмотр схем БД
SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA
--geometry - тип данных для пространственных объектов

-- 6. Определите тип пространственных данных во всех таблицах
-- Эти данные описывают местоположение объектов в пространстве
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'

-- 7. Определите SRID - идентификатор системы координат
SELECT srid FROM dbo.geometry_columns

-- 8. Определите атрибутивные столбцы
-- Содержат информацию об атрибутах (характеристиках) географических объектов
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE != 'geometry'

-- 9. Верните описания пространственных объектов в формате WKT
-- Текстовый формат для представления геометрических объектов в пространстве
SELECT geom.STAsText() AS WKT_Description
FROM ne_110m_geography_regions_polys

-- 10
select * from ne_110m_geography_regions_polys

-- 10.1. Нахождение пересечения пространственных объектов;
-- Определение области, общей для двух или более пространственных объектов.
SELECT obj1.geom.STIntersection(obj2.geom) AS Intersection
FROM ne_110m_geography_regions_polys obj1, ne_110m_geography_regions_polys obj2
WHERE obj1.qgs_fid = 24 AND obj2.qgs_fid = 28

-- 10.2. Нахождение координат вершин пространственного объектов
SELECT geom.STPointN(1).ToString() AS VertexCoordinates
FROM ne_110m_geography_regions_polys
WHERE qgs_fid = 24

-- 10.3. Нахождение площади пространственных объектов;
-- Площадь (Area): Измерение площади замкнутых объектов, таких как полигоны.
SELECT geom.STArea() AS ObjectArea
FROM ne_110m_geography_regions_polys
WHERE qgs_fid = 24

-- 11. Создайте пространственный объект в виде точки (1) /линии (2) /полигона (3).
-- Точка:
DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(25 25)', 0);
SELECT @pointGeometry AS PointGeometry;

-- Линия:
DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(20 5, 5 20)', 0);
SELECT @lineGeometry AS LineGeometry;

-- Полигон:
DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((15 15, 30 25, 45 15, 40 30, 45 35, 30 55, 15 35, 20 30, 15 15))', 0);
SELECT @polygonGeometry AS StarGeometry;

-- 12. Найдите, в какие пространственные объекты попадают созданные вами объекты
-- Точка и полигон
DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(25 25)', 0);
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((15 15, 30 25, 45 15, 40 30, 45 35, 30 45, 15 35, 20 30, 15 15))', 0);

-- Определение, в какой полигон попадает точка
SELECT @polygon.STContains(@point) AS PointInsidePolygon;

-- Прямая и полигон
DECLARE @line GEOMETRY = GEOMETRY::STGeomFromText('LINESTRING(20 5, 5 20)', 0);
DECLARE @polygonn GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((15 15, 30 25, 45 15, 40 30, 45 35, 30 45, 15 35, 20 30, 15 15))', 0);

-- Определение, пересекается ли прямая с полигоном
SELECT @line.STIntersects(@polygonn) AS LineIntersectsPolygon;

-- Полигон с картой
-- Предположим, у вас есть таблица с полигонами, назовем ее ne_110m_geography_regions_polys
DECLARE @mapPolygon GEOMETRY;
SELECT @mapPolygon = geom
FROM ne_110m_geography_regions_polys
WHERE geom.STIntersects(@polygon) = 1;

SELECT @mapPolygon AS MapPolygonIntersectingGivenPolygon;


-- 13. Продемонстрируйте индексирование пространственных объектов.
CREATE SPATIAL INDEX Geometry_index_spatial
ON ne_110m_geography_regions_polys(geom)
USING GEOMETRY_GRID
WITH (
  BOUNDING_BOX = (-180, -90, 180, 90)
);

SELECT *
FROM ne_110m_geography_regions_polys WITH(INDEX(Geometry_index_spatial))
WHERE geom.STIntersects(geometry::STGeomFromText('POLYGON((-100 30, -90 30, -90 40, -100 40, -100 30))', 4326)) = 1;


-- 14. Разработайте хранимую процедуру, которая принимает координаты точки и 
-- возвращает пространственный объект, в который эта точка попадает.
CREATE OR ALTER PROCEDURE PointCheckProc
    @x FLOAT,
    @y FLOAT
AS
BEGIN
    DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(' + CAST(@x AS VARCHAR) + ' ' + CAST(@y AS VARCHAR) + ')', 0);
    DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((15 15, 30 25, 45 15, 40 30, 45 35, 30 40, 15 35, 20 30, 15 15))', 0);

    SELECT @point.STWithin(@polygon) AS PointWithinPolygon;
END;
GO

EXEC PointCheckProc 16, 16;