
-- Drop tablas

declare @drop_tablas_bi NVARCHAR(max) = ''
SELECT @drop_tablas_bi += 'DROP TABLE BASE_DE_GATOS_2.' + QUOTENAME(TABLE_NAME)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'BASE_DE_GATOS_2' and TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME LIKE 'BI_%'

EXEC sp_executesql @drop_tablas_bi;
GO

-- TABLAS --

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tiempo(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  MES int not null,
  ANIO int not null,
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_dias(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  DIA nvarchar(50)
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_rango_horario(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  RANGO nvarchar(15) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_provincia_localidad(
  ID decimal(18,0) IDENTITY PRIMARY KEY, 
  PROVINCIA nvarchar(255) not null,
  LOCALIDAD nvarchar(255) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_rango_etario(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  RANGO nvarchar(10) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tipo_medio_pago(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  TIPO_MEDIO_PAGO nvarchar(50) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_local(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  NOMBRE_LOCAL nvarchar(50) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tipo_local(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  TIPO_LOCAL nvarchar(50) not null,
  CATEGORIA_LOCAL nvarchar(50) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tipo_movilidad(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  TIPO_MOVILIDAD nvarchar(50) not null,
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tipo_paquete(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  TIPO_PAQUETE nvarchar(50) not null,
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_estados_pedidos(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  ESTADO_PEDIDO nvarchar(50) not null,
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_estados_envio_mensajeria(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  ESTADO_EM nvarchar(50) not null,
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_estados_reclamos(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  ESTADO_RECLAMO nvarchar(50) not null,
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tipos_reclamos(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  TIPO_RECLAMO nvarchar(50) not null,
)
GO

-- PROCEDURES --

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_tiempo
	AS
		BEGIN
			INSERT INTO BASE_DE_GATOS_2.BI_dimension_tiempo(MES, ANIO)
				SELECT
					MONTH(em.FECHA),
					YEAR(em.FECHA)
				FROM BASE_DE_GATOS_2.ENVIOS_MENSAJERIA em
				WHERE em.FECHA IS NOT NULL

				UNION

				SELECT
					MONTH(em.FECHA_ENTREGA),
					YEAR(em.FECHA_ENTREGA)
				FROM BASE_DE_GATOS_2.ENVIOS_MENSAJERIA em
				WHERE em.FECHA_ENTREGA IS NOT NULL

				UNION

				SELECT
					MONTH(p.FECHA),
					YEAR(p.FECHA)
				FROM BASE_DE_GATOS_2.PEDIDOS p
				WHERE p.FECHA IS NOT NULL

				UNION
			
				SELECT
					MONTH(p.FECHA_ENTREGA),
					YEAR(p.FECHA_ENTREGA)
				FROM BASE_DE_GATOS_2.PEDIDOS p
				WHERE p.FECHA_ENTREGA IS NOT NULL

				UNION

				SELECT
					MONTH(r.FECHA),
					YEAR(r.FECHA)
				FROM BASE_DE_GATOS_2.RECLAMOS r
				WHERE r.FECHA IS NOT NULL

				UNION

				SELECT
					MONTH(r.FECHA_SOLUCION),
					YEAR(r.FECHA_SOLUCION)
				FROM BASE_DE_GATOS_2.RECLAMOS r
				WHERE r.FECHA_SOLUCION IS NOT NULL

				UNION

				SELECT
					MONTH(c.FECHA_ALTA),
					YEAR(c.FECHA_ALTA)
				FROM BASE_DE_GATOS_2.CUPONES c
				WHERE c.FECHA_ALTA IS NOT NULL

				UNION

				SELECT
					MONTH(c.FECHA_VENCIMIENTO),
					YEAR(c.FECHA_VENCIMIENTO)
				FROM BASE_DE_GATOS_2.CUPONES c
				WHERE c.FECHA_VENCIMIENTO IS NOT NULL
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_dias
	AS
		BEGIN
			INSERT INTO BASE_DE_GATOS_2.BI_dimension_dias(DIA)
				SELECT DISTINCT
					DATENAME(WEEKDAY, r.FECHA)
				FROM BASE_DE_GATOS_2.RECLAMOS r
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_rango_horario
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_rango_horario(RANGO)
			VALUES ('08:00 - 10:00'),
					('10:00 - 12:00'),
					('12:00 - 14:00'),
					('14:00 - 16:00'),
					('16:00 - 18:00'),
					('18:00 - 20:00'),
					('20:00 - 22:00'),
					('22:00 - 00:00');
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_provincia_localidad
	AS
		BEGIN
			INSERT INTO BASE_DE_GATOS_2.BI_dimension_provincia_localidad(PROVINCIA, LOCALIDAD)
				SELECT
				p.NOMBRE,
				l.NOMBRE
				FROM BASE_DE_GATOS_2.LOCALIDADES l
					JOIN BASE_DE_GATOS_2.PROVINCIAS p ON l.PROVINCIA_ID = p.ID 
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_rango_etario
	AS
		BEGIN
			INSERT INTO BASE_DE_GATOS_2.BI_dimension_rango_etario(RANGO)
			VALUES ('<25'),
					('25 - 35'),
					('35 - 55'),
					('>55');
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_tipo_medio_pago
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_tipo_medio_pago(TIPO_MEDIO_PAGO)
			SELECT
			mpt.TIPO
			FROM BASE_DE_GATOS_2.MEDIO_DE_PAGO_TIPOS mpt
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_local
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_local(NOMBRE_LOCAL)
			SELECT l.NOMBRE
			FROM BASE_DE_GATOS_2.LOCALES l
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_tipo_local
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_tipo_local(TIPO_LOCAL, CATEGORIA_LOCAL)
			SELECT
			lt.TIPO,
			lc.CATEGORIA
			FROM BASE_DE_GATOS_2.LOCAL_TIPOS lt
				JOIN BASE_DE_GATOS_2.LOCAL_CATEGORIAS lc ON lt.ID = lc.TIPO_ID
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_tipo_movilidad
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_tipo_movilidad(TIPO_MOVILIDAD)
			SELECT
			m.MOVILIDAD
			FROM BASE_DE_GATOS_2.MOVILIDADES m
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_tipo_paquete
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_tipo_paquete(TIPO_PAQUETE)
			SELECT
			pt.TIPO
			FROM BASE_DE_GATOS_2.PAQUETE_TIPOS pt
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_estados_pedidos
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_estados_pedidos(ESTADO_PEDIDO)
			SELECT
			pe.ESTADO
			FROM BASE_DE_GATOS_2.PEDIDO_ESTADOS pe
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_estados_envio_mensajeria
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_estados_envio_mensajeria(ESTADO_EM)
			SELECT
			eme.ESTADO
			FROM BASE_DE_GATOS_2.ENVIO_MENSAJERIA_ESTADOS eme
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_estados_reclamos
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_estados_reclamos(ESTADO_RECLAMO)
			SELECT
			re.ESTADO
			FROM BASE_DE_GATOS_2.RECLAMO_ESTADOS re
		END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_tipos_reclamos
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.BI_dimension_tipos_reclamos(TIPO_RECLAMO)
			SELECT
			rt.TIPO
			FROM BASE_DE_GATOS_2.RECLAMO_TIPOS rt
		END
GO


EXEC BASE_DE_GATOS_2.migrar_dimension_tiempo
EXEC BASE_DE_GATOS_2.migrar_dimension_dias
EXEC BASE_DE_GATOS_2.migrar_dimension_rango_horario
EXEC BASE_DE_GATOS_2.migrar_dimension_provincia_localidad
EXEC BASE_DE_GATOS_2.migrar_dimension_rango_etario
EXEC BASE_DE_GATOS_2.migrar_dimension_tipo_medio_pago
EXEC BASE_DE_GATOS_2.migrar_dimension_local
EXEC BASE_DE_GATOS_2.migrar_dimension_tipo_local
EXEC BASE_DE_GATOS_2.migrar_dimension_tipo_movilidad
EXEC BASE_DE_GATOS_2.migrar_dimension_tipo_paquete
EXEC BASE_DE_GATOS_2.migrar_dimension_estados_pedidos
EXEC BASE_DE_GATOS_2.migrar_dimension_estados_envio_mensajeria
EXEC BASE_DE_GATOS_2.migrar_dimension_estados_reclamos
EXEC BASE_DE_GATOS_2.migrar_dimension_tipos_reclamos
GO

--------------------------------------------------------------------------------------------

-- HECHOS --

-- FUNCIONES
CREATE FUNCTION BASE_DE_GATOS_2.BI_obtener_rango_etario (@fecha_de_nacimiento datetime2)
    RETURNS nvarchar(10)
AS
BEGIN
    DECLARE @edad int;
    SELECT @edad = (DATEDIFF (DAYOFYEAR, @fecha_de_nacimiento, GETDATE())) / 365; 
    DECLARE @rango_etario nvarchar(10);

    IF (@edad < 25)
        BEGIN
            SET @rango_etario = '<25';
        END
    ELSE IF (@edad >= 25 AND @edad < 35)
        BEGIN
            SET @rango_etario = '25 - 35';
        END
    ELSE IF (@edad >= 35 AND @edad <= 55)
        BEGIN
            SET @rango_etario = '35 - 55';
        END
    ELSE IF(@edad > 55)
        BEGIN
            SET @rango_etario = '>55';
        END
    RETURN @rango_etario
END
GO

CREATE FUNCTION BASE_DE_GATOS_2.BI_obtener_rango_horario (@fecha datetime2)
    RETURNS nvarchar(15)
AS
BEGIN    
    DECLARE @hora int;
    SELECT @hora =  (CONVERT(int,DATEPART(HOUR, @fecha)));
    DECLARE @rango_horario nvarchar(15);

    IF (@hora >= 8 and @hora < 10)
        BEGIN
            SET @rango_horario = '8:00 - 10:00';
        END
    ELSE IF (@hora >= 10 AND @hora < 12)
        BEGIN
            SET @rango_horario = '10:00 - 12:00';
        END
    ELSE IF (@hora >= 12 AND @hora < 14)
        BEGIN
            SET @rango_horario = '12:00 - 14:00';
        END
    ELSE IF (@hora >= 14 AND @hora < 16)
        BEGIN
            SET @rango_horario = '14:00 - 16:00';
        END
    ELSE IF (@hora >= 16 AND @hora < 18)
        BEGIN
            SET @rango_horario = '16:00 - 18:00';
        END
        ELSE IF (@hora >= 18 AND @hora < 20)
        BEGIN
            SET @rango_horario = '18:00 - 20:00';
        END
    ELSE IF (@hora >= 20 AND @hora < 22)
        BEGIN
            SET @rango_horario = '20:00 - 22:00';
        END
    ELSE IF (@hora >= 22 AND @hora < 24)
        BEGIN
            SET @rango_horario = '22:00 - 00:00';
        END

    RETURN @rango_horario;
END
GO


-- TABLAS
CREATE TABLE BASE_DE_GATOS_2.BI_hechos_reclamo(
  NUMERO decimal(18,0) PRIMARY KEY,
  TIEMPO_ID decimal(18,0),
  LOCAL_ID decimal(18,0),
  DIA_ID decimal(18,0),
  RANGO_HORARIO_ID decimal(18,0),
  TIEMPO_RESOLUCION decimal(18,0),
  TIPO_RECLAMO_ID decimal(18,0),
  RANGO_ETARIO_OPERADOR_ID decimal(18,0),
  MONTO_CUPON decimal(18,2)
)

CREATE TABLE BASE_DE_GATOS_2.BI_hechos_pedidos (
  NUMERO decimal(18, 0) PRIMARY KEY,
  TOTAL_SERVICIO decimal(18, 2) not null,
  ESTADO nvarchar(50) not null,
  PRECIO_ENVIO decimal(18, 2) not null,
  TOTAL_CUPONES decimal(18, 2) not null,
  CALIFICACION decimal(18, 0) not null,
  DESVIO_TIEMPO_ENVIO int not null,
  LOCALIDAD_ID decimal(18, 0) not null,
  CATEGORIA_LOCAL_ID decimal(18, 0) not null,
  TIEMPO_ID decimal(18, 0) not null,
  RANGO_HORARIO_ID decimal(18, 0) not null,
  LOCAL_ID decimal(18, 0) not null,
  DIA_ID decimal(18, 0) not null,
  RANGO_ETARIO_USUARIO_ID decimal(18, 0) not null,
  RANGO_ETARIO_REPARTIDOR_ID decimal(18, 0) not null,
  TIPO_MOVILIDAD_ID decimal(18, 0) not null
)


CREATE TABLE BASE_DE_GATOS_2.BI_hechos_envio_mensajeria (
  NUMERO decimal(18, 0) PRIMARY KEY,
  DESVIO_TIEMPO_ENVIO int not null,
  ESTADO_ENVIO_MENSAJERIA nvarchar(50),
  VALOR_ASEGURADO decimal(18, 2) not null,
  RANGO_ETARIO_REPARTIDOR_ID decimal(18, 0) not null,
  LOCALIDAD_ID decimal(18, 0) not null,
  DIA_ID decimal(18, 0) not null,
  RANGO_HORARIO_ID decimal(18, 0) not null,
  TIPO_MOVILIDAD_ID decimal(18, 0) not null,
  TIEMPO_ID decimal(18, 0) not null,
  TIPO_PAQUETE_ID decimal(18, 0) not null 
)

-- CONSTRAINTS
ALTER TABLE BASE_DE_GATOS_2.BI_hechos_reclamo
ADD CONSTRAINT FK_HECHOS_RECLAMO_TIEMPO FOREIGN KEY (TIEMPO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tiempo(ID),
CONSTRAINT FK_HECHOS_RECLAMO_LOCAL FOREIGN KEY (LOCAL_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_local(ID),
CONSTRAINT FK_HECHOS_RECLAMO_DIA FOREIGN KEY (DIA_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_dias(ID),
CONSTRAINT FK_HECHOS_RECLAMO_RANGO_HORARIO FOREIGN KEY (RANGO_HORARIO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_horario(ID),
CONSTRAINT FK_HECHOS_RECLAMO_TIPO_RECLAMO FOREIGN KEY (TIPO_RECLAMO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tipos_reclamos(ID),
CONSTRAINT FK_HECHOS_RECLAMO_RANGO_ETARIO FOREIGN KEY (RANGO_ETARIO_OPERADOR_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_etario(ID);

ALTER TABLE BASE_DE_GATOS_2.BI_hechos_envio_mensajeria
  ADD CONSTRAINT FK_HECHOS_EM_RANGO_ETARIO FOREIGN KEY (RANGO_ETARIO_REPARTIDOR_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_etario (ID),
  CONSTRAINT FK_HECHOS_EM_LOCALIDAD FOREIGN KEY (LOCALIDAD_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_provincia_localidad (ID),
  CONSTRAINT FK_HECHOS_EM_DIA FOREIGN KEY (DIA_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_dias (ID),
  CONSTRAINT FK_HECHOS_EM_RANGO_HORARIO FOREIGN KEY (RANGO_HORARIO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_horario (ID),
  CONSTRAINT FK_HECHOS_EM_MOVILIDAD FOREIGN KEY (TIPO_MOVILIDAD_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tipo_movilidad (ID),
  CONSTRAINT FK_HECHOS_EM_TIEMPO FOREIGN KEY (TIEMPO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tiempo (ID),
  CONSTRAINT FK_HECHOS_EM_TIPO_PAQUETE FOREIGN KEY (TIPO_PAQUETE_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tipo_paquete (ID);
  
ALTER TABLE BASE_DE_GATOS_2.BI_hechos_pedidos
  ADD CONSTRAINT FK_HECHOS_PEDIDOS_LOCALIDAD FOREIGN KEY (LOCALIDAD_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_provincia_localidad (ID),
  CONSTRAINT FK_HECHOS_PEDIDOS_CATEGORIA_LOCAL FOREIGN KEY (CATEGORIA_LOCAL_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tipo_local (ID), 
  CONSTRAINT FK_HECHOS_PEDIDOS_TIEMPO FOREIGN KEY (TIEMPO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tiempo (ID),
  CONSTRAINT FK_HECHOS_PEDIDOS_RANGO_HORARIO FOREIGN KEY (RANGO_HORARIO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_horario (ID),
  CONSTRAINT FK_HECHOS_PEDIDOS_LOCAL FOREIGN KEY (LOCAL_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_local (ID),
  CONSTRAINT FK_HECHOS_PEDIDOS_DIA FOREIGN KEY (DIA_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_dias (ID),  
  CONSTRAINT FK_HECHOS_PEDIDOS_RANGO_ETARIO_USUARIO FOREIGN KEY (RANGO_ETARIO_USUARIO_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_etario (ID),
  CONSTRAINT FK_HECHOS_PEDIDOS_RANGO_ETARIO_REPARTIDOR FOREIGN KEY (RANGO_ETARIO_REPARTIDOR_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_rango_etario (ID),
  CONSTRAINT FK_HECHOS_PEDIDOS_MOVILIDAD FOREIGN KEY (TIPO_MOVILIDAD_ID) REFERENCES BASE_DE_GATOS_2.BI_dimension_tipo_movilidad (ID);

GO

-- PROCEDURES DE HECHOS
CREATE PROCEDURE BASE_DE_GATOS_2.BI_migrar_hechos_reclamo
  AS
    BEGIN
    INSERT INTO BASE_DE_GATOS_2.BI_hechos_reclamo(
      NUMERO,
      TIEMPO_ID,
      LOCAL_ID,
      DIA_ID,
      RANGO_HORARIO_ID,
      TIEMPO_RESOLUCION,
      TIPO_RECLAMO_ID,
      RANGO_ETARIO_OPERADOR_ID,
      MONTO_CUPON
    )
    SELECT
      r.NUMERO,
      bdt.ID,
      bdl.ID,
      bdd.ID,
      brh.ID,
      (DATEDIFF(MINUTE, r.FECHA, r.FECHA_SOLUCION)),
      r.TIPO_ID,
      bre.ID,
      c.MONTO
    FROM
      BASE_DE_GATOS_2.RECLAMOS r
		JOIN
      BASE_DE_GATOS_2.BI_dimension_tiempo bdt
        ON MONTH(r.FECHA) = bdt.MES
        AND YEAR(r.FECHA) = bdt.ANIO
        JOIN
      BASE_DE_GATOS_2.PEDIDOS p
        ON r.PEDIDO_NUMERO = p.NUMERO
        JOIN 
      BASE_DE_GATOS_2.LOCALES l
        ON p.LOCAL_ID = l.ID
        JOIN 
      BASE_DE_GATOS_2.BI_dimension_local bdl
        ON l.NOMBRE = bdl.NOMBRE_LOCAL
        JOIN
      BASE_DE_GATOS_2.BI_dimension_dias bdd
        ON DATENAME(WEEKDAY, r.FECHA) = bdd.DIA
        JOIN
      BASE_DE_GATOS_2.BI_dimension_rango_horario brh
        ON BASE_DE_GATOS_2.BI_obtener_rango_horario(r.FECHA) = brh.RANGO
        JOIN
		  BASE_DE_GATOS_2.OPERADORES o
        ON r.OPERADOR_ID = o.ID
		    JOIN
	    BASE_DE_GATOS_2.BI_dimension_rango_etario bre
		    ON BASE_DE_GATOS_2.BI_obtener_rango_etario(o.FECHA_NACIMIENTO) = bre.RANGO      
        JOIN
      BASE_DE_GATOS_2.RECLAMO_CUPON rc
        ON r.NUMERO = rc.RECLAMO_NUMERO
        JOIN
      BASE_DE_GATOS_2.CUPONES c
        ON rc.CUPON_NUMERO = c.NUMERO
    END
GO
        
CREATE PROCEDURE BASE_DE_GATOS_2.BI_migrar_hechos_envio_mensajeria
  AS 
    BEGIN
      INSERT INTO BASE_DE_GATOS_2.BI_hechos_envio_mensajeria (
        NUMERO,
        DESVIO_TIEMPO_ENVIO,
        ESTADO_ENVIO_MENSAJERIA,
        VALOR_ASEGURADO,
        RANGO_ETARIO_REPARTIDOR_ID,
        LOCALIDAD_ID,
        DIA_ID,
        RANGO_HORARIO_ID,
        TIPO_MOVILIDAD_ID,
        TIEMPO_ID,
        TIPO_PAQUETE_ID
      )
        SELECT DISTINCT
          em.NUMERO,
          ABS(em.TIEMPO_ESTIMADO_ENTREGA - DATEDIFF(MINUTE, em.FECHA, em.FECHA_ENTREGA)),
          eem.ESTADO,
          em.VALOR_ASEGURADO,
          bdre.ID rango_etario_id,
          bdpl.ID prov_localidad_id,
          bdd.ID dia_id,
          bdrh.ID rango_horario_id,
          bdtm.ID tipo_movilidad_id,
          bdt.ID tiempo_id,
          bdtp.ID tipo_paquete_id
        FROM
          BASE_DE_GATOS_2.ENVIOS_MENSAJERIA em
            JOIN
          BASE_DE_GATOS_2.ENVIO_MENSAJERIA_ESTADOS eem
            ON em.ESTADO_ID = eem.ID
            JOIN 
          BASE_DE_GATOS_2.REPARTIDORES r
            ON em.REPARTIDOR_ID = r.ID
            JOIN
          BASE_DE_GATOS_2.BI_dimension_rango_etario bdre
            ON BASE_DE_GATOS_2.BI_obtener_rango_etario(r.FECHA_NACIMIENTO) = bdre.RANGO
            JOIN
          BASE_DE_GATOS_2.DIRECCIONES d
            ON em.DIRECCION_DESTINO_ID = d.ID
            JOIN
          BASE_DE_GATOS_2.LOCALIDADES l
            ON d.LOCALIDAD_ID = l.ID
            JOIN
          BASE_DE_GATOS_2.PROVINCIAS p
            ON l.PROVINCIA_ID = p.ID
            JOIN
          BASE_DE_GATOS_2.BI_dimension_provincia_localidad bdpl
            ON l.NOMBRE = bdpl.LOCALIDAD
            AND p.NOMBRE = bdpl.PROVINCIA
            JOIN
          BASE_DE_GATOS_2.BI_dimension_dias bdd
            ON DATENAME(WEEKDAY, em.FECHA) = bdd.DIA
            JOIN
          BASE_DE_GATOS_2.BI_dimension_rango_horario bdrh
            ON BASE_DE_GATOS_2.BI_obtener_rango_horario(em.FECHA) = bdrh.RANGO
            JOIN
          BASE_DE_GATOS_2.MOVILIDADES m
            ON r.MOVILIDAD_ID = m.ID
            JOIN
          BASE_DE_GATOS_2.BI_dimension_tipo_movilidad bdtm
            ON m.MOVILIDAD = bdtm.TIPO_MOVILIDAD
            JOIN
          BASE_DE_GATOS_2.BI_dimension_tiempo bdt
            ON YEAR(em.FECHA) = bdt.ANIO 
            AND MONTH(em.FECHA) = bdt.MES
            JOIN
          BASE_DE_GATOS_2.PAQUETE_TIPOS pt
            ON em.TIPO_PAQUETE_ID = pt.ID
            JOIN
          BASE_DE_GATOS_2.BI_dimension_tipo_paquete bdtp
            ON pt.TIPO = bdtp.TIPO_PAQUETE
    END
GO     


----------------------------------- MAXI ------------------------------------------

CREATE PROCEDURE BASE_DE_GATOS_2.BI_migrar_hechos_pedidos
  AS 
    BEGIN
      INSERT INTO BASE_DE_GATOS_2.BI_hechos_pedidos (
        NUMERO,         
        TOTAL_SERVICIO,
        ESTADO,
        PRECIO_ENVIO,
        TOTAL_CUPONES,
        CALIFICACION,
        DESVIO_TIEMPO_ENVIO,
        LOCALIDAD_ID,
        CATEGORIA_LOCAL_ID,
        TIEMPO_ID,
        RANGO_HORARIO_ID,
        LOCAL_ID,
        DIA_ID,
        RANGO_ETARIO_USUARIO_ID,
        RANGO_ETARIO_REPARTIDOR_ID,
        TIPO_MOVILIDAD_ID
      )
      SELECT DISTINCT
      p.NUMERO,
      p.TOTAL_SERVICIO,
		  pe.ESTADO,
		  p.PRECIO_ENVIO,
		  p.TOTAL_CUPONES,
		  p.CALIFICACION,
		  ABS(p.TIEMPO_ESTIMADO_ENTREGA - DATEDIFF(MINUTE, p.FECHA_ENTREGA, p.FECHA)),
		  dpl.ID prov_localidad_id,
		  dtl.ID tipo_local_id,
		  dt.ID tiempo_id,
		  drh.ID rango_horario_id,
		  dl.ID local_id,
		  dd.ID dia_id,
		  dreu.ID rango_etario_usu_id,
		  drer.ID rango_etario_rep_id,
		  dtm.ID tipo_movilidad_id
        FROM BASE_DE_GATOS_2.PEDIDOS p
          JOIN BASE_DE_GATOS_2.PEDIDO_ESTADOS pe ON p.ESTADO_ID = pe.ID
    			JOIN BASE_DE_GATOS_2.USUARIOS u ON p.USUARIO_ID = u.ID
    			JOIN BASE_DE_GATOS_2.DIRECCION_USUARIO du ON p.DIRECCION_USUARIO_ID = du.ID
    			JOIN BASE_DE_GATOS_2.DIRECCIONES d ON du.DIRECCION_ID = d.ID
    			JOIN BASE_DE_GATOS_2.LOCALIDADES l ON d.LOCALIDAD_ID = l.ID
    			JOIN BASE_DE_GATOS_2.PROVINCIAS pr ON l.PROVINCIA_ID = pr.ID
    			JOIN BASE_DE_GATOS_2.BI_dimension_provincia_localidad dpl ON l.NOMBRE = dpl.LOCALIDAD AND pr.NOMBRE = dpl.PROVINCIA
  				JOIN BASE_DE_GATOS_2.LOCALES lo ON p.LOCAL_ID = lo.ID
  				JOIN BASE_DE_GATOS_2.BI_dimension_local dl ON lo.NOMBRE = dl.LOCAL_NOMBRE 
  				JOIN BASE_DE_GATOS_2.LOCAL_CATEGORIAS lc ON lo.CATEGORIA_ID = lc.ID
  				JOIN BASE_DE_GATOS_2.BI_dimension_tipo_local dtl ON lc.CATEGORIA = dtl.CATEGORIA_LOCAL
  				JOIN BASE_DE_GATOS_2.BI_dimension_tiempo dt ON YEAR(p.FECHA) = dt.ANIO AND MONTH(p.FECHA) = dt.MES
  				JOIN BASE_DE_GATOS_2.BI_dimension_rango_horario drh ON BASE_DE_GATOS_2.BI_obtener_rango_horario(p.FECHA) = drh.RANGO
  				JOIN BASE_DE_GATOS_2.BI_dimension_dias dd ON DATENAME(WEEKDAY, p.FECHA) = dd.DIA
  				JOIN BASE_DE_GATOS_2.BI_dimension_rango_etario dreu ON BASE_DE_GATOS_2.BI_obtener_rango_etario(u.FECHA_NACIMIENTO) = dreu.RANGO
  				JOIN BASE_DE_GATOS_2.REPARTIDORES r ON p.REPARTIDOR_ID = r.ID
  				JOIN BASE_DE_GATOS_2.BI_dimension_rango_etario drer ON BASE_DE_GATOS_2.BI_obtener_rango_etario(r.FECHA_NACIMIENTO) = drer.RANGO
  				JOIN BASE_DE_GATOS_2.MOVILIDADES m ON r.MOVILIDAD_ID = m.ID
  				JOIN BASE_DE_GATOS_2.BI_dimension_tipo_movilidad dtm ON m.MOVILIDAD = dtm.TIPO_MOVILIDAD
	END
GO
        

        
-- VIEWS --
CREATE VIEW BASE_DE_GATOS_2.BI_VIEW_CANT_RECLAMO_X_MES_X_LOCAL_X_DIA_X_RANGO_HORARIO 
AS
  SELECT 
    COUNT(*) cantidad_reclamos,
    dt.ANIO,
    dt.MES,
    dl.NOMBRE_LOCAL,
    dd.DIA,
    drh.RANGO rango_horario
  FROM BASE_DE_GATOS_2.BI_hechos_reclamo hr 
    JOIN BASE_DE_GATOS_2.BI_dimension_tiempo dt ON dt.ID = hr.TIEMPO_ID
    JOIN BASE_DE_GATOS_2.BI_dimension_local dl ON dl.ID = hr.LOCAL_ID
    JOIN BASE_DE_GATOS_2.BI_dimension_dias dd ON dd.ID = hr.DIA_ID
    JOIN BASE_DE_GATOS_2.BI_dimension_rango_horario drh ON drh.ID = hr.RANGO_HORARIO_ID
  GROUP BY 
    dt.ANIO,
    dt.MES,
    dl.NOMBRE_LOCAL,
    dd.DIA,
    drh.RANGO

GO

CREATE VIEW BASE_DE_GATOS_2.BI_VIEW_TIEMPO_PROMEDIO_RESOLUCION_RECLAMOS_X_MES_X_TIPO_RECLAMO_X_RANGO_ETARIO_OPERADORES 
AS
  SELECT 
    AVG(hr.TIEMPO_RESOLUCION) tiempo_promedio_resolucion,
    dt.ANIO,
    dt.MES,
    dtr.TIPO_RECLAMO,
    dre.RANGO rango_etario_operador
  FROM BASE_DE_GATOS_2.BI_hechos_reclamo hr 
    JOIN BASE_DE_GATOS_2.BI_dimension_tiempo dt ON dt.ID = hr.TIEMPO_ID
    JOIN BASE_DE_GATOS_2.BI_dimension_tipos_reclamos dtr ON dtr.ID = hr.TIPO_RECLAMO_ID
    JOIN BASE_DE_GATOS_2.BI_dimension_rango_etario dre ON dre.ID = hr.RANGO_ETARIO_OPERADOR_ID
  GROUP BY 
    dt.ANIO,
    dt.MES,
    dtr.TIPO_RECLAMO,
    dre.RANGO
GO

CREATE VIEW BASE_DE_GATOS_2.BI_VIEW_MONTO_CUPON_RECLAMO_X_MES
AS
  SELECT 
    SUM(hr.MONTO_CUPON) monto_cupones,
    dt.ANIO,
    dt.MES
  FROM BASE_DE_GATOS_2.BI_hechos_reclamo hr 
    JOIN BASE_DE_GATOS_2.BI_dimension_tiempo dt ON dt.ID = hr.TIEMPO_ID
  GROUP BY 
    dt.ANIO,
    dt.MES
GO

-- CREATE VIEW BASE_DE_GATOS_2.BI_VIEW_DIA_HORARIO_MAYOR_CANTIDAD_PEDIDOS_X_LOCALIDAD_X_CATEGORIA_LOCAL_X_MES
-- AS
--   SELECT

--   FROM
--     BASE_DE_GATOS_2.BI_hechos_pedidos hp
-- GO

EXEC BASE_DE_GATOS_2.BI_migrar_hechos_reclamo
EXEC BASE_DE_GATOS_2.BI_migrar_hechos_envio_mensajeria
EXEC BASE_DE_GATOS_2.BI_migrar_hechos_pedidos