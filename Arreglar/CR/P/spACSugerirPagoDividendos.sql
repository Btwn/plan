SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER  PROCEDURE spACSugerirPagoDividendos
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	char(20),
@Fecha		datetime,
@Ejercicio	int

AS BEGIN
DECLARE
@ID			int,
@Mov		varchar(20),
@Articulo		varchar(20),
@Almacen		char(10),
@Existencia		float,
@Precio		float,
@Renglon		float,
@RenglonID		int,
@RenglonTipo	char(1),
@ArtTipo 		varchar(20),
@ArtUnidad 		varchar(50),
@Moneda		char(10),
@TipoCambio		float
SELECT @Mov = 'Pago Dividendos'
SELECT @Renglon = 0.0, @RenglonID = 0
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
DECLARE crExistencia CURSOR FOR
SELECT a.Cuenta, a.Grupo, SUM(a.CargosU)-SUM(a.AbonosU)
FROM AcumU a
WHERE a.Rama = 'INV'
AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio
GROUP BY a.Cuenta, a.Grupo
OPEN crExistencia
FETCH NEXT FROM crExistencia INTO @Articulo, @Almacen, @Existencia
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Existencia, 0.0) IS NOT NULL
BEGIN
IF @ID IS NULL
BEGIN
INSERT Inv (Sucursal,  Empresa,  Usuario,  Estatus,     Mov,  FechaEmision, Almacen,  Moneda,  TipoCambio, Referencia)
VALUES (@Sucursal, @Empresa, @Usuario, 'CONFIRMAR', @Mov, @Fecha,       @Almacen, @Moneda, @TipoCambio, @Ejercicio)
SELECT @ID = SCOPE_IDENTITY()
END
SELECT @Precio = NULL
SELECT @Precio = NULLIF(MIN(Importe), 0.0)
FROM ArtACCupon
WHERE Articulo = @Articulo AND PagoDividendos = 1
IF @Precio IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @ArtTipo = Tipo, @ArtUnidad = Unidad FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
INSERT InvD (ID,  Renglon,  RenglonTipo,  RenglonID,  Articulo,  Almacen,  Cantidad,    Precio,  Unidad)
VALUES (@ID, @Renglon, @RenglonTipo, @RenglonID, @Articulo, @Almacen, @Existencia, @Precio, @ArtUnidad)
END
END
FETCH NEXT FROM crExistencia INTO @Articulo, @Almacen, @Existencia
END
CLOSE crExistencia
DEALLOCATE crExistencia
IF @ID IS NOT NULL
SELECT 'Se Genero con Exito "'+@Mov+'" por Confirmar.'
ELSE
SELECT 'No Tiene Existencias en este Ejercicio'
RETURN
END

