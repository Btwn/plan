SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIADOParametros
@ID	                varchar(36),
@Servicio	        varchar(20),
@Empresa	        varchar(5),
@Usuario	        varchar(10),
@Sucursal	        int,
@Importe			float,
@Monedero           varchar(36),
@Referencia         varchar(255)

AS
BEGIN
DECLARE
@Comision3		float,
@FormaPago		varchar(50),
@CImporte		float
IF EXISTS (SELECT * FROM POSLDITemp WITH (NOLOCK) WHERE ID = @ID)
DELETE POSLDITemp WHERE ID = @ID
SELECT @FormaPago = POSLCobro.FormaPago
FROM POSLDIFormaPago WITH (NOLOCK) JOIN POSLCobro WITH (NOLOCK) ON POSLDIFormaPago.FormaPago = POSLCobro.FormaPago
WHERE Servicio = @Servicio
IF (SELECT Comision3 FROM FormaPago WITH (NOLOCK) WHERE FormaPago = @FormaPago) > 0
SELECT @Comision3 = Comision3
FROM FormaPago WITH (NOLOCK)
WHERE FormaPago = @FormaPago
SELECT @CImporte = (@Importe *ISNULL(@Comision3,0.0)/100)
IF @Comision3 <> 0 AND @Servicio <> 'VALECARGO'
BEGIN
INSERT POSLDITemp(
ID, Servicio, Empresa, Usuario, Sucursal, Importe, Monedero, Referencia)
SELECT
@ID, @Servicio, @Empresa, @Usuario, @Sucursal, (@Importe+@CImporte), @Monedero, @Referencia
END
ELSE
INSERT POSLDITemp(
ID, Servicio, Empresa, Usuario, Sucursal, Importe, Monedero, Referencia)
SELECT
@ID, @Servicio, @Empresa, @Usuario, @Sucursal, @Importe, @Monedero, @Referencia
IF @Servicio = 'VALECARGO'
BEGIN
INSERT POSLDIValeTemp(
ID, Servicio, Empresa, Usuario, Sucursal, Importe, Vale)
SELECT
@ID, @Servicio, @Empresa, @Usuario, @Sucursal, @Importe, @Monedero
END
END

