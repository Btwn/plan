SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE SPDesentarimarSurtidoPedido
@ID            int,
@Empresa	      varchar(5),
@Estacion      int,
@Usuario       varchar(10)

AS BEGIN
DECLARE @IDGenerar      int,
@FechaEmision   datetime,
@Mov            varchar(20),
@MovID          varchar(20),
@MovGenerar     varchar(20),
@Modulo         varchar(5),
@ModuloGenerar  varchar(5),
@Clave          varchar(20),
@Subclave       varchar(20),
@Moneda         varchar(10),
@TipoCambio     float,
@Estatus        varchar(15),
@Almacen        varchar(10),
@Agente	        varchar(10),
@PosocionRec    varchar(10),
@PosocionSur    varchar(10),
@PosocionCD     varchar(10),
@CrossDocking   bit,
@Directo        bit,
@Sucursal       int,
@Articulo       varchar(20),
@Cantidad       float,
@Renglon        float,
@RenglonSub     int,
@RenglonIDD     int,
@RenglonID      int,
@RenglonTipo    varchar(1),
@Unidad	        varchar(50),
@Factor	        float,
@Tarima	        varchar(20),
@Disponible	    float,
@Apartado       float,
@Posicion       varchar(10),
@Accion         varchar(20),
@Base           varchar(20),
@EnSilencio     bit,
@OK             int
SELECT @FechaEmision  = GETDATE(),
@Modulo        = 'VTAS',
@ModuloGenerar = 'INV',
@Clave         = 'INV.T',
@Subclave      = 'INV.TMA',
@Estatus       = 'SINAFECTAR',
@CrossDocking  = 0,
@Directo       = 1,
@RenglonSub    = 0,
@RenglonTipo   = 'L',
@RenglonID     = 1,
@Accion        = 'AFECTAR',
@Base          = 'Todo',
@EnSilencio    = 1
SELECT @MovGenerar = Mov FROM MovTipo WHERE Modulo = @ModuloGenerar AND Clave = @Clave AND Subclave = @Subclave
SELECT @Mov        = Mov,
@MovID      = MovID,
@Moneda     = Moneda,
@TipoCambio = TipoCambio,
@Almacen    = Almacen,
@Agente     = Agente,
@Sucursal   = Sucursal
FROM Venta
WHERE ID = @ID
SELECT @PosocionRec = DefPosicionRecibo,
@PosocionSur = DefPosicionSurtido,
@PosocionCD  = Defposicioncrossdocking
FROM Alm
WHERE Almacen = @Almacen
INSERT Inv
(Empresa,
Mov,
FechaEmision,
Moneda,
TipoCambio,
Estatus,
Directo,
RenglonID,
Almacen,
AlmacenDestino,
Vencimiento,
Usuario,
UltimoCambio,
OrigenTipo,
Origen,
OrigenID,
FechaRequerida,
Sucursal,
SucursalOrigen,
Agente,
SubModulo,
PosicionWMS,
PosicionDWMS,
CrossDocking
)
VALUES
(@Empresa,
@MovGenerar,
@FechaEmision,
@Moneda,
@TipoCambio,
@Estatus,
@Directo,
@RenglonID,
@Almacen,
@Almacen,
@FechaEmision,
@Empresa,
@FechaEmision,
@Modulo,
@Mov,
@MovID,
@FechaEmision,
@Sucursal,
@Sucursal,
@Agente,
@ModuloGenerar,
@PosocionSur,
@PosocionRec,
@CrossDocking
)
SELECT @IDGenerar = @@IDENTITY
DECLARE crArtVtas CURSOR FOR
SELECT Articulo, SUM(Cantidad)
FROM VentaD
WHERE ID = @ID
GROUP BY Articulo
OPEN crArtVtas
FETCH NEXT FROM crArtVtas INTO @Articulo, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Renglon    =  ISNULL(@Renglon,0) + 2048
SELECT @RenglonIDD =  ISNULL(@RenglonIDD,0) + 1
SELECT @Unidad     = Unidad,
@Factor     = Factor,
@Tarima     = ISNULL(Tarima,'')
FROM VentaD
WHERE ID = @ID
AND Articulo = @Articulo
SELECT @Disponible = Disponible,
@Apartado   = Apartado
FROM ArtDisponibleTarima
WHERE Empresa  = @Empresa
AND Articulo = @Articulo
AND Almacen  = @Almacen
AND Tarima   = @Tarima
AND Disponible > 0
SELECT @Posicion = Posicion FROM Tarima WHERE Tarima = @Tarima
IF @Tarima = ''
SELECT @OK = 1
IF @Tarima <> '' AND ROUND(ISNULL(@Disponible,0),3) = ROUND(@Cantidad,3)
BEGIN
INSERT InvD
(ID,
Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
Almacen,
Articulo,
Cantidad,
Unidad,
Factor,
CantidadInventario,
FechaRequerida,
Sucursal,
SucursalOrigen,
Tarima,
PosicionActual,
PosicionReal
)
VALUES
(@IDGenerar,
@Renglon,
@RenglonSub,
@RenglonIDD,
@RenglonTipo,
@Almacen,
@Articulo,
@Cantidad,
@Unidad,
@Factor,
@Cantidad,
@FechaEmision,
@Sucursal,
@Sucursal,
@Tarima,
@Posicion,
@Posicion
)
END
FETCH NEXT FROM crArtVtas INTO @Articulo, @Cantidad
END
CLOSE crArtVtas
DEALLOCATE crArtVtas
/* Se elimina el movimiento por que no encontro Tarima */
IF @OK = 1
BEGIN
DELETE Inv WHERE ID = @IDGenerar
DELETE InvD WHERE ID = @IDGenerar
END
ELSE
BEGIN
IF NOT EXISTS (SELECT * FROM InvD WHERE ID = @IDGenerar)
DELETE Inv WHERE ID = @IDGenerar
ELSE
EXEC spAfectar @ModuloGenerar, @IDGenerar, @Accion, @Base, NULL, @Usuario, @EnSilencio = @EnSilencio, @Estacion = @Estacion
END
END

