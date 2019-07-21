SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAReacomodoSolicitar
@ID                	int,
@Estacion			int,
@IDOrigen			int,
@Accion				char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             	varchar(20)	OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      	datetime,
@FechaAfectacion     datetime,
@FechaConclusion		datetime,
@Proyecto	      	varchar(50),
@Usuario	      		char(10),
@Autorizacion      	char(10),
@DocFuente	      	int,
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      		int,
@MovUsuario			char(10),
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@Ok                	int				OUTPUT,
@OkRef             	varchar(255)	OUTPUT,
@TarimaEsp			varchar(20)		= NULL,
@PosicionEsp			varchar(10)		= NULL,
@ArticuloEsp			varchar(20)		= NULL,
@IDDestino		    int             = NULL OUTPUT,
@SucursalFiltro		int             = NULL

AS
BEGIN
DECLARE @Articulo			varchar(20),
@Almacen			varchar(10),
@Ordenes			float,
@CantidadTarima	float,
@Disponible		float,
@Contador			bit,
@Tipo             varchar(20),
@Resultado        float,
@Unidad			varchar(50),
@MinimoTarima     float,
@Tarima           varchar(20),
@CantidadUnidad   float,
@DisponibleTarima	float,
@PosicionOrigen   varchar(10),
@PosicionDestino  varchar(10),
@ControlArticulo  varchar(20),
@TarimasReacomodar int,
@TarimaSurtido	varchar(20),
@Renglon          float,          
@Reacomodar		int,
@TarimaN			varchar(20),
@MovDestino       varchar(20),
@MovDestinoID     varchar(20),
@AlmacenCursor	varchar(10),
@Prioridad		varchar(10),    
@SubCuenta        varchar(50)     
DECLARE @TarimaDisp TABLE(Tarima varchar(20))
IF @Accion = 'AFECTAR'
BEGIN
SELECT @AlmacenCursor = Almacen FROM TMA WHERE ID = @ID
IF @ArticuloEsp IS NULL
SELECT @Prioridad = 'Media'
ELSE
SELECT @Prioridad = 'Alta'
DECLARE crDisponible CURSOR LOCAL STATIC FOR
SELECT a.Articulo, d.Almacen, ap.Tipo, /*SUM(d.CantidadPicking)*/0 Cantidad, d.Unidad, d.CantidadUnidad, d.SubCuenta 
FROM TMAD d
JOIN TMA t ON d.ID = t.ID
JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND d.Almacen = a.Almacen AND t.Empresa = a.Empresa
JOIN Tarima ta ON ta.Tarima = a.Tarima
JOIN AlmPos ap ON ta.Almacen = ap.Almacen AND ta.Posicion = ap.Posicion AND a.Articulo = ap.ArticuloEsp
WHERE d.ID = @IDOrigen
AND Tipo = 'Domicilio'
AND a.Articulo = ISNULL(@ArticuloEsp, a.Articulo)
AND a.Tarima = ISNULL(@TarimaEsp, a.Tarima)
AND ap.Posicion = ISNULL(@PosicionEsp, ap.Posicion)
AND a.Empresa = @Empresa
AND ap.Almacen = @AlmacenCursor
GROUP BY a.Articulo, d.Almacen, ap.Tipo, d.Unidad, d.CantidadUnidad, d.SubCuenta 
OPEN crDisponible
FETCH NEXT FROM crDisponible INTO @Articulo, @Almacen, @Tipo, @CantidadTarima, @Unidad, @CantidadUnidad, @SubCuenta 
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Ordenes = 0
DECLARE crMinimo CURSOR LOCAL FOR
SELECT SUM(d.Disponible) Disponible, ISNULL(a.MinimoTarima, 0),
CASE @ArticuloEsp WHEN NULL THEN SUM(d.Disponible) - @CantidadTarima - @Ordenes ELSE 0 END Resultado
FROM ArtDisponibleTarima d
JOIN Tarima t ON d.Tarima = t.Tarima
JOIN AlmPos p ON t.Almacen = p.Almacen AND p.Posicion = t.Posicion AND p.ArticuloEsp = d.Articulo
JOIN Art a ON d.Articulo = a.Articulo
WHERE p.Tipo = @Tipo
AND d.Articulo = @Articulo
AND t.Estatus = 'ALTA'
AND p.Estatus = 'ALTA'
GROUP BY d.Articulo, ISNULL(a.MinimoTarima, 0)
OPEN crMinimo
FETCH NEXT FROM crMinimo INTO @Disponible, @MinimoTarima, @Resultado
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Contador = 0
IF @Resultado < @MinimoTarima
BEGIN
SELECT @Tarima = NULL, @DisponibleTarima = NULL, @PosicionOrigen = NULL
SELECT @ControlArticulo = ControlArticulo FROM Art WHERE Articulo = @Articulo
SELECT TOP 1 @PosicionDestino = Posicion FROM AlmPos WHERE ArticuloEsp = @Articulo AND Tipo = @Tipo AND Almacen = @Almacen
IF @Contador = 0
SELECT @Resultado = @Resultado + ISNULL(SUM(ISNULL(a.Disponible,0)),0)
FROM TMA t
JOIN TMAD d on t.id = d.id
JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND a.Articulo = @Articulo AND a.Almacen = @Almacen
JOIN MovTipo m ON m.Mov = t.Mov AND m.Modulo = 'TMA'
WHERE m.Clave = 'TMA.SRADO'
AND t.Estatus = 'PENDIENTE'
AND d.PosicionDestino = @PosicionDestino
AND a.Empresa = @Empresa
IF @Resultado < @MinimoTarima
BEGIN
SELECT @Mov = TMASolicitudReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SELECT @TarimasReacomodar = ISNULL(TarimasReacomodar,0) FROM Art WHERE Articulo = @Articulo
IF ISNULL(@TarimasReacomodar,0) = 0
SET @TarimasReacomodar = 1
INSERT TMA (Empresa,  Sucursal,  Usuario,  Mov,  FechaEmision,  Estatus,      Almacen,  TarimaSurtido,  Prioridad, Referencia,               Observaciones,                                                                                    SucursalFiltro,  SucursalDestino)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, 'SINAFECTAR', @Almacen, @TarimaSurtido, @Prioridad, 'Herramienta de Surtido', CASE @ArticuloEsp WHEN NULL THEN NULL ELSE 'Patinero - Domicilio con Existencia Incorrecta' END, @SucursalFiltro, @SucursalDestino)
SET @IDDestino = @@IDENTITY
SET @Renglon = 2048
SET @Reacomodar = 1
IF @Reacomodar <= @TarimasReacomodar 
BEGIN
SELECT TOP 1
@Tarima		   = A.Tarima,
@Disponible	   = A.Disponible - ISNULL(D.Apartado,0),
@PosicionOrigen = B.Posicion
FROM ArtDisponibleTarima A
JOIN Tarima B ON A.Tarima = B.Tarima
JOIN AlmPos C ON B.Almacen = C.Almacen AND ISNULL(B.Posicion,C.Posicion) = C.Posicion AND C.Tipo <> 'Surtido'
LEFT JOIN ArtApartadoTarima D ON A.Empresa = D.Empresa AND A.Articulo = D.Articulo AND A.Almacen = D.Almacen AND A.Tarima = D.Tarima
WHERE A.Articulo = @Articulo
AND A.Tarima NOT IN (SELECT Tarima
FROM WMSSurtidoProcesarD
WHERE Estacion = @Estacion
AND Procesado = 1
AND Articulo IN (SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (PosicionDestino IS NOT NULL AND PosicionDestino <> '')
AND NULLIF(SubCuenta,'') IS NULL
AND Tarima NOT IN (SELECT Tarima FROM @TarimaDisp)
)
AND A.Tarima NOT IN (SELECT DISTINCT d.Tarima FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo m ON t.Mov = m.Mov AND m.Modulo = 'TMA'
WHERE t.Estatus IN ('PENDIENTE', 'PROCESAR')
AND m.Clave NOT IN ('TMA.OADO', 'TMA.ORADO', 'TMA.SADO', 'TMA.SRADO', 'TMA.ADO', 'TMA.RADO')
)
AND C.Tipo = 'Ubicacion'
AND A.Almacen = @Almacen
AND A.Disponible - ISNULL(D.Apartado,0) > 0
AND B.Estatus = 'ALTA'
AND A.Empresa = @Empresa
ORDER BY B.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, B.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, B.Alta)
ELSE B.Posicion
END, A.Tarima ASC
INSERT @TarimaDisp (Tarima) VALUES (@Tarima)
IF @Tarima IS NOT NULL AND @Ok IS NULL
BEGIN
INSERT TMAD (ID,         Sucursal,  Renglon,  Tarima,                   Almacen,  Posicion,        PosicionDestino,  CantidadPicking,  Prioridad,  EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta) 
SELECT       @IDDestino, @Sucursal, @Renglon, ISNULL(@TarimaN,@Tarima), @Almacen, @PosicionOrigen, @PosicionDestino, @Disponible,     @Prioridad,  1,             0,         @Unidad, @Disponible,    @Articulo, @SubCuenta 
SET @Renglon = @Renglon + 2048
END
SET @Reacomodar = ISNULL(@Reacomodar,0) + 1
END
IF @Ok IS NULL AND @IDDestino IS NOT NULL AND EXISTS (SELECT * FROM TMAD WHERE ID = @IDDestino) AND @Tarima IS NOT NULL
BEGIN
EXEC spAfectar 'TMA', @IDDestino, 'Afectar', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM TMA WHERE ID = @IDDestino
EXEC spMovFlujo @Sucursal, Afectar, @Empresa, 'TMA', @ID, @Mov, @MovID, 'TMA', @IDDestino, @MovDestino, @MovDestinoID, @Ok OUTPUT
END
ELSE
DELETE TMA WHERE ID = @IDDestino
SELECT @Resultado = @Resultado + ISNULL(@DisponibleTarima,0)
SELECT @Contador = 1
END
IF @Tarima IS NULL
SELECT @Resultado = @MinimoTarima
END
FETCH NEXT FROM crMinimo INTO @Disponible, @MinimoTarima, @Resultado
END
CLOSE crMinimo
DEALLOCATE crMinimo
FETCH NEXT FROM crDisponible INTO @Articulo, @Almacen, @Tipo, @CantidadTarima, @Unidad, @CantidadUnidad, @SubCuenta 
END
CLOSE crDisponible
DEALLOCATE crDisponible
END
RETURN
END

