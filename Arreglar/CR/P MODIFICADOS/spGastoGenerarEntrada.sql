SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoGenerarEntrada
@ID		int,
@Accion		char(20),
@Empresa       	char(5),
@Usuario	char(10),
@Modulo	      	char(5),
@Mov           	char(20),
@MovID		varchar(20),
@MovTipo	char(20),
@MovMoneda	char(10),
@FechaEmision	datetime,
@Estatus	char(15),
@EstatusNuevo	char(15),
@Acreedor	char(10),
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ConceptoInventariable	bit,
@Inventariable		bit,
@MovEntrada			varchar(20),
@MovSalida			varchar(20),
@MovNuevo			varchar(20),
@MovIDNuevo			varchar(20),
@Concepto			varchar(20),
@IDNuevo			int,
@Renglon			float,
@Renglonsub			int,
@Concepto1			varchar(50),
@Fecha			datetime,
@Cantidad			float,
@Precio			money,
@Importe			money,
@Impuestos			money,
@Sucursal			int,
@PorcentajeDeducible		float,
@SucursalOrigen		int,
@Impuesto1			float,
@Impuestos2			money,
@Impuestos3			money,
@Conexion			int,
@EnSilencio			int,
@DID				int,
@DMov			varchar(20),
@DMovID			varchar(20),
@OkOriginal			int,
@OkRefOriginal		varchar(255)
IF @Ok = 80030
BEGIN
SELECT @OkOriginal = @Ok, @OkRefOriginal = @OkRef
SELECT @Ok = NULL, @OkRef = NULL
END
SELECT @ConceptoInventariable = GastoConceptosInventariables,
@MovEntrada = GASCIMovEntrada ,
@MovSalida = GASCIMovSalida
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @ConceptoInventariable = 0 RETURN
SELECT @Concepto = Concepto FROM GastoD WITH(NOLOCK) WHERE ID = @ID
IF @MovTipo IN('GAS.DC','GAS.DG') SELECT @MovNuevo =  @MovSalida
IF @MovTipo IN('GAS.G', 'GAS.C', 'GAS.CCH') SELECT @MovNuevo =  @MovEntrada
IF  @Modulo = 'GAS' AND @ConceptoInventariable = 1 AND @Accion IN ('AFECTAR','CANCELAR') AND @MovTipo IN ('GAS.G', 'GAS.C', 'GAS.CCH' ,'GAS.DG','GAS.DC')
BEGIN
IF @Accion = 'AFECTAR' AND @Ok IS NULL
BEGIN
INSERT INTO Gasto  (Empresa, Mov,        FechaEmision, UltimoCambio, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus,      Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Periodicidad, TieneRetencion, Acreedor, Clase, Subclase, CtaDinero, FormaPago, Condicion, Vencimiento, Importe, Retencion, Impuestos, Saldo, Anticipo, /*MovAplica, MovAplicaID,*/ Multiple, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaRequerida, CXP, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, AnexoModulo, AnexoID, ProdSerieLote, Sucursal, Mensaje, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Actividad, IVAFiscal, IEPSFiscal, EspacioResultado, EstaImpreso, AF, AFArticulo, AFSerie, Pagado, Comentarios, ConVigencia, VigenciaDesde, VigenciaHasta, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Prioridad, CostoPisoD, CostoPisoA, Nota, RetencionAlPago, SubModulo, ClienteRef, ArticuloRef,  SincroC, SucursalOrigen, SucursalDestino, ContratoValorMoneda, ContUso, ContUso2, ContUso3, ContratoID, ContratoMov, ContratoMovID)
SELECT              Empresa, @MovNuevo , FechaEmision, UltimoCambio, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, 'SINAFECTAR', Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Periodicidad, TieneRetencion, Acreedor, Clase, Subclase, CtaDinero, FormaPago, Condicion, Vencimiento, Importe, Retencion, Impuestos, Saldo, Anticipo, /*MovAplica, MovAplicaID,*/ Multiple, OrigenTipo, Mov, MovID /*Origen, OrigenID*/, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaRequerida, CXP, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, AnexoModulo, AnexoID, ProdSerieLote, Sucursal, Mensaje, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Actividad, IVAFiscal, IEPSFiscal, EspacioResultado, EstaImpreso, AF, AFArticulo, AFSerie, Pagado, Comentarios, ConVigencia, VigenciaDesde, VigenciaHasta, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Prioridad, CostoPisoD, CostoPisoA, Nota, RetencionAlPago, SubModulo, ClienteRef, ArticuloRef,  SincroC, SucursalOrigen, SucursalDestino, ContratoValorMoneda, ContUso, ContUso2, ContUso3, ContratoID, ContratoMov, ContratoMovID
FROM Gasto
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
IF @Ok IS NULL
BEGIN
DECLARE crActualizar CURSOR  FOR
SELECT g.Renglonsub, g.Concepto, g.Fecha, g.Cantidad, g.Precio, g.Importe, g.Impuestos, g.Sucursal, g.PorcentajeDeducible, g.SucursalOrigen, g.Impuesto1, g.Impuestos2, g.Impuestos3
FROM GastoD g  WITH(NOLOCK) JOIN Concepto c
 WITH(NOLOCK) ON g.Concepto = c.Concepto
WHERE g.ID = @ID AND c.EsInventariable = 1
SET @Renglon = 0.0
OPEN crActualizar
FETCH NEXT FROM crActualizar  INTO @RenglonSub, @Concepto1, @Fecha, @Cantidad, @Precio, @Importe, @Impuestos, @Sucursal, @PorcentajeDeducible, @SucursalOrigen, @Impuesto1, @Impuestos2, @Impuestos3
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @Renglon = @Renglon + 2048.0
INSERT INTO GastoD  (ID,        Renglon,  Renglonsub,  Concepto,   Fecha,   Cantidad,  Precio,    Importe,  Impuestos,  Sucursal,   PorcentajeDeducible,   SucursalOrigen,    Impuesto1,      Impuestos2,   Impuestos3)
SELECT  @IDNuevo , @Renglon, @Renglonsub, @Concepto1, @Fecha,  @Cantidad, @Precio,   @Importe, @Impuestos, @Sucursal,  @PorcentajeDeducible,  @SucursalOrigen,   @Impuesto1,     @Impuestos2,  @Impuestos3
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crActualizar  INTO @RenglonSub, @Concepto1, @Fecha, @Cantidad, @Precio, @Importe, @Impuestos, @Sucursal, @PorcentajeDeducible, @SucursalOrigen, @Impuesto1, @Impuestos2, @Impuestos3
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
IF NOT EXISTS(SELECT * FROM  GastoD g  WITH(NOLOCK) JOIN  Concepto C  WITH(NOLOCK) ON g.Concepto = c.Concepto WHERE g.ID =  @IDNuevo)
BEGIN
DELETE FROM Gasto WHERE ID = @IDNuevo
DELETE FROM GastoD WHERE ID = @IDNuevo
END
IF @OK IS NULL AND EXISTS(SELECT * FROM  GastoD g  WITH(NOLOCK) JOIN  Concepto C  WITH(NOLOCK) ON g.Concepto = c.Concepto WHERE g.ID =  @IDNuevo)
BEGIN
IF @MovNuevo IS NULL AND @ConceptoInventariable = 1 SET @Ok = 30120
IF @Ok IS NULL
BEGIN
EXEC spAfectar @Modulo = @Modulo, @ID=@IDNuevo, @Accion = @Accion, @Base='Todo',@GenerarMov = NULL, @Usuario=@Usuario, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NULL
BEGIN
SELECT @MovIDNuevo = MovID FROM Gasto WITH(NOLOCK) WHERE ID = @IDNuevo
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDNuevo, @MovNuevo, @MovIDNuevo, @Ok OUTPUT
END
END
END
END ELSE
IF @Accion = 'CANCELAR' AND @Ok IS NULL
BEGIN
DECLARE crCancelar CURSOR  FOR
SELECT DID, DMov, DMovID
FROM MovFlujo mf WITH(NOLOCK)
WHERE mf.Empresa = @Empresa
AND mf.OModulo = 'GAS'
AND mf.OID = @ID
AND mf.DModulo = 'GAS'
OPEN crCancelar
FETCH NEXT FROM crCancelar  INTO @DID, @DMov, @DMovID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spAfectar @Modulo= @Modulo, @ID=@DID, @Accion=@Accion, @Base='Todo', @GenerarMov= NULL, @Usuario=@Usuario,@Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NULL
BEGIN
SELECT @MovIDNuevo = MovID FROM Gasto WITH(NOLOCK) WHERE ID = @IDNuevo
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @DID, @DMov, @DMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCancelar  INTO @DID, @DMov, @DMovID
END
CLOSE crCancelar
DEALLOCATE crCancelar
END
IF @Ok IS NULL SELECT @Ok = @OkOriginal, @OkRef = @OkRefOriginal
END
END

