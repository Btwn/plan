SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexIDOrigen(@Modulo     varchar(5), @ID  int, @Nivel  int)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado   varchar(50),
@OModulo     varchar(5),
@OID         int ,
@Tipo        varchar(20)
SET @Resultado = NULL
IF EXISTS(SELECT * FROM CFD WITH (NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID)
SELECT @Tipo = ISNULL(dbo.fnCFDFlexTipoOrigen(@Modulo,@ID),'CFD')
IF @Tipo = 'CFD' AND @Nivel <>1
SELECT  @Resultado =RTRIM(LTRIM(c.Modulo)) + '#' +CONVERT(varchar,c.ModuloID)
FROM  CFD c WITH (NOLOCK)
WHERE c.Modulo = @Modulo AND c.ModuloID = @ID
AND c.Sello IS NOT NULL
AND c.CadenaOriginal IS NOT NULL
AND c.Documento IS NOT NULL
AND PATINDEX( '%tipoDeComprobante="ingreso" %',c.Documento)<>0
IF @Tipo = 'CFDI'   AND @Nivel <>1
SELECT  @Resultado =RTRIM(LTRIM(c.Modulo)) + '#' +CONVERT(varchar,c.ModuloID)
FROM  CFD c WITH (NOLOCK)
WHERE c.Modulo = @Modulo AND c.ModuloID = @ID
AND c.Sello IS NOT NULL
AND c.CadenaOriginal IS NOT NULL
AND c.Documento IS NOT NULL
AND c.UUID IS NOT NULL
AND PATINDEX( '%tipoDeComprobante="ingreso" %',c.Documento)<>0
SELECT @OModulo = mf.OModulo, @OID = mf.OID
FROM MovFLujo mf WITH (NOLOCK)
WHERE DModulo = @Modulo AND DID = @ID
IF @Resultado IS NULL AND @Nivel < 31 AND @OID IS NOT NULL
BEGIN
SET @Nivel = @Nivel + 1
SELECT @Resultado = dbo.fnCFDFlexIDOrigen(@OModulo, @OID,@Nivel)
END
SELECT @Resultado = ISNULL(@Resultado,'')
RETURN (@Resultado)
END

