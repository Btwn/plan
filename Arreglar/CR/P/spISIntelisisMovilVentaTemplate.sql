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
FROM MovilUsuarioCfg
WHERE Usuario = @Usuario
SELECT @ConImpuesto = CAST(VentaPreciosImpuestoIncluido AS bit),
@Moneda      = ContMoneda
FROM EmpresaCfg C
JOIN MovilUsuarioCfg S ON C.Empresa = S.Empresa
WHERE S.Usuario = @Usuario
INSERT @Cte
SELECT Cliente.Cliente, ISNULL(MAX(Ve.ID), 0)
FROM Campana Ca
JOIN CampanaTipo CT ON Ca.CampanaTipo = CT.CampanaTipo AND Ca.Estatus = 'PENDIENTE'
JOIN CampanaD Visitas ON Ca.ID = Visitas.ID AND Visitas.Usuario = @Usuario
JOIN Cte Cliente ON Visitas.Contacto = Cliente.Cliente
LEFT JOIN CteEnviarA Sucursales ON Cliente.Cliente = Sucursales.Cliente AND Visitas.EnviarA = Sucursales.ID
JOIN MovTipo MT ON Ca.Mov = MT.Mov AND MT.Modulo = 'CMP' AND MT.Clave = 'CMP.A'
LEFT JOIN CampanaTipoSituacion TS ON Visitas.Situacion = TS.Situacion
LEFT JOIN Venta Ve ON Cliente.Cliente = Ve.Cliente AND Ve.Estatus IN ('PENDIENTE','CONCLUIDO')
WHERE TS.AccionMovil NOT IN ('Cancelado', 'Confirmado')
GROUP BY Cliente.Cliente
DELETE OfertaMovilTemp WHERE GUID = @GUID
INSERT OfertaMovilTemp(
GUID,ListaPrecios,Articulo)
SELECT DISTINCT @GUID,ISNULL(NULLIF(d.ListaPreciosEsp,''),e.ListaPreciosEsp),lp.Articulo
FROM Campana c
JOIN CampanaD d on c.ID = d.ID
JOIN Cte e on d.Contacto = e.Cliente
JOIN CampanaTipoSituacion t on d.Situacion = t.Situacion
JOIN MovTipo m on c.Mov = m.Mov AND m.Modulo = 'CMP'
JOIN ListaPreciosD lp ON ISNULL(NULLIF(d.ListaPreciosEsp,''),e.ListaPreciosEsp) = lp.Lista
JOIN Art a ON lp.Articulo = a.Articulo
WHERE m.Clave = 'CMP.A' AND c.Estatus ='PENDIENTE' AND t.AccionMovil IN('Sincronizado','Por Sincronizar') AND c.Agente = @Agente 
INSERT OfertaMovilTemp(
GUID,ListaPrecios,Articulo)
SELECT DISTINCT @GUID,ISNULL(c.ListaPreciosEsp,''),pd.Articulo
FROM Cte c
JOIN ListaPrecios p ON c.ListaPreciosEsp = p.Lista
JOIN ListaPreciosD pd ON p.Lista = pd.Lista
JOIN Art a ON pd.Articulo = a.Articulo
LEFT JOIN OfertaMovilTemp MT ON a.Articulo = MT.Articulo AND c.ListaPreciosEsp = MT.ListaPrecios AND MT.GUID = @GUID
WHERE c.Agente = @Agente AND MT.Articulo IS NULL
INSERT OfertaMovilTemp(
GUID,ListaPrecios,Articulo)
SELECT DISTINCT @GUID,ISNULL(c.ListaPreciosEsp,''), pd.Articulo
FROM CteEnviarA c
JOIN ListaPrecios p ON c.ListaPreciosEsp = p.Lista
JOIN ListaPreciosD pd ON p.Lista = pd.Lista
JOIN Art a ON pd.Articulo = a.Articulo
LEFT JOIN OfertaMovilTemp MT ON a.Articulo = MT.Articulo AND c.ListaPreciosEsp = MT.ListaPrecios AND MT.GUID = @GUID
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
JOIN Venta Template ON Cliente.Cliente = Template.Cliente AND Cliente.VentaID = Template.ID
JOIN (
SELECT Detalle.ID,
Detalle.Articulo,
ISNULL(Detalle.Cantidad, 0) Cantidad,
ISNULL(Detalle.DescuentoImporte, 0) DescuentoImporte,
ISNULL(Detalle.DescuentoLinea, 0) DescuentoLinea,
dbo.fnISGetArtOpcion(Detalle.Articulo, @Agente, @@SPID) Articulos
FROM VentaD Detalle
JOIN @Cte Template ON Detalle.ID = Template.VentaID
) AS Detalle ON Template.ID = Detalle.ID
) AS MovilVentaTemplate FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF @Resultado IS NULL
SELECT @Resultado = CAST('<Intelisis Contenido="Resultado" Version="1.0" SubReferencia="" Referencia="Intelisis.Movil.Venta.Template" Sistema="Intelisis"><Resultado IntelisisServiceID="'+CONVERT(varchar,(@ID))+'" OkRef="" Ok="" /></Intelisis>' AS NVARCHAR(MAX))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
END

