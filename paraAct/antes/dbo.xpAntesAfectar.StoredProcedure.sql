create proc [dbo].[xpantesafectar] @modulo char(5),
@id int,
@accion char(20),
@base char(20),
@generarmov char(20),
@usuario char(10),
@sincrofinal bit,
@ensilencio bit,
@ok int output,
@okref varchar(255) output,
@fecharegistro datetime
as
begin
declare @mov varchar(20),
@estatus varchar(20),
@movtipo varchar(20),
@situacion varchar(50),
@proveedor varchar(20),
@encontrado int,
@diferente int,
@numreg int,
@comentarios varchar(255),
@cliente varchar(15),
@empresa char(5),
@cantidad int,
@renglonid varchar(3),
@articulo varchar(20),
@reg int,
@error int,
@provtipo varchar(30),
@concepto varchar(50),
@tipocte varchar(15),
@prefijocte varchar(2),
@nulocopia bit,
@gpotrabajo varchar(50),
@condicion varchar(50),
@condicion2 varchar(50),
@cteenviara int,
@importetotal money,
@dineroid int,
@origen varchar(20),
@origenid varchar(20),
@clave varchar(20),
@idorigen int,
@costo money,
@costoant money,
@almacen varchar(10),
@mensaje varchar(100),
@iva float,
@ivafiscal float,
@financiamiento money,
@capital float,
@renglon float,
@saldototal money,
@agente varchar(10),
@nivelcobranza varchar(100),
@importearefinanciar money,
@condref varchar(50),
@aplicamanual bit,
@aplica varchar(20),
@aplicaid varchar(20),
@vencimiento datetime,
@aplicamanualcxc bit,
@origencob varchar(20),
@ccateria int,
@personal varchar(10),
@estado bit,
@padremavi varchar(20),
@padremaviid varchar(20),
@cont int,
@contfinal int,
@idaux int,
@rfccompleto int,
@devorigen int,
@facdesgloseiva bit,
@artp varchar(20),
@precio money,
@precioart money,
@precioanterior money,
@agente2 varchar(20),
@licencia varchar(20),
@licencia2 varchar(20),
@ruta varchar(50),
@estatussol varchar(20),
@movidsol varchar(20),
@movsol varchar(20),
@fechaemision datetime,
@fechaactual datetime,
@tipocobro int,
@fechacobroantxpol datetime,
@directo bit,
@condesglose bit,
@almacenorigen varchar(15),
@almacendestino varchar(15),
@almacenorigentipo varchar(15),
@almacendestinotipo varchar(15),
@redime bit,
@bloq varchar(15),
@suc int
set @suc = (select top 1
sucursal
from venta with (nolock)
where id = @id)
set @fechaactual = getdate()
set @fechaactual = convert(varchar(8), @fechaactual, 112)
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#validaconceptogas')
and type = 'u')
drop table #validaconceptogas
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#cobro')
and type = 'u')
drop table #cobro
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#cobroaplica')
and type = 'u')
drop table #cobroaplica
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#temp2')
and type = 'u')
drop table #temp2
select
@mov = null
select
@movtipo = null
select
@cliente = null
select
@tipocte = null
select
@prefijocte = null
select
@nulocopia = 0
set @dineroid = null
if @modulo = 'vtas'
begin
select
@mov = mov,
@estatus = estatus
from venta with (nolock)
where id = @id
if @mov in ('factura', 'factura mayoreo', 'factura viu')
and @estatus <> 'concluido'
and @accion <> 'cancelar'
begin
if dbo.fn_validarexistenciainv(@id) in (2)
select
@ok = 20020
end
end
if @modulo = 'coms'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'coms',
@ok output,
@okref output
end
if @modulo = 'cxc'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'cxc',
@ok output,
@okref output
end
if @modulo = 'cxp'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'cxp',
@ok output,
@okref output
end
if @modulo = 'vtas'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'vtas',
@ok output,
@okref output
end
if @modulo = 'din'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'din',
@ok output,
@okref output
end
if @modulo = 'inv'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'inv',
@ok output,
@okref output
select
@mov = mov
from inv with (nolock)
where id = @id
if (@mov = 'recibo traspaso')
exec spvalidaseriedevuelta @id,
@ok output,
@okref output
select
@almacenorigen = almacen,
@almacendestino = almacendestino
from inv with (nolock)
where id = @id
if (@almacenorigen is not null)
and (@almacendestino is not null)
begin
select
@almacenorigentipo = tipo
from alm with (nolock)
where almacen = @almacenorigen
select
@almacendestinotipo = tipo
from alm with (nolock)
where almacen = @almacendestino
if @almacenorigentipo <> @almacendestinotipo
select
@ok = 20120
end
end
if @modulo = 'st'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'st',
@ok output,
@okref output
end
if @modulo = 'agent'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'agent',
@ok output,
@okref output
end
if @modulo = 'emb'
and @accion in ('afectar', 'verificar')
begin
exec spvalidanivelaccesoagente @id,
'emb',
@ok output,
@okref output
end
if @modulo = 'cxp'
and @accion = 'afectar'
begin
select
@estatus = estatus,
@mov = mov,
@situacion = situacion
from cxp with (nolock)
where id = @id
if @estatus = 'sinafectar'
and @mov in ('aplicacion', 'canc acuerdo espejo')
and @situacion is null
begin
select
@ok = 99990
end
end
if @modulo = 'din'
and @accion <> 'cancelar'
begin
select
@mov = mov,
@directo = directo,
@condesglose = condesglose
from dinero with (nolock)
where id = @id
select
@clave = clave
from movtipo with (nolock)
where mov = @mov
if @clave = 'din.tc'
and @condesglose = 0
and @directo = 1
delete dinerod
where id = @id
end
if @modulo = 'din'
and @accion = ('afectar')
begin
select
@mov = mov,
@importetotal = importe
from dinero with (nolock)
where id = @id
select
@clave = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
if (@clave = 'din.a')
begin
if (@importetotal > 0)
update dinero
set importe = 0.0
where id = @id
end
end
if @modulo = 'inv'
and @accion = 'afectar'
begin
select
@estatus = estatus,
@mov = mov,
@situacion = situacion
from inv with (nolock)
where id = @id
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
if @estatus = 'sinafectar'
and @mov in ('devolucion transito', 'ajuste')
and @situacion is null
begin
select
@ok = 99990
end
if @estatus = 'sinafectar'
and @movtipo in ('inv.if')
and @situacion is null
begin
select
@ok = 99990
end
if @movtipo in ('inv.a', 'inv.if')
begin
if exists (select
*
from art a with (nolock),
inv b with (nolock),
invd c with (nolock)
where b.id = c.id
and c.articulo = a.articulo
and b.id = @id
and a.cateria in ('activos fijos'))
begin
select
@ok = 100026
end
end
end
if @modulo = 'gas'
and @accion = 'afectar'
begin
select
@estatus = estatus,
@mov = mov,
@situacion = situacion
from gasto with (nolock)
where id = @id
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
if @estatus = 'sinafectar'
and @mov in ('comprobante inst', 'amortizacion', 'consumo')
and @situacion is null
begin
select
@ok = 99990
end
if @estatus = 'sinafectar'
and @mov in ('contrato')
begin
exec spsolgastocontratoaf @id
end
if @estatus = 'sinafectar'
and exists (select top 1
mov
from empresaconceptovalidar with (nolock)
where modulo = @modulo
and mov = @mov)
begin
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#validaconceptogas')
and type = 'u')
drop table #validaconceptogas
select
g.id,
g.mov,
g.movid,
gasconcepto = d.concepto,
validaconcepto = c.concepto into #validaconceptogas
from dbo.gasto g with (nolock)
inner join dbo.gastod d with (nolock)
on g.id = d.id
and g.id = @id
left join dbo.empresaconceptovalidar c with (nolock)
on c.mov = g.mov
and c.empresa = g.empresa
and c.modulo = @modulo
and c.concepto = d.concepto
group by g.id,
g.mov,
g.movid,
d.concepto,
c.concepto
select
@concepto = isnull(gasconcepto, '')
from #validaconceptogas with (nolock)
where isnull(gasconcepto, '') <> isnull(validaconcepto, '')
if exists (select
gasconcepto
from #validaconceptogas with (nolock)
where gasconcepto = '*')
select
@ok = 20481,
@okref = 'concepto "*" '
if isnull(@concepto, '') <> ''
select
@ok = 20485,
@okref = rtrim(@mov) + ' (' + rtrim(@concepto) + ')'
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#validaconceptogas')
and type = 'u')
drop table #validaconceptogas
end
end
if @modulo = 'coms'
and @accion in ('afectar', 'verificar')
begin
select
@estatus = estatus,
@mov = mov,
@situacion = situacion,
@origen = origen,
@origenid = origenid
from compra with (nolock)
where id = @id
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
if @estatus = 'sinafectar'
and @mov in ('compra consignacion', 'entrada compra', 'entrada con gastos', 'remision')
and @situacion is null
begin
select
@ok = 99990
end
if not exists (select
c.proveedor,
d.articulo
from compra c with (nolock)
inner join comprad d with (nolock)
on d.id = c.id
inner join dm0289configarticulos ca with (nolock)
on ca.articulo = d.articulo
inner join dm0289configproveedores cp with (nolock)
on cp.proveedor = c.proveedor
inner join usuario u with (nolock)
on u.usuario = c.usuario
inner join dm0289configgrupotrabajo gt with (nolock)
on gt.grupotrabajo = u.grupotrabajo
where c.id = @id
and mov = 'devolucion compra')
begin
if @mov in ('orden devolucion', 'devolucion compra')
begin
if exists (select
idcopiamavi
from comprad with (nolock)
where idcopiamavi is null
and id = @id)
select
@nulocopia = 1
if @nulocopia = 1
select
@ok = 99992
else
exec spvalidarcantidaddevmavi @id,
@modulo,
@ok output,
@okref output
end
end
if @estatus = 'sinafectar'
and @mov in ('solicitud compra')
begin
if exists (select
c.id
from comprad cd with (nolock)
inner join compra c with (nolock)
on cd.id = c.id
inner join art a with (nolock)
on cd.articulo = a.articulo
where c.planeador = 0
and a.cateria = 'venta'
and c.id = @id)
select
@ok = 99990
end
if @movtipo in ('coms.f', 'coms.ei', 'coms.eg')
begin
select
@clave = clave
from movtipo with (nolock)
where modulo = 'coms'
and mov = @origen
if @clave = 'coms.o'
begin
select
@idorigen = id
from compra with (nolock)
where mov = @origen
and movid = @origenid
declare crdetalle cursor local for
select
articulo,
isnull(costo, 0),
almacen
from comprad with (nolock)
where id = @id
open crdetalle
fetch next from crdetalle into @articulo, @costo, @almacen
while @@fetch_status <> -1
begin
if @@fetch_status <> -2
begin
select
@costoant = isnull(costo, 0)
from comprad with (nolock)
where id = @idorigen
and articulo = @articulo
if @costo > @costoant
begin
set @ok = 80110
set @okref = 'movimiento bloqueado: el costo excede al m ximo indicado en la orden de compra. art¡culo: ' + cast(@articulo as varchar(50)) + ' costo: $' + cast(@costo as varchar(15))
end
end
fetch next from crdetalle into @articulo, @costo, @almacen
end
close crdetalle
deallocate crdetalle
end
end
end
if @modulo = 'cxc'
and @accion in ('afectar', 'verificar')
begin
select
@aplicamanual = aplicamanual,
@estatus = estatus,
@mov = mov,
@situacion = situacion,
@origen = origen,
@origenid = origenid,
@concepto = concepto
from cxc with (nolock)
where id = @id
select
@aplicamanualcxc = aplicacionmanualcxcmavi
from usuariocfg2 with (nolock)
where usuario = @usuario
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
if (@aplicamanual = 0
and exists (select
id
from cxcd with (nolock)
where id = @id)
and @mov <> 'sol refinanciamiento')
delete from cxcd
where id = @id
if @mov in ('nota car')
exec spvalidarmayor12meses @id,
@mov,
'cxc'
if not exists (select
count(*)
from neciamoratoriosmavi with (nolock)
where idcobro = @id)
and @origen is null
and (@aplicamanualcxc = 0
or @aplicamanualcxc is null)
and @movtipo = 'cxc.c'
begin
set @ok = 100029
end
else
if (@aplicamanualcxc = 0
or @aplicamanualcxc is null)
and @movtipo = 'cxc.c'
and @origen is not null
begin
set @ok = 100022
end
else
if @origen is null
and (@aplicamanualcxc = 0
or @aplicamanualcxc is null)
and @movtipo = 'cxc.c'
and (select
count(*)
from neciamoratoriosmavi with (nolock)
where idcobro = @id)
= 0
begin
set @ok = 100029
end
if @movtipo = 'cxc.c'
begin
select
@tipocobro = tipocobro
from tipocobromavi with (nolock)
where idcobro = @id
if @tipocobro = 0
begin
declare crcobrop cursor for
select
origen,
origenid
from neciamoratoriosmavi with (nolock)
where idcobro = @id
group by origen,
origenid
open crcobrop
fetch next from crcobrop into @origen, @origenid
while @@fetch_status <> -1
begin
if @@fetch_status <> -2
begin
select
@fechacobroantxpol = dbo.fnfechasinhora(fechaemision)
from cxc with (nolock)
where id = (select
max(idcobro)
from neciamoratoriosmavi with (nolock)
where origen = @origen
and origenid = @origenid
and idcobro < @id
and idcobro in (select
t.idcobro
from tipocobromavi t with (nolock)
where t.tipocobro = 1))
if dbo.fnfechasinhora(@fechacobroantxpol) = dbo.fnfechasinhora(getdate())
begin
set @ok = '100036'
set @okref = 'ya existe un cobro previo por politica'
end
end
fetch next from crcobrop into @origen, @origenid
end
close crcobrop
deallocate crcobrop
end
end
if @estatus = 'sinafectar'
and (@movtipo in ('cxc.c', 'cxc.dp')
or @mov = 'cheque posfechado')
and @aplicamanual = 1
and @ok is null
and not exists (select
idcobro
from neciamoratoriosmavi with (nolock)
where idcobro = @id)
begin
create table #temp2 (
origen varchar(20),
origenid varchar(20),
mov varchar(20),
movid varchar(20),
vencimiento datetime
)
create table #cobro (
mov varchar(20) not null,
movid varchar(20) not null,
importecobro money null
)
create table #cobroaplica (
idmov int,
mov varchar(20) not null,
movid varchar(20) not null,
padremavi varchar(20) null,
padremaviid varchar(20) null,
concepto varchar(50) null,
numdoc int null,
listo bit default 0,
idvence int,
importecobro money null,
saldo money null,
vencimiento datetime
)
insert into #cobro (mov, movid, importecobro)
select
aplica,
aplicaid,
importe
from cxcd with (nolock)
where id = @id
and aplica in ('documento', 'contra recibo', 'contra recibo inst', 'nota car', 'nota car viu', 'nota car mayoreo')
insert into #cobroaplica (idmov, mov, movid, padremavi, padremaviid, concepto, vencimiento, numdoc, idvence, importecobro, saldo)
select
c.id,
ca.mov,
ca.movid,
c.padremavi,
c.padreidmavi,
c.concepto,
c.vencimiento,
count(0) over (partition by c.padremavi, c.padreidmavi),
row_number() over (partition by c.padremavi, c.padreidmavi order by c.vencimiento),
ca.importecobro,
c.saldo
from cxc c with (nolock)
join #cobro ca
on ca.mov = c.mov
and ca.movid = c.movid
where (c.mov in ('documento', 'contra recibo', 'contra recibo inst')
or (c.mov in ('nota car', 'nota car viu', 'nota car mayoreo')
and c.concepto in ('canc cobro factura', 'canc cobro factura viu', 'canc cobro mayoreo', 'canc cobro cred y pp', 'canc cobro seg auto', 'canc cobro seg vida')))
and c.estatus not in ('cancelado')
declare crcxcd cursor for
select
ca.padremavi,
ca.padremaviid,
ca.numdoc
from #cobroaplica ca with (nolock)
group by ca.padremavi,
ca.padremaviid,
ca.numdoc
open crcxcd
fetch next from crcxcd into @padremavi, @padremaviid, @contfinal
while @@fetch_status <> -1
begin
if @@fetch_status <> -2
begin
select
@cont = 1
while @cont <= @contfinal
begin
select
@aplica = mov,
@aplicaid = ca.movid,
@vencimiento = vencimiento,
@idaux = ca.idmov
from #cobroaplica ca with (nolock)
where ca.padremavi = @padremavi
and ca.padremaviid = @padremaviid
and ca.idvence = @cont
if @aplica in ('nota car', 'nota car viu', 'nota car mayoreo')
begin
insert into #temp2
select
padremavi,
padreidmavi,
mov,
movid,
vencimiento
from cxc with (nolock)
where id in (select
id
from movcampoextra with (nolock)
where modulo = 'cxc'
and valor = @padremavi + '_' + @padremaviid)
and estatus in ('pendiente')
and id <> @idaux
and vencimiento < @vencimiento
and id not in (select
idmov
from #cobroaplica ca with (nolock)
where padremavi = @padremavi
and padremaviid = @padremaviid
and ca.listo = 1)
order by vencimiento desc
end
else
begin
insert into #temp2
select
origen,
origenid,
mov,
movid,
vencimiento
from cxcpendiente with (nolock)
where origen = @padremavi
and origenid = @padremaviid
and not (movid = @aplicaid
and mov = @aplica)
and vencimiento < @vencimiento
and id not in (select
idmov
from #cobroaplica ca with (nolock)
where padremavi = @padremavi
and padremaviid = @padremaviid
and ca.listo = 1)
order by vencimiento asc
end
if @cont <> @contfinal
begin
update #cobroaplica
set listo = 1
where importecobro = saldo
and padremavi = @padremavi
and padremaviid = @padremaviid
and idvence = @cont
end
select
@cont = @cont + 1
end
if exists (select
vencimiento
from #temp2)
begin
select
@ok = 100020
end
end
fetch next from crcxcd into @padremavi, @padremaviid, @contfinal
end
close crcxcd
deallocate crcxcd
end
if @mov in ('nota credito', 'nota credito viu', 'nota credito mayoreo', 'cancela prestamo', 'cancela credilana')
and @concepto like 'corr cobro%'
begin
if (select
count(*)
from (select distinct
padre.id
from cxc c with (nolock)
join cxcd d with (nolock)
on d.id = c.id
join cxc f with (nolock)
on f.mov = d.aplica
and f.movid = d.aplicaid
join cxc padre with (nolock)
on padre.mov = f.padremavi
and padre.movid = f.padreidmavi
where c.id = @id) as padres)
> 1
select
@ok = 100035
end
end
if @modulo = 'cxc'
and @accion in ('afectar', 'verificar')
and @ok is null
begin
select
@agente = agente,
@financiamiento = financiamiento,
@estatus = estatus,
@mov = mov,
@situacion = situacion,
@origen = origen,
@origenid = origenid,
@saldototal = (isnull(importe, 0) + isnull(impuestos, 0))
from cxc with (nolock)
where id
=
@id
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
select
@importetotal = importe
from cxc with (nolock)
where id = @id
if @mov = 'cobro'
begin
if (select
valorafectar
from cxc with (nolock)
where id = @id)
= 1
begin
if isnull(@importetotal, 0) = 0
begin
select
@ok = 40140
end
if (select
aplicamanual
from cxc with (nolock)
where id = @id)
<> 1
and isnull(@importetotal, 0) <> 0
begin
select
@ok = 20170
end
update cxc with (rowlock)
set valorafectar = 0
where id = @id
end
end
if @estatus = 'sinafectar'
and @mov in ('dev anticipo contado', 'devolucion apartado')
and @situacion is null
begin
select
@ok = 99990
end
if @mov = 'aplicacion'
begin
exec spvalidarctasincobrablemavi @id,
@mov,
@ok output,
@okref output,
0
end
else
if (@mov in ('nota credito mayoreo', 'nota credito', 'nota credito viu', 'cancela credilana', 'cancela prestamo', 'cancela seg auto', 'cancela seg vida'))
begin
exec spvalidarctasincobrablemavi @id,
@mov,
@ok output,
@okref output,
0
end
if @mov in ('prestamo', 'diversos deudores')
begin
select
@prefijocte = substring(cte.cliente, 1, 1),
@tipocte = cte.tipo,
@condicion = cxc.condicion,
@cteenviara = cxc.clienteenviara
from cte with (nolock),
cxc with (nolock)
where cte.cliente = cxc.cliente
and cxc.id = @id
select
@condicion2 = cadena
from ventascanalmavi with (nolock)
where id = @cteenviara
if @tipocte <> 'deudor'
or @prefijocte <> 'd'
or @condicion2 <> 'contado ma'
or @cteenviara <> 2
or @condicion <> 'contado deudor'
begin
select
@ok = 99990
end
end
if @mov = 'cobro div deudores'
begin
select
@prefijocte = substring(cte.cliente, 1, 1),
@tipocte = cte.tipo,
@condicion = cxc.condicion,
@cteenviara = cxc.clienteenviara
from cte with (nolock),
cxc with (nolock)
where cte.cliente = cxc.cliente
and cxc.id = @id
select
@condicion2 = cadena
from ventascanalmavi with (nolock)
where id = @cteenviara
if @tipocte <> 'deudor'
or @prefijocte <> 'd'
or @condicion2 <> 'contado ma'
or @cteenviara <> 2
begin
select
@ok = 99990
end
end
if ((select
db_name())
= 'mavicob')
if @mov = 'documento'
and @estatus = 'sinafectar'
and @movtipo = 'cxc.d'
select
@ok = 60160
if ((select
db_name())
= 'intelisistmp')
if @mov = 'documento'
and @estatus = 'sinafectar'
select
@ok = 60160
if @mov = 'contra recibo inst'
and @estatus = 'sinafectar'
begin
if (select
count(id)
from cxcd with (nolock)
where id = @id)
> 1
select
@ok = 100001
if exists (select
id
from cxcd with (nolock)
where id = @id
and aplica in ('contra recibo inst', 'cta incobrable f', 'cta incobrable nv'))
select
@ok = 100002
end
if @movtipo = 'cxc.fac'
and @estatus = 'sinafectar'
begin
if exists (select
id
from cxc with (nolock)
where id = @id
and movaplica in ('contra recibo inst', 'cta incobrable f', 'cta incobrable nv'))
select
@ok = 100003
else
exec spvalidarctasincobrablemavi @id,
'endoso',
@ok output,
@okref output,
0
end
if @mov in ('cta incobrable nv')
exec spvalidarctasincobrablemavi @id,
@mov,
@ok output,
@okref output,
1
if @mov in ('cta incobrable f')
exec spvalidarctasincobrablemavi @id,
@mov,
@ok output,
@okref output,
1
if @mov = 'react incobrable f'
begin
if exists (select
cd.id
from cxcd cd with (nolock)
where cd.id = @id
and cd.aplica not in ('cta incobrable f'))
select
@ok = 100002
if (select
count(id)
from cxcd with (nolock)
where id = @id)
> 1
select
@ok = 100001
end
if @mov = 'react incobrable nv'
begin
if exists (select
cd.id
from cxcd cd with (nolock)
where cd.id = @id
and cd.aplica not in ('cta incobrable nv'))
select
@ok = 100002
if (select
count(id)
from cxcd with (nolock)
where id = @id)
> 1
select
@ok = 100001
end
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.aa')
begin
select
@ok =
case dbo.fnesmismocanalmavi(@id)
when 0 then 100007
when 2 then 100013
end
if (select
dbo.fnvalidarvaloranticipomavi(@id))
<> 1
select
@ok = 100008
end
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.de')
begin
exec xpvalidardevolucionmavi @id,
@ok output
if (@ok is null)
begin
select
@importetotal = importe
from cxc with (nolock)
where id = @id
if (@importetotal is null)
select
@ok = 40140
end
end
if @mov = 'sol refinanciamiento'
and @estatus in ('sinafectar', 'pendiente')
begin
select
@importearefinanciar = 0
if (select
isnull(importe, 0.0)
from cxc with (nolock)
where id = @id)
<= 0.0
select
@ok = 99996
if @ok = null
if exists (select
cxcd.id
from cxcd with (nolock)
where cxcd.id = @id
and dbo.fniddelmovimientomavi(cxcd.aplica, cxcd.aplicaid) not in (select
idorigen
from mavirefinaciamientos with (nolock)
where id = @id))
select
@ok = 100015
if @ok is null
begin
select
@importearefinanciar = sum(isnull(dbo.fnsaldopendientemovpadremavi(idorigen), 0))
from mavirefinaciamientos with (nolock)
where id = @id
if isnull(@saldototal, 0) <> isnull(@importearefinanciar, 0)
select
@ok = 100016
end
if @ok is null
if (@agente is null)
or (@agente = '')
or (isnull(@agente, '') = '')
select
@ok = 20930
end
if @mov = 'refinanciamiento'
and isnull(@origen, '') = ''
and isnull(@origenid, '') = ''
begin
set @ok = 60160
select
@mensaje = descripcion
from mensajelista with (nolock)
where mensaje = @ok
end
if @mov = 'refinanciamiento'
and @estatus = 'sinafectar'
begin
update cxc with (rowlock)
set escredilana = 1
where id = @id
end
if @mov = 'refinanciamiento'
and @estatus = 'sinafectar'
and @saldototal = 0
begin
set @ok = 99996
end
if @mov = 'refinanciamiento'
and @estatus = 'sinafectar'
begin
if @ok = null
begin
select
@importearefinanciar = null
select
@idorigen = dbo.fniddelmovimientomavi(@origen, @origenid)
select
@importearefinanciar = sum(isnull(dbo.fnsaldopendientemovpadremavi(idorigen), 0))
from mavirefinaciamientos with (nolock)
where id = @idorigen
select
@saldototal = isnull(@saldototal, 0) - isnull(@financiamiento, 0)
if isnull(@saldototal, 0) <> isnull(@importearefinanciar, 0)
select
@ok = 100016
end
end
if (@mov in ('cta incobrable f', 'cta incobrable nv')
and @estatus = 'sinafectar'
and @ok is null)
exec spctaincmigramavicob @id,
@usuario,
@ok output,
@okref output
if (@movtipo = 'cxc.nc'
and @estatus = 'sinafectar')
exec spcambiaestadoenviomavicob @id,
@accion
if (@mov = 'cheque posfechado'
and @ok is null)
exec spvalidaaplicacionchequepos @id,
@ok output,
@okref output
end
if @modulo = 'cxc'
and @accion = 'generar'
begin
select
@importearefinanciar = 0
select
@financiamiento = financiamiento,
@condref = condref,
@estatus = estatus,
@mov = mov,
@situacion = situacion,
@origen = origen,
@origenid = origenid,
@saldototal = (isnull(importe, 0) + isnull(impuestos, 0))
from cxc with (nolock)
where id = @id
if @mov = 'sol refinanciamiento'
and @estatus = 'pendiente'
begin
if @estatus = 'pendiente'
and @ok = null
begin
if (isnull(@condref, '') = ''
or @condref = '')
select
@ok = 100017
if @financiamiento <= 0
select
@ok = 100018
end
if @saldototal <= 0.0
select
@ok = 99996
if @ok = null
if exists (select
cxcd.id
from cxcd with (nolock)
where cxcd.id = @id
and dbo.fniddelmovimientomavi(cxcd.aplica, cxcd.aplicaid) not in (select
idorigen
from mavirefinaciamientos with (nolock)
where id = @id))
select
@ok = 100015
if @ok = null
begin
select
@importearefinanciar = sum(isnull(dbo.fnsaldopendientemovpadremavi(idorigen), 0))
from mavirefinaciamientos with (nolock)
where id = @id
if isnull(@saldototal, 0) <> isnull(@importearefinanciar, 0)
select
@ok = 100016
end
end
end
if @modulo = 'cxc'
and @accion = 'cancelar'
begin
exec spvalidanocancelarcobrosintermediosmavi @modulo,
@id,
@accion,
@base,
@ensilencio,
@ok output,
@okref output,
@fecharegistro
select
@estatus = estatus,
@mov = mov,
@situacion = situacion
from cxc with (nolock)
where id = @id
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.aa')
begin
if (select
isnull(saldoaplicadomavi, 0.0) + isnull(saldodevueltomavi, 0.0)
from cxc with (nolock)
where id = @id)
> 0
set @ok = 100009
end
if @mov = 'aplicacion saldo'
begin
declare @movref varchar(50),
@movidref varchar(50)
select
@movref = aplica,
@movidref = aplicaid
from cxcd with (nolock)
where id = @id
if (select
estatus
from cxc with (nolock)
where mov = @movref
and movid = @movidref)
= 'concluido'
set @ok = 100010
end
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.c')
begin
select
@fechaemision = convert(varchar(8), fechaemision, 112)
from cxc with (nolock)
where id = @id
if @fechaemision <> @fechaactual
begin
set @ok = '60050'
end
end
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.est')
and @mov = 'sol refinanciamiento'
begin
select
@estatussol = estatus,
@movsol = mov,
@movidsol = movid
from cxc with (nolock)
where id = @id
if @estatussol in ('concluido', 'pendiente')
begin
if exists (select
mov
from cxc with (nolock)
where origen = @movsol
and origenid = @movidsol
and mov = 'refinanciamiento'
and estatus not in ('cancelado'))
set @ok = 30151
end
end
if (dbo.fnclaveafectacionmavi(@mov, 'cxc') = 'cxc.nc')
begin
if (select
h.estatus
from cxcd d with (nolock)
join movtipo m with (nolock)
on d.aplica = m.mov
and m.clave = 'cxc.dm'
and m.modulo = 'cxc'
join cxc c with (nolock)
on c.mov = d.aplica
and c.movid = d.aplicaid
join ctasmavicobhist h with (nolock)
on c.id = h.idctaincobrable
where d.id = @id)
= 'enviado'
begin
select
@ok = 100036
end
else
begin
exec spcambiaestadoenviomavicob @id,
@accion
end
end
if (dbo.fnclaveafectacionmavi(@mov, 'cxc') = 'cxc.dm')
and @accion = 'cancelar'
begin
if (select
estatus
from ctasmavicobhist with (nolock)
where idctaincobrable = @id)
= 'enviado'
select
@ok = 100036
end
end
if @modulo = 'emb'
and @accion = 'afectar'
begin
select
@agente = agente,
@estatus = estatus,
@mov = mov,
@situacion = situacion
from embarque with (nolock)
where id = @id
select
@nivelcobranza = nivelcobranzamavi
from agente with (nolock)
where agente = @agente
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = @modulo
if @estatus = 'sinafectar'
and @mov in ('embarque mayoreo', 'embarque', 'embarque sucursal', 'embarque magisterio')
and @situacion is null
begin
select
@ok = 99990
end
else
if (@mov = 'orden cobro'
and @estatus = 'sinafectar')
if exists (select
cx.mov,
cx.movid
from embarqued ed with (nolock)
join embarquemov em with (nolock)
on ed.embarquemov = em.id
and em.modulo = 'cxc'
join cxc cx with (nolock)
on em.moduloid = cx.id
join cte cte with (nolock)
on cte.cliente = cx.cliente
left outer join cteenviara e with (nolock)
on e.id = cx.clienteenviara
and e.cliente = cx.cliente
where ed.id = @id
and isnull(e.nivelcobranzamavi, 'sin nivel') <> @nivelcobranza)
select
@ok = 100014
select
@agente = agente,
@mov = mov,
@agente2 = agente2,
@licencia = licenciaagente,
@licencia2 = licenciaagente2,
@ruta = ruta
from embarque with (nolock)
where id = @id
if (@estatus = 'sinafectar'
and @mov <> 'orden cobro')
begin
if (ltrim(rtrim(@agente)) in ('', null))
select
@ok = 60260,
@okref = ' agente '
if (ltrim(rtrim(@licencia)) in ('', null))
select
@ok = 60260,
@okref = ' licencia '
if (ltrim(rtrim(@ruta)) in ('', null))
select
@ok = 60260,
@okref = ' ruta '
if (@agente2 not in ('', null)
and ltrim(rtrim(@licencia2)) in ('', null))
select
@ok = 60260,
@okref = ' licencia agente 2 '
end
end
if @modulo = 'af'
and @accion = 'afectar'
begin
select
@estatus = estatus,
@mov = mov,
@situacion = situacion,
@concepto = concepto,
@personal = isnull(personal, 'sinasignar')
from activofijo with (nolock)
where id = @id
if @estatus = 'sinafectar'
and @mov in ('mantenimiento ligero', 'mantenimiento severo')
and ((@situacion is null)
or (@situacion = 'por autorizar'))
begin
if @concepto = 'omitir mannto'
select
@ok = 99990
end
if @mov = 'asignacion'
begin
if @personal in ('sinasignar', ' ')
begin
select
@ok = 100027
end
end
select
@proveedor = proveedor
from activofijo with (nolock)
where id = @id
if (@estatus = 'sinafectar'
and @mov in ('mannto maquinaria', 'mantenimiento', 'mantenimiento ligero', 'mantenimiento severo',
'poliza mantenimiento', 'poliza seguro', 'reparacion'))
begin
if (ltrim(rtrim(@proveedor)) in ('', null))
select
@ok = 40020
end
end
if @modulo = 'vtas'
and @accion = 'afectar'
begin
select
@mov = mov,
@cliente = cliente
from venta with (nolock)
where id = @id
select
@importetotal = sum(isnull(cantidad, 0) * isnull(precio, 0))
from ventad with (nolock)
where id = @id
select
@movtipo = clave
from movtipo with (nolock)
where mov = @mov
and modulo = 'vtas'
if @mov in ('devolucion venta', 'devolucion venta viu', 'devolucion mayoreo', 'cancela credilana', 'cancela prestamo', 'cancela seg auto', 'cancela seg vida')
begin
select
@mov = (select
origen
from venta with (nolock)
where id = @id)
if (select
origen
from venta with (nolock)
where id = @id)
= 'sol dev unicaja'
begin
exec xpvalidarmovsoldevunicaja @id,
@ok output,
2
end
else
if (select
origen
from venta with (nolock)
where id = @id)
= 'solicitud devolucion'
begin
exec xpvalidarmovsoldevolucion @id,
@ok output,
2
end
else
if (select
origen
from venta with (nolock)
where id = @id)
= 'sol dev mayoreo'
begin
exec xpvalidarmovsoldevolucion @id,
@ok output,
4
end
end
if @importetotal <= 0
and dbo.fnclaveafectacionmavi(@mov, 'vtas') in ('vtas.p', 'vtas.f')
select
@ok = 99996
if @mov not in ('analisis mayoreo', 'solicitud mayoreo', 'analisis credito', 'solicitud credito')
begin
select
@tipocte = tipo
from cte with (nolock)
where cliente = @cliente
select
@prefijocte = left(@cliente, 1)
if @prefijocte = 'p'
or @tipocte = 'prospecto'
select
@ok = 99991
end
else
begin
if @mov in ('analisis credito', 'solicitud credito')
if exists (select
*
from venta v with (nolock)
left outer join condicion c with (nolock)
on v.condicion = c.condicion
where v.id = @id
and c.tipocondicion = 'contado')
select
@ok = 99997
end
if dbo.fnclaveafectacionmavi(@mov, 'vtas') in ('vtas.d', 'vtas.sd')
begin
if @mov = 'sol dev unicaja'
begin
if exists (select
idcopiamavi
from ventad with (nolock)
where idcopiamavi is not null
and id = @id)
select
@ok = 99995
else
begin
exec xpvalidarmovsoldevunicaja @id,
@ok output,
1
select
@nulocopia = 0
select
@gpotrabajo = grupotrabajo
from usuario with (nolock)
where usuario = @usuario
if exists (select
idcopiamavi
from ventad with (nolock)
where ((idcopiamavi is null)
or (idcopiamavi = ''))
and id = @id)
select
@nulocopia = 1
if @nulocopia = 1
and @gpotrabajo not in ('contabilidad')
select
@ok = 100028
end
end
else
begin
if (select
origen
from venta with (nolock)
where id = @id)
<> 'sol dev unicaja'
begin
if exists (select
idcopiamavi
from ventad with (nolock)
where idcopiamavi is null
and id = @id)
select
@ok = 99992
end
if (@mov = 'sol dev mayoreo')
begin
exec xpvalidarmovsoldevolucion @id,
@ok output,
3
end
else
begin
exec xpvalidarmovsoldevolucion @id,
@ok output,
1
end
exec spvalidarcantidaddevmavi @id,
@modulo,
@ok output,
@okref output
if @mov in ('cancela credilana', 'cancela prestamo')
and @ok is null
exec spgeneraringresoaldevolvermavi @id,
@usuario,
@ok output,
@okref output
end
end
if dbo.fnclaveafectacionmavi(@mov, 'vtas') in ('vtas.p', 'vtas.f')
begin
exec xpvalidarserielotemavi @id,
@ok output,
@okref output
if isnull((select
agente
from venta with (nolock)
where id = @id)
, '') = ''
select
@ok = 100004
end
if @mov in ('solicitud mayoreo', 'analisis mayoreo', 'pedido mayoreo')
begin
if isnull((select
formaenvio
from venta with (nolock)
where id = @id)
, '') = ''
select
@ok = 100005
end
if @mov = 'factura mayoreo'
begin
if 'activos fijos' in (select
a.cateria
from art a with (nolock),
ventad vd with (nolock)
where vd.id = @id
and a.articulo = vd.articulo)
begin
declare @serie varchar(20),
@art varchar(20)
declare afseries_cursor cursor for
select
serielote,
articulo
from serielotemov with (nolock)
where id = @id
open afseries_cursor
fetch next from afseries_cursor
into @serie, @art
while @@fetch_status = 0
and @ok is null
begin
if (select
responsable
from activof with (nolock)
where serie = @serie
and articulo = @art)
<> null
select
@ok = 100024
fetch next from afseries_cursor
into @serie, @art
end
close afseries_cursor
deallocate afseries_cursor
end
if isnull((select
formaenvio
from venta with (nolock)
where id = @id)
, '') = ''
select
@ok = 100005
end
if (@mov in ('solicitud credito', 'pedido', 'solicitud mayoreo'))
begin
select
@cliente = cliente
from venta with (nolock)
where id = @id
if ((select
facdesgloseiva
from venta with (nolock)
where id = @id)
= 1)
begin
select
@rfccompleto = dbo.fnvalidarfc(@cliente)
if (@rfccompleto = 1)
select
@ok = 80110,
@okref = 'el rfc del cliente no está completo'
if (@rfccompleto = 2)
select
@ok = 80110,
@okref = 'el rfc del cliente está incorrecto'
end
end
if @mov in ('solicitud devolucion', 'sol dev mayoreo')
begin
select
@devorigen = isnull(idcopiamavi, 0)
from ventad with (nolock)
where id = @id
select
@facdesgloseiva = facdesgloseiva
from venta with (nolock)
where id = @devorigen
update venta with (rowlock)
set facdesgloseiva = @facdesgloseiva
where id = @id
end
if @mov in ('solicitud credito', 'analisis credito', 'pedido', 'factura', 'factura viu')
exec spvalidarmayor12meses @id,
@mov,
'vtas'
select
@estatus = estatus,
@origen = origen,
@origenid = origenid
from venta with (nolock)
where id = @id
if dbo.fnclaveafectacionmavi(@mov, 'vtas') in ('vtas.p')
and @origen is null
and @origenid is null
and @estatus = 'sinafectar'
begin
select
@redime = redimeptos
from venta with (nolock)
where id = @id
declare crartprecio cursor local forward_only for
select
renglon,
d.articulo,
precio,
d.precioanterior,
a.estatus
from ventad d with (nolock)
left join art a with (nolock)
on a.articulo = d.articulo
and a.familia = 'calzado'
and a.estatus = 'bloqueado'
where id = @id
open crartprecio
fetch next from crartprecio into @renglon, @artp, @precioart, @precioanterior, @bloq
while @@fetch_status <> -1
and @ok is null
begin
if @@fetch_status <> -2
and nullif(@artp, '') is not null
begin
set @precio = dbo.fnpropreprecio(@id, @artp, @renglon, @redime)
if (isnull(@precioanterior, @precioart) <> @precio)
and (@bloq <> 'bloqueado')
and (@suc not in (select
nombre
from tablastd with (nolock)
where tablast = 'sucursales linea')
)
select
@ok = 20305,
@okref = rtrim(@artp)
end
fetch next from crartprecio into @renglon, @artp, @precioart, @precioanterior, @bloq
end
close crartprecio
deallocate crartprecio
end
if (dbo.fnclaveafectacionmavi(@mov, 'vtas') in ('vtas.p')
and (select
origen
from venta with (nolock)
where id = @id)
is null
and @ok is null)
begin
exec spvalidaventasinimpuestosmavi @id,
@ok output,
@okref output
end
end
if @modulo = 'vtas'
and @accion = 'cancelar'
begin
select
@mov = mov,
@estatus = estatus,
@dineroid = idingresomavi
from venta with (nolock)
where id = @id
if exists (select
vd.id
from ventad vd with (nolock)
inner join venta v with (nolock)
on vd.id = v.id
where vd.idcopiamavi = @id
and v.estatus not in ('cancelado', 'sinafectar'))
select
@ok = 100000
if exists (select
em.asignadoid
from embarquemov em with (nolock)
inner join embarque e with (nolock)
on em.asignadoid = e.id
where em.moduloid = @id
and em.modulo = 'vtas'
and e.estatus not in ('cancelado', 'sinafectar'))
select
@ok = 100000
if @mov in ('cancela credilana', 'cancela prestamo')
begin
if exists (select
id
from dinero with (nolock)
where id = @dineroid
and estatus in ('pendiente', 'concluido'))
select
@ok = 60060
end
end
if @modulo = 'cxc'
and isnull(@accion, '') in ('cancelar', 'afectar')
and isnull(@ok, 0) = 0
and exists (select
id
from cxc with (nolock)
where id = @id
and ((mov in (select distinct
movcar
from tcidm0224_confignotasespejo with (nolock)
union all
select distinct
movcredito
from tcidm0224_confignotasespejo with (nolock))
and isnull(concepto, '') in (select distinct
conceptocar
from tcidm0224_confignotasespejo with (nolock)
union all
select distinct
conceptocredito
from tcidm0224_confignotasespejo with (nolock))
)
or mov = 'aplicacion'
)
and estatus not in ('cancelado'))
begin
exec dbo.sp_mavidm0224notacreditoespejo @id,
@accion,
@usuario,
@ok output,
@okref output,
'antes'
end
return
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#validaconceptogas')
and type = 'u')
drop table #validaconceptogas
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#cobro')
and type = 'u')
drop table #cobro
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#cobroaplica')
and type = 'u')
drop table #cobroaplica
if exists (select
*
from tempdb.sys.sysobjects
where id = object_id('tempdb.dbo.#temp2')
and type = 'u')
drop table #temp2
end