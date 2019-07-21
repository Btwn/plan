SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4CargaCalendario
@Ejercicio INT,
@Estacion  INT,
@Empresa   VARCHAR(5),
@Sucursal  INT

AS
BEGIN
DECLARE
@UUID         VARCHAR(101),
@Archivo      VARCHAR(500),
@Bulk         VARCHAR(400),
@Renglon	    FLOAT,
@Mov          VARCHAR(20),
@IDNomX       INT,
@Debug        BIT,
@Directorio   VARCHAR(255),
@Ruta         VARCHAR(255),
@Ruta2        VARCHAR(255),
@ComandShell  VARCHAR(255),
@Ok           INT,
@OkRef        VARCHAR(100),
@Funcion      nVARCHAR(4000),
@API          VARCHAR(100),
@URL          VARCHAR(200),
@result       VARCHAR(max),
@Parmetros    nVARCHAR(4000),
@XML          XML,
@FechaEmision VARCHAR(10),
@Base         VARCHAR(100),
@Json         VARCHAR(MAX)
DELETE ServicioJSON WHERE Estacion = @Estacion
SELECT @UUID = NEWID(), @FechaEmision = CONVERT(char(10),GETDATE(), 126), @Base =  DB_NAME()
SET @XML = (SELECT * FROM (SELECT 'Calendario' as action, @UUID as process_id, @Empresa as company, @Sucursal as subCompany, @FechaEmision as date, @Base as tenant_id, 'G3' as system, CONVERT(varchar(4), @Ejercicio) as 'calendarFilter', 'Nomina.Calendario.Exportar' as 'object', '' as 'concept') as ServicioG3 FOR XML AUTO, ELEMENTS)
SELECT @Json = dbo.XML2JSON(@XML)
SELECT @Json = REPLACE(LTRIM(@Json), '{"ServicioG3":', '')
SELECT @Json = REPLACE(@Json, '}}', '}')
INSERT INTO ServicioJSON (Estacion, Dato)
SELECT @Estacion, @Json
SELECT TOP 1 @Directorio = DirectorioArchivosZip, @Debug = ISNULL(Debug, 0), @API = API, @URL = URL  FROM ServiciosG3 WHERE Servicio = 'Calendario' AND Estatus = 1
SELECT @Ruta =    @Directorio+'\'+@UUID,
@Ruta2 =   @Directorio+'\'+@UUID+'CSV',
@Archivo = @Directorio+'\'+@UUID+'CSV\output.csv'
SELECT @Funcion = N'SELECT @resultOUT = dbo.Int2API_beta('''+@API+''', ''/BetaNomina?URL='+isnull(@URL, '')+'&Modulo=Calendario&Estacion='+Convert(varchar(4), @Estacion)+'&process_id='+@UUID+''', ''intelisis'', ''apifirst'')'
SELECT @Parmetros = N'@resultOUT varchar(MAX) OUTPUT'
EXECUTE sp_executesql @Funcion, @Parmetros, @resultOUT = @result OUTPUT
SELECT @Ok = replace(substring(@result, charindex(upper('OK'), upper(@result)) + 4, charindex(upper('OkRef'), upper(@result))-charindex(upper('OK'), upper(@result))-4-2), '"', '')
SELECT @OkRef = replace(substring(@result, charindex(upper('OkRef'), upper(@result)) + 7, charindex(upper('}'), upper(@result))-charindex(upper('OkRef'), upper(@result))-7), '"', '')
IF @Ok IN ('200', '205')
BEGIN
CREATE TABLE #OutputCalendario(
TipoPeriodo         VARCHAR(50),
Tiempo              VARCHAR(50),
Primera             VARCHAR(50),
Ultima              VARCHAR(50),
Clave               VARCHAR(50),
Ejercicio           VARCHAR(50),
Periodo             VARCHAR(50),
Bimestre            VARCHAR(50),
Quincena            VARCHAR(50),
Inicio              VARCHAR(50),
Fin                 VARCHAR(50),
Dias                VARCHAR(50),
PrimerDia           VARCHAR(50),
UltimoDia           VARCHAR(50),
SigInicio           VARCHAR(50),
SigFin              VARCHAR(50),
FinBimestre         VARCHAR(50),
FinAno              VARCHAR(50),
FechaInicioBimestre VARCHAR(50),
FechaFinBimestre    VARCHAR(50),
)
SELECT @Bulk = 'BULK
INSERT #OutputCalendario
FROM '''+@Archivo+'''
WITH
( FIELDTERMINATOR = ''|'',
ROWTERMINATOR = ''0x0a'',
CODEPAGE = ''ACP'' )'
EXEC(@Bulk)
UPDATE #OutputCalendario SET FechaFinBimestre = REPLACE(FechaFinBimestre,char(13), '')
DELETE NominaG4Calendario where YEAR(Tiempo) = @Ejercicio
INSERT INTO NominaG4Calendario ( TipoPeriodo, Tiempo,                   Primera, Ultima, Clave, Ejercicio, Periodo, Bimestre, Quincena, Inicio,                   Fin,                   Dias, PrimerDia, UltimoDia, SigInicio,                   SigFin,                   FinBimestre, FinAno, FechaInicioBimestre,                   FechaFinBimestre)
SELECT                      TipoPeriodo, CONVERT(DATETIME,Tiempo), Primera, Ultima, Clave, Ejercicio, Periodo, Bimestre, Quincena, CONVERT(DATETIME,Inicio), CONVERT(DATETIME,Fin), Dias, PrimerDia, UltimoDia, CONVERT(DATETIME,SigInicio), CONVERT(DATETIME,SigFin), FinBimestre, FinAno, CONVERT(DATETIME,FechaInicioBimestre), CONVERT(DATETIME,FechaFinBimestre)
FROM #OutputCalendario
WHERE YEAR(Tiempo) = @Ejercicio
IF @Debug = 0
BEGIN
SELECT @ComandShell = 'rd '+ @Ruta  +' /S /Q;'
EXEC xp_cmdshell @ComandShell, NO_OUTPUT
SELECT @ComandShell = 'rd '+ @Ruta2  +' /S /Q;'
EXEC xp_cmdshell @ComandShell, NO_OUTPUT
END
SELECT 'PROCESO CONCLUIDO'
END
ELSE
SELECT convert(varchar(100),@Ok)+': '+@OkRef
DELETE ServicioJSON WHERE Estacion = @Estacion
RETURN
END

