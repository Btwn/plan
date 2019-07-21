SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoRegistrar
@Empresa		  char(5),
@Sucursal		  int,
@Modulo		  char(5),
@ID			  int,
@Estatus		  char(15),
@EstatusNuevo	  char(15),
@Usuario		  char(10),
@FechaEmision	  datetime,
@FechaRegistro 	  datetime,
@Mov			  char(20),
@MovID		  varchar(20),
@MovTipo		  char(20),
@ContMov		  char(20),
@ContMovID		  varchar(20),
@ContMoneda		  char(10),
@ContTipoCambio	  float,
@Referencia		  varchar(50),
@Concepto		  varchar(50),
@Proyecto		  varchar(50),
@UEN			  int,
@Contacto		  varchar(10),
@ContactoTipo	  varchar(20),
@ContactoAplica	  varchar(20),
@Intercompania	  bit,
@OrigenMoneda	  varchar(10),
@OrigenTipoCambio	  float,
@CfgPartidasSinImporte bit,
@CfgRegistro		  bit,
@Ok			  int		OUTPUT,
@OkRef		  varchar(255)	OUTPUT,
@ModuloInicial		char(5) = NULL

AS BEGIN
DECLARE
@Renglon			float,
@ContID			int,
@Cuenta			char(20),
@SubCuenta			varchar(50),
@SubCuenta2			varchar(50),
@SubCuenta3			varchar(50),
@ContactoEspecifico		varchar(10),
@Articulo			varchar(20),
@DepartamentoDetallista	int,
@Presupuesto		bit,
@AfectarPresupuesto		varchar(30),
@DisminuirPresupuesto	bit,
@SucursalContable   	int,
@Debe			money,
@Haber			money,
@SucursalOrigen		int,
@RedondeoMonetarios		int,
@Campo					varchar(20),
@ContactoTipoEsp		varchar(20) 
/** JH 08.08.2006 **/
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
CREATE INDEX Presup ON #Poliza(Presupuesto)
CREATE INDEX CuentaPresupuesto ON #Poliza(Cuenta,Presupuesto)
SELECT @SucursalOrigen = Sucursal FROM Version
SELECT @DisminuirPresupuesto = 0
SELECT @AfectarPresupuesto = NULLIF(NULLIF(RTRIM(AfectarPresupuesto), ''), '(por Omision)') FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @AfectarPresupuesto = ISNULL(@AfectarPresupuesto, ISNULL(NULLIF(RTRIM(AfectarPresupuesto), ''), 'No')) FROM MovClave WHERE Clave = @MovTipo
IF @AfectarPresupuesto <> 'No'
BEGIN
IF @AfectarPresupuesto = 'Desasignar'           	SELECT @AfectarPresupuesto = 'Asignar',           	@DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desreservar'          	SELECT @AfectarPresupuesto = 'Reservar',          	@DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desejercer Reservado' 	SELECT @AfectarPresupuesto = 'Ejercer Reservado', 	@DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desejercer Directo'   	SELECT @AfectarPresupuesto = 'Ejercer Directo',   	@DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Descomprometer Directo'   SELECT @AfectarPresupuesto = 'Comprometer Directo',     @DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Descomprometer Reservado' SELECT @AfectarPresupuesto = 'Comprometer Reservado',   @DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desdevengar Directo'   	SELECT @AfectarPresupuesto = 'Devengar Directo',        @DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desdevengar Reservado'   	SELECT @AfectarPresupuesto = 'Devengar Reservado',      @DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desdevengar Comprometido' SELECT @AfectarPresupuesto = 'Devengar Comprometido',   @DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desejercer Comprometido'  SELECT @AfectarPresupuesto = 'Ejercer Comprometido',    @DisminuirPresupuesto = 1 ELSE
IF @AfectarPresupuesto = 'Desejercer Devengado'   	SELECT @AfectarPresupuesto = 'Ejercer Devengado',       @DisminuirPresupuesto = 1
IF @DisminuirPresupuesto = 0
INSERT #Poliza (Presupuesto, Cuenta, Debe)  SELECT 1, CuentaPresupuesto, Importe*@OrigenTipoCambio FROM MovPresupuesto WHERE Modulo = @Modulo AND ModuloID =  @ID
ELSE
INSERT #Poliza (Presupuesto, Cuenta, Haber) SELECT 1, CuentaPresupuesto, Importe*@OrigenTipoCambio FROM MovPresupuesto WHERE Modulo = @Modulo AND ModuloID =  @ID
END
IF EXISTS(SELECT * FROM #Poliza)
BEGIN
INSERT Cont (OrigenTipo, Origen, OrigenID, Sucursal,  SucursalOrigen,  Empresa,  Mov,      FechaEmision,  FechaContable, Moneda,      TipoCambio,      Usuario,  Concepto,  Proyecto,  UEN,  Contacto,  ContactoTipo,  ContactoAplica,  Intercompania,  AfectarPresupuesto,  OrigenMoneda,  OrigenTipoCambio,  Referencia,  Estatus)
VALUES (@Modulo,    @Mov,   @MovID,   @Sucursal, @SucursalOrigen, @Empresa, @ContMov, @FechaEmision, @FechaEmision, @ContMoneda, @ContTipoCambio, @Usuario, @Concepto, @Proyecto, @UEN, @Contacto, @ContactoTipo, @ContactoAplica, @Intercompania, @AfectarPresupuesto, @OrigenMoneda, @OrigenTipoCambio, @Referencia, 'SINAFECTAR')
SELECT @ContID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0
IF @EstatusNuevo = 'CANCELADO'
UPDATE #Poliza SET Debe = -Debe, Haber = -Haber
IF (SELECT ContAutoEliminarCCNoReq FROM EmpresaGral WHERE Empresa = @Empresa) = 1
BEGIN
UPDATE #Poliza
SET SubCuenta = NULL
FROM #Poliza p
JOIN Cta c ON c.Cuenta = p.Cuenta
WHERE c.CentrosCostos = 0
UPDATE #Poliza
SET SubCuenta2 = NULL
FROM #Poliza p
JOIN Cta c ON c.Cuenta = p.Cuenta
WHERE c.CentroCostos2 = 0
UPDATE #Poliza
SET SubCuenta3 = NULL
FROM #Poliza p
JOIN Cta c ON c.Cuenta = p.Cuenta
WHERE c.CentroCostos3 = 0
END
UPDATE #Poliza SET ContactoTipo = NULL WHERE ISNULL(ContactoEspecifico,'') = '' 
DECLARE crPoliza CURSOR FOR
/** JH 08.08.2006 **/
SELECT ISNULL(Presupuesto, 0), NULLIF(RTRIM(Cuenta), ''), NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(SubCuenta2), ''), NULLIF(RTRIM(SubCuenta3), ''), SucursalContable, NULLIF(RTRIM(Concepto), ''), NULLIF(RTRIM(ContactoEspecifico), ''), NULLIF(RTRIM(Articulo), ''), NULLIF(DepartamentoDetallista, 0), ROUND(NULLIF(SUM(Debe), 0.0), @RedondeoMonetarios), ROUND(NULLIF(SUM(Haber), 0.0), @RedondeoMonetarios), Campo, ContactoTipo 
FROM #Poliza
GROUP BY Presupuesto, Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, SucursalContable, Concepto, ContactoEspecifico, Articulo, DepartamentoDetallista, Campo, ContactoTipo 
ORDER BY Presupuesto, Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, SucursalContable, Concepto, ContactoEspecifico, Articulo, DepartamentoDetallista, Campo, ContactoTipo 
OPEN crPoliza
FETCH NEXT FROM crPoliza INTO @Presupuesto, @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @SucursalContable, @Concepto, @ContactoEspecifico, @Articulo, @DepartamentoDetallista, @Debe, @Haber, @Campo, @ContactoTipoEsp 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Cuenta IS NOT NULL AND (@CfgPartidasSinImporte = 1 OR (@Debe IS NOT NULL OR @Haber IS NOT NULL))
BEGIN
SELECT @Renglon = @Renglon + 2048
IF @Debe  IS NOT NULL SELECT @Debe  = @Debe  / @ContTipoCambio
IF @Haber IS NOT NULL SELECT @Haber = @Haber / @ContTipoCambio
INSERT ContD (Sucursal,  SucursalContable,  ID,      Renglon,  Presupuesto,  Cuenta,  SubCuenta,  SubCuenta2,  SubCuenta3,  Concepto,  ContactoEspecifico,  Articulo,  DepartamentoDetallista,  Debe,  Haber,  Campo,  ContactoTipo) 
VALUES (@Sucursal, @SucursalContable, @ContID, @Renglon, @Presupuesto, @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @Concepto, @ContactoEspecifico, @Articulo, @DepartamentoDetallista, @Debe, @Haber, @Campo, @ContactoTipoEsp) 
END
END
FETCH NEXT FROM crPoliza INTO @Presupuesto, @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @SucursalContable, @Concepto, @ContactoEspecifico, @Articulo, @DepartamentoDetallista, @Debe, @Haber, @Campo, @ContactoTipoEsp 
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crPoliza
DEALLOCATE crPoliza
IF @CfgRegistro = 1
INSERT ContReg (
ID, Empresa, Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe, Haber)
/** JH 08.08.2006 **/
SELECT @ContID, @Empresa, SucursalContable, @Modulo, @ID, Renglon, RenglonSub, NULLIF(RTRIM(Cuenta), ''), NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(SubCuenta2), ''), NULLIF(RTRIM(SubCuenta3), ''), NULLIF(RTRIM(Concepto), ''), NULLIF(RTRIM(ContactoEspecifico), ''), ROUND(CONVERT(money, Debe/@ContTipoCambio),@RedondeoMonetarios), ROUND(CONVERT(money, Haber/@ContTipoCambio),@RedondeoMonetarios) 
FROM #Poliza
WHERE Presupuesto = 0
EXEC spCont @ContID, 'CONT', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario,  1, 0,
@ContMov OUTPUT, @ContMovID OUTPUT,  NULL, @Ok OUTPUT, @OkRef OUTPUT, @ContAuto = 1, @ModuloInicial = @ModuloInicial
IF @Ok IS NOT NULL
SELECT @OkRef = ISNULL(@OkRef, '')+' ('+RTRIM(Nombre)+' / '+RTRIM(@Mov)+' '+RTRIM(@MovID)+')'
FROM Modulo WHERE Modulo = @Modulo
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
IF @Ok = 50010 	
BEGIN
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable
FROM ContD
WHERE ID = @ContID
END
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'CONT', @ContID, @ContMov, @ContMovID, @Ok OUTPUT
EXEC spContAutoSetDatos @Empresa, @Modulo, @ID, @ContID, @ContMov, @ContMovID
END
END

