SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spAplicaValAdquisicionAF
@ID			int,
@Modulo		varchar(5),
@Estatus	varchar(20),
@Empresa	varchar(5),
@Usuario    varchar(10),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Clave		Varchar(20),
@RenglonSL		Int,
@ValorCancelado	Money,
@cID			Int,
@cRenglon		Float,
@cModulo		Varchar(5),
@cArt			Varchar(20),
@cSerie			Varchar(50),
@cTotal			Money,
@cTotalMov		Money,
@cFechaIniDep	Datetime
IF @Modulo = 'COMS'
SELECT @Clave = m.Clave
FROM Compra c
JOIN MovTipo m ON c.Mov = m.Mov AND m.Modulo = @Modulo AND c.ID = @ID
IF @Modulo = 'GAS'
SELECT @Clave = m.Clave
FROM Gasto c
JOIN MovTipo m ON c.Mov = m.Mov AND m.Modulo = @Modulo AND c.ID = @ID
DECLARE cActivoFijo CURSOR FOR
SELECT B.ID, A.Renglon, A.Modulo, A.Articulo, A.Serie, A.Total, A.ImporteMov, A.FechaInicioDepreciacion
FROM AuxiliarActivoFijo A
LEFT JOIN ActivoF B ON B.Articulo = A.Articulo AND B.Serie = A.Serie
WHERE A.IDMov = @ID AND A.Modulo = @Modulo
AND A.Aplicar = 1
OPEN cActivoFijo
FETCH NEXT FROM cActivoFijo INTO @cID, @cRenglon, @cModulo, @cArt, @cSerie, @cTotal, @cTotalMov, @cFechaIniDep
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Estatus = 'CONCLUIDO' AND (@Clave IN ('COMS.EI','COMS.EG') OR @cModulo = 'GAS')
BEGIN
UPDATE ActivoF
SET AdquisicionValor = AdquisicionValor + @cTotalMov
WHERE ID = @cID
AND ISNULL(DepreciacionInicio,GETDATE()) <= ISNULL(@cFechaIniDep,GETDATE())
IF @Clave = 'COMS.EG'
BEGIN
UPDATE ActivoF
SET AdquisicionValor = AdquisicionValor + @cTotalMov,
AdquisicionValorF = AdquisicionValorF + @cTotalMov,
AdquisicionValorF2 = AdquisicionValorF2 + @cTotalMov
WHERE ID = @cID
AND ISNULL(DepreciacionInicio,GETDATE()) <= ISNULL(@cFechaIniDep,GETDATE())
END
SELECT @RenglonSL = MAX(ISNULL(RenglonID,0))+1
FROM SerieLoteD A
WHERE Empresa = @Empresa
AND Articulo = @cArt
AND SerieLote = @cSerie
AND Modulo = @cModulo
AND ID = @ID
DELETE FROM SerieLoteD
WHERE Articulo = @cArt
AND SerieLote = @cSerie
AND Modulo = @cModulo
AND ID = @ID
AND Empresa = @Empresa
INSERT INTO SerieLoteD(Empresa, Articulo, Subcuenta, SerieLote, Modulo, ID, RenglonID, Sucursal)
SELECT A.Empresa, A.Articulo, B.Subcuenta, A.Serie, @cModulo, @ID, @cRenglon, A.Sucursal
FROM ActivoF A
JOIN SerieLote B ON A.Articulo = B.Articulo
AND A.Serie = B.SerieLote
WHERE A.Articulo = @cArt
AND A.ID = @cID
EXCEPT
SELECT Empresa, Articulo, Subcuenta, SerieLote, Modulo, ID, RenglonID, Sucursal
FROM SerieLoteD
WHERE Empresa = @Empresa
AND Modulo = @cModulo
AND ID = @ID
END
IF (@Estatus = 'CANCELADO'  AND (@Clave IN ('COMS.EI','COMS.EG') OR  @cModulo = 'GAS')) OR (@Estatus = 'CONCLUIDO' AND @Clave IN ('COMS.D','COMS.B'))
BEGIN
SELECT @ValorCancelado = ISNULL(A.AdquisicionValor,0) - ISNULL(@cTotalMov,0)
FROM ActivoF A
JOIN AuxiliarActivoFijo B ON A.ID = B.ID
WHERE B.ID = @cID
AND B.IDMov = @ID
AND B.Empresa = @Empresa
AND B.Modulo = @cModulo
AND B.Articulo = @cArt
AND B.Serie =	@cSerie
UPDATE ActivoF
SET AdquisicionValor = @ValorCancelado
WHERE ID = @cID
AND Articulo = @cArt
AND Serie = @cSerie
AND ISNULL(DepreciacionInicio,GETDATE()) <= ISNULL(@cFechaIniDep,GETDATE())
DELETE FROM SerieLoteD
WHERE Empresa = @Empresa
AND Articulo = @cArt
AND SerieLote = @cSerie
AND Modulo = @cModulo
AND	ID = @ID
END
FETCH NEXT FROM cActivoFijo INTO @cID, @cRenglon, @cModulo, @cArt, @cSerie, @cTotal, @cTotalMov, @cFechaIniDep
END
CLOSE cActivoFijo
DEALLOCATE cActivoFijo
END

