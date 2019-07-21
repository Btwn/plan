SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSPOSHerrCteGenerarVale
@Estacion		int,
@Empresa		varchar(5),
@Usuario		varchar(10),
@Sucursal		int,
@Moneda			varchar(10),
@Tipo			varchar(50),
@Categoria		varchar(50),
@Grupo			varchar(50),
@Familia		varchar(50),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
DECLARE
@Cliente             varchar(10),
@ID                  int,
@FechaEmision        datetime,
@Ok                  int,
@OkRef               varchar(255),
@OKRefLDI            varchar(500),
@Monedero            varchar(20),
@Mov                 varchar(20),
@MovID               varchar(20),
@TipoCambio          float,
@IDNuevo             int,
@ArticuloTarjeta     varchar(20),
@AlmacenTarjeta      varchar(10),
@Importe             float,
@MonederoLDI         bit,
@SugerirFechaCierre  bit,
@FechaCierre         datetime
SELECT @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @MonederoLDI = ISNULL(MonederoLDI,0)
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE Moneda = @Moneda
SELECT @ArticuloTarjeta= CxcArticuloTarjetasDef ,@AlmacenTarjeta= CxcAlmacenTarjetasDef
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Mov = MovEmision
FROM POSCfg
WHERE Empresa = @Empresa
IF @Mov IS NULL
SELECT TOP 1 @Mov = Mov FROM MovTipo WHERE Modulo = 'VALE' AND Clave = 'VALE.ET'
IF EXISTS(SELECT Monedero FROM POSHerrCteFrecuente WHERE Monedero IN (SELECT Serie FROM ValeSerie))
SELECT @Ok = 36011, @OkRef = @Monedero
IF @Ok IS NULL
BEGIN
IF @Ok IS NULL
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT ID, Monedero, Cliente
FROM POSHerrCteFrecuente
WHERE ID IN (SELECT ID FROM ListaID  WHERE Estacion = @Estacion)AND Monedero IS NOT NULL
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @ID, @Monedero, @Cliente
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
BEGIN TRANSACTION
SELECT @Ok = NULL ,@OkRef = NULL
INSERT Vale(
Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Sucursal, Tipo, Precio, Importe, Cantidad, Articulo,
Almacen, FechaInicio, FechaTermino, Cliente)
SELECT
@Empresa,@Mov,@FechaEmision,@Moneda, @TipoCambio, @Usuario,'SINAFECTAR',@Sucursal, @Tipo, 0.0, 0.0, 1, @ArticuloTarjeta,
@AlmacenTarjeta, @FechaD, @FechaA, @Cliente
IF @@ERROR <> 0
SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT ValeD(
ID, Serie, Sucursal, SucursalOrigen,Importe)
SELECT
@IDNuevo, @Monedero, @Sucursal, @Sucursal, 0.0
IF @@ERROR <> 0
SET @Ok = 1
IF @OK IS NULL
EXEC spAfectar 'VALE', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @IDNuevo IS NOT NULL
SELECT @MovID = MovID FROM Vale WHERE ID = @IDNuevo
IF EXISTS(SELECT * FROM POSValeSerie WHERE Serie = @Monedero AND Cliente IS NULL)
UPDATE POSValeSerie SET Cliente = @Cliente WHERE Serie = @Monedero
IF @MonederoLDI = 1
EXEC spPOSLDIValidarTarjeta  'MON CONSULTA',@IDNuevo, @Monedero,@Empresa,@Usuario,@Sucursal,@Importe OUTPUT,
@Ok OUTPUT, @OkRef  OUTPUT, @OKRefLDI OUTPUT ,0,'VALE'
IF @OKRefLDI = 'Tarjeta no registrada'
BEGIN
SELECT @Ok = NULL,@OkRef= NULL
IF @MonederoLDI = 1
EXEC spPOSLDI 'MON ALTA NUEVO', @IDNuevo, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, NULL, 1, NULL,
@Ok OUTPUT, @OkRef  OUTPUT, 'VALE'
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NOT NULL
UPDATE POSHerrCteFrecuente SET Error = ISNULL(@OkrefLdi,'')+' '+ISNULL(@OkRef,'')  WHERE ID = @ID
IF @Ok IS NULL
BEGIN
INSERT POSHerrCteFrecuenteD(
Cliente, Monedero, FechaEmision, Mov, MovID)
SELECT
@Cliente, @Monedero,@FechaEmision, @Mov, @MovID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
DELETE  POSHerrCteFrecuente   WHERE ID = @ID
IF @Ok IS NULL
UPDATE Cte SET Categoria = ISNULL(NULLIF(@Categoria ,''),Categoria), Grupo = ISNULL(NULLIF(@Grupo ,''),Grupo),
Familia = ISNULL(NULLIF(@Familia ,''),Familia)
WHERE Cliente = @Cliente
END
FETCH NEXT FROM crArticulo INTO @ID, @Monedero, @Cliente
END
CLOSE crArticulo
DEALLOCATE crArticulo
END
END
IF @Ok IS NULL
SELECT @OkRef = 'PROCESO CONCLUIDO'
SELECT @OkRef
END

