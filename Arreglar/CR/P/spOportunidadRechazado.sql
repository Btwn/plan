SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadRechazado
@ID             int,
@Competidor		varchar(50),
@Motivo			varchar(100)

AS
BEGIN
UPDATE Oportunidad SET Competidor = @Competidor, Motivo = @Motivo WHERE ID = @ID
RETURN
END

