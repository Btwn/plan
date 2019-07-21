SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforCuadrarExistenciaMES
@Usuario		varchar(10),
@Empresa		varchar(5),
@Sucursal		int,
@eArticulo     varchar(20) = NULL,
@eSerieLote    varchar(20) = NULL,
@eAlmacen      varchar(10) = NULL

AS
BEGIN
DECLARE
@AccesoID							int,
@Ok									int,
@OkRef								varchar(255),
@Contrasena							varchar(32),
@Resultado							varchar(max),
@Resultado2							varchar(max),
@Id									int,
@Version							float,
@SubReferencia                      varchar(255) ,
@Datos								varchar (max),
@ReferenciaIntelisisService         varchar(50)
DECLARE @Tabla table(
Articulo			varchar(20),
SubCuenta			varchar(50),
SerieLote			varchar(20),
Almacen			varchar(10),
EntradaSalida		varchar(1),
Existencia		float
)
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
IF EXISTS ( SELECT *
FROM IntelisisService
WITH(NOLOCK) WHERE Referencia  IN (
'Intelisis.Cuenta.Alm.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Alm',
'Intelisis.Cuenta.CteTipo.Listado',
'Intelisis.Interfaz.Infor.Transferencia.CteTipo',
'Intelisis.Cuenta.Mon.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Mon',
'Intelisis.Interfaz.Infor.Transferencia.Prov',
'Intelisis.Cuenta.Prov.Listado',
'Intelisis.Cuenta.Usuario.Listado',
'Intelisis.Interfaz.Infor.Transferencia.ArtContadorLotes',
'Intelisis.Interfaz.Infor.Transferencia.Usuario',
'Intelisis.Cuenta.ArtFam.Listado',
'Intelisis.Interfaz.Infor.Transferencia.ArtFam',
'Intelisis.Cuenta.Departamento.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Departamento',
'Intelisis.Cuenta.Empresa.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Empresa',
'Intelisis.COMS.Mov.Listado',
'Intelisis.Interfaz.Infor.Transferencia.COMS_F',
'Intelisis.Interfaz.Infor.Transferencia.COMS_O',
'Intelisis.Interfaz.Infor.Transferencia.COMS_OC',
'Intelisis.Interfaz.Infor.Transferencia.VTAS_PR',
'Intelisis.Cuenta.Cte.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Cte',
'Intelisis.Cuenta.Unidad.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Unidad',
'Intelisis.Cuenta.Personal.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Personal',
'Intelisis.COMS.InsertarMov.COMS_O',
'Intelisis.Cuenta.Art.Insertar',
'Intelisis.INV.InsertarMov.INV_E',
'Intelisis.INV.InsertarMov.INV_S',
'Intelisis.Cuenta.Sucursal.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Sucursal',
'Intelisis.Interfaz.Infor.Solicitud.ObjetivosVentas',
'Intelisis.Interfaz.Infor.Insertar.CancelacionMov',
'Intelisis.Cuenta.Planta.Usuario.Listado',
'Intelisis.Interfaz.Infor.Transferencia.PlantaUsuario',
'Intelisis.Cuenta.Planta.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Planta',
'Intelisis.Cuenta.ArtLinea.Listado',
'Intelisis.Interfaz.Infor.Transferencia.ArtLinea',
'Intelisis.PC.InsertarMov.PC_C',
'Intelisis.Cuenta.MotivoRechazo.Listado',
'Intelisis.Interfaz.Infor.Transferencia.MotivoRechazo',
'Intelisis.Interfaz.Infor.Transferencia.OpcionDetalle',
'Intelisis.Interfaz.Infor.Transferencia.Opcion',
'Intelisis.INV.InsertarMov.NOM_P',
'Intelisis.Interfaz.Infor.CancelarMov',
'Intelisis.INV.InsertarMov.INV_EST',
'Infor.Movimiento.Procesar.COMS_OC',
'Infor.Movimiento.Procesar.COMS_O',
'Infor.Cuenta.ArtContadorLotes.Mantenimiento',
'Infor.Cuenta.ArtLinea.Mantenimiento',
'Infor.Reporte.ObjetivosVentas',
'Infor.Cuenta.Cte.Mantenimiento',
'Infor.Cuenta.Usuario.Mantenimiento',
'Infor.Cuenta.Proveedor.Mantenimiento',
'Infor.Cuenta.Planta.Usuario.Mantenimiento',
'Infor.Movimiento.Procesar.VTAS_P',
'Infor.Cuenta.Art.Mantenimiento',
'Infor.Cuenta.Personal.Mantenimiento',
'Infor.Cuenta.Moneda.Mantenimiento',
'Infor.Cuenta.ArtFam.Mantenimiento',
'Infor.Movimiento.Procesar.COMS_F',
'Infor.Cuenta.MotivoRechazo.Mantenimiento',
'Infor.Cuenta.Unidad.Mantenimiento',
'Infor.Movimiento.Procesar.VTAS_PR',
'Infor.Cuenta.Planta.Mantenimiento',
'Infor.Movimiento.Procesar.COMS_OC',
'Infor.Cuenta.Empresa.Mantenimiento',
'Infor.Cuenta.CteTipo.Mantenimiento',
'Infor.Cuenta.Almacen.Mantenimiento',
'Infor.Cuenta.Opcion.Mantenimiento',
'Infor.Cuenta.OpcionDetalle.Mantenimiento'
)
AND Estatus IN ('SINPROCESAR')
)
SET @Ok = 2
IF @Ok IS NULL
BEGIN
INSERT INTO @Tabla (Articulo,   SubCuenta,    SerieLote,                     Almacen,   Existencia,												  EntradaSalida)
SELECT e.Articulo ,e.SubCuenta , ISNULL(e.SerieLote,'(none)') , e.Almacen, ISNULL(e.ExistenciaInte,0.0)-ISNULL(e.ExistenciaMES,0.0), CASE	WHEN ISNULL(e.ExistenciaInte,0.0) - ISNULL(e.ExistenciaMES,0.0) > 0.0  THEN 'E'  WHEN ISNULL(e.ExistenciaInte,0.0) - ISNULL(e.ExistenciaMES,0.0) < 0.0  THEN 'S'  END
FROM ArtExistenciaIntMES e
 WITH(NOLOCK) JOIN Alm a  WITH(NOLOCK) ON e.Almacen = a.Almacen
WHERE ISNULL(a.EsFactory,0) = 1
AND e.Articulo  = ISNULL(@eArticulo, e.Articulo)
AND e.Almacen   = ISNULL(@eAlmacen, e.Almacen)
AND e.SerieLote = ISNULL(@eSerieLote, e.SerieLote)
UPDATE @Tabla
SET Existencia = Existencia * -1
WHERE EntradaSalida = 'S'
SET @Resultado2 = ISNULL(CONVERT(varchar(max), (SELECT * FROM @Tabla InvExistencia FOR XML AUTO)),'')
SET @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) + 'Intelisis.INV.Cuadrar.ExistenciaMES' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' ReferenciaIntelisisService=' + CHAR(34) + ISNULL(@ReferenciaIntelisisService,'') + CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
EXEC spIntelisisService  @Usuario, @Contrasena, @Datos, @Resultado, @Ok Output, @OkRef Output, 0, 0, @Id Output
IF @OK IS NOT NULL
BEGIN
SELECT @OkRef = Descripcion
FROM MensajeLista
WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT CONVERT(varchar,@ok) + ' ' + @OkRef
END
ELSE
SELECT 'Proceso Concluido. <BR>Los ajustes en el inventario pueden tardar algunos minutos en verse reflejados,<BR>por favor espere antes de verificar los resultados.'
END
IF @Ok = 2
SELECT 'Existen Tareas Por Procesar No Se Puede Cuadrar La Existencia'
END

