SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_agdCartaCupoLeer
@ArchivoID	int,
@ArchivoNombre	varchar(255),
@ArchivoTipo	char(1),
@Hoy		datetime,
@Ahora		datetime,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ID			int,
@Tipo		varchar(50),
@Datos		varchar(8000),
@Valor		varchar(255),
@Conteo		int,
@EstatusInterfase	varchar(15),
@TipoMovimiento	char(1),
@Pedimento		varchar(20),
@AduanaDespacho	varchar(10),
@TipoDocumento	varchar(10),
@Cliente		varchar(10),
@ClienteRFC		varchar(20),
@AgenteAduanal	varchar(10),
@AgenteAduanalCURP	varchar(20),
@AgenteAduanalRFC	varchar(20),
@DestinoMercancia	varchar(10),
@TipoCaso		varchar(5),
@SF			varchar(5),
@AG			varchar(5),
@CC			varchar(5),
@Fraccion		varchar(20),
@Secuencia		int,
@ValorEnDolares	money,
@Cantidad		float,
@UnidadInt		int,
@UnidadMedidaTarifa	varchar(10),
@ConsecutivoTipo	varchar(50),
@Folio		varchar(10),
@Firma		varchar(50)
SELECT @Tipo = 'Carta Cupo', @EstatusInterfase = NULL, @Firma = NULL
DECLARE crArchivoD CURSOR LOCAL FOR
SELECT Datos
FROM ArchivoD
WHERE ID = @ArchivoID
ORDER BY RID
OPEN crArchivoD
FETCH NEXT FROM crArchivoD INTO @Datos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
IF @Valor = '500'
BEGIN
SELECT @EstatusInterfase = 'INICIO'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @TipoMovimiento = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @AgenteAduanal  = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @Pedimento      = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @AduanaDespacho = @Valor
INSERT agdCartaCupo
(Estatus,    Situacion, TipoMovimiento,  AgenteAduanal,  Pedimento,  AduanaDespacho)
VALUES ('BORRADOR', 'Normal',  @TipoMovimiento, @AgenteAduanal, @Pedimento, @AduanaDespacho)
SELECT @ID = SCOPE_IDENTITY()
END ELSE
IF @EstatusInterfase = 'INICIO'
BEGIN
IF @Valor = '501'
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @TipoDocumento = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @ClienteRFC = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @AgenteAduanalCURP = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @AgenteAduanalRFC = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @DestinoMercancia = @Valor
END ELSE
IF @Valor = '507'
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @TipoCaso = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
IF @TipoCaso = 'SF' SELECT @SF = @Valor ELSE
IF @TipoCaso = 'AG' SELECT @AG = @Valor ELSE
IF @TipoCaso = 'CC' SELECT @CC = @Valor
END ELSE
IF @Valor = '551'
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @Fraccion = @Valor
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @Secuencia = CONVERT(int, @Valor)
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @ValorEnDolares = CONVERT(money, @Valor)
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|'
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @Cantidad = CONVERT(float, @Valor)
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' SELECT @UnidadInt = CONVERT(int, @Valor)
EXEC spLlenarCeros @UnidadInt, 2, @UnidadMedidaTarifa OUTPUT
INSERT agdCartaCupoD
(ID,  Fraccion,  Secuencia,  ValorEnDolares,  Cantidad,  UnidadMedidaTarifa)
VALUES (@ID, @Fraccion, @Secuencia, @ValorEnDolares, @Cantidad, @UnidadMedidaTarifa)
END ELSE
IF @Valor = '801'
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' IF UPPER(@Valor) <> UPPER(@ArchivoNombre) SELECT @Ok = 16030
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' IF @Valor <> '1' SELECT @Ok = 16040
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, '|' IF CONVERT(int, @Valor) <> @Conteo SELECT @Ok = 16050
SELECT @EstatusInterfase = 'FIN'
END
END
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crArchivoD INTO @Datos
END
CLOSE crArchivoD
DEALLOCATE crArchivoD
IF @EstatusInterfase <> 'FIN' AND @Ok IS NULL SELECT @Ok = 16020
IF @Ok IS NULL
BEGIN
SELECT @Cliente = NULL, @AgenteAduanal = NULL
SELECT @Cliente = Cliente FROM Cte WHERE RFC = @ClienteRFC
IF @Cliente IS NULL SELECT @Ok = 16060, @OkRef = @ClienteRFC
SELECT @AgenteAduanal = MIN(Proveedor) FROM Prov WHERE RFC = @AgenteAduanalRFC OR CURP = @AgenteAduanalCURP
IF @AgenteAduanal IS NULL SELECT @Ok = 16070, @OkRef = @AgenteAduanalRFC
IF (SELECT Almacen FROM Alm WHERE Almacen = @AG) <> @AG
SELECT @Ok = 16080, @OkRef = @AG
END
IF @Ok IS NULL
BEGIN
SELECT @ConsecutivoTipo = @Tipo + ' ' + CONVERT(varchar, YEAR(@Hoy))
IF NOT EXISTS(SELECT * FROM Consecutivo WHERE Tipo = @ConsecutivoTipo)
INSERT Consecutivo (Tipo, Nivel, Prefijo, Consecutivo) VALUES (@ConsecutivoTipo, 'Global', NULL, 0)
EXEC spConsecutivo @ConsecutivoTipo, 0, @Folio OUTPUT
UPDATE agdCartaCupo
SET FechaEmision      = @Hoy,
FechaExpedicion   = @Ahora,
Folio             = @Folio,
TipoDocumento     = @TipoDocumento,
Cliente	     = @Cliente,
ClienteRFC        = @ClienteRFC,
AgenteAduanal     = @AgenteAduanal,
AgenteAduanalCURP = @AgenteAduanalCURP,
AgenteAduanalRFC  = @AgenteAduanalRFC,
DestinoMercancia  = @DestinoMercancia,
SF                = @SF,
AG		     = @AG,
CC		     = @CC
WHERE ID = @ID
INSERT agdCartaCupoArchivo
(ID,  TipoArchivo, Nombre,         Fecha,  Firma)
VALUES (@ID, @Tipo,       @ArchivoNombre, @Ahora, @Firma)
END
RETURN
END

