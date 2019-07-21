SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xp_OrdenDistribucion_Gigante
@Plantilla		varchar(50),
@Direccion		varchar(255),
@Empresa		char(5),
@Usuario		char(10),
@Estacion		int
AS BEGIN
DECLARE
@EnviarA 	int,
@Ok		int,
@OkRef	varchar(255)
BEGIN TRANSACTION
DECLARE crSucursal CURSOR FOR
SELECT DISTINCT CONVERT(int, SUBSTRING(Clave, 1, 3))
FROM ListaSt
WHERE dbo.fnEsNumerico(SUBSTRING(Clave, 1, 3)) = 1
ORDER BY CONVERT(int, SUBSTRING(Clave, 1, 3))
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @EnviarA
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
EXEC xp_OrdenDistribucion_Gigante_Sucursal @Plantilla, @Direccion, @Empresa, @Usuario, @Estacion, @EnviarA, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crSucursal INTO @EnviarA
END  
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL SELECT @Ok = 80050
SELECT Mensaje, Tipo, Descripcion, "Referencia" = ISNULL(@OkRef, '')
FROM MensajeLista
WHERE Mensaje = @Ok
RETURN
END

