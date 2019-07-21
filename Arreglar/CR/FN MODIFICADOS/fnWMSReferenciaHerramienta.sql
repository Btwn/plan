SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSReferenciaHerramienta (@ID int)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Referencia			varchar(50),
@Modulo				varchar(5),
@IDModulo			int,
@Almacen			varchar(20),
@AlmacenDestino		varchar(20),
@Sucursal			int,
@SucursalDestino	int
IF @Referencia IS NOT NULL
RETURN (@Referencia)
SELECT @Modulo = Modulo, @IDModulo = IDModulo, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino
FROM WMSModuloTarima WITH(NOLOCK)
WHERE ID = @ID
SELECT @Sucursal = Sucursal FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen
SELECT @SucursalDestino = Sucursal FROM Alm WITH(NOLOCK) WHERE Almacen = @AlmacenDestino
IF @Modulo = 'VTAS'
SELECT @Referencia = RTRIM(LTRIM(Mov)) + ' ' + RTRIM(LTRIM(MovID)) FROM Venta WITH(NOLOCK) WHERE ID = @IDModulo
ELSE
IF @Modulo = 'COMS'
SELECT @Referencia = RTRIM(LTRIM(Mov)) + ' ' + RTRIM(LTRIM(MovID)) FROM Compra WITH(NOLOCK) WHERE ID = @IDModulo
ELSE
IF @Modulo = 'INV'
BEGIN
IF @Sucursal <> ISNULL(@SucursalDestino, @Sucursal)
SELECT @Referencia = 'Sucursal Destino ' + CONVERT(varchar,@SucursalDestino) FROM Inv WITH(NOLOCK) WHERE ID = @IDModulo
ELSE
SELECT @Referencia = RTRIM(LTRIM(Mov)) + ' ' + RTRIM(LTRIM(MovID)) FROM Inv WITH(NOLOCK) WHERE ID = @IDModulo
END
ELSE
IF @Modulo = 'PROD'
SELECT @Referencia = RTRIM(LTRIM(Mov)) + ' ' + RTRIM(LTRIM(MovID)) FROM Prod WITH(NOLOCK) WHERE ID = @IDModulo
RETURN (@Referencia)
END

