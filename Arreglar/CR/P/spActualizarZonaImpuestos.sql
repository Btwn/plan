SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizarZonaImpuestos
@Modulo		char(5),
@ID		int

AS BEGIN
DECLARE
@Mov		varchar(20),
@Empresa		varchar(5),
@Sucursal		int,
@Contacto		varchar(10),
@EnviarA		int,
@FechaEmision	datetime,
@ZonaImpuesto	varchar(50),
@Articulo		varchar(20),
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		float
IF @Modulo = 'COMS'
DECLARE crMovD CURSOR FOR
SELECT e.Mov, e.Empresa, e.Sucursal, e.FechaEmision, e.Proveedor, CONVERT(int, NULL), e.ZonaImpuesto, d.Articulo, a.Impuesto1, a.Impuesto2, a.Impuesto3
FROM CompraD d, Compra e, Art a
WHERE e.ID = @ID AND e.ID = d.ID AND d.Articulo = a.Articulo
IF @Modulo = 'VTAS'
DECLARE crMovD CURSOR FOR
SELECT e.Mov, e.Empresa, e.Sucursal, e.FechaEmision, e.Cliente, e.EnviarA, e.ZonaImpuesto, d.Articulo, a.Impuesto1, a.Impuesto2, a.Impuesto3
FROM VentaD d, Venta e, Art a
WHERE e.ID = @ID AND e.ID = d.ID AND d.Articulo = a.Articulo
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Mov, @Empresa, @Sucursal, @FechaEmision, @Contacto, @EnviarA, @ZonaImpuesto, @Articulo, @Impuesto1, @Impuesto2, @Impuesto3
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
IF @Modulo = 'COMS' UPDATE CompraD SET Impuesto1 = @Impuesto1, Impuesto2 = @Impuesto2, @Impuesto3 = @Impuesto1 WHERE CURRENT OF crMovD ELSE
IF @Modulo = 'VTAS' UPDATE VentaD  SET Impuesto1 = @Impuesto1, Impuesto2 = @Impuesto2, @Impuesto3 = @Impuesto1 WHERE CURRENT OF crMovD
END
FETCH NEXT FROM crMovD INTO @Mov, @Empresa, @Sucursal, @FechaEmision, @Contacto, @EnviarA, @ZonaImpuesto, @Articulo, @Impuesto1, @Impuesto2, @Impuesto3
END  
CLOSE crMovD
DEALLOCATE crMovD
END

