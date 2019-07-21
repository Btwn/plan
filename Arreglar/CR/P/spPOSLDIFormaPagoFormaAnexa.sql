SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIFormaPagoFormaAnexa
@Codigo		varchar(50),
@ID			varchar(36),
@Empresa	varchar(5)

AS
BEGIN
DECLARE
@FormaPago	varchar(50),
@Forma		varchar(50),
@Caja	    varchar(10),
@Ok			int
SELECT @Caja = CtaDinero
FROM POSL
WHERE ID = @ID
IF ISNULL((SELECT Abierto FROM POSEstatusCaja WHERE Caja = @Caja),0) <> 1
SELECT @Ok = 30440
SELECT @FormaPago = FormaPago
FROM CB
WHERE CB.Codigo = @Codigo
IF @Ok IS NULL
SELECT @Forma = plfp.Forma
FROM POSLDIFormaPago plfp
WHERE plfp.FormaPago = @FormaPago
SELECT @Forma
END

