SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCopiar
@Sucursal				int,
@Modulo					char(5),
@ID						int,
@Usuario				char(10),
@FechaTrabajo			datetime,
@EnSilencio				bit = 0,
@Identico				bit = 0,
@Directo				bit = 1,
@Sub					bit = 0,
@GenerarMov				varchar(20) = NULL,
@GenerarMovID			varchar(20) = NULL,
@CopiarArtCostoInv		bit = 0,
@CopiarSucursalDestino	bit = 0,
@Conexion				bit = 0,
@SinDetalle				bit = 0

AS BEGIN
DECLARE
@p					int,
@Base				varchar(20),
@Empresa			char(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@Moneda				char(10),
@TipoCambio			float,
@Almacen			char(10),
@AlmacenDestino		char(10),
@Ok					int,
@GenerarID			int,
@Max				int,
@MasterMovID		varchar(20),
@AnexoID			int,
@AnexarOrdenes		int
IF @Identico = 1
SELECT @Base = 'IDENTICO'
ELSE
SELECT @Base = 'TODO'
SELECT @GenerarID = NULL, @AnexarOrdenes = 0, @AnexoID = NULL
EXEC spExtraerFecha @FechaTrabajo OUTPUT
EXEC spIDEnMov @Modulo, @ID, @Empresa OUTPUT, @Mov OUTPUT, @MovID OUTPUT, @Moneda OUTPUT, @Almacen OUTPUT, @AlmacenDestino OUTPUT, @Ok OUTPUT
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @Sub = 1 AND @MovTipo IN ('VTAS.P', 'VTAS.S', 'VTAS.SD', 'VTAS.R'/*, 'VTAS.VCR'*/)
BEGIN
IF (SELECT VentaAnexarOrdenes FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @AnexarOrdenes = 1
SELECT @AnexoID = ISNULL(AnexoID, ID) FROM Venta WHERE ID = @ID
END
END
IF @GenerarMov IS NULL
SELECT @GenerarMov = @Mov
IF @Sub = 1
BEGIN
SELECT @p = CHARINDEX('-', @MovID)
IF @p > 0
SELECT @MasterMovID = SUBSTRING(@MovID, 1, @p-1) ELSE SELECT @MasterMovID = @MovID
IF @Modulo = 'VTAS'
SELECT @Max = ISNULL(MAX(CONVERT(int, SUBSTRING(MovID, LEN(@MasterMovID)+2, 20))), 0) FROM Venta WHERE Empresa = @Empresa AND Mov = @GenerarMov AND MovID LIKE RTRIM(@MasterMovID)+'-%'
ELSE
SELECT @Max = ISNULL(MAX(CONVERT(int, SUBSTRING(MovID, LEN(@MasterMovID)+2, 20))), 0) FROM Mov WHERE Empresa = @Empresa AND Mov = @GenerarMov AND MovID LIKE RTRIM(@MasterMovID)+'-%'
SELECT @GenerarMovID = RTRIM(@MasterMovID)+'-'+CONVERT(varchar, @Max+1)
END
IF @Conexion = 0
BEGIN TRANSACTION
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
IF (SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM EmpresaGral WHERE Empresa = @Empresa) = 1 OR
(SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1
SELECT @TipoCambio = NULL
EXEC spMovCopiarEncabezado @Sucursal, @Modulo,  @ID, @Empresa, NULL, NULL, @Usuario, @FechaTrabajo,
'SINAFECTAR', @Moneda, @TipoCambio, @Almacen, @AlmacenDestino, @Directo, @GenerarMov, @GenerarMovID,
@GenerarID OUTPUT, @Ok OUTPUT, 0, @CopiarSucursalDestino = @CopiarSucursalDestino
IF @GenerarID IS NOT NULL
BEGIN
IF @Identico = 1
EXEC spMovCopiarOtros @Sucursal, @Modulo, @ID, @GenerarID
IF @Sub = 1
BEGIN
IF @AnexarOrdenes = 1
BEGIN
IF @Modulo = 'VTAS'
UPDATE Venta SET AnexoID = @AnexoID WHERE ID = @GenerarID
END
END
ELSE
BEGIN
IF @SinDetalle = 0
BEGIN
IF @Modulo IN ('VTAS', 'INV', 'COMS', 'PROD'/*, 'TMA'*/, 'SAUX')
BEGIN
EXEC spInvUtilizarTodoDetalle @Sucursal, @Modulo, @Base, @ID, NULL, NULL, NULL, @GenerarID, 1, NULL, @Empresa = @Empresa
IF @MovTipo NOT IN ('VTAS.P','INV.OT','INV.OI')
EXEC spMovCopiarSerieLote @Sucursal, @Modulo, @ID, @GenerarID, @CopiarArtCostoInv = @CopiarArtCostoInv
IF @Modulo IN ('COMS', 'INV')
EXEC spMovCopiarGastoDiverso @Modulo, @Sucursal, @ID, @GenerarID
END
ELSE
IF @Modulo = 'CAM'
EXEC spMovCopiarCambioD @Empresa, @Sucursal, @Modulo, @ID, @GenerarID
ELSE
BEGIN
IF @Modulo NOT IN ('EMB')
EXEC spMovCopiarDetalle @Sucursal, @Modulo, @ID, @GenerarID, @Usuario, @Base, @GenerarMov, @GenerarMovID
IF @Modulo = 'OFER'
INSERT OfertaFiltro (ID,         Campo, Valor, Sucursal)
SELECT @GenerarID, Campo, Valor, @Sucursal
FROM OfertaFiltro
WHERE ID = @ID
IF @Modulo = 'PC'
EXEC spPCArtListaAceptar 0, @GenerarID
IF @Modulo = 'PROY'
EXEC spMovCopiarProyecto @Empresa, @Sucursal, @ID, @GenerarID
END
END
END
EXEC spMovCopiarFormaAnexa @Modulo, @ID, @GenerarID
IF EXISTS(SELECT * FROM EmpresaCfgModulo WHERE Empresa = @Empresa AND Modulo = @Modulo AND Tiempos = 'Si')
INSERT INTO MovTiempo (Modulo,  Sucursal,  ID,         Usuario,  FechaInicio, FechaComenzo, Estatus)
VALUES (@Modulo, @Sucursal, @GenerarID, @Usuario, GETDATE(),   GETDATE(),    'SINAFECTAR')
END
EXEC xpMovCopiar @Sucursal, @Modulo, @ID, @Usuario, @FechaTrabajo, @EnSilencio, @Identico, @Directo, @Sub, @GenerarID,  @GenerarMov, @GenerarMovID, @CopiarArtCostoInv
IF @Conexion = 0
COMMIT TRANSACTION
IF @EnSilencio = 0
SELECT 80030, NULL, NULL, NULL, @GenerarID
RETURN @GenerarID
END

