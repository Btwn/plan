SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSValidaTarimaSurtido
@Estacion	int,
@Borrar		int

AS
BEGIN
DECLARE
@CrEmpresa			varchar(5),
@CrID				int,
@CrModulo			varchar(20),
@CrModuloID			int,
@CrArticulo			varchar(20),
@CrSubcuenta		varchar(50),
@CrTarima			varchar(20),
@CrSerieLote		varchar(50),
@CrDiponible		float,
@CrCantidadA		float,
@CrCantidad			float,
@CrMovimiento		varchar(50),
@SumaCantidadA		float,
@Ok					int,
@OkRef				varchar(255)
IF @Borrar = 1
BEGIN
DELETE FROM WMSTarimaDisponible WHERE Estacion = @Estacion
RETURN
END
IF @Borrar = 0
BEGIN
DECLARE CrTarimas CURSOR FOR
SELECT A.Empresa, A.ID, A.Modulo, A.ModuloID, A.Articulo, A.SubCuenta,
A.Tarima, A.SerieLote, A.Disponible, A.CantidadA, B.Cantidad, B.Mov+' '+ISNULL(B.MovID,'')
FROM WMSTarimaDisponible A
JOIN WMSPedidosSinSurtir B
ON A.ID = B.ID
AND A.Estacion = B.Estacion
WHERE A.Estacion = @Estacion
AND A.CantidadA > 0
OPEN CrTarimas
FETCH NEXT FROM CrTarimas INTO @CrEmpresa, @CrID, @CrModulo, @CrModuloID, @CrArticulo, @CrSubcuenta,
@CrTarima, @CrSerieLote, @CrDiponible, @CrCantidadA, @CrCantidad, @CrMovimiento
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Art WHERE Articulo = @CrArticulo AND Tipo IN ('Serie','Lote') )
SELECT @CrSerieLote = ''
IF @CrDiponible < @CrCantidadA
BEGIN
SELECT @Ok = Mensaje, @OkRef = Descripcion+'<BR>Mov: '+@CrMovimiento+'<BR>Tarima: '+@CrTarima
FROM MensajeLista
WHERE MENSAJE = 20020
END
SELECT @SumaCantidadA = SUM(CantidadA)
FROM WMSTarimaDisponible
WHERE Tarima = @CrTarima
AND ISNULL(SerieLote,'') = ISNULL(@CrSerieLote,'')
AND ISNULL(Subcuenta,'') = ISNULL(@CrSubcuenta,'')
AND Estacion = @Estacion
AND CantidadA > 0
IF @CrDiponible < @SumaCantidadA
BEGIN
SELECT @Ok = Mensaje, @OkRef = Descripcion+'<BR>Tarima: '+@CrTarima
FROM MensajeLista
WHERE MENSAJE = 20020
END
SELECT @SumaCantidadA = SUM(CantidadA)
FROM WMSTarimaDisponible
WHERE ID = @CrID
AND Estacion = @Estacion
AND CantidadA > 0
IF @CrCantidad < @SumaCantidadA
BEGIN
SELECT @Ok = Mensaje, @OkRef = Descripcion+'<BR>Mov: '+@CrMovimiento
FROM MensajeLista
WHERE Mensaje = 13240
END
FETCH NEXT FROM CrTarimas INTO @CrEmpresa, @CrID, @CrModulo, @CrModuloID, @CrArticulo, @CrSubcuenta,
@CrTarima, @CrSerieLote, @CrDiponible, @CrCantidadA, @CrCantidad, @CrMovimiento
END
CLOSE CrTarimas
DEALLOCATE CrTarimas
IF @Ok IS NOT NULL
SELECT @OkRef
ELSE
SELECT ''
END
END

