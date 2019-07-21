SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMovCopiarEncabezadoWMS
@Modulo			char(5),
@ID				int,
@GenerarModulo	char(5),
@GenerarID		int
AS BEGIN
DECLARE
@Posicion		varchar(10),
@PosicionD		varchar(10),
@Montacarga		varchar(10),
@TarimaSurtido	varchar(20),
@Prioridad      varchar(10)
SELECT @Posicion = PosicionWMS, @PosicionD = PosicionDWMS
FROM Inv
WHERE ID = @ID
SELECT @Montacarga = Montacarga,
@TarimaSurtido = TarimaSurtido,
@Prioridad = Prioridad
FROM TMA WHERE ID = @ID
IF @Modulo = 'INV'
UPDATE Inv SET PosicionWMS = @Posicion, PosicionDWMS = @PosicionD WHERE ID = @GenerarID
ELSE
IF @Modulo = 'TMA'
UPDATE TMA SET Montacarga = @Montacarga, TarimaSurtido = @TarimaSurtido, Prioridad = @Prioridad WHERE ID = @GenerarID
ELSE
IF @Modulo = 'COMS'
UPDATE Compra SET PosicionWMS = (SELECT PosicionWMS FROM Compra WHERE ID = @ID) WHERE ID = @GenerarID
ELSE
IF @Modulo = 'VTAS'
UPDATE Venta SET PosicionWMS = (SELECT PosicionWMS FROM Venta WHERE ID = @ID) WHERE ID = @GenerarID
RETURN
END

