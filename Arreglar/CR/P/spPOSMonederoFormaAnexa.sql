SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMonederoFormaAnexa
@Codigo		varchar(50),
@ID			varchar(36),
@Empresa	varchar(5)

AS
BEGIN
DECLARE
@Redime		Bit,
@Forma		Varchar(50),
@Ok			Int,
@FormaPago	varchar(50)
SELECT @FormaPago = FormaPago
FROM CB
WHERE CB.Codigo = @Codigo
SELECT @Forma = NULL
SELECT @Forma = NULLIF(ObjetoPOS,'')
FROM FormaCobroMon
WHERE Empresa = @Empresa
AND FormaCobro = @FormaPago
SELECT @Forma
END

