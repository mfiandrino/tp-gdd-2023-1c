BEGIN TRANSACTION

USE [GD1C2023]
GO

SET NoCount ON

DECLARE @schemaName VARCHAR(200)
SET @schemaName=''
DECLARE @constraintName VARCHAR(200)
SET @constraintName=''
DECLARE @tableName VARCHAR(200)
SET @tableName=''

WHILE EXISTS
(   
    SELECT c.name
    FROM sys.objects AS c
    INNER JOIN sys.tables AS t
    ON c.parent_object_id = t.[object_id]
    INNER JOIN sys.schemas AS s 
    ON t.[schema_id] = s.[schema_id]
    WHERE c.[type] IN ('D','C','F','PK','UQ')
    and t.[name] NOT IN ('__RefactorLog', 'sysdiagrams')
    and c.name > @constraintName
)

BEGIN   
    -- First get the Constraint
    SELECT 
        @constraintName=min(c.name)
    FROM sys.objects AS c
    INNER JOIN sys.tables AS t
    ON c.parent_object_id = t.[object_id]
    INNER JOIN sys.schemas AS s 
    ON t.[schema_id] = s.[schema_id]
    WHERE c.[type] IN ('D','C','F','PK','UQ')
    and t.[name] NOT IN ('__RefactorLog', 'sysdiagrams')
    and c.name > @constraintName

    -- Then select the Table and Schema associated to the current constraint
    SELECT 
        @tableName = t.name,
        @schemaName = s.name
    FROM sys.objects AS c
    INNER JOIN sys.tables AS t
    ON c.parent_object_id = t.[object_id]
    INNER JOIN sys.schemas AS s 
    ON t.[schema_id] = s.[schema_id]
    WHERE c.name = @constraintName

    -- Then Print to the output and drop the constraint
    Print 'Dropping constraint ' + @constraintName + '...'
    Exec('ALTER TABLE [' + @schemaName + N'].[' + @tableName + N'] DROP CONSTRAINT [' + @constraintName + ']')
END

SET NoCount OFF

DROP TABLE [BASE_DE_GATOS_2].[LOCALES]
GO

DROP TABLE [BASE_DE_GATOS_2].[LOCAL_CATEGORIAS]
GO

DROP TABLE [BASE_DE_GATOS_2].[LOCAL_PRODUCTO]
GO

DROP TABLE [BASE_DE_GATOS_2].[LOCAL_PRODUCTO_PEDIDO]
GO

DROP TABLE [BASE_DE_GATOS_2].[HORARIOS]
GO

DROP TABLE [BASE_DE_GATOS_2].[LOCALIDADES]
GO

DROP TABLE [BASE_DE_GATOS_2].[DIRECCION]
GO

DROP TABLE [BASE_DE_GATOS_2].[REPARTIDORES]
GO

DROP TABLE [BASE_DE_GATOS_2].[ENVIO_PEDIDO]
GO

DROP TABLE [BASE_DE_GATOS_2].[MEDIOS_DE_PAGO]
GO

DROP TABLE [BASE_DE_GATOS_2].[USUARIOS]
GO

DROP TABLE [BASE_DE_GATOS_2].[DIRECCION_USUARIO]
GO

DROP TABLE [BASE_DE_GATOS_2].[PEDIDOS]
GO

DROP TABLE [BASE_DE_GATOS_2].[RECLAMOS]
GO

DROP TABLE [BASE_DE_GATOS_2].[ENVIO_MENSAJERIA]
GO

DROP TABLE [BASE_DE_GATOS_2].[ESTADO_ENVIO_MENSAJERIA]
GO

DROP TABLE [BASE_DE_GATOS_2].[ESTADO_PEDIDO]
GO

DROP TABLE [BASE_DE_GATOS_2].[ESTADO_RECLAMO]
GO

DROP TABLE [BASE_DE_GATOS_2].[HORARIO_DIAS]
GO

DROP TABLE [BASE_DE_GATOS_2].[LOCAL_TIPOS]
GO

DROP TABLE [BASE_DE_GATOS_2].[MARCAS_TARJETA]
GO

DROP TABLE [BASE_DE_GATOS_2].[MOVILIDAD]
GO

DROP TABLE [BASE_DE_GATOS_2].[OPERADORES]
GO

DROP TABLE [BASE_DE_GATOS_2].[PRODUCTOS]
GO

DROP TABLE [BASE_DE_GATOS_2].[PROVINCIAS]
GO

DROP TABLE [BASE_DE_GATOS_2].[SOLUCION_RECLAMO]
GO

DROP TABLE [BASE_DE_GATOS_2].[TIPO_MEDIO_DE_PAGO]
GO

DROP TABLE [BASE_DE_GATOS_2].[TIPO_PAQUETES]
GO

DROP TABLE [BASE_DE_GATOS_2].[TIPO_RECLAMO]
GO

DROP TABLE [BASE_DE_GATOS_2].[CUPONES]
GO

DROP TABLE [BASE_DE_GATOS_2].[PEDIDO_CUPON]
GO

DROP TABLE [BASE_DE_GATOS_2].[RECLAMO_CUPON]
GO

DROP TABLE [BASE_DE_GATOS_2].[RECLAMO_CUPON_TIPO]
GO

DROP TABLE [BASE_DE_GATOS_2].[PEDIDO_CUPON_TIPO]
GO

DROP SCHEMA BASE_DE_GATOS_2

COMMIT