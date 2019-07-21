SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizarOrdenEntarimadoWMS
@OrdenID    int,
@ID         int,
@Accion	    varchar(20),
@Modulo		varchar(5),
@Posicion	varchar(10),
@PosicionD  varchar(10)

AS BEGIN
DECLARE
@Mov varchar(20),
@Clave varchar(20)
IF @Modulo = 'COMS'
SELECT @Posicion = PosicionWMS FROM Compra WITH(NOLOCK) WHERE ID = @ID
ELSE
IF @Modulo = 'INV'
SELECT @Posicion = PosicionWMS, @PosicionD = PosicionDWMS FROM Inv WITH(NOLOCK) WHERE ID = @ID
ELSE
IF @Modulo = 'VTAS'
SELECT @Posicion = PosicionWMS FROM Venta WITH(NOLOCK) WHERE ID = @ID
SELECT @Mov = Mov
FROM Inv WITH(NOLOCK)
WHERE ID = @OrdenID
SELECT @Clave = Clave
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'INV' AND Mov = @Mov
IF @Clave = 'INV.SOL'
BEGIN
UPDATE Inv SET PosicionWMS = ISNULL(@PosicionD,@Posicion) WHERE ID = @OrdenID
END
IF @Clave <> 'INV.SOL'
UPDATE Inv WITH(ROWLOCK) SET PosicionWMS = @Posicion WHERE ID = @OrdenID
EXEC xpActualizarOrdenEntarimadoWMS @OrdenID, @ID, @Accion, @Modulo, @Posicion, @PosicionD
RETURN
END

