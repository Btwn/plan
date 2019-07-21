SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerSDI
@Empresa       	char(5),
@Sucursal      	int,
@Categoria     	varchar(50),
@Puesto     	varchar(50),
@Personal      	char(10),
@AnosCumplidos 	int,
@SueldoDiario  	money,
@TipoSueldo 	varchar(10),
@EnSilencio	int 		= 0,
@SDI     	money		= NULL	OUTPUT,
@ZonaEconomica	varchar(50) 	= NULL

AS BEGIN
DECLARE
@Factor  		float,
@Dias    		int,
@GravableIMSS 	money,
@FechaD   		datetime,
@FechaA   		datetime,
@Fecha    		datetime,
@Autotransportes	bit,
@CANAPAT		bit,
@FactorCANAPAT	float,
@SDIMaximo          money,
@Jornada		varchar(20)
SELECT @Dias		= 0,
@GravableIMSS  = 0,
@CANAPAT       = 0,
@FactorCANAPAT = NULL,
@SDI		= NULL
EXEC xpVerSDI @Empresa, @Sucursal, @Categoria, @Personal, @AnosCumplidos, @SueldoDiario, @TipoSueldo, @EnSilencio, @SDI OUTPUT, @ZonaEconomica
IF @SDI IS NOT NULL
BEGIN
IF @EnSilencio = 0
SELECT "SDI" = @SDI
RETURN
END
SELECT @Jornada = Jornada, @ZonaEconomica = ISNULL(@ZonaEconomica, ZonaEconomica) FROM Personal WHERE Personal = @Personal
SELECT @Autotransportes = ISNULL(Autotransportes, 0) FROM EmpresaGral WHERE Empresa = @Empresa
IF @Autotransportes = 1
SELECT @CANAPAT = AutoCANAPAT FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @CANAPAT = 1
BEGIN
SELECT @FactorCANAPAT = NULLIF(FactorCANAPAT, 0) FROM PersonalCat WHERE Categoria = @Categoria
SELECT @SDI = @FactorCANAPAT * SueldoMinimo FROM ZonaEconomica WHERE Zona = @ZonaEconomica
END
IF @SDI IS NULL
BEGIN
SELECT @Fecha= GETDATE()
EXEC spNominaDiasBimestre  @Fecha, @FechaD  OUTPUT,  @FechaA  OUTPUT
IF UPPER(@TipoSueldo) <> 'FIJO'
BEGIN
EXEC spNominaAcumuladoFechas @Empresa, @Personal,'Sueldo', @FechaD, @FechaA, NULL, NULL, @Dias OUTPUT
EXEC spNominaAcumuladoFechas @Empresa, @Personal,'Acumulado Gravable IMSS', @FechaD, @FechaA, NULL, @GravableIMSS OUTPUT, NULL
END
EXEC spNominaFactorIntegracion @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, @AnosCumplidos, @Factor OUTPUT
IF ISNULL(@Dias, 0) > 0
SELECT @SDI = (@Factor * @SueldoDiario)+(ISNULL(@GravableIMSS, 0)/@Dias)
ELSE
SELECT @SDI = (@Factor * @SueldoDiario)
EXEC xpSDIFijo @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, @SueldoDiario, @SDI OUTPUT
END
SELECT @SDIMaximo     = 25.0 * ISNULL( SueldoMinimo, 0 ) FROM ZonaEconomica WHERE Zona='A'
IF @SDI > @SDIMaximo
SELECT @SDI = @SDIMaximo
IF ISNULL((SELECT JornadaReducida FROM Jornada WHERE Jornada = @Jornada), 0) = 0
IF EXISTS(SELECT SueldoMinimo FROM ZonaEconomica WHERE Zona = @ZonaEconomica AND SueldoMinimo>@SDI)
SELECT @SDI = SueldoMinimo FROM ZonaEconomica WHERE Zona = @ZonaEconomica
IF @EnSilencio = 0
SELECT "SDI" = @SDI
RETURN
END

