SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTMACantidadGenerar (@Empresa varchar(5), @ID int, @Renglon float, @Origen varchar(20), @OrigenID varchar(20), @Base varchar(20), @MovTipo varchar(20), @SubClave varchar(20)) 
RETURNS float

AS BEGIN
DECLARE
@CantidadGenerar	float
IF @Base = 'PENDIENTE'
BEGIN
IF @MovTipo IN ('TMA.OSUR', 'TMA.OPCKTARIMA') 
SELECT @CantidadGenerar = d.CantidadPicking - (SELECT ISNULL(SUM(ISNULL(CantidadPicking,0)),0) FROM TMA t WITH(NOLOCK) JOIN TMAD d1 WITH(NOLOCK) ON d1.ID = t.ID WHERE t.Origen = @Origen AND t.OrigenID = @OrigenID AND t.Empresa = @Empresa AND t.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.Renglon = d1.Renglon)
FROM TMAD d WITH(NOLOCK)
WHERE ID = @ID
AND EstaPendiente = 1
AND Renglon = @Renglon 
ELSE
SELECT @CantidadGenerar = d.CantidadPicking
FROM TMAD d WITH(NOLOCK)
WHERE ID = @ID
AND EstaPendiente = 1
AND Renglon = @Renglon 
END
ELSE
IF @SubClave NOT IN ('TMA.OSURP', 'TMA.SURP') AND @MovTipo NOT IN ('TMA.OPCKTARIMA') 
SELECT @CantidadGenerar = d.CantidadPicking
FROM TMAD d WITH(NOLOCK)
WHERE ID = @ID
AND EstaPendiente = 1
AND Renglon = @Renglon 
ELSE
SELECT @CantidadGenerar = d.CantidadA
FROM TMAD d WITH(NOLOCK)
WHERE ID = @ID
AND EstaPendiente = 1
AND Renglon = @Renglon 
RETURN(@CantidadGenerar)
END

