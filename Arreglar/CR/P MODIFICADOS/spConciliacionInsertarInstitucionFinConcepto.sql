SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionInsertarInstitucionFinConcepto
@Institucion	varchar(20),
@Layout			varchar(20)

AS BEGIN
DECLARE
@Empresa		varchar(5),
@Ok				int,
@OkRef			varchar(255)
IF EXISTS(SELECT * FROM MensajeInstitucion WITH (NOLOCK)   WHERE Institucion = @Institucion)
BEGIN
BEGIN TRY
BEGIN TRANSACTION
DELETE InstitucionFinConcepto WHERE Institucion = @Institucion
INSERT InstitucionFinConcepto
(Institucion, ConceptoBanco, TipoMovimiento)
SELECT @Institucion, Descripcion,   TipoMovimiento
FROM MensajeInstitucion WITH (NOLOCK)  
WHERE Institucion = @Institucion
GROUP BY Descripcion, TipoMovimiento
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT @Ok = ERROR_NUMBER(), @OkRef = ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END
IF @Ok IS NOT NULL
SELECT @OkRef
ELSE
SELECT null
RETURN
END

