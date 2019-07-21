SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoInv
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Sucursal			int,
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@AntecedenteID		int,
@Almacen			varchar(10),
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@GastoID				int,
@CopiarMov				bit,
@InvID					int,
@InvMov					varchar(20),
@InvMovID				varchar(20),
@Directo				bit,
@Aplica					varchar(20),
@AplicaID				varchar(20),
@CfgMultiUnidadesNivel	varchar(20),
@CfgMultiUnidades		bit,
@Articulo				varchar(100),
@Unidad					varchar(20),
@Cantidad				int,
@CantidadInventario		int,
@OrigenTipo				varchar(20),
@Origen					varchar(20),
@OrigenID				varchar(20),
@AntecedenteOrigen		varchar(20),
@AntecedenteOrigenID	varchar(20)
SELECT @OrigenTipo = OrigenTipo, @Origen = Origen, @OrigenID = OrigenID FROM Gasto  WITH (NOLOCK)  WHERE ID = @ID
SELECT @OrigenTipo = OrigenTipo, @AntecedenteOrigen = Origen, @AntecedenteOrigenID = OrigenID FROM Gasto  WITH (NOLOCK) WHERE Empresa  = @Empresa AND Mov = @Origen AND MovID = @OrigenId AND Sucursal = @Sucursal
SELECT @AntecedenteID = ID FROM Gasto WITH (NOLOCK) WHERE Empresa  = @Empresa AND Mov = @AntecedenteOrigen AND MovID = @AntecedenteOrigenID AND Sucursal = @Sucursal
SELECT @InvID = NULL, @InvMovID = NULL
SELECT @CopiarMov = ISNULL(GastoInvCopiarMov, 0)
FROM EmpresaCfg2  WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @CopiarMov = 1
BEGIN
SELECT @InvMov = @Mov, @InvMovID = @MovID
IF NOT EXISTS(SELECT * FROM MovTipo  WITH (NOLOCK) WHERE Modulo = 'INV' AND Mov = @InvMov) SELECT @Ok = 70150, @OkRef = @InvMov+' (Modulo Inventarios)'
END ELSE
SELECT @InvMov = CASE @MovTipo
WHEN 'GAS.S'  THEN InvSolicitud
WHEN 'GAS.SR' THEN InvSolicitudRechazada
WHEN 'GAS.CI' THEN InvConsumo
END
FROM EmpresaCfgMov  WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @InvID = MAX(ID)
FROM Inv  WITH (NOLOCK)
WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
END ELSE
BEGIN
SELECT @GastoID = @ID, @Directo = 1, @Aplica = NULL, @AplicaID = NULL
IF @AntecedenteID IS NOT NULL
BEGIN
SELECT @Directo = 0
SELECT @Aplica = Mov, @AplicaID = MovID FROM Inv  WITH (NOLOCK)  WHERE ID = (SELECT MIN(InvID) FROM GastoD  WITH (NOLOCK)  WHERE ID = (SELECT MIN(ID) FROM Gasto  WITH (NOLOCK)  WHERE ID = @AntecedenteID))
IF @MovTipo = 'GAS.SR' SELECT @GastoID = @AntecedenteID
END
INSERT Inv (
OrigenTipo,  Origen, OrigenID, UltimoCambio,  Sucursal,  Empresa, Usuario,  Estatus,     Mov,     MovID,     FechaEmision, Almacen,  Proyecto, Moneda, TipoCambio, Observaciones, FechaRequerida, Directo)
SELECT @Modulo,     Mov,    MovID,    GETDATE(),     @Sucursal, Empresa, Usuario, 'SINAFECTAR', @InvMov, @InvMovID, FechaEmision, @Almacen, Proyecto, Moneda, TipoCambio, Observaciones, FechaRequerida, @Directo
FROM Gasto  WITH (NOLOCK)
WHERE ID = @GastoID
SELECT @InvID = SCOPE_IDENTITY()
SELECT @CfgMultiUnidades       = MultiUnidades,@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD') FROM EmpresaCfg2  WITH (NOLOCK)  WHERE Empresa = @Empresa
SELECT  @Articulo=a.Articulo, @Cantidad=d.Cantidad,@Unidad=a.Unidad FROM GastoD d  WITH (NOLOCK)  JOIN Gasto e  WITH (NOLOCK)  ON e.ID = d.ID JOIN Concepto c  WITH (NOLOCK)  ON c.Modulo = @Modulo AND c.Concepto = d.Concepto AND c.EsInventariable = 1
JOIN Art a  WITH (NOLOCK)  ON a.Articulo = c.Articulo WHERE d.ID = @GastoID
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT InvD (
Aplica,  AplicaID,  Sucursal,  ID,     Renglon,CantidadInventario ,   RenglonSub,   RenglonID,                                            RenglonTipo,               Articulo,   Cantidad,   Unidad,   Almacen,  FechaRequerida)
SELECT @Aplica, @AplicaID, @Sucursal, @InvID, d.Renglon,@CantidadInventario, d.RenglonSub, ROW_NUMBER() OVER (ORDER BY d.Renglon, d.RenglonSub), dbo.fnRenglonTipo(a.Tipo), a.Articulo, d.Cantidad, a.Unidad, @Almacen, e.FechaRequerida
FROM GastoD d  WITH (NOLOCK)
JOIN Gasto e  WITH (NOLOCK)  ON e.ID = d.ID
JOIN Concepto c  WITH (NOLOCK)  ON c.Modulo = @Modulo AND c.Concepto = d.Concepto AND c.EsInventariable = 1
JOIN Art a  WITH (NOLOCK)  ON a.Articulo = c.Articulo
WHERE d.ID = @GastoID
UPDATE Inv  WITH (ROWLOCK)  SET RenglonID = (SELECT MAX(RenglonID) FROM InvD  WITH (NOLOCK) WHERE ID = @InvID) WHERE ID = @InvID
UPDATE GastoD  WITH (ROWLOCK)  SET InvID = @InvID WHERE ID = @ID
END
IF @InvID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @InvID, @Accion, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
SELECT @InvMovID = MovID FROM Inv  WITH (NOLOCK)  WHERE ID = @InvID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
RETURN
END

