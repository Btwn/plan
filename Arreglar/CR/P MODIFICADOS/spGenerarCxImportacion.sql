SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCxImportacion
@Sucursal                   int,
@SucursalOrigen             int,
@SucursalDestino            int,
@Accion                     char(20),
@ModuloAfectar              char(5),
@Empresa                    char(5),
@Modulo                     char(5),
@ID                         int,
@Mov                        char(20),
@MovID                      varchar(20),
@MovTipo                    char(20),
@MovMoneda                  char(10),
@MovTipoCambio              float,
@FechaEmision               datetime,
@Concepto                   varchar(50),
@Proyecto                   varchar(50),
@Usuario                    char(10),
@Autorizacion               char(10),
@Referencia                 varchar(50),
@DocFuente                  int,
@Observaciones              varchar(255),
@FechaRegistro              datetime,
@Ejercicio                  int,
@Periodo                    int,
@Condicion                  varchar(50),
@Vencimiento                datetime,
@Contacto                   char(10),
@EnviarA                    int,
@Agente                     char(10),
@Tipo                       char(20),
@CtaDinero                  char(10),
@FormaPago                  varchar(50),
@Importe                    money,
@Impuestos                  money,
@Retencion                  money,
@ComisionTotal              money,
@Beneficiario               int,
@Aplica                     char(20),
@AplicaMovID                varchar(20),
@ImporteAplicar             money,
@VIN                        varchar(20),
@MovEspecifico              char(20),
@CxModulo                   char(5)         OUTPUT,
@CxMov                      char(20)        OUTPUT,
@CxMovID                    varchar(20)     OUTPUT,
@Ok                         int             OUTPUT,
@OkRef                      varchar(255)    OUTPUT,
@INSTRUCCIONES_ESP          varchar(20)     = NULL,
@IVAFiscal                  float           = NULL,
@IEPSFiscal                 float           = NULL,
@Retencion2                 money           = NULL,
@Retencion3                 money           = NULL

AS BEGIN
DECLARE
@ImportacionProveedor       char(10),
@ImportacionReferencia      varchar(50),
@ProvCondicion              varchar(50),
@ProvVencimiento            datetime,
@SumaImporte                money,
@SumaImpuestos              money,
@MonedaD                 varchar(10),
@TipoCambioD             float
IF @Modulo <> 'COMS' RETURN
DECLARE crImportacion CURSOR FOR
SELECT ImportacionProveedor, ImportacionReferencia, MonedaD, TipoCambioD, SUM(SubTotal), SUM(Impuestos)
FROM CompraTCalc
WITH(NOLOCK) WHERE ID = @ID
GROUP BY ImportacionProveedor, ImportacionReferencia, MonedaD, TipoCambioD
ORDER BY ImportacionProveedor, ImportacionReferencia, MonedaD, TipoCambioD
OPEN crImportacion
FETCH NEXT FROM crImportacion  INTO @ImportacionProveedor, @ImportacionReferencia, @MonedaD, @TipoCambioD, @SumaImporte, @SumaImpuestos
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT @ImportacionProveedor = NULLIF(RTRIM(@ImportacionProveedor), ''),
@ImportacionReferencia = NULLIF(RTRIM(@ImportacionReferencia), ''),
@ProvVencimiento = NULL
SELECT @ProvCondicion = Condicion
FROM Prov
WITH(NOLOCK) WHERE Proveedor = @ImportacionProveedor
SELECT @MonedaD = ISNULL(@MonedaD, @MovMoneda), @TipoCambioD = ISNULL(@TipoCambioD, @MovTipoCambio)
EXEC xpGenerarCxImportacionCondicionVencimiento @Modulo, @ID, @Accion, @ImportacionProveedor, @ImportacionReferencia, @SumaImporte, @SumaImpuestos, @ProvCondicion OUTPUT, @ProvVencimiento OUTPUT
IF @ImportacionProveedor IS NULL SELECT @Ok = 40020
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @ModuloAfectar, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MonedaD, @TipoCambioD,
@FechaEmision, @Concepto, @Proyecto, @Usuario, @Autorizacion, @ImportacionReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@ProvCondicion, @ProvVencimiento, @ImportacionProveedor, NULL, @Agente, @Tipo, @CtaDinero, @FormaPago,
@SumaImporte, @SumaImpuestos, NULL, NULL,
@Beneficiario, @Aplica, @AplicaMovID, @ImporteAplicar, @VIN, @MovEspecifico,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @INSTRUCCIONES_ESP, @IVAFiscal, @IEPSFiscal, @Retencion2 = @Retencion2, @Retencion3 = @Retencion3
FETCH NEXT FROM crImportacion  INTO @ImportacionProveedor, @ImportacionReferencia, @MonedaD, @TipoCambioD, @SumaImporte, @SumaImpuestos
END
CLOSE crImportacion
DEALLOCATE crImportacion
RETURN
END

