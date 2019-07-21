SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@ContMoneda			char(10),
@Estatus			char(15),
@AfectarPresupuesto		varchar(30),
@FechaContable		datetime,
@CfgVerificarIVA		bit,
@CfgCentrosCostos		bit,
@CfgToleraciaRedondeo	float,
@CfgRegistro		bit,
@Ejercicio			int,
@Periodo			int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Presupuesto		bit,
@Renglon			float,
@RenglonSub			int,
@UltRenglon			float,
@UltRenglonSub		int,
@Cuantos			int,
@Cuenta			char(20),
@SubCuenta			varchar(50),
@Debe			money,
@Debe2			money,
@Haber			money,
@Haber2			money,
@UltDebe			money,
@UltDebe2			money,
@UltHaber			money,
@UltHaber2			money,
@EsAcumulativa		bit,
@CentrosCostos		bit,
@CentroCostosRequerido	bit,
@IVATipo			char(20),
@IVAPorcentaje		float,
@SumaIVA			money,
@SumaCausanIVA		money,
@SumaDebe 			money,
@SumaDebe2 			money,
@SumaDebeReg		money,
@SumaHaber  		money,
@SumaHaber2  		money,
@SumaHaberReg  		money,
@Dif			money,
@Dif2			money,
@RedondeoMonetarios		int,
@ContactoTipo		varchar(20),
@Contacto			varchar(10),
@CfgCuentaCuadre		varchar(20),
@CfgToleranciaCuadre	float,
@CentrosCostos2		bit,
@SubCuenta2			varchar(50),
@CentroCostosRequerido2	bit,
@CentrosCostos3		bit,
@SubCuenta3			varchar(50),
@CentroCostosRequerido3	bit,
@Campo				varchar(20),
@Origen				varchar(20),
@OrigenID			varchar(20),
@OrigenTipo			varchar(20),
@ContXAfectar		bit,
@CentroCostosOmision	varchar(20)
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @ContXAfectar = ContXAfectar FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @CfgCuentaCuadre    = NULLIF(RTRIM(ContCuentaCuadre), ''),
@CfgToleranciaCuadre= ISNULL(ContToleranciaCuadre, 0.0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Accion IN ('CANCELAR', 'DESAFECTAR')
BEGIN
IF @Conexion = 0
IF (EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo) OR
(SELECT ISNULL(NULLIF(RTRIM(OrigenTipo), ''), @Modulo) FROM Cont WHERE ID = @ID) <> @Modulo) AND
(SELECT ContPermitirCancelacionOrigen FROM EmpresaCfg WHERE Empresa = @Empresa) = 0
IF @Accion = 'CANCELAR'   SELECT @Ok = 60070 ELSE
IF @Accion = 'DESAFECTAR' SELECT @Ok = 60075
END
IF @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR' AND @MovTipo = 'CONT.P' AND @Modulo = 'CONT' AND @ContXAfectar = 0
BEGIN
SELECT @Origen = Origen,@OrigenID = OrigenID, @OrigenTipo = OrigenTipo FROM Cont WHERE ID = @ID
IF (SELECT SUM(Debe) FROM ContD WHERE ID = @ID) < 0 AND (SELECT SUM(Haber) FROM ContD WHERE ID = @ID) < 0 AND @OrigenTipo != 'CTRL/E' AND @OrigenTipo != 'CONTP'
BEGIN
IF NOT EXISTS(SELECT SUM(d.Debe),SUM(d.Haber)
FROM Cont c
JOIN ContD d ON c.ID = d.ID
WHERE c.Origen = @Origen
AND c.OrigenID = @OrigenID
AND c.OrigenTipo = @OrigenTipo
AND c.Estatus = 'CONCLUIDO'
AND c.ID <> @ID
HAVING SUM(d.Debe) > 0 AND SUM(d.Haber) > 0)
SELECT @Ok = 10065, @OkRef = 'El Movimiento: '+RTRIM(@Origen)+' '+RTRIM(@OrigenID)+' No tiene una Poliza en Estatus Concluido'
END
END
/** JH 08.08.2006 **/
IF @MovTipo = 'CONT.PR' AND @AfectarPresupuesto <> 'ASIGNAR' AND @Ok IS NULL
SELECT @Ok = 50120
IF @Ok IS NULL
BEGIN
SELECT @ContactoTipo = NULLIF(RTRIM(ContactoTipo), ''),
@Contacto = NULLIF(RTRIM(Contacto), '')
FROM Cont
WHERE ID = @ID
SELECT @SumaDebe      = 0.0,
@SumaDebe2     = 0.0,
@SumaHaber     = 0.0,
@SumaHaber2    = 0.0,
@SumaIVA       = 0.0,
@SumaCausanIVA = 0.0,
@Cuantos	  = 0
DECLARE crContVerificar CURSOR
FOR SELECT ContD.Renglon, ContD.RenglonSub, NULLIF(RTRIM(ContD.Cuenta), ''), NULLIF(RTRIM(ContD.SubCuenta), ''), ISNULL(ContD.Debe, 0.0), ISNULL(ContD.Haber, 0.0), ISNULL(ContD.Debe2, 0.0), ISNULL(ContD.Haber2, 0.0), ContD.Presupuesto, Cta.EsAcumulativa, Cta.CentrosCostos, Cta.CentroCostosRequerido, NULLIF(RTRIM(ContD.SubCuenta2),''), NULLIF(RTRIM(ContD.SubCuenta3),''), ISNULL(ContD.Debe, 0.0), ISNULL(ContD.Haber, 0.0), ISNULL(ContD.Debe2, 0.0), ISNULL(ContD.Haber2, 0.0), ContD.Presupuesto, Cta.EsAcumulativa, Cta.CentrosCostos, Cta.CentroCostosRequerido, Cta.CentroCostos2, Cta.CentroCostosRequerido2, Cta.CentroCostos3, Cta.CentroCostosRequerido3, ContD.Campo
FROM ContD, Cta
WHERE ID = @ID
AND Cta.Cuenta = ContD.Cuenta
OPEN crContVerificar
FETCH NEXT FROM crContVerificar INTO @Renglon, @RenglonSub, @Cuenta, @SubCuenta, @Debe, @Haber, @Debe2, @Haber2, @Presupuesto, @EsAcumulativa, @CentrosCostos, @CentroCostosRequerido, @SubCuenta2, @SubCuenta3, @Debe, @Haber, @Debe2, @Haber2, @Presupuesto, @EsAcumulativa, @CentrosCostos, @CentroCostosRequerido, @CentrosCostos2, @CentroCostosRequerido2, @CentrosCostos3, @CentroCostosRequerido3, @Campo
IF @@ERROR <> 0 SELECT @Ok = 1
IF @@FETCH_STATUS = -1 SELECT @Ok = 60010
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF ISNULL(@Debe,0.0) = 0.0 AND ISNULL(@Haber,0.0) = 0.0
SELECT @Ok = 40080, @OkRef = 'La Cuenta '+RTRIM(@Cuenta)+' tiene valor 0 en Debe y Haber'
IF @Presupuesto IS NULL SELECT @Ok = 40190
SELECT @Cuantos = @Cuantos + 1
IF @Presupuesto = 0
BEGIN
IF @Cuenta IS NULL SELECT @OK = 40030
IF @Debe  <> ROUND(@Debe, @RedondeoMonetarios)  OR @Haber  <> ROUND(@Haber, @RedondeoMonetarios) OR
@Debe2 <> ROUND(@Debe2, @RedondeoMonetarios) OR @Haber2 <> ROUND(@Haber2, @RedondeoMonetarios)
BEGIN
SELECT @Debe  = ROUND(@Debe, @RedondeoMonetarios),  @Haber  = ROUND(@Haber, @RedondeoMonetarios),
@Debe2 = ROUND(@Debe2, @RedondeoMonetarios), @Haber2 = ROUND(@Haber2, @RedondeoMonetarios)
UPDATE ContD
SET Debe  = NULLIF(@Debe, 0.0),  Haber  = NULLIF(@Haber, 0.0),
Debe2 = NULLIF(@Debe2, 0.0), Haber2 = NULLIF(@Haber2, 0.0)
WHERE CURRENT OF crContVerificar
END
IF @EsAcumulativa = 1 SELECT @Ok = 50060, @OkRef = 'Cuenta: '+RTRIM(@Cuenta)
IF @CfgCentrosCostos = 1 AND @CentrosCostos = 1
BEGIN
IF @SubCuenta IS NULL
BEGIN
IF @CentroCostosRequerido = 1 SELECT @Ok = 50030						
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM CtaSub WHERE Cuenta = @Cuenta AND SubCuenta = @SubCuenta)
BEGIN
IF EXISTS(SELECT * FROM CtaSub cs, CentroCostos cc WHERE cs.Cuenta = @Cuenta AND cs.SubCuenta=cc.CentroCostos)
SELECT @Ok = 50080									
ELSE
IF NOT EXISTS(SELECT * FROM CentroCostos WHERE CentroCostos = @SubCuenta AND EsAcumulativo = 0)
SELECT @Ok = 50080									
END
END
END ELSE
IF @SubCuenta IS NOT NULL SELECT @Ok = 50080							
IF @CfgCentrosCostos = 1 AND @CentrosCostos2 = 1 
BEGIN
IF @SubCuenta2 IS NULL
BEGIN
IF @CentroCostosRequerido2 = 1 SELECT @Ok = 50030						
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM CtaSub2 WHERE Cuenta = @Cuenta AND SubCuenta2 = @SubCuenta2)
BEGIN
IF EXISTS(SELECT * FROM CtaSub2 cs, CentroCostos2 cc WHERE cs.Cuenta = @Cuenta AND cs.SubCuenta2=cc.CentroCostos2)
SELECT @Ok = 50080									
ELSE
IF NOT EXISTS(SELECT * FROM CentroCostos2 WHERE CentroCostos2 = @SubCuenta2 AND EsAcumulativo = 0)
SELECT @Ok = 50080									
END
END
END ELSE
IF @SubCuenta2 IS NOT NULL SELECT @Ok = 50080							
IF @CfgCentrosCostos = 1 AND @CentrosCostos3 = 1  
BEGIN
IF @SubCuenta3 IS NULL
BEGIN
IF @CentroCostosRequerido3 = 1 SELECT @Ok = 50030						
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM CtaSub3 WHERE Cuenta = @Cuenta AND SubCuenta3 = @SubCuenta3)
BEGIN
IF EXISTS(SELECT * FROM CtaSub3 cs, CentroCostos3 cc WHERE cs.Cuenta = @Cuenta AND cs.SubCuenta3=cc.CentroCostos3)
SELECT @Ok = 50080									
ELSE
IF NOT EXISTS(SELECT * FROM CentroCostos3 WHERE CentroCostos3 = @SubCuenta3 AND EsAcumulativo = 0)
SELECT @Ok = 50080									
END
END
END ELSE
IF @SubCuenta3 IS NOT NULL SELECT @Ok = 50080							
IF @CfgVerificarIVA = 1
BEGIN
SELECT @IVATipo = NULLIF(RTRIM(UPPER(Tipo)), ''), @IVAPorcentaje = ISNULL(Porcentaje, 0.0)
FROM CtaIVA
WHERE Cuenta = @Cuenta
IF @IVATipo IS NOT NULL
IF @IVATipo='IVA'
SELECT @SumaIVA = @SumaIVA + (@Debe - @Haber)
ELSE
SELECT @SumaCausanIVA = @SumaCausanIVA + ((@Debe - @Haber) * (@IVAPorcentaje / 100))
END
SELECT @UltRenglon = @Renglon, @UltRenglonSub = @RenglonSub,
@UltDebe  = @Debe,  @UltHaber  = @Haber,
@UltDebe2 = @Debe2, @UltHaber2 = @Haber2
SELECT @SumaDebe   = @SumaDebe   + @Debe,
@SumaHaber  = @SumaHaber  + @Haber,
@SumaDebe2  = @SumaDebe2  + @Debe2,
@SumaHaber2 = @SumaHaber2 + @Haber2
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Cuenta: '+RTRIM(@Cuenta)
END
END
FETCH NEXT FROM crContVerificar INTO @Renglon, @RenglonSub, @Cuenta, @SubCuenta, @Debe, @Haber, @Debe2, @Haber2, @Presupuesto, @EsAcumulativa, @CentrosCostos, @CentroCostosRequerido, @SubCuenta2, @SubCuenta3, @Debe, @Haber, @Debe2, @Haber2, @Presupuesto, @EsAcumulativa, @CentrosCostos, @CentroCostosRequerido, @CentrosCostos2, @CentroCostosRequerido2, @CentrosCostos3, @CentroCostosRequerido3, @Campo
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crContVerificar
DEALLOCATE crContVerificar
IF @Accion <> 'DESAFECTAR'
BEGIN
SELECT @Dif = @SumaDebe-@SumaHaber
IF @SumaDebe <> @SumaHaber AND @Ok IS NULL SELECT @Ok = 50010, @OkRef = 'Diferencia '+CONVERT(varchar, @Dif)     
IF @Ok = 50010 AND ABS(@Dif) < @CfgToleraciaRedondeo
BEGIN
IF @UltDebe>0.0
SELECT @UltDebe = @UltDebe - @Dif, @SumaDebe = @SumaDebe - @Dif
ELSE SELECT @UltHaber = @UltHaber + @Dif, @SumaHaber = @SumaHaber + @Dif
IF @SumaDebe = @SumaHaber
BEGIN
UPDATE ContD SET Debe = NULLIF(@UltDebe, 0.0), Haber = NULLIF(@UltHaber, 0.0) WHERE ID = @ID AND Renglon = @UltRenglon AND RenglonSub = @UltRenglonSub
SELECT @Ok = NULL
END
END ELSE
IF @Ok = 50010 AND ABS(@Dif) <= @CfgToleranciaCuadre AND @CfgCuentaCuadre IS NOT NULL
BEGIN
IF @Dif > 0.0
BEGIN
INSERT ContD (
ID, Renglon,          Cuenta,           Haber, Sucursal,  SucursalContable)
SELECT @ID, @Renglon+2048.0, @CfgCuentaCuadre, @Dif,  @Sucursal, @Sucursal
IF @CfgRegistro = 1 AND @MovTipo IN ('CONT.P', 'CONT.C')
INSERT ContReg (
ID,  Cuenta,           Haber, Sucursal,  Empresa)
SELECT @ID, @CfgCuentaCuadre, @Dif,  @Sucursal, @Empresa
END ELSE
BEGIN
INSERT ContD (
ID, Renglon,          Cuenta,           Debe,   Sucursal,  SucursalContable)
SELECT @ID, @Renglon+2048.0, @CfgCuentaCuadre, -@Dif,  @Sucursal, @Sucursal
IF @CfgRegistro = 1 AND @MovTipo IN ('CONT.P', 'CONT.C')
INSERT ContReg (
ID,  Cuenta,           Debe,  Sucursal,  Empresa)
SELECT @ID, @CfgCuentaCuadre, -@Dif, @Sucursal, @Empresa
END
SELECT @CentrosCostos = Cta.CentrosCostos,@CentroCostosRequerido = Cta.CentroCostosRequerido, @CentroCostosOmision = Cta.CentroCostosOmision
FROM ContD, Cta
WHERE ID = @ID AND ContD.Cuenta = @CfgCuentaCuadre
AND Cta.Cuenta = ContD.Cuenta
IF @CentrosCostos = 1 AND @CentroCostosRequerido = 1
UPDATE ContD
SET SubCuenta = @CentroCostosOmision
WHERE ID = @ID AND ContD.Cuenta = @CfgCuentaCuadre
SELECT @Ok = NULL, @Dif = 0.0, @Cuantos = @Cuantos + 1
END
IF @Ok IS NULL
BEGIN
SELECT @Dif2 = @SumaDebe2-@SumaHaber2
IF @SumaDebe2 <> @SumaHaber2 AND @Ok IS NULL SELECT @Ok = 50010, @OkRef = 'Diferencia Moneda Paralelo '+CONVERT(varchar, @Dif2)     
IF @Ok = 50010 AND ABS(@Dif2) < @CfgToleraciaRedondeo
BEGIN
IF @UltDebe2>0.0
SELECT @UltDebe2 = @UltDebe2 - @Dif2, @SumaDebe2 = @SumaDebe2 - @Dif2
ELSE SELECT @UltHaber2 = @UltHaber2 + @Dif2, @SumaHaber2 = @SumaHaber2 + @Dif2
IF @SumaDebe2 = @SumaHaber2
BEGIN
UPDATE ContD SET Debe2 = NULLIF(@UltDebe2, 0.0), Haber2 = NULLIF(@UltHaber2, 0.0) WHERE ID = @ID AND Renglon = @UltRenglon AND RenglonSub = @UltRenglonSub
SELECT @Ok = NULL
END
END
END
END
/** JH 08.08.2006 **/
IF @CfgRegistro = 1 AND @MovTipo IN ('CONT.P', 'CONT.C') AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM ContReg WHERE ID = @ID)
BEGIN
SELECT @SumaDebeReg = SUM(Debe), @SumaHaberReg = SUM(Haber) FROM ContReg WHERE ID = @ID
SELECT @Dif = ISNULL(@SumaDebe, 0.0)-ISNULL(@SumaDebeReg, 0.0)
IF @Dif <> 0.0 SELECT @Ok = 50015
IF @Ok = 50015 AND ABS(@Dif) < @CfgToleraciaRedondeo 
SELECT @Ok = NULL
SELECT @Dif = ISNULL(@SumaHaber, 0.0)-ISNULL(@SumaHaberReg, 0.0)
IF @Dif <> 0.0 SELECT @Ok = 50015
IF @Ok = 50015 AND ABS(@Dif) < @CfgToleraciaRedondeo 
SELECT @Ok = NULL
END
END
IF @Ok IS NULL AND @Cuantos <> (SELECT COUNT(*) FROM ContD WHERE ID = @ID) SELECT @Ok = 50070          
IF @Ok IS NULL AND ROUND(@SumaIVA, 0)<>ROUND(@SumaCausanIVA, 0) SELECT @Ok = 50040	     		   
IF @Ok IS NOT NULL RETURN
END
IF @Ok IS NULL
EXEC xpContVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@ContMoneda, @Estatus, @FechaContable, @CfgVerificarIVA, @CfgCentrosCostos, @CfgToleraciaRedondeo,
@Ejercicio, @Periodo, @Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

