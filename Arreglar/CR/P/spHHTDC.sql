SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHHTDC
@TieneDatos		int,
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Modulo			char(5),
@ModuloID		int,
@Importe		money,
@Posicion		varchar(255)

AS
BEGIN
DECLARE
@IDLargo        int,
@ModuloID1		varchar(30),
@Suc            varchar(10),
@Ruta			varchar(255)
SET NOCOUNT ON
SELECT @ModuloID1 = CONVERT(int, CONVERT(varchar(30), @ModuloID))
SELECT @Suc = ltrim(rtrim(CONVERT(int, CONVERT(varchar(10), @Sucursal))))
IF @Posicion = 'BancoA01'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA01 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA02'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA02 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA03'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA03 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA04'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA04 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA05'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA05 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA06'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA06 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA07'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA07 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
IF @Posicion = 'BancoA08'
BEGIN
SET @Ruta = (SELECT DISTINCT TDCA08 FROM POSCobroFormasPago WHERE Sucursal = @Suc)
END
SELECT 'TieneDatos'='SI',
'RutaEjecutableA'= @Ruta, 
'NombreServidorA'=SERVERPROPERTY('ServerName'),
'BaseDeDatosA'=DB_NAME(),
'UsuarioSQLA'='sa',
'ContrasenaA'='',
'EmpresaA'=rtrim(@Empresa),
'SucursalA'=rtrim(@Sucursal),
'EstacionA'= 0,
'UsuarioA'=ltrim(rtrim(@Usuario)),
'ModuloA'=@Modulo,
'ModuloIDA'=@ModuloID,
'OrdinalPagoA'=1,
'ImporteTotalA'=CASE WHEN @Modulo='POS' THEN @Importe ELSE 0 END,
'TipoTransaccionA'='Venta',
'OrigenTrnIDA'=0,
'VersionAppA'='1.0.12',
'AmbienteA'='Pruebas'
RETURN
END

