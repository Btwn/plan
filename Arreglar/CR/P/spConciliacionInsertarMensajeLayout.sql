SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionInsertarMensajeLayout
@Institucion	varchar(20),
@Layout			varchar(20)

AS BEGIN
DECLARE
@Empresa		varchar(5)
IF EXISTS(SELECT * FROM MensajeLayout WHERE Layout = @Layout)
BEGIN
DELETE MensajeInstitucion WHERE Institucion = @Institucion
INSERT MensajeInstitucion
(Institucion, Mensaje, Descripcion, ConciliarMismaFecha, TipoMovimiento, NaturalezaMovimiento)
SELECT @Institucion, Mensaje, Descripcion, ConciliarMismaFecha, TipoMovimiento, NaturalezaMovimiento
FROM MensajeLayout
WHERE Layout = @Layout
END
RETURN
END

