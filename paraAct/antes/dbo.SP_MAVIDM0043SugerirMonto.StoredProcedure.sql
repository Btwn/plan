create procedure [dbo].[sp_mavidm0043sugerirmonto]
@idfac int ,@estacion int , @idcobro int , @importetotal money
as
begin
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#factura')
and type = 'u')
drop table #factura
create table #factura (
idfact int,
padremavi varchar(50),
padreidmavi varchar(50),
fechaemisionfact datetime,
maxdiasatrazo int,
importefact money,
condicion varchar(100) null,
numdocs int,
monedero money,
cobxpol varchar(5),
uen int null,
sucursal int
)
insert into #factura
select
a.id idfact,
a.padremavi,
a.padreidmavi,
fechaemisionfact = a.fechaemision,
maxdiasatrazo = isnull(cm.maxdiasvencidosmavi, 0),
a.importe + a.impuestos importefact,
a.condicion,
isnull(danumerodocumentos, 0) numdocs,
0.00 monedero,
'',
uen,
sucursal
from (select
id,
padremavi,
padreidmavi,
fechaemision,
isnull(condicion, '') condicion,
importe,
impuestos,
isnull(uen, '') uen,
sucursal
from cxc with (nolock)
where id = @idfac) a
left join condicion cn with (nolock)
on cn.condicion = a.condicion
left join cxcmavi cm with (nolock)
on a.id = cm.id
if (select
isnull(valor, '')
from tablastd with (nolock)
where tablast = 'calcula bonif en cobro'
and nombre = 'activar')
= '1'
begin
if (select
count(id)
from #factura f
join cxc docs with (nolock)
on docs.padremavi = f.padremavi
and docs.padreidmavi = f.padreidmavi
where docs.estatus in ('pendiente', 'concluido')
and docs.id != f.idfact
and docs.idbonifap is null
and docs.idbonifcc is null
and docs.idbonifpp is null)
> 0
begin
declare @mov varchar(30),
@movid varchar(30)
select
@mov = padremavi,
@movid = padreidmavi
from #factura
exec sp_mavidm0279calcularbonif @mov,
@movid,
null,
null,
@clave = 'cobro'
end
end
delete m
from mavibonificaciontest m
join #factura f
on origen = padremavi
and origenid = padreidmavi
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#docs')
and type = 'u')
drop table #docs
select
docs.cliente,
docs.id,
docs.mov,
docs.movid,
docs.padremavi,
docs.padreidmavi,
importe + impuestos importedoc,
saldo,
docs.vencimiento,
isnull(docs.idbonifap, 0) idbonifap,
isnull(docs.idbonifcc, 0) idbonifcc,
isnull(docs.bonifcc, 0) bonifcc,
isnull(docs.idbonifpp, 0) idbonifpp,
isnull(docs.bonifpp, 0) bonifpp,
isnull(docs.bonifppext, 0) bonifppext,
docs.estatus,
docs.concepto,
dvn = datediff(dd, vencimiento, convert(datetime, convert(varchar(10), getdate(), 10))),
docs.fechaemision,
docs.condicion,
case
when isnull(referenciamavi, referencia) like '%/%' then substring(isnull(referenciamavi, referencia), 1, charindex('/', isnull(referenciamavi, referencia)) - 1)
end referencia,
cast(0.00 as float) moratorios into #docs
from #factura f
join cxc docs with (nolock)
on docs.padremavi = f.padremavi
and docs.padreidmavi = f.padreidmavi
where docs.estatus in ('pendiente', 'concluido')
and docs.id != f.idfact
update f
set monedero = isnull(mon.abono, 0.00)
from #factura f
join auxiliarp mon with (nolock)
on mon.mov = f.padremavi
and mon.movid = f.padreidmavi
update f
set cobxpol = dbo.fn_mavirm0906cobxpol(f.idfact)
from #factura f
update dcs
set moratorios = dbo.fninteresmoratoriomavi(dcs.id)
from #docs dcs
left join #factura f
on f.padremavi = dcs.padremavi
and f.padreidmavi = dcs.padreidmavi
where dcs.estatus = 'pendiente'
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#bonifaplica')
and type = 'u')
drop table #bonifaplica
select
padremavi,
padreidmavi,
id,
aplicaa,
bonificacion,
porcbon1,
bonif_ext,
maxdvppext,
vencimientoantes,
vencimientodesp,
diasatrazo,
diasmenoresa,
diasmayoresa,
financiamiento,
factor,
plazoejefin into #bonifaplica
from (
select
padremavi,
padreidmavi,
b.id,
b.aplicaa,
b.bonificacion,
b.vencimientoantes,
b.vencimientodesp,
b.diasatrazo,
b.diasmenoresa,
b.diasmayoresa,
b.financiamiento,
b.factor,
b.plazoejefin,
case
when b.bonificacion like '%contado comercial%' then case
when maxdiasatrazo > b.diasatrazo and
b.diasatrazo <> 0 then 'no aplica'
when b.vencimientoantes <> 0 and
d.vencyapaso >= b.vencimientoantes then 'no aplica'
when b.diasmenoresa <> 0 and
b.diasmenoresa < datediff(day, fechaemisionfact, getdate()) then 'no aplica'
when diasmayoresa <> 0 and
diasmayoresa >= datediff(dd, fechaemisionfact, primervenc) then 'no aplica'
else 'aplica'
end
end bonifcc,
case
when b.bonificacion like '%adelanto en pas%' then case
when b.vencimientoantes <> 0 and
d.vencyapaso >= b.vencimientoantes then 'no aplica'
when b.vencimientodesp <> 0 and
d.vencyapaso < b.vencimientodesp then 'no aplica'
when b.diasmayoresa <> 0 and
b.diasmayoresa > d.vencyapaso then 'no aplica'
when b.diasmenoresa <> 0 and
b.diasmenoresa < d.vencyapaso then 'no aplica'
else 'aplica'
end
end bonifap,
case
when b.bonificacion like '%pa puntual%' and
d.idbonifpp is not null then 'aplica'
else ''
end bonifpp,
case
when b.bonificacion like '%adelanto en pas%' and
b.porcbon1 = 0 then b.linea
else b.porcbon1
end porcbon1,
isnull(bc.porcbon, 0) bonif_ext,
isnull(bc.maxdv, 0) maxdvppext,
fechaemisionfact
from (
select
padremavi,
padreidmavi,
idbonifcc,
idbonifpp,
idbonifap,
min(vencimiento) primervenc,
isnull(max(case
when vencyapaso = 's' then ordenvenc
end), 0) vencyapaso,
isnull(max(case
when vencyapaso = 's' then dvn
end), 0) maxdvn,
fechaemisionfact,
maxdiasatrazo
from (
select
d.padremavi,
d.padreidmavi,
isnull(d.idbonifcc, 0) idbonifcc,
isnull(d.idbonifpp, 0) idbonifpp,
isnull(d.idbonifap, 0) idbonifap,
d.mov,
d.movid,
f.fechaemisionfact,
row_number() over (order by d.vencimiento) ordenvenc,
d.dvn,
case
when d.dvn > 0 then 's'
else ''
end vencyapaso,
d.vencimiento,
f.maxdiasatrazo
from #docs d
left join #factura f
on f.padremavi = d.padremavi
and f.padreidmavi = d.padreidmavi
where d.mov = 'documento') b
group by padremavi,
padreidmavi,
idbonifcc,
idbonifpp,
idbonifap,
fechaemisionfact,
maxdiasatrazo) d
left join mavibonificacionconf b with (nolock)
on b.id in (d.idbonifcc, d.idbonifpp, d.idbonifap)
left join mavibonificacionconvencimiento bc with (nolock)
on bc.idbonificacion = b.id) f
where isnull(bonifcc, '') = 'aplica'
or isnull(bonifpp, '') = 'aplica'
or isnull(bonifap, '') = 'aplica'
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#bonficaciones')
and type = 'u')
drop table #bonficaciones
select
r.cliente,
r.id,
idbonificacion,
r.bonificacion,
@estacion estacion,
r.mov,
r.movid,
r.padremavi,
r.padreidmavi,
round(f.importefact - f.monedero, 2) importefactfin,
round((f.importefact - f.monedero) / (f.numdocs), 2) importedoc,
r.porcbonpp,
r.porcboncc,
case
when r.bonificacion = 'bonificacion pa puntual' then bonifppfinal
when r.bonificacion = 'bonificacion contado comercial' then bonifcc
end montobonif,
financiamiento,
factor,
plazoejefin,
documento1de,
f.sucursal sucursal1,
'' tiposucursal,
'' lineavta,
r.diasmenoresa,
r.diasmayoresa,
0 idventa,
f.uen,
f.condicion,
'' ok,
'' okref,
f.fechaemisionfact,
r.vencimiento,
@idcobro idcrobo,
'' lineacelulares,
'' lineacredilanas,
f.idfact,
0 baseparaaplicar,
f.numdocs,
f.monedero,
case
when r.bonificacion = 'bonificacion contado comercial' then ((f.numdocs - r.plazoejefin) * (r.financiamiento / 100) + 1)
else 0
end factorconversion_cc into #bonficaciones
from (select
d.cliente,
d.id,
b.id idbonificacion,
b.bonificacion,
d.mov,
d.movid,
d.padremavi,
d.padreidmavi,
case
when b.bonificacion like '%pa puntual%' and
dvn <= 0 then b.porcbon1
else case
when b.bonificacion like '%pa puntual%' and
dvn <= maxdvppext then b.bonif_ext
else 0
end
end porcbonpp,
case
when b.bonificacion like '%contado comercial%' then b.porcbon1
else 0
end porcboncc,
case
when dvn <= 0 then d.bonifpp
else case
when dvn <= maxdvppext then d.bonifppext
else 0
end
end bonifppfinal,
d.bonifcc,
b.factor,
b.financiamiento,
b.plazoejefin,
case
when referencia like '%(%' then substring(referencia, charindex('(', referencia) + 1, 5)
else ''
end documento1de,
b.diasmenoresa,
b.diasmayoresa,
d.vencimiento
from #docs d
join #bonifaplica b
on b.padremavi = d.padremavi
and b.padreidmavi = d.padreidmavi
where estatus = 'pendiente') r
left join #factura f
on f.padremavi = r.padremavi
and f.padreidmavi = r.padreidmavi
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#temp')
and type = 'u')
drop table #temp
create table #temp (
docto int null,
idbonificacion int null,
bonificacion varchar(40) null,
estacion int null,
mov varchar(50) null,
movid varchar(50) null,
padremavi varchar(50) null,
padreidmavi varchar(50) null,
importefact money null,
importedoc money null,
porcbon money null,
montobonif money null,
financiamiento money null,
factor money null,
plazoejefin int,
documento1de int null,
documentototal int null,
sucursal1 int null,
tiposucursal varchar(50) null,
lineavta varchar(100) null,
diasmenoresa int null,
diasmayoresa int null,
idventa int null,
uen int,
condicion varchar(100) null,
ok int null,
okref varchar(50) null,
fechaemisionfact datetime,
vencimiento datetime,
idcrobo int,
lineacelulares varchar(100) null,
lineacredilanas varchar(100) null,
baseparaaplicar money
)
insert into #temp (docto, idbonificacion, bonificacion, estacion, mov, movid, padremavi, padreidmavi, importefact, importedoc
, porcbon, montobonif, financiamiento, factor, plazoejefin, documento1de, documentototal, sucursal1, tiposucursal, lineavta, diasmenoresa, diasmayoresa, idventa
, uen, condicion, ok, okref, fechaemisionfact, vencimiento, idcrobo, lineacelulares, lineacredilanas, baseparaaplicar)
select
b.idfact,
b.idbonificacion,
b.bonificacion,
b.estacion,
b.padremavi mov,
b.padreidmavi movid,
b.padremavi,
b.padreidmavi,
b.importefactfin,
b.importefactfin importedoc,
b.porcboncc,
b.montobonif - sum(isnull(dt.importe, 0))
montobonif,
b.financiamiento,
b.factorconversion_cc,
b.plazoejefin,
1 documento1de,
b.numdocs documentototal,
sucursal1,
'' tiposucursal,
'' lineavta,
b.diasmenoresa,
b.diasmayoresa,
b.idventa,
b.uen,
b.condicion,
b.ok,
b.okref,
b.fechaemisionfact,
b.vencimiento,
b.idcrobo,
b.lineacelulares,
b.lineacredilanas,
b.baseparaaplicar
from (select
cliente,
idfact,
idbonificacion,
bonificacion,
estacion,
padremavi,
padreidmavi,
importefactfin,
porcboncc,
count(id) totpendientes,
numdocs * max(montobonif) montobonif,
financiamiento,
factor,
plazoejefin,
diasmenoresa,
diasmayoresa,
idventa,
uen,
condicion,
ok,
okref,
fechaemisionfact,
min(vencimiento) vencimiento,
idcrobo,
lineacelulares,
lineacredilanas,
baseparaaplicar,
numdocs,
factorconversion_cc,
sucursal1
from #bonficaciones
where isnull(bonificacion, '') = 'bonificacion contado comercial'
group by cliente,
idfact,
idbonificacion,
bonificacion,
estacion,
padremavi,
padreidmavi,
importefactfin,
porcboncc,
financiamiento,
factor,
plazoejefin,
diasmenoresa,
diasmayoresa,
idventa,
uen,
condicion,
ok,
okref,
fechaemisionfact,
idcrobo,
lineacelulares,
lineacredilanas,
baseparaaplicar,
numdocs,
factorconversion_cc,
uen,
sucursal1) b
left join cxc nc with (nolock)
on nc.cliente = b.cliente
and nc.mov like 'nota credito%'
and nc.concepto like '%pa puntual%'
and nc.estatus = 'concluido'
left join #docs d
on b.padremavi = d.padremavi
and b.padreidmavi = d.padreidmavi
and d.estatus = 'concluido'
left join cxcd dt with (nolock)
on nc.id = dt.id
and dt.aplica = d.mov
and dt.aplicaid = d.movid
group by b.idfact,
b.idbonificacion,
b.bonificacion,
b.estacion,
b.padremavi,
b.padreidmavi,
b.importefactfin,
b.porcboncc,
b.montobonif,
b.financiamiento,
factor,
plazoejefin,
numdocs,
b.diasmenoresa,
b.diasmayoresa,
b.idventa,
b.uen,
b.condicion,
b.ok,
b.okref,
b.fechaemisionfact,
b.vencimiento,
b.idcrobo,
b.lineacelulares,
b.lineacredilanas,
b.baseparaaplicar,
factorconversion_cc,
b.sucursal1
insert into #temp (docto, idbonificacion, bonificacion, estacion, mov, movid, padremavi, padreidmavi, importefact, importedoc
, porcbon, montobonif, financiamiento, factor, plazoejefin, documento1de, documentototal, sucursal1, tiposucursal, lineavta, diasmenoresa, diasmayoresa, idventa
, uen, condicion, ok, okref, fechaemisionfact, vencimiento, idcrobo, lineacelulares, lineacredilanas, baseparaaplicar)
select
b.id,
b.idbonificacion,
b.bonificacion,
b.estacion,
b.mov,
b.movid,
b.padremavi,
b.padreidmavi,
b.importefactfin,
round(b.importedoc, 2) importedoc,
b.porcbonpp,
round(b.montobonif, 2) montobonif,
b.financiamiento,
b.factor,
b.plazoejefin,
b.documento1de,
b.numdocs documentototal,
b.sucursal1,
b.tiposucursal,
b.lineavta,
b.diasmenoresa,
b.diasmayoresa,
b.idventa,
b.uen,
b.condicion,
b.ok,
b.okref,
b.fechaemisionfact,
b.vencimiento,
b.idcrobo,
b.lineacelulares,
b.lineacredilanas,
b.baseparaaplicar
from #bonficaciones b
where b.bonificacion = 'bonificacion pa puntual'
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#bonifaplipp')
and type = 'u')
drop table #bonifaplipp
select
ds.padremavi,
ds.padreidmavi,
sum(isnull(dt.importe, 0)) bonifaplipp into #bonifaplipp
from #docs ds
join cxcd dt with (nolock)
on dt.aplica = ds.mov
and dt.aplicaid = ds.movid
join cxc nc with (nolock)
on nc.id = dt.id
and nc.mov like 'nota credito%'
and nc.concepto like '%pa puntual%'
and nc.estatus = 'concluido'
where ds.estatus = 'concluido'
group by ds.padremavi,
ds.padreidmavi
if exists (select top 1
id
from #bonifaplica
where bonificacion not in ('bonificacion pa puntual', 'bonificacion contado comercial'))
begin
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#artcanc')
and type = 'u')
drop table #artcanc
create table #artcanc (
padremavi varchar(50),
padreidmavi varchar(50),
artcancelado varchar(50),
impocanc money
)
insert into #artcanc (padremavi, padreidmavi, artcancelado, impocanc)
select
d.padremavi,
d.padreidmavi,
t.articulo,
sum(t.cantidad * t.precio) importeart
from (
select
a.padremavi,
a.padreidmavi,
dv.id
from (
select
f.padremavi,
f.padreidmavi,
sv.mov,
sv.movid
from #factura f
join venta sv with (nolock)
on sv.referencia = f.padremavi + ' ' + f.padreidmavi
) a
join venta dv with (nolock)
on dv.origen = a.mov
and dv.origenid = a.movid
where dv.mov like '%devolucion%'
and dv.estatus = 'concluido') d
join ventad t with (nolock)
on t.id = d.id
and precio > 0
group by d.padremavi,
d.padreidmavi,
t.articulo
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#detalle')
and type = 'u')
drop table #detalle
select
ar.padremavi,
ar.padreidmavi,
ar.articulo,
ar.impoart - isnull(ac.impocanc, 0.00) impoart,
ar.linea into #detalle
from (select
b.padremavi,
b.padreidmavi,
case
when padremavi != 'refinanciamiento' then vd.articulo
else 'refinanciamiento'
end articulo,
case
when padremavi != 'refinanciamiento' then (vd.precio * cantidad)
else b.importefact
end impoart,
a.linea
from #factura b
left join venta v with (nolock)
on v.mov = b.padremavi
and v.movid = b.padreidmavi
and v.estatus = 'concluido'
left join ventad vd with (nolock)
on vd.id = v.id
left join art a with (nolock)
on a.articulo = vd.articulo) ar
left join #artcanc ac
on ac.padremavi = ar.padremavi
and ac.padreidmavi = ar.padreidmavi
and ac.artcancelado = ar.articulo
if exists (select top 1
id
from #bonifaplica
where bonificacion = 'bonificacion adelanto en pas')
begin
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#otrosdatos')
and type = 'u')
drop table #otrosdatos
select
d.*,
bc.montobonif boncc,
isnull(bonifaplipp, 0.00) bonifaplipp into #otrosdatos
from (select
d.padremavi,
d.padreidmavi,
sum(saldo) totsaldo,
sum(moratorios) totmoratorios,
sum(isnull(montobonif, 0)) bonpp
from #docs d
left join #temp b
on d.mov = b.mov
and d.movid = b.movid
and b.bonificacion like '%pa puntual%'
group by d.padremavi,
d.padreidmavi) d
left join #temp bc
on d.padremavi = bc.mov
and d.padreidmavi = bc.movid
and bc.bonificacion like '%contado comercial%'
left join #bonifaplipp ppa
on ppa.padremavi = d.padremavi
and ppa.padreidmavi = d.padreidmavi
insert into #temp (docto, idbonificacion, bonificacion, estacion, mov, movid, padremavi, padreidmavi, importefact, importedoc
, porcbon, montobonif, financiamiento, factor, plazoejefin, documento1de, documentototal, sucursal1, tiposucursal, lineavta, diasmenoresa, diasmayoresa, idventa
, uen, condicion, ok, okref, fechaemisionfact, vencimiento, idcrobo, lineacelulares, lineacredilanas, baseparaaplicar)
select
dc.id docto,
b.idbonif,
b.bonificacion,
dc.estacion,
dc.mov,
dc.movid,
dc.padremavi,
dc.padreidmavi,
dc.importefactfin,
dc.importefactfin / b.numdocs importedoc,
case
when dc.vencimiento > convert(datetime, convert(varchar(10), getdate(), 10)) then b.porcdescto
else 0.00
end porcdescto,
case
when dc.vencimiento > convert(datetime, convert(varchar(10), getdate(), 10)) then b.bonifap
else 0.00
end bonifap,
dc.financiamiento,
dc.factor,
dc.plazoejefin,
dc.documento1de,
b.numdocs,
dc.sucursal1,
dc.tiposucursal,
dc.lineavta,
dc.diasmenoresa,
dc.diasmayoresa,
dc.idventa,
dc.uen,
dc.condicion,
dc.ok,
dc.okref,
dc.fechaemisionfact,
dc.vencimiento,
dc.idcrobo,
dc.lineacelulares,
dc.lineacredilanas,
0 baseparaaplicar
from (
select
idbonif,
bonificacion,
padremavi,
padreidmavi,
case
when (totsaldo - bonifapcc) <= @importetotal then round(bonifapcc / numdocspend, 2)
else round(bonifappp / numdocspend, 2)
end bonifap,
numdocs,
porcdescto,
totsaldo
from (
select
f.idbonif,
f.bonificacion,
f.padremavi,
f.padreidmavi,
round(sum(importe_apcc * (porcdescto / 100)), 2) bonifapcc,
round(sum(importe_appp * (porcdescto / 100)), 2) bonifappp,
f.numdocs,
porcdescto,
totsaldo,
f.numdocspend
from (
select
bf.*,
((vd.impoart - otrasbonifccxart - (f.monedero * (vd.impoart / f.importefact))) / f.numdocs) * numdocsadel importe_apcc,
((vd.impoart - otrasbonifppxart - (f.monedero * (vd.impoart / f.importefact))) / f.numdocs) * numdocsadel importe_appp,
porcdescto = numdocsadel * case
when isnull(ml.porclin, 0) > 0 then ml.porclin
else porcbon1
end,
vd.articulo,
vd.impoart,
f.importefact,
f.numdocs
from (
select
a.*,
sum(case
when d.mov = 'documento' and
d.vencimiento > convert(datetime, convert(varchar(10), getdate(), 10)) then 1
else 0
end) numdocsadel,
sum(case
when estatus = 'pendiente' then 1
else 0
end) numdocspend,
otrasbonifpp / a.totart otrasbonifppxart,
otrasbonifcc / a.totart otrasbonifccxart
from (
select
b.idbonif,
b.bonificacion,
b.padremavi,
b.padreidmavi,
ba.bonpp + ba.bonifaplipp otrasbonifpp,
ba.boncc + ba.bonifaplipp otrasbonifcc,
ba.totsaldo,
b.factor,
b.totart,
b.porcbon1
from (
select
bn.id idbonif,
bn.bonificacion,
bn.padremavi,
bn.padreidmavi,
bn.factor,
count(d.articulo) totart,
bn.porcbon1
from #bonifaplica bn
left join #detalle d
on d.padremavi = bn.padremavi
and d.padreidmavi = bn.padreidmavi
where bn.bonificacion = 'bonificacion adelanto en pas'
group by bn.padremavi,
bn.bonificacion,
bn.padreidmavi,
bn.factor,
bn.id,
bn.porcbon1) b
left join #otrosdatos ba
on ba.padremavi = b.padremavi
and ba.padreidmavi = b.padreidmavi
group by b.idbonif,
b.bonificacion,
b.padremavi,
b.padreidmavi,
b.factor,
b.totart,
ba.bonpp,
ba.bonifaplipp,
ba.boncc,
ba.totsaldo,
b.porcbon1) a
left join #docs d
on a.padremavi = d.padremavi
and a.padreidmavi = d.padreidmavi
and d.mov != d.padremavi
where d.mov = 'documento'
and d.vencimiento > convert(datetime, convert(varchar(10), getdate(), 10))
group by a.idbonif,
a.bonificacion,
a.padremavi,
a.padreidmavi,
a.factor,
a.totart,
a.otrasbonifpp,
a.otrasbonifcc,
a.totsaldo,
a.porcbon1) bf
left join #factura f
on f.padremavi = bf.padremavi
and f.padreidmavi = bf.padreidmavi
left join #detalle vd
on vd.padremavi = bf.padremavi
and vd.padreidmavi = bf.padreidmavi
left join mavibonificacionlinea ml with (nolock)
on bf.idbonif = ml.idbonificacion
and vd.linea = ml.linea) f
group by f.idbonif,
f.bonificacion,
f.padremavi,
f.padreidmavi,
f.numdocspend,
f.numdocs,
f.porcdescto,
f.totsaldo) g) b
left join #bonficaciones dc
on dc.padremavi = b.padremavi
and dc.padreidmavi = b.padreidmavi
end
end
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#totpend')
and type = 'u')
drop table #totpend
select
padremavi,
padreidmavi,
count(id) totpendientes into #totpend
from #docs
where estatus = 'pendiente'
group by padremavi,
padreidmavi
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#final')
and type = 'u')
drop table #final
select
row_number() over (order by vencimiento) enum,
id,
padremavi,
padreidmavi,
round(max(saldo), 4) saldo,
round(max(moratorios), 4) moratorios,
round(max(saldo) - (max(bcc) / count(id)) - max(bap), 2) + case
when cobxpol = 'no' then round(max(moratorios), 4)
else 0.00
end patotal,
round(max(saldo) - max(bpp), 2) + case
when cobxpol = 'no' then round(max(moratorios), 4)
else 0.00
end cubrepp,
round(max(bpp), 2) bonifpp,
round(max(bap), 2) bonifap into #final
from (select
d.id,
d.padremavi,
d.padreidmavi,
d.saldo,
d.moratorios,
d.vencimiento,
isnull(t.montobonif / totpendientes, 0.00) bcc,
case
when td.bonificacion like '%pa puntual%' then isnull(td.montobonif, 0.00)
else 0.00
end bpp,
case
when td.bonificacion like '%adelanto%' then isnull(td.montobonif, 0.00)
else 0.00
end bap,
d.cobxpol
from (
select
dcs.id,
dcs.padremavi,
dcs.padreidmavi,
dcs.saldo,
moratorios,
t.totpendientes,
vencimiento,
cobxpol
from #docs dcs
left join #factura f
on f.padremavi = dcs.padremavi
and f.padreidmavi = dcs.padreidmavi
left join #totpend t
on t.padremavi = f.padremavi
and t.padreidmavi = f.padreidmavi
where dcs.estatus = 'pendiente') d
left join #temp t
on t.padremavi = d.padremavi
and t.padreidmavi = d.padreidmavi
and t.bonificacion like '%bonificacion contado comercial%'
left join #temp td
on d.id = td.docto
and td.bonificacion not like '%bonificacion contado comercial%') dc
group by padremavi,
padreidmavi,
id,
vencimiento,
cobxpol
if exists (select
count(idbonificacion)
from #temp
where bonificacion like '%adelanto en pas%')
begin
if (select
count(idbonificacion)
from #temp
where bonificacion like '%contado comercial%')
= 1
and (select
sum(patotal + moratorios)
from #final)
<= @importetotal
begin
if not exists (select
t.idbonificacion
from #temp t
join mavibonificacionincluye i with (nolock)
on i.idbonificacion = t.idbonificacion
and i.bonificacionno = 'bonificacion adelanto en pas'
and i.encascada != 'no'
where t.bonificacion like '%contado comercial%')
delete from #bonifaplica
where bonificacion = 'bonificacion adelanto en pas'
end
if (select
count(idbonificacion)
from #temp
where bonificacion like '%pa puntual%')
= 1
and (select
sum(saldo + moratorios) - sum(bonifpp) - sum(bonifap)
from #final)
<= @importetotal
begin
if not exists (select
t.idbonificacion
from #temp t
join mavibonificacionincluye i with (nolock)
on i.idbonificacion = t.idbonificacion
and i.bonificacionno = 'bonificacion adelanto en pas'
and i.encascada != 'no'
where t.bonificacion like '%adelanto en pas%')
delete from #bonifaplica
where bonificacion = 'bonificacion adelanto en pas'
end
end
declare @ini int,
@fin int
select
@ini = min(enum) + 1,
@fin = max(enum)
from #final
while @ini <= @fin
begin
update #final
set cubrepp = cubrepp + (select
cubrepp
from #final
where enum = @ini - 1)
where enum = @ini
set @ini = @ini + 1
end
if (select
count(idbonificacion)
from #temp
where bonificacion like '%contado comercial%')
= 1
and (select
sum(patotal + moratorios)
from #final)
<= @importetotal
insert into mavibonificaciontest (docto, idbonificacion, bonificacion, estacion, mov, movid, origen, origenid, importeventa, importedocto
, porcbon1, montobonif, financiamiento, factor, plazoejefin, documento1de, documentototal, sucursal1, tiposucursal, lineavta, diasmenoresa, diasmayoresa, idventa
, uen, condicion, ok, okref, fechaemision, vencimiento, idcobro, lineacelulares, lineacredilanas, baseparaaplicar)
select
docto,
idbonificacion,
bonificacion,
estacion,
mov,
movid,
padremavi,
padreidmavi,
importefact,
importedoc,
porcbon,
montobonif,
financiamiento,
factor,
plazoejefin,
documento1de,
documentototal,
sucursal1,
tiposucursal,
lineavta,
diasmenoresa,
diasmayoresa,
idventa,
uen,
condicion,
ok,
okref,
fechaemisionfact,
vencimiento,
idcrobo,
lineacelulares,
lineacredilanas,
baseparaaplicar
from #temp
where bonificacion not like '%pa puntual%'
else
if (select
sum(saldo + moratorios) - sum(bonifpp) - sum(bonifap)
from #final)
<= @importetotal
insert into mavibonificaciontest (docto, idbonificacion, bonificacion, estacion, mov, movid, origen, origenid, importeventa, importedocto
, porcbon1, montobonif, financiamiento, factor, plazoejefin, documento1de, documentototal, sucursal1, tiposucursal, lineavta, diasmenoresa, diasmayoresa, idventa
, uen, condicion, ok, okref, fechaemision, vencimiento, idcobro, lineacelulares, lineacredilanas, baseparaaplicar)
select
docto,
idbonificacion,
bonificacion,
estacion,
mov,
movid,
padremavi,
padreidmavi,
importefact,
importedoc,
porcbon,
montobonif,
financiamiento,
factor,
plazoejefin,
documento1de,
documentototal,
sucursal1,
tiposucursal,
lineavta,
diasmenoresa,
diasmayoresa,
idventa,
uen,
condicion,
ok,
okref,
fechaemisionfact,
vencimiento,
idcrobo,
lineacelulares,
lineacredilanas,
baseparaaplicar
from #temp
where bonificacion not like '%contado comercial%'
else
insert into mavibonificaciontest (docto, idbonificacion, bonificacion, estacion, mov, movid, origen, origenid, importeventa, importedocto
, porcbon1, montobonif, financiamiento, factor, plazoejefin, documento1de, documentototal, sucursal1, tiposucursal, lineavta, diasmenoresa, diasmayoresa, idventa
, uen, condicion, ok, okref, fechaemision, vencimiento, idcobro, lineacelulares, lineacredilanas, baseparaaplicar)
select
docto,
idbonificacion,
bonificacion,
estacion,
mov,
movid,
padremavi,
padreidmavi,
importefact,
importedoc,
porcbon,
montobonif,
financiamiento,
factor,
plazoejefin,
documento1de,
documentototal,
sucursal1,
tiposucursal,
lineavta,
diasmenoresa,
diasmayoresa,
idventa,
uen,
condicion,
ok,
okref,
fechaemisionfact,
vencimiento,
idcrobo,
lineacelulares,
lineacredilanas,
baseparaaplicar
from #temp
where bonificacion like '%pa puntual%'
if @importetotal >= (select
sum(patotal)
from #final)
select
@importetotal = sum(saldo) + sum(moratorios)
from #final
else
if @importetotal >= (select
sum(saldo + moratorios) - sum(bonifpp) - sum(bonifap)
from #final)
select
@importetotal = sum(saldo) + sum(moratorios)
from #final
else
if @importetotal < (select
sum(patotal)
from #final)
select
@importetotal = isnull(sum(bonifpp), 0) + @importetotal
from (select
case
when bonifpp > saldo then saldo
else bonifpp
end as bonifpp
from #final
where cubrepp <= @importetotal) f
select
@importetotal
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#factura')
and type = 'u')
drop table #factura
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#docs')
and type = 'u')
drop table #docs
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#bonifaplica')
and type = 'u')
drop table #bonifaplica
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#bonficaciones')
and type = 'u')
drop table #bonficaciones
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#temp')
and type = 'u')
drop table #temp
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#bonifaplipp')
and type = 'u')
drop table #bonifaplipp
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#artcanc')
and type = 'u')
drop table #artcanc
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#detalle')
and type = 'u')
drop table #detalle
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#otrosdatos')
and type = 'u')
drop table #otrosdatos
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#totpend')
and type = 'u')
drop table #totpend
if exists (select
name
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#final')
and type = 'u')
drop table #final
end