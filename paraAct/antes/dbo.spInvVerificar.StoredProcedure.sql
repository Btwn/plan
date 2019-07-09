create procedure [dbo].[spinvverificar]
@id int,
@accionchar(20),
@basechar(20),
@empresa char(5),
@usuariochar(10),
@autorizacionchar(10) output,
@mensajeint,
@modulo char(5),
@mov char(20),
@movidvarchar(20),
@movtipo char(20),
@movmonedachar(10),
@movtipocambiofloat,
@fechaemisiondatetime,
@ejercicio int,
@periodo int,
@almacen char(10),
@almacentipochar(15),
@almacendestino char(10),
@almacendestinotipochar(15),
@voltearalmacenbit,
@almacenespecificochar(10),
@condicionvarchar(50),
@vencimientodatetime,
@clienteprovchar(10),
@enviaraint,
@descuentoglobalfloat,
@sobrepreciofloat,
@concreditobit,
@conlimitecreditobit,
@limitecreditomoney,
@conlimitepedidosbit,
@limitepedidosmoney,
@monedacreditochar(10),
@tipocambiocreditofloat,
@diascreditoint,
@condicionesvalidasvarchar(255),
@pedidosparcialesbit,
@vtasconsignacionbit,
@almacenvtasconsignacionchar(10),
@anticiposfacturadosmoney,
@estatuschar(15),
@estatusnuevochar(15),
@afectarmatandobit,
@afectarmatandoopcionalbit,
@afectarconsignacionbit,
@afectaralmacenrenglonbit,
@origentipovarchar(10),
@origenvarchar(20),
@origenidvarchar(20),
@origenmovtipovarchar(20),
@facturarvtasmostradorbit,
@estransferenciabit,
@serviciogarantiabit,
@servicioarticulochar(20),
@servicioseriechar(20),
@fecharequeridadatetime,
@autocorridachar(8),
@cfgcosteonivelsubcuentabit,
@cfgdecimalescantidadesint,
@cfgserieslotesmayoreobit,
@cfgserieslotesautoordenchar(20),
@cfgvalidarprecioschar(20),
@cfgpreciominimosucursalbit,
@cfgvalidarmargenminimochar(20),
@cfgventasurtirdemasbit,
@cfgcomprarecibirdemasbit,
@cfgcomprarecibirdemastolerancia float,
@cfgtransferirdemasbit,
@cfgventachecarcreditochar(20),
@cfgventapedidosdisminuyencredito bit,
@cfgventabloquearmorososchar(20),
@cfgventaliquidaintegralbit,
@cfgfacturacobrointegradobit,
@cfginvprestamosgarantiasbit,
@cfginventradassincostobit,
@cfgserviciosrequieretareas bit,
@cfgserviciosvalidaridbit,
@cfgimpincbit,
@cfglimiterenfacturasint,
@cfgnotasborradorbit,
@cfganticiposfacturadosbit,
@cfgmultiunidadesbit,
@cfgmultiunidadesnivelchar(20),
@cfgcomprafactordinamico bit,
@cfginvfactordinamico bit,
@cfgprodfactordinamico bit,
@cfgventafactordinamico bit,
@cfgtoleranciacostomoney,
@cfgtoleranciatipocostochar(20),
@cfgformaparequeridabit,
@cfgbloquearnotasnegativasbit,
@cfgbloquearfacturaciondirecta bit,
@seguimientomatrizbit,
@cobrointegradobit,
@cobrointegradocxcbit,
@cobrointegradoparcial bit,
@cobrarpedidobit,
@cfgcompravalidarartprovbit,
@cfgvalidarccbit,
@cfgventarestringidabit,
@cfglimitecreditonivelgrupo bit,
@cfglimitecreditoniveluen bit,
@cfgrestringirartbloqueados bit,
@cfgvalidarfecharequeridabit,
@facturacionrapidaagrupadabit,
@utilizarbit,
@utilizaridint,
@utilizarmovtipochar(20),
@generarbit,
@generarmov char(20),
@generarafectadobit,
@conexionbit,
@sincrofinalbit,
@sucursalint,
@sucursaldestinoint,
@accionespecialvarchar(20),
@anexoidint,
@autorizarbitoutput,
@afectarconsecutivo bit output,
@ok int output,
@okref varchar(255) output,
@cfgpreciomonedabit = 0
as begin
declare
@enlineabit,
@renglon float,
@renglonsubint,
@renglonidint,
@renglontipochar(1),
@conteoint,
@autogeneradobit,
@afectaralmacen char(10),
@afectaralmacentipochar(20),
@articulo char(20),
@articulodestino char(20),
@subcuentadestino varchar(20),
@arttipo char(20),
@artserieloteinfobit,
@arttipoopcionchar(20),
@arttipocompravarchar(20),
@artseproducebit,
@artsecomprabit,
@artesformulabit,
@artunidad varchar(50),
@artmargenminimoborrarbit,
@artmargenminimomoney,
@artmonedaventachar(10),
@artfactorventafloat,
@arttipocambioventafloat,
@artpreciominimomoney,
@artmonedacostochar(10),
@artfactorcostofloat,
@arttipocambiocostofloat,
@artcaducidadminimaint,
@fechacaducidaddatetime,
@subcuenta varchar(50),
@sustitutoarticulo varchar(20),
@sustitutosubcuenta varchar(50),
@cantidad float,
@cantidadobsequio float,
@cantidadsugerida float,
@cantidadcalcularimportefloat,
@movunidadvarchar(50),
@factorfloat,
@cantidadoriginalfloat,
@cantidadinventariofloat,
@cantidadpendiente float,
@cantidadreservadafloat,
@cantidadordenadafloat,
@cantidada float,
@cantidadseriesint,
@idaplicaint,
@aplicamov char(20),
@aplicamovidvarchar(20),
@aplicaordenadofloat,
@aplicapendientefloat,
@aplicareservadafloat,
@aplicaclienteprovchar(10),
@aplicacondicionvarchar(50),
@aplicamovtipochar(20),
@aplicacontrolanticiposchar(20),
@aplicaautorizacionchar(10),
@almacenrenglonchar(10),
@articulomatarchar(20),
@subcuentamatarvarchar(50),
@costo money,
@artcostomoney,
@saldomoney,
@ventaspendientesmoney,
@remisionesaplicadasmoney,
@pedidospendientesmoney,
@disponible float,
@esentrada bit,
@essalidabit,
@afectarpiezas bit,
@afectarcostos bit,
@afectarunidades bit,
@afectaral bit,
@precio float,
@preciounitarionetomoney,
@preciotipocambiofloat,
@descuentotipo char(1),
@descuentolinea money,
@impuesto1 float,
@impuesto2 float,
@impuesto3 money,
@importe money,
@importeneto money,
@impuestos money,
@impuestosnetos money,
@importetotalmoney,
@valescobradosmoney,
@tarjetascobradasmoney,
@importe1money,
@importe2money,
@importe3money,
@importe4money,
@importe5money,
@formacobro1varchar(50),
@formacobro2varchar(50),
@formacobro3varchar(50),
@formacobro4varchar(50),
@formacobro5varchar(50),
@formacobrovalesvarchar(50),
@formacobrotarjetasvarchar(50),
@cobrodesglosadomoney,
@cobrocambiomoney,
@cobroredondeomoney,
@cobrodelefectivomoney,
@efectivomoney,
@descuentolineaimportemoney,
@descuentoglobalimportemoney,
@sobreprecioimportemoney,
@sumacantidadoriginalfloat,
@sumacantidadpendientefloat,
@importetotalsinautorizarmoney,
@sumaimportenetomoney,
@sumaimpuestosnetosmoney,
@utilizarestatuschar(15),
@servicioarticulotipochar(20),
@diasvencimientoint,
@maxdiasmoratoriosint,
@diastoleranciaint,
@checarcreditobit,
@serielotechar(50),
@estatuscuentachar(15),
@descripcionvarchar(100),
@tareaomisionvarchar(50),
@tareaomisionestadovarchar(30),
@detalletipovarchar(20),
@novalidardisponiblebit,
@validardisponiblebit,
@validarcobrointegradobit,
@cantsaldomoney,
@minimomoney,
@maximomoney,
@almacentempchar(10),
@almacenoriginalchar(10),
@almacendestinooriginalchar(10),
@cfgcontrolalmacenesbit,
@cfglimitarcompralocalbit,
@prodserielotevarchar(50),
@prodrutavarchar(20),
@prodordenint,
@prodordendestinoint,
@prodordenfinalint,
@prodordensiguienteint,
@prodcentrochar(10),
@prodcentrodestinochar(10),
@prodcentrosiguientechar(10),
@prodestacionchar(10),
@prodestaciondestinochar(10),
@difcreditomoney,
@importeautorizarmoney,
@almacensucursalint,
@almacendestinosucursalint,
@cfgventacobroredondeodecimalesint,
@cfgventalimiterenfacturasvmosbit,
@cfgautoautorizacionfacturas bit,
@sumaimportenetosinautorizar money,
@sumaimpuestosnetossinautorizar money,
@cantidadminimaventa float,
@cantidadmaximaventa float,
@cfgventadevsinantecedente bit,
@cfgventadevseriessinantecedentebit,
@cfgcompracaducidadbit,
@contusovarchar(20),
@flotante float,
@identificadorvarchar(20),
@empresagrupovarchar(50),
@artactividadesbit,
@redondeomonetariosint,
@validarfecharequeridabit,
@fecharequeridaddatetime,
@excendetedemasfloat,
@serieslotesautoordenchar(20),
@ultimocostomoney,
@costopromediomoney,
@costoestandarmoney,
@costoreposicionmoney,
@ventauenint,
@cateriaactivofijovarchar(50),
@paqueteint,
@pptobit,
@pptoventasbit,
@feabit,
@esactivof bit,
@esestadisticabit
select @esactivof = 0
select @redondeomonetarios = dbo.fnredondeomonetarios()
select @checarcredito = 0,
@novalidardisponible = 0,
@cfgcontrolalmacenes = 0,
@serielote = null,
@prodserielote = null,
@prodorden = null,
@prodordendestino = null,
@prodcentro = null,
@prodcentrodestino = null,
@prodruta = null,
@descripcion = null,
@idaplica = null,
@aplicaautorizacion = null,
@almacenoriginal = @almacen,
@almacendestinooriginal = @almacendestino,
@autorizar = 0,
@validarfecharequerida = 0,
@ventauen = null,
@ppto = 0
if @cfglimitecreditonivelgrupo = 1
select @empresagrupo = nullif(rtrim(grupo), '') from empresa with (nolock) where empresa = @empresa
if @cfglimitecreditoniveluen = 1 and @modulo = 'vtas'
begin
select @ventauen = uen from venta with (nolock) where id = @id
select @limitecredito = creditolimite from cteuen with (nolock) where cliente = @clienteprov and uen = @ventauen
end
select @ppto = ppto,
@pptoventas = pptoventas,
@fea = fea
from empresagral with (nolock)
where empresa = @empresa
select @cfgventacobroredondeodecimales = ventacobroredondeodecimales,
@cfgventalimiterenfacturasvmos = isnull(ventalimiterenfacturasvmos, 0),
@formacobrovales = cxcformacobrovales,
@formacobrotarjetas = cxcformacobrotarjetas
from empresacfg with (nolock)
where empresa = @empresa
select @cfgautoautorizacionfacturas = autoautorizacionfacturas,
@cfgventadevsinantecedente = ventadevsinantecedente,
@cfgventadevseriessinantecedente = ventadevseriessinantecedente,
@cfgcompracaducidad = isnull(compracaducidad, 0)
from empresacfg2 with (nolock)
where empresa = @empresa
select @cfgcontrolalmacenes = isnull(controlalmacenes, 0),
@cfglimitarcompralocal = isnull(limitarcompralocal, 0)
from usuariocfg2 with (nolock)
where usuario = @usuario
if nullif(rtrim(@almacen), '') is null and @modulo in ('vtas', 'coms', 'inv') and @accion not in ('cancelar', 'generar')
select @ok = 20390
if nullif(rtrim(@almacendestino), '') is null and @movtipo = 'inv.dti' and @accion not in ('cancelar', 'generar')
select @ok = 20390
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @cobrointegrado = 0 and ((@movtipo in ('vtas.c', 'vtas.cs')) or (@movtipo in ('vtas.p','vtas.s') and @estatusnuevo = 'pendiente') or (@movtipo in ('vtas.f','vtas.far','vtas.fc', 'vtas.fg', 'vtas.fb','vtas.r') and @utilizar = 0))
select @checarcredito = 1
if @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm') and @cfgnotasborrador = 1 and (@estatus in ('sinafectar', 'borrador', 'confirmar') or @accion = 'cancelar')
select @novalidardisponible = 1
if @accion in ('reservar', 'desreservar', 'reservarparcial', 'asignar', 'desasignar') and @movtipo not in ('vtas.p', 'vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx', 'vtas.s', 'inv.sol', 'inv.sm', 'inv.ot', 'inv.oi')
select @ok = 60040
if @modulo = 'coms' and @movtipo in ('coms.o', 'coms.op', 'coms.f', 'coms.fl', 'coms.eg', 'coms.ei', 'coms.cc', 'coms.og', 'coms.od', 'coms.oi', 'coms.ig') and @accion not in ('cancelar', 'generar') and @ok is null
begin
select @estatuscuenta = estatus from prov with (nolock) where proveedor = @clienteprov
if @estatuscuenta = 'bloqueado'
begin
select @ok = 65032, @okref = @clienteprov
exec xpok_65032 @empresa, @usuario, @accion, @modulo, @id, @ok output, @okref output
end
end
if @modulo in ('vtas', 'coms') and @movtipo <> 'coms.r' and nullif(rtrim(@clienteprov), '') is null and @accion not in ('cancelar', 'generar')
begin
if @modulo = 'vtas' select @ok = 40010 else
if @modulo = 'coms' select @ok = 40020
end
if @cfgvalidarfecharequerida = 1
begin
if (@modulo = 'vtas' and @movtipo in ('vtas.c','vtas.cs','vtas.p','vtas.vp','vtas.s','vtas.pr','vtas.est','vtas.f','vtas.far','vtas.fc','vtas.dfc','vtas.fb','vtas.r','vtas.sg','vtas.eg','vtas.vc','vtas.vcr','vtas.sd')) or
(@modulo = 'coms' and @movtipo not in ('coms.d', 'coms.dg', 'coms.b', 'coms.dc'))
select @validarfecharequerida = 1
end
if @validarfecharequerida = 1
if @fecharequerida is null select @ok = 25120 else
if @fecharequerida < @fechaemision select @ok = 25121
if @modulo = 'vtas' and @movtipo not in ('vtas.pr', 'vtas.est', 'vtas.sd', 'vtas.d', 'vtas.df', 'vtas.dfc', 'vtas.b', 'vtas.dr', 'vtas.dc', 'vtas.dcr', 'vtas.vp') and @accion not in ('cancelar', 'desreservar', 'generar') and (@autorizacion is null or @mensaje not in (65010, 65020, 65040, 20310, 65030, 65035)) and @ok is null
begin
select @estatuscuenta = estatus from cte with (nolock) where cliente = @clienteprov
if @estatuscuenta <> 'bloqueado'
select @estatuscuenta = estatus, @descripcion = descripcion from bloqueo with (nolock) where bloqueo = @estatuscuenta
if @estatuscuenta = 'bloqueado'
select @ok = 65030, @okref = @descripcion
if isnull(@enviara, 0) > 0 and @ok is null
begin
select @estatuscuenta = estatus from cteenviara with (nolock) where cliente = @clienteprov and id = @enviara
if @estatuscuenta <> 'bloqueado'
select @estatuscuenta = estatus, @descripcion = descripcion from bloqueo with (nolock) where bloqueo = @estatuscuenta
if @estatuscuenta = 'bloqueado'
select @ok = 65035, @okref = @descripcion
end
if @ok is not null select @autorizar = 1
end
if @anticiposfacturados <> 0.0 and @ok is null and @estatus = 'sinafectar'
begin
if @movtipo in ('vtas.f','vtas.far', 'vtas.fb') and @cfganticiposfacturados = 1
begin
if @anticiposfacturados < 0.0 select @ok = 30100 else
if @accion <> 'cancelar'
begin
select @cantsaldo = 0.0
select @cantsaldo = round(isnull(sum(anticiposaldo * (case when cxc.clientemoneda <> @movmoneda then cxc.clientetipocambio / @movtipocambio else 1.0 end)), 0.0), 2) from cxc with (nolock) where empresa = @empresa and anticipoaplicamodulo = @modulo and anticipoaplicaid = @id
if round(@anticiposfacturados, 2) > @cantsaldo select @ok = 30400
end
end else select @ok = 70070
if @ok is not null select @okref = 'anticipos facturados'
end
if @movtipo = 'inv.tc' select @ok = 60120
if @accion <> 'cancelar' and @ok is null
begin
if @movtipo in ('vtas.c', 'vtas.cs', 'vtas.p', 'vtas.s', 'vtas.f','vtas.far', 'vtas.fb', 'coms.c', 'coms.o', 'coms.op', 'coms.f', 'coms.fl', 'coms.eg', 'coms.ei', 'inv.p')
exec spverificarvencimiento @condicion, @vencimiento, @fechaemision, @ok output
if @modulo = 'vtas' and @estatus in ('sinafectar', 'borrador', 'confirmar') and (@base in ('seleccion', 'reservado')) and @pedidosparciales = 0
if (@utilizar = 1 and @utilizarmovtipo ='vtas.p') or (@generar = 1 and @movtipo = 'vtas.p')
select @ok = 20300
if @movtipo in ('vtas.vc', 'vtas.dc')
if @vtasconsignacion = 0 or @almacenvtasconsignacion = null select @ok = 20270
end
if @movtipo in ('inv.oi', 'inv.ti', 'inv.si', 'inv.ei') and @accion <> 'generar'
begin
if @almacendestino = @almacen or @almacendestino is null select @ok = 20120
end
if @estatus = 'pendiente' and @accion = 'cancelar' and @base in ('seleccion','pendiente') and @movtipo not in ('vtas.p', 'vtas.s', 'coms.r', 'coms.o', 'coms.op', 'coms.og', 'coms.od', 'coms.oi', 'inv.sol', 'inv.ot', 'inv.oi', 'inv.ti', 'inv.sm', 'prod.o', 'vtas.vcr') select @ok = 60240
if @movtipo in ('vtas.s', 'vtas.sg', 'vtas.eg') and @ok is null
begin
select @servicioarticulotipo = null
select @servicioarticulotipo = upper(tipo) from art with (nolock) where articulo = @servicioarticulo
if @servicioarticulotipo is null select @ok = 20450 else
if @servicioarticulotipo in ('serie','lote','vin','partida') and @servicioserie is null select @ok = 20460
end
if @movtipo in ('vtas.n', 'vtas.no', 'vtas.nr') and @accion = 'cancelar'
if exists(select * from venta with (nolock) where id = (select id from ventaorigen with (nolock) where origenid = @id) and estatus = 'borrador')
select @ok = 30370
if @accion not in ('generar', 'cancelar') and @ok is null
exec spvalidarmovimportemaximo @usuario, @modulo, @mov, @id, @ok output, @okref output
if @fea = 1
if (select nullif(rtrim(consecutivofea), '') from movtipo with (nolock) where modulo = @modulo and mov = @mov) is not null
exec spprevalidarfea @id, 1, @ok output, @okref output
if @ok is null
exec xpinvverificar @id, @accion, @base, @empresa, @usuario, @modulo,
@mov, @movid, @movtipo, @movmoneda, @movtipocambio, @estatus, @estatusnuevo,
@fechaemision,
@ok output, @okref output
if @ok is not null return
if @modulo = 'vtas'
declare crverificardetalle cursor
for select 0, d.renglon, d.renglonsub, d.renglonid, d.renglontipo, (isnull(d.cantidad, 0.0)-isnull(d.cantidadcancelada, 0.0)), d.cantidadobsequio, d.cantidadinventario, isnull(d.cantidadreservada, 0.0), isnull(d.cantidadordenada, 0.0), isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), nullif(rtrim(d.unidad), ''), isnull(d.factor, 0.0), nullif(rtrim(d.articulo), ''), nullif(rtrim(d.subcuenta), ''), convert(varchar(20), null), convert(varchar(20), null), nullif(rtrim(d.sustitutoarticulo), ''), nullif(rtrim(d.sustitutosubcuenta), ''), isnull(d.costo, 0.0), isnull(d.precio, 0.0), nullif(rtrim(d.descuentotipo), ''), isnull(d.descuentolinea, 0.0), isnull(d.impuesto1, 0.0), isnull(d.impuesto2, 0.0), isnull(d.impuesto3, 0.0), nullif(rtrim(d.aplica), ''), d.aplicaid, nullif(rtrim(d.almacen), ''), rtrim(upper(a.tipo)), a.serieloteinfo, isnull(nullif(rtrim(upper(a.tipoopcion)), ''), 'no'), rtrim(upper(a.tipocompra)), a.seproduce, a.secompra, a.esformula, nullif(rtrim(a.unidad), ''), isnull(a.preciominimo, 0.0), nullif(rtrim(a.monedaprecio), ''), isnull(a.margenminimo, 0.0), nullif(rtrim(a.monedacosto), ''), convert(char, null), convert(char, null), convert(int, null), convert(int, null), convert(char, null), convert(char, null), convert(char, null), nullif(a.cantidadminimaventa, 0), nullif(a.cantidadmaximaventa, 0), convert(int, null), convert(datetime, null), a.actividades, d.fecharequerida, d.paquete, 0, d.preciotipocambio
from ventad d with (nolock), art a with (nolock)
where d.id = @id
and d.articulo = a.articulo
else
if @modulo = 'coms'
declare crverificardetalle cursor
for select 0, d.renglon, d.renglonsub, d.renglonid, d.renglontipo, (isnull(d.cantidad, 0.0)-isnull(d.cantidadcancelada, 0.0)), convert(float, null), d.cantidadinventario, d.cantidad, d.cantidad, isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), nullif(rtrim(d.unidad), ''), d.factor, nullif(rtrim(d.articulo), ''), nullif(rtrim(d.subcuenta), ''), convert(varchar(20), null), convert(varchar(20), null), convert(char(20), null), convert(char(20), null), isnull(d.costo, 0.0), isnull(d.costo, 0.0), nullif(rtrim(d.descuentotipo), ''), isnull(d.descuentolinea, 0.0), isnull(d.impuesto1, 0.0), isnull(d.impuesto2, 0.0), isnull(d.impuesto3, 0.0), nullif(rtrim(d.aplica), ''), d.aplicaid, nullif(rtrim(d.almacen), ''), nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, isnull(nullif(rtrim(upper(a.tipoopcion)), ''), 'no'), rtrim(upper(a.tipocompra)), a.seproduce, a.secompra, a.esformula, nullif(rtrim(a.unidad), ''), isnull(a.preciominimo, 0.0), nullif(rtrim(a.monedaprecio), ''), isnull(a.margenminimo, 0.0), nullif(rtrim(a.monedacosto), ''), convert(char, null), convert(char, null), convert(int, null), convert(int, null), convert(char, null), convert(char, null), convert(char, null), convert(float, null), convert(float, null), case when a.tienecaducidad=1 then nullif(a.caducidadminima, 0) else convert(int, null) end, d.fechacaducidad, a.actividades, d.fecharequerida, d.paquete, d.esestadistica, convert(float, null)
from comprad d with (nolock), art a with (nolock)
where d.id = @id
and d.articulo = a.articulo
else
if @modulo = 'inv'
declare crverificardetalle cursor
for select 0, d.renglon, d.renglonsub, d.renglonid, d.renglontipo, (isnull(d.cantidad, 0.0)-isnull(d.cantidadcancelada, 0.0)), convert(float, null), d.cantidadinventario, isnull(d.cantidadreservada, 0.0), isnull(d.cantidadordenada, 0.0), isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), nullif(rtrim(d.unidad), ''), d.factor, nullif(rtrim(d.articulo), ''), nullif(rtrim(d.subcuenta), ''), nullif(rtrim(d.articulodestino), ''), nullif(rtrim(d.subcuentadestino), ''), convert(char(20), null), convert(char(20), null), isnull(d.costo, 0.0), convert(money, null), '$', convert(money, null), convert(float, null), convert(float, null), convert(money, null), nullif(rtrim(d.aplica), ''), d.aplicaid, nullif(rtrim(d.almacen), ''), nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, isnull(nullif(rtrim(upper(a.tipoopcion)), ''), 'no'), rtrim(upper(a.tipocompra)), a.seproduce, a.secompra, a.esformula, nullif(rtrim(a.unidad), ''), isnull(a.preciominimo, 0.0), nullif(rtrim(a.monedaprecio), ''), isnull(a.margenminimo, 0.0), nullif(rtrim(a.monedacosto), ''), nullif(rtrim(d.prodserielote), ''), convert(char, null), convert(int, null), convert(int, null), convert(char, null), convert(char, null), d.tipo, convert(float, null), convert(float, null), convert(int, null), convert(datetime, null), a.actividades, convert(datetime, null), d.paquete, 0, convert(float, null)
from invd d with (nolock), art a with (nolock)
where d.id = @id
and d.articulo = a.articulo
else
if @modulo = 'prod'
declare crverificardetalle cursor
for select d.autogenerado, d.renglon, d.renglonsub, d.renglonid, d.renglontipo, (isnull(d.cantidad, 0.0)-isnull(d.cantidadcancelada, 0.0)), convert(float, null), d.cantidadinventario, isnull(d.cantidadreservada, 0.0), isnull(d.cantidadordenada, 0.0), isnull(d.cantidadpendiente, 0.0), isnull(d.cantidada, 0.0), nullif(rtrim(d.unidad), ''), d.factor, nullif(rtrim(d.articulo), ''), nullif(rtrim(d.subcuenta), ''), convert(varchar(20), null), convert(varchar(20), null), convert(char(20), null), convert(char(20), null), isnull(d.costo, 0.0), convert(money, null), '$', convert(money, null), convert(float, null), convert(float, null), convert(money, null), nullif(rtrim(d.aplica), ''), d.aplicaid, nullif(rtrim(d.almacen), ''), nullif(rtrim(upper(a.tipo)), ''), a.serieloteinfo, isnull(nullif(rtrim(upper(a.tipoopcion)), ''), 'no'), rtrim(upper(a.tipocompra)), a.seproduce, a.secompra, a.esformula, nullif(rtrim(a.unidad), ''), isnull(a.preciominimo, 0.0), nullif(rtrim(a.monedaprecio), ''), isnull(a.margenminimo, 0.0), nullif(rtrim(a.monedacosto), ''), nullif(rtrim(d.prodserielote), ''), nullif(rtrim(d.ruta), ''), d.orden, d.ordendestino, nullif(rtrim(d.centro), ''), nullif(rtrim(d.centrodestino), ''), d.tipo, convert(float, null), convert(float, null), convert(int, null), convert(datetime, null), a.actividades, convert(datetime, null), d.paquete, 0, convert(float, null)
from prodd d with (nolock), art a with (nolock)
where d.id = @id
and d.articulo = a.articulo
select @afectaral = 0,
@sumacantidadoriginal = 0,
@sumacantidadpendiente = 0,
@sumaimporteneto = 0.0,
@sumaimpuestosnetos = 0.0,
@sumaimportenetosinautorizar = 0.0,
@sumaimpuestosnetossinautorizar = 0.0
if @ok is null
begin
open crverificardetalle
fetch next from crverificardetalle into @autogenerado, @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadobsequio, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @movunidad, @factor, @articulo, @subcuenta, @articulodestino, @subcuentadestino, @sustitutoarticulo, @sustitutosubcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @arttipo, @artserieloteinfo, @arttipoopcion, @arttipocompra, @artseproduce, @artsecompra, @artesformula, @artunidad, @artpreciominimo, @artmonedaventa, @artmargenminimo, @artmonedacosto, @prodserielote, @prodruta, @prodorden, @prodordendestino, @prodcentro, @prodcentrodestino, @detalletipo, @cantidadminimaventa, @cantidadmaximaventa, @artcaducidadminima, @fechacaducidad, @artactividades, @fecharequeridad, @paquete, @esestadistica, @preciotipocambio
if @@error <> 0 select @ok = 1
while @@fetch_status <> -1 and @ok is null
begin
select @serieslotesautoorden = isnull(nullif(nullif(rtrim(upper(serieslotesautoorden)), ''), '(empresa)'), @cfgserieslotesautoorden)
from art with (nolock)
where articulo = @articulo
if @ppto = 1 and @accion <> 'cancelar' and (@modulo = 'coms' or (@modulo = 'vtas' and @pptoventas = 1))
if (select nullif(rtrim(cuentapresupuesto), '') from art with (nolock) where articulo = @articulo) is null
begin
select @ok = 40035, @okref = @articulo
exec xpok_40035 @empresa, @usuario, @accion, @modulo, @id, @ok output, @okref output
end
select @importe = 0.0,
@importeneto = 0.0,
@impuestos = 0.0,
@impuestosnetos = 0.0,
@descuentolineaimporte = 0.0,
@descuentoglobalimporte = 0.0,
@sobreprecioimporte = 0.0,
@idaplica = null,
@aplicaautorizacion = null,
@aplicacondicion = null,
@aplicamovtipo = null,
@aplicacontrolanticipos = null
if @validarfecharequerida = 1
if @fecharequeridad is null select @ok = 25120 else
if @fecharequeridad < @fechaemision select @ok = 25121
if @cfgcompravalidarartprov = 1 and @modulo = 'coms' and @movtipo not in ('coms.r')
if not exists(select * from artprov with (nolock) where articulo = @articulo and isnull(nullif(rtrim(subcuenta), ''), '') = isnull(nullif(rtrim(@subcuenta), ''), '') and proveedor = @clienteprov)
select @ok = 26040, @okref = rtrim(@articulo)+' '+rtrim(@subcuenta)
if @movtipo = 'inv.ep'
begin
exec spmovgastoindirectosugerir @empresa, @modulo, @id
if @artseproduce = 0 or @arttipo not in ('serie', 'vin', 'lote', 'partida') select @ok = 20076, @okref = @articulo
end
if @arttipoopcion in ('no', null) and @subcuenta is not null select @ok = 20740, @okref = @articulo
exec xpok_20740 @empresa, @usuario, @accion, @modulo, @id, @ok output, @okref output
if @aplicamov is not null and @aplicamovid is not null
begin
if @modulo = 'vtas' select @idaplica = id, @aplicaautorizacion = nullif(rtrim(autorizacion), ''), @aplicacondicion = condicion from venta with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado') else
if @modulo = 'coms' select @idaplica = id, @aplicaautorizacion = nullif(rtrim(autorizacion), '') from compra with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado') else
if @modulo = 'inv' select @idaplica = id, @aplicaautorizacion = nullif(rtrim(autorizacion), '') from inv with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado') else
if @modulo = 'prod' select @idaplica = id, @aplicaautorizacion = nullif(rtrim(autorizacion), '') from prod with (nolock) where empresa = @empresa and mov = @aplicamov and movid = @aplicamovid and estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado')
exec spaplicaok @empresa, @usuario, @modulo, @idaplica, @ok output, @okref output
if @aplicaautorizacion is not null and @autorizacion is null and @cfgautoautorizacionfacturas = 1 select @autorizacion = @aplicaautorizacion
end else
begin
if @movtipo = 'inv.dti' and @accion <> 'generar' select @ok = 25410
end
if @aplicamov <> null
begin
select @aplicamovtipo = null
select @aplicamovtipo = min(clave) from movtipo with (nolock) where modulo = @modulo and mov = @aplicamov
if @modulo = 'vtas' and @aplicamovtipo is null select @aplicamovtipo = min(clave) from movtipo with (nolock) where modulo = 'cxc' and mov = @aplicamov else
if @modulo = 'coms' and @aplicamovtipo is null select @aplicamovtipo = min(clave) from movtipo with (nolock) where modulo = 'cxp' and mov = @aplicamov
if @aplicamovtipo in ('vtas.p', 'vtas.s', 'vtas.sd')
select @aplicacontrolanticipos = isnull(nullif(rtrim(upper(controlanticipos)), ''), 'no') from condicion where condicion = @aplicacondicion
end
if @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fb') and @cfgbloquearfacturaciondirecta = 1 and @aplicamovtipo is null and @accion not in ('generar', 'cancelar')
select @ok = 25415
if @accion <> 'generar'
begin
if @modulo = 'vtas' and @accion <> 'cancelar' and @movtipo not in ('vtas.pr', 'vtas.d', 'vtas.df', 'vtas.dfc', 'vtas.b', 'vtas.co', 'vtas.vp')
begin
if @cantidadminimaventa is not null and @cantidadoriginal < @cantidadminimaventa select @ok = 20011, @okref = @articulo else
if @cantidadmaximaventa is not null and @cantidadoriginal > @cantidadmaximaventa select @ok = 20013, @okref = @articulo
end
if @cobrarpedido = 1
begin
if @movtipo in ('vtas.c', 'vtas.cs', 'vtas.p', 'vtas.p', 'vtas.sd', 'vtas.b')
begin
if @aplicamovtipo is not null and @aplicacontrolanticipos = 'cobrar pedido'
select @ok = 20880
end else
if @movtipo in ('vtas.f','vtas.far', 'vtas.fb', 'vtas.vp', 'vtas.d', 'vtas.df', 'vtas.dfc', 'vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm')
begin
if @aplicamovtipo not in ('vtas.p', 'vtas.s', 'vtas.sd') or @aplicacontrolanticipos <> 'cobrar pedido'
select @ok = 20880
end else select @ok = 20880
end else
if @aplicacontrolanticipos = 'cobrar pedido' select @ok = 20880
if @ok = 20880
exec xpok_20880 @empresa, @usuario, @accion, @modulo, @id, @ok output, @okref output
end
if @modulo = 'prod' and @movtipo <> 'prod.o' and @accion not in ('cancelar', 'generar') and @prodserielote is not null
begin
select @aplicamovtipo = 'prod.o', @aplicamov = mov, @aplicamovid = movid, @prodruta = ruta
from prodserielotependiente with (nolock)
where empresa = @empresa and prodserielote = @prodserielote and articulo = @articulo and subcuenta = @subcuenta
update prodd with (rowlock)
set aplica = @aplicamov,
aplicaid = @aplicamovid,
ruta = @prodruta
where current of crverificardetalle
end
if @autogenerado = 1 and @accion = 'afectar' select @ok = 60270
if @utilizar = 1 and @base <> 'todo' select @utilizarestatus = 'pendiente' else select @utilizarestatus = @estatus
if @artesformula = 1 select @ok = 20750
if @modulo = 'coms' and @cfglimitarcompralocal = 1 and (@artsecompra = 0 or @arttipocompra <> 'local') select @ok = 20760
if @arttipoopcion = 'si' and @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion <> 'cancelar' and @ok is null
exec spopcionvalidar @articulo, @subcuenta, @accion, @ok output, @okref
select @almacen = @almacenoriginal, @almacendestino = @almacendestinooriginal
if @afectaralmacenrenglon = 1 select @almacen = nullif(rtrim(@almacenrenglon), '')
if @almacenespecifico is not null select @almacen = @almacenespecifico
if @voltearalmacen = 1 select @almacentemp = @almacen, @almacen = @almacendestino, @almacendestino = @almacentemp
if @estransferencia = 0 and @movtipo not in ('inv.ot', 'inv.ti') select @almacendestino = null
if @movtipo = 'inv.ei' select @almacendestino = @almacenoriginal
if @almacen is not null
begin
select @almacentipo = upper(tipo), @almacensucursal = sucursal from alm with (nolock) where almacen = @almacen
if @almacentipo = 'estructura' select @ok = 20680, @okref = @almacen
if @cfgcontrolalmacenes = 1 and @accion <> 'cancelar' and @movtipo not in ('inv.ti', 'inv.dti')
if not exists(select * from usuarioalm with (nolock) where usuario = @usuario and almacen = @almacen)
select @ok = 20660, @okref = @almacen
if @almacensucursal <> isnull(@sucursaldestino, @sucursal) and @accion <> 'sincro' and @movtipo not in ('inv.ti', 'inv.dti', 'inv.tif', 'inv.tis', 'vtas.pr', 'coms.pr', 'vtas.est', 'coms.est') and @seguimientomatriz = 0
begin
exec spsucursalenlinea @almacensucursal, @enlinea output
if @enlinea = 0
select @ok = 20780, @okref = @almacen
end
end
if @almacendestino is not null and @movtipo <> 'inv.ei'
begin
select @almacendestinotipo = upper(tipo), @almacendestinosucursal = sucursal from alm with (nolock) where almacen = @almacendestino
if @almacendestinotipo = 'estructura' select @ok = 20680, @okref = @almacendestino
if @cfgcontrolalmacenes = 1 and @accion <> 'cancelar' and @movtipo not in ('inv.ti', 'inv.dti')
if not exists(select * from usuarioalm with (nolock) where usuario = @usuario and almacen = @almacendestino)
select @ok = 20660, @okref = @almacendestino
if @almacendestinosucursal <> isnull(@sucursaldestino, @sucursal) and @accion not in ('sincro', 'cancelar', 'generar')
begin
select @ok = 20790, @okref = @almacendestino
end
end
if @accion in ('afectar', 'verificar') and @movtipo = 'inv.ei' and @almacen <> @almacendestinooriginal select @ok = 20120
if @accion in ('afectar', 'verificar') and @movtipo = 'inv.ei' and @aplicamovtipo <> 'inv.ti' select @ok = 25410
if @accion in ('afectar', 'verificar') and @movtipo in ('prod.a', 'prod.r', 'prod.e') and @aplicamovtipo <> 'prod.o' and upper(@detalletipo) not in ('merma', 'desperdicio') select @ok = 25280
if @accion = 'afectar' and @movtipo = 'vtas.vp' and @aplicamovtipo not in (null, 'vtas.p', 'vtas.s') select @ok = 20197
if @accion = 'afectar' and @movtipo in ('inv.tif', 'inv.tis') and @aplicamovtipo <> 'inv.ti' select @ok = 20180
if @estransferencia = 1 and @accion <> 'generar' and @ok is null
begin
if @almacendestino = @almacen or @almacendestino is null select @ok = 20120
else
if @almacentipo <> @almacendestinotipo and not (@almacentipo in ('normal','proceso') and @almacendestinotipo in ('normal','proceso'))
if (@almacentipo in ('normal','proceso','garantias') or @almacendestinotipo in ('normal','proceso','garantias'))
begin
if @cfginvprestamosgarantias = 0 or @movtipo not in ('inv.p', 'inv.r')
select @ok = 40130
end else select @ok = 40130
end
if @modulo = 'vtas' and @serviciogarantia = 1 and (@almacentipo <> 'garantias' or @movtipo not in ('vtas.s','vtas.sg','vtas.eg')) and @ok is null
select @ok = 20440
if @artactividades = 1 and @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx','vtas.fb') and @accion not in ('cancelar', 'generar') and @cantidadoriginal > 0.0
if exists(select * from ventadagente with (nolock) where id = @id and renglon = @renglon and renglonsub = @renglonsub and upper(estado) not in ('completada', 'cancelada', 'concluida'))
select @ok = 20496
exec spinvinitrenglon @empresa, @cfgdecimalescantidades, @cfgmultiunidades, @cfgmultiunidadesnivel, @cfgcomprafactordinamico, @cfginvfactordinamico, @cfgprodfactordinamico, @cfgventafactordinamico, @cfgbloquearnotasnegativas,
1, 0, @accion, @base, @modulo, @id, @renglon, @renglonsub, @utilizarestatus, @estatusnuevo, @movtipo, @facturarvtasmostrador, @estransferencia, @afectarconsignacion, 0, @almacentipo, @almacendestinotipo,
@articulo, @movunidad, @artunidad, @arttipo, @renglontipo,
@aplicamovtipo, @cantidadoriginal, @cantidadinventario, @cantidadpendiente, @cantidada, @detalletipo,
@cantidad output, @cantidadcalcularimporte output, @cantidadreservada output, @cantidadordenada output, @esentrada output, @essalida output, @subcuenta output,
@afectarpiezas output, @afectarcostos output, @afectarunidades output, @factor output,
@ok output, @okref output
if @aplicamovtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx','vtas.fb') select @ok = 20180 else
if @almacen is null and @accion <> 'generar' select @ok = 20390 else
if @articulo is null select @ok = 20400 else
if @cantidad = 0.0 and @base = 'todo' and @autocorrida is null and @movtipo <> 'inv.if' select @ok = 20015 else
if @cantidad < 0.0 and @arttipo <> 'servicio' and @facturarvtasmostrador = 0 and @accion <> 'cancelar' and @movtipo not in ('vtas.est', 'inv.est') select @ok = 20010 else
if @accion = 'cancelar' and @base = 'seleccion' and round(@cantidad, 4) > round(@cantidadpendiente + @cantidadreservada, 4) select @ok = 20010
if @cfgmultiunidades = 1 and @movunidad is null and @accion <> 'cancelar' select @ok = 20150 else
if @aplicamov is not null and @facturarvtasmostrador = 1 select @ok = 20102 else
if @accion in ('reservar','asignar') and @cantidad > @cantidadpendiente select @ok = 20160 else
if @accion = 'desreservar' and @cantidad > @cantidadreservada select @ok = 20165 else
if @accion = 'desasignar' and @cantidad > @cantidadordenada select @ok = 20167
if @facturarvtasmostrador = 1 and (@aplicamov is not null or @aplicamovid is not null) select @ok = 20180
if @arttipo = 'partida' and @arttipoopcion = 'matriz'
if not exists(select * from artrenglon with (nolock) where renglon = @subcuenta) select @ok = 20045
if ((@modulo = 'prod' or (@movtipo in ('inv.sm', 'inv.cm'))) and @accion not in ('cancelar', 'generar') and @origentipo <> 'inv/ep')
begin
if @movtipo in ('prod.o', 'prod.a', 'prod.r') and @prodruta is null select @ok = 25300
if @movtipo = 'prod.e'
begin
if @prodcentro is null select @ok = 25040
else begin
exec spprodultimocentro @empresa, @articulo, @subcuenta, @prodserielote, @prodruta, @prodordenfinal output
if @prodorden is null select @prodorden = @prodordenfinal
if @prodorden <> @prodordenfinal
select @ok = 25350, @okref = @prodcentro
end
end
if @movtipo in ('prod.a', 'prod.r')
begin
if @prodcentro is null or @prodorden is null select @ok = 25040 else
if (@prodcentrodestino is null) or (@prodcentro = @prodcentrodestino) select @ok = 25330
else
begin
exec spprodavancealcentro @empresa, @movtipo, @articulo, @subcuenta, @prodserielote, @prodruta, @prodorden, @prodordensiguiente output, @prodcentro, @prodcentrosiguiente output, @prodestacion, @prodestaciondestino output, @verificar = 1
if @prodcentrodestino <> @prodcentrosiguiente
select @ok = 25340, @okref = @prodcentrodestino
end
if @ok is null
if not exists(select * from prodserielotependiente with (nolock) where empresa = @empresa and prodserielote = @prodserielote and articulo = @articulo and subcuenta = @subcuenta and orden = @prodorden and centro = @prodcentro)
select @ok = 25350, @okref = @prodcentro
end
if @prodserielote is null
select @ok = 25230
if @movtipo = 'inv.cm' and not exists(select * from prodserielotependiente with (nolock) where empresa = @empresa and prodserielote = @prodserielote)
select @ok = 25250, @okref = @prodserielote
if @ok is null
begin
if @movtipo = 'prod.o'
begin
if exists(select * from prodserielotependiente with (nolock) where empresa = @empresa and prodserielote = @prodserielote and cantidadpendiente > 0.0 and id <> @id)
select @ok = 25245
end else
begin
if not exists (select * from prodserielote with (nolock) where empresa = @empresa and prodserielote = @prodserielote and cantidadordenada > 0.0)
select @ok = 25250
end
end
if @ok is not null and @okref is null select @okref = @prodserielote
end
if @movtipo = 'prod.o' and @accion = 'cancelar' and @ok is null
if round((select sum(isnull(car, 0.0) - isnull(abono, 0.0)) from prodserielotecosto with (nolock) where empresa = @empresa and prodserielote = @prodserielote), @redondeomonetarios) <> 0.0
select @ok = 25370, @okref = @prodserielote
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion not in ('cancelar', 'generar') and @origentipo <> 'vmos'
begin
if @renglontipo = 'j'
exec spinvvalidarjue @empresa, @modulo, @id, @almacen, @renglonid, @articulo, @cantidad, @ok output, @okref output
if @renglontipo in ('c', 'e')
begin
if @modulo = 'vtas' if not exists(select * from ventad with (nolock) where id = @id and renglonid = @renglonid and renglontipo = 'j') select @ok = 20620 else
if @modulo = 'coms' if not exists(select * from comprad with (nolock) where id = @id and renglonid = @renglonid and renglontipo = 'j') select @ok = 20620 else
if @modulo = 'inv' if not exists(select * from invd with (nolock) where id = @id and renglonid = @renglonid and renglontipo = 'j') select @ok = 20620 else
if @modulo = 'prod' if not exists(select * from prodd with (nolock) where id = @id and renglonid = @renglonid and renglontipo = 'j') select @ok = 20620
end
if @ok = 20620
exec xpok_20620 @empresa, @usuario, @accion, @modulo, @id, @renglon, @renglonsub, @ok output, @okref output
end
if @@fetch_status <> -2 and @cantidad <> 0.0 and @ok is null
begin
if @almacentipo = 'activos fijos'
begin
select @cateriaactivofijo = null
select @cateriaactivofijo = nullif(rtrim(cateriaactivofijo), '') from art with (nolock) where articulo = @articulo
if (@arttipo not in ('serie','vin','servicio') or @cfgserieslotesmayoreo = 0) select @ok = 44010 else
if @cateriaactivofijo is null and @arttipo <> 'servicio' select @ok = 44110 else
if @modulo in ('vtas', 'coms') and (select upper(propietario) from activofcat with (nolock) where cateria = @cateriaactivofijo) <> 'empresa' select @ok = 44180
end
if @modulo in ('vtas', 'coms')
begin
exec spcalculaimporte @accion, @modulo, @cfgimpinc, @movtipo, @esentrada, @cantidadcalcularimporte, @precio, @descuentotipo, @descuentolinea, @descuentoglobal, @sobreprecio, @impuesto1, @impuesto2, @impuesto3,
@importe output, @importeneto output, @descuentolineaimporte output, @descuentoglobalimporte output, @sobreprecioimporte output,
@impuestos output, @impuestosnetos output,
@articulo = @articulo, @cantidadobsequio = @cantidadobsequio, @cfgpreciomoneda = @cfgpreciomoneda, @movtipocambio = @movtipocambio, @preciotipocambio = @preciotipocambio
if @modulo = 'vtas' and round(isnull(@precio, 0.0), 0) < 0.0 and @autocorrida is null select @ok = 20305
if @modulo = 'coms' select @costo = @importeneto / @cantidad
if @@error <> 0 select @ok = 1
end
if @afectarcostos = 1 and @esentrada = 1 and @accion not in ('generar', 'cancelar') and @cfgtoleranciatipocosto in ('promedio', 'estandar', 'ultimo costo')
begin
select @artcosto = null
if @cfgcosteonivelsubcuenta = 1 and nullif(rtrim(@subcuenta), '') is not null
begin
if @cfgtoleranciatipocosto = 'ultimo costo' select @artcosto = ultimocosto from artsubcosto with (nolock) where sucursal = @sucursal and empresa = @empresa and articulo = @articulo and subcuenta = @subcuenta else
if @cfgtoleranciatipocosto = 'promedio' select @artcosto = costopromedio from artsubcosto with (nolock) where sucursal = @sucursal and empresa = @empresa and articulo = @articulo and subcuenta = @subcuenta else
if @cfgtoleranciatipocosto = 'estandar' select @artcosto = costoestandar from art with (nolock) where articulo = @articulo else
if @cfgtoleranciatipocosto = 'reposicion' select @artcosto = costoreposicion from art with (nolock) where articulo = @articulo
end else
begin
if @cfgtoleranciatipocosto = 'ultimo costo' select @artcosto = ultimocosto from artcosto with (nolock) where sucursal = @sucursal and empresa = @empresa and articulo = @articulo else
if @cfgtoleranciatipocosto = 'promedio' select @artcosto = costopromedio from artcosto with (nolock) where sucursal = @sucursal and empresa = @empresa and articulo = @articulo else
if @cfgtoleranciatipocosto = 'estandar' select @artcosto = costoestandar from art with (nolock) where articulo = @articulo else
if @cfgtoleranciatipocosto = 'reposicion' select @artcosto = costoreposicion from art with (nolock) where articulo = @articulo
end
if @artcosto is not null
begin
exec spmoneda null, @movmoneda, @movtipocambio, @artmonedacosto, @artfactorcosto output, @arttipocambiocosto output, @ok output
select @artcosto = @artcosto * @artfactorcosto
select @minimo = @artcosto * (1 - (@cfgtoleranciacosto/100)),
@maximo = @artcosto * (1 + (@cfgtoleranciacosto/100))
if @costo/@factor < @minimo
begin
select @ok = 20600
exec xpok_20600 @empresa, @usuario, @accion, @modulo, @id, @renglon, @renglonsub, @ok output, @okref output
end else
if @costo/@factor > @maximo
begin
select @ok = 20610
exec xpok_20610 @empresa, @usuario, @accion, @modulo, @id, @renglon, @renglonsub, @ok output, @okref output
end
end
end
if @cfgvalidarprecios <> 'no' and @facturarvtasmostrador = 0 and @movtipo in ('vtas.c', 'vtas.cs', 'vtas.p', 'vtas.s', 'vtas.r', 'vtas.f','vtas.far', 'vtas.fc', 'vtas.fb', 'vtas.vc','vtas.vcr', 'vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm') and @renglontipo not in ('c', 'e') and @almacentipo <> 'garantias' and @accion not in ('cancelar', 'generar') and (@autorizacion is null or @mensaje not in (65010, 65020, 65040, 20310)) and @ok is null
begin
if @cfgpreciominimosucursal = 1
select @artpreciominimo = isnull(preciominimo, @artpreciominimo) from artsucursal with (nolock) where articulo = @articulo and sucursal = @almacensucursal
select @preciounitarioneto = abs((@importeneto / @cantidad) / @factor), @artcosto = null
if @cfgvalidarprecios = 'precio minimo'
begin
exec spmoneda null, @movmoneda, @movtipocambio, @artmonedaventa, @artfactorventa output, @arttipocambioventa output, @ok output
if round(@preciounitarioneto, 2) < round(@artpreciominimo * @artfactorventa, @redondeomonetarios)
select @ok = 20310
end
if @cfgvalidarprecios in ('ultimo costo', 'costo promedio', 'costo estandar', 'costo reposicion') and @arttipo not in ('jue', 'servicio')
select @cfgvalidarmargenminimo = @cfgvalidarprecios,
@cfgvalidarprecios = 'margen minimo',
@artmargenminimoborrar = 1
if @artmargenminimoborrar = 1 select @artmargenminimo = 0.0
if @cfgvalidarprecios = 'margen minimo' and @cfgvalidarmargenminimo <> 'no'
begin
select @costoestandar = isnull(costoestandar, 0), @costoreposicion = isnull(costoreposicion, 0)
from art with (nolock)
where articulo = @articulo
if @cfgcosteonivelsubcuenta = 1 and nullif(rtrim(@subcuenta), '') is not null
select @ultimocosto = isnull(ultimocosto, 0), @costopromedio = isnull(costopromedio, 0)
from artsubcosto with (nolock)
where sucursal = @sucursal and empresa = @empresa and articulo = @articulo and subcuenta = @subcuenta
else
select @ultimocosto = isnull(ultimocosto, 0), @costopromedio = isnull(costopromedio, 0)
from artcosto with (nolock)
where sucursal = @sucursal and empresa = @empresa and articulo = @articulo
if @cfgvalidarmargenminimo = 'ultimo costo' select @artcosto = @ultimocosto else
if @cfgvalidarmargenminimo = 'costo promedio' select @artcosto = @costopromedio else
if @cfgvalidarmargenminimo = 'costo estandar' select @artcosto = @costoestandar else
if @cfgvalidarmargenminimo = 'costo reposicion' select @artcosto = @costoreposicion else
if @cfgvalidarmargenminimo = '(mayor costo)'
begin
select @artcosto = @ultimocosto
if @costopromedio > @artcosto select @artcosto = @costopromedio else
if @costoestandar > @artcosto select @artcosto = @costoestandar else
if @costoreposicion > @artcosto select @artcosto = @costoreposicion
end
if @artcosto is not null
begin
exec spmoneda null, @movmoneda, @movtipocambio, @artmonedacosto, @artfactorcosto output, @arttipocambiocosto output, @ok output
select @artcosto = @artcosto * @artfactorcosto
if round(@preciounitarioneto-(@preciounitarioneto * (@artmargenminimo/100)), @redondeomonetarios) < round(@artcosto, @redondeomonetarios)
select @ok = 20310
end
end
if @ok = 20310
if exists(select * from cte with (nolock) where cliente = @clienteprov and preciosinferioresminimo = 1)
select @ok = null
exec xpvalidarprecios @empresa, @modulo, @id, @accion, @articulo, @subcuenta, @cfgvalidarprecios, @ok output, @okref output
if @ok is not null select @autorizar = 1
end
if (@estatus in ('sinafectar', 'borrador', 'confirmar') or @accion in ('reservar', 'cancelar')) and @ok is null and (@generar = 0 or @movtipo = 'inv.if') and
(@utilizar = 0 or (@utilizar = 1 and @movtipo in ('vtas.r','vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx','vtas.fb','vtas.sg','vtas.eg','vtas.vc','vtas.vcr','coms.f','coms.fl','coms.eg', 'coms.ei','coms.ig','coms.cc') and @accion not in ('cancelar', 'generar')))
begin
select @aplicaordenado = 0.0, @aplicapendiente = 0.0, @aplicareservada = 0.0
if @afectarmatando = 1 and @estatus in ('sinafectar', 'borrador', 'confirmar') and @ok is null
begin
if @utilizar = 0
begin
if (@aplicamov is null) or (nullif(rtrim(@aplicamovid), '') is null)
begin
if @afectarmatandoopcional = 0 select @ok = 20170
end else
begin
if @sustitutoarticulo is not null and @articulo <> @sustitutoarticulo select @articulomatar = @sustitutoarticulo else select @articulomatar = @articulo
if @sustitutosubcuenta is not null and @subcuenta <> @sustitutosubcuenta select @subcuentamatar = @sustitutosubcuenta else select @subcuentamatar = @subcuenta
exec spinvpendiente @id, @modulo, @empresa, @movtipo, @almacen, @almacendestino, @aplicamov, @aplicamovid, @aplicamovtipo, @articulomatar, @subcuentamatar, @movunidad,
@aplicaordenado output, @aplicapendiente output, @aplicareservada output, @aplicaclienteprov output,
@ok output, @okref output
if @ok is null
begin
if round(@cantidadcalcularimporte, 4) > round(@aplicapendiente + @aplicareservada, 4)
begin
select @excendetedemas = round((((round(@cantidadcalcularimporte, 4)+@aplicaordenado-round(@aplicapendiente + @aplicareservada, 4))/@aplicaordenado)-1)*100, 4)
if (@aplicamovtipo in ('vtas.p','vtas.s') and @cfgventasurtirdemas = 1) or
(@aplicamovtipo in ('cxc.ca', 'cxc.cap') and @modulo = 'vtas') or
(@aplicamovtipo in ('coms.r') and @cfgcomprarecibirdemas = 1) or
(@aplicamovtipo in ('coms.o', 'coms.op', 'coms.og','coms.oi') and (@cfgcomprarecibirdemas = 1 and (@cfgcomprarecibirdemastolerancia is null or @excendetedemas<=@cfgcomprarecibirdemastolerancia))) or
(@aplicamovtipo in ('inv.ot', 'inv.oi') and @cfgtransferirdemas = 1) or
(@aplicamovtipo = 'inv.sm' and @movtipo = 'inv.cm')
select @ok = null
else
begin
select @ok = 20180, @okref = 'articulo: '+rtrim(@articulo)+'<br><br>ordenado: '+convert(varchar, @aplicaordenado)+'<br>pendiente: '+convert(varchar, (@aplicapendiente + @aplicareservada))+'<br><br>aplicar: '+convert(varchar, @cantidad)+'<br>excedente: '+convert(varchar, @excendetedemas)+'%'
if @movtipo = 'prod.e' and upper(@detalletipo) = 'excedente' select @ok = null, @okref = null
end
end else
if @clienteprov <> @aplicaclienteprov and nullif(rtrim(@aplicaclienteprov), '') is not null
begin
if @modulo = 'vtas'
begin
if not exists(select * from cterelacion with (nolock) where (cliente = @clienteprov and relacion = @aplicaclienteprov) or (cliente = @aplicaclienteprov and relacion = @clienteprov))
select @ok = 20191
end else
if @modulo = 'coms' and @movtipo <> 'coms.ei'
begin
if not exists(select * from provrelacion with (nolock) where (proveedor = @clienteprov and relacion = @aplicaclienteprov) or (proveedor = @aplicaclienteprov and relacion = @clienteprov))
select @ok = 20192
end else
if @modulo in ('inv','prod') select @ok = 20190
if @ok is not null select @okref = @aplicaclienteprov
end
end
end
end else
if @utilizarmovtipo in ('vtas.p','vtas.s','inv.sol','inv.ot','inv.oi','inv.sm') select @aplicareservada = @cantidadreservada
end
if @movtipo = 'inv.cp' and @estatus in ('sinafectar', 'borrador', 'confirmar')
begin
if @articulodestino is null select @ok = 20220 else
if @articulo = @articulodestino and isnull(@subcuenta, '') = isnull(@subcuentadestino, '') select @ok = 20250 else
if @arttipo not in ('normal', 'serie', 'vin', 'lote', 'partida') select @ok = 20235 else
if @arttipo <> (select tipo from art with (nolock) where articulo = @articulodestino) select @ok = 20236 else
if nullif(@subcuentadestino, '') is not null
exec spopcionvalidar @articulodestino, @subcuentadestino, @accion, @ok output, @okref
end
select @afectaralmacen = @almacen, @afectaralmacentipo = @almacentipo
if (@essalida = 1 or @estransferencia = 1 or @accion = 'reservar') and @arttipo not in ('jue','servicio') and @facturarvtasmostrador = 0 and @ok is null
begin
if (@aplicamovtipo = 'vtas.r' and @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx'))
select @ok = @ok
else begin
if @subcuenta is null
begin
if @arttipoopcion = 'matriz' select @ok = 20070
select @validardisponible = ~@novalidardisponible
if @cantidad > @aplicareservada and @validardisponible = 1
begin
exec spartdisponible @empresa, @afectaralmacen, @articulo, @afectarconsignacion, @afectaralmacentipo, @factor, @disponible output, @ok output
select @disponible = @disponible + @aplicareservada
if round(@disponible, 4) < round(@cantidad, 4) select @ok = 20020
end
end else
begin
if @cantidad > @aplicareservada and @validardisponible = 1
begin
exec spartsubdisponible @empresa, @afectaralmacen, @articulo, @arttipo, @subcuenta, @afectarconsignacion, @afectaralmacentipo, @factor, @disponible output, @ok output
select @disponible = @disponible + @aplicareservada
if round(@disponible, 4) = 0.0
begin
if @arttipoopcion <> 'no' select @ok = 20040
else select @ok = 20020
end else if round(@disponible, 4) < round(@cantidad, 4) select @ok = 20020
end
end
end
end
if @movtipo in ('coms.b', 'coms.ca', 'coms.gx') and @afectarcostos = 1 and @costo = 0.0 and @arttipo not in ('jue', 'servicio') select @ok = 20100
if @estransferencia = 1 select @afectaralmacen = @almacendestino, @afectaralmacentipo = @almacendestinotipo
if (@esentrada = 1 or @estransferencia = 1 or @movtipo='coms.o') and @essalida = 0 and @ok is null and @estatusnuevo <> 'borrador'
begin
if @afectarpiezas = 1
begin
if @costo <> 0.0
select @ok = 20140
end else
if (@afectarcostos = 1 or @movtipo = 'coms.o') and @almacentipo <> 'garantias' and @accion <> 'cancelar' and @arttipo not in ('jue', 'servicio')
begin
if exists(select articulo from activof with (nolock) where empresa = @empresa and articulo = @articulo and serie in (select serielote from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and renglonid = @renglonid and articulo = @articulo))
select @esactivof = 1
else select @esactivof = 0
if @costo = 0.0 and @movtipo not in ('vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm', 'prod.e', 'inv.cm') and @cfginventradassincosto = 0 and @esactivof <> 1 select @ok = 20100 else
if @costo < 0.0 and @movtipo <> 'inv.tc' select @ok = 20101
end
end
if (@esentrada = 1 or @estransferencia = 1) and @essalida = 0 and @ok is null
begin
if @subcuenta is null and @arttipoopcion = 'matriz' select @ok = 20070
end
if @movtipo in ('vtas.d', 'vtas.df', 'vtas.dfc', 'vtas.b') and @arttipo not in ('jue','servicio')
begin
if @cfgventadevsinantecedente = 0
begin
if not exists(select *
from venta e with (nolock), ventad d with (nolock), movtipo mt with (nolock)
where e.id=d.id and e.empresa = @empresa and e.cliente = @clienteprov and e.estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado')
and mt.modulo = 'vtas' and mt.mov = e.mov and mt.clave in ('vtas.f','vtas.far', 'vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm', 'vtas.fc', 'vtas.fg', 'vtas.fx')
and d.articulo = @articulo and isnull(d.subcuenta, '') = isnull(@subcuenta, ''))
begin
select @ok = 20670, @okref = @articulo
exec xpok_20670 @empresa, @usuario, @accion, @modulo, @id, @renglon, @renglonsub, @ok output, @okref output
end
end
if @arttipo in ('serie','lote','vin','partida') and @ok is null
begin
if @cfgventadevseriessinantecedente = 0
begin
select @okref = null
select @okref = min(serielote)
from serielotemov with (nolock)
where id = @id
and serielote not in (select serielote from serielotemov with (nolock) where id in
(select e.id
from venta e with (nolock), ventad d with (nolock), movtipo mt with (nolock)
where e.id=d.id and e.empresa = @empresa and e.cliente = @clienteprov and e.estatus not in ('sinafectar', 'borrador', 'confirmar', 'cancelado')
and mt.modulo = 'vtas' and mt.mov = e.mov and mt.clave in ('vtas.f','vtas.far', 'vtas.n', 'vtas.no', 'vtas.nr', 'vtas.fm', 'vtas.fc', 'vtas.fg', 'vtas.fx')
and d.articulo = @articulo and isnull(d.subcuenta, '') = isnull(@subcuenta, '')))
if @okref is not null
select @ok = 20670, @okref = rtrim(@articulo)+' / '+rtrim(@okref)
end
end
end
if @movtipo = 'inv.if'
begin
if exists(select * from invd with (nolock) where id = @id and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '') and (renglon <> @renglon or renglonsub <> @renglonsub))
select @ok = 10245, @okref = @articulo
if @subcuenta is null and @arttipoopcion = 'matriz' select @ok = 20070
end
end else
begin
if @afectarpiezas = 0 and @movtipo <> 'inv.if' and @ok is null and @estatus = 'pendiente'
begin
if @base = 'seleccion' and @cantidad > @cantidadpendiente + @cantidadreservada and @accion <> 'desasignar'
begin
if @utilizar = 1 and
((@utilizarmovtipo in ('vtas.p','vtas.s') and @cfgventasurtirdemas = 1) or
(@utilizarmovtipo in ('coms.o','coms.op','coms.og','coms.oi') and @cfgcomprarecibirdemas = 1) or
(@utilizarmovtipo in ('inv.ot', 'inv.oi') and @cfgtransferirdemas = 1) or
@utilizarmovtipo in ('inv.sm'))
select @ok = null
else
select @ok = 20160
end else if @base = 'seleccion' and @accion = 'reservar' and @cantidad > @cantidadpendiente
select @ok = 20160
else if @base = 'reservado' and @accion <> 'generar' and @cantidad > @cantidadreservada
select @ok = 20165
else if @base = 'ordenado' and @cantidad > @cantidadordenada
select @ok = 20167
end
end
if @arttipo in ('serie', 'vin', 'lote', 'partida') and (@generar = 0 or @movtipo in ('inv.if')) and @utilizar = 0 and @cfgserieslotesmayoreo = 1 and (@esentrada = 1 or @movtipo in ('coms.b', 'coms.ca', 'coms.gx', 'inv.if','vtas.co') or @essalida = 1 or @estransferencia = 1) and @afectarunidades = 1 and @ok is null
begin
if (@aplicamovtipo = 'vtas.r' and @movtipo in ('vtas.f','vtas.far', 'vtas.fc', 'vtas.fg', 'vtas.fx'))
begin
if @movtipo <> 'vtas.fm'
if exists(select * from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '') and renglonid = @renglonid)
select @ok = 20095
end else
begin
if @arttipo = 'vin'
if exists(select * from serielotemov s with (nolock), vin v with (nolock)
where s.empresa = @empresa and s.modulo = @modulo and s.id = @id and s.articulo = @articulo and isnull(s.subcuenta, '') = isnull(@subcuenta, '') and s.renglonid = @renglonid
and s.serielote = v.vin and v.articulo <> @articulo)
select @ok = 20690
if round(abs(@cantidad*@factor), @cfgdecimalescantidades) <> round((select isnull(sum(abs(cantidad)), 0.0) from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '') and renglonid = @renglonid), @cfgdecimalescantidades)
begin
if not exists(select * from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '') and renglonid = @renglonid)
begin
if (@esentrada = 1 or @movtipo in ('coms.b','coms.ca', 'coms.gx','vtas.co','inv.cp') or @serieslotesautoorden = 'no') and (@artserieloteinfo = 0 or (@essalida = 1 and @accion <> 'cancelar')) and @ok is null and @esestadistica = 0 and @aplicamovtipo <> 'coms.cc'
begin
select @cantidadsugerida = abs(@cantidad*@factor)
exec spsugerirserielotemov @empresa, @modulo, @id, @movtipo, @almacen, @renglonid, @articulo, @subcuenta, @sucursal, @cantidad, @paquete, @ensilencio = 1
if not exists(select * from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '') and renglonid = @renglonid)
begin
if @arttipo = 'vin' select @ok = 20325 else select @ok = 20320
if @ok is not null
begin
if @modulo = 'vtas' and @origentipo = 'vmos' select @ok = null
if @movtipo in ('vtas.n', 'vtas.nr', 'vtas.no', 'vtas.fm') and @cfgnotasborrador = 1 select @ok = null
end
end
end
end else select @ok = 20330
end else begin
if @esentrada = 1 and @arttipo in ('serie', 'vin')
begin
select @serielote = min(s.serielote)
from serielotemov sm with (nolock), serielote s with (nolock)
where s.sucursal = @sucursal and s.empresa = sm.empresa and s.articulo = sm.articulo and s.subcuenta = sm.subcuenta and s.serielote = sm.serielote and (isnull(s.existencia, 0) > 0 or isnull(s.existenciaactivofijo, 0) > 0)
and sm.empresa = @empresa and sm.modulo = @modulo and sm.id = @id and sm.articulo = @articulo and sm.renglonid = @renglonid
if @serielote is not null select @ok = 20080
if @ok = 20080 and @accion = 'cancelar' and @movtipo = 'inv.cp' and @cantidad > 0.0 select @ok = null
end else
if (@essalida = 1 or @estransferencia = 1 or @movtipo in ('coms.b', 'coms.ca', 'coms.gx')) and @artserieloteinfo = 0
begin
select @serielote = min(serielote)
from serielotemov with (nolock)
where empresa = @empresa and modulo = @modulo and id = @id and articulo = @articulo and subcuenta = isnull(@subcuenta, '') and renglonid = @renglonid and isnull(cantidad, 0) > 0
and serielote not in (select serielote from serielote with (nolock) where empresa = @empresa and articulo = @articulo and subcuenta = isnull(@subcuenta, '') and almacen = @almacen and (isnull(existencia, 0) > 0 or isnull(existenciaactivofijo, 0) > 0))
if @serielote is not null select @ok = 20090
if @ok is not null and @modulo = 'vtas' and (@origentipo = 'vmos' or @movtipo = 'vtas.fm') select @ok = null
end
if @ok is null and @movtipo in ('coms.dc','coms.dg') and @artserieloteinfo = 0
begin
select @cantidadseries = count(*)
from serielotemov with (nolock)
where empresa = @empresa and modulo = @modulo and articulo = @articulo and id = @idaplica
and serielote in (select serielote from serielotemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and articulo = @articulo and renglonid = @renglonid)
if @cantidadseries <> @cantidad select @ok = 20090
end
end
end
end
if @movtipo = 'coms.ca'
if (select round(sum(isnull(inventario, 0)), 4) from artsubexistenciainv with (nolock) where empresa = @empresa and almacen = @almacen and articulo = @articulo and isnull(subcuenta, '') = isnull(@subcuenta, '')) <= 0.0
select @ok = 20810
if @movtipo in ('coms.og','coms.ig','coms.dg') and @almacentipo <> 'garantias' and @ok is null
select @ok = 20440
if @movtipo in ('coms.f','coms.fl','coms.eg','coms.ei','coms.cc') and @accion <> 'generar' and @cfgcompracaducidad = 1 and @artcaducidadminima is not null and @ok is null
begin
if @fechacaducidad is null select @ok = 25125 else
if @fechacaducidad < dateadd(day, @artcaducidadminima, @fechaemision) select @ok = 25126
end
if @modulo = 'vtas' and @accion <> 'cancelar' and @estatus in ('sinafectar', 'borrador', 'confirmar') and @ok is null
exec xpinvverificarcteartbloqueo @empresa, @id, @usuario, @clienteprov, @articulo, @ok output, @okref output
if @ok is null
exec xpinvverificardetalle @id, @accion, @base, @empresa, @usuario, @modulo,
@mov, @movid, @movtipo, @movmoneda, @movtipocambio, @estatus, @estatusnuevo,
@fechaemision, @renglon, @renglonsub, @articulo, @cantidad, @importe,
@importeneto, @impuestos, @impuestosnetos,
@ok output, @okref output
if @ok is not null and @okref is null
begin
select @okref = 'articulo: '+rtrim(@articulo)
if nullif(rtrim(@subcuenta), '') is not null
select @okref = @okref + ' ('+rtrim(@subcuenta)+')'
if nullif(rtrim(@serielote), '') is not null
select @okref = @okref + ' - '+rtrim(@serielote)
end
select @afectaral = 1
if @modulo = 'vtas'
begin
select @sumaimporteneto = @sumaimporteneto + @importeneto,
@sumaimpuestosnetos = @sumaimpuestosnetos + @impuestosnetos
if (@aplicaautorizacion is null or @cfgautoautorizacionfacturas = 0)
select @sumaimportenetosinautorizar = @sumaimportenetosinautorizar + @importeneto,
@sumaimpuestosnetossinautorizar = @sumaimpuestosnetossinautorizar + @impuestosnetos
end
if @accion = 'cancelar'
select @sumacantidadoriginal = @sumacantidadoriginal + @cantidadoriginal,
@sumacantidadpendiente = @sumacantidadpendiente + @cantidadpendiente + @cantidadreservada
end
if @ok is null
begin
fetch next from crverificardetalle into @autogenerado, @renglon, @renglonsub, @renglonid, @renglontipo, @cantidadoriginal, @cantidadobsequio, @cantidadinventario, @cantidadreservada, @cantidadordenada, @cantidadpendiente, @cantidada, @movunidad, @factor, @articulo, @subcuenta, @articulodestino, @subcuentadestino, @sustitutoarticulo, @sustitutosubcuenta, @costo, @precio, @descuentotipo, @descuentolinea, @impuesto1, @impuesto2, @impuesto3, @aplicamov, @aplicamovid, @almacenrenglon, @arttipo, @artserieloteinfo, @arttipoopcion, @arttipocompra, @artseproduce, @artsecompra, @artesformula, @artunidad, @artpreciominimo, @artmonedaventa, @artmargenminimo, @artmonedacosto, @prodserielote, @prodruta, @prodorden, @prodordendestino, @prodcentro, @prodcentrodestino, @detalletipo, @cantidadminimaventa, @cantidadmaximaventa, @artcaducidadminima, @fechacaducidad, @artactividades, @fecharequeridad, @paquete, @esestadistica, @preciotipocambio
if @@error <> 0 select @ok = 1
end else
if @okref is null
begin
select @okref = 'articulo: '+@articulo
if @subcuenta is not null select @okref = @okref+ ' ('+@subcuenta+')'
end
end
close crverificardetalle
end
deallocate crverificardetalle
if @ok is null
begin
if @modulo = 'vtas'
begin
select @importetotalsinautorizar = @sumaimportenetosinautorizar + @sumaimpuestosnetossinautorizar - @anticiposfacturados,
@importetotal = @sumaimporteneto + @sumaimpuestosnetos - @anticiposfacturados
if @cfgautoautorizacionfacturas = 1 and isnull(@importetotalsinautorizar, 0) <> 0.0
begin
if @anexoid is not null
select @importetotalsinautorizar = 0.0
else
if @origentipo = @modulo
if (select nullif(rtrim(autorizacion), '') from venta where empresa = @empresa and mov = @origen and movid = @origenid and estatus in ('pendiente', 'concluido')) is not null
select @importetotalsinautorizar = 0.0
end
end
if @modulo = 'vtas' and @cfgimpinc = 1
begin
select @sumaimporteneto = @sumaimporteneto - (@sumaimporteneto + @sumaimpuestosnetos - @importetotal)
end
if @afectaral = 0 and @estatusnuevo <> 'confirmar' and @movtipo <> 'inv.if'
if @accion = 'cancelar' select @ok = 60015 else select @ok = 60010
if @accion = 'cancelar'
begin
if @estatus = 'pendiente' and round(@sumacantidadoriginal, 4) <> round(@sumacantidadpendiente, 4) and @base = 'todo'
select @ok = 60080
end else
if @modulo = 'vtas' and @accion not in ('generar', 'cancelar') and @estatus <> 'pendiente'
begin
if @cfgventabloquearmorosos <> 'no' and @movtipo not in ('vtas.pr', 'vtas.est', 'vtas.sd', 'vtas.d', 'vtas.df', 'vtas.dfc', 'vtas.b', 'vtas.dr', 'vtas.dc', 'vtas.dcr', 'vtas.vp') and (@autorizacion is null or @mensaje not in (65010, 65020, 65040)) and @cobrointegrado = 0 and @importetotalsinautorizar <> 0.0 and @ok is null
begin
select @diastolerancia = 0
if substring(@cfgventabloquearmorosos,1,1) <> 's'
begin
if isnumeric(@cfgventabloquearmorosos) = 1
select @diastolerancia = convert(int, @cfgventabloquearmorosos)
else begin
if isnumeric(rtrim(substring(@cfgventabloquearmorosos, 1, 2))) = 1
select @diastolerancia = convert(int, rtrim(substring(@cfgventabloquearmorosos, 1, 2)))
end
end
select @maxdiasmoratorios = isnull(max(p.diasmoratorios), 0)
from cxcpendiente p with (nolock), movtipo mt with (nolock)
where p.empresa = @empresa
and p.cliente = @clienteprov
and mt.modulo = 'cxc' and mt.mov = p.mov and mt.clave not in ('cxc.a', 'cxc.ar', 'cxc.nc', 'cxc.dac', 'cxc.ncd','cxc.ncf')
if @maxdiasmoratorios > @diastolerancia
begin
select @ok = 65040
exec xpvalidacionmorosos @empresa, @accion, @modulo, @id, @movtipo, @serviciogarantia, @ok output
end
if @ok is not null select @autorizar = 1
end
if @checarcredito = 1 and @movtipo not in ('vtas.pr', 'vtas.est', 'vtas.sd', 'vtas.d', 'vtas.df', 'vtas.dfc', 'vtas.b', 'vtas.dr', 'vtas.dc', 'vtas.dcr', 'vtas.vp') and (@autorizacion is null or @mensaje not in (65010, 65020)) and @accion <> 'generar' and @ok is null
begin
select @diasvencimiento = 0
if @condicion is not null
begin
select @diasvencimiento = null
select @diasvencimiento = diasvencimiento from condicion where condicion = @condicion
if @diasvencimiento is null
select @diasvencimiento = datediff(day, @fechaemision, @vencimiento)
else
begin
if @diascredito is not null
if @diasvencimiento > @diascredito select @ok = 65020
if @condicionesvalidas is not null
if charindex(upper(@condicion), @condicionesvalidas) = 0 select @ok = 65020
end
end
if @concredito = 0 and @diasvencimiento > 0 select @ok = 65020
if @concredito = 1 and @conlimitecredito = 1 and @movtipo not in ('vtas.d','vtas.df','vtas.dfc','vtas.b','vtas.dr') and @importetotalsinautorizar <> 0.0 and @ok is null
begin
if (@cfgventachecarcredito = 'cotizacion') or
(@cfgventachecarcredito = 'pedido' and @movtipo not in ('vtas.c', 'vtas.cs')) or
(@movtipo not in ('vtas.c','vtas.cs','vtas.p','vtas.s'))
begin
select @saldo = 0.0, @ventaspendientes = 0.0, @pedidospendientes = 0.0
if @cfglimitecreditoniveluen = 1
begin
if @cfglimitecreditonivelgrupo = 1
select @saldo = isnull(sum(s.saldo * m.tipocambio), 0.0)
from cxc s with (nolock), mon m with (nolock), empresa e with (nolock)
where e.grupo = @empresagrupo and s.empresa = e.empresa and s.cliente = @clienteprov and s.moneda = m.moneda
and s.uen = @ventauen and s.estatus = 'pendiente'
else
select @saldo = isnull(sum(s.saldo * m.tipocambio), 0.0)
from cxc s with (nolock), mon m with (nolock)
where s.empresa = @empresa and s.cliente = @clienteprov and s.moneda = m.moneda
and s.uen = @ventauen and s.estatus = 'pendiente'
end else
begin
if @cfglimitecreditonivelgrupo = 1
select @saldo = isnull(sum(s.saldo * m.tipocambio), 0.0)
from cxcsaldo s with (nolock), mon m with (nolock), empresa e with (nolock)
where e.grupo = @empresagrupo and s.empresa = e.empresa and s.cliente = @clienteprov and s.moneda = m.moneda
else
select @saldo = isnull(sum(s.saldo * m.tipocambio), 0.0)
from cxcsaldo s with (nolock), mon m with (nolock)
where s.empresa = @empresa and s.cliente = @clienteprov and s.moneda = m.moneda
end
if @movtipo in ('vtas.p', 'vtas.s') and @conlimitepedidos = 1
begin
if @cfglimitecreditoniveluen = 1
begin
if @cfglimitecreditonivelgrupo = 1
select @pedidospendientes = isnull(sum(isnull(v.saldo, 0) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.p', 'vtas.s') and v.estatus = 'pendiente' and v.empresa = @empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
and v.uen = @ventauen
else
select @pedidospendientes = isnull(sum(isnull(v.saldo, 0) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock), empresa e with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.p', 'vtas.s') and v.estatus = 'pendiente' and e.grupo = @empresagrupo and v.empresa = e.empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
and v.uen = @ventauen
end else
begin
if @cfglimitecreditonivelgrupo = 1
select @pedidospendientes = isnull(sum(isnull(v.saldo, 0) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.p', 'vtas.s') and v.estatus = 'pendiente' and v.empresa = @empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
else
select @pedidospendientes = isnull(sum(isnull(v.saldo, 0) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock), empresa e with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.p', 'vtas.s') and v.estatus = 'pendiente' and e.grupo = @empresagrupo and v.empresa = e.empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
end
select @difcredito = (@limitepedidos*@tipocambiocredito) - @pedidospendientes - (@sumaimportenetosinautorizar*@movtipocambio)
if round(@difcredito, 0) < 0.0
begin
select @importeautorizar = -@difcredito
select @ok = 65010,
@okref = 'limite pedidos: '+convert(char, @limitepedidos * @tipocambiocredito) +
'<br>pedidos pendientes: '+ltrim(convert(char, @pedidospendientes)) +
'<br>importe movimiento: '+ltrim(convert(char, @sumaimportenetosinautorizar*@movtipocambio)) +
'<br><br>diferencia: '+ltrim(convert(char, -@difcredito)) +
'<br>importe autorizar: '+ltrim(convert(char, @importeautorizar))
if @importeautorizar > @sumaimportenetosinautorizar*@movtipocambio select @importeautorizar = @sumaimportenetosinautorizar*@movtipocambio
update venta with (rowlock) set difcredito = @importeautorizar where id = @id
end
end else
begin
if @cfgventapedidosdisminuyencredito = 1
select @saldo = @saldo + isnull(sum(isnull(v.saldo, 0) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock), empresa e with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.p', 'vtas.s') and v.estatus = 'pendiente' and e.grupo = @empresagrupo and v.empresa = e.empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
if @cfglimitecreditoniveluen = 1
begin
if @cfglimitecreditonivelgrupo = 1
select @ventaspendientes = isnull(sum((isnull(v.saldo, 0) ) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock), empresa e with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.r', 'vtas.vc', 'vtas.vcr') and v.estatus = 'pendiente' and e.grupo = @empresagrupo and v.empresa = e.empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
and v.uen = @ventauen
else
select @ventaspendientes = isnull(sum((isnull(v.saldo, 0) ) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.r', 'vtas.vc', 'vtas.vcr') and v.estatus = 'pendiente' and v.empresa = @empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
and v.uen = @ventauen
end else
begin
if @cfglimitecreditonivelgrupo = 1
select @ventaspendientes = isnull(sum((isnull(v.saldo, 0) ) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock), empresa e with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.r', 'vtas.vc', 'vtas.vcr') and v.estatus = 'pendiente' and e.grupo = @empresagrupo and v.empresa = e.empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
else
select @ventaspendientes = isnull(sum((isnull(v.saldo, 0) ) * mon.tipocambio), 0)
from ventapendiente v with (nolock), movtipo mt with (nolock), mon with (nolock)
where mt.modulo = 'vtas' and mt.mov = v.mov and mt.clave in ('vtas.r', 'vtas.vc', 'vtas.vcr') and v.estatus = 'pendiente' and v.empresa = @empresa and v.cliente = @clienteprov and v.moneda = mon.moneda
end
select @remisionesaplicadas = 0.0
select @remisionesaplicadas = isnull(sum(d.importetotal*m.tipocambio), 0.0)
from ventatcalc d with (nolock), movtipo mt with (nolock), mon m with (nolock)
where d.id = @id
and mt.mov = d.aplica and mt.modulo = 'vtas' and mt.clave in ('vtas.r', 'vtas.vcr') and d.moneda = m.moneda
if @remisionesaplicadas is not null
select @ventaspendientes = @ventaspendientes - @remisionesaplicadas
select @difcredito = (@limitecredito*@tipocambiocredito) - @saldo - @ventaspendientes - (@importetotalsinautorizar*@movtipocambio)
if round(@difcredito, 0) < 0.0
begin
select @importeautorizar = -@difcredito
select @ok = 65010,
@okref = 'limite credito: '+convert(char, @limitecredito * @tipocambiocredito) +
'<br><br>saldo actual: '+ltrim(convert(char, @saldo)) +
'<br>remisiones pendientes: '+ltrim(convert(char, @ventaspendientes)) +
'<br>importe movimiento: '+ltrim(convert(char, @importetotalsinautorizar*@movtipocambio)) +
'<br><br>diferencia: '+ltrim(convert(char, -@difcredito)) +
'<br>importe autorizar: '+ltrim(convert(char, @importeautorizar))
if @importeautorizar > @sumaimportenetosinautorizar*@movtipocambio select @importeautorizar = @sumaimportenetosinautorizar*@movtipocambio
update venta with (rowlock) set difcredito = @importeautorizar where id = @id
end
end
end
end
if @ok is not null select @autorizar = 1
end
if @movtipo in ('vtas.f','vtas.far', 'vtas.fb', 'vtas.fm') and @estatus in ('sinafectar', 'confirmar', 'borrador') and @accion not in ('cancelar', 'generar') and @ok is null and @autocorrida is null
if round(@importetotal, 0) < 0.0 select @ok = 20410
if @movtipo = 'vtas.s' and @cfgserviciosrequieretareas = 1 and @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion not in ('cancelar', 'generar')
if not exists (select * from serviciotarea with (nolock) where id = @id)
begin
select @tareaomision = nullif(rtrim(ventaserviciostareaomision), '') from empresacfg with (nolock) where empresa = @empresa
if @tareaomision is null
select @ok = 20490
else begin
select @tareaomisionestado = null
select @tareaomisionestado = estado from tareaestado with (nolock) where orden = 1
insert serviciotarea (sucursal, id, tarea, estado) values (@sucursal, @id, @tareaomision, @tareaomisionestado)
end
end
if @movtipo = 'vtas.s' and @cfgserviciosvalidarid = 1 and @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion not in ('cancelar', 'generar') and @anexoid is null
begin
select @flotante = nullif(servicionumero, 0), @identificador = nullif(rtrim(servicioidentificador), '') from venta with (nolock) where id = @id
if @flotante is not null or @identificador is not null
if exists(select id from venta with (nolock) where empresa = @empresa and estatus = 'pendiente' and servicionumero = @flotante and servicioidentificador = @identificador and servicioserie<>@servicioserie)
select @ok = 26120, @okref = isnull(@identificador, '')+' '+convert(varchar, @flotante)
end
if @movtipo in ('vtas.sg','vtas.eg') and @importetotal > 0.0 and @ok is null select @ok = 20420
if @movtipo in ('vtas.f','vtas.far','vtas.fb')
and @cfglimiterenfacturas > 0
and (@facturarvtasmostrador = 0 or @cfgventalimiterenfacturasvmos = 1)
and @accion <> 'generar'
and @ok is null
and @facturacionrapidaagrupada = 0
begin
select @conteo = isnull(count(*), 0) from ventad with (nolock) where id = @id
if @cfglimiterenfacturas < @conteo select @ok = 60210, @okref = 'limite: '+ltrim(convert(char, @cfglimiterenfacturas))+', renglones: '+ltrim(convert(char, @conteo))
end
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @cobrointegrado = 1 and @origentipo <> 'vmos' and @ok is null
begin
select @importe1 = 0.0, @importe2 = 0.0, @importe3 = 0.0, @importe4 = 0.0, @importe5 = 0.0,
@cobrodesglosado = 0.0, @cobrocambio = 0.0, @cobrodelefectivo = 0.0, @valescobrados = 0.0, @cobroredondeo = 0.0, @tarjetascobradas = 0.0
select @importe1 = isnull(importe1, 0.0), @importe2 = isnull(importe2, 0.0), @importe3 = isnull(importe3, 0.0), @importe4 = isnull(importe4, 0.0), @importe5 = isnull(importe5, 0.0),
@formacobro1 = nullif(rtrim(formacobro1), ''), @formacobro2 = nullif(rtrim(formacobro2), ''), @formacobro3 = nullif(rtrim(formacobro3), ''), @formacobro4 = nullif(rtrim(formacobro4), ''), @formacobro5 = nullif(rtrim(formacobro5), ''),
@cobrodelefectivo = round(isnull(delefectivo, 0.0), @redondeomonetarios),
@cobroredondeo = isnull(redondeo, 0)
from ventacobro with (nolock)
where id = @id
exec spventacobrototal @formacobro1, @formacobro2, @formacobro3, @formacobro4, @formacobro5,
@importe1, @importe2, @importe3, @importe4, @importe5, @cobrodesglosado output, @moneda = @movmoneda, @tipocambio = @movtipocambio
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
if @cfgformaparequerida = 1
if (@importe1 > 0.0 and @formacobro1 is null) or (@importe2 > 0.0 and @formacobro2 is null) or (@importe3 > 0.0 and @formacobro3 is null) or (@importe4 > 0.0 and @formacobro4 is null) or (@importe5 > 0.0 and @formacobro5 is null)
select @ok = 30530
if @importetotal < @cobrodesglosado + @cobrodelefectivo
select @cobrocambio = @cobrodesglosado + @cobrodelefectivo - @importetotal - @cobroredondeo
if @importetotal = @cobrodelefectivo and @cobrodesglosado <> 0
select @ok = 30100
if @valescobrados > 0.0 or @tarjetascobradas <> 0.0
begin
exec spvalevalidarcobro @empresa, @modulo, @id, @accion, @fechaemision, @valescobrados, @tarjetascobradas, @movmoneda, @ok output, @okref output
if @tarjetascobradas = 0 and exists(select * from tarjetaseriemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id and isnull(importe,0) <> 0)
select @ok = 36171
if @valescobrados = 0 and exists(select * from valeseriemov with (nolock) where empresa = @empresa and modulo = @modulo and id = @id)
select @ok = 36170
end
if (@movtipo in ('vtas.n', 'vtas.fm') and @cfgventaliquidaintegral = 1) or
(@movtipo in ('vtas.f','vtas.far') and @cfgfacturacobrointegrado = 1) or
@movtipo in ('vtas.p', 'vtas.s', 'vtas.sd', 'vtas.vp')
select @validarcobrointegrado = 1
else
select @validarcobrointegrado = 0
if @cobrodesglosado + @cobrodelefectivo = 0.0 and @validarcobrointegrado = 0 and @movid is null
select @afectarconsecutivo = 1
else
begin
if round(@cobrodesglosado + @cobrodelefectivo, 2) < round(round(@importetotal, @cfgventacobroredondeodecimales) + @cobroredondeo, 2) and @ok is null
begin
if abs(@importetotal + @cobroredondeo - (@cobrodesglosado + @cobrodelefectivo)) > 0.01
begin
select @ok = 20370, @okref = 'diferencia: '+ltrim(convert(varchar, @importetotal + @cobroredondeo - (@cobrodesglosado + @cobrodelefectivo)))
if @cobrointegradoparcial = 1
select @ok = null, @okref = null
end
end
if @importetotal>=0.0 and round(@cobrocambio, 1) > round(@cobrodesglosado, 1) and @ok is null
select @ok = 30250
if @cobrodelefectivo > 0.0 and @movtipo not in ('vtas.sd', 'vtas.vp') and @ok is null
begin
select @efectivo = 0.0
select @efectivo = isnull(saldo, 0.0) from cxcefectivo with (nolock) where empresa = @empresa and cliente = @clienteprov and moneda = @movmoneda
if round(@cobrodelefectivo, 0) > round(-@efectivo, 0)
select @ok = 30090
end else
if @cobrodelefectivo < 0.0 select @ok = 30100
end
end
end
end
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion not in ('cancelar', 'generar') and @ok is null
begin
if @cfgvalidarcc = 1 and @modulo in ('vtas', 'coms', 'inv')
begin
select @contuso = null
if @modulo = 'vtas'
begin
if @contuso is null select @contuso = min(d.contuso) from ventad d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostosempresa v with (nolock) where v.empresa = @empresa)
if @contuso is null select @contuso = min(d.contuso) from ventad d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostossucursal v with (nolock) where v.sucursal = @sucursal)
if @contuso is null select @contuso = min(d.contuso) from ventad d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostosusuario v with (nolock) where v.usuario = @usuario)
end else
if @modulo = 'coms'
begin
if @contuso is null select @contuso = min(d.contuso) from comprad d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostosempresa v with (nolock) where v.empresa = @empresa)
if @contuso is null select @contuso = min(d.contuso) from comprad d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostossucursal v with (nolock) where v.sucursal = @sucursal)
if @contuso is null select @contuso = min(d.contuso) from comprad d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostosusuario v with (nolock) where v.usuario = @usuario)
end else
if @modulo = 'inv'
begin
if @contuso is null select @contuso = min(d.contuso) from invd d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostosempresa v with (nolock) where v.empresa = @empresa)
if @contuso is null select @contuso = min(d.contuso) from invd d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostossucursal v with (nolock) where v.sucursal = @sucursal)
if @contuso is null select @contuso = min(d.contuso) from invd d with (nolock) where d.id = @id and nullif(rtrim(d.contuso), '') is not null and d.contuso not in (select v.centrocostos from centrocostosusuario v with (nolock) where v.usuario = @usuario)
end
if @contuso is not null select @ok = 20765, @okref = @contuso
end
if @cfgventarestringida = 1 and @movtipo in ('vtas.f','vtas.far', 'vtas.fb', 'vtas.fm', 'vtas.n') and @ok is null and @accion not in ('generar', 'cancelar')
exec spventarestringida @id, @accion, @empresa, @ok output, @okref output
if @cfgrestringirartbloqueados = 1 and @modulo in ('vtas', 'coms') and @ok is null
begin
select @okref = null
if @modulo = 'vtas' select @okref = min(d.articulo) from ventad d with (nolock), art a with (nolock) where d.id = @id and d.articulo = a.articulo and a.estatus = 'bloqueado' else
if @modulo = 'coms' select @okref = min(d.articulo) from comprad d with (nolock), art a with (nolock) where d.id = @id and d.articulo = a.articulo and a.estatus = 'bloqueado'
if @okref is not null select @ok = 26110
end
end
if @movtipo = 'vtas.cto'
if exists(select * from venta with (nolock) where id = @id and (convigencia=0 or vigenciadesde is null or vigenciahasta is null or vigenciahasta < vigenciadesde))
select @ok = 10095
if @movtipo = 'prod.e' and @accion not in ('generar', 'cancelar') and @ok is null
if exists(select * from prodd with (nolock) where id = @id and nullif(rtrim(tipo), '') is null) select @ok = 25390
if @movtipo in ('coms.f', 'coms.fl', 'coms.eg', 'coms.ei') and @accion not in ('generar', 'cancelar') and @ok is null
and (@autorizacion is null or @mensaje not in (20900, 20901))
begin
exec spcompravalidarpresupuesto @empresa, @id, @fechaemision, @ok output, @okref output
if @ok is not null select @autorizar = 1
end
return
end