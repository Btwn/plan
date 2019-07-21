SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadReportePipelineD
@Empresa	varchar(5),
@Sucursal	int,
@AgenteD	varchar(10),
@AgenteA	varchar(10),
@FechaD		datetime,
@FechaA		datetime,
@Plantilla	varchar(20),
@Moneda		varchar(10),
@Clave		varchar(50)

AS BEGIN
DECLARE @PorcentajePonderado		float,
@PorcentajeAvanceClave	float,
@PorcentajeAvance			float,
@ImporteEstimadoClave		float,
@ImporteEstimado			float,
@ImporteOportunidad		float,
@EmpresaNombre			varchar(100),
@Direccion2				varchar(100),
@Direccion3				varchar(100),
@Direccion4				varchar(100),
@Titulo					varchar(100),
@Reporte					varchar(500),
@Agente					varchar(10),
@AgenteNombre				varchar(100),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@ContactoNombre			varchar(100),
@Fecha					datetime
IF @Sucursal IN (-1) SELECT @Sucursal = NULL
IF @AgenteD IN ('', 'NULL', '(Todos)', '(Todas)') SELECT @AgenteD = NULL
IF @AgenteA IN ('', 'NULL', '(Todos)', '(Todas)') SELECT @AgenteA = NULL
IF @Clave IN ('', 'NULL', '(Todos)', '(Todas)') SELECT @Clave = NULL
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
DECLARE @PipeLineProspectos TABLE(
ID						int,
RID						int			IDENTITY(1,1),
Movimiento				varchar(50)	COLLATE DATABASE_DEFAULT NULL,
Agente					varchar(10) COLLATE DATABASE_DEFAULT NULL,
AgenteNombre			varchar(100)COLLATE DATABASE_DEFAULT NULL,
ContactoTipo			varchar(20) COLLATE DATABASE_DEFAULT NULL,
Contacto				varchar(10) COLLATE DATABASE_DEFAULT NULL,
ContactoNombre			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Clave					varchar(50) COLLATE DATABASE_DEFAULT NULL,
PorcentajePonderado		float		NULL,
PorcentajeAvanceClave	float		NULL,
PorcentajeAvance		float		NULL,
ImporteOportunidad		float		NULL,
ImporteEstimadoClave	money		NULL,
ImporteEstimado			money		NULL,
NumLeadsClave			int			NULL,
Etiqueta				varchar(200)COLLATE DATABASE_DEFAULT NULL,
Empresa					varchar(5)  COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion2				varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion3				varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion4				varchar(100)COLLATE DATABASE_DEFAULT NULL,
Titulo					varchar(100)COLLATE DATABASE_DEFAULT NULL,
Reporte					varchar(500)COLLATE DATABASE_DEFAULT NULL,
Fecha					datetime
)
EXEC spContactoDireccionHorizontal @@SPID, 'Empresa', @Empresa, @Empresa, 1, 1, 1, 1
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM ContactoDireccionHorizontal
WHERE Estacion = @@SPID
SELECT @Titulo = 'Pipeline de Oportunidades por Actividad'
SELECT @Reporte = 'Actividad: ' + ISNULL(@Clave, '') + ' Sucursal: ' + ISNULL(CONVERT(varchar,@Sucursal), '(Todas)') + ' Del Agente: ' + ISNULL(CONVERT(varchar,@AgenteD), '(Todos)') + ' Al Agente: ' + ISNULL(CONVERT(varchar,@AgenteD), '(Todos)') + ' De la Fecha: ' + dbo.fnFormatearFecha(@FechaD, 'dd/MM/aaaa') + ' A la Fecha: ' + dbo.fnFormatearFecha(@FechaA, 'dd/MM/aaaa') + ' Plantilla: ' + ISNULL(CONVERT(varchar,@Plantilla), '') + ' Moneda: ' + ISNULL(CONVERT(varchar,@Moneda), '')
DECLARE crClaves CURSOR LOCAL STATIC FOR
SELECT OportunidadD.Clave, pd.PorcentajePonderado, OportunidadD.PorcentajeAvance, dbo.fnOportunidadAvance(Oportunidad.ID), Oportunidad.ImporteOportunidad*(dbo.fnOportunidadAvance(Oportunidad.ID)/100.0),
Oportunidad.ImporteOportunidad, Oportunidad.Agente, Agente.Nombre, Oportunidad.ContactoTipo, Oportunidad.Contacto, Cte.Nombre, OportunidadD.Fecha
FROM Oportunidad
JOIN OportunidadD ON Oportunidad.ID = OportunidadD.ID
JOIN Empresa ON Oportunidad.Empresa = Empresa.Empresa
JOIN Cte ON Oportunidad.Contacto = Cte.Cliente
JOIN MovTipo ON Oportunidad.Mov = MovTipo.Mov AND MovTipo.Modulo = 'OPORT'
LEFT OUTER JOIN Agente ON Oportunidad.Agente = Agente.Agente
JOIN OportunidadPlantilla p ON p.Plantilla = Oportunidad.Plantilla
JOIN OportunidadPlantillaD pd ON p.ID = pd.ID AND pd.Tipo = OportunidadD.Tipo AND pd.Clave = OportunidadD.Clave
WHERE Oportunidad.FechaEmision BETWEEN ISNULL(@FechaD, Oportunidad.FechaEmision) AND ISNULL(@FechaA, Oportunidad.FechaEmision)
AND Oportunidad.Empresa = ISNULL(@Empresa, Oportunidad.Empresa)
AND Oportunidad.Sucursal = ISNULL(@Sucursal, Oportunidad.Sucursal)
AND ISNULL(Oportunidad.Agente,'') BETWEEN ISNULL(@AgenteD, ISNULL(Oportunidad.Agente,'')) AND ISNULL(@AgenteA, ISNULL(Oportunidad.Agente,''))
AND Oportunidad.Estatus NOT IN ('CANCELADO', 'SINAFECTAR')
AND Oportunidad.Moneda = ISNULL(@Moneda, Oportunidad.Moneda)
AND Oportunidad.Plantilla = @Plantilla
AND MovTipo.Clave = 'OPORT.O'
AND NULLIF(PorcentajeAvance, 0) IS NOT NULL
AND OportunidadD.Clave = ISNULL(@Clave,OportunidadD.Clave)
OPEN crClaves
FETCH NEXT FROM crClaves INTO @Clave, @PorcentajePonderado, @PorcentajeAvanceClave, @PorcentajeAvance, @ImporteEstimado, @ImporteOportunidad, @Agente, @AgenteNombre,
@ContactoTipo, @Contacto, @ContactoNombre, @Fecha
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF ISNULL(LEN(@Clave), 0) < 0 SELECT @Clave = 'No definida'
SELECT @ImporteEstimadoClave = ((@ImporteOportunidad*(@PorcentajePonderado/100.0))*(@PorcentajeAvanceClave/100.0))
UPDATE @PipeLineProspectos
SET ImporteEstimadoClave = ISNULL(ImporteEstimadoClave, 0) + ISNULL(@ImporteEstimadoClave, 0),
NumLeadsClave = ISNULL(NumLeadsClave, 0) + 1
WHERE ISNULL(Clave, '') = ISNULL(@Clave, '')
IF @@ROWCOUNT = 0
INSERT INTO @PipeLineProspectos(
Clave,  PorcentajePonderado,  PorcentajeAvanceClave,  PorcentajeAvance,  ImporteOportunidad,  ImporteEstimadoClave,  ImporteEstimado, NumLeadsClave,  Agente,  AgenteNombre,  ContactoTipo,  Contacto,  ContactoNombre,  Fecha)
VALUES(@Clave, @PorcentajePonderado, @PorcentajeAvanceClave, @PorcentajeAvance, @ImporteOportunidad, @ImporteEstimadoClave, @ImporteEstimado, 1,             @Agente, @AgenteNombre, @ContactoTipo, @Contacto, @ContactoNombre, @Fecha)
END
FETCH NEXT FROM crClaves INTO @Clave, @PorcentajePonderado, @PorcentajeAvanceClave, @PorcentajeAvance, @ImporteEstimado, @ImporteOportunidad, @Agente, @AgenteNombre,
@ContactoTipo, @Contacto, @ContactoNombre, @Fecha
END
CLOSE crClaves
DEALLOCATE crClaves
UPDATE @PipeLineProspectos SET Clave = 'No definida' WHERE ISNULL(Clave, '') = ''
UPDATE @PipeLineProspectos
SET Etiqueta = ISNULL(Clave, '') + '  ' + ISNULL(CONVERT(varchar(10), PorcentajePonderado), '') + '%',
Empresa = @Empresa,
EmpresaNombre = @EmpresaNombre,
Direccion2 = @Direccion2,
Direccion3 = @Direccion3,
Direccion4 = @Direccion4,
Titulo = @Titulo,
Reporte = @Reporte
SELECT * FROM @PipeLineProspectos ORDER BY Clave,PorcentajeAvanceClave
RETURN
END

