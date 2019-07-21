SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadMatar
@Empresa		varchar(5),
@Usuario		varchar(5),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Sucursal		int,
@ID				int,
@Accion			varchar(20),
@OrigenTipo		varchar(5),
@Origen			varchar(20),
@OrigenID		varchar(20),
@ContactoTipo	varchar(10),
@Contacto		varchar(20),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Renglon					float,
@IDOrigen					int,
@AplicaEstatusNuevo		char(15),
@AplicaFechaConclusion	datetime,
@AplicaEstatus			varchar(15),
@OrigenMovTipo			varchar(20)
IF @Accion = 'AFECTAR'
BEGIN
SELECT @IDOrigen = ID, @AplicaEstatus = Estatus FROM Oportunidad JOIN MovTipo ON Oportunidad.Mov = MovTipo.Mov AND MovTipo.Modulo = 'OPORT' WHERE Empresa = @Empresa AND Oportunidad.Mov = @Origen AND MovID = @OrigenID AND Estatus = 'PENDIENTE'
SELECT @Renglon = MIN(Renglon) FROM OportunidadD WHERE ID = @IDOrigen AND Contacto = @Contacto AND ISNULL(CantidadPendiente, 0) <> 0
IF @IDOrigen IS NULL OR @Renglon IS NULL
SELECT @Ok = 20180, @OkRef = @Contacto
UPDATE OportunidadD SET CantidadPendiente = NULL WHERE ID = @IDOrigen AND Contacto = @Contacto AND Renglon = @Renglon
IF NOT EXISTS(SELECT * FROM OportunidadD WHERE ID = @IDOrigen AND ISNULL(CantidadPendiente, 0) <> 0)
SELECT @AplicaEstatusNuevo = 'CONCLUIDO', @AplicaFechaConclusion = @FechaEmision
ELSE
SELECT @AplicaEstatusNuevo = @AplicaEstatus, @AplicaFechaConclusion = NULL
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDOrigen = ID, @AplicaEstatus = Estatus FROM Oportunidad JOIN MovTipo ON Oportunidad.Mov = MovTipo.Mov AND MovTipo.Modulo = 'OPORT' WHERE Empresa = @Empresa AND Oportunidad.Mov = @Origen AND MovID = @OrigenID AND Estatus IN('PENDIENTE', 'CONCLUIDO')
SELECT @Renglon = MIN(Renglon) FROM OportunidadD WHERE ID = @IDOrigen AND Contacto = @Contacto AND ISNULL(CantidadPendiente, 0) = 0
IF @IDOrigen IS NULL OR @Renglon IS NULL
SELECT @Ok = 20180, @OkRef = @Contacto
UPDATE OportunidadD SET CantidadPendiente = 1 WHERE ID = @IDOrigen AND Contacto = @Contacto AND Renglon = @Renglon
IF NOT EXISTS(SELECT * FROM OportunidadD WHERE ID = @IDOrigen AND ISNULL(CantidadPendiente, 0) = 0)
SELECT @AplicaEstatusNuevo = 'PENDIENTE', @AplicaFechaConclusion = NULL
ELSE
SELECT @AplicaEstatusNuevo = 'PENDIENTE', @AplicaFechaConclusion = @FechaEmision
END
IF @AplicaEstatus <> @AplicaEstatusNuevo
BEGIN
EXEC spValidarTareas @Empresa, 'OPORT', @IDOrigen, @AplicaEstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Oportunidad SET Estatus = @AplicaEstatusNuevo, FechaConclusion = @AplicaFechaConclusion WHERE ID = @IDOrigen
IF @@ERROR <> 0 SELECT @Ok = 1
END
EXEC xpOportunidadMatar @Empresa, @Usuario, @FechaEmision, @FechaRegistro, @Sucursal, @ID, @Accion, @OrigenTipo, @Origen, @OrigenID, @ContactoTipo, @Contacto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, 'OPORT', @IDOrigen, @AplicaEstatus, @AplicaEstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Origen, @OrigenID, @OrigenMovTipo, NULL, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

