SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgVentaB ON Venta

FOR DELETE
AS BEGIN
DECLARE
@ID		int,
@Estatus 	varchar(15),
@Mensaje	varchar(255),
@MovID	varchar(20),
@Ok		int,
@TCProcesado1	bit,	
@TCProcesado2	bit,	
@TCProcesado3	bit,	
@TCProcesado4	bit,	
@TCProcesado5	bit		
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Ok = NULL
SELECT @ID = ID, @Estatus = Estatus, @MovID = NULLIF(RTRIM(MovID), '') FROM Deleted
IF @Estatus IS NOT NULL AND @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') SELECT @Ok = 60090
IF @MovID IS NOT NULL SELECT @Ok = 30015
IF @Ok IS NULL AND EXISTS(SELECT ID FROM VentaCobro WHERE ID = @ID) 
BEGIN
SELECT @TCProcesado1 = ISNULL(TCProcesado1, 0), @TCProcesado2 = ISNULL(TCProcesado2, 0), @TCProcesado3 = ISNULL(TCProcesado3, 0), @TCProcesado4 = ISNULL(TCProcesado4, 0), @TCProcesado5 = ISNULL(TCProcesado5, 0) FROM VentaCobro WHERE ID = @ID
IF @TCProcesado1 = 1 OR @TCProcesado2 = 1 OR @TCProcesado3 = 1 OR @TCProcesado4 = 1 OR @TCProcesado5 = 1
SELECT @Ok = 9
END
IF @Ok IS NOT NULL
BEGIN
IF @Ok IS NOT NULL AND EXISTS(SELECT * FROM Nota WHERE ID = @ID)
SELECT @Ok = NULL
ELSE BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
RAISERROR (@Mensaje,16,-1)
END
END ELSE
EXEC spMovAlEliminar 'VTAS', @ID
END

