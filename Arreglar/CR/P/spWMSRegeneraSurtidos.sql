SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSRegeneraSurtidos
@Estacion	int,
@Usuario	varchar(10)

AS
BEGIN
DECLARE
@CrID				int,
@CrEmpresa			varchar(5),
@CrModulo			varchar(20),
@CrModuloID			int,
@CrArticulo			varchar(20),
@CrAlmacen			varchar(10),
@CrSubCuenta		varchar(20),
@CrTarima			varchar(20),
@CrSerieLote		varchar(50),
@CrDisponible		float,
@CrCantidadA		float,
@PCKUbicacion	 			bit,
@Mov						varchar(20),
@TipoPosicion	 			varchar(20),
@TarimaSurtido   			varchar(20),
@Sucursal        			int,
@FechaEmision    			datetime,
@Estatus         			varchar(15),
@Observaciones   			varchar(100),
@Referencia					varchar(50),
@SucursalDestino 			int,
@ModuloAux       			varchar(10),
@ModuloIDAux       			int,
@Origen          			varchar(20),
@OrigenID        			varchar(20),
@GenerarID					int,
@PosicionOrigen				varchar(10),
@PosicionDestino			varchar(10),
@TarimaFechaCaducidadAux	datetime,
@Zona                   	varchar(50),
@OrigenObservaciones		varchar(100),
@SubCuentaAux				varchar(50),
@RenglonID					int,
@Unidad						varchar(20),
@ModuloD          			varchar(20),
@MovIDD          			varchar(20),
@Ok							int,
@OkRef						varchar(255)
DECLARE @SerieLoteMov AS TABLE (Empresa				varchar(5),
Modulo				varchar(5),
Sucursal			int,
ID					int,
RenglonID			int,
Articulo			varchar(20),
SubCuenta			varchar(50),
SerieLote			varchar(50),
Tarima				varchar(20),
Cantidad			float,
AsignacionUbicacion	bit default 0
)
BEGIN TRAN
DECLARE CrTarimas CURSOR FOR
SELECT ID, Empresa, Modulo, ModuloID, Articulo, Almacen,
SubCuenta, Tarima, SerieLote, Disponible, CantidadA
FROM WMSTarimaDisponible
WHERE Estacion = @Estacion
AND CantidadA > 0
ORDER BY ID, Tarima, SerieLote
OPEN CrTarimas
FETCH NEXT FROM CrTarimas INTO @CrID, @CrEmpresa, @CrModulo, @CrModuloID, @CrArticulo, @CrAlmacen,
@CrSubCuenta, @CrTarima, @CrSerieLote, @CrDisponible, @CrCantidadA
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Mov = NULL
IF NOT EXISTS(SELECT * FROM Art WHERE Articulo = @CrArticulo AND Tipo IN ('Serie','Lote') )
SELECT @CrSerieLote = ''
SELECT @PCKUbicacion = WMSPCKUbicacion FROM EmpresaCfg WHERE Empresa = @CrEmpresa
SELECT @TarimaFechaCaducidadAux = FechaCaducidad FROM Tarima WHERE Tarima = @CrTarima
SELECT @TipoPosicion	= A.Tipo,
@Zona			= A.Zona,
@PosicionOrigen	= A.Posicion
FROM AlmPos A
JOIN Tarima B
ON A.Posicion = B.Posicion
AND A.Almacen = B.Almacen
WHERE A.Almacen = @CrAlmacen
AND B.Tarima = @CrTarima
SELECT @TarimaSurtido = Tarima,
@ModuloAux = Modulo,
@Origen = Mov,
@OrigenID = MovID,
@RenglonID = RenglonID,
@ModuloIDAux = ModuloID
FROM WMSPedidosSinSurtir
WHERE ID = @CrID
AND Articulo = @CrArticulo
IF @CrModulo = 'VTAS'
SELECT @Sucursal = A.Sucursal,
@FechaEmision = dbo.fnFechaSinHora(GETDATE()),
@Estatus = 'SINAFECTAR',
@Observaciones = 'Herramienta',
@Referencia = 'Sucursal Destino '+CAST(ISNULL(E.Sucursal,A.Sucursal) AS VARCHAR(5)),
@SucursalDestino = ISNULL(E.Sucursal,A.Sucursal),
@OrigenObservaciones = A.Observaciones,
@PosicionDestino = CASE ISNULL(C.WMSAndenSurtidoContacto,0)
WHEN 1
THEN ISNULL(NULLIF(D.DefPosicionSurtido,''),ISNULL(A.PosicionWMS, B.DefPosicionSurtido))
ELSE ISNULL(A.PosicionWMS, B.DefPosicionSurtido)
END
FROM Venta A
JOIN Alm B
ON A.Almacen = B.Almacen
JOIN EmpresaCfg C
ON A.Empresa = C.Empresa
LEFT JOIN Cte D
ON A.Cliente = D.Cliente
LEFT JOIN Alm E
ON A.AlmacenDestino = E.Almacen
WHERE ID = @CrModuloID
IF @CrModulo = 'COMS'
SELECT @Sucursal = A.Sucursal,
@FechaEmision = dbo.fnFechaSinHora(GETDATE()),
@Estatus = 'SINAFECTAR',
@Observaciones = 'Herramienta',
@Referencia = 'Sucursal Destino '+CAST(ISNULL(E.Sucursal, A.Sucursal) AS VARCHAR(5)),
@SucursalDestino = ISNULL(E.Sucursal,A.Sucursal),
@OrigenObservaciones = A.Observaciones,
@PosicionDestino = CASE ISNULL(C.WMSAndenSurtidoContacto,0)
WHEN 1
THEN ISNULL(NULLIF(D.DefPosicionSurtido,''),ISNULL(A.PosicionWMS, B.DefPosicionSurtido))
ELSE ISNULL(A.PosicionWMS, B.DefPosicionSurtido)
END
FROM Compra A
JOIN Alm B
ON A.Almacen = B.Almacen
JOIN EmpresaCfg C
ON A.Empresa = C.Empresa
LEFT JOIN Cte D
ON A.Cliente = D.Cliente
LEFT JOIN Alm E
ON A.Almacen = E.Almacen
WHERE A.ID = @CrModuloID
IF @CrModulo = 'INV'
SELECT @Sucursal = A.Sucursal,
@FechaEmision = dbo.fnFechaSinHora(GETDATE()),
@Estatus = 'SINAFECTAR',
@Observaciones = 'Herramienta de Resurtido',
@Referencia = 'Sucursal Destino '+CAST(ISNULL(C.Sucursal,A.Sucursal) AS VARCHAR(5)),
@SucursalDestino = ISNULL(C.Sucursal,A.Sucursal),
@OrigenObservaciones = A.Observaciones,
@PosicionDestino = ISNULL(A.PosicionWMS, B.DefPosicionSurtido)
FROM Inv A
JOIN Alm B
ON A.AlmacenDestino = B.Almacen
LEFT JOIN Alm C
ON A.AlmacenDestino = C.Almacen
WHERE A.ID = @CrModuloID
/*****     PCK NORMAL     *****/
IF @TipoPosicion = 'Domicilio'
BEGIN
SELECT @Mov = Mov
FROM MovTipo
WHERE Modulo = 'TMA'
AND RTRIM(LTRIM(Clave)) = 'TMA.OSUR'
AND SubClave = 'TMA.OSURP'
END
/*****     SURTIDO NORMAL     *****/
IF (@TipoPosicion = 'Ubicacion' AND @CrDisponible = @CrCantidadA) OR (@TipoPosicion = 'Cross Docking')
BEGIN
SELECT @Mov = Mov
FROM MovTipo
WHERE Modulo = 'TMA'
AND RTRIM(LTRIM(Clave)) = 'TMA.OSUR'
AND ISNULL(SubClave,'') = ''
END
/*****     PCK TARIMA COMPLETA     *****/
IF @TipoPosicion = 'Ubicacion' AND @CrDisponible > @CrCantidadA AND @PCKUbicacion = 1
BEGIN
SELECT @Mov = Mov
FROM MovTipo
WHERE Modulo = 'TMA'
AND RTRIM(LTRIM(Clave)) = 'TMA.OPCKTARIMA'
AND ISNULL(SubClave,'') = ''
END
IF @Mov IS NOT NULL
BEGIN
INSERT TMA (Empresa, Sucursal, Usuario, Mov, FechaEmision, Estatus, Almacen, Zona, Observaciones,
TarimaSurtido, Prioridad, Referencia, SucursalFiltro, OrigenTipo, Origen, OrigenID, OrigenObservaciones)
VALUES     (@CrEmpresa, @Sucursal, @Usuario, @Mov, @FechaEmision, @Estatus, @CrAlmacen, @Zona, @Observaciones,
@TarimaSurtido, 'Normal', @Referencia, @SucursalDestino, @ModuloAux, @Origen, @OrigenID, @OrigenObservaciones)
SET @GenerarID = @@IDENTITY
INSERT TMAD (ID, Sucursal, Renglon, Tarima, Almacen, Posicion, PosicionDestino, CantidadPicking, Zona,
Prioridad, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad)
VALUES      (@GenerarID, @Sucursal, 2048, @CrTarima, @CrAlmacen, @PosicionOrigen, @PosicionDestino, @CrCantidadA, @Zona,
'Normal', 1,  0,         @Unidad, @CrCantidadA, @CrArticulo, @CrSubCuenta, @TarimaFechaCaducidadAux)
/**********************     SERIE / LOTE     **************************/
IF @Ok IS NULL AND @CrSerieLote <> ''
BEGIN
INSERT SerieLoteMov(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo, SubCuenta,
SerieLote, Cantidad, Tarima, AsignacionUbicacion)
VALUES (@CrEmpresa, @Sucursal, 'TMA', @GenerarID, 2048, @CrArticulo, ISNULL(@CrSubCuenta,''),
@CrSerieLote, @CrCantidadA, @CrTarima, 0)
IF NOT EXISTS(SELECT *
FROM @SerieLoteMov
WHERE Empresa = @CrEmpresa
AND Modulo = @ModuloAux
AND ID = @CrID
AND RenglonID = @RenglonID
AND Articulo = @CrArticulo
AND SubCuenta = @CrSubCuenta
AND SerieLote = @CrSerieLote
AND Tarima = @TarimaSurtido)
INSERT @SerieLoteMov(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo, SubCuenta,
SerieLote, Cantidad, Tarima, AsignacionUbicacion)
VALUES (@CrEmpresa, @Sucursal, @ModuloAux, @ModuloIDAux, @RenglonID, @CrArticulo, ISNULL(@CrSubCuenta,''),
@CrSerieLote, @CrCantidadA, @TarimaSurtido, 0)
IF EXISTS (SELECT *
FROM @SerieLoteMov
WHERE Empresa = @CrEmpresa
AND Modulo = @ModuloAux
AND ID = @CrID
AND RenglonID = @RenglonID
AND Articulo = @CrArticulo
AND SubCuenta = @CrSubCuenta
AND SerieLote = @CrSerieLote
AND Tarima = @TarimaSurtido)
UPDATE @SerieLoteMov SET Cantidad = Cantidad + @CrCantidadA
WHERE Empresa = @CrEmpresa
AND Modulo = @ModuloAux
AND ID = @ModuloIDAux
AND RenglonID = @RenglonID
AND Articulo = @CrArticulo
AND SubCuenta = @CrSubCuenta
AND SerieLote = @CrSerieLote
AND Tarima = @TarimaSurtido
DELETE FROM SerieLoteMov WHERE Modulo = @ModuloAux AND ID = @ModuloIDAux
END
/***********************************************************************/
EXEC spAfectar 'TMA', @GenerarID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ModuloD = 'TMA', @MovIDD = MovID FROM TMA WHERE ID = @GenerarID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @CrEmpresa, @ModuloAux, @CrModuloID, @Origen, @OrigenID, @ModuloD, @GenerarID, @Mov, @MovIDD, @Ok OUTPUT
END
END
FETCH NEXT FROM CrTarimas INTO @CrID, @CrEmpresa, @CrModulo, @CrModuloID, @CrArticulo, @CrAlmacen,
@CrSubCuenta, @CrTarima, @CrSerieLote, @CrDisponible, @CrCantidadA
END
CLOSE CrTarimas
DEALLOCATE CrTarimas
INSERT SerieLoteMov(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo, SubCuenta,
SerieLote, Cantidad, Tarima, AsignacionUbicacion)
SELECT Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo, SubCuenta,
SerieLote, Cantidad, Tarima, AsignacionUbicacion
FROM @SerieLoteMov
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
END

