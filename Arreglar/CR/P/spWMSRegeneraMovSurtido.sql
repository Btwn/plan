SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSRegeneraMovSurtido
@Estacion	int,
@Usuario	varchar(10)

AS
BEGIN
DECLARE
@ID			int,
@Empresa	varchar(5),
@Tarima		varchar(20),
@SerieLote	varchar(50),
@Articulo	varchar(20),
@Almacen	varchar(10),
@Posicion	varchar(10),
@Disponible float,
@CantidadA	float,
@OrigenTipo varchar(10),
@IDOrigen					int,
@MovOrigen					varchar(20),
@MovIDOrigen				varchar(20),
@SLRenglonID				float,
@SLSubCuenta				varchar(50),
@SLSerieLote				varchar(50),
@SLTarima					varchar(20),
@GenerarID					int,
@Renglon					float,
@Mov						varchar(20),
@TipoPosicion	 			varchar(20),
@PCKUbicacion	 			bit,
@Sucursal        			int,
@FechaEmision    			datetime,
@Observaciones   			varchar(100),
@Estatus         			varchar(15),
@Agente          			varchar(10),
@TarimaSurtido   			varchar(20),
@Zona                   	varchar(50),
@Referencia					varchar(50),
@SucursalDestino 			int,
@ModuloAux       			varchar(10),
@Origen          			varchar(20),
@OrigenID        			varchar(20),
@OrigenObservaciones		varchar(100),
@TarimaFechaCaducidadAux	datetime,
@PosicionOrigen				varchar(10),
@PosicionDestino			varchar(10),
@Unidad						varchar(20),
@SubCuentaAux				varchar(50),
@ModuloD					varchar(20),
@MovIDD						varchar(20),
@Ok							int,
@OkRef						varchar(255)
DECLARE @TMASurtido	AS TABLE(ID int, Articulo varchar(20), CantidadPicking float, CantidadPendiente float, CantidadUnidad float)
BEGIN TRAN
INSERT INTO @TMASurtido(ID, Articulo, CantidadPicking, CantidadPendiente, CantidadUnidad)
SELECT A.ID, C.Articulo, C.CantidadPicking, C.CantidadPendiente, C.CantidadUnidad
FROM WMSTarimaSurtido A
JOIN TMA B
ON A.ID = B.ID
JOIN TMAD C
ON A.ID = C.ID
WHERE A.Estacion = @Estacion
AND A.CantidadA > 0
GROUP BY A.ID, C.Articulo, C.CantidadPicking, C.CantidadPendiente, C.CantidadUnidad
DECLARE CrTarimas CURSOR FOR
SELECT ID, Empresa, Tarima, SerieLote, Articulo, Almacen, Posicion, Disponible, CantidadA, OrigenTipo
FROM WMSTarimaSurtido
WHERE Estacion = @Estacion
AND CantidadA > 0
ORDER BY ID, Tarima, SerieLote
OPEN CrTarimas
FETCH NEXT FROM CrTarimas INTO @ID, @Empresa, @Tarima, @SerieLote, @Articulo, @Almacen, @Posicion, @Disponible, @CantidadA, @OrigenTipo
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Mov = NULL
IF NOT EXISTS(SELECT * FROM Art WHERE Articulo = @Articulo AND Tipo IN ('Serie','Lote') )
SELECT @SerieLote = ''
IF @OrigenTipo = 'VTAS'
SELECT @IDOrigen = B.ID,
@MovOrigen = B.Mov,
@MovIDOrigen = B.MovID
FROM TMA A
JOIN Venta B
ON LTRIM(RTRIM(A.Origen))   = LTRIM(RTRIM(B.Mov))
AND LTRIM(RTRIM(A.OrigenID)) = LTRIM(RTRIM(B.MovID))
AND A.Empresa = B.Empresa
AND A.Sucursal = B.Sucursal
WHERE A.ID = @ID
IF @OrigenTipo = 'COMS'
SELECT @IDOrigen = B.ID,
@MovOrigen = B.Mov,
@MovIDOrigen = B.MovID
FROM TMA A
JOIN Compra B
ON LTRIM(RTRIM(A.Origen))   = LTRIM(RTRIM(B.Mov))
AND LTRIM(RTRIM(A.OrigenID)) = LTRIM(RTRIM(B.MovID))
AND A.Empresa = B.Empresa
AND A.Sucursal = B.Sucursal
WHERE A.ID = @ID
IF @OrigenTipo = 'INV'
SELECT @IDOrigen = B.ID,
@MovOrigen = B.Mov,
@MovIDOrigen = B.MovID
FROM TMA A
JOIN Inv B
ON LTRIM(RTRIM(A.Origen))   = LTRIM(RTRIM(B.Mov))
AND LTRIM(RTRIM(A.OrigenID)) = LTRIM(RTRIM(B.MovID))
AND A.Empresa = B.Empresa
AND A.Sucursal = B.Sucursal
WHERE A.ID = @ID
SELECT @PCKUbicacion = WMSPCKUbicacion FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TarimaFechaCaducidadAux = FechaCaducidad FROM Tarima WHERE Tarima = @Tarima
SELECT @TipoPosicion = Tipo,
@Zona		 = Zona
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @Posicion
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
IF (@TipoPosicion = 'Ubicacion' AND @Disponible = @CantidadA) OR (@TipoPosicion = 'Cross Docking')
BEGIN
SELECT @Mov = Mov
FROM MovTipo
WHERE Modulo = 'TMA'
AND RTRIM(LTRIM(Clave)) = 'TMA.OSUR'
AND ISNULL(SubClave,'') = ''
END
/*****     PCK TARIMA COMPLETA     *****/
IF @TipoPosicion = 'Ubicacion' AND @Disponible > @CantidadA AND @PCKUbicacion = 1
BEGIN
SELECT @Mov = Mov
FROM MovTipo
WHERE Modulo = 'TMA'
AND RTRIM(LTRIM(Clave)) = 'TMA.OPCKTARIMA'
AND ISNULL(SubClave,'') = ''
END
IF @Mov IS NOT NULL
BEGIN
SELECT @Sucursal        	  = T.Sucursal,
@FechaEmision    	  = dbo.fnFechaSinHora(GETDATE()),
@Observaciones   	  = 'Herramienta',
@Estatus         	  = 'SINAFECTAR',
@Agente          	  = T.Agente,
@TarimaSurtido   	  = T.TarimaSurtido,
@Referencia			  = T.Referencia,
@SucursalDestino 	  = T.SucursalFiltro,
@ModuloAux       	  = T.OrigenTipo,
@Origen          	  = T.Origen,
@OrigenID        	  = T.OrigenID,
@OrigenObservaciones	  = T.OrigenObservaciones,
@PosicionOrigen		  = TD.Posicion,
@PosicionDestino  	  = TD.PosicionDestino,
@Unidad   			  = TD.Unidad,
@SubCuentaAux		  = TD.SubCuenta
FROM TMA T
JOIN TMAD TD ON T.ID = TD.ID
WHERE T.ID = @ID
INSERT TMA (Empresa, Sucursal, Usuario, Mov, FechaEmision, Estatus, Almacen, Agente, Zona, Observaciones, TarimaSurtido, Prioridad, Referencia, SucursalFiltro, OrigenTipo, Origen, OrigenID, OrigenObservaciones)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @TarimaSurtido, 'Normal', @Referencia, @SucursalDestino, @ModuloAux, @Origen, @OrigenID, @OrigenObservaciones)
SET @GenerarID = @@IDENTITY
SET @Renglon = 2048
INSERT TMAD (ID,         Sucursal, Renglon, Tarima, Almacen, Posicion, PosicionDestino, CantidadPicking,
Zona,       Prioridad, Montacarga, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo,
SubCuenta,  FechaCaducidad)
VALUES      (@GenerarID, @Sucursal, @Renglon, @Tarima, @Almacen, @PosicionOrigen, @PosicionDestino, @CantidadA,
@Zona,     'Normal', @Agente, 1,   0,  @Unidad, @CantidadA, @Articulo,
@SubCuentaAux, @TarimaFechaCaducidadAux)
IF @SerieLote <> ''
BEGIN
SELECT @SLSubCuenta = ISNULL(SubCuenta,''),
@SLSerieLote = SerieLote,
@SLTarima    = Tarima
FROM SerieLoteMov
WHERE ID = @ID
AND Articulo = @Articulo
UPDATE SerieLoteMov SET Cantidad = Cantidad - @CantidadA
WHERE Modulo = 'TMA'
AND ID = @ID
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = @SLSubCuenta
AND SerieLote = @SLSerieLote
AND Empresa = @Empresa
AND Tarima = @SLTarima
UPDATE SerieLoteMov SET Cantidad = Cantidad - @CantidadA
WHERE Modulo = @OrigenTipo
AND ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = @SLSubCuenta
AND SerieLote = @SLSerieLote
AND Empresa = @Empresa
AND Tarima = @TarimaSurtido
DELETE FROM SerieLoteMov
WHERE Modulo = @OrigenTipo
AND ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = @SLSubCuenta
AND SerieLote = @SLSerieLote
AND Empresa = @Empresa
AND Tarima = @SLTarima
AND Cantidad = 0
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,
Cantidad, Tarima, AsignacionUbicacion)
VALUES              (@Empresa, @Sucursal, 'TMA', @GenerarID, @Renglon, @Articulo, ISNULL(@SubCuentaAux,''), @SerieLote,
@CantidadA, @Tarima, 0)
IF EXISTS(SELECT *
FROM SerieLoteMov
WHERE Modulo = @OrigenTipo
AND ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND SerieLote = @SerieLote
AND Empresa = @Empresa
AND Tarima = @TarimaSurtido)
UPDATE SerieLoteMov SET Cantidad = Cantidad + @CantidadA
WHERE Modulo = @OrigenTipo
AND ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND SerieLote = @SerieLote
AND Empresa = @Empresa
AND Tarima = @TarimaSurtido
IF NOT EXISTS(SELECT *
FROM SerieLoteMov
WHERE Modulo = @OrigenTipo
AND ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND SerieLote = @SerieLote
AND Empresa = @Empresa
AND Tarima = @TarimaSurtido)
BEGIN
IF @OrigenTipo = 'VTAS'
SELECT @SLRenglonID = RenglonID
FROM VentaD
WHERE ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaAux,'')
IF @OrigenTipo = 'INV'
SELECT @SLRenglonID = RenglonID
FROM InvD
WHERE ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaAux,'')
IF @OrigenTipo = 'COMS'
SELECT @SLRenglonID = RenglonID
FROM CompraD
WHERE ID = @IDOrigen
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuentaAux,'')
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta, SerieLote,
Cantidad, Tarima, AsignacionUbicacion)
VALUES (@Empresa, @Sucursal, @OrigenTipo, @IDOrigen, @SLRenglonID, @Articulo, ISNULL(@SubCuentaAux,''), @SerieLote,
@CantidadA, @TarimaSurtido, 0)
END
END
UPDATE @TMASurtido
SET CantidadPicking = CantidadPicking - @CantidadA,
CantidadPendiente = CantidadPendiente - @CantidadA,
CantidadUnidad = CantidadUnidad - @CantidadA
WHERE ID = @ID
AND Articulo = @Articulo
AND CantidadPicking > 0
IF EXISTS(SELECT *
FROM @TMASurtido A
JOIN TMA B ON A.ID = B.ID
JOIN TMAD C ON A.ID = C.ID
AND A.Articulo = C.Articulo
WHERE A.ID = @ID
AND A.CantidadPicking = 0)
BEGIN
UPDATE C SET C.CantidadPicking	 = A.CantidadPicking,
C.CantidadPendiente = A.CantidadPendiente,
C.CantidadUnidad    = A.CantidadUnidad
FROM @TMASurtido A
JOIN TMA B
ON A.ID = B.ID
JOIN TMAD C
ON A.ID = C.ID
AND A.Articulo = C.Articulo
WHERE A.ID = @ID
EXEC spAfectar 'TMA', @ID, 'CANCELAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF EXISTS(SELECT * FROM @TMASurtido A WHERE A.ID = @ID AND Articulo = @Articulo AND A.CantidadPicking > 0)
UPDATE C
SET C.CantidadPicking	= A.CantidadPicking,
C.CantidadPendiente	= A.CantidadPendiente,
C.CantidadUnidad		= A.CantidadUnidad
FROM @TMASurtido A
JOIN TMA B
ON A.ID = B.ID
JOIN TMAD C
ON A.ID = C.ID
AND A.Articulo = C.Articulo
WHERE A.ID = @ID
AND A.CantidadPicking > 0
EXEC spAfectar 'TMA', @GenerarID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ModuloD = 'TMA', @MovIDD = MovID FROM TMA WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @OrigenTipo, @IDOrigen, @MovOrigen, @MovIDOrigen, @ModuloD, @GenerarID, @Mov, @MovIDD, @Ok OUTPUT
END
END
FETCH NEXT FROM CrTarimas INTO @ID, @Empresa, @Tarima, @SerieLote, @Articulo, @Almacen, @Posicion, @Disponible, @CantidadA, @OrigenTipo
END
CLOSE CrTarimas
DEALLOCATE CrTarimas
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
END

