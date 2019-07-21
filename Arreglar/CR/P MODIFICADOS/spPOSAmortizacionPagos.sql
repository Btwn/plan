SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAmortizacionPagos
@ID				varchar(36),
@Condicion		varchar(50),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@Refrescar		bit = 0
 
AS
BEGIN
DECLARE
@AnticipadoNumero		int,
@AnticipadoPeriodo		varchar(15),
@Tasa					varchar(50),
@Dias					int,
@Porcentaje				float,
@PorcentajePeriodo		float,
@Estatus				varchar(15),
@MovClave				varchar(20),
@Mov					varchar(20),
@ImporteTotal			float,
@FechaEmision			datetime,
@FechaAmortizada		datetime,
@ImporteAmortizado		float,
@NumeroAmortizacion		int,
@DiasAmortizacion		int,
@RedondeoMonetarios		int,
@Empresa                varchar(5),
@ControlAnticipos       varchar(20)
SELECT
@Estatus = ISNULL(pl.Estatus, 'SINAFECTAR'),
@MovClave = mt.Clave,
@Mov = pl.Mov,
@FechaEmision = pl.FechaEmision,
@Empresa = pl.Empresa
FROM POSL pl WITH (NOLOCK)
INNER JOIN MovTipo mt WITH (NOLOCK) ON pl.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE pl.ID = @ID
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
IF @Condicion IS NULL AND @Refrescar = 1
SELECT @Condicion = pl.Condicion
FROM POSL pl WITH (NOLOCK)
WHERE pl.ID = @ID
IF NULLIF(@Condicion,'') IS NOT NULL
BEGIN
IF (UPPER(@Condicion) NOT IN(SELECT UPPER(Condicion) FROM POSMovCondicion c WITH (NOLOCK) WHERE c.Mov = @Mov) AND @Ok IS NULL)
BEGIN
SELECT @ok = 20700, @OkRef = @Condicion
END
SELECT
@AnticipadoNumero = c.AnticipadoNumero,
@AnticipadoPeriodo = c.AnticipadoPeriodo,
@Tasa = c.Tasa,
@ControlAnticipos = ControlAnticipos
FROM Condicion c WITH (NOLOCK)
WHERE c.Condicion = @Condicion
IF @ControlAnticipos = 'Plazos'
BEGIN
IF (NULLIF(@AnticipadoNumero,0) IS NULL OR NULLIF(@AnticipadoPeriodo,'') IS NULL) AND @Ok IS NULL AND @Condicion IS NOT NULL
SELECT @ok = 20700, @OkRef = @Condicion
END
END
IF @Tasa IS NOT NULL
BEGIN
IF (SELECT Tasa FROM POSL pl WITH (NOLOCK) WHERE pl.ID = @ID) IS NOT NULL
SELECT @Tasa = p.Tasa
FROM POSL p WITH (NOLOCK)
WHERE p.ID = @ID
SELECT
@Dias = t.Dias,
@Porcentaje = t.Porcentaje
FROM Tasa t WITH (NOLOCK)
WHERE t.Tasa = @Tasa
END
IF ISNULL(@Estatus, '') <> 'SINAFECTAR' AND @Ok IS NULL AND @Condicion IS NOT NULL AND @Refrescar = 0
SELECT @Ok = 10015, @OkRef = 'El movimiento no puede estar afectado'
IF ISNULL((SELECT SUM(Importe) FROM POSLCobro plc WITH (NOLOCK) WHERE plc.ID = @ID),0) <> 0 AND @Ok IS NULL AND @Condicion IS NOT NULL AND @Refrescar = 0
SELECT @Ok = 20180, @OkRef = 'El movimiento no puede tener cobros aplicados'
IF @Ok IS NULL AND @Condicion IS NOT NULL
BEGIN
UPDATE POSL WITH (ROWLOCK)
SET Condicion = @Condicion, Tasa = @Tasa
WHERE ID = @ID
DELETE POSLAmortizacionPagos
WHERE ID = @ID
SELECT @ImporteTotal = SUM(((plv.Cantidad - ISNULL(plv.CantidadObsequio,0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100)) * (1 + ((ISNULL(plv.Impuesto1,0)/100)+(ISNULL(plv.Impuesto2,0)/100))))   )
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
SELECT @DiasAmortizacion =
CASE @AnticipadoPeriodo
WHEN 'Semanal' THEN 7
WHEN 'Quincenal' THEN 15
WHEN 'Mensual' THEN 30
WHEN 'Bimestral' THEN 60
WHEN 'Trimestral' THEN 90
WHEN 'Semestral' THEN 180
WHEN 'Anual' THEN 365
ELSE 1
END
SELECT @NumeroAmortizacion = 1,
@FechaAmortizada = @FechaEmision + @DiasAmortizacion,
@ImporteAmortizado = @ImporteTotal / @AnticipadoNumero
SELECT @ImporteAmortizado = ROUND(@ImporteAmortizado,@RedondeoMonetarios)
IF @Porcentaje IS NOT NULL AND @Dias IS NOT NULL
SELECT @PorcentajePeriodo = (@Porcentaje / @Dias) * @DiasAmortizacion
WHILE @NumeroAmortizacion <= @AnticipadoNumero
BEGIN
INSERT POSLAmortizacionPagos (
ID, Fecha, Importe,	Interes)
VALUES (
@ID, @FechaAmortizada, @ImporteAmortizado, @PorcentajePeriodo)
SELECT @FechaAmortizada = @FechaAmortizada + @DiasAmortizacion
SELECT @NumeroAmortizacion = @NumeroAmortizacion + 1
END
END
END

