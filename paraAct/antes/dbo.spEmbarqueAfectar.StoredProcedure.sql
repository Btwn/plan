create procedure [dbo].[spembarqueafectar]
@id int,
@accion char(20),
@empresa char(5),
@modulo char(5),
@mov char(20),
@movid varchar(20) output,
@movtipo char(20),
@fechaemision datetime,
@fechaafectacion datetime,
@fechaconclusion datetime,
@proyecto varchar(50),
@usuario char(10),
@autorizacion char(10),
@docfuente int,
@observaciones varchar(255),
@referencia varchar(50),
@concepto varchar(50),
@estatus char(15),
@estatusnuevo char(15),
@fecharegistro datetime,
@ejercicio int,
@periodo int,
@fechasalida datetime,
@fecharetorno datetime,
@vehiculo char(10),
@personalcobrador varchar(10),
@conexion bit,
@sincrofinal bit,
@sucursal int,
@sucursaldestino int,
@sucursalorigen int,
@antecedenteid int,
@antecedentemovtipo char(20),
@ctadinero char(10),
@cfgafectarcobros bit,
@cfgmodificarvencimiento bit,
@cfgestadotransito varchar(50),
@cfgestadopendiente varchar(50),
@cfggastotarifa bit,
@cfgafectargastotarifa bit,
@cfgbaseprorrateo varchar(20),
@cfgdesembarquesparciales bit,
@cfgcontx bit,
@cfgcontxgenerar char(20),
@generarpoliza bit,
@generarmov char(20),
@idgenerar int output,
@generarmovid varchar(20) output,
@ok int output,
@okref varchar(255) output
as begin
declare
@generar bit,
@generarafectado bit,
@generarmodulo char(5),
@generarmovtipo char(20),
@generarestatus char(15),
@generarperiodo int,
@generarejercicio int,
@embarquemov int,
@embarquemovid int,
@estado char(30),
@estadotipo char(20),
@fechahora datetime,
@importe money,
@forma varchar(50),
@detallereferencia varchar(50),
@detalleobservaciones varchar(100),
@movmodulo char(5),
@movmoduloid int,
@movmov char(20),
@movmovid varchar(20),
@movmovtipo char(20),
@movestatus char(15),
@movmoneda char(10),
@movcondicion varchar(50),
@movvencimiento datetime,
@movimporte money,
@movimpuestos money,
@movtipocambio float,
@movporcentaje float,
@peso float,
@aplicaimporte money,
@volumen float,
@paquetes int,
@cliente char(10),
@proveedor char(10),
@clienteproveedor char(10),
@clienteenviara int,
@agente char(10),
@sumapeso float,
@sumavolumen float,
@sumapaquetes int,
@sumaimportepesos money,
@sumaimpuestospesos money,
@sumaimporteembarque money,
@fechacancelacion datetime,
@antecedenteestatus char(15),
@generaraccion char(20),
@dias int,
@cxmodulo char(5),
@cxmov char(20),
@cxmovid varchar(20),
@ctemodificarvencimiento varchar(20),
@enviaramodificarvencimiento varchar(20),
@modificarvencimiento bit,
@gastoanexototalpesos money,
@diaretorno datetime,
@tienependientes bit
select @generar = 0,
@generarafectado = 0,
@idgenerar = null,
@generarmodulo = null,
@generarmovid = null,
@generarmovtipo = null,
@generarestatus = 'sinafectar',
@tienependientes = 0
if @cfgdesembarquesparciales = 1 and @movtipo in ('emb.e', 'emb.oc') and @estatusnuevo = 'concluido'
begin
if exists(select d.id from embarqued d join embarquemov m on d.embarquemov=m.id join embarqueestado e on d.estado=e.estado where d.id = @id and upper(e.tipo)='pendiente' and d.desembarqueparcial = 0)
select @tienependientes = 1, @estatusnuevo = 'pendiente'
end
exec spmovconsecutivo @sucursal, @sucursalorigen, @sucursaldestino, @empresa, @usuario, @modulo, @ejercicio, @periodo, @id, @mov, null, @estatus, @concepto, @accion, @conexion, @sincrofinal, @movid output, @ok output, @okref output
if @estatus in ('sinafectar', 'borrador', 'confirmar') and @accion <> 'cancelar' and @ok is null
begin
exec spmovchecarconsecutivo @empresa, @modulo, @mov, @movid, null, @ejercicio, @periodo, @ok output, @okref output
end
if @accion in ('consecutivo', 'sincro') and @ok is null
begin
if @accion = 'sincro' exec spasignarsucursalestatus @id, @modulo, @sucursaldestino, @accion
select @ok = 80060, @okref = @movid
return
end
if @accion = 'generar' and @ok is null
begin
exec spmovgenerar @sucursal, @empresa, @modulo, @ejercicio, @periodo, @usuario, @fecharegistro, @generarestatus,
null, null,
@mov, @movid, 0,
@generarmov, null, @generarmovid output, @idgenerar output, @ok output, @okref output
exec spmovtipo @modulo, @generarmov, @fechaafectacion, @empresa, null, null, @generarmovtipo output, @generarperiodo output, @generarejercicio output, @ok output
if @@error <> 0 select @ok = 1
if @ok is null select @ok = 80030
return
end
if @ok is not null return
if @conexion = 0
begin transaction
exec spmovestatus @modulo, 'afectando', @id, @generar, @idgenerar, @generarafectado, @ok output
if @accion = 'afectar' and @estatus in ('sinafectar', 'borrador', 'confirmar')
if (select sincro from version ) = 1
exec sp_executesql n'update embarqued set sucursal = @sucursal, sincroc = 1 where id = @id and (sucursal <> @sucursal or sincroc <> 1)', n'@sucursal int, @id int', @sucursal, @id
if @accion <> 'cancelar'
exec spregistrarmovimiento @sucursal, @empresa, @modulo, @mov, @movid, @id, @ejercicio, @periodo, @fecharegistro, @fechaemision,
null, @proyecto, null, null,
@usuario, @autorizacion, null, @docfuente, @observaciones,
@generar, @generarmov, @generarmovid, @idgenerar,
@ok output
select @sumapeso = 0.0,
@sumavolumen = 0.0,
@sumapaquetes = 0.0,
@sumaimportepesos = 0.0,
@sumaimpuestospesos = 0.0,
@sumaimporteembarque= 0.0
declare crembarque cursor for
select nullif(d.embarquemov, 0), d.estado, d.fechahora, nullif(rtrim(d.forma), ''), isnull(d.importe, 0.0), nullif(rtrim(d.referencia), ''), nullif(rtrim(d.observaciones), ''),
m.id, m.modulo, m.moduloid, m.mov, m.movid, m.importe, m.impuestos, m.moneda, m.tipocambio, isnull(m.peso, 0.0), isnull(m.volumen, 0.0), isnull(d.paquetes, 0),
nullif(rtrim(m.cliente), ''), nullif(rtrim(m.proveedor), ''), m.clienteenviara, upper(e.tipo), isnull(d.movporcentaje, 0)
from embarqued d
join embarquemov m on d.embarquemov = m.id
left outer join embarqueestado e on d.estado = e.estado
where d.id = @id and d.desembarqueparcial = 0
open crembarque
fetch next from crembarque into @embarquemov, @estado, @fechahora, @forma, @importe, @detallereferencia, @detalleobservaciones, @embarquemovid, @movmodulo, @movmoduloid, @movmov, @movmovid, @movimporte, @movimpuestos, @movmoneda, @movtipocambio, @peso, @volumen, @paquetes, @cliente, @proveedor, @clienteenviara, @estadotipo, @movporcentaje
if @@error <> 0 select @ok = 1
if @@fetch_status = -1 select @ok = 60010
while @@fetch_status <> -1 and @ok is null
begin
if @accion = 'afectar' and @movtipo = 'emb.oc' and @movmodulo = 'cxc' and @estadotipo = 'cobrado'
if @importe < isnull((select saldo from cxc where id = @movmoduloid), 0)
select @estadotipo = 'cobro parcial'
if @@fetch_status <> -2 and @embarquemov is not null and @ok is null
begin
if @movtipo in ('emb.e', 'emb.oc')
begin
if @accion = 'afectar' and @estatus = 'sinafectar'
begin
if @movtipo = 'emb.oc' and @movmodulo = 'cxc'
update cxc set personalcobrador = @personalcobrador where id = @movmoduloid and isnull(personalcobrador, '') <> @personalcobrador
update embarqued set estado = @cfgestadotransito where current of crembarque
update embarquemov set movporcentaje = isnull(movporcentaje, 0) + @movporcentaje where id = @embarquemovid
end
if @accion = 'cancelar'
begin
update embarqued set estado = @cfgestadopendiente where current of crembarque
update embarquemov set movporcentaje = isnull(movporcentaje, 0) - @movporcentaje where id = @embarquemovid
end
if @movmodulo = 'vtas' and @movtipo = 'emb.e' and ((@accion = 'afectar' and @estatus = 'sinafectar') or (@accion = 'cancelar' and (@estatus = 'pendiente' or @estadotipo <> 'desembarcar')) or (@estadotipo = 'desembarcar' and @accion = 'afectar'))
begin
update ventad set cantidadembarcada = case when @accion = 'cancelar' or @estadotipo = 'desembarcar' then isnull(d.cantidadembarcada, 0) - isnull(e.cantidad, 0) else isnull(d.cantidadembarcada, 0) + isnull(e.cantidad , 0) end
from embarquedart e , ventad d
where e.id = @id and e.embarquemov = @embarquemov and e.modulo = 'vtas' and e.moduloid = d.id and e.renglon = d.renglon and e.renglonsub = d.renglonsub
if exists(select e.id from embarquedart e join ventad d on e.moduloid = d.id where e.id = @id and e.embarquemov = @embarquemov and e.modulo = 'vtas' and d.cantidadembarcada <> d.cantidad-isnull(d.cantidadcancelada, 0))
update embarquemov set asignadoid = null where id = @embarquemov
end
if (@accion = 'afectar' and @estatus = 'pendiente') or (@accion = 'cancelar' and @estatus = 'concluido')
begin
select @generaraccion = @accion
select @movmovtipo = null, @movestatus = null, @agente = null
select @movmovtipo = clave from movtipo where modulo = @movmodulo and mov = @movmov
if @movmodulo = 'vtas'
begin
select @movestatus = estatus, @agente = agente, @movcondicion = condicion, @movvencimiento = vencimiento from venta where id = @movmoduloid
if @estadotipo in ('entregado', 'cobrado') and @fechahora is not null and @accion <> 'cancelar' and @ok is null
begin
select @modificarvencimiento = @cfgmodificarvencimiento
select @ctemodificarvencimiento = isnull(upper(modificarvencimiento), '(empresa)')
from cte where cliente = @cliente
if @ctemodificarvencimiento = 'si' select @modificarvencimiento = 1 else
if @ctemodificarvencimiento = 'no' select @modificarvencimiento = 0
if nullif(@clienteenviara, 0) is not null
begin
select @enviaramodificarvencimiento = rtrim(upper(modificarvencimiento))
from cteenviara where cliente = @cliente and id = @clienteenviara
if @enviaramodificarvencimiento = 'si' select @modificarvencimiento = 1 else
if @enviaramodificarvencimiento = 'no' select @modificarvencimiento = 0
end
if @modificarvencimiento = 1
exec spembarquemodificarvencimiento @fechahora, @empresa, @movmoduloid, @movmov, @movmovid, @movcondicion, @movvencimiento, @ok output
end
end else
if @movmodulo = 'inv' select @movestatus = estatus from inv where id = @movmoduloid else
if @movmodulo = 'coms' select @movestatus = estatus from compra where id = @movmoduloid else
if @movmodulo = 'cxc' select @movestatus = estatus from cxc where id = @movmoduloid else
if @movmodulo = 'din' select @movestatus = estatus from dinero where id = @movmoduloid
if ((@accion <> 'cancelar' and (@estadotipo = 'desembarcar')) or (@estadotipo = 'cobro parcial' and @movtipo = 'emb.oc')) or (@accion = 'cancelar' and @estatus = 'concluido' and @estadotipo <> 'desembarcar')
begin
update embarquemov set asignadoid = null where id = @embarquemov
end
if @estadotipo = 'entregado'
begin
if @movmovtipo in ('din.ch', 'din.che') and @movestatus = 'pendiente'
exec spdinero @movmoduloid, @movmodulo, 'afectar', 'todo', @fecharegistro, null, @usuario, 1, 0,
@generarmov, @generarmovid, @idgenerar,
@ok output, @okref output
end
if @estadotipo in ('cobrado', 'cobro parcial', 'pagado')
begin
select @clienteproveedor = null
if @estadotipo in ('cobrado', 'cobro parcial')
begin
select @clienteproveedor = @cliente
if @cfgafectarcobros = 0 and @accion <> 'cancelar' select @generaraccion = 'generar'
end else
if @estadotipo = 'pagado' select @clienteproveedor = @proveedor
if @clienteproveedor is not null
begin
if @importe>@movimporte select @aplicaimporte = isnull(@movimporte, 0.0) + isnull(@movimpuestos, 0.0) else select @aplicaimporte = @importe
exec spgenerarcx @sucursal, @sucursalorigen, @sucursaldestino, @generaraccion, null, @empresa, @modulo, @id, @mov, @movid, null, @movmoneda, @movtipocambio,
@fechaemision, null, @proyecto, @usuario, null,
@detallereferencia, null, null, @fecharegistro, @ejercicio, @periodo,
null, null, @clienteproveedor, @clienteenviara, @agente, @estado, @ctadinero, @forma,
@importe, null, null, null,
null, @movmov, @movmovid, @aplicaimporte, null, null,
@generarmodulo, @generarmov, @generarmovid,
@ok output, @okref output, @personalcobrador = @personalcobrador
end
end
if @ok = 80030 select @ok = null, @okref = null
if @estadotipo in ('entregado', 'cobrado') and @accion <> 'cancelar'
begin
if @movmodulo = 'vtas' update venta set fechaentrega = @fechahora where id = @movmoduloid else
if @movmodulo = 'coms' update compra set fechaentrega = @fechahora where id = @movmoduloid else
if @movmodulo = 'inv' update inv set fechaentrega = @fechahora where id = @movmoduloid else
if @movmodulo = 'cxc' update cxc set fechaentrega = @fechahora where id = @movmoduloid else
if @movmodulo = 'din' update dinero set fechaentrega = @fechahora where id = @movmoduloid
end
end else
begin
exec spmovflujo @sucursal, @accion, @empresa, @movmodulo, @movmoduloid, @movmov, @movmovid, @modulo, @id, @mov, @movid, @ok output
if @accion = 'cancelar'
update embarquemov set asignadoid = @antecedenteid where id = @embarquemov
end
end
if @tienependientes = 1 and @estadotipo not in ('pendiente', null, '')
update embarqued set desembarqueparcial = 1
where current of crembarque
select @sumapeso = @sumapeso + @peso,
@sumavolumen = @sumavolumen + @volumen,
@sumapaquetes = @sumapaquetes + @paquetes,
@sumaimportepesos = @sumaimportepesos + (@movimporte * @movtipocambio),
@sumaimpuestospesos = @sumaimpuestospesos + (@movimpuestos * @movtipocambio),
@sumaimporteembarque= @sumaimporteembarque+ (((isnull(@movimporte, 0)+isnull(@movimpuestos, 0))*@movtipocambio))*(@movporcentaje/100)
end
fetch next from crembarque into @embarquemov, @estado, @fechahora, @forma, @importe, @detallereferencia, @detalleobservaciones, @embarquemovid, @movmodulo, @movmoduloid, @movmov, @movmovid, @movimporte, @movimpuestos, @movmoneda, @movtipocambio, @peso, @volumen, @paquetes, @cliente, @proveedor, @clienteenviara, @estadotipo, @movporcentaje
if @@error <> 0 select @ok = 1
end
close crembarque
deallocate crembarque
if @cfggastotarifa = 1 and @estatusnuevo = 'concluido' and @accion <> 'cancelar' and @ok is null
begin
exec spgastoanexotarifa @sucursal, @empresa, @modulo, @id, @mov, @movid, @fechaemision, @fecharegistro, @usuario, @cfgafectargastotarifa, @ok output, @okref output
end
if (@estatusnuevo = 'concluido' or @accion = 'cancelar') and @ok is null
begin
exec spgastoanexo @empresa, @modulo, @id, @accion, @fecharegistro, @usuario, @gastoanexototalpesos output, @ok output, @okref output
exec spgastoanexoeliminar @empresa, @modulo, @id
end
if @ok is null
begin
if @tienependientes = 1
update embarque set estatus = @estatusnuevo,
ultimocambio = @fecharegistro
where id = @id
else begin
if @estatusnuevo = 'cancelado' select @fechacancelacion = @fecharegistro else select @fechacancelacion = null
if @estatusnuevo = 'concluido' select @fechaconclusion = @fecharegistro else if @estatusnuevo <> 'cancelado' select @fechaconclusion = null
if @estatusnuevo = 'concluido' and @fecharetorno is null select @fecharetorno = @fecharegistro
select @diaretorno = @fecharetorno
exec spextraerfecha @diaretorno output
if @cfgcontx = 1 and @cfgcontxgenerar <> 'no'
begin
if @estatus = 'sinafectar' and @estatusnuevo <> 'cancelado' select @generarpoliza = 1 else
if @estatus <> 'sinafectar' and @estatusnuevo = 'cancelado' if @generarpoliza = 1 select @generarpoliza = 0 else select @generarpoliza = 1
end
exec spvalidartareas @empresa, @modulo, @id, @estatusnuevo, @ok output, @okref output
update embarque set peso = nullif(@sumapeso, 0.0),
volumen = nullif(@sumavolumen, 0.0),
paquetes = nullif(@sumapaquetes, 0.0),
importe = nullif(@sumaimportepesos, 0.0),
impuestos = nullif(@sumaimpuestospesos, 0.0),
importeembarque = nullif(@sumaimporteembarque, 0.0),
gastos = nullif(@gastoanexototalpesos, 0.0),
fechasalida = @fechasalida,
fecharetorno = @fecharetorno,
diaretorno = @diaretorno,
fechaconclusion = @fechaconclusion,
fechacancelacion = @fechacancelacion,
ultimocambio = @fecharegistro ,
estatus = @estatusnuevo,
situacion = case when @estatus<>@estatusnuevo then null else situacion end,
generarpoliza = @generarpoliza
where id = @id
if @@error <> 0 select @ok = 1
end
if @estatusnuevo = 'concluido'
begin
update embarqued set desembarqueparcial = 0 where id = @id and desembarqueparcial = 1
update embarquemov set gastos = isnull(gastos, 0) + (((e.importe+e.impuestos)*e.tipocambio) * @gastoanexototalpesos) / (@sumaimportepesos + @sumaimpuestospesos)
from embarquemov e, embarqued d where d.id = @id and d.embarquemov = e.id
update embarquemov set concluido = 1
where asignadoid = @id
if @cfgbaseprorrateo = 'importe'
update venta set embarquegastos = isnull(embarquegastos, 0) + (((e.importe+e.impuestos)*e.tipocambio) * @gastoanexototalpesos) / (@sumaimportepesos + @sumaimpuestospesos)
from embarquemov e , embarqued d , venta v
where d.id = @id and d.embarquemov = e.id and e.modulo = 'vtas' and e.moduloid = v.id
else
if @cfgbaseprorrateo = 'paquetes'
update venta set embarquegastos = isnull(embarquegastos, 0) + (e.paquetes * @gastoanexototalpesos) / @sumapaquetes
from embarquemov e , embarqued d , venta v
where d.id = @id and d.embarquemov = e.id and e.modulo = 'vtas' and e.moduloid = v.id
else
if @cfgbaseprorrateo = 'peso'
update venta set embarquegastos = isnull(embarquegastos, 0) + (e.peso * @gastoanexototalpesos) / @sumapeso
from embarquemov e , embarqued d , venta v
where d.id = @id and d.embarquemov = e.id and e.modulo = 'vtas' and e.moduloid = v.id
else
if @cfgbaseprorrateo = 'volumen'
update venta set embarquegastos = isnull(embarquegastos, 0) + (e.volumen * @gastoanexototalpesos) / @sumavolumen
from embarquemov e , embarqued d , venta v
where d.id = @id and d.embarquemov = e.id and e.modulo = 'vtas' and e.moduloid = v.id
else
if @cfgbaseprorrateo = 'peso/volumen'
update venta set embarquegastos = isnull(embarquegastos, 0) + (((isnull(e.peso, 0)*isnull(e.volumen, 0))*e.tipocambio) * @gastoanexototalpesos) / (@sumapeso * @sumavolumen)
from embarquemov e , embarqued d , venta v
where d.id = @id and d.embarquemov = e.id and e.modulo = 'vtas' and e.moduloid = v.id
end
update vehiculo set estatus = case when @estatusnuevo = 'pendiente' then 'entransito' else 'disponible' end
where vehiculo = @vehiculo
if @@error <> 0 select @ok = 1
end
if @vehiculo is not null
begin
if (select tienemovimientos from vehiculo where vehiculo = @vehiculo) = 0
update vehiculo set tienemovimientos = 1 where vehiculo = @vehiculo
end
if @ok is null or @ok between 80030 and 81000
exec spmovfinal @empresa, @sucursal, @modulo, @id, @estatus, @estatusnuevo, @usuario, @fechaemision, @fecharegistro, @mov, @movid, @movtipo, @idgenerar, @ok output, @okref output
if @accion = 'cancelar' and @estatusnuevo = 'cancelado' and @ok is null
exec spcancelarflujo @empresa, @modulo, @id, @ok output
if @conexion = 0
if @ok is null or @ok between 80030 and 81000
commit transaction
else
rollback transaction
return
end