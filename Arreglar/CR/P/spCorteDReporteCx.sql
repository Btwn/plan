SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDReporteCx
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
DECLARE @FechaA			datetime,
@CuentaAux		varchar(10),
@CuentaAuxAnt		varchar(10),
@MonedaAux		varchar(10),
@MonedaAuxAnt		varchar(10),
@AplicaAux		varchar(20),
@AplicaAuxAnt		varchar(20),
@AplicaIDAux		varchar(20),
@AplicaIDAuxAnt	varchar(20)
SELECT @CuentaAux = MIN(Cuenta)
FROM CorteD
WHERE ID	= @ID
SELECT @FechaA = GETDATE()
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
IF @MovTipo = 'CORTE.EDOCTACXC'
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,									Columna2,		Agrupador1)
SELECT @ID,		'ENC5', 'Estado de Cuenta Simplificado - Clientes',	Empresa.Nombre,	@CuentaAux
FROM Empresa
WHERE Empresa = @Empresa
ELSE IF @MovTipo = 'CORTE.EDOCTACXP'
INSERT INTO #CorteDReporte(
ID,		Tipo,	Columna1,										Columna2,		Agrupador1)
SELECT @ID,		'ENC5', 'Estado de Cuenta Simplificado - Proveedores',	Empresa.Nombre,	@CuentaAux
FROM Empresa
WHERE Empresa = @Empresa
INSERT INTO #CorteDReporte(
ID,			Tipo,										Columna1,		Columna2,
Columna3,		Columna4,								Agrupador1)
SELECT @ID,			'ENC6',									'De la Fecha',	dbo.fnFormatearFecha(@CorteFechaD, 'dd/MM/aaaa'),
'A la Fecha',	dbo.fnFormatearFecha(@FechaA, 'dd/MM/aaaa'),@CuentaAux
SELECT @CuentaAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @CuentaAux = MIN(Cuenta)
FROM CorteD
WHERE ID		= @ID
AND Cuenta	> @CuentaAuxAnt
IF @CuentaAux IS NULL BREAK
SELECT @CuentaAuxAnt = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', @CuentaAux, @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion1, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion2, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion3, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion4, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion5, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion6, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion7, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
INSERT INTO #CorteDReporte(ID, Tipo, Columna1, Agrupador1) SELECT @ID, 'DATOS1', Direccion8, @CuentaAux FROM #ContactoDireccion WHERE Contacto = @CuentaAux
IF @MovTipo = 'CORTE.EDOCTACXC'
INSERT INTO #CorteDReporte(
ID,			Tipo,		Columna1,			Columna2,		Agrupador1)
SELECT @ID,			'DATOS2',	'Días de Crédito',	CtaCreditoDias, @CuentaAux
FROM CorteD
WHERE ID		= @ID
AND Cuenta	= @CuentaAux
GROUP BY CtaCreditoDias
INSERT INTO #CorteDReporte(
ID,		Tipo,		Columna1,				Columna2,		Agrupador1)
SELECT @ID,		'DATOS2',	'Condición de Pago',	CtaCondicion,	@CuentaAux
FROM CorteD
WHERE ID		= @ID
AND Cuenta	= @CuentaAux
GROUP BY CtaCondicion
INSERT INTO #CorteDReporte(
ID,				Tipo,		Columna1,
Columna2,		Agrupador1)
SELECT @ID,				'DATOS2',	'Límite de Crédito ' + ISNULL(CtaLimiteCreditoMoneda, ''),
CtaLimiteCredito,@CuentaAux
FROM CorteD
WHERE ID		= @ID
AND Cuenta	= @CuentaAux
GROUP BY CtaLimiteCreditoMoneda, CtaLimiteCredito
INSERT INTO #CorteDReporte(
ID,			Tipo,		Columna1,		Columna2,		Columna3,		Columna4,	Columna5,		Columna6,
Columna7,	Columna8,	Agrupador1)
SELECT @ID,			'NOM',		'Movimiento',	'Consecutivo',	'Referencia',	'Fecha',	'Vencimiento',	'Cargo',
'Abono',		'Saldo',	@CuentaAux
SELECT @MonedaAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @MonedaAux = MIN(Moneda)
FROM CorteD
WHERE ID		= @ID
AND Cuenta	= @CuentaAux
AND Moneda	> @MonedaAuxAnt
IF @MonedaAux IS NULL BREAK
SELECT @MonedaAuxAnt = @MonedaAux
SELECT @AplicaAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @AplicaAux = MIN(Aplica)
FROM CorteD
WHERE ID		= @ID
AND Cuenta	= @CuentaAux
AND Moneda	= @MonedaAux
AND Aplica	> @AplicaAuxAnt
IF @AplicaAux IS NULL BREAK
SELECT @AplicaAuxAnt = @AplicaAux
SELECT @AplicaIDAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @AplicaIDAux = MIN(AplicaID)
FROM CorteD
WHERE ID			= @ID
AND Cuenta		= @CuentaAux
AND Moneda		= @MonedaAux
AND Aplica		= @AplicaAux
AND AplicaID	> @AplicaIDAuxAnt
IF @AplicaIDAux IS NULL BREAK
SELECT @AplicaIDAuxAnt = @AplicaIDAux
INSERT INTO #CorteDReporte(
ID,									Tipo,															Columna1,											Columna2,
Columna3,								Columna4,														Columna5,											Columna6,
Columna7,								Columna8,														Agrupador1,											Agrupador2,
Agrupador3)
SELECT @ID,									'DET',															Mov,												MovID,
Referencia,							dbo.fnFormatearFecha(Fecha, 'dd/MM/aaaa'),						dbo.fnFormatearFecha(Vencimiento, 'dd/MM/aaaa'),	dbo.fnMonetarioEnTexto(ISNULL(Cargo, 0)),
dbo.fnMonetarioEnTexto(ISNULL(Abono, 0)),dbo.fnMonetarioEnTexto(ISNULL(Cargo, 0.0) - ISNULL(Abono, 0.0)),@CuentaAux,											@AplicaAux,
@AplicaIDAux
FROM CorteD
WHERE ID			= @ID
AND Cuenta		= @CuentaAux
AND Moneda		= @MonedaAux
AND Aplica		= @AplicaAux
AND AplicaID	= @AplicaIDAux
INSERT INTO #CorteDReporte(
ID,											Tipo,											Columna1,
Columna2,										Columna3,										Columna4,																Agrupador1,
Agrupador2,																						Agrupador3)
SELECT @ID,											'SUBT',											'Saldo ' + ISNULL(@AplicaAux, '') + ' ' + ISNULL(@AplicaIDAux, ''),
dbo.fnMonetarioEnTexto(SUM(ISNULL(Cargo, 0))),	dbo.fnMonetarioEnTexto(SUM(ISNULL(Abono, 0))),	dbo.fnMonetarioEnTexto(SUM(ISNULL(Cargo, 0)) - SUM(ISNULL(Abono, 0))),	@CuentaAux,
@AplicaAux,									@AplicaIDAux
FROM CorteD
WHERE ID			= @ID
AND Cuenta		= @CuentaAux
AND Moneda		= @MonedaAux
AND Aplica		= @AplicaAux
AND AplicaID		= @AplicaIDAux
END
END
INSERT INTO #CorteDReporte(
ID,											Tipo,											Columna1,
Columna2,										Columna3,										Columna4,																Agrupador1,
Agrupador2,									Agrupador3)
SELECT @ID,											'TOT',											'Total ' + ISNULL(@MonedaAux, ''),
dbo.fnMonetarioEnTexto(SUM(ISNULL(Cargo, 0))),	dbo.fnMonetarioEnTexto(SUM(ISNULL(Abono, 0))),	dbo.fnMonetarioEnTexto(SUM(ISNULL(Cargo, 0)) - SUM(ISNULL(Abono, 0))),	@CuentaAux,
@AplicaAux,				@AplicaIDAux
FROM CorteD
WHERE ID			= @ID
AND Cuenta		= @CuentaAux
AND Moneda		= @MonedaAux
END
END
RETURN
END

