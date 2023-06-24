CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tiempo(
  MES int not null,
  ANIO int not null,
  PRIMARY KEY (MES, ANIO)
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_dias(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  DIA nvarchar(50)
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_rango_horario(
  RANGO_INICIO time not null,
  RANGO_FIN time not null,
  PRIMARY KEY(RANGO_INICIO, RANGO_FIN)
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_provincia_localidad(
  ID decimal(18,0) IDENTITY PRIMARY KEY, 
  PROVINCIA nvarchar(255) not null,
  LOCALIDAD nvarchar(255) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_rango_etario(
  RANGO_INICIO int not null,
  RANGO_FIN int not null,
  PRIMARY KEY(RANGO_INICIO, RANGO_FIN)
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_tipo_medio_pago(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  TIPO_MEDIO_PAGO nvarchar(50) not null
)

CREATE TABLE BASE_DE_GATOS_2.BI_dimension_local(
  ID decimal(18,0) IDENTITY PRIMARY KEY,
  LOCAL_NOMBRE nvarchar(50) not null
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


-- Dimension tiempo
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
		ORDER BY 2,1
END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_dias
AS
BEGIN
	INSERT INTO BASE_DE_GATOS_2.BI_dimension_dias(DIA)
		SELECT
			hd.DIA
		FROM BASE_DE_GATOS_2.HORARIO_DIAS hd
END
GO

CREATE PROCEDURE BASE_DE_GATOS_2.migrar_dimension_rango_horario
AS
BEGIN
	INSERT INTO BASE_DE_GATOS_2.BI_dimension_rango_horario(RANGO_INICIO, RANGO_FIN)
		VALUES	('08:00:00.000', '09:59:59.999'),
				    ('10:00:00.000', '11:59:59.999'),
				    ('12:00:00.000', '13:59:59.999'),
    				('14:00:00.000', '15:59:59.999'),
    				('16:00:00.000', '17:59:59.999'),
    				('18:00:00.000', '19:59:59.999'),
    				('20:00:00.000', '21:59:59.999'),
    				('22:00:00.000', '23:59:59.999');
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
	INSERT INTO BASE_DE_GATOS_2.BI_dimension_rango_etario(RANGO_INICIO, RANGO_FIN)
	VALUES	(0, 25),
			(26, 35),
			(36, 55),
			(56, 130);
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
	INSERT INTO BASE_DE_GATOS_2.BI_dimension_local(LOCAL_NOMBRE)
		SELECT
		  l.NOMBRE
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