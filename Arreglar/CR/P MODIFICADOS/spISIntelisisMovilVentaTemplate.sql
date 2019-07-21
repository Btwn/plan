SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilVentaTemplate
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Agente		 varchar(10),
@Usuario	 varchar(10),
@ConImpuesto bit,
@Moneda      char(10),
@GUID        varchar(50)
SET @GUID = @@SPID
DECLARE
@Cte TABLE (Cliente varchar(20), VentaID int)
SELECT
@Usuario    = Usuario
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10))
SELECT @Agente = Agente
FROM MovilUsuarioCfg WITH (NOLOCK)
WHERE Usuario = @Usuario
SELECT @ConImpuesto = CAST(VentaPreciosImpuestoIncluido AS bit),
@Moneda      = ContMoneda
FROM EmpresaCfg C WITH (NOLOCK)
JOIN MovilUsuarioCfg S WITH (NOLOCK) ON C.Empresa = S.Empresa
WHERE S.Usuario = @Usuario
INSERT @Cte
SELECT Cliente.Cliente, ISNULL(MAX(Ve.ID), 0)
FROM Campana Ca WITH (NOLOCK)
JOIN CampanaTipo CT WITH (NOLOCK) ON Ca.CampanaTipo = CT.CampanaTipo AND Ca.Estatus = 'PENDIENTE'
JOIN CampanaD Visitas WITH (NOLOCK) ON Ca.ID = Visitas.ID AND Visitas.Usuario = @Usuario
JOIN Cte Cliente WITH (NOLOCK) ON Visitas.Contacto = Cliente.Cliente
LEFT JOIN CteEnviarA Sucursales WITH (NOLOCK) ON Cliente.Cliente = Sucursales.Cliente AND Visitas.EnviarA = Sucursales.ID
JOIN MovTipo MT WITH (NOLOCK) ON Ca.Mov = MT.Mov AND MT.Modulo = 'CMP' AND MT.Clave = 'CMP.A'
LEFT JOIN CampanaTipoSituacion TS WITH (NOLOCK) ON Visitas.Situacion = TS.Situacion
LEFT JOIN Venta Ve WITH (NOLOCK) ON Cliente.Cliente = Ve.Cliente AND Ve.Estatus IN ('PENDIENTE','CONCLUIDO')
WHERE TS.AccionMovil NOT IN ('Cancelado', 'Confirmado')
GROUP BY Cliente.Cliente
DELETE OfertaMovilTemp WHERE GUID = @GUID
INSERT OfertaMovilTemp(
GUID,ListaPrecios,Articulo)
SELECT DISTINCT @GUID,ISNULL(NULLIF(d.ListaPreciosEsp,''),e.ListaPreciosEsp),lp.Articulo
FROM Campana c WITH (NOLOCK)
JOIN CampanaD d WITH (NOLOCK) on c.ID = d.ID
JOIN Cte e WITH (NOLOCK) on d.Contacto = e.Cliente
JOIN CampanaTipoSituacion t WITH (NOLOCK) on d.Situacion = t.Situacion
JOIN MovTipo m WITH (NOLOCK) on c.Mov = m.Mov AND m.Modulo = 'CMP'
JOIN ListaPreciosD lp WITH (NOLOCK) ON ISNULL(NULLIF(d.ListaPreciosEsp,''),e.ListaPreciosEsp) = lp.Lista
JOIN Art a WITH (NOLOCK) ON lp.Articulo = a.Articulo
WHERE m.Clave = 'CMP.A' AND c.Estatus ='PENDIENTE' AND t.AccionMovil IN('Sincronizado','Por Sincronizar') AND c.Agente = @Agente 
INSERT OfertaMovilTemp(
GUID,ListaPrecios,Articulo)
SELECT DISTINCT @GUID,ISNULL(c.ListaPreciosEsp,''),pd.Articulo
FROM Cte c WITH (NOLOCK)
JOIN ListaPrecios p WITH (NOLOCK) ON c.ListaPreciosEsp = p.Lista
JOIN ListaPreciosD pd WITH (NOLOCK) ON p.Lista = pd.Lista
JOIN Art a WITH (NOLOCK) ON pd.Articulo = a.Articulo
LEFT JOIN OfertaMovilTemp MT WITH (NOLOCK) ON a.Articulo = MT.Articulo AND c.ListaPreciosEsp = MT.ListaPrecios AND MT.GUID = @GUID
WHERE c.Agente = @Agente AND MT.Articulo IS NULL
INSERT OfertaMovilTemp(
GUID,ListaPrecios,Articulo)
SELECT DISTINCT @GUID,ISNULL(c.ListaPreciosEsp,''), pd.Articulo
FROM CteEnviarA c WITH (NOLOCK)
JOIN ListaPrecios p WITH (NOLOCK) ON c.ListaPreciosEsp = p.Lista
JOIN ListaPreciosD pd WITH (NOLOCK) ON p.Lista = pd.Lista
JOIN Art a WITH (NOLOCK) ON pd.Articulo = a.Articulo
LEFT JOIN OfertaMovilTemp MT WITH (NOLOCK) ON a.Articulo = MT.Articulo AND c.ListaPreciosEsp = MT.ListaPrecios AND MT.GUID = @GUID
WHERE c.Agente = @Agente AND MT.Articulo IS NULL
SELECT @Resultado = CAST((
SELECT * FROM (
SELECT
Template.Cliente, Template.ID, Template.FechaEmision,
Template.Importe, Template.Impuestos, Template.Saldo, Template.PrecioTotal,
0.00 AS Descuento,
0.00 DescuentoGlobal,
Template.Moneda,
Detalle.Cantidad,
0.00 AS DescuentoImporte,
0.00 AS DescuentoLinea,
Detalle.Articulos
FROM @Cte Cliente
JOIN Venta Template WITH (NOLOCK)  ON Cliente.Cliente = Template.Cliente AND Cliente.VentaID = Template.ID
JOIN (
SELECT Detalle.ID,
Detalle.Articulo,
ISNULL(Detalle.Cantidad, 0) Cantidad,
ISNULL(Detalle.DescuentoImporte, 0) DescuentoImporte,
ISNULL(Detalle.DescuentoLinea, 0) DescuentoLinea,
dbo.fnISGetArtOpcion(Detalle.Articulo, @Agente, @@SPID) Articulos
FROM VentaD Detalle WITH (NOLOCK)
JOIN @Cte Template ON Detalle.ID = Template.VentaID
) AS Detalle ON Template.ID = Detalle.ID
) AS MovilVentaTemplate FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF @Resultado IS NULL
SELECT @Resultado = CAST('<Intelisis Contenido="Resultado" Version="1.0" SubReferencia="" Referencia="Intelisis.Movil.Venta.Template" Sistema="Intelisis"><Resultado IntelisisServiceID="'+CONVERT(varchar,(@ID))+'" OkRef="" Ok="" /></Intelisis>' AS NVARCHAR(MAX))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok)
END

