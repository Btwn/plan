SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSResurtir
@Estacion		int,
@Empresa		char(5)

AS BEGIN
DECLARE
@Ok			int,
@OkRef		varchar(255),
@Tarima		varchar(20)
SET @Ok = NULL
SET @OkRef = NULL
SET @Tarima = NULL
BEGIN TRANSACTION
DECLARE crTarima CURSOR FOR
SELECT DISTINCT Tarima
FROM (
SELECT d.Tarima FROM Venta v  JOIN VentaD d  ON v.ID = d.ID WHERE v.Mov + ' ' + v.MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) AND v.Empresa = @Empresa AND NULLIF(d.Tarima,'') IS NOT NULL UNION
SELECT d.Tarima FROM Compra v JOIN CompraD d ON v.ID = d.ID WHERE v.Mov + ' ' + v.MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) AND v.Empresa = @Empresa AND NULLIF(d.Tarima,'') IS NOT NULL UNION
SELECT d.Tarima FROM Inv v    JOIN InvD d    ON v.ID = d.ID WHERE v.Mov + ' ' + v.MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) AND v.Empresa = @Empresa AND NULLIF(d.Tarima,'') IS NOT NULL UNION
SELECT d.Tarima FROM Prod v   JOIN ProdD d   ON v.ID = d.ID WHERE v.Mov + ' ' + v.MovID IN(SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) AND v.Empresa = @Empresa AND NULLIF(d.Tarima,'') IS NOT NULL
) X
OPEN crTarima
FETCH NEXT FROM crTarima INTO @Tarima
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spWMSResurtirTarima @Tarima, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crTarima INTO @Tarima
END
CLOSE crTarima
DEALLOCATE crTarima
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
COMMIT TRANSACTION
SELECT 'Proceso terminado'
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = 'Error ' + CONVERT(varchar,@Ok) + '<BR><BR>' + Descripcion + '<BR><BR>' + 'Tarima ' + @Tarima FROM MensajeLista WHERE Mensaje = @Ok
SELECT @OkRef
END
RETURN
END

