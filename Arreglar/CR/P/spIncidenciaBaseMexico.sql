SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER  PROCEDURE spIncidenciaBaseMexico
@Empresa		     char(5),
@FechaEmision		  datetime,
@FechaAplicacion	datetime,
@Personal		char(10),
@NominaConcepto		varchar(10),
@EnSilencio		bit		= 0,
@Cantidad		float		= NULL	OUTPUT,
@Valor			money		= NULL	OUTPUT,
@Porcentaje		float		= NULL	OUTPUT,
@Acreedor         	varchar(10)	= NULL	OUTPUT,
@Vencimiento		datetime	= NULL	OUTPUT

AS BEGIN
DECLARE
@DiasMes			float,
@DiasMesSueldo			float,
@DiasAno		  	float,
@DiasVacaciones       	float,
@DiasVacaciones2      	float,
@DiasVacaciones3      	float,
@DiasTrabajados       	float,
@MasVacaciones        	bit,
@DiasPeriodoEstandar	float,
@HorasDia			float,
@FactorAusentismo		float,
@Categoria			varchar(50),
@Puesto			varchar(50),
@PeriodoTipo		varchar(20),
@SucursalTrabajo		int,
@ZonaEconomica		varchar(30),
@Ejercicio			int,
@Periodo			int,
@SemanasPeriodo		int,
@SDI	    		money,
@SueldoDiario		money,
@SueldoDiarioVariable 	money,
@SueldoVariableVacacionesA 	datetime,
@SueldoVariableVacacionesD 	datetime,
@FechaAlta 			datetime,
@SueldoVariableAcumulado 	money,
@SueldoHora		        money,
@SueldoPeriodo 		money,
@SueldoMensual 		money,
@SueldoMensualPersonal 	money,
@SMZ			money,
@SMDF			money,
@TieneSubConceptos		bit,
@CantidadBase		varchar(50),
@CantidadPropiedad		varchar(50),
@CantidadEsPorcentaje 	bit,
@Factor			float,
@PorcentajeBase		varchar(50),
@PorcentajePropiedad	varchar(50),
@ValorBase			varchar(50),
@ValorPropiedad		varchar(50),
@AcreedorBase		varchar(50),
@AcreedorPropiedad		varchar(50),
@VencimientoBase		varchar(50),
@VencimientoDia		int,
@ImportePrimProd            money,
@ImporteComisiones          money,
@ImporteViaticos            money,
@VencimientoMes		varchar(50),
@RedondeoMonetarios 	int,
@SueldoDiarioComplemento Float
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @SucursalTrabajo 	  = p.SucursalTrabajo,
@Categoria 	  	    = p.Categoria,
@Puesto	  	        = p.Puesto,
@SDI	    	  	      = ISNULL(p.SDI, 0.0),
@SueldoDiario	  	  = ISNULL(p.SueldoDiario, 0.0),
@ZonaEconomica	  	  = p.ZonaEconomica,
@HorasDia	  	      = j.HorasPromedio,
@FactorAusentismo    = j.FactorAusentismo,
@DiasPeriodoEstandar	= ISNULL(pt.DiasPeriodo, 0),
@PeriodoTipo		      = p.PeriodoTipo,
@SueldoDiarioComplemento = p.SueldoDiarioComplemento,
@FechaAlta             = p.FechaAlta
FROM Personal p
LEFT OUTER JOIN Jornada j ON j.Jornada = p.Jornada
LEFT OUTER JOIN PeriodoTipo pt ON pt.PeriodoTipo = p.PeriodoTipo
WHERE p.Personal = @Personal
SELECT @Periodo = Periodo, @Ejercicio = Ejercicio, @SemanasPeriodo = SemanasPeriodo
FROM PeriodoTipoCalendario
WHERE PeriodoTipo = @PeriodoTipo AND Abierto = 1
SELECT @SMZ = SueldoMinimo FROM ZonaEconomica WHERE Zona = @ZonaEconomica
SELECT @SMDF = SueldoMinimo FROM ZonaEconomica WHERE Zona = 'A'
SELECT @CantidadBase	      	= UPPER(CantidadBase),
@CantidadPropiedad   	= CantidadPropiedad,
@Cantidad	      	= CantidadDef,
@CantidadEsPorcentaje  = ISNULL(CantidadEsPorcentaje, 0),
@PorcentajeBase      	= UPPER(PorcentajeBase),
@PorcentajePropiedad 	= PorcentajePropiedad,
@Porcentaje      	= PorcentajeDef,
@ValorBase	      	= UPPER(ValorBase),
@ValorPropiedad      	= ValorPropiedad,
@Valor		      	= ValorDef,
@TieneSubConceptos   	= TieneSubConceptos,
@AcreedorBase		= UPPER(AcreedorBase),
@AcreedorPropiedad	= AcreedorPropiedad,
@Acreedor		= AcreedorDef,
@VencimientoBase	= UPPER(VencimientoBase),
@VencimientoDia	= VencimientoDia,
@VencimientoMes	= VencimientoMes
FROM NominaConcepto
WHERE NominaConcepto = @NominaConcepto
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Mes', @DiasMes OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Mes Sueldo', @DiasMesSueldo OUTPUT
EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, '# Dias Ano', @DiasAno OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Importe Comisiones',		 @ImporteComisiones OUTPUT
EXEC spPersonalPropValorMoney @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'Importe PRIM.PRODUCC.', @ImportePrimProd OUTPUT
SELECT @SueldoPeriodo = @SueldoDiario * @DiasPeriodoEstandar
SELECT @SueldoMensual = @SueldoDiario * ISNULL(@DiasMesSueldo,30)
IF @CantidadBase = 'PROPIEDAD'    EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, @CantidadPropiedad, @Cantidad OUTPUT ELSE
IF @CantidadBase = 'DIAS PERIODO' SELECT @Cantidad = @DiasPeriodoEstandar
IF @PorcentajeBase = 'PROPIEDAD'         EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, @PorcentajePropiedad, @Porcentaje OUTPUT ELSE
IF @PorcentajeBase = 'FACTOR AUSENTISMO' SELECT @Porcentaje = @FactorAusentismo*100.0
IF @ValorBase = 'PROPIEDAD'      	      	EXEC spPersonalPropValorFloat @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, @ValorPropiedad, @Valor OUTPUT ELSE
IF @ValorBase = 'SUELDO DIARIO'  	SELECT  @Valor = @SueldoDiario ELSE
IF @ValorBase = 'SUELDO DIARIO COMPLEMENTO'  	SELECT  @Valor = @SueldoDiarioComplemento ELSE
IF @ValorBase = 'SUELDO DIARIO VAC'  	SELECT  @Valor = @SueldoDiarioVariable ELSE
IF @ValorBase = 'SUELDO DIARIO MES'  	SELECT  @Valor = @SueldoMensualPersonal/30.0 ELSE
IF @ValorBase = 'ACUM MES ANT MENOS VAC '    EXEC   spCalculaPremioAsistencia  @Empresa, @Personal, @FechaAplicacion, @Valor   OUTPUT
IF @ValorBase = 'SDI' 	   	      SELECT @Valor = @SDI ELSE
IF @ValorBase = 'SUELDO PERIODO' 	SELECT @Valor = @SueldoDiario*@DiasPeriodoEstandar ELSE
IF @ValorBase = 'SUELDO MENSUAL' 	SELECT @Valor = @SueldoDiario*@DiasMesSueldo ELSE
IF @ValorBase = 'SUELDO ANUAL'   	SELECT @Valor = @SueldoDiario*@DiasAno ELSE
IF @ValorBase = 'SUELDO HORA'     	SELECT @Valor = @SueldoDiario/NULLIF (@HorasDia ,0.0)ELSE
IF @ValorBase = 'SUELDO HORA JORNADA' SELECT @Valor = (@SueldoDiario/NULLIF(@HorasDia, 0.0))*@FactorAusentismo ELSE
IF @ValorBase = 'SALARIO MINIMO ZONA' SELECT @Valor = @SMZ ELSE
IF @ValorBase = 'SALARIO MINIMO DF'   SELECT @Valor = @SMDF
IF @VencimientoBase = 'FECHA EMISION INCIDENCIA'    SELECT @Vencimiento = @FechaEmision ELSE
IF @VencimientoBase = 'FECHA APLICACION INCIDENCIA' SELECT @Vencimiento = @FechaAplicacion
SELECT @Valor = @Valor
SELECT @Porcentaje = ISNULL(@Porcentaje, 100.0)
IF @EnSilencio = 0
SELECT "Cantidad" = @Cantidad, "Valor" = @Valor, "Porcentaje" = @Porcentaje, "Acreedor" = @Acreedor, "Vencimiento" = @Vencimiento,
"ValorBase"=@ValorBase
RETURN
END

