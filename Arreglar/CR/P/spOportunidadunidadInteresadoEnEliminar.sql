SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadunidadInteresadoEnEliminar
@Estacion	int,
@ID         int,
@RenglonID	int

AS BEGIN
DELETE OportunidadInteresadoEn WHERE ID = @ID AND RenglonID = @RenglonID
RETURN
END

