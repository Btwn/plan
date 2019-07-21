SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInvSucursal
@Empresa		varchar(5),
@Sucursal		int,
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Inventario	float OUTPUT

AS
BEGIN
SELECT CargoU, AbonoU
INTO #Auxiliar
FROM AuxiliarU au WITH (NOLOCK)
WHERE au.Rama = 'INV'
AND au.Empresa =  @Empresa
AND au.Sucursal = @Sucursal
AND au.Cuenta = @Articulo
AND ISNULL(au.SubCuenta, '') = ISNULL(@SubCuenta, '')
UNION ALL
SELECT Cargo = CASE WHEN plv.Cantidad < 0 THEN plv.Cantidad * (-1) ELSE 0 END,
Abono = CASE WHEN plv.Cantidad > 0 THEN plv.Cantidad ELSE 0 END
FROM POSL pl WITH (NOLOCK)
INNER JOIN POSLVenta plv WITH (NOLOCK) ON pl.ID = plv.ID
AND plv.Articulo = @Articulo
AND ISNULL(plv.SubCuenta, '') = ISNULL(@SubCuenta, '')
INNER JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = pl.Mov
AND mt.Modulo = 'POS'
AND mt.Clave IN ('POS.N', 'POS.F','POS.NPC')
WHERE pl.Empresa = @Empresa
AND pl.Sucursal = @Sucursal
AND pl.Estatus = 'CONCLUIDO'
SELECT @Inventario = SUM(ISNULL(CargoU,0)) - SUM(ISNULL(AbonoU,0))
FROM #Auxiliar
END

