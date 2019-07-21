SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConcliarBanamex
@Sucursal		int,
@Estacion		int,
@Usuario		char(10)

AS BEGIN
SET NOCOUNT ON
DECLARE
@ClaveArchivo	char(20),
@ID			int,
@Institucion	char(20),
@ModuloID		int,
@AuxiliarID		int,
@MovID		varchar(20),
@p			int,
@Conciliado		bit,
@Tipo		char(1),
@CtaNombre		char(40),
@CtaSucursal	char(4),
@CtaNumero		char(16),
@UltEmpresa		char(5),
@Empresa		char(5),
@Moneda		char(10),
@MovCodigo		char(2),
@MovSucursal	char(4),
@MovReferencia1	char(10),
@MovReferencia2	char(20),
@MovImporte		money,
@MovSubCodigo	char(2),
@SucursalBancaria	int,
@CtaDinero		char(10),
@CtaDineroDestino	char(10),
@Ok			int,
@OkRef		varchar(255),
@OkDesc           	varchar(255),
@OkTipo           	varchar(50),
@Resultado		varchar(255),
@FechaArchivo	datetime,
@FechaRegistro 	datetime,
@Clave 			varchar(100),
@Observaciones		varchar(100),
@Mov			char(20),
@ConciliarPorSucursales	bit,
@DineroSucursal		int,
@RegistrosConciliados	int,
@RegistrosPendientes	int,
@Hoy			datetime,
@ConcliarNivelCheque	bit
SELECT @Institucion = 'BANAMEX',
@FechaRegistro = GETDATE(),
@CtaNumero = NULL, @CtaNombre = NULL, @CtaSucursal = NULL,
@Ok = NULL, @OkRef = NULL, @Resultado = NULL, @UltEmpresa = NULL,
@RegistrosConciliados = 0, @RegistrosPendientes = 0
SELECT @ConcliarNivelCheque = ISNULL(ConcliarNivelCheque, 0) FROM InstitucionFin WHERE Institucion = @Institucion
SELECT @Hoy = @FechaRegistro
EXEC spExtraerFecha @Hoy OUTPUT
CREATE TABLE #Conciliar(
ID			int		IDENTITY(1,1)	NOT NULL,
Tipo			char(1)		COLLATE Database_Default NULL,
CtaDinero		char(10)	COLLATE Database_Default NULL,
CtaDineroDestino	char(10)	COLLATE Database_Default NULL,
Empresa			char(5)		COLLATE Database_Default NULL,
Moneda			char(10)	COLLATE Database_Default NULL,
AuxiliarID		int		NULL,
MovImporte		money		NULL,
MovCodigo		char(2)		COLLATE Database_Default NULL,
MovSucursal		char(4)		COLLATE Database_Default NULL,
MovReferencia1		char(10)	COLLATE Database_Default NULL,
MovReferencia2		char(10)	COLLATE Database_Default NULL
CONSTRAINT priTempConciliar PRIMARY KEY CLUSTERED (ID)
)
DECLARE crListaSt CURSOR FOR
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @ClaveArchivo
SELECT @FechaArchivo = CONVERT(datetime, RTRIM(SUBSTRING(@ClaveArchivo, 1, 2)) + '/' + RTRIM(SUBSTRING(@ClaveArchivo, 3, 2)) + '/' + RTRIM(SUBSTRING(@ClaveArchivo, 5, 2)), 3)
IF @@ERROR <> 0 SELECT @Ok = 71060
IF @Ok IS NULL
DELETE Dinero WHERE FechaEmision = @FechaArchivo AND Estatus = 'BORRADOR' AND InstitucionMensaje IS NOT NULL
FETCH NEXT FROM crListaSt INTO @Clave
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @MovID = NULL
SELECT @Tipo = SUBSTRING(@Clave, 1, 1)
IF @Tipo IN ('N', 'A', 'C')
BEGIN
IF @Tipo = 'N'
BEGIN
SELECT @CtaNombre = NULL, @CtaSucursal = NULL, @CtaNumero = NULL
SELECT @CtaNombre   = RTRIM(SUBSTRING(@Clave,  2, 40)),
@CtaSucursal = RTRIM(SUBSTRING(@Clave, 42,  4)),
@CtaNumero   = RTRIM(SUBSTRING(@Clave, 46, 16))
END ELSE
BEGIN
SELECT @MovCodigo = NULL, @MovSucursal = NULL, @MovReferencia1 = NULL, @MovReferencia2 = NULL, @MovImporte = NULL, @MovSubCodigo = NULL
SELECT @MovCodigo      = RTRIM(SUBSTRING(@Clave,  2,  2)),
@MovSucursal    = RTRIM(SUBSTRING(@Clave,  4,  4)),
@MovReferencia1 = RTRIM(SUBSTRING(@Clave,  8, 10)),
@MovReferencia2 = RTRIM(SUBSTRING(@Clave, 18, 20)),
@MovImporte     = CONVERT(money, RTRIM(SUBSTRING(@Clave, 38, 17))) / 100,
@MovSubCodigo   = RTRIM(SUBSTRING(@Clave, 55,  2))
EXEC spQuitarCerosIzq @MovReferencia1 OUTPUT
IF @ConcliarNivelCheque = 1 AND @Tipo = 'C' AND dbo.fnEsNumerico(@MovReferencia1) = 1
BEGIN
IF ISNULL(CONVERT(int, RTRIM(@MovReferencia1)), 0) NOT IN (0, 40000)
SELECT @MovID = RTRIM(@MovReferencia1)
END
SELECT @SucursalBancaria = CONVERT(int, @MovSucursal)
END
IF @CtaNumero IS NULL OR @CtaNombre IS NULL OR @CtaSucursal IS NULL SELECT @Ok = 71060
IF @Tipo IN ('A', 'C') AND @Ok IS NULL
BEGIN
IF @MovCodigo IS NULL OR @MovSucursal IS NULL OR @MovImporte IS NULL SELECT @Ok = 71060
SELECT @CtaDinero = NULL, @Empresa = NULL
SELECT @CtaDinero = CtaDinero, @Empresa = Empresa, @Moneda = Moneda
FROM CtaDinero
WHERE Institucion = @Institucion AND UPPER(NumeroCta) = UPPER(@CtaNumero)
IF @CtaDinero = NULL AND dbo.fnEsNumerico(@CtaNumero) = 1
BEGIN
SELECT @CtaNumero = RTRIM(LTRIM(CONVERT(char, CONVERT(money, @CtaNumero))))
SELECT @p = CHARINDEX('.', @CtaNumero)
IF @p > 0 SELECT @CtaNumero = RTRIM(LTRIM(SUBSTRING(@CtaNumero, 1, @p-1)))
SELECT @CtaDinero = CtaDinero, @Empresa = Empresa, @Moneda = Moneda
FROM CtaDinero
WHERE Institucion = @Institucion AND UPPER(NumeroCta) = UPPER(@CtaNumero)
END
IF @CtaDinero IS NOT NULL
BEGIN
IF @Empresa IS NULL SELECT @Ok = 40160
IF @Ok IS NOT NULL CONTINUE
IF @Empresa <> @UltEmpresa
BEGIN
SELECT @ConciliarPorSucursales = ISNULL(DineroConciliarPorSucursales, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @UltEmpresa = @Empresa
END
SELECT @AuxiliarID = NULL
IF EXISTS(SELECT * FROM MensajeInstitucion WHERE Institucion = @Institucion AND Mensaje = @MovCodigo AND ConciliarMismaFecha = 1)
BEGIN
IF @Tipo = 'A'
SELECT @AuxiliarID = MIN(ID)
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Modulo = 'DIN' AND a.Cuenta = @CtaDinero AND ROUND(a.Cargo, 2) = @MovImporte
AND a.Conciliado = 0 AND a.EsCancelacion = 0
AND a.ID NOT IN (SELECT AuxiliarID FROM #Conciliar)
AND a.Fecha = @FechaArchivo
AND (@ConciliarPorSucursales = 0 OR (@SucursalBancaria IN (SELECT sb.Numero FROM SucursalBanco sb WHERE sb.Sucursal = a.Sucursal AND sb.Institucion = @Institucion)))
ELSE
SELECT @AuxiliarID = MIN(ID)
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Modulo = 'DIN' AND a.Cuenta = @CtaDinero AND ROUND(a.Abono, 2) = @MovImporte AND a.MovID = ISNULL(@MovID, a.MovID)
AND a.Conciliado = 0 AND a.EsCancelacion = 0
AND a.ID NOT IN (SELECT AuxiliarID FROM #Conciliar)
AND a.Fecha = @FechaArchivo
AND (@ConciliarPorSucursales = 0 OR (@SucursalBancaria IN (SELECT sb.Numero FROM SucursalBanco sb WHERE sb.Sucursal = a.Sucursal AND sb.Institucion = @Institucion)))
END ELSE
BEGIN
IF @Tipo = 'A'
SELECT @AuxiliarID = MIN(ID)
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Modulo = 'DIN' AND a.Cuenta = @CtaDinero AND ROUND(a.Cargo, 2) = @MovImporte
AND a.Conciliado = 0 AND a.EsCancelacion = 0
AND a.ID NOT IN (SELECT AuxiliarID FROM #Conciliar)
AND (@ConciliarPorSucursales = 0 OR (@SucursalBancaria IN (SELECT sb.Numero FROM SucursalBanco sb WHERE sb.Sucursal = a.Sucursal AND sb.Institucion = @Institucion)))
ELSE BEGIN
SELECT @AuxiliarID = MIN(ID)
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Modulo = 'DIN' AND a.Cuenta = @CtaDinero AND ROUND(a.Abono, 2) = @MovImporte AND a.MovID = ISNULL(@MovID, a.MovID)
AND a.Conciliado = 0 AND a.EsCancelacion = 0
AND a.ID NOT IN (SELECT AuxiliarID FROM #Conciliar)
AND (@ConciliarPorSucursales = 0 OR (@SucursalBancaria IN (SELECT sb.Numero FROM SucursalBanco sb WHERE sb.Sucursal = a.Sucursal AND sb.Institucion = @Institucion)))
END
END
INSERT #Conciliar (Tipo,  CtaDinero,  Empresa,  Moneda,  AuxiliarID,  MovImporte,  MovCodigo,  MovSucursal,  MovReferencia1,  MovReferencia2)
VALUES (@Tipo, @CtaDinero, @Empresa, @Moneda, @AuxiliarID, @MovImporte, @MovCodigo, @MovSucursal, @MovReferencia1, @MovReferencia2)
END
END
END
END
FETCH NEXT FROM crListaSt INTO @Clave
END  
CLOSE crListaSt
DEALLOCATE crListaSt
BEGIN TRANSACTION
/*SELECT @Estatus = 'PENDIENTE'
IF EXISTS(SELECT * FROM #Conciliar WHERE AuxiliarID IS NULL)
BEGIN*/
DECLARE crTrans CURSOR FOR
SELECT Tipo, CtaDinero, Empresa, Moneda, MovImporte
FROM #Conciliar
WHERE AuxiliarID IS NULL AND MovCodigo = '71' AND Tipo = 'A'
ORDER BY Tipo
OPEN crTrans
FETCH NEXT FROM crTrans INTO @Tipo, @CtaDinero, @Empresa, @Moneda, @MovImporte
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ID = NULL, @AuxiliarID = NULL
SELECT @ID = ID, @AuxiliarID = AuxiliarID
FROM #Conciliar
WHERE CtaDinero <> @CtaDinero AND MovCodigo = '51' AND Tipo = 'C' AND Empresa = @Empresa AND Moneda = @Moneda AND MovImporte = @MovImporte
AND AuxiliarID IS NULL
IF @@ROWCOUNT = 0
SELECT @ID = ID, @AuxiliarID = AuxiliarID
FROM #Conciliar
WHERE CtaDinero <> @CtaDinero AND MovCodigo = '51' AND Tipo = 'C' AND Empresa = @Empresa AND Moneda = @Moneda AND MovImporte = @MovImporte
AND AuxiliarID IS NOT NULL
IF @AuxiliarID IS NULL
UPDATE #Conciliar
SET CtaDineroDestino = @CtaDinero, Tipo = 'T'
WHERE ID = @ID
IF @ID IS NOT NULL
DELETE #Conciliar WHERE CURRENT OF crTrans
END
FETCH NEXT FROM crTrans INTO @Tipo, @CtaDinero, @Empresa, @Moneda, @MovImporte
END  
CLOSE crTrans
DEALLOCATE crTrans
DECLARE crConciliar CURSOR FOR
SELECT Tipo, CtaDinero, CtaDineroDestino, Empresa, Moneda, MovImporte, MovCodigo, MovSucursal, MovReferencia1, MovReferencia2
FROM #Conciliar
WHERE AuxiliarID IS NULL
OPEN crConciliar
FETCH NEXT FROM crConciliar INTO @Tipo, @CtaDinero, @CtaDineroDestino, @Empresa, @Moneda, @MovImporte, @MovCodigo, @MovSucursal, @MovReferencia1, @MovReferencia2
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Mov = CASE WHEN @Tipo = 'C' THEN BancoCargoBancario
WHEN @Tipo = 'T' THEN BancoTransferencia
ELSE BancoAbonoBancario END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Observaciones =  RTRIM(Mensaje)+' - '+RTRIM(Descripcion)
FROM MensajeInstitucion
WHERE Institucion = Institucion AND Mensaje = @MovCodigo
SELECT @DineroSucursal = NULL
IF @ConciliarPorSucursales = 1
SELECT @DineroSucursal = MIN(Sucursal) FROM SucursalBanco WHERE Institucion = @Institucion AND Numero = @MovSucursal
IF NOT EXISTS(SELECT * FROM Dinero WHERE Sucursal = ISNULL(@DineroSucursal, Sucursal) AND Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @CtaDinero AND ISNULL(CtaDineroDestino, '') = ISNULL(@CtaDineroDestino, '') AND ISNULL(Importe, 0)+ISNULL(Impuestos,0) = @MovImporte AND Estatus IN ('BORRADOR', 'PENDIENTE', 'CONCLUIDO') AND FechaConciliacion = @Hoy)
BEGIN
INSERT Dinero (Sucursal,                          Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Usuario,  Observaciones,      Estatus,    CtaDinero,  CtaDineroDestino,  Importe,     ConDesglose, InstitucionMensaje, InstitucionSucursal, InstitucionReferencia1, InstitucionReferencia2, FechaConciliacion, AutoConciliar)
SELECT ISNULL(@DineroSucursal, @Sucursal), @Empresa, @Mov, @FechaArchivo,  @Moneda, Mon.TipoCambio, @Usuario, @Observaciones, 'BORRADOR', @CtaDinero, @CtaDineroDestino, @MovImporte, 0,           @MovCodigo,         @MovSucursal,        @MovReferencia1,        @MovReferencia2,        @Hoy,     1
FROM Mon
WHERE Mon.Moneda = @Moneda
END ELSE
DELETE #Conciliar WHERE CURRENT OF crConciliar
END
FETCH NEXT FROM crConciliar INTO @Tipo, @CtaDinero, @CtaDineroDestino, @Empresa, @Moneda, @MovImporte, @MovCodigo, @MovSucursal, @MovReferencia1, @MovReferencia2
END  
CLOSE crConciliar
DEALLOCATE crConciliar
/*END ELSE
BEGIN*/
DECLARE crConciliar CURSOR FOR
SELECT a.ModuloID, c.AuxiliarID, c.MovCodigo, c.MovSucursal, c.MovReferencia1, c.MovReferencia2
FROM #Conciliar c, Auxiliar a
WHERE AuxiliarID IS NOT NULL AND c.AuxiliarID = a.ID
OPEN crConciliar
FETCH NEXT FROM crConciliar INTO @ModuloID, @AuxiliarID, @MovCodigo, @MovSucursal, @MovReferencia1, @MovReferencia2
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
/*SELECT @Estatus = 'CONCLUIDO'*/
UPDATE Auxiliar SET Conciliado = 1, FechaConciliacion = @Hoy WHERE ID = @AuxiliarID
UPDATE Dinero
SET InstitucionMensaje     = @MovCodigo,
InstitucionSucursal    = @MovSucursal,
InstitucionReferencia1 = @MovReferencia1,
InstitucionReferencia2 = @MovReferencia2,
FechaConciliacion      = @Hoy
WHERE ID = @ModuloID
END
FETCH NEXT FROM crConciliar INTO @ModuloID, @AuxiliarID, @MovCodigo, @MovSucursal, @MovReferencia1, @MovReferencia2
END  
CLOSE crConciliar
DEALLOCATE crConciliar
/*END*/
IF @Ok IS NULL
BEGIN
/*IF EXISTS(SELECT * FROM #Conciliar WHERE AuxiliarID IS NULL)
SELECT @Estatus = 'PENDIENTE'
ELSE
SELECT @Estatus = 'CONCLUIDO'
UPDATE ConciliacionLog SET Estatus = @Estatus, Fecha = @FechaRegistro WHERE Tipo = @Institucion AND Clave = @ClaveArchivo
IF @@ROWCOUNT = 0
INSERT ConciliacionLog (Tipo, Clave, Estatus, Fecha) VALUES (@Institucion, @ClaveArchivo, @Estatus, @FechaRegistro)*/
COMMIT TRANSACTION
END ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @RegistrosConciliados = COUNT(*) FROM #Conciliar WHERE AuxiliarID IS NOT NULL
SELECT @RegistrosPendientes = COUNT(*) FROM #Conciliar WHERE AuxiliarID IS NULL
IF @RegistrosPendientes > 0
SELECT @Resultado = 'Faltan '+RTRIM(CONVERT(char, @RegistrosPendientes))+' Movimientos en Borrador'
ELSE
SELECT @Resultado = 'Proceso Concluido'
IF @RegistrosConciliados > 0
SELECT @Resultado = @Resultado+', se Conciliaron '+RTRIM(CONVERT(char, @RegistrosConciliados))+' Registros.'
END ELSE
SELECT @Resultado = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado
RETURN
END

