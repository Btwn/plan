SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaArmada
@Empresa		varchar(5),
@Sucursal		int,
@Moneda			varchar(10),
@TipoCambio		float

AS BEGIN
DECLARE
@OfertaID	int,
@ArmadaOk	bit
DECLARE @OfertaArmada TABLE(
Orden int IDENTITY(1,1)PRIMARY KEY,
ID    int)
INSERT @OfertaArmada(ID)
SELECT o.ID
FROM Oferta o
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave = 'OFER.OA'
JOIN #OfertaActiva oa ON oa.ID = o.ID
ORDER BY o.Prioridad,o.FechaEmision
DECLARE crOfertaArmada CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT ID
FROM @OfertaArmada
OPEN crOfertaArmada
FETCH NEXT FROM crOfertaArmada INTO @OfertaID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spOfertaArmadaAplicar @OfertaID, @Empresa
FETCH NEXT FROM crOfertaArmada INTO @OfertaID
END  
CLOSE crOfertaArmada
DEALLOCATE crOfertaArmada
RETURN
END

