SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexParcialidadNumero
(@OrigenSerie varchar(20), @OrigenFolio int, @OrigenUUID varchar(50))
RETURNS varchar(20)

AS BEGIN
DECLARE @ParcialidadNumero int
SELECT @OrigenSerie = NULLIF(@OrigenSerie,''), @OrigenFolio = NULLIF(@OrigenFolio,0), @ParcialidadNumero = 0
IF @OrigenUUID IS NULL
BEGIN
IF @OrigenSerie IS NOT NULL AND @OrigenFolio IS NOT NULL
BEGIN
SELECT @ParcialidadNumero = ISNULL(MAX(ParcialidadNumero),0) FROM CFD WHERE OrigenSerie = @OrigenSerie AND OrigenFolio = @OrigenFolio AND Modulo = 'VTAS'
IF @ParcialidadNumero = 0
SELECT @ParcialidadNumero = ISNULL(MAX(ParcialidadNumero),0) FROM CFD WHERE OrigenSerie = @OrigenSerie AND OrigenFolio = @OrigenFolio AND Modulo = 'CXC'
END
END
ELSE
BEGIN
SELECT @ParcialidadNumero = ISNULL(MAX(ParcialidadNumero),0) FROM CFD WHERE OrigenUUID = @OrigenUUID
END
SELECT @ParcialidadNumero = ISNULL(@ParcialidadNumero,0) + 1
RETURN (@ParcialidadNumero)
END

