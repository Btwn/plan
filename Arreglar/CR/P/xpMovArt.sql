SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMovArt
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@Fecha		datetime,
@Articulo	char(20)
AS BEGIN
DECLARE
@Mov	char(20),
@Almacen 	char(10),
@ID		int,
@Ok		int,
@OkRef	varchar(255),
@Mensaje	varchar(255)
SELECT @Ok = NULL, @OkRef = NULL
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @Almacen = NULLIF(RTRIM(DefAlmacen), '') FROM Usuario WHERE Usuario = @Usuario
IF @Almacen IS NULL SELECT @Ok = 10576, @OkRef = @Usuario
IF @Ok IS NULL
BEGIN
INSERT Inv (Empresa,  Mov,                    Usuario,  FechaEmision, FechaRequerida, Estatus,     Almacen,  Sucursal,    Directo, Moneda,   TipoCambio,   Proyecto,      UEN)
SELECT @Empresa, cm.InvSolicitud, @Usuario, @Fecha,       @Fecha,         'CONFIRMAR', @Almacen, al.Sucursal, 1,       m.Moneda, m.TipoCambio, u.DefProyecto, u.UEN
FROM EmpresaCfgMov cm, EmpresaCfg c, Mon m, Alm al, Usuario u
WHERE cm.Empresa = @Empresa AND c.Empresa = @Empresa AND m.Moneda = c.ContMoneda
AND al.Almacen = @Almacen AND u.Usuario = @Usuario
SELECT @ID = SCOPE_IDENTITY()
IF @ID IS NOT NULL
INSERT InvD (ID, Renglon, Articulo, Cantidad, Unidad, CantidadInventario, FechaRequerida, Almacen, Sucursal)
SELECT @ID, 2048.0, @Articulo, 1, a.Unidad, 1, @Fecha, @Almacen, al.Sucursal
FROM Art a, Alm al
WHERE a.Articulo = @Articulo AND al.Almacen = @Almacen
END
IF @Ok IS NULL
SELECT @Mensaje = 'Se Genero "'+ISNULL(RTRIM(Mov), '')+'" por Confirmar.' FROM Inv WHERE ID = @ID
ELSE
SELECT @Mensaje = Descripcion + ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

