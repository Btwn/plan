SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spProyArrastraServicios
@IDProyecto		int,
@Empresa		varchar(20),
@Sucursal		int,
@NuevoIDProy	int,
@Usuario		varchar(50),
@EstacionSp		int

AS BEGIN
DECLARE @Mov				varchar(100),
@MovID				varchar(20),
@NuevoMov			varchar(100),
@NuevoMovID			varchar(20),
@DModuloArrastra	varchar(20),
@DIDArrastra		int,
@MovArrastra		varchar(100),
@MovIDArrastra		varchar(20),
@OIDCambia			int,
@ExisteMov			bit
SELECT @Mov = Mov, @MovID = MovID FROM Proyecto WHERE ID = @IDProyecto
SELECT @NuevoMov = Mov, @NuevoMovID = MovID FROM Proyecto WHERE ID = @NuevoIDProy
IF EXISTS(SELECT * FROM MovFlujo WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND OModulo = 'PROY' AND OID = @IDProyecto
AND OMov = @Mov AND OMovID = @MovID AND DMov NOT LIKE 'Presupuesto%' AND Cancelado = 0)
BEGIN
DECLARE crArrastraServicios CURSOR LOCAL FOR
SELECT OID, DModulo, DID, DMov, DMovID
FROM MovFlujo WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND OModulo = 'PROY' AND OID = @IDProyecto
AND OMov = @Mov AND OMovID = @MovID AND DMov NOT LIKE 'Presupuesto%' AND Cancelado = 0
OPEN crArrastraServicios
FETCH NEXT FROM crArrastraServicios INTO @OIDCambia, @DModuloArrastra, @DIDArrastra, @MovArrastra, @MovIDArrastra
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @ExisteMov = 0 
IF RTRIM(LTRIM(@DModuloArrastra)) = 'COMS' 
IF EXISTS(SELECT * FROM Compra WHERE ID = @DIDArrastra AND Estatus <> 'CANCELADO' AND Origen IS NOT NULL AND OrigenTipo IS NOT NULL AND OrigenID IS NOT NULL AND ORIGENTIPO = 'PROY')
BEGIN
UPDATE Compra SET Origen = @NuevoMov, OrigenTipo = 'PROY', OrigenID = @NuevoMovID, Proyecto = RTRIM(LTRIM(@NuevoMov))+' '+RTRIM(LTRIM(@NuevoMovID))
WHERE ID = @DIDArrastra AND Estatus = 'CONCLUIDO'
SET @ExisteMov = 1
END
IF RTRIM(LTRIM(@DModuloArrastra)) = 'VTAS' 
IF EXISTS(SELECT * FROM Venta WHERE ID = @DIDArrastra AND Estatus <> 'CANCELADO' AND Origen IS NOT NULL AND OrigenTipo IS NOT NULL AND OrigenID IS NOT NULL AND OrigenTipo = 'PROY')
BEGIN
UPDATE Venta SET Origen = @NuevoMov, OrigenTipo = 'PROY', OrigenID = @NuevoMovID, Proyecto = RTRIM(LTRIM(@NuevoMov))+' '+RTRIM(LTRIM(@NuevoMovID))
WHERE ID = @DIDArrastra AND Estatus <> 'CANCELADO'
SET @ExisteMov = 1
END
IF RTRIM(LTRIM(@DModuloArrastra)) = 'GAS' 
IF EXISTS(SELECT * FROM Gasto WHERE ID = @DIDArrastra AND Estatus <> 'CANCELADO' AND Origen IS NOT NULL AND OrigenTipo IS NOT NULL AND OrigenID IS NOT NULL AND OrigenTipo = 'PROY')
BEGIN
UPDATE Gasto SET Origen = @NuevoMov, OrigenTipo = 'PROY', OrigenID = @NuevoMovID, Proyecto = RTRIM(LTRIM(@NuevoMov))+' '+RTRIM(LTRIM(@NuevoMovID))
WHERE ID = @DIDArrastra AND Estatus = 'CONCLUIDO'
SET @ExisteMov = 1
END
IF RTRIM(LTRIM(@DModuloArrastra)) = 'CXP' 
IF EXISTS(SELECT * FROM Cxp WHERE ID = @DIDArrastra AND Estatus <> 'CANCELADO' AND Origen IS NOT NULL AND OrigenTipo IS NOT NULL AND OrigenID IS NOT NULL AND OrigenTipo = 'PROY')
BEGIN
UPDATE Cxp SET Origen = @NuevoMov, OrigenTipo = 'PROY', OrigenID = @NuevoMovID, Proyecto = RTRIM(LTRIM(@NuevoMov))+' '+RTRIM(LTRIM(@NuevoMovID))
WHERE ID = @DIDArrastra AND Estatus = 'CONCLUIDO'
SET @ExisteMov = 1
END
IF RTRIM(LTRIM(@DModuloArrastra)) = 'CXC' 
IF EXISTS(SELECT * FROM Cxc WHERE ID = @DIDArrastra AND Estatus <> 'CANCELADO' AND Origen IS NOT NULL AND OrigenTipo IS NOT NULL AND OrigenID IS NOT NULL AND OrigenTipo = 'PROY')
BEGIN
UPDATE Cxc SET Origen = @NuevoMov, OrigenTipo = 'PROY', OrigenID = @NuevoMovID, Proyecto = RTRIM(LTRIM(@NuevoMov))+' '+RTRIM(LTRIM(@NuevoMovID))
WHERE ID = @DIDArrastra AND Estatus = 'CONCLUIDO'
SET @ExisteMov = 1
END
IF @ExisteMov = 1 
BEGIN
INSERT ArrastreProy SELECT @Sucursal, @Empresa, 'PROY', @NuevoIDProy, @NuevoMov, @NuevoMovID, @DModuloArrastra, @DIDArrastra, @MovArrastra, @MovIDArrastra, @OIDCambia, @Mov, @MovID, GETDATE()
UPDATE MovFlujo SET OID = @NuevoIDProy, OMov = @NuevoMov, OMovID = @NuevoMovID
WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND DModulo = @DModuloArrastra AND DID = @DIDArrastra
AND DMov = @MovArrastra AND DMovID = @MovIDArrastra AND Cancelado = 0
SET @ExisteMov = 0
END
END
FETCH NEXT FROM crArrastraServicios INTO @OIDCambia, @DModuloArrastra, @DIDArrastra, @MovArrastra, @MovIDArrastra
END
CLOSE crArrastraServicios
DEALLOCATE crArrastraServicios
END
END

