SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaMexicoCalcSDI
@Empresa			char(5),
@SucursalTrabajo		int,
@Categoria			Varchar(50),
@Puesto				Varchar(50),
@Personal			Char(10),
@NomTipo			Varchar(50),
@EsSocio			Bit,
@SDI				Money,
@DiasNaturales			Float,
@Incapacidades			Float,
@Faltas				Float,
@SMDF				Money,
@EsBimestre			Bit,
@NomCalcSDI			Bit,
@PrimerDiaBimestre		Datetime,
@FechaA				Datetime,
@DiasAguinaldoSiguienteSDI	Float,
@DiasAguinaldoSDI		Float,
@PrimaVacacionalPct		Float,
@DiasVacacionesSiguiente	Float,
@DiasAno			Float,
@DiasVacaciones			Float,
@AntiguedadSDI			Float,
@DiasBimestre			Float,
@DiasBimestreTrabajados		Float,
@SueldoDiario			Money,
@SDIAnterior			Money,
@SDIVariableDiario		Money,
@SDINuevo			Money,
@FechaAntiguedad		Datetime,
@SDIBruto			Money,
@FhiAntiguedad			Int,
@ISRLiquidacionGravable		Money,
@CfgFactorIntegracionAntiguedad	Varchar(20),
@FaltasAcumulado		Float			OUTPUT,
@IncapacidadesAcumulado		Float			OUTPUT,
@FactorIntegracion		Float			OUTPUT,
@IMSSObrero			Money 			OUTPUT,
@IMSSObreroCV			Money 			OUTPUT,
@IMSSPatron 			Money 			OUTPUT,
@IMSSPatronMensual 		Money 			OUTPUT,
@IMSSPatronCV 			Money 			OUTPUT,
@IMSSPatronRetiro	 	Money 			OUTPUT,
@IMSSPatronInfonavit		Money 			OUTPUT,
@IMSSBase			Money 			OUTPUT,
@IMSSBaseMes			Money 			OUTPUT,
@IMSSBaseAcumulado		Money 			OUTPUT,
@IMSSObreroSinCV		Money 			OUTPUT,
@Ok				Int			OUTPUT,
@CfgFactorIntegracionTabla	Varchar(50)		OUTPUT,
@OkRef				Varchar(255) 		OUTPUT,
@Salida				int =0

AS BEGIN
DECLARE
@OtorgarPrimaVacacionalAguinaldo bit,
@AyudaFamiliar money,
@Vales         money,
@Antiguedad    float
SET @EsSocio=0
IF @NomTipo = 'SDI'
BEGIN
EXEC spPersonalPropValorBit   @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Prima Vacacional Tipo Aguinaldo (S/N)', @OtorgarPrimaVacacionalAguinaldo OUTPUT
SELECT  @NomCalcSDI=1,@EsSocio=0
IF @EsSocio = 0
BEGIN
EXEC spNominaIMSS @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, @SDI, @DiasNaturales, @Incapacidades, @Faltas, @SMDF, 1,
@IMSSObrero OUTPUT, @IMSSObreroCV OUTPUT,
@IMSSPatron OUTPUT, @IMSSPatronMensual OUTPUT, @IMSSPatronCV OUTPUT, @IMSSPatronRetiro OUTPUT, @IMSSPatronInfonavit OUTPUT
SELECT @IMSSObreroSinCV = @IMSSObrero-@IMSSObreroCV
IF EXISTS(SELECT  EsfinBimestre  FROM MovTipoNomAutoCalendarioEsp WHERE Modulo = 'NOM' AND IncidenciaA = @FechaA and EsFinBimestre = 1)  OR  @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @EsBimestre = 1
ELSE
IF  @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @EsBimestre = 0
IF @EsBimestre = 1 AND @NomCalcSDI = 1
BEGIN
IF @OtorgarPrimaVacacionalAguinaldo = 1
BEGIN
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'SDI Desde (DD/MM/AAAA)', @PrimerDiaBimestre OUTPUT
EXEC spPersonalPropValorDMA   @Empresa, NULL,   NULL, NULL, NULL, 'SDI Hasta (DD/MM/AAAA)', @FechaA OUTPUT
END
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, 'IMSS/Base', @PrimerDiaBimestre, @FechaA, NULL, @IMSSBaseAcumulado OUTPUT, NULL
IF @OtorgarPrimaVacacionalAguinaldo <> 1
begin
SELECT  @FaltasAcumulado=0 /*sum (a.cantidad)*/
FROM NOMINAD a, nomina b
WHERE a.id=b.id
and b.estatus='concluido'
and b.fechaemision between @PrimerDiaBimestre and @FechaA
AND a.CONCEPTO in ('Falta Injustificada','Incapacidad EG','Incapacidad Enfermedad Continua','Incapacidad Maternidad','Incapacidad Accidente','Incapacidad Accidente Trayecto','Sancion','Permiso sin goce')
AND A.PERSONAL=@PERSONAL
END
ELSE
BEGIN
SELECT @FaltasAcumulado=0, @IncapacidadesAcumulado=0,@Faltas=0, @incapacidades=0
END
SELECT @IMSSBaseMes =  ISNULL(@IMSSBaseAcumulado,0) + ISNULL(@IMSSBase,0)
SELECT @FactorIntegracion = NULL
IF @CfgFactorIntegracionAntiguedad = 'SIGUIENTE'
BEGIN
SELECT @FactorIntegracion = 1+((@DiasAguinaldoSiguienteSDI+((@PrimaVacacionalPct/100.0)*@DiasVacacionesSiguiente))/@DiasAno)
END ELSE
IF @CfgFactorIntegracionAntiguedad = 'ACTUAL'
BEGIN
SELECT @FactorIntegracion = 1+((@DiasAguinaldoSDI+((@PrimaVacacionalPct/100.0)*@DiasVacaciones))/@DiasAno)
END
ELSE
IF @CfgFactorIntegracionAntiguedad = 'TABLA'
EXEC spTablaNum @CfgFactorIntegracionTabla, @AntiguedadSDI, @FactorIntegracion OUTPUT
SELECT @DiasBimestre = DATEDIFF(day, @PrimerDiaBimestre, @FechaA) + 1
SELECT @DiasBimestreTrabajados = dbo.fnmenor(@DiasBimestre, @DiasBimestre - ISNULL(@FaltasAcumulado, 0.0) - ISNULL(@IncapacidadesAcumulado, 0.0) - @Faltas - @Incapacidades)
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Ayuda Familiar', @AyudaFamiliar OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Vales Despensa Importe', @Vales OUTPUT
IF @OtorgarPrimaVacacionalAguinaldo = 1
SELECT @SDINuevo = dbo.fnMayor(dbo.fnMenor((@SueldoDiario * @FactorIntegracion) + (@Ayudafamiliar / 14.0)+ ((@Vales/14.0) - (@SMDF * 0.40)) + (@IMSSBaseMes / @DiasBimestreTrabajados), 25*@SMDF),@SMDF*1.0452)
ELSE
SELECT @SDINuevo = dbo.fnMayor(dbo.fnMenor(@SueldoDiario * @FactorIntegracion + (@IMSSBaseMes / @DiasBimestreTrabajados), 25*@SMDF),@SMDF*1.0452)
SET @SDIAnterior=0
SELECT @SDIAnterior=isnull(sdi,0) from PERSONAL WHERE PERSONAL = @Personal
IF @SDIAnterior=NULL SET @SDIAnterior=0
SELECT @SDIVariableDiario = (@IMSSBaseAcumulado / (isnull(@DiasBimestreTrabajados,1)))
if @Salida = 0
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI', @Empresa, @Personal, @DiasBimestreTrabajados, @SDINuevo
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/Factor', @Empresa, @Personal, @FactorIntegracion
END
SELECT @SDIBruto = @SueldoDiario* @FactorIntegracion
SELECT @FhiAntiguedad=CONVERT(int,dbo.fnFormatDateTime(@FechaAntiguedad, 'YYYYMMDD'))
SELECT @FhiAntiguedad=(DATEDIFF(day, @fechaAntiguedad, @FechaA) + 1)/(@DiasAno)
if @Salida = 0
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/FechaAntiguedad', @Empresa, @Personal, @FhiAntiguedad
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/Bruto', @Empresa, @Personal, @Importe = @SDIBruto
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/AcumuladoGravable', @Empresa, @Personal, @Importe = @IMSSBaseAcumulado
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Dias/IMSSBimestre', @Empresa, @Personal, @DiasBimestreTrabajados
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/VariableDiario', @Empresa, @Personal, @Importe = @SDIVariableDiario
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/Neto', @Empresa, @Personal, @Importe = @SDINuevo
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'SDI/Anterior', @Empresa, @Personal, @Importe = @SDIAnterior
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Indemnizacion/Gravable', @Empresa, @Personal, @Importe = @ISRLiquidacionGravable
END
END
END
END
if @Salida <> 0
SELECT @Personal,@SDINuevo
RETURN
END

