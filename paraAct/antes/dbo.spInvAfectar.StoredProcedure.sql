create procedure [dbo].[spinvafectar]
@id int,
@accionchar(20),
@basechar(20),
@empresa char(5),
@modulo char(5),
@mov char(20),
@movid varchar(20)output,
@movtipo char(20),
@movmoneda char(10),
@movtipocambio float,
@fechaemisiondatetime,
@fechaafectacion datetime,
@fechaconclusion datetime,
@concepto varchar(50),
@proyecto varchar(50),
@usuario char(10),
@autorizacion char(10),
@referencia varchar(50),
@docfuente int,
@observaciones varchar(255),
@estatus char(15),
@estatusnuevochar(15),
@fecharegistro datetime,
@ejercicio int,
@periodo int,
@almacen char(10),
@almacentipochar(15),
@almacendestino char(10),
@almacendestinotipochar(15),
@voltearalmacenbit,
@almacenespecificochar(10),
@larbit,
@condicionvarchar(50),
@vencimientodatetime,
@periodicidadvarchar(20),
@endosaravarchar(10),
@clienteprovchar(10),
@enviaraint,
@descuentoglobalfloat,
@sobrepreciofloat,
@agentechar(10),
@anticiposfacturadosmoney,
@servicioarticulochar(20),
@servicioseriechar(20),
@fecharequeridadatetime,
@zonaimpuestovarchar(50),
@origentipovarchar(10),
@origenvarchar(20),
@origenidvarchar(20),
@origenmovtipovarchar(20),
@cfgformacosteo char(20),
@cfgtipocosteo char(20),
@cfgcosteoactividadesvarchar(20),
@cfgcosteonivelsubcuentabit,
@cfgcosteomultiplesimultaneo bit,
@cfgposicionesbit,
@cfgexistenciaalternabit,
@cfgexistenciaalternaserielote bit,
@cfgserieslotesmayoreobit,
@cfgserieslotesautocampochar(20),
@cfgserieslotesautoordenchar(20),
@cfgcosteoseriesbit,
@cfgcosteolotesbit,
@cfgvalidarlotescostodifbit,
@cfgventasurtirdemasbit,
@cfgcomprarecibirdemasbit,
@cfgtransferirdemasbit,
@cfgbackordersbit,
@cfgcontxbit,
@cfgcontxgenerarchar(20),
@cfgcontxfacturaspendientes bit,
@cfgembarcarbit,
@cfgimpincbit,
@cfgventacontratosarticulochar(20),
@cfgventacontratosimpuestofloat,
@cfgventacomisionescobradasbit,
@cfganticiposfacturadosbit,
@cfgmultiunidadesbit,
@cfgmultiunidadesnivelchar(20),
@cfgcomprafactordinamico bit,
@cfginvfactordinamico bit,
@cfgprodfactordinamico bit,
@cfgventafactordinamico bit,
@cfgcompraautocarsbit,
@cfgventaautobonifbit,
@cfgvinaccesorioart bit,
@cfgvincostosumaaccesoriosbit,
@seguimientomatrizbit,
@cobrointegradobit,
@cobrointegradocxcbit,
@cobrointegradoparcial bit,
@cobrarpedidobit,
@afectardetalle bit,
@afectarmatandobit,
@afectarvtasmostradorbit,
@facturarvtasmostradorbit,
@afectarconsignacionbit,
@afectaralmacenrenglonbit,
@cfgventamultiagentebit,
@cfgventamultialmacenbit,
@cfgventaartalmacenespecifico bit,
@cfgtipomermachar(1),
@cfgcomisionbasechar(20),
@cfglimiterenfacturasint,
@cfgventaredondeodecimalesint,
@cfgcompracostosimpuestoincluido bit,
@afectarconsecutivobit,
@estransferenciabit,
@conexionbit,
@sincrofinalbit,
@sucursalint,
@sucursaldestinoint,
@sucursalorigenint,
@utilizarbit,
@utilizaridint,
@utilizarmovchar(20),
@utilizarseriechar(20),
@utilizarmovtipochar(20),
@utilizarmovidvarchar(20),
@generar bit,
@generarmov char(20),
@generarseriechar(20),
@generarafectadobit,
@generarcopiabit,
@generarpolizabit,
@generaropbit,
@generargastobit,
@facturacionrapidaagrupadabit,
@idtransitoint output,
@idgenerar int output,
@generarmovid varchar(20) output,
@contidint output,
@ok int output,
@okref varchar(255) output,
@cfgpreciomonedabit = 0
as begin
declare
@diasint,
@renglon float,
@renglonsub int,
@renglonidint,
@renglontipochar(1),
@articulo char(20),
@posicionchar(10),
@auxiliaralternosucursalint,
@auxiliaralternoalmacenchar(10),
@auxiliaralternofactorentrada float,
@auxiliaralternofactorsalida float,
@arttipo varchar(20),
@artserieloteinfobit,
@arttipoopcionvarchar(20),
@artcomisionvarchar(50),
@pesofloat,
@volumenfloat,
@subcuenta varchar(50),
@acumularsindetallesbit,
@acumcantidadfloat,
@cantidad float,
@factorfloat,
@movunidadvarchar(50),
@cantidadoriginalfloat,
@cantidadobsequiofloat,
@cantidadinventariofloat,
@cantidadreservada float,
@cantidadordenadafloat,
@cantidadordenadaafloat,
@cantidadpendiente float,
@cantidadpendienteafloat,
@cantidada float,
@idsalidatraspasoint,
@idaplicaint,
@aplicamov char(20),
@aplicamovid varchar(20),
@aplicamovtipochar(20),
@almacenrenglonchar(10),
@agenterenglonchar(10),
@almacenorigenchar(10),
@costo float,
@costoinvfloat,
@costoinvtotal money,
@precio float,
@precion float,
@preciotipocambiofloat,
@descuentotipo char(1),
@descuentolinea float,
@impuesto1 float,
@impuesto1n float,
@impuesto2 float,
@impuesto2n float,
@impuesto3 money,
@impuesto3n money,
@importe money,
@importeneto money,
@impuestos money,
@impuestosnetosmoney,
@impuesto1neto money,
@impuesto2neto money,
@impuesto3neto money,
@importecomisionmoney,
@descuentolineaimportemoney,
@descuentoglobalimportemoney,
@sobreprecioimportemoney,
@anticipoimportemoney,
@anticipoimpuestosmoney,
@importecxmoney,
@impuestoscxmoney,
@retencioncxmoney,
@retencion2cxmoney,
@retencion3cxmoney,
@importetotalcxmoney,
@condicioncxvarchar(50),
@vencimientocxdatetime,
@facturandoremision bit,
@tienependientesbit,
@sumapendiente float,
@sumareservadafloat,
@sumaordenadafloat,
@sumaimportemoney,
@sumaimporteneto money,
@sumaimpuestos money,
@sumaimpuestosnetos money,
@sumaimpuesto1neto money,
@sumaimpuesto2neto money,
@sumaimpuesto3neto money,
@sumadescuentolineamoney,
@sumapreciolineamoney,
@sumacostolineamoney,
@sumapesofloat,
@sumavolumenfloat,
@sumacomisionmoney,
@sumaretencionmoney,
@sumaretencion2money,
@sumaretencion3money,
@sumaretencionesmoney,
@sumaanticiposfacturadosmoney,
@retencionmoney,
@retencion2money,
@retencion3money,
@paquetesint,
@importetotalmoney,
@movimpuesosubtotalmoney,
@importematarmoney,
@fechacancelaciondatetime,
@artunidadvarchar(50),
@artcantidadfloat,
@artcosto float,
@artcostoinvfloat,
@artajustecosteofloat,
@artcostouepsfloat,
@artcostopepsfloat,
@artultimocostofloat,
@artpreciolistafloat,
@artdepartamentodetallistaint,
@artmonedachar(10),
@artfactor float,
@arttipocambiofloat,
@artcostoidentificadobit,
@ajustepreciolistamoney,
@movretencion1float,
@movretencion2float,
@movretencion3float,
@reservadoparcialfloat,
@explotandorenglonfloat,
@explotandosubcuentabit,
@esentrada bit,
@essalida bit,
@escarbit,
@afectarcantidadfloat,
@afectaralmacenchar(10),
@afectaralmacendestinochar(10),
@afectarserielotebit,
@afectarcostos bit,
@afectarunidades bit,
@afectarpiezas bit,
@afectarramachar(5),
@utilizarbasechar(20),
@utilizarestatuschar(15),
@generaralmacenchar(10),
@generaralmacendestinochar(10),
@generarestatuschar(15),
@generardirectobit,
@generarmovtipo char(20),
@generarperiodo int,
@generarejercicio int,
@generarpolizatempbit,
@yageneroconsecutivobit,
@cxmodulochar(5),
@cxidint,
@cxmovchar(20),
@cxmovidvarchar(20),
@cxmovespecificovarchar(20),
@cxagentechar(10),
@cxmovtipovarchar(20),
@cximportemoney,
@cxajusteidint,
@cxajustemovchar(20),
@cxajustemovidvarchar(20),
@cxajusteimportemoney,
@cxconceptovarchar(50),
@compraidint,
@clientechar(10),
@detalletipovarchar(20),
@mermafloat,
@desperdiciofloat,
@cantidadcalcularimportefloat,
@destinotipo varchar(10),
@destinovarchar(20),
@destinoidvarchar(20),
@cobrodesglosadomoney,
@cobrocambiomoney,
@cobroredondeomoney,
@cobrosumaefectivomoney,
@cobrodelefectivomoney,
@valescobradosmoney,
@tarjetascobradasmoney,
@dineroimportemoney,
@dineromodulochar(5),
@dineromovchar(20),
@dineromovidvarchar(20),
@movimpuestobit,
@importe1money,
@importe2money,
@importe3money,
@importe4money,
@importe5money,
@importecambiomoney,
@formacobro1varchar(50),
@formacobro2varchar(50),
@formacobro3varchar(50),
@formacobro4varchar(50),
@formacobro5varchar(50),
@formacobrovalesvarchar(50),
@formacobrotarjetasvarchar(50),
@incrementasaldotarjetabit,
@formapacambiovarchar(50),
@referencia1varchar(50),
@referencia2varchar(50),
@referencia3varchar(50),
@referencia4varchar(50),
@referencia5varchar(50),
@ctadinerochar(10),
@cajerochar(10),
@formamonedachar(10),
@formatipocambiofloat,
@almacenespecificoventachar(10),
@matarantesbit,
@ultrenglonidjueint,
@cantidadjuefloat,
@cantidadminimajueint,
@almacentempchar(10),
@almacenoriginalchar(10),
@almacendestinooriginalchar(10),
@prodserielotevarchar(50),
@vinvarchar(20),
@ultreservadocantidadfloat,
@ultreservadofechadatetime,
@ultagentechar(10),
@comisionacummoney,
@comisionimportenetofloat,
@comisionfactorfloat,
@productovarchar(20),
@subproductovarchar(50),
@ivafiscalfloat,
@iepsfiscalfloat,
@afectandonotassincobrobit,
@continuarbit,
@artprovcostofloat,
@proveedorref varchar(10),
@cfgretencionalpabit,
@cfgretencionmovchar(20),
@cfgretencionacreedorchar(10),
@cfgretencionconceptovarchar(50),
@cfgretencion2acreedorchar(10),
@cfgretencion2conceptovarchar(50),
@cfgretencion3acreedorchar(10),
@cfgretencion3conceptovarchar(50),
@cfgingresomovchar(20),
@cfgestadisticaajustemermachar(20),
@cfginvajustecaragentevarchar(20),
@cfgventadmultiagentesugerir bit,
@cfgventamonederobit,
@cfgventapuntosenvalesbit,
@espaciodvarchar(10),
@espaciodanteriorvarchar(10),
@rutachar(20),
@ordenint,
@ordendestinoint,
@centrochar(10),
@centrodestinochar(10),
@estacionchar(10),
@estaciondestinochar(10),
@tiempoestandarfijofloat,
@tiempoestandarvariable float,
@descuentoinversofloat,
@sucursalalmacen int,
@sucursalalmacendestino int,
@prorrateoaplicaidint,
@prorrateoaplicaidmovvarchar(20),
@prorrateoaplicaidmovidvarchar(20),
@artlotesfijosbit,
@artactividadesbit,
@serieslotesautoordenvarchar(50),
@costoactividadmoney,
@cotizacionidint,
@cotizacionestatusnuevochar(15),
@hoydatetime,
@redondeomonetariosint,
@cfgdiashabilesvarchar(20),
@cfgabcdiashabilesbit,
@costosimpuestoincluido bit,
@borrarretencioncxbit,
@movimpuestofactorfloat,
@preciosinimpuestosfloat,
@modificarcosto float,
@modificarprecio float,
@cfgacbit,
@lcmetodoint,
@lcporcentajeresidualfloat,
@pptobit,
@pptoventasbit,
@wmsbit,
@wmsmovvarchar(20),
@transitosucursalint,
@transitomov varchar(20),
@transitomovid varchar(20),
@transitoestatus varchar(15),
@traspasoexpressmovvarchar(20),
@traspasoexpressmovidvarchar(20),
@feabit,
@feaconsecutivovarchar(20),
@feareferenciavarchar(50),
@feaserievarchar(20),
@feafolioint,
@movtipoconsecutivofeavarchar(20),
@cantidaddiffloat,
@cfgarrastrarserielotebit,
@cfgnotasborradorbit,
@novalidardisponiblebit,
@idorigen int,
@cfgventaartestatusbit,
@cfgventaartsituacionbit,
@artestatusvarchar(15),
@artsituacionvarchar(50),
@artexcento1bit,
@artexcento2bit,
@artexcento3bit,
@fiscalbit,
@referenciaaplicacionanticipo varchar(50),
@cxendosomov varchar(20),
@cxendosomovid varchar(20),
@cxendosoid int,
@autoendosar varchar(20),
@proveedor varchar(20),
@cfgmovcxpendoso varchar(20),
@cfgcompraautoendosoautocars bit,
@cortedias int,
@menosdias int,
@dia int,
@esquince bit,
@daperiodo char(15)
set @cortedias = 2
set @esquince = 0
select @redondeomonetarios = redondeomonetarios from version select @artmoneda= null,
@sumapendiente = 0.0,
@sumareservada= 0.0,
@sumaordenada= 0.0,
@sumaimporte = 0.0,
@sumaimporteneto = 0.0,
@sumaimpuestos = 0.0,
@sumaimpuestosnetos = 0.0,
@sumaimpuesto1neto = 0.0,
@sumaimpuesto2neto = 0.0,
@sumaimpuesto3neto = 0.0,
@sumadescuentolinea= 0.0,
@sumacomision= 0.0,
@sumapreciolinea= 0.0,
@sumacostolinea= 0.0,
@sumapeso= 0.0,
@sumavolumen= 0.0,
@sumaretencion = 0.0,
@sumaretencion2 = 0.0,
@sumaretencion3 = 0.0,
@comisionacum= 0.0,
@comisionimporteneto= 0.0,
@explotandorenglon= null,
@yageneroconsecutivo = 0,
@matarantes = 0,
@ultrenglonidjue= null,
@detalletipo= null,
@merma= null,
@desperdicio = null,
@vin= null,
@ultagente= null,
@producto= null,
@subproducto= null,
@comisionfactor= 1.0,
@ivafiscal = null,
@iepsfiscal = null,
@sucursalalmacen = null,
@sucursalalmacendestino = null,
@artlotesfijos = 0,
@artactividades = 0,
@movimpuesto = 0,
@costosimpuestoincluido = 0,
@borrarretencioncx = 0,
@facturandoremision = 0,
@novalidardisponible = 0
select @almacenoriginal = @almacen, @almacendestinooriginal = @almacendestino
select @generaralmacen = @almacen, @generaralmacendestino = @almacendestino
select @hoy = @fecharegistro
exec spextraerfecha @hoy output
select @cfgdiashabiles = diashabiles,
@ppto = isnull(ppto, 0),
@pptoventas = isnull(pptoventas, 0),
@wms = isnull(wms, 0),
@cfgac = isnull(ac, 0),
@fea = isnull(fea, 0),
@fiscal = isnull(fiscal, 0)
from empresagral where empresa = @empresa
select @cfgretencionmov = case when @movtipo = 'coms.d' then cxpdevretencion else cxpretencion end,
@cfgingresomov = ventaingreso,
@cfgestadisticaajustemerma = investadisticaajustemerma
from empresacfgmov where empresa = @empresa
select @cfgarrastrarserielote = isnull(ventaarrastrarserielote, 0),
@cfgnotasborrador = notasborrador,
@cfgcompraautoendosoautocars = isnull(compraautoendosoautocars, 0)
from empresacfg where empresa = @empresa
if @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm') and @cfgnotasborrador = 1 and (@estatus in ('sinafectar', 'borrador', 'confirmar') or @accion = 'cancelar')
select @novalidardisponible = 1
select @cfgretencionalpa = isnull(retencionalpa, 0),
@cfgretencionacreedor = nullif(rtrim(gastoretencionacreedor), ''),
@cfgretencionconcepto = isnull(nullif(nullif(rtrim(gastoretencionconcepto), ''), '(concepto gasto)'), @concepto),
@cfgretencion2acreedor = nullif(rtrim(gastoretencion2acreedor), ''),
@cfgretencion2concepto = isnull(nullif(nullif(rtrim(gastoretencion2concepto), ''), '(concepto gasto)'), @concepto),
@cfgretencion3acreedor = nullif(rtrim(gastoretencion3acreedor), ''),
@cfgretencion3concepto = isnull(nullif(nullif(rtrim(gastoretencion3concepto), ''), '(concepto gasto)'), @concepto),
@cfgabcdiashabiles = isnull(invfrecuenciaabcdiashabiles, 0),
@cfginvajustecaragente = upper(invajustecaragente),
@cfgventadmultiagentesugerir = isnull(ventadmultiagentesugerir, 0),
@cfgventapuntosenvales = isnull(ventapuntosenvales, 0),
@cfgventamonedero = isnull(ventamonedero, 0),
@cfgventaartestatus = isnull(ventaartestatus, 0),
@cfgventaartsituacion = isnull(ventaartsituacion, 0)
from empresacfg2 where empresa = @empresa
if @origentipo = 'inv'
select @idorigen = id from inv where empresa = @empresa and sucursal = @sucursal and mov = @origen and movid = @origenid and estatus in ('pendiente', 'concluido')
if @origentipo = 'vtas'
select @idorigen = id from venta where empresa = @empresa and sucursal = @sucursal and mov = @origen and movid = @origenid and estatus in ('pendiente', 'concluido')
if @origentipo = 'coms'
select @idorigen = id from compra where empresa = @empresa and sucursal = @sucursal and mov = @origen and movid = @origenid and estatus in ('pendiente', 'concluido')
if @origentipo = 'prod'
select @idorigen = id from prod where empresa = @empresa and sucursal = @sucursal and mov = @origen and movid = @origenid and estatus in ('pendiente', 'concluido')
if @accion in ('reservar', 'desreservar', 'reservarparcial', 'asignar', 'desasignar') and @movtipo not in ('vtas.p', 'vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx', 'vtas.s', 'inv.sol', 'inv.sm', 'inv.ot', 'inv.oi')
select @ok = 60040
if @utilizar = 1
begin
if @utilizar = 1 and @movtipo in ('vtas.dc', 'vtas.dcr') select @generaralmacen = @almacendestino, @generaralmacendestino = @almacen
if @accion = 'generar' select @generarestatus = 'sinafectar' else select @generarestatus = 'cancelado'
if @utilizarmovtipo in ('vtas.c','vtas.cs','vtas.fr','vtas.cto','coms.c') select @generardirecto = 1 else select @generardirecto = 0
if @utilizarmovtipo = 'vtas.co' and @cfgventacontratosarticulo is null select @ok = 20470
if @voltearalmacen = 1 select @almacentemp = @generaralmacen, @generaralmacen = @generaralmacendestino, @generaralmacendestino = @almacentemp
if @ok is null
begin
exec spmovgenerar @sucursal, @empresa, @modulo, @ejercicio, @periodo, @usuario, @fecharegistro, @generarestatus,
@generaralmacen, @generaralmacendestino,
@utilizarmov, @utilizarmovid, @generardirecto,
@mov, @utilizarserie, @movid output, @id output, @ok output, @okref output
if @ok is null and (@movtipo in ('inv.ei', 'inv.dti', 'inv.si') or (@utilizarmovtipo in ('vtas.vcr', 'vtas.p', 'vtas.c') and @cfgarrastrarserielote = 1))
exec spmovcopiarserielote @sucursal, @modulo, @utilizarid, @id, 1
end
if @ok is null
select @yageneroconsecutivo = 1
if @ok is null
begin
if @movtipo = 'vtas.eg'
update venta with (rowlock) set almacendestino = (select almacendestinoentregagarantia from empresacfg where empresa = @empresa) where id = @id
if @utilizarmovtipo = 'vtas.co'
begin
update venta with (rowlock) set condicion = null, vencimiento = null, referencia = rtrim(@utilizarmov)+' '+ltrim(convert(char, @utilizarmovid)) where id = @id
select @precio = sum(precio * (cantidad-isnull(cantidadcancelada,0)) * (1-(case descuentotipo when '$' then (isnull(descuentolinea, 0.0)/precio)*100 else isnull(descuentolinea,0.0) end)/100))
from ventad where id = @utilizarid
insert into ventad (sucursal, id, renglon, aplica, aplicaid, articulo, cantidad, precio, impuesto1, almacen)
values (@sucursal, @id, 2048, @utilizarmov, @utilizarmovid, @cfgventacontratosarticulo, 1, @precio, @cfgventacontratosimpuesto, @almacen)
end else
begin
exec spinvutilizartododetalle @sucursal, @modulo, @base, @utilizarid, @utilizarmov, @utilizarmovid, @utilizarmovtipo, @id, @generardirecto, @ok output, @empresa = @empresa, @movtipo = @movtipo
if @movtipo in ('coms.eg', 'coms.ei', 'coms.oi', 'inv.ei')
exec spmovcopiargastodiverso @modulo, @sucursal, @utilizarid, @id
if @movtipo in ('vtas.f','vtas.far') and @cfglimiterenfacturas > 0
if @facturacionrapidaagrupada = 1
exec spinvlimiterenfacturasagrupada @id, @cfglimiterenfacturas
else
exec spinvlimiterenfacturas @id, @cfglimiterenfacturas
if @utilizarmovtipo in ('vtas.vc', 'vtas.vcr') and @movtipo not in ('vtas.dc', 'vtas.dcr') update ventad with (rowlock) set almacen = @generaralmacen where id = @id else
if @utilizarmovtipo = 'inv.p' update invd with (rowlock) set almacen = @generaralmacendestino where id = @id else
if @utilizarmovtipo = 'inv.sm' and @movtipo = 'inv.cm' update invd with (rowlock) set tipo = 'salida' where id = @id else
if @utilizarmovtipo = 'prod.o' and @movtipo in ('prod.e', 'prod.co')
begin
if @cfgtipomerma = '#'
update prodd with (rowlock)
set tipo = 'entrada',
cantidad = cantidad - isnull(a.merma, 0) - isnull(a.desperdicio, 0),
merma = a.merma,
desperdicio = a.desperdicio
from prodd d, art a where d.articulo = a.articulo and d.id = @id
else
update prodd with (rowlock)
set tipo = 'entrada',
cantidad = cantidad - isnull(round(d.cantidad*(a.merma/100), 10), 0) - isnull(round(d.cantidad*(a.desperdicio/100), 10), 0),
merma = round(d.cantidad*(a.merma/100), 10),
desperdicio = round(d.cantidad*(a.desperdicio/100), 10)
from prodd d, art a where d.articulo = a.articulo and d.id = @id
update prodd with (rowlock) set cantidadinventario = cantidad * factor where id = @id
end
end
select @utilizarbase = @base, @base = 'todo', @idgenerar = @id
end
end else
if @voltearalmacen = 1 select @almacentemp = @generaralmacen, @generaralmacen = @generaralmacendestino, @generaralmacendestino = @almacentemp
if @modulo = 'vtas' and @accion <> 'cancelar' and @estatus = 'sinafectar'
if exists(select convigencia from venta where id = @id and convigencia = 1)
update cte with (rowlock)
set vigenciadesde = v.vigenciadesde, vigenciahasta = v.vigenciahasta
from venta v where v.id = @id and v.cliente = cte.cliente
if @accion = 'generar' and @ok is null
begin
if @utilizar = 1
begin
exec spmovtipo @modulo, @mov, @fechaafectacion, @empresa, null, null, @generarmovtipo output, @generarperiodo output, @generarejercicio output, @ok output
begin transaction
if @utilizarmovtipo in ('vtas.c', 'vtas.cs', 'coms.c')
begin
exec spvalidartareas @empresa, @modulo, @utilizarid, 'concluido', @ok output, @okref output
if @utilizarmovtipo in ('vtas.c', 'vtas.cs') update venta with (rowlock) set estatus = 'concluido' where id = @utilizarid else
if @utilizarmovtipo = 'coms.c' update compra with (rowlock) set estatus = 'concluido' where id = @utilizarid
if @@error <> 0 select @ok = 1
exec spmovflujo @sucursal, @accion, @empresa, @modulo, @utilizarid, @utilizarmov, @utilizarmovid, @modulo, @id, @mov, 0, @ok output
end
if @utilizarbase = 'seleccion'
begin
if @modulo = 'vtas' update ventad with (rowlock) set cantidada = null where id = @utilizarid and cantidada is not null else
if @modulo = 'coms' update comprad with (rowlock) set cantidada = null where id = @utilizarid and cantidada is not null else
if @modulo = 'inv' update invd with (rowlock) set cantidada = null where id = @utilizarid and cantidada is not null else
if @modulo = 'prod' update prodd with (rowlock) set cantidada = null where id = @utilizarid and cantidada is not null
if @@error <> 0 select @ok = 1
end
if @cfgventaartalmacenespecifico = 1 and @modulo = 'vtas'
begin
if @cfgventamultialmacen = 0
begin
select @almacenespecificoventa = null
select @almacenespecificoventa = min(nullif(rtrim(almacenespecificoventa), ''))
from art a , ventad d where d.id = @id and d.articulo = a.articulo and a.almacenespecificoventamov = @mov and nullif(rtrim(a.almacenespecificoventa), '') is not null
if @almacenespecificoventa is not null
update venta with (rowlock) set almacen = @almacenespecificoventa where id = @id
end else
update ventad with (rowlock)
set almacen = nullif(rtrim(almacenespecificoventa), '')
from ventad d, art a where d.id = @id and d.articulo = a.articulo and a.almacenespecificoventamov = @mov and nullif(rtrim(a.almacenespecificoventa), '') is not null
end
if @utilizarmovtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm') and @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm')
begin
update ventad with (rowlock) set cantidad = -abs(cantidad), cantidadinventario = -abs(cantidadinventario), aplica = null, aplicaid = null where id = @id
update venta with (rowlock) set directo = 1, referencia = rtrim(@utilizarmov)+' '+rtrim(@utilizarmovid) where id = @id
end
if @utilizarmovtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm') and @movtipo = 'vtas.sd'
begin
update ventad with (rowlock) set aplica = null, aplicaid = null where id = @id
update venta with (rowlock) set directo = 1, referencia = rtrim(@utilizarmov)+' '+rtrim(@utilizarmovid) where id = @id
end
if @modulo = 'vtas'
begin
if @movtipo in ('vtas.n', 'vtas.fm')
update venta with (rowlock) set condicion = null, vencimiento = null where id = @id
else
if @movtipo <> 'vtas.fr'
begin
exec spcalcularvencimiento @modulo, @empresa, @clienteprov, @condicion, @hoy, @vencimiento output, null, @ok output
update venta with (rowlock) set vencimiento = @vencimiento where id = @id and vencimiento <> @vencimiento
end
end
if @utilizarmovtipo = 'inv.p'
update inv with (rowlock) set almacen = almacendestino, almacendestino = almacen where id = @id
if @movtipo in ('prod.a', 'prod.r', 'prod.e')
exec spprodavancetiempocentro @id, @movtipo, @movmoneda, @movtipocambio
if @ok is null
exec xpinvafectar @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @conexion, @sincrofinal, @sucursal,
@utilizarid, @utilizarmovtipo,
@ok output, @okref output
if @ok is null
commit transaction
else begin
rollback transaction
exec speliminarmov @modulo, @id
end
end
return
end
if @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr') and @accion = 'cancelar' and @estatus = 'concluido'
select @ok = 60060
if (@estatusnuevo in ('pendiente', 'concluido') and @modulo in ('vtas', 'coms') and
@movtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm', 'vtas.f', 'vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx', 'vtas.fb', 'vtas.d', 'vtas.df', 'vtas.b', 'coms.f', 'coms.fl', 'coms.eg', 'coms.ei', 'coms.d', 'coms.b', 'coms.cc', 'coms.dc', 'coms.ca') )
or (@estatusnuevo = 'procesar' and @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr'))
begin
select @movimpuesto = 1
create table #movimpuesto (
renglonfloatnot null,
renglonsubintnot null,
impuesto1floatnull,
impuesto2floatnull,
impuesto3floatnull,
importe1moneynull,
importe2moneynull,
importe3moneynull,
retencion1floatnull,
retencion2floatnull,
retencion3floatnull,
excento1bitnulldefault 0,
excento2bitnulldefault 0,
excento3bitnulldefault 0,
subtotalmoneynull,
lotefijovarchar(20)collate database_default null)
end
if @cobrointegrado = 1 and @cfgventacomisionescobradas = 1 and @cfgcomisionbase = 'cobro'
begin
select @comisionfactor = 1-abs(isnull(delefectivo / nullif((isnull(importe1, 0) + isnull(importe2, 0) + isnull(importe3, 0) + isnull(importe4, 0) + isnull(importe5, 0) - isnull(cambio, 0) + isnull(delefectivo, 0)), 0), 0.0))
from ventacobro with (nolock)
where id = @id
end
if @movtipo = 'inv.cp' and @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion = 'afectar'
exec spafectarcambiopresentacion @sucursal, @id, @empresa, @movmoneda, @movtipocambio, @cfgmultiunidades, @cfgmultiunidadesnivel, @cfgformacosteo, @cfgtipocosteo, @ok output, @okref output
if @ok is null and @yageneroconsecutivo = 0
exec spmovconsecutivo @sucursal, @sucursalorigen, @sucursaldestino, @empresa, @usuario, @modulo, @ejercicio, @periodo, @id, @mov, null, @estatus, @concepto, @accion, @conexion, @sincrofinal, @movid output, @ok output, @okref output
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion <> 'cancelar' and @ok is null
exec spmovchecarconsecutivo@empresa, @modulo, @mov, @movid, null, @ejercicio, @periodo, @ok output, @okref output
if @estatusnuevo = 'confirmar' and @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm') return
if @accion in ('consecutivo', 'sincro') and @ok is null
begin
if @accion = 'sincro' exec spasignarsucursalestatus @id, @modulo, @sucursaldestino, @accion
select @ok = 80060, @okref = @movid, @sucursal = @sucursaldestino
return
end
if @generar = 1 and @ok is null
begin
if @movtipo = 'inv.if' select @generarestatus = 'sinafectar' else select @generarestatus = 'cancelado'
if @movtipo in ('vtas.c','vtas.cs','vtas.fr') select @generardirecto = 1 else select @generardirecto = 0
exec spmovgenerar @sucursal, @empresa, @modulo, @ejercicio, @periodo, @usuario, @fecharegistro, @generarestatus,
@almacen, @almacendestino,
@mov, @movid, @generardirecto,
@generarmov, @generarserie, @generarmovid output, @idgenerar output, @ok output, @okref output
end
if @ok is not null or @afectarconsecutivo = 1 return
if @conexion = 0
begin transaction
exec spmovestatus @modulo, 'afectando', @id, @generar, @idgenerar, @generarafectado, @ok output
if @estatus in ('sinafectar', 'confirmar', 'borrador')
begin
if (select sincro from version with (nolock)) = 1
begin
if @modulo = 'inv' exec sp_executesql n'update invd with (rowlock) set sucursal = @sucursal, sincroc = 1 where id = @id and (sucursal <> @sucursal or sincroc <> 1)', n'@sucursal int, @id int', @sucursal, @id else
if @modulo = 'vtas' exec sp_executesql n'update ventad with (rowlock) set sucursal = @sucursal, sincroc = 1 where id = @id and (sucursal <> @sucursal or sincroc <> 1)', n'@sucursal int, @id int', @sucursal, @id else
if @modulo = 'coms' exec sp_executesql n'update comprad with (rowlock) set sucursal = @sucursal, sincroc = 1 where id = @id and (sucursal <> @sucursal or sincroc <> 1)', n'@sucursal int, @id int', @sucursal, @id else
if @modulo = 'prod' exec sp_executesql n'update prodd with (rowlock) set sucursal = @sucursal, sincroc = 1 where id = @id and (sucursal <> @sucursal or sincroc <> 1)', n'@sucursal int, @id int', @sucursal, @id
end
end
if @ok is null or @ok between 80030 and 81000
exec xpinvafectarantes @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @conexion, @sincrofinal, @sucursal,
null, null,
@ok output, @okref output
if @accion <> 'cancelar' and @estatus <> 'pendiente'
begin
exec spregistrarmovimiento @sucursal, @empresa, @modulo, @mov, @movid, @id, @ejercicio, @periodo, @fecharegistro, @fechaemision,
@concepto, @proyecto, @movmoneda, @movtipocambio,
@usuario, @autorizacion, @referencia, @docfuente, @observaciones,
@generar, @generarmov, @generarmovid, @idgenerar,
@ok output
end
if @movtipo in ('prod.a', 'prod.r', 'prod.e') and @ok is null
begin
exec spprodcostearavance @sucursal, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaemision, @fecharegistro, @usuario, @proyecto, @ejercicio, @periodo, @referencia, @observaciones,
@ok output, @okref output
if @estatus = 'sinafectar' or @accion = 'cancelar'
exec spprodavance @sucursal, @accion, @empresa, @fechaemision, @fecharegistro, @usuario, @id, @mov, @movid, @movtipo, @ok output, @okref output
end
if @movtipo = 'prod.e' and @estatusnuevo = 'concluido' and @accion <> 'cancelar' and @ok is null
exec spprodcostearentrada @empresa, @id, @movmoneda, @movtipocambio, @ok output, @okref output
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx', 'vtas.fb') and @cobrointegrado = 0 and @facturarvtasmostrador = 0 and @estatus in ('sinafectar', 'confirmar', 'borrador') and @accion <> 'cancelar' and @ok is null
exec xpotroscars @empresa, @id, @clienteprov, @movmoneda, @movtipocambio, @ok output, @okref output
if @afectardetalle = 1 and @ok is null
begin
if @accion = 'cancelar' or (@movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx') and @estatusnuevo = 'pendiente') select @matarantes = 1 else select @matarantes = 0
if @afectarmatando = 1 and @utilizar = 0 and @matarantes = 1 and @ok is null
exec spinvmatar @sucursal, @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @ejercicio, @periodo, @afectarconsignacion, @almacentipo, @almacendestinotipo,
@cfgventasurtirdemas, @cfgcomprarecibirdemas, @cfgtransferirdemas, @cfgbackorders, @cfgcontx, @cfgcontxgenerar, @cfgembarcar, @cfgimpinc, @cfgmultiunidades, @cfgmultiunidadesnivel,
@ok output, @okref output,
@cfgpreciomoneda = @cfgpreciomoneda
if @modulo = 'vtas'
begin
declare crventadetalle cursor
for select d.renglon, d.renglonsub, d.renglonid, d.renglontipo, isnull(d.cantidad, 0.0), isnull(d.cantidadobsequio, 0.0), isnull(d.cantidadinventario, 0.0), isnull(d.cantidadreservada, 0.0), isnull(d.cantidadordenada, 0.0), isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), isnull(d.factor, 0.0), nullif(rtrim(d.unidad), ''), d.articulo, nullif(rtrim(d.subcuenta), ''), isnull(d.costo, 0.0), isnull(d.precio, 0.0), nullif(rtrim(d.descuentotipo), ''), isnull(d.descuentolinea, 0.0), isnull(d.impuesto1, 0.0), isnull(d.impuesto2, 0.0), isnull(d.impuesto3, 0.0), nullif(rtrim(d.aplica), ''), nullif(rtrim(d.aplicaid), ''), d.almacen, d.agente, nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, nullif(rtrim(upper(a.tipoopcion)), ''), isnull(a.peso, 0.0), isnull(a.volumen, 0.0), a.unidad, d.ultimoreservadocantidad, d.ultimoreservadofecha, nullif(rtrim(a.comision), ''), nullif(rtrim(d.espacio), ''), a.lotesfijos, a.actividades, a.costoidentificado, d.costoueps, d.costopeps, d.ultimocosto, d.preciolista, d.preciotipocambio, nullif(rtrim(d.posicion), ''), a.departamentodetallista, a.estatus, a.situacion, a.impuesto1excento, a.excento2, a.excento3
from ventad d, art a
where d.id = @id
and d.articulo = a.articulo
open crventadetalle
fetch next from crventadetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadobsequio, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @agenterenglon, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @ultreservadocantidad, @ultreservadofecha, @artcomision, @espaciod, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @preciotipocambio, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3
if @@error <> 0 select @ok = 1
end else
if @modulo = 'coms'
begin
declare crcompradetalle cursor
for select d.renglon, d.renglonsub, d.renglonid, d.renglontipo, isnull(d.cantidad, 0.0), isnull(d.cantidadinventario, 0.0), d.cantidad, d.cantidad, isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), d.factor, nullif(rtrim(d.unidad), ''), d.articulo, nullif(rtrim(d.subcuenta), ''), isnull(d.costo, 0.0), isnull(d.costo, 0.0), nullif(rtrim(d.descuentotipo), ''), isnull(d.descuentolinea, 0.0), isnull(d.impuesto1, 0.0), isnull(d.impuesto2, 0.0), isnull(d.impuesto3, 0.0), nullif(rtrim(d.aplica), ''), nullif(rtrim(d.aplicaid), ''), d.almacen, d.servicioarticulo, d.servicioserie, nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, nullif(rtrim(upper(a.tipoopcion)), ''), isnull(a.peso, 0.0), isnull(a.volumen, 0.0), a.unidad, isnull(d.retencion1, 0.0), isnull(d.retencion2, 0.0), isnull(d.retencion3, 0.0), a.lotesfijos, a.actividades, a.costoidentificado, d.costoueps, d.costopeps, d.ultimocosto, d.preciolista, nullif(rtrim(d.posicion), ''), a.departamentodetallista, a.estatus, a.situacion, a.impuesto1excento, a.excento2, a.excento3
from comprad d, art a
where d.id = @id
and d.articulo = a.articulo
open crcompradetalle
fetch next from crcompradetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @servicioarticulo, @servicioserie, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @movretencion1, @movretencion2, @movretencion3, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3
if @@error <> 0 select @ok = 1
end else
if @modulo = 'inv'
begin
declare crinvdetalle cursor
for select d.renglon, d.renglonsub, d.renglonid, d.renglontipo, isnull(d.cantidad, 0.0), isnull(d.cantidadinventario, 0.0), isnull(d.cantidadreservada, 0.0), isnull(d.cantidadordenada, 0.0), isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), d.factor, nullif(rtrim(d.unidad), ''), d.articulo, nullif(rtrim(d.subcuenta), ''), isnull(d.costo, 0.0), convert(money, null), '$', convert(money, null), convert(float, null), convert(float, null), convert(money, null), nullif(rtrim(d.aplica), ''), nullif(rtrim(d.aplicaid), ''), d.almacen, d.prodserielote, nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, nullif(rtrim(upper(a.tipoopcion)), ''), isnull(a.peso, 0.0), isnull(a.volumen, 0.0), a.unidad, d.ultimoreservadocantidad, d.ultimoreservadofecha, d.tipo, d.producto, d.subproducto, a.lotesfijos, a.actividades, a.costoidentificado, d.costoueps, d.costopeps, d.ultimocosto, d.preciolista, nullif(rtrim(d.posicion), ''), a.departamentodetallista, a.estatus, a.situacion, a.impuesto1excento, a.excento2, a.excento3
from invd d, art a
where d.id = @id
and d.articulo = a.articulo
open crinvdetalle
fetch next from crinvdetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @prodserielote, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @ultreservadocantidad, @ultreservadofecha, @detalletipo, @producto, @subproducto, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3
if @@error <> 0 select @ok = 1
end else
if @modulo = 'prod'
begin
declare crproddetalle cursor
for select d.renglon, d.renglonsub, d.renglonid, d.renglontipo, isnull(d.cantidad, 0.0), isnull(d.cantidadinventario, 0.0), isnull(d.cantidadreservada, 0.0), isnull(d.cantidadordenada, 0.0), isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), d.factor, nullif(rtrim(d.unidad), ''), d.articulo, nullif(rtrim(d.subcuenta), ''), isnull(d.costo, 0.0), convert(money, null), '$', convert(money, null), convert(float, null), convert(float, null), convert(money, null), nullif(rtrim(d.aplica), ''), nullif(rtrim(d.aplicaid), ''), d.almacen, nullif(rtrim(d.prodserielote), ''), nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, nullif(rtrim(upper(a.tipoopcion)), ''), isnull(a.peso, 0.0), isnull(a.volumen, 0.0), a.unidad, d.ultimoreservadocantidad, d.ultimoreservadofecha, d.tipo, d.merma, d.desperdicio, d.ruta, d.orden, d.centro, a.lotesfijos, a.actividades, a.costoidentificado, d.costoueps, d.costopeps, d.ultimocosto, d.preciolista, nullif(rtrim(d.posicion), ''), a.departamentodetallista, a.estatus, a.situacion, a.impuesto1excento, a.excento2, a.excento3
from prodd d, art a
where d.id = @id
and d.articulo = a.articulo
open crproddetalle
fetch next from crproddetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @prodserielote, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @ultreservadocantidad, @ultreservadofecha, @detalletipo, @merma, @desperdicio, @ruta, @orden, @centro, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3
if @@error <> 0 select @ok = 1
end
while @@fetch_status <> -1 and @ok is null
begin
exec xpinvafectardetalleantes @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @conexion, @sincrofinal, @sucursal,
@renglon, @renglonsub, @articulo, @cantidad, @importe, @importeneto, @impuestos, @impuestosnetos,
@ok output, @okref output
select @cantidadpendientea = @cantidadpendiente, @cantidadordenadaa = @cantidadordenada
if @cfgventamultiagente = 1 and @modulo = 'vtas' select @agente = @agenterenglon
if @cfgmultiunidades = 0
begin
if @modulo = 'coms'
select @artunidad = unidadcompra from art with (nolock) where articulo = @articulo
select @movunidad = @artunidad
end
if @agente <> @ultagente and @ultagente is not null and @comisionacum <> 0.0 and @ok is null and
(((@movtipo in ('vtas.f','vtas.far', 'vtas.fb', 'vtas.d', 'vtas.df', 'vtas.b') and (@estatus = 'sinafectar' or @estatusnuevo = 'cancelado')) and (@cfgventacomisionescobradas = 0 or @cobrointegrado = 1 or @cobrarpedido = 1)) or @movtipo in ('vtas.fm', 'vtas.n', 'vtas.no', 'vtas.nr'))
begin
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, 'agent', @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
null, null, @clienteprov, null, @ultagente, null, null, null,
@comisionimporteneto, null, null, @comisionacum,
null, null, null, null, null, null,
@cxmodulo, @cxmov, @cxmovid, @ok output, @okref output
select @comisionacum = 0.0, @comisionimporteneto = 0.0
end
select @ultagente = @agente
if @renglon = @explotandorenglon select @explotandosubcuenta = 1 else select @explotandosubcuenta = 0
select @almacen = @almacenoriginal, @almacendestino = @almacendestinooriginal
if @afectaralmacenrenglon = 1 select @almacen = nullif(rtrim(@almacenrenglon), '')
if @almacenespecifico is not null select @almacen = @almacenespecifico
if @voltearalmacen = 1 select @almacentemp = @almacen, @almacen = @almacendestino, @almacendestino = @almacentemp
if @estransferencia = 0 select @almacendestino = null
if @almacen is not null select @almacentipo = upper(tipo) from alm where almacen = @almacenrenglon
if @almacendestino is not null select @almacendestinotipo = upper(tipo) from alm where almacen = @almacendestino
select @sucursalalmacen = sucursal from alm with (nolock) where almacen = @almacen
if @almacendestino is not null
select @sucursalalmacendestino = sucursal from alm with (nolock) where almacen = @almacendestino
select @aplicamovtipo = null, @idaplica = null
if @aplicamov <> null
begin
select @aplicamovtipo = clave from movtipo with (nolock) where modulo = @modulo and mov = @aplicamov
if @modulo = 'vtas' select @idaplica = id from venta with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado') else
if @modulo = 'coms' select @idaplica = id from compra with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado') else
if @modulo = 'prod' select @idaplica = id from prod with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado') else
if @modulo = 'inv' select @idaplica = id from inv with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado')
if @movtipo = 'inv.ei' and @idaplica is not null
begin
select @idsalidatraspaso = o.id
from inv i with (nolock)
join inv o with (nolock) on o.empresa = i.empresa and o.mov = i.origen and o.movid = i.origenid and o.estatus in ('pendiente', 'concluido')
where i.id = @idaplica
end
end
exec spinvinitrenglon @empresa, 0, @cfgmultiunidades, @cfgmultiunidadesnivel, @cfgcomprafactordinamico, @cfginvfactordinamico, @cfgprodfactordinamico, @cfgventafactordinamico, 0,
0, 0, @accion, @base, @modulo, @id, @renglon, @renglonsub, @estatus, @estatusnuevo, @movtipo, @facturarvtasmostrador, @estransferencia, @afectarconsignacion, @explotandosubcuenta, @almacentipo, @almacendestinotipo,
@articulo, @movunidad, @artunidad, @arttipo, @renglontipo,
@aplicamovtipo, @cantidadoriginal, @cantidadinventario, @cantidadpendiente, @cantidada, @detalletipo,
@cantidad output, @cantidadcalcularimporte output, @cantidadreservada output, @cantidadordenada output, @esentrada output, @essalida output, @subcuenta output,
@afectarpiezas output, @afectarcostos output, @afectarunidades output, @factor output,
@ok output, @okref output
select @importe = 0.0,
@importeneto = 0.0,
@impuestos = 0.0,
@impuestosnetos= 0.0,
@impuesto1neto = 0.0,
@impuesto2neto = 0.0,
@impuesto3neto = 0.0,
@descuentolineaimporte= 0.0,
@descuentoglobalimporte = 0.0,
@sobreprecioimporte = 0.0,
@importecomision= 0.0,
@costoinvtotal = 0.0
if @@fetch_status <> -2 and @cantidad <> 0.0 and @ok is null
begin
select @costosimpuestoincluido = 0
if @cfgcompracostosimpuestoincluido = 1 and @almacentipo <> 'activos fijos'
select @costosimpuestoincluido = 1
select @artmoneda = monedacosto, @serieslotesautoorden = isnull(nullif(nullif(rtrim(upper(serieslotesautoorden)), ''), '(empresa)'), @cfgserieslotesautoorden)
from art with (nolock)
where articulo = @articulo
if @generar = 0 or @generarafectado = 1
begin
if @modulo = 'coms' and @movtipo in ('coms.og', 'coms.ig', 'coms.dg')
begin
select @costo = 0.0, @precio = 0.0
update comprad with (rowlock) set costo = null where current of crcompradetalle
end
select @afectarserielote = 0
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx') and @aplicamovtipo = 'vtas.r' select @facturandoremision = 1 else select @facturandoremision = 0
if @arttipo in ('serie', 'lote', 'vin', 'partida') and @cfgserieslotesmayoreo = 1 and (@esentrada = 1 or @essalida = 1 or @estransferencia = 1 or @movtipo in ('coms.b', 'coms.ca', 'coms.gx')) and @facturarvtasmostrador = 0 and @facturandoremision = 0
begin
select @afectarserielote = 1
if @artserieloteinfo = 0
exec spserieslotessurtidoauto @sucursal, @empresa, @modulo, @essalida, @estransferencia,
@id, @renglonid, @almacen, @articulo, @subcuenta, @cantidad, @factor,
@almacentipo, @serieslotesautoorden,
@ok output, @okref output
end
select @precion = @precio, @impuesto1n = @impuesto1, @impuesto2n = @impuesto2, @impuesto3n = @impuesto3
if @modulo in ('vtas', 'coms') and @accion <> 'cancelar'
begin
exec xpmovdprecioimpuestos @empresa, @modulo, @id, @mov, @movid, @movtipo, @renglon, @renglonsub, @renglonid, @arttipo, @articulo, @subcuenta, @almacen, @cantidadoriginal, @precion output, @impuesto1n output, @impuesto2n output, @impuesto3n output, @ok output, @okref output
if @movimpuesto = 1
begin
if @arttipo = 'lote' and @artlotesfijos = 1 and @novalidardisponible = 0
exec splotesfijos @empresa, @modulo, @id, @mov, @movid, @movtipo, @renglon, @renglonsub, @renglonid, @arttipo, @articulo, @subcuenta, @almacen, @zonaimpuesto, @cantidadoriginal, @factor,
@cfgimpinc, @esentrada, @precio, @descuentotipo, @descuentolinea, @descuentoglobal, @sobreprecio,
@impuesto1n output, @impuesto2n output, @impuesto3n output, @ok output, @okref output,
@cfgpreciomoneda = @cfgpreciomoneda, @movtipocambio = @movtipocambio, @preciotipocambio = @preciotipocambio
end
end
if @precion <> @precio or @impuesto1n <> @impuesto1 or @impuesto2 <> @impuesto2n or @impuesto3 <> @impuesto3n
begin
select @precio = @precion, @impuesto1 = @impuesto1n, @impuesto2 = @impuesto2n, @impuesto3 = @impuesto3n
if @modulo = 'vtas' update ventad with (rowlock) set precio = @precio, impuesto1 = @impuesto1, impuesto2 = @impuesto2, impuesto3 = @impuesto3 where current of crventadetalle else
if @modulo = 'coms'
begin
select @costo = @precio
update comprad with (rowlock) set costo = @costo, impuesto1 = @impuesto1, impuesto2 = @impuesto2, impuesto3 = @impuesto3 where current of crcompradetalle
end
end
if @artactividades = 1
begin
if @movtipo in ('vtas.p', 'vtas.s')
exec spsugerirartactividad @empresa, @sucursal, @id, @renglon, @renglonsub, @articulo, @cantidadoriginal, @agente
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx','vtas.fb')
begin
update ventadagente with (rowlock)
set costoactividad = a.costo
from ventadagente d, actividad a with (nolock)
where d.id = @id and d.renglon = @renglon and d.renglonsub = @renglonsub and d.actividad = a.actividad
if @cfgcosteoactividades = 'tiempo estandar'
select @costoactividad = sum(costoactividad*cantidadestandar) from ventadagente with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
else
select @costoactividad = sum(costoactividad*(convert(float, minutos)/60)) from ventadagente with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
update ventad with (rowlock) set costoactividad = @costoactividad/nullif(@movtipocambio, 0)/nullif(@cantidadoriginal, 0) where current of crventadetalle
end
end
if @modulo in ('vtas', 'coms')
begin
exec spcalculaimporte @accion, @modulo, @cfgimpinc, @movtipo, @esentrada, @cantidadcalcularimporte, @precio, @descuentotipo, @descuentolinea, @descuentoglobal, @sobreprecio, @impuesto1, @impuesto2, @impuesto3,
@importe output, @importeneto output, @descuentolineaimporte output, @descuentoglobalimporte output, @sobreprecioimporte output,
@impuestos output, @impuestosnetos output, @impuesto1neto output, @impuesto2neto output, @impuesto3neto output,
@articulo = @articulo, @cantidadobsequio = @cantidadobsequio, @cfgpreciomoneda = @cfgpreciomoneda, @movtipocambio = @movtipocambio, @preciotipocambio = @preciotipocambio
if @movimpuesto = 1 and not (@arttipo = 'lote' and @artlotesfijos = 1)
begin
if @cantidadoriginal<0.0 select @movimpuestofactor = -1.0 else select @movimpuestofactor = 1.0
insert #movimpuesto (renglon, renglonsub, retencion1, retencion2, retencion3, excento1, excento2, excento3, impuesto1, impuesto2, impuesto3, importe1, importe2, importe3, subtotal)
select @renglon, @renglonsub, @movretencion1, @movretencion2, @movretencion3, @artexcento1, @artexcento2, @artexcento3, @impuesto1, @impuesto2, @impuesto3, @impuesto1neto*@movimpuestofactor, @impuesto2neto*@movimpuestofactor, @impuesto3neto*@movimpuestofactor, @importeneto*@movimpuestofactor
end
if @modulo = 'coms'
begin
select @costo = @importeneto / @cantidad
end
if @@error <> 0 select @ok = 1
end
select @afectarcantidad = null
if @afectarunidades = 1 and @ok is null
begin
exec spinvafectarunidades @sucursalalmacen, @accion, @base, @empresa, @usuario, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio, @estatus,
@articulo, @artmoneda, @arttipocambio, @arttipo, @subcuenta, @almacen, @almacentipo, @almacendestino, @almacendestinotipo, @esentrada, @cantidadoriginal, @cantidad, @factor,
@renglon, @renglonsub, @renglonid, @renglontipo,
@fecharegistro, @fechaafectacion, @ejercicio, @periodo, @aplicamov, @aplicamovid, @origentipo,
@afectarcostos, @afectarpiezas, @afectarvtasmostrador, @facturarvtasmostrador, @afectarconsignacion, @estransferencia, @cfgserieslotesmayoreo, @cfgformacosteo, @cfgtipocosteo,
@cantidadreservada, @reservadoparcial output, @ultrenglonidjue output, @cantidadjue output, @cantidadminimajue output,
@ultreservadocantidad output, @ultreservadofecha output, @afectarcantidad output, @afectaralmacen output, @afectaralmacendestino output,
@ok output, @okref output
end
else
select @reservadoparcial = 0.0
if @facturandoremision = 1 and @accion <> 'cancelar' and @arttipo not in ('jue', 'servicio')
begin
select @costo = isnull(sum(cantidad*costo)/nullif(sum(cantidad), 0.0), 0.0)
from ventad with (nolock)
where id = @idaplica and articulo = @articulo and isnull(subcuenta,'') = isnull(@subcuenta,'')
if @costo = 0.0
select @afectarcostos = 1
else
update ventad with (rowlock) set costo = @costo where current of crventadetalle
end
if @modulo = 'vtas' and @almacentipo = 'garantias' and @accion <> 'cancelar'
begin
update ventad with (rowlock) set costo = null where current of crventadetalle
select @costo = 0.0
end
if @essalida = 1 and @modulo in ('vtas', 'inv') and @estransferencia = 0 and @almacentipo <> 'activos fijos' and @accion = 'afectar' and @facturarvtasmostrador = 0
exec spchecarconsignacion @empresa, @sucursalalmacen, @usuario, @modulo, @mov, @movid,
@fechaafectacion, @ejercicio, @periodo, @artmoneda, @almacen, @articulo, @subcuenta, @afectarcantidad,
@ok output, @okref output
if @afectarcostos = 1 or @estransferencia = 1 or @movtipo in ('coms.cc', 'coms.dc') and @ok is null
begin
if @movtipo in ('coms.eg', 'coms.ei')
select @costoinv = costoinv from comprad with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
else if @movtipo in ('inv.ei')
select @costoinv = costoinv from invd with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
else
select @costoinv = @costo
if @costosimpuestoincluido = 1
select @costoinv = @costoinv + (@impuestosnetos / @cantidad)
exec spartcosto @sucursalalmacen, @accion, @empresa, @modulo, @afectarcostos,
@esentrada, @essalida, @estransferencia, @afectarserielote, @cfgformacosteo, @cfgtipocosteo,
@arttipo, @articulo, @subcuenta, @cantidad, @movunidad, @factor, @costoinv, @costo,
@mov, @movid, @movtipo, @aplicamovtipo, @fechaafectacion, @movmoneda, @movtipocambio,
@id, @renglonid, @almacen, @almacentipo, 0, @cfgcosteoseries, @cfgcosteolotes, @cfgcosteomultiplesimultaneo, @artcostoidentificado,
@artcosto output, @artajustecosteo output, @artcostoueps output, @artcostopeps output, @artultimocosto output, @artpreciolista output,
@artmoneda output, @artfactor output, @arttipocambio output, @ok output
if @cfgcosteonivelsubcuenta = 1 and @arttipoopcion <> 'no'
exec spartcosto @sucursalalmacen, @accion, @empresa, @modulo, @afectarcostos,
@esentrada, @essalida, @estransferencia, @afectarserielote, @cfgformacosteo, @cfgtipocosteo,
@arttipo, @articulo, @subcuenta, @cantidad, @movunidad, @factor, @costoinv, @costo,
@mov, @movid, @movtipo, @aplicamovtipo, @fechaafectacion, @movmoneda, @movtipocambio,
@id, @renglonid, @almacen, @almacentipo, 1, @cfgcosteoseries, @cfgcosteolotes, @cfgcosteomultiplesimultaneo, @artcostoidentificado,
@artcosto output, @artajustecosteo output, @artcostoueps output, @artcostopeps output, @artultimocosto output, @artpreciolista output,
@artmoneda output, @artfactor output, @arttipocambio output, @ok output
select @modificarcosto = @artcosto * @artfactor, @modificarprecio = @precio
exec xpmovmodificarcostoprecio @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @afectarcostos, @esentrada, @essalida, @estransferencia, @renglon, @renglonsub, @articulo, @subcuenta, @movunidad, @artcosto, @artfactor, @modificarcosto output, @modificarprecio output, @ok output, @okref output
if @modificarcosto <> @artcosto * @artfactor or @modificarprecio <> @precio
begin
select @artcosto = @modificarcosto / @artfactor, @precio = @modificarprecio
if @modulo = 'vtas' update ventad with (rowlock) set precio = @precio where current of crventadetalle else
if @modulo = 'inv' update invd with (rowlock) set precio = @precio where current of crinvdetalle
exec spcalculaimporte @accion, @modulo, @cfgimpinc, @movtipo, @esentrada, @cantidadcalcularimporte, @precio, @descuentotipo, @descuentolinea, @descuentoglobal, @sobreprecio, @impuesto1, @impuesto2, @impuesto3,
@importe output, @importeneto output, @descuentolineaimporte output, @descuentoglobalimporte output, @sobreprecioimporte output,
@impuestos output, @impuestosnetos output, @impuesto1neto output, @impuesto2neto output, @impuesto3neto output,
@articulo = @articulo, @cantidadobsequio = @cantidadobsequio, @cfgpreciomoneda = @cfgpreciomoneda, @movtipocambio = @movtipocambio, @preciotipocambio = @preciotipocambio
if @movimpuesto = 1 and not (@arttipo = 'lote' and @artlotesfijos = 1)
begin
delete #movimpuesto where renglon = @renglon and renglonsub = @renglonsub
if @cantidadoriginal<0.0 select @movimpuestofactor = -1.0 else select @movimpuestofactor = 1.0
insert #movimpuesto (renglon, renglonsub, retencion1, retencion2, retencion3, excento1, excento2, excento3, impuesto1, impuesto2, impuesto3, importe1, importe2, importe3, subtotal)
select @renglon, @renglonsub, @movretencion1, @movretencion2, @movretencion3, @artexcento1, @artexcento2, @artexcento3, @impuesto1, @impuesto2, @impuesto3, @impuesto1neto*@movimpuestofactor, @impuesto2neto*@movimpuestofactor, @impuesto3neto*@movimpuestofactor, @importeneto*@movimpuestofactor
end
end
select @artcostoinv = @artcosto
select @costoinvtotal = @artcosto * @cantidad
select @artcantidad = isnull(@cantidad, 0.0)*isnull(@factor, 1.0)
if @movtipo in ('coms.eg', 'coms.ei', 'inv.ei') select @artcosto = @costo / @artfactor
select @preciosinimpuestos = dbo.fnpreciosinimpuestos (@empresa, @articulo, @artpreciolista)
if (@essalida = 1 or @estransferencia = 1) and @accion <> 'cancelar' and @ok is null
begin
if @modulo = 'vtas' update ventad with (rowlock) set unidad = @movunidad, costo = @artcosto * @artfactor, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crventadetalle else
if @modulo = 'inv' update invd with (rowlock) set unidad = @movunidad, costo = @artcosto * @artfactor, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crinvdetalle else
if @modulo = 'prod' update prodd with (rowlock) set unidad = @movunidad, costo = @artcosto * @artfactor, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crproddetalle else
if @modulo = 'coms' update comprad with (rowlock) set unidad = @movunidad, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crcompradetalle
if @@error <> 0 select @ok = 1
end else
begin
select @ajustepreciolista = null
if @movtipo = 'inv.ei' and @idsalidatraspaso is not null
select @ajustepreciolista = @preciosinimpuestos - (select min(preciolista) from invd with (nolock) where id = @idsalidatraspaso and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '') and isnull(unidad, '') = isnull(@movunidad, ''))
if @modulo = 'vtas' update ventad with (rowlock) set unidad = @movunidad, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crventadetalle else
if @modulo = 'inv' update invd with (rowlock) set unidad = @movunidad, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista, ajustepreciolista = @ajustepreciolista where current of crinvdetalle else
if @modulo = 'prod' update prodd with (rowlock) set unidad = @movunidad, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crproddetalle else
if @modulo = 'coms' update comprad with (rowlock) set unidad = @movunidad, ajustecosteo = @artajustecosteo * @artfactor, costoueps = @artcostoueps * @artfactor, costopeps = @artcostopeps * @artfactor, ultimocosto = @artultimocosto * @artfactor, preciolista = @preciosinimpuestos, departamentodetallista = @artdepartamentodetallista where current of crcompradetalle
end
if @movtipo = 'vtas.fc' and nullif(rtrim(@servicioserie), '') is not null and @cfgvinaccesorioart = 1 and @cfgvincostosumaaccesorios = 1
insert vinaccesorio
(vin, tipo, accesorio, descripcion, preciodistribuidor, preciopublico, preciocontado, fechaalta, estatus)
select @servicioserie, @mov, @articulo, a.descripcion1, @artcosto*@cantidad, a.preciolista*@cantidad, a.precio2*@cantidad, @fechaemision, 'alta'
from art a with (nolock)
where a.articulo = @articulo
if @modulo <> 'coms' select @costo = @artcosto * @artfactor
if @afectarcostos = 1 and @arttipo not in ('jue', 'servicio') and @ok is null
begin
if @esentrada = 1 or (@essalida = 0 and @estransferencia = 1 and @accion <> 'cancelar') select @escar = 1 else select @escar = 0
if @movtipo = 'coms.b' if @accion <> 'cancelar' select @escar = 0 else select @escar = 1
if @movtipo in ('coms.ca', 'coms.gx') if @accion <> 'cancelar' select @escar = 1 else select @escar = 0
if @almacentipo = 'activos fijos' select @afectarrama = 'af' else select @afectarrama = 'inv'
exec spsaldo @sucursalalmacen, @accion, @empresa, @usuario, @afectarrama, @artmoneda, @arttipocambio, @articulo, @subcuenta, @afectaralmacen, @afectaralmacendestino,
@modulo, @id, @mov, @movid, @escar, @costoinvtotal, @afectarcantidad, @factor,
@fechaafectacion, @ejercicio, @periodo, @aplicamov, @aplicamovid, 0, 0, 0,
@ok output, @okref output, @renglon = @renglon, @renglonsub = @renglonsub, @renglonid = @renglonid
end
end
if @afectarserielote = 1 and @ok is null
begin
exec spserieslotesmayoreo @sucursal, @sucursalalmacen, @sucursalalmacendestino, @empresa, @modulo, @accion, @afectarcostos, @esentrada, @essalida, @estransferencia,
@id, @renglonid, @almacen, @almacendestino, @articulo, @subcuenta, @arttipo, @artserieloteinfo, @artlotesfijos, @artcosto, @artcostoinv, @cantidad, @factor,
@movtipo, @aplicamovtipo, @almacentipo, @fechaemision, @cfgcosteoseries, @cfgcosteolotes, @artcostoidentificado, @cfgvalidarlotescostodif, @cfgvinaccesorioart, @cfgvincostosumaaccesorios,
@ok output, @okref output
if @arttipo = 'vin'
begin
if @modulo = 'vtas'
begin
if @vin is not null select @ok = 20630
select @vin = min(serielote) from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and renglonid = @renglonid and articulo = @articulo
if @movtipo = 'vtas.f'
update venta with (rowlock) set servicioarticulo = @articulo, servicioserie = @vin where id = @id
end
if @accion = 'cancelar' and @ok is null
update vin with (rowlock)
set fechamrs = null
from vin v, serielotemov s with (nolock)
where s.empresa = @empresa and s.modulo = @modulo and s.id = @id and s.renglonid = @renglonid and s.articulo = @articulo
and v.vin = s.serielote and v.tienemovimientos = 0
else begin
if exists(
select v.vin
from vin v with (nolock), serielotemov s with (nolock)
where s.empresa = @empresa and s.modulo = @modulo and s.id = @id and s.renglonid = @renglonid and s.articulo = @articulo
and v.vin = s.serielote and v.tienemovimientos = 0)
update vin with (rowlock)
set tienemovimientos = 1
from vin v, serielotemov s with (nolock)
where s.empresa = @empresa and s.modulo = @modulo and s.id = @id and s.renglonid = @renglonid and s.articulo = @articulo
and v.vin = s.serielote and v.tienemovimientos = 0
if @movtipo in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei')
exec spvinentrada @empresa, @modulo, @id, @mov, @renglonid, @articulo, @fechaemision, @fecharequerida, @importeneto, @impuesto1neto, @vin output, @ok output, @okref output
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx', 'vtas.fb')
update vin with (rowlock)
set cliente = @clienteprov,
fechasalida = @fechaemision,
ventaid = @id
from vin v, serielotemov s with (nolock)
where s.empresa = @empresa and s.modulo = @modulo and s.id = @id and s.renglonid = @renglonid and s.articulo = @articulo
and v.vin = s.serielote
end
end
end
if (@movtipo = 'vtas.fm' and @facturarvtasmostrador = 1 and @arttipo in ('serie', 'lote', 'vin', 'partida') and @accion <> 'cancelar')
begin
select @cantidaddif = @cantidad
select @cantidaddif = @cantidad - isnull(sum(cantidad) / @factor, 0.0)
from serielotemov with (nolock)
where empresa = @empresa
and modulo = @modulo
and id = @id
and renglonid = @renglonid
and articulo = @articulo
and isnull(rtrim(subcuenta), '') = isnull(@subcuenta, '')
if @cantidaddif <> 0.0
begin
declare @serielotemov table (sucursal int null, empresa char(5) collate database_default null, modulo char(5) collate database_default null, id int null, renglonid int null, articulo varchar(20) collate database_default null, subcuenta varchar(50) collate database_default null, serielote varchar(20) collate database_default null, cantidad float null, cantidadalterna float null, propiedades varchar(20) collate database_default null, artcostoinv money null, cliente varchar(10) collate database_default null, localizacion varchar(10) collate database_default null)
exec spserieslotessurtidoauto @sucursal, @empresa, @modulo, @essalida, @estransferencia,
@id, @renglonid, @almacen, @articulo, @subcuenta, @cantidaddif, @factor,
@almacentipo, @serieslotesautoorden,
@ok output, @okref output, @temp = 1
exec spserieslotesmayoreo @sucursal, @sucursalalmacen, @sucursalalmacendestino, @empresa, @modulo, @accion, @afectarcostos, @esentrada, @essalida, @estransferencia,
@id, @renglonid, @almacen, @almacendestino, @articulo, @subcuenta, @arttipo, @artserieloteinfo, @artlotesfijos, @artcosto, @artcostoinv, @cantidaddif, @factor,
@movtipo, @aplicamovtipo, @almacentipo, @fechaemision, @cfgcosteoseries, @cfgcosteolotes, @artcostoidentificado, @cfgvalidarlotescostodif, @cfgvinaccesorioart, @cfgvincostosumaaccesorios,
@ok output, @okref output, @temp = 1
exec spserieslotesfusionartemp @ok output, @okref output
select @cantidaddif = @cantidad
select @cantidaddif = @cantidad - isnull(sum(cantidad) / @factor, 0.0)
from serielotemov with (nolock)
where empresa = @empresa
and modulo = @modulo
and id = @id
and renglonid = @renglonid
and articulo = @articulo
and isnull(rtrim(subcuenta), '') = isnull(@subcuenta, '')
if @cantidaddif <> 0.0 select @ok = 20330
end
end
if @afectarcostos = 1 and @cfgmultiunidades = 1 and @cfgmultiunidadesnivel = 'articulo'
exec xpartunidadfactorrecalc @empresa, @accion,@modulo, @id, @renglon, @renglonsub, @movtipo, @almacentipo,
@articulo, @subcuenta, @movunidad, @arttipo, @factor,
@almacen, @cantidad, @cantidadinventario, @esentrada, @essalida,
@ok output, @okref output
if @modulo in ('coms', 'prod', 'inv')
begin
if (@cfgbackorders = 1 and @movtipo in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei', 'coms.ig', 'inv.t', 'inv.t', 'inv.ei') or (@movtipo='prod.e')) and @accion <> 'cancelar'
begin
select @cliente = null
select @destinotipo = null, @destino = null, @destinoid = null
if @modulo = 'coms' select @cliente = cliente from comprad with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub else
if @modulo = 'inv' select @cliente = cliente, @destinotipo = destinotipo, @destino = destino, @destinoid = destinoid from invd with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub else
if @modulo = 'prod' select @cliente = cliente from prodd with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
if @modulo = 'inv' and @lar = 1 and (@cliente is not null or @destinotipo is not null) select @ok = 20970
if @cliente is not null
exec spinvbackordercliente @sucursal, @empresa, @usuario, @cliente, @articulo, @subcuenta, @cantidad, @factor,
@artmoneda, @almacen, @fechaafectacion, @fecharegistro, @ejercicio, @periodo,
@ok output, @okref output
end
if @movtipo in ('coms.d', 'coms.b', 'coms.ca', 'coms.gx') and @afectarcostos = 1
begin
select @descuentoinverso = 100-isnull(@descuentoglobal, 0)
exec spr3 @descuentoinverso, @costo, 100, @precio output
exec spcalculaimporte @accion, @modulo, @cfgimpinc, @movtipo, @esentrada, @cantidadcalcularimporte, @precio, null, null, @descuentoglobal, @sobreprecio, @impuesto1, @impuesto2, @impuesto3,
@importe output, @importeneto output, @descuentolineaimporte output, @descuentoglobalimporte output, @sobreprecioimporte output,
@impuestos output, @impuestosnetos output, @impuesto1neto output, @impuesto2neto output, @impuesto3neto output,
@articulo = @articulo, @cantidadobsequio = @cantidadobsequio, @cfgpreciomoneda = @cfgpreciomoneda, @movtipocambio = @movtipocambio, @preciotipocambio = @preciotipocambio
end else begin
select @importeneto = @costo * @cantidad
end
end
if @modulo = 'prod' select @importe = @cantidad * @costo
if @movtipo = 'prod.o' and @accion = 'afectar'
begin
exec spprodcentroinicial @id, @articulo, @subcuenta, @prodserielote, @orden output, @ordendestino output, @centro output, @centrodestino output, @estacion output, @estaciondestino output
update prodd with (rowlock) set centro = @centro, orden = @orden, centrodestino = @centrodestino, ordendestino = @ordendestino, estacion = @estacion, estaciondestino = @estaciondestino where current of crproddetalle
end
if @movtipo in ('prod.o', 'prod.co', 'prod.e')
exec spprodserielote @sucursal, @accion, @empresa, @movtipo, @fechaemision, @detalletipo, @prodserielote, @articulo, @subcuenta, @cantidad, @merma, @desperdicio, @factor, @ok output, @okref output
if @movtipo = 'inv.cm'
exec spprodserielotecosto @sucursal, @accion, @empresa, @modulo, @id, @movtipo, @detalletipo, @prodserielote, @producto, @subproducto, @costoinvtotal, @artmoneda, @mov, 0
if @movtipo = 'prod.e'
exec spprodserielotecosto @sucursal, @accion, @empresa, @modulo, @id, @movtipo, @detalletipo, @prodserielote, @articulo, @subcuenta, @costoinvtotal, @artmoneda, @mov, 0
if @almacentipo = 'activos fijos' and @arttipo in ('serie', 'vin') and @cfgserieslotesmayoreo = 1 and @ok is null and
(@esentrada = 1 or @essalida = 1 or @estransferencia = 1) and @origenmovtipo <> 'coms.cc'
exec spactivof @sucursal, @empresa, @modulo, @accion, @esentrada, @essalida, @estransferencia,
@id, @renglonid, @almacen, @almacendestino, @articulo, @arttipo, @cantidad,
@artcostoinv, @artmoneda, @fechaemision,
@ok output, @okref output
if @modulo = 'vtas' and
(@estatusnuevo = 'concluido' or (@estatusnuevo = 'cancelado' and @estatus <> 'pendiente')) and
(@movtipo in ('vtas.f','vtas.far','vtas.fb', 'vtas.d', 'vtas.df', 'vtas.b') or
(@movtipo = 'vtas.fm' and @facturarvtasmostrador = 1 and @accion <> 'cancelar')) and @ok is null
begin
if @arttipo in ('serie','lote','vin') and @cfgserieslotesmayoreo = 0
select @acumularsindetalles = 1
else select @acumularsindetalles = 0
if @movtipo in ('vtas.f','vtas.far','vtas.fb','vtas.fm') select @escar = 1 else select @escar = 0
if @cantidadoriginal<0.0 select @escar = ~@escar
if @accion = 'cancelar' select @escar = ~@escar
if @movtipo = 'vtas.b' select @acumcantidad = null else select @acumcantidad = @cantidad
exec spsaldo @sucursal, @accion, @empresa, @usuario, 'vtas', @movmoneda, null, @articulo, @subcuenta, @clienteprov, null,
@modulo, @id, @mov, @movid, @escar, @importeneto, @acumcantidad, @factor,
@fechaafectacion, @ejercicio, @periodo, null, null, 0, @acumularsindetalles, 0,
@ok output, @okref output, @renglon = @renglon, @renglonsub = @renglonsub, @renglonid = @renglonid
end else
if @modulo = 'coms' and (@estatusnuevo = 'concluido' or (@estatusnuevo = 'cancelado' and @estatus <> 'pendiente')) and @movtipo in ('coms.f','coms.fl','coms.eg', 'coms.ei','coms.d','coms.b','coms.ca', 'coms.gx') and @ok is null
begin
if @arttipo in ('serie','lote','vin') and @cfgserieslotesmayoreo = 0
select @acumularsindetalles = 1
else select @acumularsindetalles = 0
if @movtipo in ('coms.f','coms.fl','coms.eg', 'coms.ei','coms.ca', 'coms.gx') select @escar = 1 else select @escar = 0
if @accion = 'cancelar' select @escar = ~@escar
if @movtipo in ('coms.b', 'coms.ca', 'coms.gx') select @acumcantidad = null else select @acumcantidad = @cantidad
exec spsaldo @sucursal, @accion, @empresa, @usuario, 'coms', @movmoneda, null, @articulo, @subcuenta, @clienteprov, null,
@modulo, @id, @mov, @movid, @escar, @importeneto, @acumcantidad, @factor,
@fechaafectacion, @ejercicio, @periodo, null, null, 0, @acumularsindetalles, 0,
@ok output, @okref output, @renglon = @renglon, @renglonsub = @renglonsub, @renglonid = @renglonid
if @movtipo in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei') and @accion <> 'cancelar'
begin
if @movtipo = 'coms.ei'
select @proveedorref = isnull(nullif(rtrim(importacionproveedor), ''), @clienteprov) from comprad with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
else
select @proveedorref = @clienteprov
if @costosimpuestoincluido = 1 select @artprovcosto = @costo else select @artprovcosto = @artcosto
exec xpartprov @empresa, @accion, @modulo, @id, @renglon, @renglonsub, @movtipo, @almacentipo,
@articulo, @subcuenta, @movunidad, @arttipo, @factor,
@almacen, @cantidad, @cantidadinventario, @esentrada, @essalida,
@proveedorref, @artprovcosto, @fechaemision,
@ok output, @okref output
end
end
if (@cfgposiciones = 1 or @cfgexistenciaalterna = 1) and @origentipo <> 'vmos' and @almacentipo <> 'activos fijos' and @arttipo not in ('jue', 'servicio') and (@esentrada = 1 or @essalida = 1 or @estransferencia = 1 or @movtipo in ('coms.cc') or @mov = @cfgestadisticaajustemerma) and @ok is null
begin
if @cfgposiciones = 1 and @posicion is null
select @ok = 13050
else begin
if @movtipo not in ('coms.cc')
begin
select @auxiliaralternosucursal = @sucursalalmacen, @auxiliaralternoalmacen = @almacen
if @accion = 'cancelar'
select @auxiliaralternofactorentrada = -1.0, @auxiliaralternofactorsalida = null
else
select @auxiliaralternofactorentrada = null, @auxiliaralternofactorsalida = 1.0
if @essalida = 1 or @estransferencia = 1
begin
if @cfgexistenciaalternaserielote = 1 and @arttipo in ('serie', 'lote', 'vin', 'partida')
insert auxiliaralterno
(empresa, sucursal, almacen, posicion, serielote, modulo, id, renglon, renglonsub, articulo, subcuenta, unidad, factor, entrada, salida)
select @empresa, @auxiliaralternosucursal, @auxiliaralternoalmacen, @posicion, serielote, @modulo, @id, @renglon, @renglonsub, @articulo, @subcuenta, @movunidad, @factor, cantidad*@auxiliaralternofactorentrada, cantidad*@auxiliaralternofactorsalida
from serielotemov with (nolock)
where empresa = @empresa and modulo = @modulo and id = @id and renglonid = @renglonid and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '')
else
insert auxiliaralterno
(empresa, sucursal, almacen, posicion, modulo, id, renglon, renglonsub, articulo, subcuenta, unidad, factor, entrada, salida)
select @empresa, @auxiliaralternosucursal, @auxiliaralternoalmacen, @posicion, @modulo, @id, @renglon, @renglonsub, @articulo, @subcuenta, @movunidad, @factor, @cantidad*@auxiliaralternofactorentrada, @cantidad*@auxiliaralternofactorsalida
end
if @estransferencia = 1
select @auxiliaralternosucursal = @sucursalalmacendestino, @auxiliaralternoalmacen = @almacendestino
if @accion = 'cancelar'
select @auxiliaralternofactorentrada = null, @auxiliaralternofactorsalida = -1.0
else
select @auxiliaralternofactorentrada = 1.0, @auxiliaralternofactorsalida = null
if @esentrada = 1 or @estransferencia = 1 or @mov = @cfgestadisticaajustemerma
begin
if @cfgexistenciaalternaserielote = 1 and @arttipo in ('serie', 'lote', 'vin', 'partida')
insert auxiliaralterno
(empresa, sucursal, almacen, posicion, serielote, modulo, id, renglon, renglonsub, articulo, subcuenta, unidad, factor, entrada, salida)
select @empresa, @auxiliaralternosucursal, @auxiliaralternoalmacen, @posicion, serielote, @modulo, @id, @renglon, @renglonsub, @articulo, @subcuenta, @movunidad, @factor, cantidad*@auxiliaralternofactorentrada, cantidad*@auxiliaralternofactorsalida
from serielotemov with (nolock)
where empresa = @empresa and modulo = @modulo and id = @id and renglonid = @renglonid and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '')
else
insert auxiliaralterno
(empresa, sucursal, almacen, posicion, modulo, id, renglon, renglonsub, articulo, subcuenta, unidad, factor, entrada, salida)
select @empresa, @auxiliaralternosucursal, @auxiliaralternoalmacen, @posicion, @modulo, @id, @renglon, @renglonsub, @articulo, @subcuenta, @movunidad, @factor, @cantidad*@auxiliaralternofactorentrada, @cantidad*@auxiliaralternofactorsalida
end
end
end
end
if @afectarmatando = 1 and @utilizar = 1 and @aplicamov is not null and @aplicamovid is not null and @ok is null
select @ok = 71050
if (@estatus = 'pendiente' or @estatusnuevo = 'pendiente') and @ok is null
begin
if @estatusnuevo = 'pendiente'
begin
if @accion in ('asignar', 'desasignar')
exec spinvasignar @sucursal, @accion, @empresa, @modulo, @id, @mov, @movid, @almacen, @articulo, @subcuenta, @movunidad, @cantidad output, @ok output, @okref output
if @accion = 'reservarparcial' select @cantidadpendiente = @cantidad - @reservadoparcial, @cantidadreservada = @cantidadreservada + @reservadoparcial else
if @accion = 'reservar' select @cantidadpendiente = @cantidadpendiente - @cantidad, @cantidadreservada = @cantidadreservada + @cantidad else
if @accion = 'desreservar' select @cantidadpendiente = @cantidadpendiente + @cantidad, @cantidadreservada = @cantidadreservada - @cantidad else
if @accion = 'asignar' select @cantidadpendiente = @cantidadpendiente - @cantidad, @cantidadordenada = @cantidadordenada + @cantidad else
if @accion = 'desasignar' select @cantidadpendiente = @cantidadpendiente + @cantidad, @cantidadordenada = @cantidadordenada - @cantidad else
if @accion = 'cancelar'
begin
select @cantidadreservada = @cantidadreservada - @cantidad
if @cantidadreservada < 0
select @cantidadpendiente = @cantidadpendiente + @cantidadreservada, @cantidadreservada = 0.0
end else select @cantidadpendiente = @cantidad
end
else
if @estatusnuevo = 'cancelado'
select @cantidadreservada = 0.0, @cantidadpendiente = 0.0
else
if @base in ('seleccion','pendiente','todo')
select @cantidadpendiente = @cantidadpendiente - @cantidad
if @movtipo in ('vtas.f','vtas.far','vtas.fc', 'vtas.fg', 'vtas.fx','vtas.fb') and @estatusnuevo = 'concluido' and @accion = 'afectar' select @cantidadpendiente = 0.0, @cantidadreservada = 0.0
if @modulo not in ('vtas', 'inv', 'prod') select @cantidadordenada = 0.0
if @cantidadpendiente = 0.0 select @cantidadpendiente = null
if @cantidadreservada = 0.0 select @cantidadreservada = null
if @cantidadordenada = 0.0 select @cantidadordenada = null
if @modulo = 'vtas' update ventad with (rowlock) set cantidadcancelada = case when @accion = 'cancelar' and @base <> 'todo' then isnull(cantidadcancelada, 0.0) + @cantidad else cantidadcancelada end, cantidada = null, cantidadreservada = @cantidadreservada, ultimoreservadocantidad = @ultreservadocantidad, ultimoreservadofecha = @ultreservadofecha, cantidadordenada = @cantidadordenada, cantidadpendiente = @cantidadpendiente where current of crventadetalle else
if @modulo = 'inv' update invd with (rowlock) set cantidadcancelada = case when @accion = 'cancelar' and @base <> 'todo' then isnull(cantidadcancelada, 0.0) + @cantidad else cantidadcancelada end, cantidada = null, cantidadreservada = @cantidadreservada, ultimoreservadocantidad = @ultreservadocantidad, ultimoreservadofecha = @ultreservadofecha, cantidadordenada = @cantidadordenada, cantidadpendiente = @cantidadpendiente where current of crinvdetalle else
if @modulo = 'prod' update prodd with (rowlock) set cantidadcancelada = case when @accion = 'cancelar' and @base <> 'todo' then isnull(cantidadcancelada, 0.0) + @cantidad else cantidadcancelada end, cantidada = null, cantidadreservada = @cantidadreservada, ultimoreservadocantidad = @ultreservadocantidad, ultimoreservadofecha = @ultreservadofecha, cantidadordenada = @cantidadordenada, cantidadpendiente = @cantidadpendiente where current of crproddetalle else
if @modulo = 'coms' update comprad with (rowlock) set cantidadcancelada = case when @accion = 'cancelar' and @base <> 'todo' then isnull(cantidadcancelada, 0.0) + @cantidad else cantidadcancelada end, cantidada = null, cantidadpendiente = @cantidadpendiente where current of crcompradetalle
if @@error <> 0 select @ok = 1
exec spartr @empresa, @modulo, @articulo, @subcuenta, @almacen, @movtipo, @factor, null, @cantidadpendientea, @cantidadpendiente, null, @cantidadordenadaa, @cantidadordenada
if @cfgbackorders = 1 and @movtipo in ('coms.o', 'coms.og', 'coms.oi', 'prod.o', 'inv.ot', 'inv.oi') and @aplicamovtipo is null
begin
select @destinotipo = null, @destino = null, @destinoid = null
if @modulo = 'coms' select @destinotipo = destinotipo, @destino = destino, @destinoid = destinoid from comprad with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub else
if @modulo = 'inv' select @destinotipo = destinotipo, @destino = destino, @destinoid = destinoid from invd with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub else
if @modulo = 'prod' select @destinotipo = destinotipo, @destino = destino, @destinoid = destinoid from prodd with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
if @destinotipo in (select modulo from modulo) and @destino is not null and @destinoid is not null
exec spinvbackorder @sucursal, @accion, @estatus, 0, @empresa, @usuario, @modulo, @id, @mov, @movid,
@destinotipo, @destino, @destinoid, @articulo, @subcuenta, @movunidad, @cantidad, @factor, @artmoneda,
@almacen, @fechaafectacion, @fecharegistro, @ejercicio, @periodo,
@ok output, @okref output, @movtipo = @movtipo
end
end
if @cfgbackorders = 1 and @movtipo = 'coms.cp'
begin
select @destinotipo = null, @destino = null, @destinoid = null
if @modulo = 'coms' select @destinotipo = destinotipo, @destino = destino, @destinoid = destinoid from comprad with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
if @destinotipo in (select modulo from modulo) and @destino is not null and @destinoid is not null
exec spinvbackorder @sucursal, @accion, @estatus, 0, @empresa, @usuario, @modulo, @id, @mov, @movid,
@destinotipo, @destino, @destinoid, @articulo, @subcuenta, @movunidad, @cantidad, @factor, @artmoneda,
@almacen, @fechaafectacion, @fecharegistro, @ejercicio, @periodo,
@ok output, @okref output, @movtipo = @movtipo
end
end
if @generar = 1 and @generarcopia = 1 and @ok is null
begin
if @movtipo in ('vtas.c', 'vtas.cs', 'vtas.fr') select @generardirecto = 1 else select @generardirecto = 0
exec spinvgenerardetalle @sucursal, @modulo, @id, @renglon, @renglonsub, @idgenerar, @generardirecto, @mov, @movid, @cantidad, @ok output
if @base = 'seleccion'
begin
if @modulo = 'vtas' update ventad with (rowlock) set cantidada = null where current of crventadetalle else
if @modulo = 'coms' update comprad with (rowlock) set cantidada = null where current of crcompradetalle else
if @modulo = 'inv' update invd with (rowlock) set cantidada = null where current of crinvdetalle else
if @modulo = 'prod' update prodd with (rowlock) set cantidada = null where current of crproddetalle
if @@error <> 0 select @ok = 1
end
end
if @estatus in ('sinafectar', 'confirmar', 'borrador')
begin
select @tiempoestandarfijo = null,
@tiempoestandarvariable = null
if @movtipo in ('prod.a', 'prod.e')
select @tiempoestandarfijo = isnull(tiempofijo, 0), @tiempoestandarvariable = isnull(tiempovariable, 0)*@cantidad
from prodrutad with (nolock)
where ruta = @ruta and orden = @orden and centro = @centro
if @modulo = 'vtas' update ventad with (rowlock) set unidad = @movunidad, factor = @factor, artestatus = case when @cfgventaartestatus = 1 then @artestatus else null end, artsituacion = case when @cfgventaartsituacion = 1 then @artsituacion else null end where current of crventadetalle else
if @modulo = 'coms' update comprad with (rowlock) set unidad = @movunidad, factor = @factor where current of crcompradetalle else
if @modulo = 'inv' update invd with (rowlock) set unidad = @movunidad, factor = @factor where current of crinvdetalle else
if @modulo = 'prod' update prodd with (rowlock) set unidad = @movunidad, factor = @factor, tiempoestandarfijo = @tiempoestandarfijo, tiempoestandarvariable = @tiempoestandarvariable where current of crproddetalle
end
if @movtipo = 'coms.r'
begin
select @compraid = null
select @compraid = max(c.id)
from compra c with (nolock), comprad d with (nolock), movtipo mt with (nolock)
where c.empresa = @empresa and c.estatus = 'concluido'
and mt.modulo = @modulo and mt.mov = c.mov and mt.clave in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei')
and d.id = c.id and d.articulo = @articulo and isnull(d.subcuenta, '') = isnull(@subcuenta, '')
if @compraid is not null
select @proveedorref = proveedor from compra with (nolock) where id = @compraid
else
begin
select @proveedorref = @clienteprov
select @proveedorref = isnull(p.proveedor, @clienteprov)
from art a with (nolock), prov p with (nolock)
where a.articulo = @articulo and p.proveedor = a.proveedor
end
update comprad with (rowlock) set proveedorref = @proveedorref
where current of crcompradetalle
end
if @modulo = 'coms' and @accion in ('afectar', 'cancelar') and nullif(rtrim(@servicioserie), '') is not null
exec spserieloteflujo @sucursal, @sucursalalmacen, @sucursalalmacendestino, @accion, @empresa, @modulo, @id, @servicioarticulo, null, @servicioserie, @almacen, @renglonid
if @movtipo in ('vtas.p', 'vtas.s', 'vtas.sd', 'vtas.f','vtas.far', 'vtas.fb', 'vtas.d', 'vtas.df', 'vtas.b', 'vtas.fm', 'vtas.n', 'vtas.no', 'vtas.nr', 'prod.a', 'prod.r', 'prod.e') and @facturarvtasmostrador = 0 and (@estatus = 'sinafectar' or @accion = 'cancelar') and @ok is null
begin
if @accion = 'cancelar'
begin
if @modulo = 'vtas' select @importecomision = isnull(comision, 0.0) from ventad with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub else
if @modulo = 'prod' select @importecomision = isnull(comision, 0.0) from prodd with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub
end else begin
exec xpcomisioncalcular @id, @accion, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @fechaemision, @fecharegistro, @fechaafectacion, @agente, @conexion, @sincrofinal, @sucursal,
@renglon, @renglonsub, @articulo, @cantidad, @importe, @importeneto, @impuestos, @impuestosnetos, @costo, @artcosto, @artcomision,
@importecomision output, @ok output, @okref output
if isnull(@importecomision, 0.0) <> 0.0 and @ok is null
begin
if @modulo = 'vtas' update ventad with (rowlock) set comision = @importecomision where current of crventadetalle else
if @modulo = 'prod' update prodd with (rowlock) set comision = @importecomision where current of crproddetalle
end
end
end
if @movtipo not in ('coms.r', 'coms.c', 'coms.o', 'coms.op')
begin
if (select tienemovimientos from art with (nolock) where articulo = @articulo) = 0
update art with (rowlock) set tienemovimientos = 1 where articulo = @articulo
if nullif(rtrim(@subcuenta), '') is not null
begin
if (select tienemovimientos from artsub where articulo = @articulo and subcuenta = @subcuenta) = 0
update artsub with (rowlock) set tienemovimientos = 1 where articulo = @articulo and subcuenta = @subcuenta
end
if @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm', 'vtas.f', 'coms.f', 'coms.fl', 'coms.eg', 'coms.ei')
exec spartult @articulo, @fechaemision, @modulo, @movtipo, @id
end
if @esentrada = 1 or @essalida = 1 or @estransferencia = 1
begin
exec spregistrarartalm @empresa, @articulo, @subcuenta, @almacen, @fechaemision
if @almacendestino is not null
exec spregistrarartalm @empresa, @articulo, @subcuenta, @almacendestino, @fechaemision
end
if @movtipo = 'prod.o' and @centro is not null
begin
if (select tienemovimientos from centro with (nolock) where centro = @centro) = 0
update centro with (rowlock) set tienemovimientos = 1 where centro = @centro
end
if @modulo = 'vtas' and @mov = @cfgingresomov
begin
if @accion = 'cancelar'
begin
select @espaciodanterior = null
if @aplicamov = @cfgingresomov
select @espaciodanterior = min(d.espacio)
from ventad d with (nolock), venta v with (nolock)
where v.empresa = @empresa and v.mov = @aplicamov and v.movid = @aplicamovid and v.estatus in ('concluido', 'pendiente')
and d.id = v.id and d.articulo = @articulo and d.subcuenta = @subcuenta and d.espacio is not null
update cte with (rowlock) set espacio = nullif(rtrim(@espaciodanterior), '') where cliente = @clienteprov
end else
if @espaciod is null
select @ok = 10210
else
update cte with (rowlock) set espacio = @espaciod where cliente = @clienteprov
end
if @movtipo = 'inv.if' and @accion = 'afectar' and @estatus in ('sinafectar', 'confirmar', 'borrador')
exec spartalmabc @articulo, @almacen, @fechaemision, @cfgdiashabiles, @cfgabcdiashabiles
if @ok is null
exec xpinvafectardetalle @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @conexion, @sincrofinal, @sucursal,
@renglon, @renglonsub, @articulo, @cantidad, @importe, @importeneto, @impuestos, @impuestosnetos,
@ok output, @okref output
select @retencion = 0.0, @retencion2 = 0.0, @retencion3 = 0.0
if @modulo = 'vtas' and @ok is null
exec xpventaretencioncalcular @id, @accion, @empresa, @usuario, @modulo, @mov, @movid, @movtipo, @movmoneda, @movtipocambio, @clienteprov,
@renglon, @renglonsub, @articulo, @cantidad, @importe, @importeneto, @impuestos, @impuestosnetos,
@retencion output, @borrarretencioncx output, @ok output, @okref output
if @movtipo in ('coms.f','coms.fl','coms.eg', 'coms.ei', 'coms.d')
select @retencion = (@importeneto * (@movretencion1 / 100.0)),
@retencion2 = (@importeneto * (@movretencion2 / 100.0)) ,
@retencion3 = (@importeneto * (@movretencion3 / 100.0))
select @sumapendiente = @sumapendiente + isnull(@cantidadpendiente, 0.0),
@sumareservada = @sumareservada + isnull(@cantidadreservada, 0.0),
@sumaordenada = @sumaordenada + isnull(@cantidadordenada, 0.0),
@sumaimporte = @sumaimporte + @importe,
@sumaimporteneto = @sumaimporteneto + @importeneto,
@comisionimporteneto = @comisionimporteneto + @importeneto,
@sumaimpuestos = @sumaimpuestos + @impuestos,
@sumaimpuestosnetos = @sumaimpuestosnetos + @impuestosnetos,
@sumaimpuesto1neto = @sumaimpuesto1neto + @impuesto1neto,
@sumaimpuesto2neto = @sumaimpuesto2neto + @impuesto2neto,
@sumaimpuesto3neto = @sumaimpuesto3neto + @impuesto3neto,
@sumacostolinea = @sumacostolinea + round(@costo * @cantidad, @redondeomonetarios),
@sumapreciolinea = @sumapreciolinea + round(@precio * @cantidad, @redondeomonetarios),
@sumadescuentolinea = @sumadescuentolinea + @descuentolineaimporte,
@sumapeso = @sumapeso + (@cantidad * @peso * @factor),
@sumavolumen = @sumavolumen + (@cantidad * @volumen * @factor),
@sumacomision = @sumacomision + isnull(@importecomision, 0.0),
@comisionacum = @comisionacum + isnull(@importecomision, 0.0)*@comisionfactor,
@sumaretencion = @sumaretencion + isnull(@retencion, 0.0),
@sumaretencion2 = @sumaretencion2 + isnull(@retencion2, 0.0),
@sumaretencion3 = @sumaretencion3 + isnull(@retencion3, 0.0)
end
if @ok is not null and @okref is null
begin
select @okref = 'articulo: '+@articulo
if @subcuenta is not null select @okref = @okref+ ' ('+@subcuenta+')'
end
if @ok is null
begin
if @modulo = 'vtas' fetch next from crventadetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadobsequio, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @agenterenglon, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @ultreservadocantidad, @ultreservadofecha, @artcomision, @espaciod, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @preciotipocambio, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3 else
if @modulo = 'coms' fetch next from crcompradetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @servicioarticulo, @servicioserie, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @movretencion1, @movretencion2, @movretencion3, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3 else
if @modulo = 'inv' fetch next from crinvdetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @prodserielote, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @ultreservadocantidad, @ultreservadofecha, @detalletipo, @producto, @subproducto, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3 else
if @modulo = 'prod' fetch next from crproddetalle into @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @factor, @movunidad, @articulo, @subcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @prodserielote, @arttipo, @artserieloteinfo, @arttipoopcion, @peso, @volumen, @artunidad, @ultreservadocantidad, @ultreservadofecha, @detalletipo, @merma, @desperdicio, @ruta, @orden, @centro, @artlotesfijos, @artactividades, @artcostoidentificado, @artcostoueps, @artcostopeps, @artultimocosto, @artpreciolista, @posicion, @artdepartamentodetallista, @artestatus, @artsituacion, @artexcento1, @artexcento2, @artexcento3
if @@error <> 0 select @ok = 1
end
end
if @modulo = 'vtas' begin close crventadetalle deallocate crventadetalle end else
if @modulo = 'coms' begin close crcompradetalle deallocate crcompradetalle end else
if @modulo = 'inv' begin close crinvdetalle deallocate crinvdetalle end else
if @modulo = 'prod' begin close crproddetalle deallocate crproddetalle end
end
if @modulo = 'vtas' and @ok is null
exec xpventaretenciontotalcalcular @id, @accion, @empresa, @usuario, @modulo, @mov, @movid, @movtipo, @movmoneda, @movtipocambio, @clienteprov,
@sumaimpuesto1neto, @sumaimpuesto2neto, @sumaimpuesto3neto,
@sumaretencion output, @sumaretencion2 output, @ok output, @okref output, @sumaretencion3 = @sumaretencion3 output
if @movimpuesto = 1
begin
delete movimpuesto where modulo = @modulo and moduloid = @id
insert movimpuesto (
modulo, moduloid, origenmodulo, origenmoduloid, origenconcepto, origenfecha, retencion1, retencion2, retencion3, excento1, excento2, excento3, impuesto1, impuesto2, impuesto3, lotefijo, importe1, importe2, importe3, subtotal)
select @modulo, @id, @modulo, @id, @concepto, @fechaemision, retencion1, retencion2, retencion3, excento1, excento2, excento3, impuesto1, impuesto2, impuesto3, lotefijo, sum(importe1), sum(importe2), sum(importe3), sum(subtotal)
from #movimpuesto
group by retencion1, retencion2, retencion3, excento1, excento2, excento3, impuesto1, impuesto2, impuesto3, lotefijo
order by retencion1, retencion2, retencion3, excento1, excento2, excento3, impuesto1, impuesto2, impuesto3, lotefijo
end
if @ppto = 1 and @accion <> 'cancelar' and (@modulo = 'coms' or (@modulo = 'vtas' and @pptoventas = 1))
exec spmoduloagregarmovpresupuesto @modulo, @id, @ok output, @okref output
if @afectarmatando = 1 and @utilizar = 0 and @matarantes = 0 and @ok is null
exec spinvmatar @sucursal, @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @ejercicio, @periodo, @afectarconsignacion, @almacentipo, @almacendestinotipo,
@cfgventasurtirdemas, @cfgcomprarecibirdemas, @cfgtransferirdemas, @cfgbackorders, @cfgcontx, @cfgcontxgenerar, @cfgembarcar, @cfgimpinc, @cfgmultiunidades, @cfgmultiunidadesnivel,
@ok output, @okref output,
@cfgpreciomoneda = @cfgpreciomoneda
if @ok is null
begin
select @importetotal = @sumaimporteneto + @sumaimpuestosnetos
if @modulo = 'vtas'
begin
select @importetotal = round(@importetotal, @cfgventaredondeodecimales)
select @sumaimporteneto = @sumaimporteneto - (@sumaimporteneto + @sumaimpuestosnetos - @importetotal)
end
if @anticiposfacturados > 0.0
begin
select @anticipoimporte = @sumaimporteneto * @anticiposfacturados / @importetotal
select @anticipoimpuestos = @anticiposfacturados - @anticipoimporte
end else
select @anticipoimporte = 0.0, @anticipoimpuestos = 0.0
select @importecx = @sumaimporteneto - @anticipoimporte,
@impuestoscx = @sumaimpuestosnetos - @anticipoimpuestos,
@retencioncx = @sumaretencion,
@retencion2cx = @sumaretencion2,
@retencion3cx = @sumaretencion3,
@importetotalcx = @importetotal - @anticiposfacturados
select @sumaretenciones = isnull(@sumaretencion, 0.0) + isnull(@sumaretencion2, 0.0) + isnull(@sumaretencion3, 0.0)
if @utilizar = 1 and @importetotal > 0.0 and @utilizarmovtipo in ('vtas.p','vtas.r','vtas.s','vtas.vc','vtas.vcr', 'coms.o', 'coms.op', 'coms.cc')
begin
if @modulo = 'vtas' update venta with (rowlock) set saldo = saldo - @importetotal where id = @utilizarid else
if @modulo = 'coms' update compra with (rowlock) set saldo = saldo - @importetotal where id = @utilizarid
if @@error <> 0 select @ok = 1
end
if (@estatus in ('sinafectar','confirmar','borrador') and @afectardetalle = 1) or (@movtipo in ('coms.d', 'coms.b', 'coms.ca', 'coms.gx'))
begin
select @paquetes = null
if @modulo = 'vtas' and @movtipo not in ('vtas.pr', 'vtas.est', 'vtas.c', 'vtas.cs', 'vtas.p', 'vtas.s', 'vtas.sd')
begin
select @paquetes = isnull(count(distinct paquete), 0) from ventad with (nolock) where id = @id
select @paquetes = @paquetes + isnull(round(sum(cantidad), 0), 0) from ventad with (nolock) where id = @id and nullif(paquete, 0) is null
end else
if @modulo = 'inv' and @movtipo not in ('inv.sol', 'inv.ot', 'inv.ot', 'inv.if')
begin
select @paquetes = isnull(count(distinct paquete) ,0) from invd with (nolock) where id = @id
select @paquetes = @paquetes + isnull(round(sum(cantidad), 0), 0) from invd with (nolock) where id = @id and nullif(paquete, 0) is null
end else
if @modulo = 'coms' and @movtipo not in ('coms.r', 'coms.c', 'coms.o', 'coms.op', 'coms.og', 'coms.od', 'coms.oi')
begin
select @paquetes = isnull(count(distinct paquete) ,0) from invd with (nolock) where id = @id
select @paquetes = @paquetes + isnull(round(sum(cantidad), 0), 0) from comprad with (nolock) where id = @id and nullif(paquete, 0) is null
end
select @ivafiscal = convert(float, @sumaimpuesto1neto) / nullif(@importetotal-@sumaretenciones, 0),
@iepsfiscal = convert(float, @sumaimpuesto2neto) / nullif(@importetotal-@sumaretenciones, 0)
if @modulo = 'vtas' update venta with (rowlock) set peso = @sumapeso, volumen = @sumavolumen, paquetes = @paquetes, importe = @sumaimporte, impuestos = @sumaimpuestosnetos, ivafiscal = @ivafiscal, iepsfiscal = @iepsfiscal, saldo = case when @estatusnuevo in ('pendiente', 'procesar') then @importetotal else null end, descuentolineal = @sumadescuentolinea, comisiontotal = @sumacomision, preciototal = @sumapreciolinea, costototal = @sumacostolinea, retencion = nullif(@sumaretenciones, 0.0) where id = @id else
if @modulo = 'coms' update compra with (rowlock) set peso = @sumapeso, volumen = @sumavolumen, paquetes = @paquetes, importe = @sumaimporte, impuestos = @sumaimpuestosnetos, ivafiscal = @ivafiscal, iepsfiscal = @iepsfiscal, saldo = case when @estatusnuevo in ('pendiente', 'procesar') then @importetotal else null end, descuentolineal = @sumadescuentolinea where id = @id else
if @modulo = 'inv' update inv with (rowlock) set peso = @sumapeso, volumen = @sumavolumen, paquetes = @paquetes, importe = @sumacostolinea where id = @id else
if @modulo = 'prod' update prod with (rowlock) set peso = @sumapeso, volumen = @sumavolumen, paquetes = @paquetes, importe = @sumacostolinea where id = @id
if @@error <> 0 select @ok = 1
end else
exec spinvrecalcencabezado @id, @modulo, @cfgimpinc, @cfgmultiunidades, @descuentoglobal, @sobreprecio,
@cfgpreciomoneda = @cfgpreciomoneda
if @movtipo = 'inv.if' and @estatusnuevo = 'concluido'
exec spinvinventariofisico @sucursal, @id, @empresa, @almacen, @idgenerar, @base, @cfgserieslotesmayoreo, @estatus, @ok output, @okref output
if @movtipo = 'vtas.s' and @estatus = 'confirmar' and @estatusnuevo in ('pendiente', 'cancelado')
begin
select @cotizacionid = id from venta with (nolock) where empresa = @empresa and origentipo = 'vtas' and origen = @mov and origenid = @movid and estatus not in ('sinafectar', 'cancelado')
select @cotizacionestatusnuevo = case when @accion = 'cancelar' then 'cancelado' else 'concluido' end
exec spvalidartareas @empresa, @modulo, @cotizacionid, @cotizacionestatusnuevo, @ok output, @okref output
update venta with (rowlock) set estatus = @cotizacionestatusnuevo where id = @cotizacionid
end
if @@error <> 0 select @ok = 1
if @estatus in ('sinafectar','autorizare','confirmar','borrador') or @accion = 'cancelar'
begin
if @accion <> 'cancelar'
begin
if @movtipo = 'vtas.fr'
select @vencimiento = isnull(case when convigencia = 1 then vigenciadesde end, @fechaemision) from venta with (nolock) where id = @id
else
exec spcalcularvencimiento @modulo, @empresa, @clienteprov, @condicion, @fechaemision, @vencimiento output, @dias output, @ok output
if(@enviara = 76)
begin
select @daperiodo = daperiodo from condicion where condicion = @condicion
if @daperiodo = 'quincenal'
begin
set @dia = datepart(dd, @vencimiento)
set @menosdias = datepart(dd, dateadd(mm, 1, @vencimiento))
set @menosdias = (@dia - @menosdias) + 15
if @dia <= 15
begin
select @esquince = 1, @vencimiento = dateadd(dd, 15 - @dia, @vencimiento)
set @vencimiento = dateadd(dd, @cortedias, @vencimiento)
end
else
begin
if @dia >= 16 and @dia <= 30
begin
select @esquince = 0,
@vencimiento = dateadd(dd, -datepart(dd, @vencimiento), dateadd(mm, 1, @vencimiento))
set @vencimiento = dateadd(dd, @cortedias, @vencimiento)
end
else
begin
select @esquince = 0,
@vencimiento = dateadd(dd, -datepart(dd, @vencimiento), dateadd(mm, 1, @vencimiento))
set @vencimiento = dateadd(dd, @cortedias +@menosdias, @vencimiento)
end
end
end
end
exec spextraerfecha @vencimiento output
end
if @movtipo in ('vtas.p', 'vtas.s', 'coms.o') and nullif(rtrim(@condicion), '') is not null and @estatusnuevo <> 'confirmar'
if (select upper(controlanticipos) from condicion with (nolock) where condicion = @condicion) in ('abierto', 'plazos', 'fecha requerida')
exec spgenerarap @sucursal, @accion, @empresa, @modulo, @id, @movtipo, @fecharegistro,
@mov, @movid, @movmoneda, @movtipocambio, @proyecto, @clienteprov, @referencia, @condicion, @vencimiento, @importetotal,
@ok output, @okref output
if @movtipo = 'vtas.no'
begin
select @escar = 1
if @accion = 'cancelar' select @escar = ~@escar
exec spsaldo @sucursal, @accion, @empresa, @usuario, 'cno', @movmoneda, @movtipocambio, @clienteprov, null, null, null,
@modulo, @id, @mov, @movid, @escar, @importetotal, null, null,
@fechaafectacion, @ejercicio, @periodo, 'consumos', null, 0, 0, 0,
@ok output, @okref output, @renglon = @renglon, @renglonsub = @renglonsub, @renglonid = @renglonid
end
end
if (@generar = 1 and @generarafectado = 1) or (@accion = 'cancelar' and @base <> 'todo')
begin
if @modulo = 'vtas' select @sumapendiente = sum(round(isnull(cantidadpendiente, 0.0), 4)), @sumareservada = sum(round(isnull(cantidadreservada, 0.0), 2)), @sumaordenada = sum(round(isnull(cantidadordenada, 0.0), 2)) from ventad with (nolock) where id = @id else
if @modulo = 'coms' select @sumapendiente = sum(round(isnull(cantidadpendiente, 0.0), 4)) from comprad with (nolock) where id = @id else
if @modulo = 'inv' select @sumapendiente = sum(round(isnull(cantidadpendiente, 0.0), 4)), @sumareservada = sum(round(isnull(cantidadreservada, 0.0), 2)), @sumaordenada = sum(round(isnull(cantidadordenada, 0.0), 2)) from invd with (nolock) where id = @id else
if @modulo = 'prod' select @sumapendiente = sum(round(isnull(cantidadpendiente, 0.0), 4)), @sumareservada = sum(round(isnull(cantidadreservada, 0.0), 2)), @sumaordenada = sum(round(isnull(cantidadordenada, 0.0), 2)) from prodd with (nolock) where id = @id
end
if @movtipo not in ('inv.if', 'prod.a', 'prod.r', 'prod.e')
begin
select @tienependientes = 0
if @modulo = 'vtas' and exists(select * from ventad with (nolock) where id = @id and ((isnull(cantidadpendiente, 0.0) <> 0.0) or (isnull(cantidadreservada, 0.0) <> 0.0) or (isnull(cantidadordenada, 0.0) <> 0.0))) select @tienependientes = 1 else
if @modulo = 'inv' and exists(select * from invd with (nolock) where id = @id and ((isnull(cantidadpendiente, 0.0) <> 0.0) or (isnull(cantidadreservada, 0.0) <> 0.0) or (isnull(cantidadordenada, 0.0) <> 0.0))) select @tienependientes = 1 else
if @modulo = 'prod' and exists(select * from prodd with (nolock) where id = @id and ((isnull(cantidadpendiente, 0.0) <> 0.0) or (isnull(cantidadreservada, 0.0) <> 0.0) or (isnull(cantidadordenada, 0.0) <> 0.0))) select @tienependientes = 1 else
if @modulo = 'coms' and exists(select * from comprad with (nolock) where id = @id and isnull(cantidadpendiente, 0.0) <> 0.0) select @tienependientes = 1
if @estatusnuevo <> 'pendiente' and @tienependientes = 1 select @estatusnuevo = 'pendiente'
if @estatusnuevo = 'pendiente' and @tienependientes = 0 select @estatusnuevo = 'concluido'
end
if @estatusnuevo = 'concluido' select @fechaconclusion = @fechaemision else if @estatusnuevo <> 'cancelado' select @fechaconclusion = null
if @estatusnuevo = 'cancelado' select @fechacancelacion = @fecharegistro else select @fechacancelacion = null
if @cfgcontx = 1 and @cfgcontxgenerar <> 'no'
begin
if @estatus not in ('sinafectar', 'borrador', 'confirmar') and @estatusnuevo = 'cancelado'
begin
if @generarpoliza = 1 select @generarpoliza = 0 else select @generarpoliza = 1
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx') and @estatus = 'pendiente' and @cfgcontxfacturaspendientes = 0
select @generarpoliza = 0
end else begin
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx') and @cfgcontxfacturaspendientes = 0
begin
if @estatusnuevo = 'concluido' select @generarpoliza = 1
end else
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @estatusnuevo <> 'cancelado' select @generarpoliza = 1
end
end
exec spvalidartareas @empresa, @modulo, @id, @estatusnuevo, @ok output, @okref output
if @modulo = 'vtas' update venta with (rowlock) set vencimiento = @vencimiento, concepto = @concepto, fechaconclusion = @fechaconclusion, fechacancelacion = @fechacancelacion, ultimocambio = @fecharegistro , estatus = @estatusnuevo, saldo = case when @estatusnuevo in ('concluido', 'cancelado') then null else saldo end, situacion = case when @estatus<>@estatusnuevo then null else situacion end, generarpoliza = @generarpoliza, autorizacion = @autorizacion, mensaje = null where id = @id else
if @modulo = 'coms' update compra with (rowlock) set vencimiento = @vencimiento, concepto = @concepto, fechaconclusion = @fechaconclusion, fechacancelacion = @fechacancelacion, ultimocambio = @fecharegistro , estatus = @estatusnuevo, saldo = case when @estatusnuevo in ('concluido', 'cancelado') then null else saldo end, situacion = case when @estatus<>@estatusnuevo then null else situacion end, generarpoliza = @generarpoliza, autorizacion = @autorizacion, mensaje = null where id = @id else
if @modulo = 'inv' update inv with (rowlock) set vencimiento = @vencimiento, concepto = @concepto, fechaconclusion = @fechaconclusion, fechacancelacion = @fechacancelacion, ultimocambio = @fecharegistro , estatus = @estatusnuevo, situacion = case when @estatus<>@estatusnuevo then null else situacion end, generarpoliza = @generarpoliza, autorizacion = @autorizacion where id = @id else
if @modulo = 'prod' update prod with (rowlock) set concepto = @concepto, fechaconclusion = @fechaconclusion, fechacancelacion = @fechacancelacion, ultimocambio = @fecharegistro , estatus = @estatusnuevo, situacion = case when @estatus<>@estatusnuevo then null else situacion end, generarpoliza = @generarpoliza, autorizacion = @autorizacion where id = @id
if @@error <> 0 select @ok = 1
exec spembarquemov @accion, @empresa, @modulo, @id, @mov, @movid, @estatus, @estatusnuevo, @cfgembarcar, @ok output
if @accion = 'cancelar'
begin
if @estatusnuevo = 'pendiente'
begin
if @modulo = 'vtas' update venta with (rowlock) set saldo = saldo - @importetotal where id = @id else
if @modulo = 'coms' update compra with (rowlock) set saldo = saldo - @importetotal where id = @id
end else
begin
if @modulo = 'vtas' update venta with (rowlock) set saldo = null where id = @id else
if @modulo = 'coms' update compra with (rowlock) set saldo = null where id = @id
end
if @@error <> 0 select @ok = 1
end
if @movtipo in ('vtas.vc','vtas.vcr','vtas.dc','vtas.dcr') and @accion <> 'cancelar'
begin
update venta with (rowlock) set almacendestino = case when @movtipo in ('vtas.vc','vtas.vcr') then @generaralmacendestino else @generaralmacen end where id = @id
if @@error <> 0 select @ok = 1
end
if @utilizar = 1 and @ok is null
begin
select @utilizarestatus = 'concluido', @sumapendiente = 0.0
if @afectarmatando = 1
begin
if @modulo = 'vtas' select @sumapendiente = sum(round(isnull(cantidadpendiente,0.0), 4)) + sum(round(isnull(cantidadreservada,0.0), 4)) from ventad with (nolock) where id = @utilizarid else
if @modulo = 'coms' select @sumapendiente = sum(round(isnull(cantidadpendiente,0.0), 4)) from comprad with (nolock) where id = @utilizarid else
if @modulo = 'inv' select @sumapendiente = sum(round(isnull(cantidadpendiente,0.0), 4)) + sum(round(isnull(cantidadreservada,0.0), 4)) from invd with (nolock) where id = @utilizarid else
if @modulo = 'prod' select @sumapendiente = sum(round(isnull(cantidadpendiente,0.0), 4)) + sum(round(isnull(cantidadreservada,0.0), 4)) from prodd with (nolock) where id = @utilizarid
if @@error <> 0 select @ok = 1
if @sumapendiente > 0.0 select @utilizarestatus = 'pendiente'
end
if @utilizarestatus = 'concluido' select @fechaconclusion = @fechaemision else if @utilizarestatus <> 'cancelado' select @fechaconclusion = null
exec spvalidartareas @empresa, @modulo, @utilizarid, @utilizarestatus, @ok output, @okref output
if @modulo = 'vtas' update venta with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @utilizarestatus where id = @utilizarid else
if @modulo = 'coms' update compra with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @utilizarestatus where id = @utilizarid else
if @modulo = 'inv' update inv with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @utilizarestatus where id = @utilizarid else
if @modulo = 'prod' update prod with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @utilizarestatus where id = @utilizarid
if @@error <> 0 select @ok = 1
end
if @generar = 1 and @ok is null
begin
if @generarafectado = 1 select @generarestatus = 'concluido' else select @generarestatus = 'sinafectar'
if @generarestatus = 'concluido' select @fechaconclusion = @fechaemision else if @generarestatus <> 'cancelado' select @fechaconclusion = null
if @utilizarestatus = 'concluido' and @cfgcontx = 1 and @cfgcontxgenerar <> 'no' select @generarpolizatemp = 1 else select @generarpolizatemp = 0
exec spvalidartareas @empresa, @modulo, @idgenerar, @generarestatus, @ok output, @okref output
if @modulo = 'vtas' update venta with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @generarestatus, generarpoliza = @generarpolizatemp where id = @idgenerar else
if @modulo = 'coms' update compra with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @generarestatus, generarpoliza = @generarpolizatemp where id = @idgenerar else
if @modulo = 'inv' update inv with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @generarestatus, generarpoliza = @generarpolizatemp where id = @idgenerar else
if @modulo = 'prod' update prod with (rowlock) set fechaconclusion = @fechaconclusion, estatus = @generarestatus, generarpoliza = @generarpolizatemp where id = @idgenerar
if @@error <> 0 select @ok = 1
exec xpinvgenerarfinal @empresa, @usuario, @accion, @modulo, @id, @idgenerar, @generarestatus, @ok output, @okref output
end
if @movtipo = 'vtas.s' and nullif(rtrim(@servicioserie), '') is not null
begin
exec spserieloteflujo @sucursal, @sucursalalmacen, @sucursalalmacendestino, @accion, @empresa, @modulo, @id, @servicioarticulo, null, @servicioserie, @almacen, 0
end
select @continuar = 1, @cxid = null, @cxmovtipo = null
if (@facturarvtasmostrador = 1 and @accion <> 'cancelar') or (@accion ='cancelar' and @movtipo in ('vtas.f','vtas.far','vtas.fb') and @origentipo = 'vmos')
begin
select @continuar = 0
exec spinvrecalcencabezado @id, @modulo, @cfgimpinc, @cfgmultiunidades, @descuentoglobal, @sobreprecio,
@cfgpreciomoneda = @cfgpreciomoneda
if @movtipo in ('vtas.f','vtas.far','vtas.fb')
begin
exec spinvmatarnotas @sucursal, @id, @accion, @empresa, @usuario, @modulo, @mov, @movid, @fechaafectacion, @ejercicio, @periodo, @ok output, @okref output, @afectandonotassincobro output
select @continuar = @afectandonotassincobro
end
end
if @movtipo = 'vtas.fb' and @accion in ('afectar', 'cancelar')
begin
exec spmovtipoinstruccionbit @modulo, @mov, 'incrementasaldotarjeta', @incrementasaldotarjeta output, @ok output, @okref output
if @incrementasaldotarjeta = 1
exec spincrementasaldotarjeta @empresa, @id, @mov, @movid, @modulo, @ejercicio, @periodo, @accion, @fechaemision, @movmoneda, @movtipocambio, @ok output, @okref output
end
if @continuar = 1 and (@estatus in ('sinafectar', 'borrador', 'confirmar') or @estatusnuevo = 'cancelado') and @ok is null
begin
if @accion = 'cancelar'
begin
if @cfgcompraautocars = 1 and @movtipo in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei', 'coms.d', 'coms.b') and @ok is null
exec xpcompraautocars @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo, @empresa, @id, @mov,
@movid, @movtipo, @movmoneda, @movtipocambio, @fechaemision , @concepto, @proyecto,
@usuario, @autorizacion, @referencia, @docfuente, @observaciones, @fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @sumaimporteneto, @sumaimpuestosnetos, @vin, @ok output, @okref output
if @cfgventaautobonif = 1 and @movtipo in ('vtas.f','vtas.far', 'vtas.d', 'vtas.df', 'vtas.b') and @ok is null
exec xpventaautobonif @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo, @empresa, @id, @mov,
@movid, @movtipo, @movmoneda, @movtipocambio, @fechaemision , @concepto, @proyecto,
@usuario, @autorizacion, @referencia, @docfuente, @observaciones, @fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @cobrointegrado, @sumaimporteneto, @sumaimpuestosnetos, @vin, @ok output, @okref output
if @movtipo in ('vtas.f','vtas.far') and (select cxcautoaplicaranticipospedidos from empresacfg2 with (nolock) where empresa = @empresa) = 1
begin
select @referenciaaplicacionanticipo = rtrim(@origen) + ' ' + rtrim(@origenid)
exec xpventaautoaplicaranticipospedidos @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo, @empresa, @id, @mov,
@movid, @movtipo, @movmoneda, @movtipocambio, @fechaemision , @concepto, @proyecto,
@usuario, @autorizacion, @referenciaaplicacionanticipo, @docfuente, @observaciones, @fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @cobrointegrado, @sumaimporteneto, @sumaimpuestosnetos, @vin, @ok output, @okref output
end
end
if @modulo = 'vtas' and @cobrointegrado = 0
exec spborrarventacobro @id
if @cobrointegrado = 1
begin
select @dineroimporte = 0.0, @cobrodesglosado = 0.0, @cobrodelefectivo = 0.0, @cobrocambio = 0.0, @valescobrados = 0.0, @cobroredondeo = 0.0, @tarjetascobradas = 0.0
select @importe1 = isnull(importe1, 0.0), @importe2 = isnull(importe2, 0.0), @importe3 = isnull(importe3, 0.0), @importe4 = isnull(importe4, 0.0), @importe5 = isnull(importe5, 0.0),
@formacobro1 = rtrim(formacobro1), @formacobro2 = rtrim(formacobro2), @formacobro3 = rtrim(formacobro3), @formacobro4 = rtrim(formacobro4), @formacobro5 = rtrim(formacobro5),
@referencia1 = rtrim(referencia1), @referencia2 = rtrim(referencia2), @referencia3 = rtrim(referencia3), @referencia4 = rtrim(referencia4), @referencia5 = rtrim(referencia5),
@cobrodelefectivo = isnull(delefectivo, 0.0), @ctadinero = nullif(rtrim(ctadinero), ''), @cajero = nullif(rtrim(cajero), ''),
@cobroredondeo = isnull(redondeo, 0.0)
from ventacobro with (nolock)
where id = @id
exec spventacobrototal @formacobro1, @formacobro2, @formacobro3, @formacobro4, @formacobro5,
@importe1, @importe2, @importe3, @importe4, @importe5, @cobrodesglosado output, @moneda = @movmoneda, @tipocambio = @movtipocambio
select @formacobrovales = cxcformacobrovales, @formacobrotarjetas = cxcformacobrotarjetas from empresacfg where empresa = @empresa
if @formacobro1 = @formacobrovales select @valescobrados = @valescobrados + @importe1
if @formacobro2 = @formacobrovales select @valescobrados = @valescobrados + @importe2
if @formacobro3 = @formacobrovales select @valescobrados = @valescobrados + @importe3
if @formacobro4 = @formacobrovales select @valescobrados = @valescobrados + @importe4
if @formacobro5 = @formacobrovales select @valescobrados = @valescobrados + @importe5
if @formacobro1 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe1
if @formacobro2 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe2
if @formacobro3 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe3
if @formacobro4 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe4
if @formacobro5 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe5
if @cobrodesglosado + @cobrodelefectivo <> 0.0
begin
select @cobrocambio = @cobrodesglosado + @cobrodelefectivo - @importetotalcx - @cobroredondeo
if round(abs(@cobrocambio), @redondeomonetarios) = 0.01 select @cobrocambio = 0.0
if @accion <> 'cancelar'
update ventacobro with (rowlock) set actualizado = 1, cambio = @cobrocambio where id = @id
select @dineroimporte = @cobrodesglosado - @cobrocambio
end
end
if @cobrointegrado = 1 and @cobrointegradocxc = 0 and @cobrointegradoparcial = 0 and @origentipo <> 'cr' and @importetotalcx <> 0.0 and (@estatus in ('sinafectar', 'confirmar', 'borrador') or @estatusnuevo = 'cancelado') and @ok is null
begin
if @valescobrados > 0.0 or @tarjetascobradas <> 0
exec spvaleaplicarcobro @empresa, @modulo, @id, @tarjetascobradas, @accion, @fechaemision, @ok output, @okref output
if @ok is null and @tarjetascobradas <> 0
exec spvalegeneraaplicaciontarjeta @empresa, @modulo, @id, @mov, @movid, @accion, @fechaemision, @usuario, @sucursal,
@tarjetascobradas, @ctadinero, @movmoneda, @movtipocambio, @ok output, @okref output
if @ok is null and @modulo = 'vtas' and @cfgventamonedero = 1 and exists(select * from tarjetaseriemov where empresa = @empresa and modulo = @modulo and id = @id)
exec spventamonedero @empresa, @modulo, @id, @mov, @movid, @movtipo, @accion, @fechaemision,
@ejercicio, @periodo, @usuario, @sucursal, @movmoneda, @movtipocambio,
@ok output, @okref output
if @cobrodelefectivo <> 0.0
begin
if @movtipo in ('vtas.vp', 'vtas.sd') select @escar = 0 else select @escar = 1
if @accion = 'cancelar' select @escar = ~@escar
exec spsaldo @sucursalorigen , @accion, @empresa, @usuario, 'cefe', @movmoneda, @movtipocambio, @clienteprov, null, null, null,
@modulo, @id, @mov, @movid, @escar, @cobrodelefectivo, null, null,
@fechaafectacion, @ejercicio, @periodo, 'saldo a favor', null, 0, 0, 0,
@ok output, @okref output
end
if @dineroimporte <> 0.0
begin
select @cobrosumaefectivo = 0.0
if @importe1 <> 0.0
begin
exec spformapamontc @formacobro1, @referencia1, @movmoneda, @movtipocambio, @importe1, @cobrosumaefectivo output, @formamoneda output, @formatipocambio output, @ok output, @formacobrovales
exec spgenerardinero @sucursalorigen, @sucursalorigen, @sucursalorigen, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @formamoneda, @formatipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia1, @docfuente, @observaciones, 0, 0,
@fecharegistro, @ejercicio, @periodo,
@formacobro1, null, null,
@clienteprov, @ctadinero, @cajero, @importe1, null,
null, null, null,
@dineromov output, @dineromovid output,
@ok output, @okref output
end
if @importe2 <> 0.0
begin
exec spformapamontc @formacobro2, @referencia2, @movmoneda, @movtipocambio, @importe2, @cobrosumaefectivo output, @formamoneda output, @formatipocambio output, @ok output, @formacobrovales
exec spgenerardinero @sucursalorigen, @sucursalorigen, @sucursalorigen, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @formamoneda, @formatipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia2, @docfuente, @observaciones, 0, 0,
@fecharegistro, @ejercicio, @periodo,
@formacobro2, null, null,
@clienteprov, @ctadinero, @cajero, @importe2, null,
null, null, null,
@dineromov output, @dineromovid output,
@ok output, @okref output
end
if @importe3 <> 0.0
begin
exec spformapamontc @formacobro3, @referencia3, @movmoneda, @movtipocambio, @importe3, @cobrosumaefectivo output, @formamoneda output, @formatipocambio output, @ok output, @formacobrovales
exec spgenerardinero @sucursalorigen, @sucursalorigen, @sucursalorigen, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @formamoneda, @formatipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia3, @docfuente, @observaciones, 0, 0,
@fecharegistro, @ejercicio, @periodo,
@formacobro3, null, null,
@clienteprov, @ctadinero, @cajero, @importe3, null,
null, null, null,
@dineromov output, @dineromovid output,
@ok output, @okref output
end
if @importe4 <> 0.0
begin
exec spformapamontc @formacobro4, @referencia4, @movmoneda, @movtipocambio, @importe4, @cobrosumaefectivo output, @formamoneda output, @formatipocambio output, @ok output, @formacobrovales
exec spgenerardinero @sucursalorigen, @sucursalorigen, @sucursalorigen, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @formamoneda, @formatipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia4, @docfuente, @observaciones, 0, 0,
@fecharegistro, @ejercicio, @periodo,
@formacobro4, null, null,
@clienteprov, @ctadinero, @cajero, @importe4, null,
null, null, null,
@dineromov output, @dineromovid output,
@ok output, @okref output
end
if @importe5 <> 0.0
begin
exec spformapamontc @formacobro5, @referencia5, @movmoneda, @movtipocambio, @importe5, @cobrosumaefectivo output, @formamoneda output, @formatipocambio output, @ok output, @formacobrovales
exec spgenerardinero @sucursalorigen, @sucursalorigen, @sucursalorigen, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @formamoneda, @formatipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia5, @docfuente, @observaciones, 0, 0,
@fecharegistro, @ejercicio, @periodo,
@formacobro5, null, null,
@clienteprov, @ctadinero, @cajero, @importe5, null,
null, null, null,
@dineromov output, @dineromovid output,
@ok output, @okref output
end
if round(@cobrocambio, 2) <> 0.0
begin
if abs(round(@cobrosumaefectivo, 2)) < abs(round(@cobrocambio, 2)) select @ok = 30590
if @ok is null
begin
select @formapacambio = formapacambio from empresacfg with (nolock) where empresa = @empresa
select @importecambio = -@cobrocambio
exec spformapamontc @formapacambio, null, @movmoneda, @movtipocambio, @importecambio, null, @formamoneda output, @formatipocambio output, @ok output, @formacobrovales
exec spgenerardinero @sucursalorigen, @sucursalorigen, @sucursalorigen, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @formamoneda, @formatipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, 'cambio', @docfuente, @observaciones, 0, 0,
@fecharegistro, @ejercicio, @periodo,
@formapacambio, null, null,
null, @ctadinero, @cajero, @importecambio, null,
null, null, null,
@dineromov output, @dineromovid output,
@ok output, @okref output
end
end
end
end else
if @importetotalcx > 0.0 and @ok is null and @origentipo <> 'cr' and
(@movtipo in ('vtas.fm', 'vtas.n', 'vtas.no', 'vtas.nr') and @cobrointegradocxc = 1) or
(@movtipo in ('vtas.f','vtas.fx','vtas.far', 'vtas.fb','vtas.d','vtas.df') and @cobrarpedido = 0 and (@estatus in ('sinafectar', 'confirmar', 'borrador') or @estatusnuevo = 'cancelado')) or
(@movtipo in ('vtas.b', 'coms.f','coms.fl','coms.eg', 'coms.ei','coms.d','coms.b','coms.ca', 'coms.gx') and @estatusnuevo in ('concluido','procesar','cancelado'))
begin
if @borrarretencioncx = 1 select @retencioncx = 0.0, @retencion2cx = 0.0, @retencion3cx = 0.0
if @movtipo = 'coms.ei'
exec spgenerarcximportacion @sucursal, @sucursalorigen, @sucursaldestino, @accion, null, @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @enviara, @agente, null, null, null,
@importecx, @impuestoscx, @retencioncx, @sumacomision,
null, null, null, null, @vin, null,
@cxmodulo output, @cxmov output, @cxmovid output,
@ok output, @okref output, @instrucciones_esp = 'sin_docauto', @ivafiscal = @ivafiscal, @iepsfiscal = @iepsfiscal, @retencion2 = @retencion2cx, @retencion3 = @retencion3cx
else begin
if (@cobrointegradocxc = 1 or @cobrointegradoparcial = 1) and @accion = 'cancelar'
exec spcobrointegradocxccancelar @sucursal, @accion, @modulo, @empresa, @usuario, @id, @mov, @movid, @fecharegistro, @ok output, @okref output
select @condicioncx = @condicion, @vencimientocx = @vencimiento
if @cobrointegradoparcial = 1
select @condicioncx = condicion, @vencimientocx = vencimiento from ventacobro with (nolock) where id = @id
if @cfgac = 1 and @modulo = 'vtas'
begin
select @lcmetodo = ta.metodo, @lcporcentajeresidual = isnull(lc.porcentajeresidual, 0)
from venta v with (nolock)
join tipoamortizacion ta with (nolock) on ta.tipoamortizacion = v.tipoamortizacion
join lc with (nolock) on lc.lineacredito = v.lineacredito
where v.id = @id
exec xpporcentajeresidual @modulo, @id, @lcporcentajeresidual output
end
exec @cxid = spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, null, @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
@condicioncx, @vencimientocx, @clienteprov, @enviara, @agente, null, null, null,
@importecx, @impuestoscx, @retencioncx, @sumacomision,
null, null, null, null, @vin, null,
@cxmodulo output, @cxmov output, @cxmovid output,
@ok output, @okref output, @instrucciones_esp = 'sin_docauto', @ivafiscal = @ivafiscal, @iepsfiscal = @iepsfiscal, @retencion2 = @retencion2cx, @retencion3 = @retencion3cx, @endosara = @endosara, @copiarmovimpuesto = 1
if (@cobrointegradocxc = 1 or @cobrointegradoparcial = 1) and @accion <> 'cancelar'
exec spcobrointegradocxc @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo,
@empresa, @usuario, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio, @fecharegistro,
@dineroimporte, @cobrodelefectivo, @cobrocambio,
@formacobro1, @formacobro2, @formacobro3, @formacobro4, @formacobro5,
@importe1, @importe2, @importe3, @importe4, @importe5,
@referencia1, @referencia2, @referencia3, @referencia4, @referencia5,
@ctadinero, @cajero, @cxid, @ok output, @okref output
if @cfgac = 1 and @lcmetodo = 50 and @accion <> 'cancelar'
begin
select @cxajusteimporte = @importecx * (@lcporcentajeresidual/100.0)
if @cxajusteimporte > 0.0
begin
select @cxajustemov = acajustevalorresidual from empresacfgmov with (nolock) where empresa = @empresa
select @cxconcepto = acajusteconceptovalorresidual from empresacfg with (nolock) where empresa = @empresa
exec @cxajusteid = spafectar 'cxc', @cxid, 'generar', 'todo', @cxajustemov, @usuario, @ensilencio = 1, @conexion = 1, @ok = @ok output, @okref = @okref output
if @ok = 80030 select @ok = null, @okref = null
if @ok is null and @cxajusteid is not null
begin
update cxc with (rowlock) set concepto = @cxconcepto, importe = @cxajusteimporte, impuestos = null, aplicamanual = 1 where id = @cxajusteid
delete cxcd where id = @cxajusteid
insert cxcd (id, renglon, aplica, aplicaid, importe) values (@cxajusteid, 2048.0, @mov, @movid, @cxajusteimporte)
exec spafectar 'cxc', @cxajusteid, 'afectar', 'todo', null, @usuario, @ensilencio = 1, @conexion = 1, @ok = @ok output, @okref = @okref output
end
end
select @cxajusteimporte = @impuestoscx
if @cxajusteimporte > 0.0
begin
select @cxajustemov = acajusteimpuestoad from empresacfgmov with (nolock) where empresa = @empresa
select @cxconcepto = acajusteconceptoimpuestoad from empresacfg with (nolock) where empresa = @empresa
exec @cxajusteid = spafectar 'cxc', @cxid, 'generar', 'todo', @cxajustemov, @usuario, @ensilencio = 1, @conexion = 1, @ok = @ok output, @okref = @okref output
if @ok = 80030 select @ok = null, @okref = null
if @ok is null and @cxajusteid is not null
begin
update cxc with (rowlock) set concepto = @cxconcepto, importe = @cxajusteimporte, impuestos = null, aplicamanual = 1 where id = @cxajusteid
delete cxcd where id = @cxajusteid
insert cxcd (id, renglon, aplica, aplicaid, importe) values (@cxajusteid, 2048.0, @mov, @movid, @cxajusteimporte)
exec spafectar 'cxc', @cxajusteid, 'afectar', 'todo', null, @usuario, @ensilencio = 1, @conexion = 1, @ok = @ok output, @okref = @okref output
end
end
end
end
if @cxid is not null
select @cxmovtipo = clave from movtipo with (nolock) where modulo = @cxmodulo and mov = @cxmov
end
if @fiscal = 0 and @cfgretencionalpa = 0 and @movtipo in ('coms.f','coms.fl','coms.eg', 'coms.ei', 'coms.d') and (@sumaretencion <> 0.0 or @sumaretencion2 <> 0.0 or @sumaretencion3 <> 0.0)
begin
if @sumaretencion <> 0.0
begin
if @cfgretencionacreedor is null
select @ok = 70100
else
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, null, @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaemision, @cfgretencionconcepto, @proyecto, @usuario, @autorizacion, null, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
null, null, @cfgretencionacreedor, null, null, null, null, null,
@sumaretencion, null, null, null,
null, null, null, null, null, @cfgretencionmov,
@cxmodulo output, @cxmov output, @cxmovid output,
@ok output, @okref output
end
if @sumaretencion2 <> 0.0
begin
if @cfgretencion2acreedor is null
select @ok = 70100
else
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, null, @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaemision, @cfgretencion2concepto, @proyecto, @usuario, @autorizacion, null, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
null, null, @cfgretencion2acreedor, null, null, null, null, null,
@sumaretencion2, null, null, null,
null, null, null, null, null, @cfgretencionmov,
@cxmodulo output, @cxmov output, @cxmovid output,
@ok output, @okref output
end
if @sumaretencion3 <> 0.0
begin
if @cfgretencion3acreedor is null
select @ok = 70100
else
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, null, @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaemision, @cfgretencion3concepto, @proyecto, @usuario, @autorizacion, null, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
null, null, @cfgretencion3acreedor, null, null, null, null, null,
@sumaretencion3, null, null, null,
null, null, null, null, null, @cfgretencionmov,
@cxmodulo output, @cxmov output, @cxmovid output,
@ok output, @okref output
end
end
if @movtipo in ('vtas.f','vtas.far', 'vtas.fb') and (@estatus = 'sinafectar' or @estatusnuevo = 'cancelado') and @cfganticiposfacturados = 1 and @anticiposfacturados > 0.0
begin
if @accion = 'cancelar' select @escar = 1 else select @escar = 0
if @accion = 'cancelar'
update cxc with (rowlock)
set anticiposaldo = isnull(anticiposaldo, 0) + vfa.importe
from cxc c, ventafacturaanticipo vfa with (nolock)
where vfa.id = @id and vfa.cxcid = c.id
else begin
select @sumaanticiposfacturados = sum(anticipoaplicar) from cxc with (nolock) where anticipoaplicamodulo = @modulo and anticipoaplicaid = @id
exec xpsumaanticiposfacturados @empresa, @usuario, @accion, @modulo, @id, @movmoneda, @movtipocambio, @sumaanticiposfacturados output, @ok output, @okref output
if isnull(@sumaanticiposfacturados, 0)>0 and @anticiposfacturados <> @sumaanticiposfacturados select @ok = 30405 else
if exists(select * from cxc with (nolock) where anticipoaplicamodulo = @modulo and anticipoaplicaid = @id and (isnull(anticipoaplicar, 0) < 0.0 or round(anticipoaplicar, 0) > round(anticiposaldo, 0))) select @ok = 30405
else begin
insert ventafacturaanticipo (id, cxcid, importe)
select @id, id, anticipoaplicar
from cxc with (nolock)
where anticipoaplicamodulo = @modulo and anticipoaplicaid = @id
update cxc with (rowlock)
set anticiposaldo = isnull(anticiposaldo, 0) - isnull(anticipoaplicar, 0),
anticipoaplicar = null,
anticipoaplicamodulo = null,
anticipoaplicaid = null
where anticipoaplicamodulo = @modulo and anticipoaplicaid = @id
end
end
exec spsaldo @sucursal, @accion, @empresa, @usuario, 'cant', @movmoneda, @movtipocambio, @clienteprov, null, null, null,
@modulo, @id, @mov, @movid, @escar, @anticiposfacturados, null, null,
@fechaafectacion, @ejercicio, @periodo, @mov, @movid, 0, 0, 0,
@ok output, @okref output
end
if @movtipo in ('coms.eg', 'coms.ei', 'inv.ei') and @estatusnuevo in ('concluido','procesar','cancelado')
exec spafectargastodiverso @sucursal, @sucursalorigen, @sucursaldestino, @accion, @empresa, @modulo, @id, @mov, @movid, @movtipo, @fecharegistro,
@proyecto, @usuario, @autorizacion, @referencia, @docfuente, @observaciones, @ejercicio, @periodo, @vin,
@ok output, @okref output
if @ultagente is not null and @comisionacum <> 0.0 and @ok is null and
(((@movtipo in ('vtas.f','vtas.far', 'vtas.fb', 'vtas.d', 'vtas.df', 'vtas.b') and (@estatus = 'sinafectar' or @estatusnuevo = 'cancelado')) and (@cfgventacomisionescobradas = 0 or @cobrointegrado = 1 or @cobrarpedido = 1)) or @movtipo in ('vtas.fm', 'vtas.n', 'vtas.no', 'vtas.nr'))
begin
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, 'agent', @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
null, null, @clienteprov, null, @ultagente, null, null, null,
@comisionimporteneto, null, null, @comisionacum,
null, null, null, null, null, null,
@cxmodulo, @cxmov, @cxmovid, @ok output, @okref output
select @comisionacum = 0.0, @comisionimporteneto = 0.0
end
if @movtipo = 'vtas.df' or (@movtipo = 'inv.a' and @cfginvajustecaragente <> 'no') and @ok is null
begin
select @cximporte = null, @cxmovespecifico = null, @cxagente = @agente
if @movtipo = 'vtas.df'
begin
select @cximporte = -sum(cantidad*costo) from ventad with (nolock) where id = @id
select @cxmovespecifico = @mov
select @cxagente = agenteservicio from venta with (nolock) where id = @id
end else begin
if @cfginvajustecaragente = 'precio'
select @cximporte = sum(d.cantidad*isnull(d.precio, a.preciolista)) from invd d with (nolock), art a with (nolock) where d.id = @id and d.articulo = a.articulo
else
select @cximporte = sum(cantidad*costo) from invd with (nolock) where id = @id
end
if isnull(@cximporte, 0.0) < 0.0
begin
select @cximporte = -@cximporte
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @accion, 'agent', @empresa, @modulo, @id, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaafectacion, @concepto, @proyecto, @usuario, @autorizacion, @referencia, @docfuente, @observaciones,
@fecharegistro, @ejercicio, @periodo,
null, null, @agente, null, @cxagente, null, null, null,
@cximporte, null, null, @cximporte,
null, null, null, null, null, @cxmovespecifico,
@cxmodulo, @cxmov, @cxmovid, @ok output, @okref output
if @ok = 80030 select @ok = null, @okref = null
end
end
if @accion <> 'cancelar'
begin
if @cfgcompraautocars = 1 and @movtipo in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei', 'coms.d', 'coms.b') and @ok is null
exec xpcompraautocars @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo, @empresa, @id, @mov,
@movid, @movtipo, @movmoneda, @movtipocambio, @fechaemision , @concepto, @proyecto,
@usuario, @autorizacion, @referencia, @docfuente, @observaciones, @fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @sumaimporteneto, @sumaimpuestosnetos, @vin, @ok output, @okref output
if @cfgventaautobonif = 1 and @movtipo in ('vtas.f','vtas.far', 'vtas.d', 'vtas.df', 'vtas.b') and @ok is null
exec xpventaautobonif @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo, @empresa, @id, @mov,
@movid, @movtipo, @movmoneda, @movtipocambio, @fechaemision , @concepto, @proyecto,
@usuario, @autorizacion, @referencia, @docfuente, @observaciones, @fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @cobrointegrado, @sumaimporteneto, @sumaimpuestosnetos, @vin, @ok output, @okref output
end
if @accion <> 'cancelar' and @movtipo in ('vtas.f','vtas.far') and (select cxcautoaplicaranticipospedidos from empresacfg2 with (nolock) where empresa = @empresa) = 1
begin
select @referenciaaplicacionanticipo = rtrim(@origen) + ' ' + rtrim(@origenid)
exec xpventaautoaplicaranticipospedidos @sucursal, @sucursalorigen, @sucursaldestino, @accion, @modulo, @empresa, @id, @mov,
@movid, @movtipo, @movmoneda, @movtipocambio, @fechaemision , @concepto, @proyecto,
@usuario, @autorizacion, @referenciaaplicacionanticipo, @docfuente, @observaciones, @fecharegistro, @ejercicio, @periodo,
@condicion, @vencimiento, @clienteprov, @cobrointegrado, @sumaimporteneto, @sumaimpuestosnetos, @vin, @ok output, @okref output
end
if @ok in (null, 80030) and @cxid is not null and @cxmovtipo in ('cxc.f', 'cxc.ca', 'cxc.cap', 'cxc.cad', 'cxc.d', 'cxp.f', 'cxp.ca', 'cxp.cap', 'cxp.cad', 'cxp.d') and @condicion is not null and @accion <> 'cancelar'
begin
select @ok = null, @okref = null
if (select ac from empresagral with (nolock) where empresa = @empresa) = 0
if exists(select * from condicion with (nolock) where condicion = @condicion and da = 1)
exec spcxdocauto @cxmodulo, @cxid, @usuario, @ok output, @okref output
end
if @cfgcompraautoendosoautocars = 1 and @modulo = 'coms' and @movtipo = 'coms.f' and @accion = 'afectar' and @estatusnuevo = 'concluido' and @cxmodulo = 'cxp' and @cxmovtipo = 'cxp.f' and @cxid is not null and @ok in (null, 80030)
begin
select @proveedor = proveedor from compra with (nolock) where id = @id
select @autoendosar = autoendoso from prov with (nolock) where proveedor = @proveedor
if @autoendosar is not null
begin
select @ok = null, @okref = null
select @cxendosomov = cxpendoso from empresacfgmov with (nolock) where empresa = @empresa
exec spcx @cxid, @cxmodulo, 'generar', 'todo', @fecharegistro, @cxendosomov, @usuario, 1, 0, @cxendosomov output, @cxendosomovid output, @cxendosoid output, @ok output, @okref output
if @ok = 80030 select @ok = null, @okref = null
if @ok is null
begin
if @cxmodulo = 'cxp' update cxp with (rowlock) set fechaemision = @fechaemision, proveedor = @autoendosar where id = @cxendosoid
exec spcx @cxendosoid, @cxmodulo, 'afectar', 'todo', @fecharegistro, null, @usuario, 1, 0, @cxendosomov output, @cxendosomovid output, null, @ok output, @okref output
end
end
end
if @movtipo = 'coms.op' and @ok is null
exec spcompraprorrateo @sucursal, @empresa, @usuario, @accion, @modulo, @id, @fecharegistro,
@mov, @movid, @fechaemision, @ejercicio, @periodo, @movmoneda, @movtipocambio,
@ok output, @okref output
if @movtipo = 'prod.o' and @ok is null
exec spprodexplotar @sucursal, @empresa, @usuario, @accion, @modulo, @id, @fecharegistro, 0, @ok output, @okref output
if @movtipo in ('vtas.fg') and @ok is null
exec spgenerargasto @accion, @empresa, @sucursal, @usuario, @modulo, @id, @mov, @movid, @fechaemision, @fecharegistro, @ok output, @okref output, @movtipo = @movtipo
end
end
if @modulo = 'vtas'
begin
if (select tienemovimientos from cte with (nolock) where cliente = @clienteprov) = 0
update cte with (rowlock) set tienemovimientos = 1 where cliente = @clienteprov
end
if @modulo = 'vtas' and @enviara is not null
begin
if (select tienemovimientos from cteenviara with (nolock) where cliente = @clienteprov and id = @enviara) = 0
update cteenviara with (rowlock) set tienemovimientos = 1 where cliente = @clienteprov and id = @enviara
end
if @almacen is not null
begin
if (select tienemovimientos from alm with (nolock) where almacen = @almacen) = 0
update alm with (rowlock) set tienemovimientos = 1 where almacen = @almacen
end
if @almacendestino is not null
begin
if (select tienemovimientos from alm with (nolock) where almacen = @almacendestino) = 0
update alm with (rowlock) set tienemovimientos = 1 where almacen = @almacendestino
end
if @agente is not null
begin
if (select tienemovimientos from agente with (nolock) where agente = @agente) = 0
update agente with (rowlock) set tienemovimientos = 1 where agente = @agente
end
if @modulo = 'coms'
begin
if (select tienemovimientos from prov with (nolock) where proveedor = @clienteprov) = 0
update prov with (rowlock) set tienemovimientos = 1 where proveedor = @clienteprov
end
if @origenmovtipo = 'vtas.fr'
exec spafectarmovrecurrente @accion, @empresa, @modulo, @origen, @origenid, @ok output, @okref output
if @movtipo = 'vtas.cto'
exec spmovcontratogenerar @accion, @empresa, @sucursal, @usuario, @modulo, @id, @mov, @movid, @fecharegistro, @ok output, @okref output
if @movtipo in ('coms.ca', 'coms.gx')
begin
select @prorrateoaplicaid = p.id, @prorrateoaplicaidmov = p.mov, @prorrateoaplicaidmovid = p.movid
from compra c with (nolock), compra p with (nolock)
where c.id = @id
and c.prorrateoaplicaid = p.id
if @prorrateoaplicaid is not null
exec spmovflujo @sucursal, @accion, @empresa, @modulo, @id, @mov, @movid, @modulo, @prorrateoaplicaid, @prorrateoaplicaidmov, @prorrateoaplicaidmovid, @ok output
end
if @ok is null or @ok between 80030 and 81000
begin
if @generargasto = 1 and @modulo = 'inv'
exec spgenerargasto @accion, @empresa, @sucursal, @usuario, @modulo, @id, @mov, @movid, @fechaemision, @fecharegistro, @ok output, @okref output, @movtipogenerargasto = 1
exec xpinvgenerargasto @sucursal, @accion, @modulo, @id, @mov, @movid, @movtipo, @empresa, @usuario, @fecharegistro, @clienteprov, @ok output, @okref output
end
if @movtipo in ('coms.f', 'coms.cc', 'vtas.f') and @accion = 'afectar' and @estatusnuevo = 'concluido'
exec speliminarordenespendientes @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @conexion, @sincrofinal, @sucursal,
null, null,
@ok output, @okref output
if @movtipo in ('vtas.p', 'vtas.s') and @cfgventadmultiagentesugerir = 1 and @estatusnuevo = 'pendiente'
exec spsugerirventadagentefecha @id, @ensilencio = 1
if @wms = 1 and (select wms from alm with (nolock) where almacen = @almacen) = 1 and @accion in ('afectar', 'cancelar', 'reservarparcial')
begin
select @wmsmov = null
select @wmsmov = nullif(rtrim(wmsmov), '') from cfgwmsmov with (nolock) where modulo = @modulo and mov = @mov
if @wmsmov is not null
exec spwmsgenerar @empresa, @sucursal, @usuario, @accion, @modulo, @id, @mov, @movid, @fechaemision, @fecharegistro, @almacen, @wmsmov, @ok output, @okref output
end
if @movtipo in ('inv.si', 'inv.dti') and @ok is null and @accion <> 'verificar'
begin
if @accion <> 'cancelar'
begin
exec @idgenerar = spmovcopiar @sucursal, @modulo, @id, @usuario, @fecharegistro, 1, @copiarartcostoinv = 1
if @idgenerar is not null
begin
if @movtipo = 'inv.dti'
begin
update inv with (rowlock) set almacen = @almacendestinooriginal, almacendestino = @almacen where id = @idgenerar
update invd with (rowlock) set almacen = @almacendestinooriginal where id = @idgenerar
end
update inv with (rowlock)
set referencia = rtrim(@mov)+ ' ' + rtrim(@movid),
sucursaldestino = (select a.sucursal from inv i with (nolock), alm a with (nolock) where i.id = @idgenerar and a.almacen = i.almacendestino),
mov = (select invtransito from empresacfgmov with (nolock) where empresa = @empresa),
origentipo = @modulo,
origen = @mov,
origenid = @movid
where id = @idgenerar
update serielotemov with (rowlock)
set sucursal = (select sucursal from alm with (nolock) where almacen = @almacendestinooriginal)
where empresa = @empresa and modulo = @modulo and id = @idgenerar
exec xpgenerartransito @empresa, @sucursal, @usuario, @modulo, @movtipo, @referencia, @id, @idgenerar
end
end else
select @idgenerar = @idtransito
if @ok in (null, 80030)
begin
select @ok = null, @okref = null
exec spinv @idgenerar, @modulo, @accion, 'todo', @fecharegistro, null, @usuario, 1, @sincrofinal, 'transito',
@mov, @movid, @idgenerar, @contid,
@ok output, @okref output
select @transitosucursal = sucursal, @transitomov = mov, @transitomovid = movid, @transitoestatus = estatus from inv with (nolock) where id = @idgenerar
if @ok in (null, 80030)
begin
exec spmovflujo @sucursal, @accion, @empresa, @modulo, @id, @mov, @movid, @modulo, @idgenerar, @transitomov, @transitomovid, @ok output
if @accion = 'cancelar' and @ok = 80030 select @ok = null, @okref = null
end else select @okref = @transitomov
end
if (select traspasoexpress from movtipo with (nolock) where modulo = @modulo and mov = @mov) = 1 and @ok in (null, 80030) and @accion <> 'cancelar' and @transitoestatus = 'pendiente'
begin
select @ok = null, @okref = null
select @idtransito = @idgenerar
exec @idgenerar = spmovcopiar @sucursal, @modulo, @idtransito, @usuario, @fecharegistro, 1, @copiarartcostoinv = 1
if @idgenerar is not null
begin
update inv with (rowlock)
set mov = (select invrecibotraspaso from empresacfgmov with (nolock) where empresa = @empresa),
origentipo = @modulo,
origen = @transitomov,
origenid = @transitomovid,
directo = 0
where id = @idgenerar
update invd with (rowlock)
set aplica = @transitomov,
aplicaid = @transitomovid
where id = @idgenerar
exec spinv @idgenerar, @modulo, @accion, 'todo', @fecharegistro, null, @usuario, 1, @sincrofinal, null,
@mov, @movid, @idgenerar, @contid,
@ok output, @okref output
select @traspasoexpressmov = mov, @traspasoexpressmovid = movid from inv with (nolock) where id = @idgenerar
if @ok in (null, 80030)
exec spmovflujo @sucursal, @accion, @empresa, @modulo, @idtransito, @transitomov, @transitomovid, @modulo, @idgenerar, @traspasoexpressmov, @traspasoexpressmovid, @ok output
else
select @okref = @traspasoexpressmov
end
end
end
if @movtipo in ('vtas.d', 'vtas.dcr') and @ok in (null, 80030)
begin
select @ok = null
if exists(select * from ventad with (nolock) where id = @id and isnull(nullif(rtrim(transferira), ''), almacen) <> almacen)
exec spinvtransferira @empresa, @sucursal, @usuario, @accion, @modulo, @id, @mov, @movid, @fechaemision, @fecharegistro, @ok output, @okref output
end
if @fea = 1
begin
select @movtipoconsecutivofea = nullif(rtrim(consecutivofea), '') from movtipo with (nolock) where modulo = @modulo and mov = @mov
if @movtipoconsecutivofea is not null
begin
if @accion = 'afectar' and @estatus in ('sinafectar', 'borrador', 'confirmar') and not exists(select * from ventafea with (nolock) where id = @id)
begin
exec spconsecutivo @movtipoconsecutivofea, @sucursal, @feaconsecutivo output, @referencia = @feareferencia output
exec spmovidenserieconsecutivo @feaconsecutivo, @feaserie output, @feafolio output
insert ventafea (
id, serie, folio, aprobacion, procesar, cancelada)
select @id, @feaserie, @feafolio, convert(int, @feareferencia), 1, 0
exec spprevalidarfea @id, 0, @ok output, @okref output
end else
if @accion = 'cancelar' and @estatus in ('pendiente', 'concluido')
begin
update ventafea with (rowlock) set procesar = 1, cancelada = 1 where id = @id
end
end
end
if @cfgventapuntosenvales = 1 and @accion in ('afectar', 'reservarparcial', 'cancelar') and @mov in (select mov from empresacfgpuntosenvalesmov with (nolock) where empresa = @empresa) and (@ok is null or @ok between 80030 and 81000)
exec spventapuntosenvales @empresa, @modulo, @id, @mov, @movid, @movtipo, @accion, @fechaemision, @usuario, @sucursal, @movmoneda, @movtipocambio, @ok output, @okref output
if @ok is null and @movtipo = 'coms.gx'
if exists(select * from comprad with (nolock) where id = @id and esestadistica = 1)
exec spinvgenerarestadistica @empresa, @sucursal, @modulo, @id, @mov, @movid, @accion, @clienteprov, @ok output, @okref output
if @movtipo = 'inv.a' and @origenmovtipo= 'inv.if'
exec spmovflujo @sucursal, @accion, @empresa, 'inv', @idorigen, @origen, @origenid, 'inv', @id, @mov, @movid, @ok output
if @ok is null or @ok between 80030 and 81000
exec spmovfinal @empresa, @sucursal, @modulo, @id, @estatus, @estatusnuevo, @usuario, @fechaemision, @fecharegistro, @mov, @movid, @movtipo, @idgenerar, @ok output, @okref output
if @ok is null or @ok between 80030 and 81000
exec xpinvafectar @id, @accion, @base, @empresa, @usuario, @modulo, @mov, @movid, @movtipo,
@movmoneda, @movtipocambio, @estatus, @estatusnuevo, @fechaemision, @fecharegistro, @fechaafectacion, @conexion, @sincrofinal, @sucursal,
null, null,
@ok output, @okref output
if @movtipo = 'vtas.s' and @generarop = 1 and @estatusnuevo in ('pendiente', 'cancelado') and @estatus <> @estatusnuevo
exec spautogenerarop @sucursal, @accion, @modulo, @id, @mov, @movid, @movtipo, @empresa, @usuario, @fecharegistro, @clienteprov, @servicioserie, @ok output, @okref output
if @accion = 'cancelar' and @estatusnuevo = 'cancelado' and @ok is null
begin
exec spcancelarflujo @empresa, @modulo, @id, @ok output
if @modulo = 'vtas' update ventaorigen with (rowlock) set origenid = 0 where id = @id
end
if @conexion = 0
begin
if @ok is null or @ok between 80030 and 81000
commit transaction
else begin
declare @polizadescuadrada table (cuenta varchar(20) null, subcuenta varchar(50) null, concepto varchar(50) null, debe money null, haber money null, sucursalcontable int null)
if exists(select * from polizadescuadrada with (nolock) where modulo = @modulo and id = @id)
insert @polizadescuadrada (cuenta, subcuenta, concepto, debe, haber, sucursalcontable) select cuenta, subcuenta, concepto, debe, haber, sucursalcontable from polizadescuadrada where modulo = @modulo and id = @id
rollback transaction
delete polizadescuadrada where modulo = @modulo and id = @id
insert polizadescuadrada (modulo, id, cuenta, subcuenta, concepto, debe, haber, sucursalcontable) select @modulo, @id, cuenta, subcuenta, concepto, debe, haber, sucursalcontable from @polizadescuadrada
end
end
if @ok = 80070 and @movtipo = 'inv.if' update inv with (rowlock) set estatus = 'concluido', fechaconclusion = getdate() where id = @id
return
end