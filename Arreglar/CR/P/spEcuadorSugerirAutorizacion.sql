SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEcuadorSugerirAutorizacion
@Sucursal		int,
@Empresa     	char(5),
@Modulo		char(5),
@Mov			varchar(20),
@Campo		varchar(50),
@FechaEmision	datetime,
@Proveedor		varchar(10) = NULL

AS BEGIN
DECLARE @EcuadorMostrarAnexo		varchar(20),
@AutorizacionSRI		varchar(50),
@PuntoEmision			varchar(50),
@Articulo			varchar(50),
@Resultado			varchar(50),
@VigenteA			datetime,
@EsEcuador			bit,
@TipoRegistro			varchar(20),
@Establecimiento		varchar(20)
SELECT @EsEcuador = EsEcuador FROM Empresa WHERE Empresa = @Empresa
SELECT @EcuadorMostrarAnexo = RTRIM(EcuadorMostrarAnexo) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @EcuadorMostrarAnexo IN ('Detalle','Encabezado') AND @EsEcuador = 1
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @Modulo = ConsecutivoModulo FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
SELECT TOP 1
@PuntoEmision = PuntoEmision,
@AutorizacionSRI = Autorizacion,
@VigenteA = Vigencia,
@Establecimiento = Establecimiento
FROM EcuadorAutorizacion
WHERE Modulo = @Modulo
AND Mov = @Mov
AND ISNULL(Sucursal,@Sucursal) = @Sucursal
AND Vigencia >= @FechaEmision
ORDER BY Vigencia DESC
IF @Campo = 'PuntoEmision'    SET @Resultado = @PuntoEmision    ELSE
IF @Campo = 'AutorizacionSRI' SET @Resultado = @AutorizacionSRI ELSE
IF @Campo = 'Establecimiento' SET @Resultado = @Establecimiento ELSE
IF @Campo = 'VigenteA'        SET @Resultado = CONVERT(varchar,@VigenteA)
END ELSE
IF @Modulo IN ('COMS')
BEGIN
SELECT
@AutorizacionSRI = AutorizacionSRI,
@VigenteA = VigenciaSRI,
@TipoRegistro = TipoRegistro
FROM Prov
WHERE Proveedor = @Proveedor
IF @Campo = 'AutorizacionSRI'    SET @Resultado = @AutorizacionSRI ELSE
IF @Campo = 'VigenteA'           SET @Resultado = CONVERT(varchar,@VigenteA) ELSE
IF @Campo = 'TipoIdentificacion' SET @Resultado = @TipoRegistro
END ELSE
IF @Modulo IN ('GAS')
BEGIN
SELECT
@AutorizacionSRI = AutorizacionSRI,
@VigenteA = VigenciaSRI,
@TipoRegistro = TipoRegistro
FROM Prov
WHERE Proveedor = @Proveedor
IF @Campo = 'AutorizacionSRI'    SET @Resultado = @AutorizacionSRI ELSE
IF @Campo = 'VigenteA'           SET @Resultado = CONVERT(varchar,@VigenteA) ELSE
IF @Campo = 'TipoIdentificacion' SET @Resultado = @TipoRegistro
END
END
SELECT @Resultado
END

