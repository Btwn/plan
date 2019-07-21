SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVerificadorPreciosInsertaAccion
@ID			varchar(36),
@Codigo		varchar(50)

AS
BEGIN
DECLARE @Caja	varchar(10),
@Host	varchar(20)
SELECT @Caja	= Caja,
@Host	= Host
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
IF NULLIF(@Codigo,'') IS NOT NULL
BEGIN
IF NOT EXISTS (SELECT * FROM POSLAccion WITH (NOLOCK) WHERE Caja = @Caja AND Host = @Host AND Accion = 'VERIFICAR PRECIOS')
INSERT INTO POSLAccion (Host, Caja, Accion)
SELECT				 @Host, @Caja,'VERIFICAR PRECIOS'
END
END

