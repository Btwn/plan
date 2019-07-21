SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerCuentaTipo
@CuentaTipo		varchar(20)

AS BEGIN
IF @CuentaTipo = 'Cliente'   SELECT 'Clave' = CONVERT(char(20), Cliente),   'Nombre' = convert(varchar(100), Nombre)		FROM Cte      ELSE
IF @CuentaTipo = 'Proveedor' SELECT 'Clave' = CONVERT(char(20), Proveedor), 'Nombre' = convert(varchar(100), Nombre)		FROM Prov     ELSE
IF @CuentaTipo = 'Personal'  SELECT 'Clave' = CONVERT(char(20), Personal),  'Nombre' = convert(varchar(100), RTRIM(Nombre+' '+ApellidoPaterno+' '+ApellidoMaterno))  FROM Personal ELSE
IF @CuentaTipo = 'Agente'    SELECT 'Clave' = CONVERT(char(20), Agente),    'Nombre' = convert(varchar(100), Nombre)		FROM Agente   ELSE
IF @CuentaTipo = 'Almacen'   SELECT 'Clave' = CONVERT(char(20), Almacen),   'Nombre' = convert(varchar(100), Nombre)		FROM Alm   ELSE
IF @CuentaTipo = 'Articulo'  SELECT 'Clave' = CONVERT(char(20), Articulo),   'Nombre' = convert(varchar(100), Descripcion1) FROM Art
ELSE SELECT CONVERT(char(20), NULL), CONVERT(varchar(100), NULL)
RETURN
END

