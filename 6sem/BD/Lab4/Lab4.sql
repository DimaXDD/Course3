CREATE DATABASE Lab4;
USE Lab4;

SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA

--geometry - Этот тип данных используется для представления пространственных объектов в плоскости. Например, точки, линии, полигоны.

-- 6.	Определите тип пространственных данных во всех таблицах
-- Эти данные описывают местоположение объектов в пространстве и могут быть использованы для моделирования и анализа географических и пространственных явлений.
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
--
-- 7.	Определите SRID - идентификатор системы координат
-- Примеры SRID включают SRID 4326, который обозначает систему координат WGS 84 (широта/долгота), который используется для веб-карт в проекции Web Mercator.
--SELECT *
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = 'myPackage' AND DATA_TYPE = 'geometry'

SELECT srid FROM dbo.geometry_columns


-- 8.	Определите атрибутивные столбцы
-- содержат информацию об атрибутах (характеристиках) географических объектов
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE != 'geometry'

-- 9.	Верните описания пространственных объектов в формате WKT
--  текстовый формат для представления геометрических объектов в пространстве
SELECT geom.STAsText() AS WKT_Description
FROM ne_110m_geography_regions_polys

-- 10
select * from ne_110m_geography_regions_polys

-- 10.1.	Нахождение пересечения пространственных объектов;
-- Определение области, общей для двух или более пространственных объектов.

SELECT obj1.geom.STIntersection(obj2.geom) AS Intersection
FROM ne_110m_geography_regions_polys obj1, ne_110m_geography_regions_polys obj2
WHERE obj1.qgs_fid = 5 AND obj2.qgs_fid = 6

-- 10.2.	Нахождение координат вершин пространственного объектов

SELECT geom.STPointN(1).ToString() AS VertexCoordinates
FROM ne_110m_geography_regions_polys
WHERE qgs_fid = 6

-- 10.3.	Нахождение площади пространственных объектов;
-- Площадь (Area): Измерение площади замкнутых объектов, таких как полигоны.
SELECT geom.STArea() AS ObjectArea
FROM ne_110m_geography_regions_polys
WHERE qgs_fid = 5

-- 11.	Создайте пространственный объект в виде точки (1) /линии (2) /полигона (3).
-- точка
DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(25 25)', 0);

SELECT @pointGeometry AS PointGeometry;

-- линия
DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(20 5, 5 20, 25 25)', 0);

SELECT @lineGeometry AS LineGeometry;


-- полигон
DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((15 10, 55 55, 5 4, 12 2, 15 10))', 0);

SELECT @polygonGeometry AS PolygonGeometry;


-- 12.	Найдите, в какие пространственные объекты попадают созданные вами объекты

-- точка и полигон
DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(25 25)', 0);
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((20 20, 20 40, 40 40, 40 20, 20 20))', 0);
SELECT @polygon AS PolygonGeometry;
SELECT @point.STWithin(@polygon) AS PointWithinPolygon;

-- прямая и полигон
DECLARE @line GEOMETRY = GEOMETRY::STGeomFromText('LINESTRING(20 5, 5 20, 25 25)', 0);
DECLARE @polygonn GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((20 20, 20 40, 40 40, 40 20, 20 20))', 0);

SELECT @line.STIntersects(@polygonn) AS LineIntersectsPolygon;

-- 13.
CREATE SPATIAL INDEX Geometry_index_spatial
ON ne_110m_geography_regions_polys(geom)
USING GEOMETRY_GRID
WITH (
  BOUNDING_BOX = (-180, -90, 180, 90)
);


SELECT *
FROM ne_110m_geography_regions_polys WITH(INDEX(Geometry_index_spatial))
WHERE geom.STIntersects(geometry::STGeomFromText('POLYGON((-100 30, -90 30, -90 40, -100 40, -100 30))', 4326)) = 1;


-- 14.
create procedure PointCheckProc
@point geometry
as
begin
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((1 1, 50 1, 50 50, 1 50, 1 1))', 0);
SELECT @point.STWithin(@polygon) AS PointWithinPolygon;
end;
go

exec PointCheckProc 'POINT(2 6)';
