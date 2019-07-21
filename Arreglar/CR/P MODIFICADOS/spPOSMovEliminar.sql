SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMovEliminar
@Empresa			varchar(5),
@Modulo				varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Estacion			int,
@ID					varchar(36)		OUTPUT,
@Mensaje			varchar(255)	OUTPUT,
@Imagen				varchar(255)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@GenerarNuevo		bit = 1

AS
BEGIN
DECLARE @MovID	varchar(20)
SELECT @GenerarNuevo = 1
IF ISNULL((SELECT SUM(ISNULL(Importe,0)) FROM POSLCObro pc WITH (NOLOCK) WHERE pc.ID = @ID),0) <> 0
SELECT @Ok = 60060
SELECT @MovID = MovID
FROM POSL pl WITH (NOLOCK)
WHERE pl.ID = @ID
IF @OK IS NULL
DELETE FROM POSLArtSeleccionado WHERE ID = @ID
IF @MovID IS NOT NULL AND @OK IS NULL
BEGIN
UPDATE POSL WITH (ROWLOCK) SET Estatus = 'CANCELADO', FechaCancelacion = GETDATE() WHERE ID = @ID
SELECT @Mensaje = 'MOVIMIENTO CANCELADO'
SELECT @ID = NULL
IF @ID IS NULL AND @GenerarNuevo = 1
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario,@Estacion, @ID OUTPUT, @Imagen OUTPUT
END
IF @MovID IS NULL AND @Ok IS NULL
BEGIN
IF (SELECT Sum(Cantidad) FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID )> 0
BEGIN
IF EXISTS(SELECT * FROM POSCancelacionArticulos WITH (NOLOCK) WHERE ID = @ID)
DELETE FROM POSCancelacionArticulos WHERE ID = @ID
INSERT POSCancelacionArticulos(ID, Empresa, Sucursal, Cajero, Caja, Articulo, Precio, Fecha, Cantidad)
SELECT @ID, @Empresa, @Sucursal, p.UsuarioAutoriza, p.Caja, pd.Articulo, pd.PrecioImpuestoInc,
getdate()-1, pd.Cantidad
FROM POSL p WITH (NOLOCK) JOIN POSLVenta pd WITH (NOLOCK) ON p.id = pd.id
WHERE p.ID = @ID
END
ELSE
DELETE FROM POSCancelacionArticulos WHERE ID = @ID
DELETE FROM POSL WHERE ID = @ID
DELETE FROM POSLVenta WHERE ID = @ID
DELETE FROM POSLCobro WHERE ID = @ID
DELETE FROM POSLSerieLote WHERE ID = @ID
DELETE FROM POSLArtSeleccionado WHERE ID = @ID
SELECT @Mensaje = 'MOVIMIENTO ELIMINADO'
IF @ID IS NULL AND @GenerarNuevo = 1
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Imagen OUTPUT
END
END

