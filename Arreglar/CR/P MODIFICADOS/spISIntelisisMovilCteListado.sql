SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilCteListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Agente		varchar(10),
@Usuario	varchar(10),
@Situacion  varchar(50),
@ZonaImpuesto varchar(30),
@Sucursal   int,
@Empresa    char(5),
@CRID       int,
@CID       int
SELECT
@Usuario    = Usuario
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10))
SELECT @Agente = Agente, @Sucursal = Sucursal, @Empresa = Empresa
FROM MovilUsuarioCfg WITH (NOLOCK)
WHERE Usuario = @Usuario
SELECT @ZonaImpuesto = 'Z'+RTRIM(DefZonaImpuesto)
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
IF ISNULL(@ZonaImpuesto,'Z') = 'Z' OR ISNULL(@ZonaImpuesto,'') = ''
BEGIN
SELECT @ZonaImpuesto = 'Z'+RTRIM(ZonaImpuesto)
FROM Sucursal WITH (NOLOCK)
WHERE Sucursal = @Sucursal
END
SELECT TOP 1 @Situacion = Situacion
FROM CampanaTipoSituacion WITH (NOLOCK)
WHERE Orden IS NOT NULL AND AccionMovil = 'Sincronizado'
ORDER BY Orden
SELECT
Visitas.RID IdVisita,
ISNULL(CONVERT(VARCHAR(10), Visitas.FechaD, 121), ' ') Fecha,
ISNULL(CONVERT(VARCHAR(5),  Visitas.FechaD, 108), ' ') Hora,
ISNULL(CONVERT(VARCHAR(5),  Visitas.FechaA, 108), ' ') HoraHasta,
Cliente.Cliente Cte,
ISNULL(Cliente.Nombre, ' ') Nombre,
ISNULL(ISNULL(Sucursales.Nombre,				Cliente.Nombre				), ' ') Sucursal,
ISNULL(ISNULL(Sucursales.Direccion,			Cliente.Direccion			), ' ') Direccion,
ISNULL(ISNULL(Sucursales.DireccionNumero,		Cliente.DireccionNumero		), ' ') DireccionNumero,
ISNULL(ISNULL(Sucursales.DireccionNumeroInt,	Cliente.DireccionNumeroInt	), ' ') DireccionNumeroInt,
ISNULL(ISNULL(Sucursales.EntreCalles,	        Cliente.EntreCalles	        ), ' ') EntreCalles,
ISNULL(ISNULL(Sucursales.Delegacion,			Cliente.Delegacion			), ' ') Delegacion,
ISNULL(ISNULL(Sucursales.Colonia,				Cliente.Colonia				), ' ') Colonia,
ISNULL(ISNULL(Sucursales.Poblacion,			Cliente.Poblacion			), ' ') Poblacion,
ISNULL(ISNULL(Sucursales.Estado,				Cliente.Estado				), ' ') Estado,
ISNULL(ISNULL(Sucursales.Pais,					Cliente.Pais				), ' ') Pais,
ISNULL(ISNULL(Sucursales.CodigoPostal,			Cliente.CodigoPostal		), ' ') CodigoPostal,
ISNULL(Cliente.RFC,                                                           ' ') RFC,
ISNULL(ISNULL(Sucursales.Telefonos,			Cliente.Telefonos			), ' ') Telefonos,
ISNULL(ISNULL(Sucursales.Extencion1,			Cliente.Extencion1			), ' ') Extencion1,
ISNULL(ISNULL(Sucursales.eMail1,				Cliente.eMail1				), ' ') eMail1,
dbo.Replace4XML(ISNULL(ISNULL(Visitas.ListaPreciosEsp,Cliente.ListaPreciosEsp),' ')) ListaPrecios,
ISNULL(ISNULL(Sucursales.Estatus,				Cliente.Estatus				), ' ') Estatus,
CAST(CAST(ISNULL(De.Porcentaje, 0) AS DECIMAL(18,2)) AS VARCHAR(15)) Descuento,
dbo.Replace4XML(ISNULL(NULLIF(ISNULL(NULLIF('Z'+Sucursales.ZonaImpuesto,'Z'),NULLIF('Z'+Sucursales.ZonaImpuesto,'Z')),'Z'),@ZonaImpuesto))ZonaImpuesto,
ISNULL(Cliente.CreditoLimite,                                                 ' ') CreditoLimite,
ISNULL(ISNULL(Sucursales.Contacto1,			Cliente.Contacto1			), ' ') Contacto1,
ISNULL(ISNULL(Sucursales.Contacto2,			Cliente.Contacto2			), ' ') Contacto2,
ISNULL(ISNULL(Sucursales.Observaciones,		Cliente.Observaciones		), ' ') Observaciones,
ISNULL(ISNULL(Sucursales.Condicion,		    Cliente.Condicion		    ), ' ') Condicion,
ISNULL(		    Cliente.DefMoneda		   , ' ') DefMoneda,
Saldo = (SELECT SUM(s.Saldo*m.TipoCambio) FROM CxcSaldo s WITH (NOLOCK), Mon m WITH (NOLOCK) WHERE s.Moneda = m.Moneda AND Empresa=@Empresa AND Cliente=Visitas.Contacto),
ISNULL(ISNULL(Sucursales.MapaLatitud,			Cliente.MapaLatitud			), ' ') MapaLatitud,
ISNULL(ISNULL(Sucursales.MapaLongitud,			Cliente.MapaLongitud		), ' ') MapaLongitud,
ISNULL(ISNULL(Sucursales.MapaPrecision,		Cliente.MapaPrecision		), ' ') MapaPrecision
INTO #IntelisisMovilCteListado
FROM Campana Ca WITH (NOLOCK)
JOIN CampanaTipo CT WITH (NOLOCK) ON Ca.CampanaTipo = CT.CampanaTipo AND Ca.Estatus = 'PENDIENTE'
JOIN CampanaD Visitas WITH (NOLOCK) ON Ca.ID = Visitas.ID AND Visitas.Usuario = @Usuario
JOIN Cte Cliente WITH (NOLOCK) ON Visitas.Contacto = Cliente.Cliente
LEFT JOIN CteEnviarA Sucursales WITH (NOLOCK) ON Cliente.Cliente = Sucursales.Cliente AND Visitas.EnviarA = Sucursales.ID
JOIN MovTipo MT WITH (NOLOCK) ON Ca.Mov = MT.Mov AND MT.Modulo = 'CMP' AND MT.Clave = 'CMP.A'
LEFT JOIN CampanaTipoSituacion TS WITH (NOLOCK) ON Visitas.Situacion = TS.Situacion
LEFT JOIN Descuento De WITH (NOLOCK) ON ISNULL(Sucursales.Descuento,Cliente.Descuento) = De.Descuento
WHERE TS.AccionMovil NOT IN ('Cancelado', 'Confirmado')
UPDATE CampanaD with (ROWLOCK)
SET Usuario = @Usuario, Situacion = @Situacion, SituacionFecha = GETDATE()
WHERE RID IN (SELECT IdVisita FROM #IntelisisMovilCteListado)
INSERT CampanaEvento(ID,RID,FechaHora,Tipo,Situacion,SituacionFecha,Observaciones,Comentarios,Sucursal,SucursalOrigen)
SELECT ID,RID,GETDATE(),'Cita',@Situacion,GETDATE(),'','',0,0
FROM CampanaD (NOLOCK) 
WHERE RID IN (SELECT IdVisita FROM #IntelisisMovilCteListado) AND RID NOT IN(SELECT RID FROM CampanaEvento (NOLOCK) )
SELECT @Resultado = CAST((
SELECT * FROM (
SELECT * FROM #IntelisisMovilCteListado
) AS MovilCteListado FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista (NOLOCK)  WHERE Mensaje = @Ok)
END

