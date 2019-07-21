SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalcInvSeguridad
@Empresa	 char(5),
@Dias	 int,
@Factor	 float

AS BEGIN
DECLARE
@Desde	  datetime,
@Hasta	  datetime,
@Almacen	  char(10),
@Articulo	  char(20),
@SubCuenta	  varchar(50),
@VentaNeta	  float,
@Minimo	  float,
@Ok		  int,
@OkRef	  varchar(255)
SELECT @Ok = NULL, @OkRef = NULL, @Hasta = GETDATE()
EXEC spExtraerFecha @Hasta OUTPUT
SELECT @Desde = DATEADD(day, -@Dias, @Hasta)
BEGIN TRANSACTION
UPDATE ArtAlm SET Minimo = NULL WHERE Empresa = @Empresa
DECLARE crVentas CURSOR FOR
SELECT NULLIF(RTRIM(d.Almacen), ''), NULLIF(RTRIM(d.Articulo), ''), ISNULL(RTRIM(d.SubCuenta), ''), SUM(d.Cantidad*d.Factor*mt.Factor)
FROM Venta e, VentaD d, MovTipo mt
WHERE e.Empresa = @Empresa AND e.Estatus = 'CONCLUIDO' AND e.ID = d.ID AND mt.Modulo = 'VTAS' AND mt.Mov = e.Mov AND mt.Clave IN ('VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.D', 'VTAS.DFC') AND e.FechaEmision BETWEEN @Desde AND @Hasta
GROUP BY d.Almacen, d.Articulo, d.SubCuenta
OPEN crVentas
FETCH NEXT FROM crVentas INTO @Almacen, @Articulo, @SubCuenta, @VentaNeta
WHILE @@fetch_status <> -1 AND @Ok IS NULL AND @Almacen IS NOT NULL AND @Articulo IS NOT NULL
BEGIN
IF @@fetch_status <> -2 AND @Ok IS NULL
BEGIN
SELECT @Minimo = ROUND(((@VentaNeta/@Dias)*(365/12))*@Factor, 0)
UPDATE ArtAlm
SET Minimo = @Minimo
WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT ArtAlm (Empresa, Almacen, Articulo, SubCuenta, Minimo) VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, @Minimo)
END
FETCH NEXT FROM crVentas INTO @Almacen, @Articulo, @SubCuenta, @VentaNeta
END
CLOSE crVentas
DEALLOCATE crVentas
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @OkRef = "Proceso Concluido."
SELECT @OkRef
END ELSE
BEGIN
SELECT Descripcion+' '+RTRIM(@OkRef)
FROM MensajeLista
WHERE Mensaje = @Ok
END
RETURN
END

