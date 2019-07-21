SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCObtenerDatosTransaccion
@Modulo			varchar(5),
@ModuloID		int,
@FormaPago		varchar(50),
@Importe		float,
@Accion			varchar(20),
@CancelaRID		int,
@Sucursal		int,
@Estacion		int,
@Campo			varchar(50),
@Referencia		varchar(50),
@XMLTransaccion	varchar(max)	OUTPUT

AS
BEGIN
DECLARE @TCTipoPlan		varchar(2),
@TCNoMeses		int,
@TCDiferirMeses	int,
@OrderID			varchar(255)
IF @Accion = 'VOID'
BEGIN
SELECT @TCTipoPlan		= CASE TCTipoPlan
WHEN 'Normal'			   THEN ''
WHEN 'Con Intereses'	   THEN '05'
WHEN 'Diferimiento Inicial'THEN '07'
WHEN 'Sin Intereses'	   THEN '03'
END,
@TCNoMeses	    = TCNoMeses,
@TCDiferirMeses	= TCDiferirMeses,
@OrderID			= IDOrden
FROM TCTransaccion
WHERE RID = @CancelaRID
END
ELSE
BEGIN
SELECT @TCTipoPlan		= CASE TCTipoPlan
WHEN 'Normal'			   THEN ''
WHEN 'Con Intereses'	   THEN '05'
WHEN 'Diferimiento Inicial'THEN '07'
WHEN 'Sin Intereses'	   THEN '03'
END,
@TCNoMeses	    = CASE TCTipoPlan
WHEN 'Normal'				THEN 0
WHEN 'Diferimiento Inicial' THEN 0
WHEN 'Con Intereses'		THEN ISNULL(TCNoMeses, 0)
WHEN 'Sin Intereses'		THEN ISNULL(TCNoMeses, 0)
END,
@TCDiferirMeses	= CASE TCTipoPlan
WHEN 'Normal'				THEN 0
WHEN 'Diferimiento Inicial' THEN ISNULL(TCDiferirMeses, 0)
WHEN 'Con Intereses'		THEN 0
WHEN 'Sin Intereses'		THEN 0
END,
@OrderID			= NULL
FROM FormaPago
WHERE FormaPago = @FormaPago
IF @Accion = 'Credit'
SELECT @OrderID = @Referencia
END
IF @Modulo = 'VTAS'
SELECT @XMLTransaccion = (SELECT MonCodigoInternacional.CodigoNumerico 'Moneda',
@TCTipoPlan 'TipoPlan',
@TCNoMeses 'NoMeses',
@TCDiferirMeses 'DiferirMeses',
@Modulo 'Modulo',
@ModuloID 'ModuloID',
@FormaPago 'FormaPago',
@Importe 'Importe',
@Accion 'Accion',
@CancelaRID 'CancelaRID',
@OrderID 'OrderID',
@Sucursal 'Sucursal',
@Estacion'Estacion',
@Campo 'Campo'
FROM Venta
JOIN Mon ON Venta.Moneda = Mon.Moneda
LEFT OUTER JOIN MonCodigoInternacional ON Mon.Moneda = MonCodigoInternacional.Moneda
WHERE ID = @ModuloID
FOR XML RAW('Transaccion')
)
END

