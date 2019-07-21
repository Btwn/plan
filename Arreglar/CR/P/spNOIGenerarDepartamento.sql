SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIGenerarDepartamento
@Empresa        varchar(5),
@Estacion       int

AS BEGIN
DECLARE
@Departamento      varchar(50),
@Sucursal          int,
@EmpresaNOI        varchar(2),
@Ok                int
SELECT @EmpresaNOI = EmpresaAspel
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
DECLARE crDetalle CURSOR FOR
SELECT   Departamento, Sucursal
FROM NOIDepartamento
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @Departamento, @Sucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM Departamento WHERE  Departamento = @Departamento)
UPDATE Departamento SET
Departamento = @Departamento ,
Sucursal = @Sucursal
WHERE Departamento = @Departamento
IF @@ERROR <> 0 SET @Ok = 1
IF NOT EXISTS(SELECT * FROM Departamento WHERE  Departamento = @Departamento)
INSERT  Departamento (Departamento,Sucursal)
SELECT                 @Departamento,@Sucursal
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO   @Departamento, @Sucursal
END
CLOSE crDetalle
DEALLOCATE crDetalle
IF @Ok IS NULL
DELETE  NOIDepartamento
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
IF @Ok IS NULL
SELECT 'Departamentos Importados Correctamente'
ELSE
SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END

