SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spProyGenerarMovInv
@Proyecto	varchar(50),
@GenerarMov	varchar(20),	
@Mov		varchar(20),
@Almacen	varchar(10),
@Articulo	varchar(20),
@SerieLote	varchar(50),
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@FechaEmision	datetime

AS BEGIN
DECLARE
@Ok		int,
@OkRef	varchar(255),
@AlmTipo	varchar(20),
@ArtTipo	varchar(20),
@ID		int,
@Costo	float,
@Moneda	varchar(10),
@TipoCambio	float
SELECT @Costo = ISNULL(SUM(Costo), 0.0)+ISNULL(SUM(Gasto), 0.0)
FROM ProyResultado
WHERE Proyecto = @Proyecto AND Empresa = @Empresa AND Tipo = 'Real'
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @Ok = NULL, @OkRef = NULL, @Articulo = NULLIF(RTRIM(NULLIF(@Articulo, '0')), ''), @SerieLote = NULLIF(RTRIM(NULLIF(@SerieLote, '0')), '')
SELECT @AlmTipo = UPPER(Tipo) FROM Alm WHERE Almacen = @Almacen
SELECT @ArtTipo = UPPER(Tipo) FROM Art WHERE Articulo = @Articulo
IF @Articulo IS NULL SELECT @Ok = 10530 ELSE
IF @SerieLote IS NULL SELECT @Ok = 20051 ELSE
IF @GenerarMov = 'AF'  AND @AlmTipo <> 'ACTIVOS FIJOS' SELECT @Ok = 20441, @OkRef = @Almacen ELSE
IF @GenerarMov = 'INV' AND @AlmTipo <> 'NORMAL'        SELECT @Ok = 20441, @OkRef = @Almacen ELSE
IF @GenerarMov = 'AF'  AND @ArtTipo <> 'SERIE'         SELECT @Ok = 44010, @OkRef = @Articulo
IF @Ok IS NULL
BEGIN
INSERT Inv (Empresa, Sucursal, Usuario, FechaEmision, Mov, Almacen, Estatus, Moneda, TipoCambio, Proyecto, RenglonID) VALUES (@Empresa, @Sucursal, @Usuario, @FechaEmision, @Mov, @Almacen, 'CONFIRMAR', @Moneda, @TipoCambio, @Proyecto, 1)
SELECT @ID = SCOPE_IDENTITY()
INSERT InvD (ID, Sucursal, Renglon, RenglonID, Articulo, Cantidad, Costo, Almacen) VALUES (@ID, @Sucursal, 2048.0, 1, @Articulo, 1, @Costo, @Almacen)
INSERT SerieLoteMov (Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad) VALUES (@Empresa, @Sucursal, 'INV', @ID, 1, @Articulo, '', @SerieLote, 1)
END
IF @Ok = NULL
SELECT 'Se Genero '+@Mov+ ' (por Confirmar)'
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

