SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIImportarConceptoNomina
@Empresa        varchar(5),
@TablaPeriodo	varchar(10),
@Estacion       int

AS BEGIN
DECLARE
@Sucursal                       int,
@SQL				varchar(MAX),
@SQL2				varchar(MAX),
@SQL3				varchar(MAX),
@SQL4				varchar(MAX),
@Datos                        	varchar(MAX),
@BaseNOI	                varchar(255),
@EmpresaNOI                     varchar(2),
@ID    	        		int,
@Ok     			int,
@OkRef	                	varchar(255)
DECLARE @Tabla table
(NominaConcepto varchar(10),
Concepto        varchar(50),
Estatus         varchar(15),
Movimiento      varchar(20),
Pais            varchar(30),
CuentaGrupo     varchar(20),
Modulo          varchar(5),
Status          varchar(10))
DECLARE @Tabla2 table
(NominaConcepto         varchar(10),
GravaISR               varchar(50)
)
DECLARE @Tabla3 table
(NominaConcepto         varchar(10),
GravaIMSS              varchar(50)
)
DECLARE @Tabla4 table
(NominaConcepto             varchar(10),
GravaImpuestoEstatal       varchar(50)
)
SELECT @BaseNOI = '['+Servidor +'].'+BaseDatosNombre,@EmpresaNOI = EmpresaAspel ,@Sucursal = SucursalIntelisis
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL = 'SELECT UPPER(CHAR(PER_O_DED))+dbo.fnRellenarCerosIzquierda(NUM_PERDED,3) NominaConcepto,
NOMBRE,
CASE WHEN STATUS = '+CHAR(39)+'A'+CHAR(39)+' THEN'+CHAR(39)+ 'ALTA'+CHAR(39)+' WHEN STATUS ='+CHAR(39)+ 'Baja' +CHAR(39)+'THEN'+CHAR(39)+ 'Baja'+CHAR(39)+' WHEN STATUS ='+CHAR(39)+ 'Baja' +CHAR(39)+'THEN'+CHAR(39)+ 'Baja'+CHAR(39)+' ELSE NULL END Estatus,
CASE WHEN  UPPER(CHAR(PER_O_DED)) ='+CHAR(39)+ 'P'+CHAR(39)+ ' THEN'+CHAR(39)+ 'Percepcion'+CHAR(39)+' WHEN UPPER(CHAR(PER_O_DED)) ='+CHAR(39)+ 'D'+CHAR(39)+ 'THEN '+CHAR(39)+'Deduccion' +CHAR(39)+' WHEN  UPPER(CHAR(PER_O_DED)) ='+CHAR(39)+ 'E'+CHAR(39)+ ' THEN'+CHAR(39)+ 'Estadistica'+CHAR(39)+'ELSE NULL END Movimiento,
'+CHAR(39)+'Mexico' +CHAR(39)+'As Pais,
'+CHAR(39)+'ASPEL' +CHAR(39)+'As CuentaGrupo,
'+CHAR(39)+'NOM' +CHAR(39)+'As Modulo ,
STATUS
FROM ' + @BaseNOI + '.dbo.PD' + @TablaPeriodo+@EmpresaNOI + '
WHERE TIPO_REG = 0 ORDER BY PER_O_DED, NUM_PERDED'
INSERT @Tabla(NominaConcepto,Concepto,Estatus,Movimiento,Pais,CuentaGrupo,Modulo,Status)
EXEC (@SQL)
UPDATE @Tabla SET Movimiento = 'Estadistica' WHERE Status = 'C'
SELECT @SQL2 = 'SELECT UPPER(CHAR(PER_O_DED))+dbo.fnRellenarCerosIzquierda(NUM_PERDED,3),
CASE WHEN DIG_GRAV ='+CHAR(39)+ 'G' +CHAR(39)+'THEN'+CHAR(39)+ 'Si'+CHAR(39)+' WHEN DIG_GRAV='+CHAR(39)+ 'E'+CHAR(39)+' THEN'+CHAR(39)+ 'No' +CHAR(39)+'END
FROM ' + @BaseNOI + '.dbo.PD' + @TablaPeriodo+@EmpresaNOI + '
WHERE TIPO_REG IN(1)
AND DIG_GRAV IN ('+CHAR(39)+'G'+CHAR(39)+','+CHAR(39)+'E'+CHAR(39)+')
ORDER BY PER_O_DED'
INSERT @Tabla2(NominaConcepto,GravaISR)
EXEC (@SQL2)
SELECT @SQL3 = 'SELECT UPPER(CHAR(PER_O_DED))+dbo.fnRellenarCerosIzquierda(NUM_PERDED,3),
CASE WHEN DIG_GRAV ='+CHAR(39)+ 'G' +CHAR(39)+'THEN'+CHAR(39)+ 'Si'+CHAR(39)+' WHEN DIG_GRAV='+CHAR(39)+ 'E'+CHAR(39)+' THEN'+CHAR(39)+ 'No' +CHAR(39)+'END
FROM ' + @BaseNOI + '.dbo.PD' + @TablaPeriodo+@EmpresaNOI + '
WHERE TIPO_REG IN(2)
AND DIG_GRAV IN ('+CHAR(39)+'G'+CHAR(39)+','+CHAR(39)+'E'+CHAR(39)+')
ORDER BY PER_O_DED'
INSERT @Tabla3(NominaConcepto,GravaIMSS)
EXEC (@SQL3)
SELECT @SQL4 = 'SELECT UPPER(CHAR(PER_O_DED))+dbo.fnRellenarCerosIzquierda(NUM_PERDED,3),
CASE WHEN DIG_GRAV ='+CHAR(39)+ 'G' +CHAR(39)+'THEN'+CHAR(39)+ 'Si'+CHAR(39)+' WHEN DIG_GRAV='+CHAR(39)+ 'E'+CHAR(39)+' THEN'+CHAR(39)+ 'No' +CHAR(39)+'END
FROM ' + @BaseNOI + '.dbo.PD' + @TablaPeriodo+@EmpresaNOI + '
WHERE TIPO_REG IN(4)
AND DIG_GRAV IN ('+CHAR(39)+'G'+CHAR(39)+','+CHAR(39)+'E'+CHAR(39)+')
ORDER BY PER_O_DED'
INSERT @Tabla4(NominaConcepto,GravaImpuestoEstatal)
EXEC (@SQL4)
IF EXISTS (SELECT * FROM NOINominaConcepto WHERE Nomina = @TablaPeriodo AND EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion)
DELETE  NOINominaConcepto
WHERE Nomina = @TablaPeriodo AND EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
INSERT NOINominaConcepto(Estacion,  NominaConcepto,   GravaISR,                GravaIMSS,                GravaImpuestoEstatal,                 Concepto,   Estatus,   Movimiento,   Pais,   CuentaGrupo,   Modulo, EmpresaNOI, Nomina)
SELECT                   @Estacion, a.NominaConcepto, ISNULL(b.GravaISR,'Si'), ISNULL(c.GravaIMSS,'Si'), ISNULL(d.GravaImpuestoEstatal,'Si') , a.Concepto, a.Estatus, a.Movimiento, a.Pais, a.CuentaGrupo, a.Modulo,@EmpresaNOI,@TablaPeriodo
FROM  @Tabla a
LEFT JOIN @Tabla2 b ON a.NominaConcepto = b.NominaConcepto
LEFT JOIN @Tabla3 c ON a.NominaConcepto = c.NominaConcepto
LEFT JOIN @Tabla4 d ON a.NominaConcepto = d.NominaConcepto
RETURN
END

