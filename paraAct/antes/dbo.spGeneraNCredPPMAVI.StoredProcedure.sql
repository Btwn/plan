create procedure [dbo].[spgenerancredppmavi]
@id int,
@usuario varchar(10),
@ok int output,
@okref varchar(255) output
as begin
declare
@empresa char(5),
@sucursal int,
@hoy datetime,
@vencimiento datetime,
@moneda char(10),
@tipocambio float,
@contacto char(10),
@renglon float,
@aplica varchar(20),
@aplicaid varchar(20),
@impreal money,
@moratorioapagar money,
@origen varchar(20),
@origenid varchar(20),
@movpadre varchar(20),
@movpadre1 varchar(20),
@movidpadre varchar(20),
@papuntual money,
@uen int,
@movcrear varchar(20),
@mov varchar(20),
@idcxc int,
@fechaaplicacion datetime,
@ctadinero varchar(10),
@concepto varchar(50),
@idpol int,
@numdoctos int,
@impdocto money,
@movid varchar(20),
@totalmov money,
@referencia varchar(100),
@canalventa int,
@impuestos money,
@haynotascredcanc int,
@docspend int,
@sdodoc money,
@imptotalbonif money,
@defimpuesto float,
@idcxc2 int,
@minbon int,
@maxbon int,
@mindet int,
@maxdet int,
@minbon2 int,
@maxbon2 int,
@mindet2 int,
@maxdet2 int
set @docspend = 0
set @fechaaplicacion = getdate()
select @empresa = empresa, @sucursal = sucursal, @hoy = fechaemision, @moneda = moneda, @tipocambio = tipocambio, @contacto = cliente from cxc where id = @id
select @haynotascredcanc = count(*) from neciamoratoriosmavi where idcobro = @id and papuntual > 0 and notacreditoxcanc = '1'
if exists(select id from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crgenbonifp') and type ='u')
drop table #crgenbonifp
create table #crgenbonifp(
id int primary key identity(1,1) not null,
papuntual money null,
origen varchar(25) null,
origenid varchar(25) null,
idpapuntual int null
)
if exists(select id from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crdetncbonifpp') and type ='u')
drop table #crdetncbonifpp
create table #crdetncbonifpp(
id int primary key identity(1,1) not null,
mov varchar(25) null,
movid varchar(25) null,
papuntual money null
)
if exists(select id from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crgenbonifpp2') and type ='u')
drop table #crgenbonifpp2
create table #crgenbonifpp2(
id int primary key identity(1,1) not null,
papuntual money null,
origen varchar(25) null,
origenid varchar(25) null,
idpapuntual int null
)
if exists(select id from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crdetncbonifpp2') and type ='u')
drop table #crdetncbonifpp2
create table #crdetncbonifpp2(
id int primary key identity(1,1) not null,
mov varchar(25) null,
movid varchar(25) null,
papuntual money null
)
if @haynotascredcanc = 0
begin
insert into #crgenbonifp (papuntual,origen,origenid,idpapuntual)
select sum(isnull(papuntual,0)), origen, origenid, idpapuntual
from neciamoratoriosmavi where idcobro = @id and papuntual > 0
group by origen, origenid, idpapuntual
select @minbon=min(id), @maxbon=max(id) from #crgenbonifp
while @minbon <= @maxbon
begin
select @papuntual=papuntual, @origen=origen, @origenid=origenid,@idpol=idpapuntual from #crgenbonifp where id=@minbon
set @imptotalbonif = @papuntual
set @renglon = 1024.0
select @uen = uen, @canalventa = clienteenviara from cxc where mov = @origen and movid = @origenid
select @movpadre = @origen
select @movcrear = isnull(movcrear, 'nota credito') from movcrearbonifmavi where mov = @movpadre and uen = @uen
if @movcrear is null select @movcrear = 'nota credito'
select @concepto = concepto
from mavibonificacionconf where id = @idpol
select @docspend = count(*) from cxc where padremavi = @origen and padreidmavi = @origenid and estatus = 'pendiente'
if @docspend > 0
begin
insert into cxc(empresa, mov, movid, fechaemision, ultimocambio, concepto, proyecto, moneda, tipocambio, usuario, autorizacion, referencia, docfuente,
observaciones, estatus, situacion, situacionfecha, situacionusuario, situacionnota, cliente, clienteenviara, clientemoneda, clientetipocambio,
cobrador, condicion, vencimiento, formacobro, ctadinero, importe, impuestos, retencion, aplicamanual, condesglose, formacobro1, formacobro2,
formacobro3, formacobro4, formacobro5, referencia1, referencia2, referencia3, referencia4, referencia5, importe1, importe2, importe3,
importe4, importe5, cambio, delefectivo, agente, comisiontotal, comisionpendiente, movaplica, movaplicaid, origentipo, origen, origenid,
poliza, polizaid, fechaconclusion, fechacancelacion, dinero, dineroid, dineroctadinero, contramites, vin, sucursal, sucursalorigen, cajero,
uen, personalcobrador, fechaoriginal, nota, comentarios, lineacredito, tipoamortizacion, tipotasa, amortizaciones, comisiones, comisionesiva,
fecharevision, contuso, tienetasaesp, tasaesp, codi)
values (@empresa, @movcrear, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), @fechaaplicacion, @concepto, null, @moneda, @tipocambio, @usuario, null, @referencia, null,
null, 'sinafectar', null, null, null, null, @contacto, @canalventa, @moneda, @tipocambio,
null, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), null, @ctadinero, null, null, null, 1, 0, null, null,
null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, 0, null, @sucursal, @sucursal, null,
@uen, null, null, null, '', null, null, null, null, null, null,
null, null, 0, null, null)
select @idcxc = @@identity
insert into #crdetncbonifpp (mov,movid,papuntual)
select mov, movid, papuntual
from neciamoratoriosmavi where idcobro = @id and papuntual > 0
and origen = @origen and origenid = @origenid
select @mindet=min(id), @maxdet=max(id) from #crdetncbonifpp
while @mindet <= @maxdet
begin
select @mov=mov, @movid=movid, @impdocto=papuntual from #crdetncbonifpp where id=@mindet
select @sdodoc = saldo from cxc where mov = @mov and movid = @movid
if @impdocto > @sdodoc
begin
select @impdocto = @sdodoc
set @imptotalbonif = @imptotalbonif - @impdocto
insert into cxcd(id, renglon, renglonsub, aplica, aplicaid, importe, fecha, sucursal, sucursalorigen, descuentorecars, interesesordinarios,
interesesmoratorios, interesesordinariosquita, interesesmoratoriosquita, impuestoadicional, retencion)
values(@idcxc, @renglon, 0, @mov, @movid, @impdocto, null, @sucursal, @sucursal, null, null, null, null, null, null, null)
set @renglon = @renglon + 1024.0
update neciamoratoriosmavi set notacredbonid = @idcxc
where idcobro = @id
and origen = @origen and origenid = @origenid and idpapuntual = @idpol
end
else
begin
if @impdocto <= @sdodoc
begin
set @imptotalbonif = @imptotalbonif - @impdocto
insert into cxcd(id, renglon, renglonsub, aplica, aplicaid, importe, fecha, sucursal, sucursalorigen, descuentorecars, interesesordinarios,
interesesmoratorios, interesesordinariosquita, interesesmoratoriosquita, impuestoadicional, retencion)
values(@idcxc, @renglon, 0, @mov, @movid, @impdocto, null, @sucursal, @sucursal, null, null, null, null, null, null, null)
set @renglon = @renglon + 1024.0
update neciamoratoriosmavi set notacredbonid = @idcxc
where idcobro = @id
and origen = @origen and origenid = @origenid and idpapuntual = @idpol
end
end
set @mindet = @mindet + 1
end
select @impuestos = sum(d.importe*isnull(ca.ivafiscal,0.00))
from cxcd d join cxcaplica ca on d.aplica = ca.mov and d.aplicaid = ca.movid and ca.empresa = @empresa
where d.id = @idcxc
select @totalmov = sum(d.importe-isnull(d.importe*ca.ivafiscal,0))
from cxcd d join cxcaplica ca on d.aplica = ca.mov and d.aplicaid = ca.movid and ca.empresa = @empresa
where d.id = @idcxc
update cxc set importe = isnull(round(@totalmov,2),0.00),
impuestos = isnull(round(@impuestos,2),0.00),
saldo = isnull(round(@totalmov,2),0.00) + isnull(round(@impuestos,2),0.00),
idcobrobonifmavi = @id
where id = @idcxc
end
if @idcxc > 0
begin
exec spafectar 'cxc', @idcxc, 'afectar', 'todo', null, @usuario, null, 1, @ok output, @okref output,null, @conexion = 1
insert into detalleafectacionmavi( idcobro, id, mov, movid, valorok, valorokref) values(@id, @idcxc, @movcrear, null, @ok, @okref )
end
if @imptotalbonif > 0
begin
select @defimpuesto = defimpuesto from empresagral where empresa = @empresa
insert into cxc(empresa, mov, movid, fechaemision, ultimocambio, concepto, proyecto, moneda, tipocambio, usuario, autorizacion, referencia, docfuente,
observaciones, estatus, situacion, situacionfecha, situacionusuario, situacionnota, cliente, clienteenviara, clientemoneda, clientetipocambio,
cobrador, condicion, vencimiento, formacobro, ctadinero, importe, impuestos, retencion, aplicamanual, condesglose, formacobro1, formacobro2,
formacobro3, formacobro4, formacobro5, referencia1, referencia2, referencia3, referencia4, referencia5, importe1, importe2, importe3,
importe4, importe5, cambio, delefectivo, agente, comisiontotal, comisionpendiente, movaplica, movaplicaid, origentipo, origen, origenid,
poliza, polizaid, fechaconclusion, fechacancelacion, dinero, dineroid, dineroctadinero, contramites, vin, sucursal, sucursalorigen, cajero,
uen, personalcobrador, fechaoriginal, nota, comentarios, lineacredito, tipoamortizacion, tipotasa, amortizaciones, comisiones, comisionesiva,
fecharevision, contuso, tienetasaesp, tasaesp, codi)
values (@empresa, @movcrear, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), @fechaaplicacion, @concepto, null, @moneda, @tipocambio, @usuario, null, @referencia, null,
null, 'sinafectar', null, null, null, null, @contacto, @canalventa, @moneda, @tipocambio,
null, null, @fechaaplicacion, null, @ctadinero, null, null, null, 0, 0, null, null,
null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, 0, null, @sucursal, @sucursal, null,
@uen, null, null, null, '', null, null, null, null, null, null,
null, null, 0, null, null)
select @idcxc2 = @@identity
update cxc set importe = round(@imptotalbonif/ (1+@defimpuesto/100.0), 2),
impuestos = round(@imptotalbonif/ (1+@defimpuesto/100.0), 2)*(@defimpuesto/100.0),
saldo = round(@imptotalbonif/ (1+@defimpuesto/100.0), 2) + round(@imptotalbonif/ (1+@defimpuesto/100.0), 2)*(@defimpuesto/100.0),
idcobrobonifmavi = @id
where id = @idcxc2
exec spafectar 'cxc', @idcxc2, 'afectar', 'todo', null, @usuario, null, 1, @ok output, @okref output,null, @conexion = 1
insert into detalleafectacionmavi( idcobro, id, mov, movid, valorok, valorokref) values(@id, @idcxc2, @movcrear, null, @ok, @okref )
end
set @minbon = @minbon + 1
end
end
else
begin
insert into #crgenbonifp (papuntual,origen,origenid,idpapuntual)
select sum(isnull(papuntual,0)), origen, origenid, idpapuntual
from neciamoratoriosmavi where idcobro = @id and papuntual > 0 and notacreditoxcanc = '1'
group by origen, origenid, idpapuntual
select @minbon=min(id), @maxbon=max(id) from #crgenbonifp
while @minbon <= @maxbon
begin
select @papuntual=papuntual, @origen=origen, @origenid=origenid, @idpol=idpapuntual from #crgenbonifp where id=@minbon
set @renglon = 1024.0
select @uen = uen, @canalventa = clienteenviara from cxc where mov = @origen and movid = @origenid
select @movpadre = @origen
select @movcrear = isnull(movcrear, 'nota credito') from movcrearbonifmavi where mov = @movpadre and uen = @uen
if @movpadre = 'credilana' set @movcrear = 'nota credito'
if @movpadre = 'prestamo personal' set @movcrear = 'nota credito viu'
if @movcrear is null select @movcrear = 'nota credito'
select @concepto = concepto
from mavibonificacionconf where id = @idpol
insert into cxc(empresa, mov, movid, fechaemision, ultimocambio, concepto, proyecto, moneda, tipocambio, usuario, autorizacion, referencia, docfuente,
observaciones, estatus, situacion, situacionfecha, situacionusuario, situacionnota, cliente, clienteenviara, clientemoneda, clientetipocambio,
cobrador, condicion, vencimiento, formacobro, ctadinero, importe, impuestos, retencion, aplicamanual, condesglose, formacobro1, formacobro2,
formacobro3, formacobro4, formacobro5, referencia1, referencia2, referencia3, referencia4, referencia5, importe1, importe2, importe3,
importe4, importe5, cambio, delefectivo, agente, comisiontotal, comisionpendiente, movaplica, movaplicaid, origentipo, origen, origenid,
poliza, polizaid, fechaconclusion, fechacancelacion, dinero, dineroid, dineroctadinero, contramites, vin, sucursal, sucursalorigen, cajero,
uen, personalcobrador, fechaoriginal, nota, comentarios, lineacredito, tipoamortizacion, tipotasa, amortizaciones, comisiones, comisionesiva,
fecharevision, contuso, tienetasaesp, tasaesp, codi)
values (@empresa, @movcrear, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), @fechaaplicacion, @concepto, null, @moneda, @tipocambio, @usuario, null, @referencia, null,
null, 'sinafectar', null, null, null, null, @contacto, @canalventa, @moneda, @tipocambio,
null, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), null, @ctadinero, null, null, null, 1, 0, null, null,
null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, 0, null, @sucursal, @sucursal, null,
@uen, null, null, null, '', null, null, null, null, null, null,
null, null, 0, null, null)
select @idcxc = @@identity
insert into #crdetncbonifpp(mov,movid,papuntual)
select mov, movid, papuntual
from neciamoratoriosmavi where idcobro = @id and papuntual > 0 and notacreditoxcanc = '1'
and origen = @origen and origenid = @origenid
select @mindet=min(id), @maxdet=max(id) from #crdetncbonifpp
while @mindet <= @maxdet
begin
select @mov=mov, @movid=movid, @impdocto=papuntual from #crdetncbonifpp where id=@mindet
insert into cxcd(id, renglon, renglonsub, aplica, aplicaid, importe, fecha, sucursal, sucursalorigen, descuentorecars, interesesordinarios,
interesesmoratorios, interesesordinariosquita, interesesmoratoriosquita, impuestoadicional, retencion)
values(@idcxc, @renglon, 0, @mov, @movid, @impdocto, null, @sucursal, @sucursal, null, null, null, null, null, null, null)
set @renglon = @renglon + 1024.0
update neciamoratoriosmavi set notacredbonid = @idcxc
where idcobro = @id
and origen = @origen and origenid = @origenid and idpapuntual = @idpol
set @mindet=@mindet + 1
end
select @impuestos = sum(d.importe*isnull(ca.ivafiscal,0.00))
from cxcd d join cxcaplica ca on d.aplica = ca.mov and d.aplicaid = ca.movid and ca.empresa = @empresa
where d.id = @idcxc
select @totalmov = sum(d.importe-isnull(d.importe*ca.ivafiscal,0))
from cxcd d join cxcaplica ca on d.aplica = ca.mov and d.aplicaid = ca.movid and ca.empresa = @empresa
where d.id = @idcxc
update cxc set importe = isnull(round(@totalmov,2),0.00),
impuestos = isnull(round(@impuestos,2),0.00),
saldo = isnull(round(@totalmov,2),0.00) + isnull(round(@impuestos,2),0.00),
idcobrobonifmavi = @id
where id = @idcxc
exec spafectar 'cxc', @idcxc, 'afectar', 'todo', null, @usuario, null, 1, @ok output, @okref output,null, @conexion = 1
insert into detalleafectacionmavi( idcobro, id, mov, movid, valorok, valorokref) values(@id, @idcxc, @movcrear, null, @ok, @okref )
set @minbon = @minbon + 1
end
insert into #crgenbonifpp2(papuntual,origen,origenid,idpapuntual)
select sum(isnull(papuntual,0)), origen, origenid, idpapuntual
from neciamoratoriosmavi where idcobro = @id and papuntual > 0 and notacreditoxcanc is null
group by origen, origenid, idpapuntual
select @minbon2=min(id), @maxdet2=max(id) from #crgenbonifpp2
while @minbon2 <= @maxbon2
begin
select @papuntual=papuntual, @origen=origen, @origenid=origenid,@idpol=idpapuntual from #crgenbonifpp2 where id=@minbon2
set @renglon = 1024.0
select @uen = uen, @canalventa = clienteenviara from cxc where mov = @origen and movid = @origenid
select @movpadre = @origen
select @movcrear = isnull(movcrear, 'nota credito') from movcrearbonifmavi where mov = @movpadre and uen = @uen
if @movcrear is null select @movcrear = 'nota credito'
select @concepto = concepto
from mavibonificacionconf where id = @idpol
insert into cxc(empresa, mov, movid, fechaemision, ultimocambio, concepto, proyecto, moneda, tipocambio, usuario, autorizacion, referencia, docfuente,
observaciones, estatus, situacion, situacionfecha, situacionusuario, situacionnota, cliente, clienteenviara, clientemoneda, clientetipocambio,
cobrador, condicion, vencimiento, formacobro, ctadinero, importe, impuestos, retencion, aplicamanual, condesglose, formacobro1, formacobro2,
formacobro3, formacobro4, formacobro5, referencia1, referencia2, referencia3, referencia4, referencia5, importe1, importe2, importe3,
importe4, importe5, cambio, delefectivo, agente, comisiontotal, comisionpendiente, movaplica, movaplicaid, origentipo, origen, origenid,
poliza, polizaid, fechaconclusion, fechacancelacion, dinero, dineroid, dineroctadinero, contramites, vin, sucursal, sucursalorigen, cajero,
uen, personalcobrador, fechaoriginal, nota, comentarios, lineacredito, tipoamortizacion, tipotasa, amortizaciones, comisiones, comisionesiva,
fecharevision, contuso, tienetasaesp, tasaesp, codi)
values (@empresa, @movcrear, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), @fechaaplicacion, @concepto, null, @moneda, @tipocambio, @usuario, null, @referencia, null,
null, 'sinafectar', null, null, null, null, @contacto, @canalventa, @moneda, @tipocambio,
null, null, cast(convert(varchar, @fechaaplicacion, 101) as datetime), null, @ctadinero, null, null, null, 1, 0, null, null,
null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, null, null, null, null, null,
null, null, null, null, null, null, null, 0, null, @sucursal, @sucursal, null,
@uen, null, null, null, '', null, null, null, null, null, null,
null, null, 0, null, null)
select @idcxc = @@identity
insert into #crdetncbonifpp2(mov,movid,papuntual)
select mov, movid, papuntual
from neciamoratoriosmavi where idcobro = @id and papuntual > 0 and notacreditoxcanc is null
and origen = @origen and origenid = @origenid
select @mindet2=min(id), @maxdet2=max(id) from #crdetncbonifpp2
while @mindet2 <= @maxdet2
begin
select @mov=mov, @movid=movid, @impdocto=papuntual from #crdetncbonifpp2 where id=@mindet2
insert into cxcd(id, renglon, renglonsub, aplica, aplicaid, importe, fecha, sucursal, sucursalorigen, descuentorecars, interesesordinarios,
interesesmoratorios, interesesordinariosquita, interesesmoratoriosquita, impuestoadicional, retencion)
values(@idcxc, @renglon, 0, @mov, @movid, @impdocto, null, @sucursal, @sucursal, null, null, null, null, null, null, null)
set @renglon = @renglon + 1024.0
update neciamoratoriosmavi set notacredbonid = @idcxc
where idcobro = @id
and origen = @origen and origenid = @origenid and idpapuntual = @idpol
set @mindet2 = @mindet2 + 1
end
select @impuestos = sum(d.importe*isnull(ca.ivafiscal,0.00))
from cxcd d join cxcaplica ca on d.aplica = ca.mov and d.aplicaid = ca.movid and ca.empresa = @empresa
where d.id = @idcxc
select @totalmov = sum(d.importe-isnull(d.importe*ca.ivafiscal,0))
from cxcd d join cxcaplica ca on d.aplica = ca.mov and d.aplicaid = ca.movid and ca.empresa = @empresa
where d.id = @idcxc
update cxc set importe = isnull(round(@totalmov,2),0.00),
impuestos = isnull(round(@impuestos,2),0.00),
saldo = isnull(round(@totalmov,2),0.00) + isnull(round(@impuestos,2),0.00),
idcobrobonifmavi = @id
where id = @idcxc
exec spafectar 'cxc', @idcxc, 'afectar', 'todo', null, @usuario, null, 1, @ok output, @okref output,null, @conexion = 1
insert into detalleafectacionmavi( idcobro, id, mov, movid, valorok, valorokref) values(@id, @idcxc, @movcrear, null, @ok, @okref )
set @minbon2 = @minbon2 + 1
end
end
end
return