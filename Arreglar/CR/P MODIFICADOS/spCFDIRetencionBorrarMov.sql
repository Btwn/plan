SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionBorrarMov
@Estacion		int,
@Modulo			varchar(5),
@ModuloID		int

AS
BEGIN
DELETE CFDIRetencion        WHERE EstacionTrabajo = @Estacion AND Modulo = @Modulo AND ModuloID = @ModuloID
DELETE CFDIRetencionCalcTmp WHERE EstacionTrabajo = @Estacion AND Modulo = @Modulo AND ModuloID = @ModuloID
DELETE CFDIRetencionD       WHERE EstacionTrabajo = @Estacion AND Modulo = @Modulo AND ModuloID = @ModuloID
DELETE ListaModuloID WHERE Estacion = @Estacion AND Modulo = @Modulo AND ID = @ModuloID
RETURN
END

