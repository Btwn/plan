SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4Archivos
@Estacion      INT,
@Empresa       VARCHAR(5),
@Sucursal      INT,
@ID            INT,
@PeriodoTipo   VARCHAR(50),
@FechaD        DATETIME,
@FechaA        DATETIME,
@TipoNominaG4  VARCHAR(50)

AS BEGIN
DECLARE
@Clave                   VARCHAR(200),
@Concepto                VARCHAR(200),
@Personal                VARCHAR(10),
@vchSql                  nVARCHAR(4000),
@bcp                     nVARCHAR(4000),
@Base                    VARCHAR(100),
@TipoDato                VARCHAR(20),
@Valor                   VARCHAR(100),
@Importe                 MONEY,
@Cantidad                MONEY,
@Ok                      VARCHAR(10),
@OkRef                   VARCHAR(255),
@result                  VARCHAR(max),
@URL                     VARCHAR(200),
@Funcion                 nVARCHAR(4000),
@Parmetros               nVARCHAR(4000),
@FechaDD                 CHAR(10),
@FechaAA                 CHAR(10),
@IDD                     VARCHAR(200),
@ProcessID               VARCHAR(50),
@Mov                     VARCHAR(20),
@SucursalT               VARCHAR(10),
@FechaEmision            CHAR(10),
@Rama                    VARCHAR(3),
@IDNomX                  INT,
@API                     VARCHAR(100),
@XML                     XML,
@Usuario                 varchar(10),
@Json                    VARCHAR(MAX)
DELETE NominaPersonalPropiedadG4 WHERE Estacion = @Estacion
DELETE PersonalIncidenciaG4      WHERE Estacion = @Estacion
DELETE NominaIncidenciaG4        WHERE Estacion = @Estacion
DELETE NominaEmpresaPropiedadG4  WHERE Estacion = @Estacion
DELETE NominaConceptosG4         WHERE Estacion = @Estacion
DELETE NominaPersonalG4          WHERE Estacion = @Estacion
DELETE ServicioJSON              WHERE Estacion = @Estacion
SELECT TOP 1 @URL = URL, @API = ISNULL(API, 'API') FROM ServiciosG3 WHERE Servicio = 'Nomina' AND Estatus = 1
SELECT @FechaDD = CONVERT(char(10),@FechaD, 126), @FechaAA = CONVERT(char(10),@FechaA, 126), @Base =  DB_NAME(), @IDD = CONVERT(varchar(200), @ID), @ProcessID = NEWID(), @SucursalT = CONVERT(VARCHAR(10), @Sucursal)
SELECT @Mov = Mov, @FechaEmision = CONVERT(char(10),FechaEmision, 126), @Usuario = Usuario FROM Nomina WHERE ID = @ID
SELECT @IDNomX = ID FROM NomX WHERE NomMov = @Mov
INSERT INTO NominaConceptosG4 (Estacion,  Clave, Tipo, Objeto, Orden, Ocultar, TipoDato, Concepto2, EnCero, Grupo)
SELECT                    @Estacion, Clave, Tipo, Objeto, Orden, Ocultar, TipoDato, Concepto2, EnCero, Grupo
FROM NominaConceptoEx
WHERE IDNomX IN (@IDNomX, 0)
ORDER BY ISNULL(Orden, 1000), Clave
INSERT INTO NominaEmpresaPropiedadG4 (Estacion, element1, element2, value)
SELECT @Estacion, pp.Cuenta, Clave, pp.Valor
FROM NominaConceptoEx nc
JOIN  PersonalPropValor pp ON rtrim(pp.Propiedad) = rtrim(nc.Concepto) AND pp.Rama = 'EMP' AND pp.Cuenta =  @Empresa
WHERE nc.Tipo = 'EmpresaPropiedad'
INSERT INTO NominaPersonalG4 (Estacion,  Personal,   Sindicato,                                                               FechaAntiguedad,                          FechaAlta,                          PeriodoTipo,                                                                                                                                                       UltimoPago,                          FechaBaja,                                                                                                                                                            SueldoMensual,     Empresa)
SELECT                   @Estacion, p.Personal, CASE WHEN Sindicato = '(Confianza)' THEN 'Confianza' ELSE Sindicato END, CONVERT(char(10),p.FechaAntiguedad, 126), CONVERT(char(10),p.FechaAlta, 126), CASE WHEN p.PeriodoTipo = 'Quincenal' THEN CASE WHEN p.DiasPeriodo = 'Dias Periodo' THEN 'Quincenal Periodo' ELSE 'Quincenal Natural' END ELSE p.PeriodoTipo END , CONVERT(char(10),p.UltimoPago, 126), CASE WHEN @TipoNominaG4 in('Nomina Finiquito', 'Nomina Liquidacion') AND ISNULL(CONVERT(char(10),p.FechaBaja, 126), '') = '' THEN @FechaEmision ELSE CONVERT(char(10),p.FechaBaja, 126) END , p.SueldoDiario*30, Empresa
FROM Personal p
INNER JOIN Listast l on p.Personal = l.Clave
WHERE DiasPeriodo <> 'Dias Jornada' AND l.Estacion=@Estacion
CREATE TABLE #PersonalPropiedadTemp (Personal varchar(50), Sucursal INT)
INSERT INTO #PersonalPropiedadTemp (Personal, Sucursal) SELECT Personal, SucursalTrabajo FROM Personal INNER JOIN Listast l ON Personal = l.Clave WHERE l.Estacion = @Estacion
INSERT INTO NominaPersonalPropiedadG4 (Estacion,  element1,  element2, value)
SELECT                            @Estacion, pp.Cuenta, nc.Clave, pp.Valor
FROM NominaConceptoEx nc
JOIN PersonalPropValor pp ON rtrim(pp.Propiedad) = rtrim(nc.Concepto) AND pp.Rama = 'PER'
JOIN PersonalProp ppa ON ppa.Propiedad = pp.Propiedad
JOIN Listast l ON l.Clave = pp.Cuenta
WHERE nc.Tipo = 'PersonalPropiedad' AND isnull(Concepto, '') <> '' AND isnull(Valor, '') <> '' AND l.Estacion = @Estacion AND ppa.NivelPersonal = 1
ORDER BY pp.Cuenta, nc.Clave
INSERT INTO NominaPersonalPropiedadG4 (Estacion,  element1,   element2, value)
SELECT                            @Estacion, p.Personal, nc.Clave, Valor
FROM #PersonalPropiedadTemp p
JOIN PersonalPropValor pp ON pp.Cuenta = p.Sucursal AND pp.Rama = 'SUC'
JOIN PersonalProp ppa ON ppa.Propiedad = pp.Propiedad
JOIN NominaConceptoEx nc ON rtrim(nc.Concepto) = rtrim(pp.Propiedad)
WHERE nc.Tipo = 'PersonalPropiedad' AND isnull(nc.Concepto, '') <> '' AND ppa.NivelSucursal = 1
ORDER BY pp.Cuenta
EXEC spNominaG4Acumulados @Estacion, @Empresa, @Sucursal, @ID, @PeriodoTipo, @FechaD, @FechaA, @TipoNominaG4
EXEC spNominaG4Incidencias @Estacion, @Empresa, @TipoNominaG4
SET @XML = (SELECT * FROM (SELECT 'draft' as action, @IDD as document_id, @ProcessID as process_id, @TipoNominaG4 as documentType, @Mov as documentName, @Empresa as company, @SucursalT as subCompany, @FechaEmision as date, @Base as tenant_id, 'G3' as system, @PeriodoTipo as periodType, @FechaDD as startDate, @FechaAA as endDate) as ServicioG3 FOR XML AUTO, ELEMENTS)
SELECT @Json = dbo.XML2JSON(@XML)
SELECT @Json = REPLACE(LTRIM(@Json), '{"ServicioG3":', '')
SELECT @Json = REPLACE(@Json, '}}', '}')
INSERT INTO ServicioJSON (Estacion, Dato)
SELECT @Estacion, @Json
SELECT @TipoNominaG4 = REPLACE(@TipoNominaG4, ' ', '%20'), @Mov = REPLACE(@Mov, ' ', '%20'), @Empresa = REPLACE(@Empresa, ' ', '%20'), @Base = REPLACE(@Base, ' ', '%20'), @PeriodoTipo = REPLACE(@PeriodoTipo, ' ', '%20')
SELECT @Funcion = N'SELECT @resultOUT = dbo.Int2API_beta('''+@API+''', ''/BetaNomina?URL='+isnull(@URL, '')+'&Modulo=Nomina&Estacion='+Convert(varchar(4), @Estacion)+'&process_id='+@ProcessID+''', ''intelisis'', ''apifirst'')'
SELECT @Parmetros = N'@resultOUT varchar(MAX) OUTPUT'
EXECUTE sp_executesql @Funcion, @Parmetros, @resultOUT = @result OUTPUT
SELECT @Ok = replace(substring(@result, charindex(upper('OK'), upper(@result)) + 4, charindex(upper('OkRef'), upper(@result))-charindex(upper('OK'), upper(@result))-4-2), '"', '')
SELECT @OkRef = replace(substring(@result, charindex(upper('OkRef'), upper(@result)) + 7, charindex(upper('}'), upper(@result))-charindex(upper('OkRef'), upper(@result))-7), '"', '')
IF @Ok IN ('200', '205')
BEGIN
SELECT @PeriodoTipo = REPLACE(@PeriodoTipo, '%20', ' ')
EXEC spNominaG4CargaArchivo @Estacion, @Empresa, @Sucursal, @ID, @Ok, @PeriodoTipo, @FechaD, @FechaA, @ProcessID
END
ELSE
SELECT @Ok+': '+@OkRef
DELETE NominaPersonalPropiedadG4 WHERE Estacion = @Estacion
DELETE PersonalIncidenciaG4      WHERE Estacion = @Estacion
DELETE NominaIncidenciaG4        WHERE Estacion = @Estacion
DELETE NominaEmpresaPropiedadG4  WHERE Estacion = @Estacion
DELETE NominaConceptosG4         WHERE Estacion = @Estacion
DELETE NominaPersonalG4          WHERE Estacion = @Estacion
DELETE ServicioJSON              WHERE Estacion = @Estacion
END

