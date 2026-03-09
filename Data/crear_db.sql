-- ============================================================
-- OPS_001_AnalisisProductos — PIX RPA
-- Script de creación de base de datos SQLServer
-- Ejecutar una sola vez antes de la primera ejecución del robot
-- ============================================================

-- ============================================================
-- Crear base de datos si no existe
-- ============================================================

IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = 'Productos'
)
BEGIN
    CREATE DATABASE Productos;
END
GO


USE Productos
GO

-- ============================================================
-- Tabla principal de productos
-- ============================================================

IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = 'Productos'
)
BEGIN
    CREATE TABLE Productos (
        id               INT PRIMARY KEY,
        title            NVARCHAR(200) NOT NULL,
        price            DECIMAL(10,2) NOT NULL,
        category         NVARCHAR(100) NOT NULL,
        description      NVARCHAR(MAX),
        fecha_insercion  DATETIME DEFAULT GETDATE()
    );
END
GO


-- ============================================================
-- Índice por categoría
-- ============================================================

IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_category'
)
BEGIN
    CREATE INDEX idx_category 
    ON Productos(category);
END
GO


-- ============================================================
-- Índice por fecha
-- ============================================================

IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_fecha'
)
BEGIN
    CREATE INDEX idx_fecha 
    ON Productos(fecha_insercion);
END
GO


-- ============================================================
-- Vista Resumen por categoría
-- ============================================================

IF NOT EXISTS (
    SELECT * 
    FROM sys.views 
    WHERE name = 'vw_ResumenCategorias'
)
BEGIN
EXEC('
CREATE VIEW vw_ResumenCategorias AS
SELECT
    category                        AS Categoria,
    COUNT(*)                        AS CantidadProductos,
    ROUND(AVG(price), 2)            AS PrecioPromedio,
    ROUND(MIN(price), 2)            AS PrecioMinimo,
    ROUND(MAX(price), 2)            AS PrecioMaximo
FROM Productos
GROUP BY category
')
END
GO