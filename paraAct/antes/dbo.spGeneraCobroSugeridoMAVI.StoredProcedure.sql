create procedure [dbo].[spgeneracobrosugeridomavi] @modulo char(5),
@id int,
@usuario varchar(10),
@estacion int
as
begin
declare @empresa char(5),
@sucursal int,
@hoy datetime,
@moneda char(10),
@tipocambio float,
@renglon float,
@aplica varchar(20),
@aplicaid varchar(20),
@aplicamovtipo varchar(20),
@importe money,
@sumaimporte money,
@impuestos money,
@desglosarimpuestos bit,
@iddetalle int,
@idcxc int,
@importereal money,
@importeapagar money,
@importemoratorio money,
@importeacondonar money,
@movgenerar varchar(20),
@uen int,
@importetotal money,
@mov varchar(20),
@movid varchar(20),
@movpadre varchar(20),
@ok int,
@okref varchar(255),
@cliente varchar(10),
@ctemoneda varchar(10),
@ctetipocambio float,
@fechaaplicacion datetime,
@clienteenviara int,
@totalmov money,
@campoextra varchar(50),
@consecutivo varchar(20),
@valorcampoextra varchar(255),
@concepto varchar(50),
@moratorioapagar money,
@movidgen varchar(20),
@movcobro varchar(20),
@generanc char(1),
@origen varchar(20),
@origenid varchar(20),
@impuesto money,
@defimpuesto float,
@importedoc money,
@bonificacion money,
@movidgenerado varchar(20),
@totalapagar money,
@idcarmor int,
@interesporpolitica money,
@movidc varchar(20),
@idpadre int,
@saldoinidia money,
@porcabonocapital float,
@porcmoratoriobonificar float,
@totalmoratorio money,
@moratoriobonificado money,
@moratorioxpagar money,
@totalcobrosdia money,
@porcintabonificar float,
@porcpacapital float,
@nota varchar(100),
@cobroxpolitica int,
@moratoriosabonificar money,
@vencimientomasantiguo datetime,
@idcarmorest int,
@idcarmoratorio int,
@idcarmoratorioest int,
@saldoncpend money,
@saldoestpend money,
@estatusncest varchar(15),
@estatusnc varchar(15),
@idultcobro int,
@totalmoratultcob money,
@estatuscarmor varchar(15),
@estatuscarmorest varchar(15),
@totalbonificacion money,
@min int,
@max int,
@m1 int,
@m2 int,
@fechaemision datetime,
@quincena int,
@year int = year(getdate())
select
@quincena =
case
when day(getdate()) > 16 then month(getdate()) * 2
else (month(getdate()) * 2) - 1
end
select
@quincena =
case
when day(getdate()) = 1 then @quincena - 1
else @quincena
end
select
@year =
case
when day(getdate()) = 1 and
month(getdate()) = 1 then @year - 1
else @year
end,
@quincena =
case
when day(getdate()) = 1 and
month(getdate()) = 1 then 24
else @quincena
end
set @cobroxpolitica = 0
set @fechaaplicacion = getdate()
select
@ctemoneda = clientemoneda,
@ctetipocambio = clientetipocambio,
@cliente = cliente
from cxc with (nolock)
where id = @id
select
@cobroxpolitica = isnull(tipocobro, 0)
from tipocobromavi with (nolock)
where idcobro = @id
select
@desglosarimpuestos = 0,
@renglon = 0.0,
@sumaimporte = 0.0,
@importetotal = nullif(@importetotal, 0.0)
select
@renglon = 1024.0
select
@generanc = '1'
if exists (select
id
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#crdetalle')
and type = 'u')
drop table #crdetalle
if exists (select
id
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#crdoc')
and type = 'u')
drop table #crdoc
if not exists (select
*
from neciamoratoriosmavi with (nolock)
where idcobro = @id)
begin
select
'no hay sugerencia a cobrar..'
return
end
begin transaction bonmavi
if @modulo = 'cxc'
begin
update cxc with (rowlock)
set aplicamanual = 1
where id = @id
select
@empresa = empresa,
@sucursal = sucursal,
@hoy = fechaemision,
@moneda = moneda,
@tipocambio = tipocambio,
@clienteenviara = clienteenviara,
@movcobro = mov
from cxc with (nolock)
where id = @id
delete cxcd
where id = @id
delete detalleafectacionmavi
where idcobro = @id
select top 1
@clienteenviara = clienteenviara,
@fechaemision = fechaemision
from cxc c with (nolock)
inner join neciamoratoriosmavi n with (nolock)
on c.mov = n.mov
and c.movid = n.movid
where n.idcobro = @id
exec spgenerancredppmavi @id,
@usuario,
@ok output,
@okref output
if @ok is null
and (@clienteenviara not in (3, 4, 7, 11)
or @fechaemision between '2014-05-01' and '2014-07-10')
exec spgenerancredapmavi @id,
@usuario,
@ok output,
@okref output
if @ok is null
and @clienteenviara = 7
exec spgenerancredbonifmavi @id,
@usuario,
@ok output,
@okref output
if @ok is null
begin
select
sum(isnull(moratorioapagar, 0) - isnull(importeacondonar, 0)) importemoratorio,
origen,
origenid,
row_number() over (order by origenid) id into #crdetalle
from neciamoratoriosmavi with (nolock)
where idcobro = @id
and estacion = @estacion
and moratorioapagar > 0
group by origen,
origenid
select
@min = min(id),
@max = max(id)
from #crdetalle
while @min <= @max
begin
if @ok is null
begin
select
@origen = origen,
@origenid = origenid,
@importemoratorio = importemoratorio
from #crdetalle
where id = @min
select
@uen = uen,
@clienteenviara = clienteenviara
from cxc with (nolock)
where mov = @origen
and movid = @origenid
if @importemoratorio > 0
begin
select
@movgenerar = dbo.fnmaviobtienemovsaldomoratorios(@origen, 'moratorios', @uen)
if @movgenerar is null
select
@movgenerar = 'nota car'
if @movgenerar = 'endoso'
select
@movgenerar = 'nota car'
select
@defimpuesto = 1 + isnull(defimpuesto, 15.0) / 100
from empresagral with (nolock)
where empresa = @empresa
select
@importe = @importemoratorio / @defimpuesto
select
@impuesto = @importemoratorio - @importe
if @movgenerar in ('nota car', 'nota car viu')
select
@concepto = 'moratorios menudeo'
if @movgenerar = 'nota car mayoreo'
select
@concepto = 'moratorios mayoreo'
if @generanc = '1'
begin
insert into cxc (empresa, mov, movid, fechaemision, concepto, ultimocambio, moneda, tipocambio, usuario, referencia,
estatus, cliente, clienteenviara, clientemoneda, clientetipocambio, vencimiento,
importe, impuestos, aplicamanual, condesglose, saldo,
contramites, vin, sucursal, sucursalorigen, uen, personalcobrador, fechaoriginal, nota,
comentarios, lineacredito, tipoamortizacion, tipotasa, amortizaciones, comisiones, comisionesiva,
fecharevision, contuso, tienetasaesp, tasaesp, codi)
values (@empresa, @movgenerar, null, dbo.fnfechasinhora(@fechaaplicacion), @concepto, @fechaaplicacion, @moneda, @tipocambio, @usuario, null,
'sinafectar', @cliente, @clienteenviara, @moneda, @tipocambio, @fechaaplicacion, @importe, @impuesto, 0, 0, isnull(@importe, 0) + isnull(@impuesto, 0), 0, null, @sucursal, @sucursal, @uen, null, null, null, '', null, null, null, null, null, null, null, null, 0, null, null)
select
@idcxc = @@identity
exec spafectar 'cxc',
@idcxc,
'afectar',
'todo',
null,
@usuario,
null,
1,
@ok output,
@okref output,
null,
@conexion = 1
insert into detalleafectacionmavi (idcobro, id, mov, movid, valorok, valorokref)
values (@id, @idcxc, @movgenerar, @movidgen, @ok, @okref)
update neciamoratoriosmavi with (rowlock)
set notacarmorid = @idcxc
where idcobro = @id
and estacion = @estacion
and moratorioapagar > 0
and origen = @origen
and origenid = @origenid
select
@movidgen = movid
from cxc with (nolock)
where id = @idcxc
insert cxcd (id, sucursal, renglon, aplica, aplicaid, importe, interesesordinarios, interesesmoratorios, impuestoadicional)
values (@id, @sucursal, @renglon, @movgenerar, @movidgen, nullif(@importemoratorio, 0.0), 0.0, 0.0, 0.0)
select
@renglon = @renglon + 1024.0
if @ok = 80030
select
@ok = null
if @ok is null
begin
if not exists (select
*
from movcampoextra with (nolock)
where modulo = @modulo
and mov = @movgenerar
and id = @idcxc)
begin
select
@aplicaid = movid
from cxc with (nolock)
where id = @idcxc
if @movgenerar = 'nota car'
select
@campoextra = 'nc_factura'
if @movgenerar = 'nota car viu'
select
@campoextra = 'ncv_factura'
if @movgenerar = 'nota car mayoreo'
select
@campoextra = 'ncm_factura'
select
@valorcampoextra = rtrim(@origen) + '_' + rtrim(@origenid)
if @movgenerar in ('nota car', 'nota car viu', 'nota car mayoreo')
insert into movcampoextra (modulo, mov, id, campoextra, valor)
values ('cxc', @movgenerar, @idcxc, @campoextra, @valorcampoextra)
end
end
end
end
end
set @min = @min + 1
end
select
mov,
movid,
importereal,
importeapagar,
importemoratorio,
importeacondonar,
bonificacion,
totalapagar,
row_number() over (order by movid) id into #crdoc
from neciamoratoriosmavi with (nolock)
where idcobro = @id
and estacion = @estacion
and importeapagar > 0
select
@m1 = min(id),
@m2 = max(id)
from #crdoc
while @m1 <= @m2
begin
if @ok is null
begin
select
@mov = mov,
@movid = movid,
@importereal = importereal,
@importeapagar = importeapagar,
@importemoratorio = importemoratorio,
@importeacondonar = importeacondonar,
@bonificacion = bonificacion,
@totalapagar = totalapagar
from #crdoc
where id = @m1
select
@importedoc = isnull(@importeapagar, 0) - isnull(@bonificacion, 0)
if @importedoc > 0
begin
insert cxcd (id, sucursal, renglon, aplica, aplicaid, importe, interesesordinarios, interesesmoratorios, impuestoadicional)
values (@id, @sucursal, @renglon, @mov, @movid, nullif(@importedoc, 0.0), 0.0, 0.0, 0.0)
select
@renglon = @renglon + 1024.0
end
end
set @m1 = @m1 + 1
end
if @cobroxpolitica = 1
begin
update cxc with (rowlock)
set concepto = 'politica quita moratorios'
where id = @id
select
@interesporpolitica = min(interesporpolitica)
from neciamoratoriosmavi with (nolock)
where idcobro = @id
and interesporpolitica > 0
select
@origen = origen,
@origenid = origenid
from neciamoratoriosmavi with (nolock)
where idcobro = @id
group by origen,
origenid
select
@idpadre = id,
@uen = uen,
@clienteenviara = clienteenviara
from cxc with (nolock)
where mov = @origen
and movid = @origenid
select
@importetotal = sum(isnull(importeapagar, 0))
from neciamoratoriosmavi with (nolock)
where idcobro = @id
if not exists (select
*
from cobroxpoliticahistmavi with (nolock)
where mov = @origen
and movid = @origenid
and convert(varchar(8), fechaemision, 112) = convert(varchar(8), @fechaaplicacion, 112)
and estatuscobro = 'concluido')
begin
set @totalbonificacion = 0
select
@totalbonificacion = sum(isnull(bonificacion, 0))
from neciamoratoriosmavi with (nolock)
where idcobro = @id
select
@saldoinidia = dbo.fnsaldopmmavi(@idpadre) + isnull(@totalbonificacion, 0)
select
@totalcobrosdia = @importetotal
end
else
begin
select top 1
@saldoinidia = saldoiniciodeldia
from cobroxpoliticahistmavi with (nolock)
where mov = @origen
and movid = @origenid
and convert(varchar(8), fechaemision, 112) = convert(varchar(8), @fechaaplicacion, 112)
and estatuscobro = 'concluido'
order by idcobro asc
select
@totalcobrosdia = sum(importecobro) + isnull(@importetotal, 0)
from cobroxpoliticahistmavi with (nolock)
where mov = @origen
and movid = @origenid
and convert(varchar(8), fechaemision, 112) = convert(varchar(8), @fechaaplicacion, 112)
and estatuscobro = 'concluido'
select
@idcarmoratorioest = 0
select top 1
@idultcobro = idcobro,
@porcmoratoriobonificar = porcmoratoriobonificar,
@idcarmoratorioest = idcarmoratorioest,
@totalmoratultcob = totalmoratorio
from cobroxpoliticahistmavi with (nolock)
where mov = @origen
and movid = @origenid
and convert(varchar(8), fechaemision, 112) = convert(varchar(8), @fechaaplicacion, 112)
and estatuscobro = 'concluido'
order by idcobro desc
select
@interesporpolitica = @totalmoratultcob
if @porcmoratoriobonificar <= 100
begin
select
@saldoestpend = isnull(importe, 0) + isnull(impuestos, 0),
@estatusncest = estatus
from cxc with (nolock)
where id = @idcarmoratorioest
if @idcarmoratorioest > 0
begin
exec spafectar 'cxc',
@idcarmoratorioest,
'cancelar',
'todo',
null,
@usuario,
null,
1,
@ok output,
@okref output,
null,
@conexion = 1
update cobroxpoliticahistmavi with (rowlock)
set estatuscarmorest = 'cancelado'
where idcarmoratorioest = @idcarmoratorioest
end
end
end
if @saldoinidia > 0
select
@porcabonocapital = (@totalcobrosdia / @saldoinidia) * 100.0
select
@porcintabonificar = 0
select top 1
@porcintabonificar = isnull(con.porcdebonificaciondeinteres, 0)
from dbo.tcirm0906_configdivisionyparam con with (nolock)
inner join dbo.mavirecuperacion ma with (nolock)
on isnull(con.division, '') = isnull(ma.division, '')
where ma.cliente = @cliente
and ma.ejercicio = @year
and ma.quincena = @quincena
and @porcabonocapital >= con.porcdeabonofinal
order by con.porcdebonificaciondeinteres desc
select
@nota = null
if @porcintabonificar > 0.0
begin
select
@porcmoratoriobonificar = isnull(@interesporpolitica, 0) - (isnull(@interesporpolitica, 0) * (isnull(@porcintabonificar, 0) / 100.0))
select
@moratorioxpagar = @porcmoratoriobonificar
select
@moratoriosabonificar = isnull(@interesporpolitica, 0) - isnull(@porcmoratoriobonificar, 0)
select
@nota = 'im bonificado:' + convert(varchar(20), @moratoriosabonificar)
end
else
begin
update neciamoratoriosmavi with (rowlock)
set interesapagarconpolitica = 0
where idcobro = @id
select
@nota = 'im bonificado: 0'
select
@moratoriosabonificar = 0
select
@moratorioxpagar = isnull(@interesporpolitica, 0) - isnull(@porcmoratoriobonificar, 0)
end
select
@estatuscarmorest = null
if @interesporpolitica > 0
and @porcintabonificar > 0
and @porcintabonificar <= 100
begin
select
@estatuscarmorest = 'concluido'
insert into cxc (empresa, mov, movid, fechaemision, concepto, ultimocambio, moneda, tipocambio, usuario, referencia,
estatus, cliente, clienteenviara, clientemoneda, clientetipocambio, condicion, vencimiento,
importe, impuestos, aplicamanual, condesglose, saldo,
contramites, vin, sucursal, sucursalorigen, uen, personalcobrador, fechaoriginal, nota,
comentarios, lineacredito, tipoamortizacion, tipotasa, amortizaciones, comisiones, comisionesiva,
fecharevision, contuso, tienetasaesp, tasaesp, codi, padremavi, padreidmavi, idpadremavi)
values (@empresa, 'car moratorio est', null, @fechaaplicacion, @concepto, @fechaaplicacion, @moneda, @tipocambio, @usuario, null,
'sinafectar', @cliente, @clienteenviara, @moneda, @tipocambio, '(fecha)', @fechaaplicacion, @moratoriosabonificar, @impuesto, 0, 0, isnull(@moratoriosabonificar, 0) + isnull(@impuesto, 0), 0, null, @sucursal, @sucursal, @uen, null, null, @nota, '', null, null, null, null, null, null, null, null, 0, null, null, 'car moratorio est', null, @idpadre)
select
@idcarmorest = @@identity
exec spafectar 'cxc',
@idcarmorest,
'afectar',
'todo',
null,
@usuario,
null,
1,
@ok output,
@okref output,
null,
@conexion = 1
select
@movidc = movid
from cxc with (nolock)
where id = @idcarmorest
update cxc with (rowlock)
set padreidmavi = @movidc
where id = @idcarmorest
insert into detalleafectacionmavi (idcobro, id, mov, movid, valorok, valorokref)
values (@id, @idcarmorest, 'car moratorio est', @movidgen, @ok, @okref)
if not exists (select
*
from movcampoextra with (nolock)
where modulo = @modulo
and mov = 'car moratorio est'
and id = @idcarmorest)
begin
select
@campoextra = 'cm_factura'
select
@valorcampoextra = rtrim(@origen) + '_' + rtrim(@origenid)
insert into movcampoextra (modulo, mov, id, campoextra, valor)
values ('cxc', 'car moratorio est', @idcarmorest, @campoextra, @valorcampoextra)
end
select
@vencimientomasantiguo = min(vencimiento)
from cxc with (nolock)
where padremavi = @origen
and padreidmavi = @origenid
and estatus = 'pendiente'
if @vencimientomasantiguo is null
select
@vencimientomasantiguo = @fechaaplicacion
end
insert into cobroxpoliticahistmavi (idcobro, fechaemision, estatuscobro, importecobro, cliente, mov, movid,
saldoiniciodeldia, totalcobrosdeldia, porcabonocapital, porcmoratoriobonificar, totalmoratorio, moratoriobonificado,
moratorioxpagar, idcarmoratorioest, estatuscarmorest)
values (@id, @fechaaplicacion, 'sinafectar', @importetotal, @cliente, @origen, @origenid, @saldoinidia, @totalcobrosdia, @porcabonocapital, @porcintabonificar, @interesporpolitica, isnull(@moratoriosabonificar, 0), isnull(@moratorioxpagar, 0), isnull(@idcarmorest, 0), @estatuscarmorest)
end
select
@impuestos = sum(d.importe * isnull(ca.ivafiscal, 0))
from cxcd d with (nolock)
join cxcaplica ca with (nolock)
on d.aplica = ca.mov
and d.aplicaid = ca.movid
and ca.empresa = @empresa
where d.id = @id
select
@totalmov = sum(d.importe - isnull(d.importe * ca.ivafiscal, 0))
from cxcd d with (nolock)
join cxcaplica ca with (nolock)
on d.aplica = ca.mov
and d.aplicaid = ca.movid
and ca.empresa = @empresa
where d.id = @id
update cxc with (rowlock)
set importe = isnull(round(@totalmov, 2), 0.00),
impuestos = isnull(round(@impuestos, 2), 0.00),
saldo = isnull(round(@totalmov, 2), 0.00) + isnull(round(@impuestos, 2), 0.00)
where id = @id
exec spafectar 'cxc',
@id,
'afectar',
'todo',
null,
@usuario,
null,
1,
@ok output,
@okref output,
null,
@conexion = 1
select
@movidgenerado = movid
from cxc with (nolock)
where id = @id
update cxc with (rowlock)
set referencia = rtrim(@movcobro) + '_' + rtrim(@movidgenerado)
where idcobrobonifmavi = @id
if @idcarmorest > 0
update cxc with (rowlock)
set referencia = rtrim(@movcobro) + '_' + rtrim(@movidgenerado)
where id = @idcarmorest
end
if @ok is null
or @ok = 80030
begin
commit transaction bonmavi
select
'proceso concluido..'
end
else
begin
select
@okref = descripcion
from mensajelista with (nolock)
where mensaje = @ok
rollback transaction bonmavi
select
@okref
end
return
end
if exists (select
id
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#crdetalle')
and type = 'u')
drop table #crdetalle
if exists (select
id
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#crdoc')
and type = 'u')
drop table #crdoc
end