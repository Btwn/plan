SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCFDIRetencionCompra ON Compra
FOR UPDATE
AS
BEGIN
DECLARE @ID						int,
@IDAnt					int,
@Ok						int,
@OkRef					varchar(255),
@Mov						varchar(20),
@MovID					varchar(20)
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(i.ID)
FROM Inserted i
JOIN Deleted d ON i.ID = d.ID
WHERE i.Estatus =  'CANCELADO'
AND d.Estatus <> 'CANCELADO'
AND i.ID > @IDAnt
AND ISNULL(d.CFDRetencionTimbrado, 0) = 1
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @Mov = Mov, @MovID = MovID FROM Inserted WHERE ID = @ID
SELECT @Ok = 60050, @OkRef = 'CFDI - ' + RTRIM(@Mov)+' '+RTRIM(@MovID)
BEGIN TRY
EXEC spOk_RAISERROR @Ok, @OkRef
END TRY
BEGIN CATCH
EXEC spOk_RAISERROR @Ok, @OkRef
ROLLBACK TRAN
END CATCH
END
RETURN
END

