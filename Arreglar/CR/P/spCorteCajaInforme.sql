SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteCajaInforme (@Estacion int)

AS BEGIN
DECLARE
@FormaPago				varchar(50),
@Importe				money,
@Caja					varchar(20),
@Cajero					varchar(20),
@Fecha					datetime,
@GraficaDescripcion		varchar(50),
@Columna1				money,
@Columna2				money,
@Columna3				money,
@Columna4				money,
@Columna5				money,
@Columna6				money,
@Columna7				money,
@Etiqueta				bit,
@GraficarTipo			varchar(30),
@Graficar				int,
@GraficarCantidad		int,
@CajeroNombre			varchar(100),
@CajaNombre				varchar(100),
@FechaSinHora			varchar(20),
@Empresa				varchar(5),
@EmpresaNombre			varchar(100),
@Moneda					varchar(20),
@ImporteMC				money,
@ContMoneda				varchar(20),
@TipoCambio				varchar(20),
@FormaPago2				varchar(50),
@TipoCambio2			varchar(20),
@Corte					varchar(50),
@IDCorte				int,
@VerGraficaDetalle		bit
SELECT @Caja = InfoCaja,
@Cajero = NULLIF(NULLIF(InfoCajero, '(Todos)'), ''),
@Fecha = dbo.fnFechaSinHora(InfoFechaDia),
@Corte = NULLIF(NULLIF(InfoCorte, '(Todos)'), ''),
@GraficarTipo = ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta = ISNULL(InfoEtiqueta, 0),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@Empresa = InfoEmpresa,
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @Estacion
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
IF @Corte IS NOT NULL
SELECT @IDCorte = ID FROM Dinero WHERE Mov + ' ' + MovID = @Corte
DECLARE @TablaFormaPago TABLE
(
Estacion	int		NOT NULL,
Mov			varchar(20) NULL,
Clave		varchar(20) NULL,
SubClave	varchar(20) NULL,
FormaPago	varchar(50) NULL,
Importe		money		NULL,
Moneda		varchar(20) NULL,
TipoCambio	varchar(20) NULL,
ImporteMC	money		NULL
)
DECLARE @Tabla TABLE
(
ID					int		IDENTITY,
Estacion			int		 NOT NULL,
TituloColumna1		varchar(100) NULL,
TituloColumna2		varchar(100) NULL,
TituloColumna3		varchar(100) NULL,
TituloColumna4		varchar(100) NULL,
TituloColumna5		varchar(100) NULL,
TituloColumna6		varchar(100) NULL,
TituloColumna7		varchar(100) NULL,
TituloColumna8		varchar(100) NULL,
TituloColumna9		varchar(100) NULL,
TituloColumna10		varchar(100) NULL,
TituloColumna11		varchar(100) NULL,
Columna1			varchar(100) NULL,
Columna2			varchar(100) NULL,
Columna3			varchar(100) NULL,
Columna4			varchar(100) NULL,
Columna5			varchar(100) NULL,
Columna6			varchar(100) NULL,
Columna7			varchar(100) NULL,
Columna8			varchar(100) NULL,
Columna9			varchar(100) NULL,
Columna10			varchar(100) NULL,
Columna11			varchar(100) NULL,
Tipo				int		 NOT NULL,
Grafica				bit		DEFAULT 0,
GraficaSerie		varchar(50)	 NULL,
GraficaDescripcion	varchar(50)  NULL,
GraficaImporte		money		 NULL,
Titulo1				varchar(100) NULL,
Titulo2				varchar(100) NULL,
Titulo3				varchar(100) NULL,
Titulo4				varchar(100) NULL,
Titulo5				varchar(100) NULL,
Titulo6				varchar(100) NULL,
Titulo7				varchar(100) NULL,
Moneda				varchar(20)	 NULL,
MonedaMC			varchar(20)	 NULL,
TipoCambio			varchar(20)	 NULL,
TipoCambio2			varchar(20)	 NULL,
Orden				int DEFAULT 0,
Columna2MC			varchar(100) NULL,
Columna3MC			varchar(100) NULL,
Columna4MC			varchar(100) NULL,
Columna5MC			varchar(100) NULL,
Columna6MC			varchar(100) NULL,
Columna7MC			varchar(100) NULL,
Columna8MC			varchar(100) NULL,
Columna9MC			varchar(100) NULL,
Columna10MC			varchar(100) NULL,
Columna11MC			varchar(100) NULL
)
INSERT @TablaFormaPago
SELECT
@Estacion Estacion,
d.Mov,
m.Clave,
ISNULL(m.SubClave, ''),
CASE d.ConDesglose WHEN 0 THEN ISNULL(d.FormaPago, '') ELSE ISNULL(dd.FormaPago, '') END FormaPago,
CASE d.ConDesglose WHEN 0 THEN SUM(d.Importe) ELSE SUM(dd.Importe) END Importe,
d.Moneda,
CONVERT(money,d.TipoCambio),
CASE d.ConDesglose WHEN 0 THEN SUM(d.Importe*d.TipoCambio) ELSE SUM(dd.Importe*d.TipoCambio) END Importe
FROM Dinero d
LEFT OUTER JOIN DineroD dd ON d.ID = dd.ID
JOIN MovTipo m ON d.Mov = m.Mov AND m.Modulo = 'DIN'
WHERE d.Estatus = 'CONCLUIDO'
AND (d.Corte > 0 OR d.CorteDestino > 0)
AND m.Clave IN('DIN.A', 'DIN.AP', 'DIN.C', 'DIN.CP', 'DIN.F', 'DIN.I', 'DIN.E', 'DIN.TC')
AND CASE WHEN m.Clave IN('DIN.A','DIN.C', 'DIN.CP') THEN CASE WHEN m.SubClave IS NOT NULL THEN 1 ELSE 0 END ELSE 0 END = 0
AND dbo.fnFechaSinHora(d.FechaRegistro) = @Fecha
AND CASE m.Clave WHEN 'DIN.A' THEN d.CtaDineroDestino WHEN 'DIN.AP' THEN d.CtaDineroDestino WHEN 'DIN.TC' THEN @Caja ELSE d.CtaDinero END = @Caja
AND ISNULL(d.Cajero,'') = ISNULL(@Cajero, ISNULL(d.Cajero,''))
AND ISNULL(d.Corte,ISNULL(@IDCorte,0)) = ISNULL(@IDCorte, ISNULL(d.Corte,0))
GROUP BY d.Mov, m.Clave, m.SubClave, d.ConDesglose, CASE d.ConDesglose WHEN 0 THEN ISNULL(d.FormaPago, '') ELSE ISNULL(dd.FormaPago, '') END, d.Moneda, d.TipoCambio, d.Corte
INSERT @Tabla(Estacion, Columna1, Columna2, Columna3, Columna4, Columna5, Columna6, Columna7, Columna8, Columna9, Columna10, Tipo, Moneda, TipoCambio, Columna4MC, Columna5MC)
SELECT		@Estacion,
RTRIM(ISNULL(d.Origen, '')) + ' ' + RTRIM(ISNULL(d.OrigenID, '')),
RTRIM(ISNULL(d.Mov, '')) + ' ' + RTRIM(ISNULL(d.MovID, '')),
CONVERT(varchar,d.FechaRegistro, 120),
CASE m.Clave
WHEN 'DIN.A'	 THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
WHEN 'DIN.AP'  THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
WHEN 'DIN.I'   THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
WHEN 'DIN.TC'  THEN CASE WHEN d.ConDesglose = 0 THEN CASE WHEN d.CtaDineroDestino = @Caja THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END END
ELSE NULL	 END Abono,
CASE m.Clave
WHEN 'DIN.CP'	 THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
WHEN 'DIN.C'   THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
WHEN 'DIN.F'   THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
WHEN 'DIN.TC'  THEN CASE WHEN d.ConDesglose = 0 THEN CASE WHEN d.CtaDinero = @Caja THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END END
WHEN 'DIN.E'  THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe),1) END
ELSE NULL
END Cargo,
d.Referencia,
CASE m.Clave
WHEN 'DIN.A'	 THEN d.CtaDineroDestino
WHEN 'DIN.AP'  THEN d.CtaDineroDestino
ELSE d.CtaDinero
END Caja,
CASE m.Clave
WHEN 'DIN.A'	 THEN c.Descripcion
WHEN 'DIN.AP'  THEN c.Descripcion
ELSE cd.Descripcion
END CajaNombre,
m.Clave,
'',
2,
d.Moneda,
CONVERT(money,d.TipoCambio),
CASE m.Clave
WHEN 'DIN.A'	 THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
WHEN 'DIN.AP'  THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
WHEN 'DIN.I'   THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
ELSE NULL	 END AbonoMC,
CASE m.Clave
WHEN 'DIN.CP'	 THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
WHEN 'DIN.C'   THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
WHEN 'DIN.F'   THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
WHEN 'DIN.TC'  THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
WHEN 'DIN.E'  THEN CASE WHEN d.ConDesglose = 0 THEN CONVERT(varchar,CONVERT(money,d.Importe*d.TipoCambio),1) ELSE CONVERT(varchar,CONVERT(money,dd.Importe*d.TipoCambio),1) END
ELSE NULL
END CargoMC
FROM Dinero d
LEFT OUTER JOIN DineroD dd ON d.ID = dd.ID
JOIN MovTipo m ON d.Mov = m.Mov AND m.Modulo = 'DIN'
LEFT OUTER JOIN Agente a ON d.Cajero = a.Agente
LEFT OUTER JOIN CtaDinero c ON d.CtaDineroDestino = c.CtaDinero
LEFT OUTER JOIN CtaDinero cd ON d.CtaDinero = cd.CtaDinero
WHERE d.Estatus = 'CONCLUIDO'
AND (d.Corte > 0 OR d.CorteDestino > 0)
AND m.Clave IN('DIN.A', 'DIN.AP', 'DIN.C', 'DIN.CP', 'DIN.F', 'DIN.I', 'DIN.E', 'DIN.TC')
AND CASE WHEN m.Clave IN('DIN.A','DIN.C', 'DIN.CP') THEN CASE WHEN m.SubClave IS NOT NULL THEN 1 ELSE 0 END ELSE 0 END = 0
AND dbo.fnFechaSinHora(d.FechaRegistro) = @Fecha
AND CASE m.Clave WHEN 'DIN.A' THEN d.CtaDineroDestino WHEN 'DIN.AP' THEN d.CtaDineroDestino WHEN 'DIN.TC' THEN @Caja ELSE d.CtaDinero END = @Caja
AND ISNULL(d.Cajero,'') = ISNULL(@Cajero, ISNULL(d.Cajero,''))
AND ISNULL(d.Corte,ISNULL(@IDCorte,0)) = ISNULL(@IDCorte, ISNULL(d.Corte,0))
DECLARE crMoneda CURSOR FOR
SELECT DISTINCT Moneda, TipoCambio
FROM @Tabla
WHERE Moneda IS NOT NULL
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @Moneda, @TipoCambio
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @TipoCambio2 = @TipoCambio
IF @TipoCambio NOT IN('1', '1.00')
SELECT @TipoCambio = ' - T/C ' + @TipoCambio
ELSE
SELECT @TipoCambio = ''
INSERT @Tabla(Estacion, TituloColumna1, TituloColumna2, TituloColumna3, TituloColumna4, TituloColumna5, TituloColumna6, TituloColumna7, TituloColumna8, TituloColumna9, TituloColumna10, TituloColumna11,  Tipo, Moneda)
SELECT		@Estacion, 'Origen', 'Movimiento', 'Fecha Registro', 'Ingresos', 'Egresos', 'Referencia', '', '', 'Clave', 'Corte al Día', 'Detalle de movimientos', 1, NULL
INSERT @Tabla(Estacion, TituloColumna1, TituloColumna2,     TituloColumna3, TituloColumna4, TituloColumna5,  TituloColumna6, TituloColumna7, TituloColumna8, TituloColumna9, TituloColumna10, TituloColumna11,             Tipo, Moneda)
SELECT		@Estacion, 'Forma de Pago', 'Apertura/Aumento', 'Ingreso',      'Egreso',       'Corte Parcial', 'Corte',        'Faltante',     'Sobrante',     'Caja',         'Clave',         'Detalle por forma de pago', 3,    NULL
INSERT @Tabla(Estacion, Columna1,	             Tipo, Moneda,                            TipoCambio,  TipoCambio2,  Orden)
SELECT		 @Estacion, @TipoCambio,             4,   @Moneda,                            @TipoCambio, @TipoCambio2, 1
UNION
SELECT		 @Estacion, FormaPago + @TipoCambio, 4,   ISNULL(NULLIF(Moneda,''), @Moneda), @TipoCambio, @TipoCambio2, 1
FROM FormaPago
WHERE ISNULL(NULLIF(Moneda,''), @Moneda) = @Moneda
FETCH NEXT FROM crMoneda INTO @Moneda, @TipoCambio
END
CLOSE crMoneda
DEALLOCATE crMoneda
DECLARE crFormaPago CURSOR FOR
SELECT Columna1, Moneda, TipoCambio, TipoCambio2
FROM @Tabla
WHERE Tipo = 4
GROUP BY Columna1, Moneda, TipoCambio, TipoCambio2
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Moneda, @TipoCambio, @TipoCambio2
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @FormaPago2 = @FormaPago
IF @TipoCambio NOT IN('1', '1.00', '')
SELECT @FormaPago = REPLACE(@FormaPago, @TipoCambio, '')
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe = SUM(Importe),
@ImporteMC = SUM(ImporteMC)
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave IN ('DIN.A', 'DIN.AP')
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF @Importe IS NOT NULL
UPDATE @Tabla
SET Columna2 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna2MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe= SUM(ISNULL(Importe, 0.00)),
@ImporteMC = SUM(ISNULL(ImporteMC, 0.00))
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave ='DIN.I'
AND SubClave <> 'DIN.S'
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF NULLIF(@Importe, 0.00) IS NOT NULL
UPDATE @Tabla
SET Columna3 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna3MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe= SUM(ISNULL(Importe, 0.00)),
@ImporteMC = SUM(ISNULL(ImporteMC, 0.00))
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave IN ('DIN.E', 'DIN.TC')
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF @Importe IS NOT NULL
UPDATE @Tabla
SET Columna4 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna4MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe = SUM(Importe),
@ImporteMC = SUM(ImporteMC)
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave IN ('DIN.CP')
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF @Importe IS NOT NULL
UPDATE @Tabla
SET Columna5 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna5MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe = SUM(Importe),
@ImporteMC = SUM(ImporteMC)
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave IN ('DIN.C')
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF @Importe IS NOT NULL
UPDATE @Tabla
SET Columna6 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna6MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe = SUM(Importe),
@ImporteMC = SUM(ImporteMC)
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave IN ('DIN.F')
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF @Importe IS NOT NULL
UPDATE @Tabla
SET Columna7 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna7MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
SELECT @Importe = NULL, @ImporteMC = NULL
SELECT @Importe = SUM(Importe),
@ImporteMC = SUM(ImporteMC)
FROM @TablaFormaPago
WHERE Estacion = @Estacion
AND Clave = 'DIN.I'
AND SubClave = 'DIN.S'
AND FormaPago = @FormaPago
AND Moneda = @Moneda
AND TipoCambio = @TipoCambio2
GROUP BY FormaPago
IF @Importe IS NOT NULL
UPDATE @Tabla
SET Columna8 = CONVERT(varchar,CONVERT(money,ISNULL(@Importe, 0.00)),1),
Columna8MC = CONVERT(varchar,CONVERT(money,ISNULL(@ImporteMC, 0.00)),1)
WHERE Tipo = 4
AND Columna1 = @FormaPago2
AND Moneda = @Moneda
AND TipoCambio2 = @TipoCambio2
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Moneda, @TipoCambio, @TipoCambio2
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
UPDATE @Tabla
SET Columna11 = CONVERT(varchar,CONVERT(money,ISNULL(ISNULL(CONVERT(money,Columna2),0.0) + ISNULL(CONVERT(money,Columna3),0.0) - ISNULL(CONVERT(money,Columna4),0.0), 0.00)),1),
Columna11MC = CONVERT(varchar,CONVERT(money,ISNULL(ISNULL(CONVERT(money,Columna2MC),0.0) + ISNULL(CONVERT(money,Columna3MC),0.0) - ISNULL(CONVERT(money,Columna4MC),0.0), 0.00)),1)
WHERE Tipo = 4
DELETE @Tabla
WHERE Tipo = 4
AND(Columna1 IS NOT NULL AND Columna2 IS NULL AND Columna3 IS NULL AND Columna4 IS NULL AND Columna5 IS NULL
AND Columna6 IS NULL AND Columna7 IS NULL AND  Columna8 IS NULL AND  Columna9 IS NULL AND  Columna10 IS NULL)
INSERT @Tabla(Estacion, Columna1, Columna2, Columna3, Columna4, Columna5, Columna6, Columna7, Columna8, Columna9, Columna10, Tipo, Moneda)
SELECT
@Estacion,
'Total',
CONVERT(varchar,SUM(CONVERT(money,Columna2)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna3)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna4)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna5)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna6)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna7)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna8)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna9)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna10)),1),
6,
@Moneda
FROM @Tabla
WHERE Tipo = 4
INSERT @Tabla(Estacion, Columna1, Columna2MC, Columna3MC, Columna4MC, Columna5MC, Columna6MC, Columna7MC, Columna8MC, Columna9MC, Columna10MC, Tipo, Moneda, MonedaMC, Orden)
SELECT
@Estacion,
'Gran Total ' + @ContMoneda,
CONVERT(varchar,SUM(CONVERT(money,Columna2MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna3MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna4MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna5MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna6MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna7MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna8MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna9MC)),1),
CONVERT(varchar,SUM(CONVERT(money,Columna10MC)),1),
7,
'ZZZZZ',
@ContMoneda,
2
FROM @Tabla
WHERE Tipo = 4
DECLARE crGrafica CURSOR FOR
SELECT Columna1
FROM @Tabla
WHERE Tipo = 4
OPEN crGrafica
FETCH NEXT FROM crGrafica INTO @GraficaDescripcion
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Columna2 = Columna2MC, @Columna3 = Columna3MC, @Columna4 = Columna4MC, @Columna5 = Columna5MC, @Columna6 = Columna6MC, @Columna7 = Columna7MC
FROM @Tabla
WHERE Tipo = 4
AND Columna1 = @GraficaDescripcion
IF @Columna2 IS NOT NULL
INSERT @Tabla(Estacion, Tipo, Grafica, GraficaDescripcion,  GraficaSerie, GraficaImporte)
SELECT		@Estacion, 6,   1,       @GraficaDescripcion, 'Apertura',   @Columna2
IF @Columna3 IS NOT NULL
INSERT @Tabla(Estacion, Tipo, Grafica, GraficaDescripcion,  GraficaSerie, GraficaImporte)
SELECT		@Estacion, 6,   1,       @GraficaDescripcion, 'Ingreso',    @Columna3
IF @Columna4 IS NOT NULL
INSERT @Tabla(Estacion, Tipo, Grafica, GraficaDescripcion,  GraficaSerie,    GraficaImporte)
SELECT		@Estacion, 6,   1,       @GraficaDescripcion, 'Corte Parcial', @Columna4
IF @Columna5 IS NOT NULL
INSERT @Tabla(Estacion, Tipo, Grafica, GraficaDescripcion,  GraficaSerie, GraficaImporte)
SELECT		@Estacion, 6,   1,       @GraficaDescripcion, 'Corte',      @Columna5
IF @Columna6 IS NOT NULL
INSERT @Tabla(Estacion, Tipo, Grafica, GraficaDescripcion,  GraficaSerie, GraficaImporte)
SELECT		@Estacion, 6,   1,       @GraficaDescripcion, 'Faltante',   @Columna6
IF @Columna7 IS NOT NULL
INSERT @Tabla(Estacion, Tipo, Grafica, GraficaDescripcion,  GraficaSerie, GraficaImporte)
SELECT		@Estacion, 6,   1,       @GraficaDescripcion, 'Sobrante',   @Columna7
FETCH NEXT FROM crGrafica INTO @GraficaDescripcion
END
CLOSE crGrafica
DEALLOCATE crGrafica
SELECT @Graficar = COUNT(DISTINCT GraficaDescripcion)
FROM @Tabla
WHERE Estacion = @Estacion
AND Grafica = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @Tabla
WHERE Grafica = 1
AND GraficaDescripcion NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaDescripcion
FROM(SELECT 'GraficaDescripcion'  = GraficaDescripcion, 'GraficaImporte'      = SUM(GraficaImporte)
FROM @Tabla
WHERE Estacion = @Estacion AND Grafica = 1
GROUP BY GraficaDescripcion) AS x
GROUP BY x.GraficaDescripcion
ORDER BY SUM(ISNULL(x.GraficaImporte,0.00))DESC)
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @Tabla
WHERE Grafica = 1
AND GraficaDescripcion NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaDescripcion
FROM(SELECT 'GraficaDescripcion'  = GraficaDescripcion, 'GraficaImporte'      = SUM(GraficaImporte)
FROM @Tabla
WHERE Estacion = @Estacion AND Grafica = 1
GROUP BY GraficaDescripcion) AS x
GROUP BY x.GraficaDescripcion
ORDER BY SUM(ISNULL(x.GraficaImporte,0.00))ASC)
SELECT @CajeroNombre = Nombre FROM Agente WHERE Agente = @Cajero
SELECT @CajaNombre = MIN(Columna8) FROM @Tabla WHERE Tipo = 2
SELECT @FechaSinHora = SUBSTRING(CONVERT(varchar, @Fecha, 6),1,12)
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
UPDATE @Tabla
SET Columna7 = '',
Columna8 = ''
FROM @Tabla
WHERE Tipo = 2
UPDATE @Tabla
SET MonedaMC = '1'
WHERE Moneda = (SELECT TOP 1 Moneda FROM @Tabla WHERE Moneda <> 'ZZZZZ' GROUP BY Moneda ORDER BY Moneda DESC)
UPDATE @Tabla
SET Titulo1 = @Caja,
Titulo2 = ISNULL(@Cajero, '(Todos)'),
Titulo3 = @CajaNombre,
Titulo4 = @CajeroNombre,
Titulo5 = @FechaSinHora,
Titulo7 = @EmpresaNombre
UPDATE @Tabla
SET TituloColumna1 = 'Origen',
TituloColumna2 = 'Movimiento',
TituloColumna3 = 'Fecha Registro',
TituloColumna4 = 'Ingresos',
TituloColumna5 = 'Egresos',
TituloColumna6 = 'Referencia',
TituloColumna7 = '',
TituloColumna8 = '',
TituloColumna9 = 'Clave',
TituloColumna10 = 'Corte al Día',
TituloColumna11 = 'Detalle de movimientos'
WHERE Tipo = 2
UPDATE @Tabla
SET TituloColumna1 = 'Forma de Pago',
TituloColumna2 = 'Apertura/Aumento',
TituloColumna3 = 'Ingreso',
TituloColumna4 = 'Egreso',
TituloColumna5 = 'Corte Parcial',
TituloColumna6 = 'Corte',
TituloColumna7 = 'Faltante',
TituloColumna8 = 'Sobrante',
TituloColumna9 = 'Caja',
TituloColumna10 = 'Clave',
TituloColumna11 = 'Detalle por forma de pago'
WHERE Tipo = 4
SELECT *, @VerGraficaDetalle as VerGraficaDetalle FROM @Tabla ORDER BY Grafica, Tipo, Moneda
END

