SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexTipoOrigen
(@Modulo     varchar(5), @ID  int)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado      varchar(50),
@Documento      varchar(max)
SELECT @Documento = Documento FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
IF (SELECT PATINDEX('%version="2.2"%',@Documento))  <> 0 OR  (SELECT PATINDEX('%version="2.0"%',@Documento))<> 0
SELECT @Resultado = 'CFD'
IF (SELECT PATINDEX('%version="3.2"%',@Documento))  <> 0 OR  (SELECT PATINDEX('%version="3.0"%',@Documento))<> 0
SELECT @Resultado = 'CFDI'
SELECT @Resultado = ISNULL(@Resultado,'')
RETURN (@Resultado)
END

