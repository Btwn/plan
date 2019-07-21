SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDReporteCorteCont
@ID                	int,
@Accion				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
@MovTipo     		char(20),
@SubMovTipo     	char(20),
@FechaEmision      	datetime,
@FechaAfectacion    datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@MovUsuario			char(10),
@CorteFrecuencia	varchar(50),
@CorteGrupo			varchar(50),
@CorteTipo			varchar(50),
@CortePeriodo		int,
@CorteEjercicio		int,
@CorteOrigen		varchar(50),
@CorteCuentaTipo	varchar(20),
@CorteGrupoDe		varchar(10),
@CorteGrupoA		varchar(10),
@CorteSubGrupoDe	varchar(20),
@CorteSubGrupoA		varchar(20),
@CorteCuentaDe		varchar(10),
@CorteCuentaA		varchar(10),
@CorteSubCuentaDe	varchar(50),
@CorteSubCuenta2A	varchar(50),
@CorteSubCuenta2De	varchar(50),
@CorteSubCuenta3A	varchar(50),
@CorteSubCuenta3De	varchar(50),
@CorteSubCuentaA	varchar(50),
@CorteUENDe			int,
@CorteUENA			int,
@CorteProyectoDe	varchar(50),
@CorteProyectoA		varchar(50),
@CorteFechaD		datetime,
@CorteFechaA		datetime,
@Moneda				varchar(10),
@TipoCambio			float,
@CorteTitulo		varchar(100),
@CorteMensaje		varchar(100),
@CorteEstatus		varchar(15),
@CorteSucursalDe	int,
@CorteSucursalA		int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@SucursalDestino	int,
@SucursalOrigen		int,
@Estacion			int,
@CorteValuacion		varchar(50),
@CorteDesglosar		varchar(20),
@CorteFiltrarFechas	bit,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @Direccion2				varchar(100),
@Direccion3				varchar(100),
@Direccion4				varchar(100),
@FechaA					datetime,
@AgrupadorAux				varchar(50),
@AgrupadorAuxAnt			varchar(50),
@RID						int,
@RIDAnt					int,
@Desglosar				varchar(20),
@ConsEmpresa				varchar(10),
@ConsCuenta				varchar(20),
@ConsCtaCategoria			varchar(50),
@ConsCtaFamilia			varchar(50),
@ConsCtaGrupo				varchar(50),
@ConsSucursal				varchar(10),
@ConsUEN					varchar(10),
@ConsMovimiento			varchar(20),
@ConsEstatus				varchar(15),
@ConsProyecto				varchar(50),
@ConsContactoTipo			varchar(20),
@ConsContacto				varchar(10),
@ConsImporteMinimo		float,
@ConsImporteMaximo		float,
@ConsTotalizador			varchar(255),
@ConsAccion				varchar(8),
@PrimerCiclo		bit,
@TotalSumaDebe	float,
@TotalSumaHaber	float,
@TotalSumaSaldo	float,
@TotalSumaSaldoI	float,
@TotalRestaDebe	float,
@TotalRestaHaber	float,
@TotalRestaSaldo	float,
@TotalRestaSaldoI	float,
@TotalInfDebe		float,
@TotalInfHaber	float,
@TotalInfSaldo	float,
@TotalInfSaldoI	float,
@Total			float,
@RangoFecha		varchar(255)
DECLARE @ContactoDireccion TABLE
(
Contacto				varchar(10)  COLLATE DATABASE_DEFAULT NULL,
Direccion1				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion2				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion3				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion4				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion5				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion6				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion7				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion8				varchar(255) COLLATE DATABASE_DEFAULT NULL
)
EXEC spContactoDireccionHorizontal @Estacion, 'Empresa', @Empresa, @Empresa, 1,1,1,1
INSERT @ContactoDireccion(
Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8)
SELECT Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8
FROM ContactoDireccionHorizontal
WHERE Estacion = @Estacion
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM @ContactoDireccion
SELECT @FechaA = GETDATE()
SELECT @AgrupadorAux = MIN(Agrupador)
FROM CorteDConsulta
WHERE ID	= @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Agrupador1)
SELECT @ID,	'TIT',	@CorteTitulo,	@AgrupadorAux
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,			Columna3,			Columna4,			Agrupador1)
SELECT @ID,	'ENC1',	'Referencia:',	Referencia,			'Tipo:',			CorteTipo,			@AgrupadorAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,			Columna3,			Columna4,			Agrupador1)
SELECT @ID,	'ENC2',	'Concepto:',	Concepto,			'Grupo:',			CorteGrupo,			@AgrupadorAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		 Columna2,			Columna3,			Columna4,			Agrupador1)
SELECT @ID,	'ENC3',	'Observaciones:',Observaciones,		'Frecuencia:',		CorteFrecuencia,	@AgrupadorAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,			Agrupador1)
SELECT @ID,	'ENC4',	'Origen:',		CorteOrigen,		@AgrupadorAux
FROM Corte
WHERE ID = @ID
IF ISNULL(@CorteFiltrarFechas, 0) = 1
BEGIN
INSERT INTO #CorteDReporte(
ID,		Tipo,		Columna1,
Agrupador1)
SELECT @ID,		'ENC5',		'De la fecha ' + dbo.fnFormatearFecha(@CorteFechaD, 'dd/MM/aaaa') + ' A la fecha ' + dbo.fnFormatearFecha(@CorteFechaA, 'dd/MM/aaaa'),
@AgrupadorAux
END
ELSE
BEGIN
SELECT @RangoFecha = ''
IF ISNULL(@CorteEjercicio, 0) <> 0
SELECT @RangoFecha = 'Ejercicio ' + CONVERT(varchar, ISNULL(@CorteEjercicio, 0)) + ' '
IF ISNULL(@CortePeriodo, 0) <> 0
SELECT @RangoFecha = @RangoFecha + 'Periodo ' + CONVERT(varchar, ISNULL(@CortePeriodo, 0))
INSERT INTO #CorteDReporte(
ID,		Tipo,		Columna1,
Agrupador1)
SELECT @ID,		'ENC6',		@RangoFecha,
@AgrupadorAux
END
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Agrupador1)
SELECT @ID,	'ENC7', Empresa.Nombre,	@AgrupadorAux
FROM Empresa
WHERE Empresa = @Empresa
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'ENC8',  Direccion2, @AgrupadorAux FROM @ContactoDireccion
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'ENC9',  Direccion3, @AgrupadorAux FROM @ContactoDireccion
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'ENC10', Direccion4, @AgrupadorAux FROM @ContactoDireccion
INSERT INTO #CorteDReporte(
ID,												Tipo,		Columna1,		Columna2,
Columna3,										Agrupador1)
SELECT @ID,											'ENC11',	@CorteTitulo,	'',
dbo.fnFormatearFecha(@FechaA, 'dd/MM/aaaa'),	@AgrupadorAux
INSERT INTO #CorteDReporte(
ID,							Tipo,						Columna1,						Columna2,
Columna3,					Columna4,					Agrupador1)
SELECT @ID,						'ENC12',					'Informar (' + @Moneda + ')',	'Sumar (' + @Moneda + ')',
'Restar (' + @Moneda + ')',	'Total (' + @Moneda + ')',	@AgrupadorAux
INSERT INTO #CorteDReporte(
ID,													Tipo,													Columna1,
Columna2,											Columna3,												Columna4,
Columna5,											Columna6,												Columna7,
Columna8,											Columna9,												Columna10,
Columna11,											Columna12,												Columna13,
Columna14,											Columna15,												Columna16,
Columna17,											Agrupador1)
SELECT @ID,												'NOM',													'Cuenta',
'Descripción',										'Movimiento',											'Fecha',
'Saldo Inicial',									'Debe',													'Haber',
'Saldo Final',										'Saldo Inicial',										'Debe',
'Haber',											'Saldo Final',											'Saldo Inicial',
'Debe',												'Haber',												'Saldo Final',
'Importe Total',									@AgrupadorAux
SELECT @AgrupadorAuxAnt = '', @PrimerCiclo = 1
WHILE(1=1)
BEGIN
IF @PrimerCiclo = 1
SELECT @AgrupadorAux = MIN(Agrupador)
FROM CorteDConsulta
WHERE ID	= @ID
AND ISNULL(Agrupador, '') >= @AgrupadorAuxAnt
ELSE
SELECT @AgrupadorAux = MIN(Agrupador)
FROM CorteDConsulta
WHERE ID	= @ID
AND ISNULL(Agrupador, '') > @AgrupadorAuxAnt
IF @AgrupadorAux IS NULL AND @PrimerCiclo = 0 BREAK
SELECT @AgrupadorAuxAnt = @AgrupadorAux, @PrimerCiclo = 0, @TotalSumaDebe = NULL, @TotalSumaHaber = NULL, @TotalSumaSaldo = NULL,
@TotalSumaSaldoI = NULL, @TotalRestaDebe = NULL, @TotalRestaHaber = NULL, @TotalRestaSaldo = NULL, @TotalRestaSaldoI = NULL,
@TotalInfDebe = NULL, @TotalInfHaber = NULL, @TotalInfSaldo = NULL, @TotalInfSaldoI = NULL
INSERT INTO #CorteDReporte(
ID,	Tipo,		Columna1,					Agrupador1)
SELECT @ID,	'SUBT3',	ISNULL(@AgrupadorAux, ''),	@AgrupadorAux
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Agrupador, '') = ISNULL(@AgrupadorAux, '')
AND RID	> @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID, @Desglosar = ''
SELECT @ConsEmpresa = NULL, @ConsCuenta = NULL, @ConsCtaCategoria = NULL, @ConsCtaFamilia = NULL, @ConsCtaGrupo = NULL, @ConsSucursal = NULL,
@ConsUEN = NULL, @ConsMovimiento = NULL, @ConsEstatus = NULL, @ConsProyecto = NULL, @ConsContactoTipo = NULL, @ConsContacto = NULL,
@ConsImporteMinimo = NULL, @ConsImporteMaximo = NULL, @ConsTotalizador = NULL, @ConsAccion = NULL
SELECT @Desglosar			= ISNULL(Desglosar, 'No'),
@ConsEmpresa		= ISNULL(Empresa, '(TODOS)'),
@ConsCuenta		= ISNULL(Cuenta, '(TODOS)'),
@ConsCtaCategoria	= ISNULL(CtaCategoria, '(TODOS)'),
@ConsCtaFamilia	= ISNULL(CtaFamilia, '(TODOS)'),
@ConsCtaGrupo		= ISNULL(CtaGrupo, '(TODOS)'),
@ConsSucursal		= ISNULL(CONVERT(varchar, Sucursal), '(TODOS)'),
@ConsUEN			= ISNULL(CONVERT(varchar, UEN), '(TODOS)'),
@ConsMovimiento	= ISNULL(Movimiento, '(TODOS)'),
@ConsEstatus		= ISNULL(Estatus, '(TODOS)'),
@ConsProyecto		= ISNULL(Proyecto, '(TODOS)'),
@ConsContactoTipo	= ISNULL(ContactoTipo, '(TODOS)'),
@ConsContacto		= ISNULL(Contacto, '(TODOS)'),
@ConsImporteMinimo = ISNULL(ImporteMin, 0),
@ConsImporteMaximo	= ISNULL(ImporteMax, 0),
@ConsTotalizador	= Totalizador,
@ConsAccion		= Accion
FROM CorteDConsultaNormalizada
WHERE ID		= @ID
AND ISNULL(Agrupador, '') = ISNULL(@AgrupadorAux, '')
AND RID	= @RID
SELECT @TotalInfDebe   = SUM(Cargo),
@TotalInfHaber  = SUM(Abono),
@TotalInfSaldo  = SUM(Saldo),
@TotalInfSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND RID	= @RID
AND ISNULL(Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(Accion, '')		= 'Informar'
SELECT @TotalSumaDebe   = SUM(Cargo),
@TotalSumaHaber  = SUM(Abono),
@TotalSumaSaldo  = SUM(Saldo),
@TotalSumaSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND RID	= @RID
AND ISNULL(Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(Accion, '')		= 'Sumar'
SELECT @TotalRestaDebe   = SUM(Cargo),
@TotalRestaHaber  = SUM(Abono),
@TotalRestaSaldo  = SUM(Saldo),
@TotalRestaSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND RID	= @RID
AND ISNULL(Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(Accion, '')		= 'Restar'
IF @Desglosar <> 'No'
BEGIN
INSERT INTO #CorteDReporte(
ID,
Tipo,
Columna1,
Columna2,
Columna3,
Columna4,
Columna5,
Columna6,
Columna7,
Columna8,
Agrupador1)
SELECT @ID,
'DET',
d.Cuenta,
Cta.Descripcion,
CASE @Desglosar WHEN 'Movimiento' THEN RTRIM(d.Mov) +' '+ RTRIM(ISNULL(d.MovID, '')) ELSE @ConsMovimiento END,
CASE @Desglosar WHEN 'Movimiento' THEN NULLIF(dbo.fnFormatearFecha(d.Fecha, 'dd/MM/aaaa'), '//') ELSE '(TODOS)' END,
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.SaldoI)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Cargo)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Abono)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Saldo)), '$'),
@AgrupadorAux
FROM CorteD d
JOIN CorteDConsulta c ON d.ID = c.ID AND d.RIDConsulta = c.RID
JOIN Cta ON d.Cuenta = Cta.Cuenta
WHERE c.ID		= @ID
AND c.RID		= @RID
AND ISNULL(c.Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(c.Accion, '')		= 'Informar'
GROUP BY d.Cuenta, Cta.Descripcion, d.Mov, d.MovID, d.Fecha
INSERT INTO #CorteDReporte(
ID,
Tipo,
Columna1,
Columna2,
Columna3,
Columna4,
Columna9,
Columna10,
Columna11,
Columna12,
Columna17,
Agrupador1)
SELECT @ID,
'DET',
d.Cuenta,
Cta.Descripcion,
CASE @Desglosar WHEN 'Movimiento' THEN RTRIM(d.Mov) +' '+ RTRIM(ISNULL(d.MovID, '')) ELSE @ConsMovimiento END,
CASE @Desglosar WHEN 'Movimiento' THEN NULLIF(dbo.fnFormatearFecha(d.Fecha, 'dd/MM/aaaa'), '//') ELSE '(TODOS)' END,
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.SaldoI)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Cargo)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Abono)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Saldo)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Saldo)), '$'),
@AgrupadorAux
FROM CorteD d
JOIN CorteDConsulta c ON d.ID = c.ID AND d.RIDConsulta = c.RID
JOIN Cta ON d.Cuenta = Cta.Cuenta
WHERE c.ID		= @ID
AND c.RID		= @RID
AND ISNULL(c.Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(c.Accion, '')		= 'Sumar'
GROUP BY d.Cuenta, Cta.Descripcion, d.Mov, d.MovID, d.Fecha
INSERT INTO #CorteDReporte(
ID,
Tipo,
Columna1,
Columna2,
Columna3,
Columna4,
Columna13,
Columna14,
Columna15,
Columna16,
Columna17,
Agrupador1)
SELECT @ID,
'DET',
d.Cuenta,
Cta.Descripcion,
CASE @Desglosar WHEN 'Movimiento' THEN RTRIM(d.Mov) +' '+ RTRIM(ISNULL(d.MovID, '')) ELSE @ConsMovimiento END,
CASE @Desglosar WHEN 'Movimiento' THEN NULLIF(dbo.fnFormatearFecha(d.Fecha, 'dd/MM/aaaa'), '//') ELSE '(TODOS)' END,
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.SaldoI)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Cargo)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Abono)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(d.Saldo)), '$'),
NULLIF(dbo.fnMonetarioEnTexto(SUM(-d.Saldo)), '$'),
@AgrupadorAux
FROM CorteD d
JOIN CorteDConsulta c ON d.ID = c.ID AND d.RIDConsulta = c.RID
JOIN Cta ON d.Cuenta = Cta.Cuenta
WHERE c.ID		= @ID
AND c.RID		= @RID
AND ISNULL(c.Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(c.Accion, '')		= 'Restar'
GROUP BY d.Cuenta, Cta.Descripcion, d.Mov, d.MovID, d.Fecha
END
ELSE
BEGIN
IF @ConsAccion = 'Informar'
INSERT INTO #CorteDReporte(
ID,														Tipo,
Columna1,												Columna2,
Columna3,												Columna4,
Columna5,												Columna6,
Columna7,												Columna8,
Agrupador1)
SELECT @ID,													'DET',
@ConsCuenta,											'',
@ConsMovimiento,										'(TODOS)',
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalInfDebe), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldo), '$'),
@AgrupadorAux
ELSE IF @ConsAccion = 'Sumar'
INSERT INTO #CorteDReporte(
ID,														Tipo,
Columna1,												Columna2,
Columna3,												Columna4,
Columna9,												Columna10,
Columna11,												Columna12,
Columna17,												Agrupador1)
SELECT @ID,													'DET',
@ConsCuenta,											'',
@ConsMovimiento,										'(TODOS)',
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaDebe), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldo), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldo), '$'),	@AgrupadorAux
ELSE IF @ConsAccion = 'Restar'
INSERT INTO #CorteDReporte(
ID,														Tipo,
Columna1,												Columna2,
Columna3,												Columna4,
Columna13,												Columna14,
Columna15,												Columna16,
Columna17,												Agrupador1)
SELECT @ID,													'DET',
@ConsCuenta,											'',
@ConsMovimiento,										'(TODOS)',
NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaDebe), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldo), '$'),
NULLIF(dbo.fnMonetarioEnTexto(-@TotalRestaSaldo), '$'),	@AgrupadorAux
END
INSERT INTO #CorteDReporte(
ID,														Tipo,													Columna1,
Columna2,												Columna3,												Columna4,
Columna5,												Columna6,												Columna7,
Columna8,												Columna9,												Columna10,
Columna11,												Columna12,												Columna13,
Columna14,												Columna15,												Columna16,
Columna17,												Columna18,												Columna19,
Columna20,												Columna21,												Columna22,
Columna23,												Columna24,												Columna25,
Columna26,												Columna27,												Columna28,
Columna29,												Columna30,												Columna31,
Columna32,												Columna33,												Columna34,
Columna35,												Columna36,												Columna37,
Columna38,												Columna39,												Columna40,
Columna41,												Columna42,												Columna43,
Agrupador1)
SELECT @ID,													'SUBT',													'Empresa',
@ConsEmpresa,											'Cuenta',												@ConsCuenta,
'Categoria',											@ConsCtaCategoria,										'Familia',
@ConsCtaFamilia,										'Grupo',												@ConsCtaGrupo,
'Sucursal',												@ConsSucursal,											'UEN',
@ConsUEN,												'Movimiento',											@ConsMovimiento,
'Estatus',												@ConsEstatus,											'Proyecto',
@ConsProyecto,											'Tipo Contacto',										@ConsContactoTipo,
'Contacto',												@ConsContacto,											'Importe Min.',
dbo.fnMonetarioEnTexto(@ConsImporteMinimo),				'Importe Max.',											NULLIF(dbo.fnMonetarioEnTexto(@ConsImporteMaximo), '$'),
'Totalizador',											@ConsTotalizador,										NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldoI), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfDebe), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalInfHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldo), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaDebe), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaHaber), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldo), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaDebe), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldo), '$'),	NULLIF(dbo.fnMonetarioEnTexto(ISNULL(@TotalSumaSaldo, 0)-ISNULL(@TotalRestaSaldo, 0)), '$'),
@AgrupadorAux
END
SELECT @TotalInfDebe   = SUM(Cargo),
@TotalInfHaber  = SUM(Abono),
@TotalInfSaldo  = SUM(Saldo),
@TotalInfSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(Accion, '')		= 'Informar'
SELECT @TotalSumaDebe   = SUM(Cargo),
@TotalSumaHaber  = SUM(Abono),
@TotalSumaSaldo  = SUM(Saldo),
@TotalSumaSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(Accion, '')		= 'Sumar'
SELECT @TotalRestaDebe   = SUM(Cargo),
@TotalRestaHaber  = SUM(Abono),
@TotalRestaSaldo  = SUM(Saldo),
@TotalRestaSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Agrupador, '')	= ISNULL(@AgrupadorAux, '')
AND ISNULL(Accion, '')		= 'Restar'
INSERT INTO #CorteDReporte(
ID,														Tipo,													Columna1,
Columna2,													Columna3,												Columna4,
Columna5,													Columna6,												Columna7,
Columna8,													Columna9,												Columna10,
Columna11,												Columna12,												Columna13,
Columna14,												Agrupador1)
SELECT @ID,														'SUBT2',												CASE @TipoCambio WHEN 1.0 THEN 'Total ' + ISNULL(@AgrupadorAux, '') + ' (' + @Moneda + ')' ELSE 'Total ' + ISNULL(@AgrupadorAux, '') + ' (' + @Moneda + ' - ' + RTRIM(dbo.fnMonetarioEnTexto(@TipoCambio)) + ')' END,
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldoI), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalInfDebe), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalInfHaber), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldo), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaDebe), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaHaber), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldo), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldoI), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaDebe), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldo), '$'),
NULLIF(dbo.fnMonetarioEnTexto(ISNULL(@TotalSumaSaldo, 0)-ISNULL(@TotalRestaSaldo, 0)), '$'), @AgrupadorAux
END
SELECT @TotalInfDebe   = SUM(Cargo),
@TotalInfHaber  = SUM(Abono),
@TotalInfSaldo  = SUM(Saldo),
@TotalInfSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Accion, '')		= 'Informar'
SELECT @TotalSumaDebe   = SUM(Cargo),
@TotalSumaHaber  = SUM(Abono),
@TotalSumaSaldo  = SUM(Saldo),
@TotalSumaSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Accion, '')		= 'Sumar'
SELECT @TotalRestaDebe   = SUM(Cargo),
@TotalRestaHaber  = SUM(Abono),
@TotalRestaSaldo  = SUM(Saldo),
@TotalRestaSaldoI = SUM(SaldoI)
FROM CorteDConsulta
WHERE ID		= @ID
AND ISNULL(Accion, '')		= 'Restar'
INSERT INTO #CorteDReporte(
ID,														Tipo,													Columna1,
Columna2,												Columna3,												Columna4,
Columna5,												Columna6,												Columna7,
Columna8,												Columna9,												Columna10,
Columna11,												Columna12,												Columna13,
Columna14,												Agrupador1)
SELECT @ID,													'TOT',													CASE @TipoCambio WHEN 1.0 THEN 'Gran Total' + ' (' + @Moneda + ')' ELSE 'Gran Total' + ' (' + @Moneda + ' - ' + RTRIM(dbo.fnMonetarioEnTexto(@TipoCambio)) + ')' END,
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalInfDebe), '$'),		NULLIF(dbo.fnMonetarioEnTexto(@TotalInfHaber), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalInfSaldo), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldoI), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaDebe), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalSumaSaldo), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldoI), '$'),
NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaDebe), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaHaber), '$'),	NULLIF(dbo.fnMonetarioEnTexto(@TotalRestaSaldo), '$'),
NULLIF(dbo.fnMonetarioEnTexto(ISNULL(@TotalSumaSaldo, 0)-ISNULL(@TotalRestaSaldo, 0)), '$'), @AgrupadorAux
RETURN
END

