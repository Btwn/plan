SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceCopiarValores
@OpcionID int,
@OpcionIDOriginal int,
@VariacionID int,
@Ok int = NULL OUTPUT,
@OkRef varchar(255) = NULL OUTPUT

AS BEGIN
INSERT INTO WebArtOpcionValor (VariacionID, OpcionID, Orden, NumeroIntelisis, Valor)
SELECT @VariacionID, @OpcionID, Orden, NumeroIntelisis, Valor
FROM WebArtOpcionValor
WHERE OpcionID = @OpcionIDOriginal
END

