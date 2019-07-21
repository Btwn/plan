SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCalculaImporte2
@RedondeoMonetarios	int,
@Importe		float	OUTPUT,
@ImporteNeto		float	OUTPUT,
@DescuentoLineaImporte	float	OUTPUT,
@DescuentoGlobalImporte float	OUTPUT,
@SobrePrecioImporte	float	OUTPUT,
@Impuestos		float	OUTPUT,
@ImpuestosNetos		float	OUTPUT,
@Impuesto1Neto		float	OUTPUT,
@Impuesto2Neto		float	OUTPUT,
@Impuesto3Neto		float	OUTPUT,
@Impuesto5Neto		float	OUTPUT
AS BEGIN
RETURN
END

