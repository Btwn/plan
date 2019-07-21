SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovAlEliminar
@Modulo	char(5),
@ID		int

AS BEGIN
IF @Modulo = 'VTAS'
IF EXISTS(SELECT * FROM Nota WHERE ID = @ID) RETURN
DELETE MovTiempo     WHERE Modulo = @Modulo AND ID = @ID
DELETE MovUsuario    WHERE Modulo = @Modulo AND ID = @ID
DELETE MovBitacora   WHERE Modulo = @Modulo AND ID = @ID
DELETE AnexoMov      WHERE Rama   = @Modulo AND ID = @ID
DELETE AgenteAgenda  WHERE Modulo = @Modulo AND ID = @ID
DELETE MovFormaAnexo WHERE Modulo = @Modulo AND ID = @ID
IF @Modulo = 'VTAS'
BEGIN
DELETE ServicioAccesorios WHERE ID = @ID
DELETE ServicioTarea      WHERE ID = @ID
DELETE VentaCobro         WHERE ID = @ID
DELETE VentaDLogPicos     WHERE ID = @ID
DELETE VentaOrigen        WHERE ID = @ID
DELETE VentaOtros         WHERE ID = @ID
DELETE VentaEntrega       WHERE ID = @ID
END ELSE
IF @Modulo = 'CR'
BEGIN
DELETE CRVenta  WHERE ID = @ID
DELETE CRAgente WHERE ID = @ID
DELETE CRCobro  WHERE ID = @ID
DELETE CRCaja   WHERE ID = @ID
END
IF @Modulo IN ('VTAS', 'INV', 'COMS', 'PROD')
BEGIN
DELETE AnexoMovD     WHERE Rama   = @Modulo AND ID = @ID
DELETE SerieLoteMov  WHERE Modulo = @Modulo AND ID = @ID
DELETE GuiaEmbarque  WHERE Modulo = @Modulo AND ID = @ID
DELETE GuiaEmbarqueD WHERE Modulo = @Modulo AND ID = @ID
UPDATE PlanArtOP
SET LiberacionModulo = NULL, LiberacionID = NULL, LiberacionMov = NULL, LiberacionMovID = NULL, Estado = 'Plan'
WHERE LiberacionModulo = @Modulo AND LiberacionID = @ID /*AND LiberacionMov = @Mov AND LiberacionMovID = @MovID*/
END
IF @Modulo = 'NOM'
DELETE NominaD WHERE ID = @ID
RETURN
END

