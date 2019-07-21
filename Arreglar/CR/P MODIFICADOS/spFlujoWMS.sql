SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFlujoWMS
@Modulo				varchar(5),
@ID               	int,
@Accion				varchar(20),
@Empresa          	varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@Almacen			varchar(10),
@FechaEmision		datetime,
@Proyecto	      	varchar(50),
@Tarima				varchar(20),
@Articulo			varchar(20),
@Ok               	int           	OUTPUT,
@OkRef            	varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@PosicionActual                     varchar(10),
@PosicionReal                       varchar(10)
IF @MovTipo = 'INV.A' AND @Accion = 'AFECTAR'
BEGIN
SELECT @PosicionActual = PosicionActual, @PosicionReal = PosicionReal
FROM InvD  WITH (NOLOCK)
WHERE ID = @ID AND Articulo = @Articulo AND Tarima = @Tarima
IF @PosicionActual <> @PosicionReal AND ISNULL(@PosicionActual,'') <> '' AND ISNULL(@PosicionReal,'') <> ''
UPDATE Tarima  WITH (ROWLOCK)  SET Posicion = @PosicionReal WHERE Tarima = @Tarima
END
IF @MovTipo = 'INV.A' AND @Accion = 'CANCELAR'
BEGIN
SELECT @PosicionActual = PosicionActual, @PosicionReal = PosicionReal
FROM InvD  WITH (NOLOCK)
WHERE ID = @ID AND Articulo = @Articulo AND Tarima = @Tarima
IF @PosicionActual <> @PosicionReal AND ISNULL(@PosicionActual,'') <> '' AND ISNULL(@PosicionReal,'') <> ''
UPDATE Tarima  WITH (ROWLOCK)  SET Posicion = @PosicionActual WHERE Tarima = @Tarima
END
IF @Modulo = 'INV' AND @MovTipo = 'INV.T'
SELECT @Almacen = AlmacenDestino FROM INV  WITH (NOLOCK)  WHERE ID = @ID
EXEC spWMS @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @MovTipo, @Almacen, @FechaEmision, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @Modulo = 'VTAS'
UPDATE Tarima  WITH (ROWLOCK)
SET Baja = @FechaEmision,
Estatus = 'BAJA'
WHERE Tarima IN(SELECT d.Tarima
FROM VentaD d  WITH (NOLOCK)  JOIN Tarima t  WITH (NOLOCK)
ON d.Tarima = t.Tarima JOIN ArtDisponibleTarima a  WITH (NOLOCK)
ON a.Tarima = t.Tarima
WHERE d.ID = @ID AND t.Estatus = 'ALTA'
AND d.Tarima NOT IN(SELECT TarimaSurtido FROM TMA  WITH (NOLOCK) WHERE Estatus IN('PENDIENTE','PORPROCESAR'))
GROUP BY d.Tarima 
HAVING SUM(ISNULL(a.Disponible,0)) = 0) 
ELSE
IF @Modulo = 'COMS'
UPDATE Tarima  WITH (ROWLOCK)
SET Baja = @FechaEmision,
Estatus = 'BAJA'
WHERE Tarima IN(SELECT d.Tarima
FROM CompraD d  WITH (NOLOCK) JOIN Tarima t  WITH (NOLOCK)
ON d.Tarima = t.Tarima JOIN ArtDisponibleTarima a  WITH (NOLOCK)
ON a.Tarima = t.Tarima
WHERE d.ID = @ID AND t.Estatus = 'ALTA' AND ISNULL(a.Disponible,0) = 0
AND d.Tarima NOT IN(SELECT TarimaSurtido FROM TMA WITH (NOLOCK)  WHERE Estatus IN('PENDIENTE','PORPROCESAR')))
ELSE
IF @Modulo = 'INV'
UPDATE Tarima  WITH (ROWLOCK)
SET Baja = @FechaEmision,
Estatus = 'BAJA'
WHERE Tarima IN(SELECT d.Tarima
FROM InvD d  WITH (NOLOCK)  JOIN Tarima t  WITH (NOLOCK)
ON d.Tarima = t.Tarima JOIN ArtDisponibleTarima a  WITH (NOLOCK)
ON a.Tarima = t.Tarima
WHERE d.ID = @ID AND t.Estatus = 'ALTA'
AND d.Tarima NOT IN(SELECT TarimaSurtido FROM TMA  WITH (NOLOCK)  WHERE Estatus IN('PENDIENTE','PORPROCESAR'))
GROUP BY d.Tarima 
HAVING SUM(ISNULL(a.Disponible,0)) = 0) 
ELSE
IF @Modulo = 'PROD'
UPDATE Tarima  WITH (ROWLOCK)
SET Baja = @FechaEmision,
Estatus = 'BAJA'
WHERE Tarima IN(SELECT d.Tarima
FROM ProdD d  WITH (NOLOCK)  JOIN Tarima t  WITH (NOLOCK)
ON d.Tarima = t.Tarima JOIN ArtDisponibleTarima a  WITH (NOLOCK)
ON a.Tarima = t.Tarima
WHERE d.ID = @ID AND t.Estatus = 'ALTA' AND ISNULL(a.Disponible,0) = 0
AND d.Tarima NOT IN(SELECT TarimaSurtido FROM TMA  WITH (NOLOCK) WHERE Estatus IN('PENDIENTE','PORPROCESAR')))
END
RETURN
END

