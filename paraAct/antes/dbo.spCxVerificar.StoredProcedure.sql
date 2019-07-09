create procedure [dbo].[spcxverificar]
@id int,
@accion char(20),
@empresa char(5),
@usuario char(10),
@autorizacion char(10),
@mensaje int,
@modulo char(5),
@mov char(20),
@movid varchar(20),
@movtipo char(20),
@movmoneda char(10),
@movtipocambio float,
@fechaemision datetime,
@condicion varchar(50) output,
@vencimiento datetime output,
@formapa varchar(50),
@referencia varchar(50),
@contacto char(10),
@contactotipo char(20),
@contactoenviara int,
@contactomoneda char(10),
@contactofactor float,
@contactotipocambio float,
@importe money,
@valescobrados money,
@impuestos money,
@retencion money,
@retencion2 money,
@retencion3 money,
@saldo money,
@ctadinero char(10),
@agente char(10),
@aplicamanual bit,
@condesglose bit,
@cobrodesglosado money,
@cobrodelefectivo money,
@cobrocambio money,
@indirecto bit,
@conexion bit,
@sincrofinal bit,
@sucursal int,
@sucursaldestino int,
@sucursalorigen int,
@estatusnuevo char(15),
@afectarcantidadpendiente bit,
@afectarcantidada bit,
@cfgcontx bit,
@cfgcontxgenerar char(20),
@cfgembarcar bit,
@autoajuste money,
@autoajustemov money,
@cfgdescuentorecars bit,
@cfgformacobroda varchar(50),
@cfgrefinanciamientotasa float,
@cfganticiposfacturados bit,
@cfgvalidarppmorosos bit,
@cfgac bit,
@pagares bit,
@origentipo char(10),
@origenmovtipo char(20),
@movaplica char(20),
@movaplicaid varchar(20),
@movaplicamovtipo char(20),
@agentenomina bit,
@redondeomonetarios int,
@autorizar bit output,
@ok int output,
@okref varchar(255) output,
@instrucciones_esp varchar(20) = null
as begin
declare
@da bit,
@aplicamov char(20),
@aplicamovid varchar(20),
@aplicasaldo money,
@aplicaimportetotal money,
@aplicacontacto char(10),
@aplicamoneda char(10),
@aplicaaforo money,
@movaplicaestatus char(15),
@contactoimporte money,
@cantsaldo money,
@importetotal money,
@importeaplicado money,
@efectivo money,
@anticipos money,
@ctadineromoneda char(10),
@ctadinerotipo char(20),
@tienedescuentorecars bit,
@aplicaposfechado bit,
@contactoestatus char(15),
@valeestatus char(15),
@aforoimporte money,
@tarjetascobradas money,
@formacobrotarjetas varchar(50),
@importe1 money,
@importe2 money,
@importe3 money,
@importe4 money,
@importe5 money,
@formacobro1 varchar(50),
@formacobro2 varchar(50),
@formacobro3 varchar(50),
@formacobro4 varchar(50),
@formacobro5 varchar(50)
select @aplicaposfechado = 0,
@autorizar = 0,
@aforoimporte = 0.0,
@da = 0
if @movtipo in ('cxc.vv', 'cxc.ov', 'cxc.dv', 'cxc.av', 'cxc.sd', 'cxc.sch', 'cxp.sd', 'cxp.sch') and @conexion = 0 select @ok = 60160
if @movtipo not in ('cxc.c','cxc.cd','cxc.d','cxc.dm','cxc.a','cxc.ra','cxc.ar','cxc.aa','cxc.de','cxc.f','cxc.fa','cxc.dfa','cxc.af','cxc.ca','cxc.vv','cxc.ov','cxc.im','cxc.rm','cxc.nc','cxc.dv','cxc.ncp','cxc.cap',
'cxp.a','cxp.aa','cxp.de','cxp.f','cxp.af','cxp.ca','cxp.nc','cxp.ncp','cxp.cap','cxp.ncf',
'agent.p','agent.co','cxc.fac','cxp.fac') and @impuestos <> 0.0
select @ok = 20870
if @accion = 'cancelar'
begin
if @indirecto = 1 and @conexion = 0 select @ok = 60180
if @origenmovtipo = 'cxc.ncf' and @conexion = 0 select @ok = 60180
if @movtipo in ('cxc.f', 'cxc.ca', 'cxc.cap', 'cxc.cad', 'cxc.d', 'cxc.dm', 'cxp.f', 'cxp.ca', 'cxp.cap', 'cxp.cad', 'cxp.d', 'cxp.dm') and @condicion is not null
begin
if @cfgac = 1 or exists(select * from condicion where condicion = @condicion and da = 1)
begin
exec spcxcancelardocauto @empresa, @usuario, @modulo, @id, @mov, @movid, 1, null, @ok output, @okref output
if @ok is null select @da = 1
end
end
if @da=0 and @movtipo in ('cxc.f','cxc.fa','cxc.fac','cxc.dac','cxc.af','cxc.ca', 'cxc.cad','cxc.cap','cxc.vv','cxc.ov','cxc.im','cxc.rm','cxc.d','cxc.dm','cxc.da','cxc.dp', 'cxc.cd',
'cxp.f','cxp.af','cxp.fac','cxp.dac','cxp.ca','cxp.cad','cxp.cap','cxp.d','cxp.dm','cxp.pag','cxp.da','cxp.dp', 'cxp.cd', 'cxp.fac',
'agent.c', 'agent.d', 'agent.a', 'cxc.a','cxc.ar','cxc.nc','cxc.ncd','cxc.ncf','cxc.dv','cxc.ncp','cxp.a','cxp.nc','cxp.ncd','cxp.ncf','cxp.ncp',
'cxc.sd', 'cxc.sch', 'cxp.sd', 'cxp.sch')
begin
if not (@movtipo = 'cxc.ov' and @conexion = 1)
begin
if @movmoneda = @contactomoneda
begin
if round(@saldo + @aforoimporte, 2) <> round(@importe + @impuestos - @retencion - @retencion2 - @retencion3, 2) select @ok = 60060
end else
begin
if round((@saldo + @aforoimporte) * @contactotipocambio, 2) <> round((@importe + @impuestos - @retencion - @retencion2 - @retencion3) * @movtipocambio, 2) select @ok = 60060
end
end
if @ok is not null and @movtipo in ('cxc.ca','cxc.cad','cxc.cap','cxc.a','cxc.ar','cxc.nc','cxc.ncd','cxc.ncf','cxc.dv','cxc.ncp',
'cxp.ca','cxp.cad','cxp.cap','cxp.a','cxp.nc','cxp.ncd','cxp.ncf','cxp.ncp')
begin
if @modulo = 'cxc' and exists (select * from cxc c , cxcd d where c.id = @id and c.aplicamanual = 1 and c.id = d.id) select @ok = null else
if @modulo = 'cxp' and exists (select * from cxp c , cxpd d where c.id = @id and c.aplicamanual = 1 and c.id = d.id) select @ok = null
end
if @origentipo in ('pagare','pp/recar' ,'retencion') and @conexion = 0 select @ok = 60072
if @origentipo = 'endoso' and @conexion = 0 select @ok = 60070
end
if @movtipo = 'cxc.fa'
begin
select @cantsaldo = 0.0
select @cantsaldo = sum(isnull(round(saldo, @redondeomonetarios), 0.0)) from saldo where rama = 'cant' and empresa = @empresa and moneda = @movmoneda and cuenta = @contacto
if round(@importe + @impuestos - @retencion - @retencion2 - @retencion3, @redondeomonetarios) > @cantsaldo
select @ok = 30410
end
if @conexion = 0
begin
if @origenmovtipo is not null
begin
if @movtipo in ('cxc.f','cxc.ca', 'cxc.fa','cxc.af','cxc.a','cxc.ar','cxc.nc','cxc.ncd','cxc.ncf','cxc.dv','cxc.ncp','cxc.aje', 'cxp.f','cxp.af','cxp.a','cxp.nc','cxp.ncd','cxp.ncf','cxp.ncp','cxp.aje', 'agent.c', 'agent.d')
if exists (select * from movflujo where cancelado = 0 and empresa = @empresa and dmodulo = @modulo and did = @id and omodulo <> dmodulo)
select @ok = 60070
if @movtipo in ('cxc.a', 'cxc.ar', 'cxp.a') and @origenmovtipo is not null
select @ok = 60070
end
end
end else
begin
if @movtipo in ('cxc.re', 'cxp.re') and @origentipo <> 'auto/re' select @ok = 25410
if @modulo = 'cxc' select @contactoestatus = estatus from cte where cliente = @contacto else
if @modulo = 'cxp' select @contactoestatus = estatus from prov where proveedor = @contacto else
if @modulo = 'agent' select @contactoestatus = estatus from agente where agente = @contacto
if @modulo = 'cxp' and @contactoestatus = 'bloqueado' and @autorizacion is null
begin
select @ok = 65032, @okref = @contacto, @autorizar = 1
exec xpok_65032 @empresa, @usuario, @accion, @modulo, @id, @ok output, @okref output
end
if @movmoneda = @contactomoneda and @movtipocambio <> @contactotipocambio and @movtipo not in ('cxc.ncf', 'cxp.ncf') select @ok = 35110
if @contacto is null
if @modulo = 'cxc' select @ok = 40010 else select @ok = 40020
if @movtipo in ('cxc.fa','cxc.af','cxc.de','cxc.di','cxc.anc','cxc.aca','cxp.aca','cxc.ra','cxc.fac','cxc.dac','cxc.aje','cxc.ajr', 'cxc.da', 'cxp.af','cxp.de','cxp.anc','cxp.ra','cxp.fac','cxp.dac','cxp.aje','cxp.ajr', 'cxp.da')
and @movmoneda <> @contactomoneda
select @ok = 30080
if @movtipo in ('cxc.f','cxc.fa','cxc.af','cxc.ca', 'cxc.cad','cxc.cap','cxc.vv','cxc.cd','cxc.d','cxc.dm','cxc.da','cxc.dp','cxc.ncp', 'cxp.f','cxp.af','cxp.ca', 'cxp.cad','cxp.cap','cxp.cd','cxp.d','cxp.dm', 'cxp.pag','cxp.da','cxp.dp','cxp.ncp')
exec spverificarvencimiento @condicion, @vencimiento, @fechaemision, @ok output
if @movtipo = 'cxc.c' and @condesglose = 1
begin
if @cobrocambio > @cobrodesglosado select @ok = 30250 else
if @cobrodelefectivo < 0.0 select @ok = 30100
end
if @movtipo in ('cxc.ae','cxc.de', 'cxp.ae','cxp.de') or (@movtipo = 'cxc.c' and @condesglose = 1 and @cobrodelefectivo > 0.0)
begin
select @efectivo = 0.0
if @modulo = 'cxc'
begin
select @efectivo = isnull(saldo, 0.0) from cxcefectivo where empresa = @empresa and cliente = @contacto and moneda = @movmoneda
if @movtipo = 'cxc.c'
begin
if round(@cobrodelefectivo, 0) > round(-@efectivo, 0) select @ok = 30090
end else
if round(@importe, 0) > round(-@efectivo, 0) and @movtipo not in ('cxc.de', 'cxp.de') select @ok = 30090
end else
if @modulo = 'cxp'
begin
select @efectivo = isnull(saldo, 0.0) from cxpefectivo where empresa = @empresa and proveedor = @contacto and moneda = @movmoneda
if round(@importe, 0) < round(@efectivo, 0) select @ok = 30090
end
end
if @movtipo = 'cxc.fa' and @cfganticiposfacturados = 0 select @ok = 70070
if @movtipo = 'cxp.pag' and @pagares = 0 select @ok = 30560
if @ok is not null return
if (@importe + @impuestos - @retencion - @retencion2 - @retencion3 < 0.0 or round(@importe, 2) < 0.0 or round(@impuestos, 2) < 0.0) and @movtipo not in ('cxc.aje', 'cxc.ajr', 'cxc.ajm', 'cxc.aja', 'cxp.aje', 'cxp.ajr', 'cxp.ajm', 'cxp.aja', 'agent.p',
'agent.co', 'agent.c','agent.d', 'cxc.re', 'cxp.re') select @ok = 30100
select @importetotal = @importe + @impuestos - @retencion - @retencion2 - @retencion3
if @movtipo in ('cxc.anc', 'cxc.aca', 'cxp.aca', 'cxc.ra', 'cxc.fac', 'cxc.dac', 'cxp.anc', 'cxp.ra', 'cxp.fac', 'cxp.dac') and @accion <> 'cancelar'
begin
if @movaplica is null or @movaplicaid is null select @ok = 30170
if @ok is null
begin
if @modulo = 'cxc' select @aplicasaldo = isnull(saldo, 0.0), @aplicaimportetotal = isnull(importe, 0.0) + isnull(impuestos, 0.0), @aplicamoneda = clientemoneda, @aplicacontacto = cliente, @movaplicaestatus = estatus from cxc where empresa = @empresa and mov = @movaplica and movid = @movaplicaid and estatus not in ('sinafectar', 'confirmar', 'borrador', 'cancelado') else
if @modulo = 'cxp' select @aplicasaldo = isnull(saldo, 0.0), @aplicaimportetotal = isnull(importe, 0.0) + isnull(impuestos, 0.0), @aplicaaforo = isnull(aforo, 0.0), @aplicamoneda = proveedormoneda, @aplicacontacto = proveedor, @movaplicaestatus = estatus
from cxp where empresa = @empresa and mov = @movaplica and movid = @movaplicaid and estatus not in ('sinafectar', 'confirmar', 'borrador', 'cancelado')
if @importetotal > @aplicasaldo select @ok = 30180 else
if @movaplicaestatus <> 'pendiente' select @ok = 30190 else
if @movmoneda <> @aplicamoneda select @ok = 20196 else
if @movtipo in ('cxc.anc', 'cxc.aca', 'cxp.aca', 'cxp.anc') and @contacto <> @aplicacontacto select @ok = 30192 else
if @movtipo in ('cxc.ra', 'cxp.ra') and @contacto = @aplicacontacto select @ok = 30500 else
if @movtipo in ('cxc.fac', 'cxc.dac', 'cxp.fac', 'cxp.dac')
begin
if (@contacto = @aplicacontacto) select @ok = 30505
end
end
end
if @movtipo in ('cxc.cd', 'cxp.cd') and @ctadinero is null select @ok = 40030
if @movtipo in ('cxc.ra', 'cxp.ra') and @movaplicamovtipo not in ('cxc.a', 'cxc.ar', 'cxp.a') select @ok = 20198
if @movtipo = 'agent.a' and @agentenomina = 1 select @ok = 30360
if @movtipo in ('cxc.c','cxc.a','cxc.ar','cxc.aa','cxc.de','cxc.di','cxc.dc',
'cxp.p','cxp.a','cxp.aa','cxp.de','cxp.dc','cxc.dfa',
'agent.p','agent.co','agent.a') and @ctadinero is not null and @ok is null
begin
select @ctadineromoneda = moneda, @ctadinerotipo = tipo from ctadinero where ctadinero = @ctadinero
if @ctadinerotipo <> 'caja' and @movmoneda <> @ctadineromoneda select @ok = 30200
end
if ((@movtipo in ('cxc.c','cxc.ajm','cxc.aja','cxc.net','cxc.nc','cxc.ncd','cxc.ca','cxc.cad','cxc.cap','cxc.ncf','cxc.dv','cxc.ncp','cxc.d','cxc.dm','cxc.da','cxc.dp','cxc.ae','cxc.anc','cxc.aca','cxp.aca','cxc.dc',
'cxp.p','cxp.ajm','cxp.aja','cxp.net','cxp.nc','cxp.ncd','cxp.ca','cxp.cad','cxp.cap','cxp.ncf','cxp.ncp','cxp.d','cxp.dm', 'cxp.pag','cxp.da','cxp.dp','cxp.ae','cxp.anc','cxp.dc') and @aplicamanual = 1) or
(@movtipo in ('cxc.im', 'cxc.rm', 'agent.p','agent.co')))
and @accion in ('afectar', 'verificar') and @ok is null
begin
exec spcxaplicar @id, @accion, @empresa, @usuario, @modulo, @mov, null, @movtipo, @movmoneda, @movtipocambio,
null, null, null, @condicion output, @vencimiento output, null, @fechaemision, null, null, null,
@contacto, @contactoenviara, @contactomoneda, @contactofactor, @contactotipocambio, @agente, @importe, @impuestos, @retencion, @retencion2, @retencion3, @importetotal,
@conexion, @sincrofinal, @sucursal, @sucursaldestino, @sucursalorigen, @origentipo, @origenmovtipo, @movaplica, @movaplicaid, @movaplicamovtipo,
@cfgcontx, @cfgcontxgenerar, @cfgembarcar, @autoajuste, @autoajustemov, @cfgdescuentorecars, @cfgrefinanciamientotasa,
0, null, null, 0, null,
0, null, null, null, null, null, null, null, @cfgac,
1, @tienedescuentorecars output, @aplicaposfechado output, @importeaplicado output,
@redondeomonetarios, @ok output, @okref output
if @ok is null and @cfgvalidarppmorosos = 1
if exists(select * from cxcd where id = @id and isnull(descuentorecars, 0) < 0.0)
if exists(select *
from cxcpendiente p , movtipo mt where p.empresa = @empresa
and p.cliente = @contacto
and mt.modulo = 'cxc' and mt.mov = p.mov and mt.clave not in ('cxc.a', 'cxc.ar', 'cxc.nc', 'cxc.ncd','cxc.ncf')
and isnull(p.diasmoratorios, 0) > 0)
select @ok = 65090
end
if @aplicaposfechado = 1
begin
if @movtipo in ('cxc.c','cxp.p')
begin
if round(@importeaplicado, @redondeomonetarios)<>round(@importetotal, @redondeomonetarios) select @ok = 30230 else
if @modulo = 'cxc' if (select count(*) from cxcd where id = @id) > 1 select @ok = 30390 else
if @modulo = 'cxp' if (select count(*) from cxpd where id = @id) > 1 select @ok = 30390
end else
select @ok = 30380
end
select @formacobrotarjetas = cxcformacobrotarjetas from empresacfg where empresa = @empresa
select @tarjetascobradas = 0.0
select @condesglose = condesglose,
@importe1 = isnull(importe1, 0), @formacobro1 = formacobro1,
@importe2 = isnull(importe2, 0), @formacobro2 = formacobro2,
@importe3 = isnull(importe3, 0), @formacobro3 = formacobro3,
@importe4 = isnull(importe4, 0), @formacobro4 = formacobro4,
@importe5 = isnull(importe5, 0), @formacobro5 = formacobro5
from cxc where id = @id
if @condesglose = 0 and @importetotal > 0.0 and @formapa = @formacobrotarjetas
begin
select @tarjetascobradas = @importetotal, @formacobro1 = @formapa
end
else
begin
if @formacobro1 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe1
if @formacobro2 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe2
if @formacobro3 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe3
if @formacobro4 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe4
if @formacobro5 = @formacobrotarjetas select @tarjetascobradas = @tarjetascobradas + @importe5
end
if @valescobrados > 0.0 or @tarjetascobradas > 0.0
begin
if @movtipo in ('cxc.a', 'cxc.ar', 'cxc.aa', 'cxc.c')
exec spvalevalidarcobro @empresa, @modulo, @id, @accion, @fechaemision, @valescobrados, @tarjetascobradas, @movmoneda, @ok output, @okref output
else
select @ok = 36100, @okref = @formapa
end
if @movtipo in ('cxc.a','cxc.ar','cxc.aa','cxc.c') and upper(@formapa) = upper(@cfgformacobroda) and @accion <> 'cancelar' and @condesglose = 0 and @ok is null
if (select cxcdaref from empresacfg where empresa = @empresa) = 0
if not exists (select * from dinero where empresa = @empresa and estatus = 'pendiente' and ctadinero = @ctadinero and round(importe, @redondeomonetarios) = round(@importetotal, @redondeomonetarios) and moneda = @movmoneda)
begin
select @okref = null
select @okref = min(ctadinero) from dinero where empresa = @empresa and estatus = 'pendiente' and round(importe, @redondeomonetarios) = round(@importetotal, @redondeomonetarios) and moneda = @movmoneda
if @okref is null
select @ok = 35160
else select @ok = 35165
end
if @movtipo in ('agent.p','agent.co') and round(@importeaplicado, @redondeomonetarios) < 0.0 select @ok = 30100
end
if @accion not in ('generar', 'cancelar') and @ok is null
exec spvalidarmovimportemaximo @usuario, @modulo, @mov, @id, @ok output, @okref output
if @ok is null
exec xpcxverificar @id, @accion, @empresa, @usuario, @modulo, @mov, @movid, @movtipo, @movmoneda, @movtipocambio,
@fechaemision, @condicion, @vencimiento, @formapa, @contacto, @contactomoneda, @contactofactor, @contactotipocambio, @importe, @impuestos, @saldo, @ctadinero, @aplicamanual, @condesglose,
@cobrodesglosado, @cobrodelefectivo, @cobrocambio,
@indirecto, @conexion, @sincrofinal, @sucursal, @estatusnuevo, @afectarcantidadpendiente, @afectarcantidada, @cfgcontx, @cfgcontxgenerar, @cfgembarcar, @autoajuste, @cfgformacobroda, @cfgrefinanciamientotasa,
@movaplica, @movaplicaid, @ok output, @okref output
return
end