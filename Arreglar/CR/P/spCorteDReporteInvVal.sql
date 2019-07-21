SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDReporteInvVal
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
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @CuentaAux		varchar(10),
@CuentaAuxAnt		varchar(10),
@FechaA			datetime
SELECT @FechaA = GETDATE()
SELECT @CuentaAux = MIN(Cuenta)
FROM CorteD
WHERE ID	= @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Agrupador1)
SELECT @ID,	'TIT',	@CorteTitulo,	@CuentaAux
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,			Columna3,			Columna4,			Agrupador1)
SELECT @ID,	'ENC1',	'Referencia:',	Referencia,			'Tipo:',			CorteTipo,			@CuentaAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,			Columna3,			Columna4,			Agrupador1)
SELECT @ID,	'ENC2',	'Concepto:',	Concepto,			'Grupo:',			CorteGrupo,			@CuentaAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		 Columna2,			Columna3,			Columna4,			Agrupador1)
SELECT @ID,	'ENC3',	'Observaciones:',Observaciones,		'Frecuencia:',		CorteFrecuencia,	@CuentaAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,			Agrupador1)
SELECT @ID,	'ENC4',	'Origen:',		CorteOrigen,		@CuentaAux
FROM Corte
WHERE ID = @ID
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Agrupador1)
SELECT @ID,	'ENC5', Empresa.Nombre,	@CuentaAux
FROM Empresa
WHERE Empresa = @Empresa
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'ENC6', Direccion2, @CuentaAux FROM #ContactoDireccion
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'ENC7', Direccion3, @CuentaAux FROM #ContactoDireccion
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'ENC8', Direccion4, @CuentaAux FROM #ContactoDireccion
INSERT INTO #CorteDReporte(
ID,												Tipo,		Columna1,		Columna2,
Columna3,										Agrupador1)
SELECT @ID,											'ENC9',		@CorteTitulo,	'',
dbo.fnFormatearFecha(@FechaA, 'dd/MM/aaaa'),	@CuentaAux
FROM #ContactoDireccion
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,		Columna2,
Agrupador1)
SELECT @ID,	'ENC10', 'A la Fecha',	dbo.fnFormatearFecha(@CorteFechaA, 'dd/MM/aaaa'),
@CuentaAux
INSERT INTO #CorteDReporte(
ID,		Tipo,		Columna1,		Columna2,		Columna3,		Columna4,											 Columna5,
Agrupador1)
SELECT @ID,		'NOM1',		'Artículo',		'Descripción',	'Existencias',	ISNULL(NULLIF(@CorteValuacion, '(Sin Valuar)'), ''), CASE @CorteValuacion WHEN '(Sin Valuar)' THEN '' ELSE 'Total' END,
@CuentaAux
SELECT @CuentaAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @CuentaAux =  MIN(Cuenta)
FROM CorteD
WHERE ID = @ID
AND Cuenta > @CuentaAuxAnt
IF @CuentaAux IS NULL BREAK
SELECT @CuentaAuxAnt = @CuentaAux
INSERT INTO #CorteDReporte(
ID,		Tipo,		Columna1,		Columna2,		Agrupador1)
SELECT @ID,		'NOM2',		@CuentaAux,		Descripcion1,	@CuentaAux
FROM Art WHERE Articulo = @CuentaAux
INSERT INTO #CorteDReporte(
ID,																														Tipo,
Columna1,																												Columna2,
Columna3,																												Columna4,
Columna5,																												Agrupador1)
SELECT @ID,																														'DET',
Almacen,																													Nombre,
CONVERT(varchar, CONVERT(money, SaldoU), 1),																				CASE @CorteValuacion WHEN '(Sin Valuar)' THEN NULL ELSE dbo.fnMonetarioEnTexto(ISNULL(ValuacionValor, 0)) END,
CASE @CorteValuacion WHEN '(Sin Valuar)' THEN NULL ELSE dbo.fnMonetarioEnTexto(ISNULL(ValuacionValor * SaldoU, 0)) END,	@CuentaAux
FROM CorteD
JOIN Alm ON CorteD.Grupo = Alm.Almacen
WHERE ID			 = @ID
AND CorteD.Cuenta = @CuentaAux
ORDER BY Alm.Almacen
INSERT INTO #CorteDReporte(
ID,																														Tipo,
Columna1,																												Columna2,
Columna3,																												Columna4,
Columna5,																												Columna6,
Agrupador1)
SELECT @ID,																														'SUBT',
'Total',																													@CuentaAux,
Descripcion1,																											CONVERT(varchar, CONVERT(money, SUM(SaldoU)), 1),
CASE @CorteValuacion WHEN '(Sin Valuar)' THEN NULL ELSE dbo.fnMonetarioEnTexto(ISNULL(ValuacionValorArtConCosto, 0)) END,CASE @CorteValuacion WHEN '(Sin Valuar)' THEN NULL ELSE dbo.fnMonetarioEnTexto(ISNULL(SUM(ValuacionValor * SaldoU), 0)) END,
@CuentaAux
FROM CorteD
JOIN Art ON CorteD.Cuenta = Art.Articulo
WHERE ID			 = @ID
AND CorteD.Cuenta = @CuentaAux
GROUP BY Descripcion1, ValuacionValorArtConCosto
END
INSERT INTO #CorteDReporte(
ID,																															Tipo,
Columna1,																														Columna2,
Columna3,																														Columna4,
Agrupador1)
SELECT @ID,																															'TOT',
'Total General',																												CONVERT(varchar, CONVERT(money, SUM(SaldoU)), 1),
CASE @CorteValuacion WHEN '(Sin Valuar)' THEN NULL ELSE dbo.fnMonetarioEnTexto(ISNULL(SUM(ValuacionValor * SaldoU), 0)) END,	Moneda,
@CuentaAux
FROM CorteD
JOIN Art ON CorteD.Cuenta = Art.Articulo
WHERE ID				= @ID
GROUP BY Moneda
RETURN
END

