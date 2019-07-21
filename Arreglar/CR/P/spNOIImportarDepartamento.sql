SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIImportarDepartamento
@Empresa        varchar(5),
@Estacion       int

AS BEGIN
DECLARE
@Sucursal                       int,
@SQL				varchar(MAX),
@Datos                        	varchar(MAX),
@BaseNOI	                varchar(255),
@EmpresaNOI                     varchar(2),
@ID    	        		int,
@Ok     			int,
@OkRef	                	varchar(255)
DECLARE @Tabla table
(Departamento varchar(50))
SELECT @BaseNOI = '['+Servidor +'].'+BaseDatosNombre,@EmpresaNOI = EmpresaAspel ,@Sucursal = SucursalIntelisis
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL = 'SELECT NULLIF(NOMBRE,'+CHAR(39)+''+CHAR(39)+')
FROM ' + @BaseNOI + '.dbo.DEPTOS' + @EmpresaNOI
INSERT @Tabla (Departamento)
EXEC (@SQL)
IF EXISTS (SELECT * FROM NOIDepartamento WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion)
DELETE NOIDepartamento WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
INSERT NOIDepartamento(Estacion, EmpresaNOI,Departamento,Sucursal)
SELECT                 @Estacion,@EmpresaNOI,Departamento,@Sucursal
FROM @Tabla
WHERE Departamento IS NOT NULL
RETURN
END

