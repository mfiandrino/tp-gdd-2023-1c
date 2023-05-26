--Creación de cada tabla de nuestro modelo realizado (con la sentencia IF NOT EXISTS verificamos que no estuviera ya creada la tabla)
BEGIN TRANSACTION
-- Utilizamos la base de datos GD2C2023 que contiene la tabla Maestra
USE GD1C2023
GO

--Creamos el esquema donde realizaremos la migración
CREATE SCHEMA BASE_DE_GATOS_2
GO

--ENVIO_MENSAJERIA
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO_MENSAJERIA')
CREATE TABLE BASE_DE_GATOS_2.ENVIO_MENSAJERIA (
	EM_NUMERO decimal(18, 0) PRIMARY KEY,
	EM_DIR_ORIGEN nvarchar(255) not null,
	EM_DIR_DEST nvarchar(255) not null,
	EM_LOCALIDAD nvarchar(255) not null,
	EM_KILOMETROS decimal(18,2) not null,
	EM_VALOR_ASEGURADO decimal(18,2) not null,
	EM_PRECIO_ENVIO decimal(18,2) not null,
	EM_PRECIO_SEGURO decimal(18,2) not null,
	EM_PROPINA decimal(18,2) not null,
	EM_TOTAL decimal(18,2) not null,
	EM_OBSERVACION nvarchar(255) not null,
	EM_FECHA datetime2(3) not null,
	EM_FECHA_ENTREGA datetime2(3) not null,
	EM_TIEMPO_ESTIMADO decimal(18,2) not null,
	EM_CALIFICACION decimal(18, 0) not null,
	-- FKs
	EM_ESTADO decimal(18, 0) not null,
	EM_USUARIO decimal(18, 0) not null,
	EM_TIPO_PAQUETE decimal(18, 0) not null,
	EM_REPARTIDOR decimal(18, 0) not null,
	EM_MEDIO_DE_PAGO decimal(18, 0) not null
);

-- Estado envio mensajeria
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO_MESTADO_ENVIO_MENSAJERIAENSAJERIA')
CREATE TABLE BASE_DE_GATOS_2.ESTADO_ENVIO_MENSAJERIA (
	ESTADO_EM_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	ESTADO_EM_NOMBRE NVARCHAR(50) not null
);

-- Tipo paquetes
-- PROC: migrar_tipo_paquetes
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_PAQUETES')
CREATE TABLE BASE_DE_GATOS_2.TIPO_PAQUETES (
    TP_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    TP_NOMBRE NVARCHAR(50),
    TP_ALTO_MAX DECIMAL(18,2),
    TP_ANCHO_MAX DECIMAL(18,2),
    TP_LARGO_MAX DECIMAL(18,2),
    TP_PESO_MAX DECIMAL(18,2),
    TP_TIPO_PRECIO DECIMAL(18,2)
);

-- Locales
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL_TIPOS')
CREATE TABLE BASE_DE_GATOS_2.LOCAL_TIPOS (
	LOCAL_TIPO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	LOCAL_TIPO_NOMBRE NVARCHAR(50)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL_CATEGORIAS')
CREATE TABLE BASE_DE_GATOS_2.LOCAL_CATEGORIAS (
	LOCAL_CATEGORIA_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	LOCAL_CATEGORIA_NOMBRE NVARCHAR(50),
	LOCAL_TIPO_ID DECIMAL(18, 0)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'LOCALES')
CREATE TABLE BASE_DE_GATOS_2.LOCALES (
	LOCAL_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	LOCAL_NOMBRE NVARCHAR(100),
	LOCAL_DESCRIPCION NVARCHAR(255),
	LOCAL_DIRECCION_ID DECIMAL(18, 0),
	LOCAL_CATEGORIA_ID DECIMAL(18, 0)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL_PRODUCTO')
CREATE TABLE BASE_DE_GATOS_2.LOCAL_PRODUCTO (
	LP_LOCAL_ID DECIMAL(18, 0),
	LP_PRODUCTO_ID DECIMAL(18, 0),
	LP_PRODUCTO_PRECIO DECIMAL(18,2),
	PRIMARY KEY(LP_LOCAL_ID, LP_PRODUCTO_ID)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL_PRODUCTO_PEDIDO')
CREATE TABLE BASE_DE_GATOS_2.LOCAL_PRODUCTO_PEDIDO (
	LPC_LP_LOCAL_ID DECIMAL(18, 0),
	LPC_LP_PRODUCTO_ID DECIMAL(18, 0),
	LPC_PEDIDO_ID DECIMAL(18, 0),
	LPC_PRODUCTO_CANTIDAD DECIMAL(18, 0),
	LPC_PRODUCTO_PRECIO DECIMAL(18,2),
	PRIMARY KEY(LPC_LP_LOCAL_ID, LPC_LP_PRODUCTO_ID, LPC_PEDIDO_ID)
);

-- Productos
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'PRODUCTOS')
CREATE TABLE BASE_DE_GATOS_2.PRODUCTOS (
	PRODUCTO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	PRODUCTO_CODIGO NVARCHAR(50),
	PRODUCTO_NOMBRE NVARCHAR(50),
	PRODUCTO_DESCRIPCION NVARCHAR(255)
);

-- Horarios
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'HORARIO_DIAS')
CREATE TABLE BASE_DE_GATOS_2.HORARIO_DIAS (
	HORARIO_DIA_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	HORARIO_LOCAL_DIA NVARCHAR(50)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'HORARIOS')
CREATE TABLE BASE_DE_GATOS_2.HORARIOS (
	HORARIO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	HORARIO_DIA_ID DECIMAL(18, 0),
	HORARIO_LOCAL_HORA_APERTURA DECIMAL(18, 0),
	HORARIO_LOCAL_HORA_CIERRE DECIMAL(18, 0),
	LOCAL_ID DECIMAL(18, 0)
);

-- Localidades
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'LOCALIDADES')
CREATE TABLE BASE_DE_GATOS_2.LOCALIDADES (
	LOCALIDAD_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	LOCALIDAD_NOMBRE NVARCHAR(255),
	LOCALIDAD_PROVINCIA_ID DECIMAL(18, 0)
);

-- Dirección
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'DIRECCION')
CREATE TABLE BASE_DE_GATOS_2.DIRECCION (
	DIRECCION_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
	DIRECCION_DIRECCION NVARCHAR(255),
	LOCALIDAD_ID DECIMAL(18, 0)
);

-- Provincias
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'PROVINCIAS')
CREATE TABLE BASE_DE_GATOS_2.PROVINCIAS (
    PROVINCIA_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    PROVINCIA_NOMBRE NVARCHAR(255)
);

-- Repartidores
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'REPARTIDORES')
CREATE TABLE BASE_DE_GATOS_2.REPARTIDORES (
    REPARTIDOR_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    REPARTIDOR_NOMBRE NVARCHAR(255),
    REPARTIDOR_APELLIDO NVARCHAR(255),
    REPARTIDOR_DNI DECIMAL(18, 0),
    REPARTIDOR_TELEFONO DECIMAL(18, 0),
    REPARTIDOR_DIRECCION NVARCHAR(255),
    REPARTIDOR_EMAIL NVARCHAR(255),
    REPARTIDOR_FECHA_NAC DATE,
    REPARTIDOR_LOCALIDAD_ACTIVA DECIMAL(18, 0),
    REPARTIDOR_TIPO_MOVILIDAD DECIMAL(18, 0)
);

-- Movilidad
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'MOVILIDAD')
CREATE TABLE BASE_DE_GATOS_2.MOVILIDAD (
    MOVILIDAD_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    MOVILIDAD_TIPO NVARCHAR(50)
);

-- Pedidos
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDOS')
CREATE TABLE BASE_DE_GATOS_2.PEDIDOS (
	PEDIDO_NUMERO decimal(18, 0) PRIMARY KEY,
	PEDIDO_TOTAL_PRODUCTOS decimal(18,2) not null,
	PEDIDO_TARIFA_SERVICIO decimal(18,2) not null,
	PEDIDO_TOTAL_CUPONES decimal(18,2) not null,
	PEDIDO_TOTAL_SERVICIO decimal(18,2) not null,
	PEDIDO_OBSERV nvarchar(255) not null,
	PEDIDO_FECHA_ENTREGA datetime2(3) not null,
	PEDIDO_FECHA datetime2(3) not null,
	PEDIDO_TIEMPO_ESTIMADO_ENTREGA decimal(18,2) not null,
	PEDIDO_CALIFICACION decimal(18, 0) not null,
  -- FKs
	PEDIDO_ESTADO decimal(18, 0) not null,
	PEDIDO_USUARIO decimal(18, 0) not null,
	PEDIDO_LOCAL decimal(18, 0) not null,
	PEDIDO_MEDIO_PAGO decimal(18, 0) not null
);

-- Envío pedido
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO_PEDIDO')
CREATE TABLE BASE_DE_GATOS_2.ENVIO_PEDIDO (
    EP_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    EP_PRECIO DECIMAL(18,2),
    EP_PROPINA DECIMAL(18,2),
    EP_REPARTIDOR DECIMAL(18, 0),
    EP_DIRECCION DECIMAL(18, 0)
);

-- Estado pedido
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'ESTADO_PEDIDO')
CREATE TABLE BASE_DE_GATOS_2.ESTADO_PEDIDO (
    ESTADO_PEDIDO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    ESTADO_PEDIDO_NOMBRE NVARCHAR(50)
);

-- Medios de pago
IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'MEDIOS_DE_PAGO')
CREATE TABLE BASE_DE_GATOS_2.MEDIOS_DE_PAGO (
    MP_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    MP_NUMERO_TARJETA NVARCHAR(50),
    MP_TIPO DECIMAL(18, 0),
    MP_MARCA_TARJETA DECIMAL(18, 0),
    MP_USUARIO DECIMAL(18, 0)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_MEDIO_DE_PAGO')
CREATE TABLE BASE_DE_GATOS_2.TIPO_MEDIO_DE_PAGO (
    TIPO_MEDIO_PAGO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    TMP_TIPO NVARCHAR(50)
);

IF NOT EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'MARCAS_TARJETA')
CREATE TABLE BASE_DE_GATOS_2.MARCAS_TARJETA (
    MARCA_TARJETA_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    MARCA_TARJETA_NOMBRE NVARCHAR(100)
);

-- Reclamos
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMOS')
CREATE TABLE BASE_DE_GATOS_2.RECLAMOS (
  RECLAMO_NUMERO DECIMAL(18, 0) PRIMARY KEY,
  RECLAMO_FECHA datetime2(3) not null,
  RECLAMO_DESCRIPCION nvarchar(255) not null,
  RECLAMO_FECHA_SOLUCION datetime2(3) not null,
  RECLAMO_CALIFICACION decimal(18, 0) not null,
  -- FKs
  RECLAMO_SOLUCION decimal(18, 0) not null,
  RECLAMO_TIPO decimal(18, 0) not null,
  RECLAMO_ESTADO decimal(18, 0) not null,
  RECLAMO_USUARIO decimal(18, 0) not null,
  RECLAMO_PEDIDO decimal(18, 0) not null,
  RECLAMO_OPERADOR decimal(18, 0) not null,
);

-- Solución reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'SOLUCION_RECLAMO')
CREATE TABLE BASE_DE_GATOS_2.SOLUCION_RECLAMO (
    SOLUCION_RECLAMO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    SOLUCION_RECLAMO_NOMBRE NVARCHAR(50)
);

-- Tipo reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_RECLAMO')
CREATE TABLE BASE_DE_GATOS_2.TIPO_RECLAMO (
    TIPO_RECLAMO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    TIPO_RECLAMO_TIPO NVARCHAR(50)
);

-- Estado reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ESTADO_RECLAMO')
CREATE TABLE BASE_DE_GATOS_2.ESTADO_RECLAMO (
    ESTADO_RECLAMO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    ESTADO_RECLAMO_ESTADO NVARCHAR(50)
);

-- Operadores
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'OPERADORES')
CREATE TABLE BASE_DE_GATOS_2.OPERADORES (
    OPERADOR_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    OPERADOR_NOMBRE NVARCHAR(255),
    OPERADOR_APELLIDO NVARCHAR(255),
    OPERADOR_DNI DECIMAL(18, 0),
    OPERADOR_TELEFONO DECIMAL(18, 0),
    OPERADOR_DIRECCION NVARCHAR(255),
    OPERADOR_MAIL NVARCHAR(255),
    OPERADOR_FECHA_NAC DATE
);

-- Usuarios
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'USUARIOS')
CREATE TABLE BASE_DE_GATOS_2.USUARIOS (
    USUARIO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    USUARIO_NOMBRE NVARCHAR(255),
    USUARIO_APELLIDO NVARCHAR(255),
    USUARIO_DNI DECIMAL(18, 0),
    USUARIO_FECHA_REGISTRO DATETIME2(3),
    USUARIO_TELEFONO DECIMAL(18, 0),
    USUARIO_MAIL NVARCHAR(255),
    USUARIO_FECHA_NAC DATE,
);

-- Dirección usuario
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'DIRECCION_USUARIO')
CREATE TABLE BASE_DE_GATOS_2.DIRECCION_USUARIO (
    DU_USUARIO_ID DECIMAL(18, 0),
    DU_DIRECCION_ID DECIMAL(18, 0),
    DU_DIRECCION_NOMBRE NVARCHAR(50),
    PRIMARY KEY (DU_USUARIO_ID, DU_DIRECCION_ID)
);

-- Cupones
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPONES')
CREATE TABLE BASE_DE_GATOS_2.CUPONES (
    CUPON_NUMERO DECIMAL(18, 0) PRIMARY KEY,
    CUPON_MONTO DECIMAL(18, 2),
    CUPON_FECHA_ALTA DATETIME2(3),
    CUPON_FECHA_VENCIMIENTO DATETIME2(3),
    USUARIO_ID DECIMAL(18, 0)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO_CUPON')
CREATE TABLE BASE_DE_GATOS_2.PEDIDO_CUPON (
    PEDIDO_NUMERO DECIMAL(18, 0),
    CUPON_NUMERO DECIMAL(18, 0),
		CUPON_TIPO_ID DECIMAL(18, 0),
    PRIMARY KEY (PEDIDO_NUMERO, CUPON_NUMERO)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO_CUPON')
CREATE TABLE BASE_DE_GATOS_2.RECLAMO_CUPON (
    CUPON_NUMERO DECIMAL(18, 0),
    RECLAMO_NUMERO DECIMAL(18, 0),
		RECLAMO_CUPON_TIPO_ID DECIMAL(18, 0),
    PRIMARY KEY (CUPON_NUMERO, RECLAMO_NUMERO)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO_CUPON_TIPO')
CREATE TABLE BASE_DE_GATOS_2.RECLAMO_CUPON_TIPO (
    RECLAMO_CUPON_TIPO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    RECLAMO_CUPON_TIPO NVARCHAR(50)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON_TIPO')
CREATE TABLE BASE_DE_GATOS_2.CUPON_TIPO(
    CUPON_TIPO_ID DECIMAL(18, 0) IDENTITY PRIMARY KEY,
    CUPON_TIPO_NOMBRE NVARCHAR(50)
);

ALTER TABLE BASE_DE_GATOS_2.RECLAMO_CUPON
ADD CONSTRAINT FK_RECLAMO_CUPON_TIPO FOREIGN KEY (RECLAMO_CUPON_TIPO_ID) REFERENCES BASE_DE_GATOS_2.RECLAMO_CUPON_TIPO(RECLAMO_CUPON_TIPO_ID),
CONSTRAINT FK_RECLAMO_CUPON_CUPON FOREIGN KEY (CUPON_NUMERO) REFERENCES BASE_DE_GATOS_2.CUPONES(CUPON_NUMERO),
CONSTRAINT FK_RECLAMO_CUPON_RECLAMO FOREIGN KEY (RECLAMO_NUMERO) REFERENCES BASE_DE_GATOS_2.RECLAMOS(RECLAMO_NUMERO);

ALTER TABLE BASE_DE_GATOS_2.PEDIDO_CUPON
ADD CONSTRAINT FK_PEDIDO_CUPON_PEDIDO FOREIGN KEY (PEDIDO_NUMERO) REFERENCES BASE_DE_GATOS_2.PEDIDOS(PEDIDO_NUMERO),
CONSTRAINT FK_PEDIDO_CUPON_CUPON FOREIGN KEY (CUPON_NUMERO) REFERENCES BASE_DE_GATOS_2.CUPONES(CUPON_NUMERO),
CONSTRAINT FK_PEDIDO_CUPON_CUPON_TIPO FOREIGN KEY (CUPON_TIPO_ID) REFERENCES BASE_DE_GATOS_2.CUPON_TIPO(CUPON_TIPO_ID);

ALTER TABLE BASE_DE_GATOS_2.CUPONES
ADD CONSTRAINT FK_USUARIO_CUPONES FOREIGN KEY (USUARIO_ID) REFERENCES BASE_DE_GATOS_2.USUARIOS(USUARIO_ID);

ALTER TABLE BASE_DE_GATOS_2.LOCALES
ADD CONSTRAINT FK_LOCAL_CATEGORIA_LOCALES FOREIGN KEY (LOCAL_CATEGORIA_ID) REFERENCES BASE_DE_GATOS_2.LOCAL_CATEGORIAS(LOCAL_CATEGORIA_ID),
CONSTRAINT FK_LOCAL_DIRECCION_LOCALES FOREIGN KEY (LOCAL_DIRECCION_ID) REFERENCES BASE_DE_GATOS_2.DIRECCION(DIRECCION_ID);

ALTER TABLE BASE_DE_GATOS_2.LOCAL_CATEGORIAS 
ADD CONSTRAINT FK_LOCAL_TIPO_LOCAL_CATEGORIAS FOREIGN KEY (LOCAL_TIPO_ID) REFERENCES BASE_DE_GATOS_2.LOCAL_TIPOS(LOCAL_TIPO_ID);

ALTER TABLE BASE_DE_GATOS_2.LOCAL_PRODUCTO 
ADD CONSTRAINT FK_LP_LOCAL_LOCAL_PRODUCTO FOREIGN KEY (LP_LOCAL_ID) REFERENCES BASE_DE_GATOS_2.LOCALES(LOCAL_ID),
CONSTRAINT FK_LP_PRODUCTO_LOCAL_PRODUCTO FOREIGN KEY (LP_PRODUCTO_ID) REFERENCES BASE_DE_GATOS_2.PRODUCTOS(PRODUCTO_ID);

ALTER TABLE BASE_DE_GATOS_2.LOCAL_PRODUCTO_PEDIDO 
ADD CONSTRAINT FK_LPC_LOCAL_PRODUCTO_LOCAL_PRODUCTO_PEDIDO FOREIGN KEY (LPC_LP_LOCAL_ID, LPC_LP_PRODUCTO_ID) REFERENCES BASE_DE_GATOS_2.LOCAL_PRODUCTO(LP_LOCAL_ID, LP_PRODUCTO_ID),
CONSTRAINT FK_LPC_PEDIDO_LOCAL_PRODUCTO_PEDIDO FOREIGN KEY (LPC_PEDIDO_ID) REFERENCES BASE_DE_GATOS_2.PEDIDOS(PEDIDO_NUMERO);

ALTER TABLE BASE_DE_GATOS_2.HORARIOS
ADD CONSTRAINT FK_HORARIO_DIA_HORARIOS FOREIGN KEY (HORARIO_DIA_ID) REFERENCES BASE_DE_GATOS_2.HORARIO_DIAS(HORARIO_DIA_ID),
CONSTRAINT FK_LOCAL_HORARIOS FOREIGN KEY (LOCAL_ID) REFERENCES BASE_DE_GATOS_2.LOCALES(LOCAL_ID);

ALTER TABLE BASE_DE_GATOS_2.LOCALIDADES
ADD CONSTRAINT FK_LOCALIDAD_PROVINCIA_LOCALIDADES FOREIGN KEY (LOCALIDAD_PROVINCIA_ID) REFERENCES BASE_DE_GATOS_2.PROVINCIAS(PROVINCIA_ID);

ALTER TABLE BASE_DE_GATOS_2.DIRECCION
ADD CONSTRAINT FK_LOCALIDAD_DIRECCION FOREIGN KEY (LOCALIDAD_ID) REFERENCES BASE_DE_GATOS_2.LOCALIDADES(LOCALIDAD_ID);

ALTER TABLE BASE_DE_GATOS_2.REPARTIDORES
ADD CONSTRAINT FK_REPARTIDOR_LOCALIDAD_ACTIVA_REPARTIDORES FOREIGN KEY (REPARTIDOR_LOCALIDAD_ACTIVA) REFERENCES BASE_DE_GATOS_2.LOCALIDADES(LOCALIDAD_ID),
CONSTRAINT FK_REPARTIDOR_TIPO_MOVILIDAD_REPARTIDORES FOREIGN KEY (REPARTIDOR_TIPO_MOVILIDAD) REFERENCES BASE_DE_GATOS_2.MOVILIDAD(MOVILIDAD_ID);

ALTER TABLE BASE_DE_GATOS_2.ENVIO_PEDIDO
ADD CONSTRAINT FK_EP_REPARTIDOR_ENVIO_PEDIDO FOREIGN KEY (EP_REPARTIDOR) REFERENCES BASE_DE_GATOS_2.REPARTIDORES(REPARTIDOR_ID),
CONSTRAINT FK_EP_DIRECCION_ENVIO_PEDIDO FOREIGN KEY (EP_DIRECCION) REFERENCES BASE_DE_GATOS_2.DIRECCION(DIRECCION_ID);

ALTER TABLE BASE_DE_GATOS_2.MEDIOS_DE_PAGO
ADD CONSTRAINT FK_TIPO_MEDIO_PAGO_MEDIO_PAGO FOREIGN KEY (MP_TIPO) REFERENCES BASE_DE_GATOS_2.TIPO_MEDIO_DE_PAGO(TIPO_MEDIO_PAGO_ID),
CONSTRAINT FK_TIPO_MARCAS_TARJETA_MEDIO_PAGO FOREIGN KEY (MP_MARCA_TARJETA) REFERENCES BASE_DE_GATOS_2.MARCAS_TARJETA(MARCA_TARJETA_ID),
CONSTRAINT FK_TIPO_USUARIOS_MEDIO_PAGO FOREIGN KEY (MP_USUARIO) REFERENCES BASE_DE_GATOS_2.USUARIOS(USUARIO_ID);

ALTER TABLE BASE_DE_GATOS_2.DIRECCION_USUARIO
ADD CONSTRAINT FK_USUARIOS_DIRECCION_USUARIO FOREIGN KEY (DU_USUARIO_ID) REFERENCES BASE_DE_GATOS_2.USUARIOS (USUARIO_ID),
CONSTRAINT FK_DIRECCION_DIRECCION_USUARIO FOREIGN KEY (DU_DIRECCION_ID) REFERENCES BASE_DE_GATOS_2.DIRECCION (DIRECCION_ID);

ALTER TABLE BASE_DE_GATOS_2.PEDIDOS
ADD CONSTRAINT FK_ESTADO_PEDIDO_PEDIDOS FOREIGN KEY (PEDIDO_ESTADO) REFERENCES BASE_DE_GATOS_2.ESTADO_PEDIDO(ESTADO_PEDIDO_ID),
CONSTRAINT FK_USUARIO_PEDIDOS FOREIGN KEY (PEDIDO_USUARIO) REFERENCES BASE_DE_GATOS_2.USUARIOS(USUARIO_ID),
CONSTRAINT FK_LOCAL_PEDIDOS FOREIGN KEY (PEDIDO_LOCAL) REFERENCES BASE_DE_GATOS_2.LOCALES(LOCAL_ID),
CONSTRAINT FK_MEDIO_DE_PAGO_PEDIDOS FOREIGN KEY (PEDIDO_MEDIO_PAGO) REFERENCES BASE_DE_GATOS_2.MEDIOS_DE_PAGO(MP_ID);

ALTER TABLE BASE_DE_GATOS_2.RECLAMOS
ADD CONSTRAINT FK_TIPO_RECLAMO_RECLAMOS FOREIGN KEY (RECLAMO_TIPO) REFERENCES BASE_DE_GATOS_2.TIPO_RECLAMO(TIPO_RECLAMO_ID),
CONSTRAINT FK_ESTADO_RECLAMO_RECLAMOS FOREIGN KEY (RECLAMO_ESTADO) REFERENCES BASE_DE_GATOS_2.ESTADO_RECLAMO(ESTADO_RECLAMO_ID),
CONSTRAINT FK_USUARIOS_RECLAMOS FOREIGN KEY (RECLAMO_USUARIO) REFERENCES BASE_DE_GATOS_2.USUARIOS(USUARIO_ID),
CONSTRAINT FK_PEDIDOS_RECLAMOS FOREIGN KEY (RECLAMO_PEDIDO) REFERENCES BASE_DE_GATOS_2.PEDIDOS(PEDIDO_NUMERO),
CONSTRAINT FK_OPERADORES_RECLAMOS FOREIGN KEY (RECLAMO_OPERADOR) REFERENCES BASE_DE_GATOS_2.OPERADORES(OPERADOR_ID);

ALTER TABLE BASE_DE_GATOS_2.ENVIO_MENSAJERIA
ADD CONSTRAINT FK_ESTADO_ENVIO_MENSAJERIA FOREIGN KEY (EM_ESTADO) REFERENCES BASE_DE_GATOS_2.ESTADO_ENVIO_MENSAJERIA (ESTADO_EM_ID),
CONSTRAINT FK_USUARIO_ENVIO_MENSAJERIA FOREIGN KEY (EM_USUARIO) REFERENCES BASE_DE_GATOS_2.USUARIOS (USUARIO_ID),
CONSTRAINT FK_TIPO_PAQUETE_ENVIO_MENSAJERIA FOREIGN KEY (EM_TIPO_PAQUETE) REFERENCES BASE_DE_GATOS_2.TIPO_PAQUETES (TP_ID),
CONSTRAINT FK_REPARTIDOR_ENVIO_MENSAJERIA FOREIGN KEY (EM_REPARTIDOR) REFERENCES BASE_DE_GATOS_2.REPARTIDORES (REPARTIDOR_ID),
CONSTRAINT FK_MEDIO_DE_PAGO_ENVIO_MENSAJERIA FOREIGN KEY (EM_MEDIO_DE_PAGO) REFERENCES BASE_DE_GATOS_2.MEDIOS_DE_PAGO (MP_ID);


--Tipo paquetes
DROP PROCEDURE IF EXISTS migrar_tipo_paquetes
GO
CREATE PROCEDURE migrar_tipo_paquetes
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.TIPO_PAQUETES (TP_NOMBRE, TP_ALTO_MAX, TP_ANCHO_MAX, TP_LARGO_MAX, TP_PESO_MAX, TP_TIPO_PRECIO)
			SELECT DISTINCT
				PAQUETE_TIPO,
				PAQUETE_ALTO_MAX,
				PAQUETE_ANCHO_MAX,
				PAQUETE_LARGO_MAX,
				PAQUETE_PESO_MAX,
				PAQUETE_TIPO_PRECIO
			FROM 
				gd_esquema.Maestra
			WHERE 
				PAQUETE_TIPO IS NOT NULL
				AND PAQUETE_ALTO_MAX IS NOT NULL
				AND PAQUETE_ANCHO_MAX IS NOT NULL
				AND PAQUETE_LARGO_MAX IS NOT NULL
				AND PAQUETE_PESO_MAX IS NOT NULL
				AND PAQUETE_TIPO_PRECIO IS NOT NULL
		END
GO

--Estado envio mensajeria
DROP PROCEDURE IF EXISTS migrar_estado_envio_mensajeria
GO
CREATE PROCEDURE migrar_estado_envio_mensajeria
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.ESTADO_ENVIO_MENSAJERIA(ESTADO_EM_NOMBRE)
			SELECT DISTINCT
				ENVIO_MENSAJERIA_ESTADO
			FROM 
				gd_esquema.Maestra
			WHERE 
				ENVIO_MENSAJERIA_ESTADO IS NOT NULL
		END
GO

-- Horario Dias
DROP PROCEDURE IF EXISTS migrar_horario_dias
GO
CREATE PROCEDURE migrar_horario_dias
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.HORARIO_DIAS(HORARIO_LOCAL_DIA)
			SELECT DISTINCT
				HORARIO_LOCAL_DIA
			FROM 
				gd_esquema.Maestra
			WHERE 
				HORARIO_LOCAL_DIA IS NOT NULL
		END
GO

--Local tipos
DROP PROCEDURE IF EXISTS migrar_local_tipos
GO
CREATE PROCEDURE migrar_local_tipos
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.LOCAL_TIPOS(LOCAL_TIPO_NOMBRE)
			SELECT DISTINCT
				LOCAL_TIPO
			FROM 
				gd_esquema.Maestra
			WHERE 
				LOCAL_TIPO IS NOT NULL
		END
GO

--Local categorias
DROP PROCEDURE IF EXISTS migrar_local_categorias
GO
CREATE PROCEDURE migrar_local_categorias
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.LOCAL_CATEGORIAS(LOCAL_CATEGORIA_NOMBRE, LOCAL_TIPO_ID)
			SELECT DISTINCT
				m.LOCAL_TIPO,
				lt.LOCAL_TIPO_ID
			FROM 
				gd_esquema.Maestra m
					JOIN BASE_DE_GATOS_2.LOCAL_TIPOS lt ON m.LOCAL_TIPO = lt.LOCAL_TIPO_NOMBRE
			WHERE 
				m.LOCAL_TIPO IS NOT NULL
		END
GO


--Locales
DROP PROCEDURE IF EXISTS migrar_locales
GO
CREATE PROCEDURE migrar_locales
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.LOCALES(LOCAL_NOMBRE, LOCAL_DESCRIPCION, LOCAL_DIRECCION_ID, LOCAL_CATEGORIA_ID)
			SELECT DISTINCT
				m.LOCAL_NOMBRE,
				m.LOCAL_DESCRIPCION,
				d.DIRECCION_ID,
				lc.LOCAL_CATEGORIA_ID
			FROM 
				gd_esquema.Maestra m
					JOIN BASE_DE_GATOS_2.LOCAL_CATEGORIAS lc ON m.LOCAL_TIPO = lc.LOCAL_CATEGORIA_NOMBRE 
					JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.LOCAL_PROVINCIA = p.PROVINCIA_NOMBRE
					JOIN BASE_DE_GATOS_2.LOCALIDADES l ON m.LOCAL_LOCALIDAD = l.LOCALIDAD_NOMBRE AND l.LOCALIDAD_PROVINCIA_ID = p.PROVINCIA_ID
					JOIN BASE_DE_GATOS_2.DIRECCION d ON m.LOCAL_DIRECCION = d.DIRECCION_DIRECCION AND d.LOCALIDAD_ID = l.LOCALIDAD_ID
			WHERE 
				m.LOCAL_NOMBRE IS NOT NULL AND
				m.LOCAL_DESCRIPCION IS NOT NULL AND
				m.LOCAL_DIRECCION IS NOT NULL AND
				m.LOCAL_LOCALIDAD IS NOT NULL AND
				m.LOCAL_TIPO IS NOT NULL 
		END
GO

-- Horarios
DROP PROCEDURE IF EXISTS migrar_horarios
GO
CREATE PROCEDURE migrar_horarios
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.HORARIOS(HORARIO_DIA_ID, HORARIO_LOCAL_HORA_APERTURA, HORARIO_LOCAL_HORA_CIERRE, LOCAL_ID)
			SELECT DISTINCT
				hd.HORARIO_DIA_ID,
				m.HORARIO_LOCAL_HORA_APERTURA,
				m.HORARIO_LOCAL_HORA_CIERRE,
				l.LOCAL_ID
			FROM 
				BASE_DE_GATOS_2.HORARIO_DIAS hd
					JOIN gd_esquema.Maestra m ON
						hd.HORARIO_LOCAL_DIA = m.HORARIO_LOCAL_DIA
					JOIN BASE_DE_GATOS_2.LOCALES l ON
						l.LOCAL_NOMBRE = m.LOCAL_NOMBRE
			WHERE
				hd.HORARIO_DIA_ID IS NOT NULL
				AND m.HORARIO_LOCAL_HORA_APERTURA IS NOT NULL
				AND m.HORARIO_LOCAL_HORA_CIERRE IS NOT NULL
				AND l.LOCAL_NOMBRE IS NOT NULL
		END
GO

--Productos
DROP PROCEDURE IF EXISTS migrar_productos
GO
CREATE PROCEDURE migrar_productos
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.PRODUCTOS(PRODUCTO_CODIGO, PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION)
			SELECT DISTINCT
				PRODUCTO_LOCAL_CODIGO,
				PRODUCTO_LOCAL_NOMBRE,
				PRODUCTO_LOCAL_DESCRIPCION
			FROM 
				gd_esquema.Maestra
			WHERE 
				PRODUCTO_LOCAL_CODIGO IS NOT NULL AND
				PRODUCTO_LOCAL_NOMBRE IS NOT NULL AND
				PRODUCTO_LOCAL_DESCRIPCION IS NOT NULL
		END
GO

DROP PROCEDURE IF EXISTS migrar_local_producto
GO
CREATE PROCEDURE migrar_local_producto
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.LOCAL_PRODUCTO(LP_LOCAL_ID, LP_PRODUCTO_ID, LP_PRODUCTO_PRECIO)
			SELECT DISTINCT
				l.LOCAL_ID,
				p.PRODUCTO_ID,
				m.PRODUCTO_LOCAL_PRECIO
			FROM 
				gd_esquema.Maestra m
					JOIN BASE_DE_GATOS_2.PRODUCTOS p ON 
						m.PRODUCTO_LOCAL_CODIGO = p.PRODUCTO_CODIGO
						AND m.PRODUCTO_LOCAL_NOMBRE = p.PRODUCTO_NOMBRE
						AND m.PRODUCTO_LOCAL_DESCRIPCION = p.PRODUCTO_DESCRIPCION
					JOIN BASE_DE_GATOS_2.LOCALES l ON
						l.LOCAL_NOMBRE = m.LOCAL_NOMBRE
						AND l.LOCAL_DESCRIPCION = m.LOCAL_DESCRIPCION
		END
GO

--Estado pedido
DROP PROCEDURE IF EXISTS migrar_estado_pedido
GO
CREATE PROCEDURE migrar_estado_pedido
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.ESTADO_PEDIDO(ESTADO_PEDIDO_NOMBRE)
			SELECT DISTINCT
				m.PEDIDO_ESTADO
			FROM 
				gd_esquema.Maestra m
			WHERE 
				m.PEDIDO_ESTADO IS NOT NULL
		END
GO

--Usuarios
DROP PROCEDURE IF EXISTS migrar_usuarios
GO
CREATE PROCEDURE migrar_usuarios
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.USUARIOS(USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO, USUARIO_MAIL, USUARIO_FECHA_NAC)
			SELECT DISTINCT
				m.USUARIO_NOMBRE,
				m.USUARIO_APELLIDO,
				m.USUARIO_DNI,
				m.USUARIO_FECHA_REGISTRO,
				m.USUARIO_TELEFONO,
				m.USUARIO_MAIL,
				m.USUARIO_FECHA_NAC
			FROM 
				gd_esquema.Maestra m
			WHERE 
				m.USUARIO_NOMBRE IS NOT NULL AND
				m.USUARIO_APELLIDO IS NOT NULL AND
				m.USUARIO_DNI IS NOT NULL AND
				m.USUARIO_FECHA_REGISTRO IS NOT NULL AND
				m.USUARIO_TELEFONO IS NOT NULL AND
				m.USUARIO_MAIL IS NOT NULL AND
				m.USUARIO_FECHA_NAC IS NOT NULL
		END
GO

--Provincias
DROP PROCEDURE IF EXISTS migrar_provincias
GO
CREATE PROCEDURE migrar_provincias
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.PROVINCIAS(PROVINCIA_NOMBRE)
			SELECT DISTINCT
				m.DIRECCION_USUARIO_PROVINCIA
			FROM gd_esquema.Maestra m
			WHERE m.DIRECCION_USUARIO_PROVINCIA IS NOT NULL

			UNION
			
			SELECT 
				m.ENVIO_MENSAJERIA_PROVINCIA
			FROM gd_esquema.Maestra m
			WHERE m.ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL

			UNION

			SELECT 
				m.LOCAL_PROVINCIA
			FROM gd_esquema.Maestra m
			WHERE m.LOCAL_PROVINCIA IS NOT NULL
		END
GO


/*
-- Local Producto Pedido SOLO SE PUEDE MIGRAR UNA VEZ MIGRADA LA TABLA PEDIDOS
DROP PROCEDURE IF EXISTS migrar_local_producto_pedido
GO
CREATE PROCEDURE migrar_local_producto_pedido
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.LOCAL_PRODUCTO_PEDIDO(
			LPC_LP_LOCAL_ID,
			LPC_LP_PRODUCTO_ID,
			LPC_PEDIDO_ID,
			LPC_PRODUCTO_CANTIDAD,
			LPC_PRODUCTO_PRECIO
		)
			SELECT 
				lp.LP_LOCAL_ID,
				lp.LP_PRODUCTO_ID,
				m.PEDIDO_NUMERO,
				m.PRODUCTO_CANTIDAD,
				m.PRODUCTO_LOCAL_PRECIO
			FROM
				BASE_DE_GATOS_2.LOCAL_PRODUCTO lp
					JOIN BASE_DE_GATOS_2.LOCALES l ON
						lp.LP_LOCAL_ID = l.LOCAL_ID
					JOIN BASE_DE_GATOS_2.PRODUCTOS p ON
						lp.LP_PRODUCTO_ID = p.PRODUCTO_ID
					JOIN gd_esquema.Maestra m ON
						l.LOCAL_NOMBRE = m.LOCAL_NOMBRE
						AND l.LOCAL_DESCRIPCION = m.LOCAL_DESCRIPCION
						AND l.LOCAL_DIRECCION = m.LOCAL_DIRECCION
						AND l.LOCAL_LOCALIDAD = m.LOCAL_LOCALIDAD
						AND p.PRODUCTO_CODIGO = m.PRODUCTO_LOCAL_CODIGO
						AND p.PRODUCTO_NOMBRE = m.PRODUCTO_LOCAL_NOMBRE
						AND p.PRODUCTO_DESCRIPCION = m.PRODUCTO_LOCAL_DESCRIPCION
			END
GO
*/

-- Localidades
DROP PROCEDURE IF EXISTS migrar_localidades
GO
CREATE PROCEDURE migrar_localidades
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.LOCALIDADES(LOCALIDAD_NOMBRE, LOCALIDAD_PROVINCIA_ID)
			SELECT DISTINCT 
				m.ENVIO_MENSAJERIA_LOCALIDAD, 
				p.PROVINCIA_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.ENVIO_MENSAJERIA_PROVINCIA = p.PROVINCIA_NOMBRE

			UNION

			SELECT DISTINCT 
				DIRECCION_USUARIO_LOCALIDAD,
				p.PROVINCIA_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.DIRECCION_USUARIO_PROVINCIA = p.PROVINCIA_NOMBRE

			UNION

			SELECT DISTINCT 
				m.LOCAL_LOCALIDAD,
				p.PROVINCIA_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.LOCAL_PROVINCIA = p.PROVINCIA_NOMBRE
		END
GO

-- Direcciones
DROP PROCEDURE IF EXISTS migrar_direcciones
GO
CREATE PROCEDURE migrar_direcciones
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.DIRECCION(DIRECCION_DIRECCION, LOCALIDAD_ID)
			SELECT DISTINCT 
				m.ENVIO_MENSAJERIA_DIR_ORIG direcciones,
				l.LOCALIDAD_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.ENVIO_MENSAJERIA_PROVINCIA = p.PROVINCIA_NOMBRE
				JOIN BASE_DE_GATOS_2.LOCALIDADES l ON m.ENVIO_MENSAJERIA_LOCALIDAD = l.LOCALIDAD_NOMBRE AND l.LOCALIDAD_PROVINCIA_ID = p.PROVINCIA_ID

			UNION

			SELECT DISTINCT 
				m.ENVIO_MENSAJERIA_DIR_DEST,
				l.LOCALIDAD_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.ENVIO_MENSAJERIA_PROVINCIA = p.PROVINCIA_NOMBRE
				JOIN BASE_DE_GATOS_2.LOCALIDADES l ON m.ENVIO_MENSAJERIA_LOCALIDAD = l.LOCALIDAD_NOMBRE AND l.LOCALIDAD_PROVINCIA_ID = p.PROVINCIA_ID

			UNION

			SELECT DISTINCT 
				m.DIRECCION_USUARIO_DIRECCION,
				l.LOCALIDAD_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.DIRECCION_USUARIO_PROVINCIA = p.PROVINCIA_NOMBRE
				JOIN BASE_DE_GATOS_2.LOCALIDADES l ON m.DIRECCION_USUARIO_LOCALIDAD = l.LOCALIDAD_NOMBRE AND l.LOCALIDAD_PROVINCIA_ID = p.PROVINCIA_ID

			UNION

			SELECT DISTINCT 
				LOCAL_DIRECCION,
				l.LOCALIDAD_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.LOCAL_PROVINCIA = p.PROVINCIA_NOMBRE
				JOIN BASE_DE_GATOS_2.LOCALIDADES l ON m.LOCAL_LOCALIDAD = l.LOCALIDAD_NOMBRE AND l.LOCALIDAD_PROVINCIA_ID = p.PROVINCIA_ID
		END
GO

-- Direccion usuario
DROP PROCEDURE IF EXISTS migrar_direccion_usuario
GO
CREATE PROCEDURE migrar_direccion_usuario
	AS
		BEGIN
		INSERT INTO BASE_DE_GATOS_2.DIRECCION_USUARIO(DU_USUARIO_ID, DU_DIRECCION_NOMBRE, DU_DIRECCION_ID)
			SELECT DISTINCT
				u.USUARIO_ID,
				m.DIRECCION_USUARIO_NOMBRE,
				d.DIRECCION_ID
			FROM gd_esquema.Maestra m
				JOIN BASE_DE_GATOS_2.PROVINCIAS p ON m.DIRECCION_USUARIO_PROVINCIA = p.PROVINCIA_NOMBRE
				JOIN BASE_DE_GATOS_2.LOCALIDADES l ON m.DIRECCION_USUARIO_LOCALIDAD = l.LOCALIDAD_NOMBRE AND l.LOCALIDAD_PROVINCIA_ID = p.PROVINCIA_ID
				JOIN BASE_DE_GATOS_2.DIRECCION d ON m.DIRECCION_USUARIO_DIRECCION = d.DIRECCION_DIRECCION AND d.LOCALIDAD_ID = l.LOCALIDAD_ID
				JOIN BASE_DE_GATOS_2.USUARIOS u ON m.USUARIO_NOMBRE = u.USUARIO_NOMBRE
					AND m.USUARIO_APELLIDO = u.USUARIO_APELLIDO
					AND m.USUARIO_DNI = u.USUARIO_DNI
					AND m.USUARIO_FECHA_REGISTRO = u.USUARIO_FECHA_REGISTRO
					AND m.USUARIO_TELEFONO = u.USUARIO_TELEFONO
					AND m.USUARIO_MAIL = u.USUARIO_MAIL
					AND m.USUARIO_FECHA_NAC = u.USUARIO_FECHA_NAC
			WHERE m.DIRECCION_USUARIO_NOMBRE IS NOT NULL
		END
GO

-- Executes
EXEC migrar_local_tipos
EXEC migrar_local_categorias
EXEC migrar_provincias
EXEC migrar_localidades
EXEC migrar_direcciones
EXEC migrar_locales
EXEC migrar_horario_dias
EXEC migrar_horarios
EXEC migrar_productos
EXEC migrar_local_producto

EXEC migrar_estado_pedido
EXEC migrar_tipo_paquetes
EXEC migrar_estado_envio_mensajeria
EXEC migrar_usuarios
EXEC migrar_direccion_usuario

-- EXEC migrar_local_producto_pedido // HAY QUE MIGRAR PEDIDOS ANTES

COMMIT




