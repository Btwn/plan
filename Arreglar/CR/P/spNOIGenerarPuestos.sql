SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIGenerarPuestos
@Empresa        varchar(5),
@Estacion       int

AS BEGIN
DECLARE
@Puesto            varchar(50),
@SueldoRangoMinimo float,
@SueldoRangoMaximo float,
@Sucursal          int,
@EmpresaNOI        varchar(2),
@Ok                int
SELECT @EmpresaNOI = EmpresaAspel
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
DECLARE crDetalle CURSOR FOR
SELECT   Puesto,SueldoRangoMinimo,SueldoRangoMaximo
FROM NOIPuestos
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @Puesto,@SueldoRangoMinimo,@SueldoRangoMaximo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM Puesto WHERE  Puesto = @Puesto)
UPDATE Puesto SET
Puesto = @Puesto ,
SueldoRangoMinimo = @SueldoRangoMinimo,
SueldoRangoMaximo = @SueldoRangoMaximo
WHERE Puesto = @Puesto
IF @@ERROR <> 0 SET @Ok = 1
IF NOT EXISTS(SELECT * FROM Puesto WHERE  Puesto = @Puesto)
INSERT  Puesto (Puesto,  SueldoDef,  SueldoRangoMaximo)
SELECT          @Puesto, @SueldoRangoMinimo, @SueldoRangoMaximo
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO  @Puesto,@SueldoRangoMinimo,@SueldoRangoMaximo
END
CLOSE crDetalle
DEALLOCATE crDetalle
IF @Ok IS NULL
DELETE  NOIPuestos
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
IF @Ok IS NULL
SELECT 'Puestos Importados Correctamente'
ELSE
SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END

