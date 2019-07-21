SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadReporteOpEstatus
@Empresa	varchar(5),
@Sucursal	int,
@AgenteD	varchar(10),
@AgenteA	varchar(10),
@FechaD		datetime,
@FechaA		datetime

AS
BEGIN
DECLARE @Direccion2		varchar(100),
@Direccion3		varchar(100),
@Direccion4		varchar(100),
@Titulo			varchar(100),
@Reporte			varchar(500)
DECLARE @Oportunidades TABLE(
ID				int,
RID				int			IDENTITY(1,1),
ContactoTipo	varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Contacto		varchar(10)	COLLATE DATABASE_DEFAULT NULL,
ContactoNombre	varchar(100)COLLATE DATABASE_DEFAULT NULL,
Estatus			varchar(15)	COLLATE DATABASE_DEFAULT NULL,
Agente			varchar(10)	COLLATE DATABASE_DEFAULT NULL,
AgenteNombre	varchar(100)COLLATE DATABASE_DEFAULT NULL,
FechaEmision	datetime	NULL,
Empresa			varchar(5)  COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre	varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion2		varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion3		varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion4		varchar(100)COLLATE DATABASE_DEFAULT NULL,
Titulo			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Reporte			varchar(500)COLLATE DATABASE_DEFAULT NULL
)
EXEC spContactoDireccionHorizontal @@SPID, 'Empresa', @Empresa, @Empresa, 1, 1, 1, 1
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM ContactoDireccionHorizontal
WHERE Estacion = @@SPID
IF @Sucursal IN (-1) SELECT @Sucursal = NULL
IF @AgenteD IN ('', 'NULL', '(Todos)', '(Todas)') SELECT @AgenteD = NULL
IF @AgenteA IN ('', 'NULL', '(Todos)', '(Todas)') SELECT @AgenteA = NULL
SELECT @Titulo = 'Reporte de Oportunidades por Estatus'
SELECT @Reporte = 'Sucursal: ' + ISNULL(CONVERT(varchar,@Sucursal), '(Todas)') + ' Del Agente: ' + ISNULL(CONVERT(varchar,@AgenteD), '(Todos)') + ' Al Agente: ' + ISNULL(CONVERT(varchar,@AgenteD), '(Todos)') + ' De la Fecha: ' + dbo.fnFormatearFecha(@FechaD, 'dd/MM/aaaa') + ' A la Fecha: ' + dbo.fnFormatearFecha(@FechaA, 'dd/MM/aaaa')
INSERT INTO @Oportunidades(
ID,             ContactoTipo,             Contacto,             ContactoNombre, Estatus,             Agente,             AgenteNombre,  FechaEmision,              Direccion2,  Direccion3,  Direccion4,  Empresa, EmpresaNombre,   Titulo,  Reporte)
SELECT Oportunidad.ID, Oportunidad.ContactoTipo, Oportunidad.Contacto, Cte.Nombre,     Oportunidad.Estatus, Oportunidad.Agente, Agente.Nombre, Oportunidad.FechaEmision, @Direccion2, @Direccion3, @Direccion4, @Empresa, Empresa.Nombre, @Titulo, @Reporte
FROM Oportunidad
JOIN Empresa ON Oportunidad.Empresa = Empresa.Empresa
JOIN Cte ON Oportunidad.Contacto = Cte.Cliente
JOIN MovTipo ON Oportunidad.Mov = MovTipo.Mov AND MovTipo.Modulo = 'OPORT'
LEFT OUTER JOIN Agente ON Oportunidad.Agente = Agente.Agente
WHERE Oportunidad.FechaEmision BETWEEN ISNULL(@FechaD, Oportunidad.FechaEmision) AND ISNULL(@FechaA, Oportunidad.FechaEmision)
AND Oportunidad.Empresa = ISNULL(@Empresa, Oportunidad.Empresa)
AND Oportunidad.Sucursal = ISNULL(@Sucursal, Oportunidad.Sucursal)
AND ISNULL(Oportunidad.Agente,'') BETWEEN ISNULL(@AgenteD, ISNULL(Oportunidad.Agente,'')) AND ISNULL(@AgenteA, ISNULL(Oportunidad.Agente,''))
AND Oportunidad.Estatus NOT IN ('CANCELADO', 'SINAFECTAR')
AND MovTipo.Clave = 'OPORT.O'
SELECT * FROM @Oportunidades
RETURN
END

