SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIImportarPuestos
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
(Puesto varchar(50),
SueldoRangoMinimo float,
SueldoRangoMaximo float
)
SELECT @BaseNOI = '['+Servidor +'].'+BaseDatosNombre,@EmpresaNOI = EmpresaAspel ,@Sucursal = SucursalIntelisis
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL = 'SELECT NULLIF(NOMBRE,'+CHAR(39)+''+CHAR(39)+'),SUELDO_SUG,SUELDO_MAX
FROM ' + @BaseNOI + '.dbo.PUESTOS' + @EmpresaNOI
INSERT @Tabla (Puesto,SueldoRangoMinimo,SueldoRangoMaximo)
EXEC (@SQL)
IF EXISTS (SELECT * FROM NOIPuestos WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion)
DELETE NOIPuestos WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
INSERT NOIPuestos(Estacion,  EmpresaNOI,Puesto,SueldoRangoMinimo,SueldoRangoMaximo)
SELECT            @Estacion, @EmpresaNOI,Puesto,SueldoRangoMinimo,SueldoRangoMaximo
FROM @Tabla
WHERE Puesto IS NOT NULL
RETURN
END

