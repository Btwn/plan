SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReciboNominaPercepcionDeduccion
@Origen			varchar(max),
@Personal		varchar(20),
@Movimiento		varchar(50)
AS BEGIN
SELECT ISNULL(ND.Concepto,'') [Concepto],
ND.Importe [Importe]
FROM NominaD ND
JOIN Nomina N ON N.ID = ND.ID
WHERE ND.Movimiento = @Movimiento
AND N.Mov         ='Nomina'
AND ND.Personal   = ISNULL(@Personal,'')
AND N.id          = @Origen
AND N.Estatus     = 'CONCLUIDO'
GROUP BY ND.Concepto, ND.Importe
RETURN
END

