SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvUtilizarTodoDetalleWMS 
@Modulo			char(5),
@OID           	int,
@DID			int

AS BEGIN
DECLARE
@OMov			varchar(20),
@DMov			varchar(20),
@MovTipo		varchar(20),
@SubClave		varchar(20)
IF @Modulo = 'INV'
BEGIN
SELECT @OMov = Mov FROM Inv WHERE ID = @OID
SELECT @DMov = Mov FROM Inv WHERE ID = @DID
SELECT @MovTipo = Clave, @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @OMov
IF @OMov = @DMov AND @MovTipo <> 'INV.SI' AND ISNULL(@SubClave,'') = ''
UPDATE InvD SET Tarima = NULL WHERE ID = @DID
END
ELSE
IF @Modulo = 'TMA'
BEGIN
SELECT @OMov = Mov FROM TMA WHERE ID = @OID
SELECT @DMov = Mov FROM TMA WHERE ID = @DID
SELECT @MovTipo = Clave, @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @OMov
IF @OMov = @DMov
UPDATE TMAD SET Tarima = NULL WHERE ID = @DID
END
ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @OMov = Mov FROM Compra WHERE ID = @OID
SELECT @DMov = Mov FROM Compra WHERE ID = @DID
SELECT @MovTipo = Clave, @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @OMov
IF @OMov = @DMov
UPDATE CompraD SET Tarima = NULL WHERE ID = @DID
END
ELSE
IF @Modulo = 'VTAS'
BEGIN
SELECT @OMov = Mov FROM Venta WHERE ID = @OID
SELECT @DMov = Mov FROM Venta WHERE ID = @DID
SELECT @MovTipo = Clave, @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @OMov
IF @OMov = @DMov
UPDATE VentaD SET Tarima = NULL WHERE ID = @DID
END
RETURN
END

