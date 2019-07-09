create procedure [dbo].[xpdespuesafectar] @modulo char(5),
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
@movid varchar(20),
@cte varchar(10),
@cteenviara int,
@seenviaburocte bit,
@seenviaburocanal bit,
@estatus varchar(15),
@cxid int,
@dineroid int,
@origencri varchar(20),
@origenidcri varchar(20),
@escredilana bit,
@mayor12meses bit,
@aplicaidcti varchar(20),
@aplicacti varchar(20),
@numerodocumentos int,
@financiamiento money,
@personal varchar(10),
@dinmovid varchar(20),
@origen varchar(20),
@ctadinerodin varchar(10),
@ctadinerodesdin varchar(10),
@aplica varchar(20),
@aplicaid varchar(20),
@idncmor int,
@movmor varchar(20),
@fechacancelacion datetime,
@movmorid varchar(20),
@concepto varchar(20),
@origenid int,
@retencionconcepto float,
@idpadre int,
@daplica varchar(20),
@daplicaid varchar(20),
@dpadremavi varchar(20),
@dpadreidmavi varchar(20),
@dfechaconclusion datetime,
@destatus varchar(20),
@padreid int,
@dfechaemision datetime,
@importenc float,
@idnccobro int,
@canalventa int,
@origenped varchar(20),
@origenidped varchar(20),
@referencia varchar(50),
@referenciamavi varchar(50),
@engancheid int,
@movf varchar(20),
@movidf varchar(20),
@empresa char(5),
@sucursal int,
@fechaemision datetime,
@idsoporte int,
@importe money,
@docs int,
@abono money
select
@fechaemision = dbo.fnfechasinhora(getdate())
if @accion = 'afectar'
begin
exec spactualizatiemposmavi @modulo,
@id,
@accion,
@usuario
end
if @accion = 'cancelar'
begin
exec spactualizatiemposmavi @modulo,
@id,
@accion,
@usuario
end
if @accion = 'afectar'
and @modulo = 'vtas'
begin
select
@mov = mov,
@movid = movid,
@estatus = estatus,
@canalventa = enviara,
@cte = cliente,
@importe = importe + impuestos,
@docs = co.danumerodocumentos * 2,
@abono =
case
when @docs > 0 then @importe / @docs
else 0
end
from venta v with (nolock)
inner join condicion co with (nolock)
on co.condicion = v.condicion
where id = @id
exec spclientesnuevoscasamavi @modulo,
@id,
@accion
exec spgenerarfinanciamientomavi @id,
'vtas'
if @mov in ('analisis credito', 'pedido')
begin
exec xpactualizarefanticipo @id,
@mov
end
if dbo.fnclaveafectacionmavi(@mov, 'vtas') = 'vtas.f'
and @estatus = 'concluido'
begin
set @cxid = null
select
@cxid = cxc.id
from cxc with (nolock)
join cxcd with (nolock)
on cxc.id = cxcd.id
where cxcd.aplica = @mov
and cxcd.aplicaid = @movid
and cxc.estatus = 'concluido'
and cxc.mov = 'aplicacion saldo'
if @cxid is not null
exec xpdistribuyesaldo @cxid
if @canalventa = 34
begin
select
@personal = nomina
from cteenviara ce with (nolock)
where cliente = @cte
and id = 34
if isnull(@personal, '') > ''
exec comercializadora.dbo.spidm0221_deduccioncompras @cte,
@mov,
@movid,
@abono,
@personal,
@docs
end
end
if @mov in ('cancela credilana', 'cancela prestamo')
and @estatus = 'concluido'
begin
select
@dineroid = null
select
@dineroid = idingresomavi
from venta with (nolock)
where id = @id
if exists (select
id
from dinero with (nolock)
where id = @dineroid
and estatus = 'sinafectar')
begin
exec spafectar 'din',
@dineroid,
'afectar',
'todo',
null,
@usuario,
0,
0,
@ok output,
@okref output,
null,
0,
null
if (select
estatus
from dinero with (nolock)
where id = @dineroid)
= 'concluido'
begin
update dinero with (rowlock)
set referencia = @mov + ' ' + @movid
where id = @dineroid
select
@ok = 80300
select
@okref = mov + ' ' + movid
from dinero with (nolock)
where id = @dineroid
end
end
end
exec spactualizadesglose @id,
@mov,
'',
'cxc'
declare @clave varchar(10)
select
@clave = clave
from movtipo with (nolock)
where modulo = @modulo
and mov = @mov
if (isnull(@clave, '') = 'vtas.f')
begin
if (exists (select top 1
mov
from cxc with (nolock)
where mov = 'documento'
and padremavi = @mov
and padreidmavi = @movid
and referencia <> referenciamavi)
)
update cxc with (rowlock)
set referencia = referenciamavi
where mov = 'documento'
and padremavi = @mov
and padreidmavi = @movid
and referencia <> referenciamavi
end
if (isnull(@clave, '') in ('vtas.f', 'vtas.d'))
begin
exec sp_mavidm0279calcularbonif @mov,
@movid,
@id,
0,
@clave
end
if (isnull(@clave, '') in ('vtas.f', 'vtas.p'))
begin
exec spvtasactualizaestatustarjeta @id
end
end
if @accion = 'cancelar'
and @modulo = 'vtas'
begin
select
@mov = mov,
@movid = movid,
@estatus = estatus
from venta with (nolock)
where id = @id
exec speliminarrecuperacionmavi @id
declare @clavemov varchar(10)
select
@clavemov = dbo.fnclaveafectacionmavi(@mov, 'vtas')
if isnull(@clavemov, '') = 'vtas.f'
and @estatus = 'cancelado'
begin
set @cxid = null
select
@cxid = cxc.id
from cxc with (nolock)
join cxcd with (nolock)
on cxc.id = cxcd.id
where cxcd.aplica = @mov
and cxcd.aplicaid = @movid
and cxc.estatus = 'cancelado'
and cxc.mov = 'aplicacion saldo'
if @cxid is not null
exec xpdistribuyesaldocancelarmavi @cxid
end
select
@clave = clave
from movtipo with (nolock)
where modulo = @modulo
and mov = @mov
if isnull(@clavemov, '') = 'vtas.d'
exec sp_mavidm0279calcularbonif @mov,
@movid,
@id,
0,
@clavemov
if (isnull(@clave, '') in ('vtas.f', 'vtas.p'))
begin
exec spvtasactualizaestatustarjeta @id
end
end
if @accion = 'afectar'
and @modulo = 'cxc'
begin
exec spactualizarprogramarecuperacionmavi @id
exec spapoyofactorimmavi @id
select
@mov = mov,
@movid = movid,
@estatus = estatus,
@financiamiento = financiamiento,
@concepto = concepto
from cxc with (nolock)
where id = @id
if (select
clave
from movtipo with (nolock)
where modulo = 'cxc'
and mov = @mov)
= 'cxc.c'
begin
select
@dfechaconclusion = fechaconclusion,
@destatus = estatus
from cxc with (nolock)
where id = @id
declare @padrescobrados table (
idtmp int identity primary key,
id int,
padremavi varchar(20),
padreidmavi varchar(20),
importe float
)
insert into @padrescobrados
select
f.id,
f.mov,
f.movid,
sum(d.importe)
from cxcd d with (nolock)
join cxc c with (nolock)
on d.aplica = c.mov
and d.aplicaid = c.movid
join cxc f with (nolock)
on c.padremavi = f.mov
and c.padreidmavi = f.movid
where d.id = @id
group by f.id,
f.mov,
f.movid
insert into cobrosxpadre
select
p.id,
@id,
@dfechaconclusion,
p.importe,
@destatus,
'cxc.c'
from @padrescobrados p
end
if (select
clave
from movtipo with (nolock)
where modulo = 'cxc'
and mov = @mov)
= 'cxc.ca'
and @concepto like 'canc cobro%'
begin
select
@dpadremavi = padremavi,
@dpadreidmavi = padreidmavi,
@dfechaemision = fechaemision,
@mov = mov,
@importenc = isnull(importe, 0) + isnull(impuestos, 0),
@destatus = estatus
from cxc with (nolock)
where id = @id
select
@padreid = id
from cxc with (nolock)
where mov = @dpadremavi
and movid = @dpadreidmavi
select
@idnccobro = (substring(substring(valor, (charindex('_', valor) + 1), len(valor)),
charindex('_', (substring(valor, (charindex('_', valor) + 1), len(valor)))) + 1,
len(substring(valor, (charindex('_', valor) + 1), len(valor)))))
from movcampoextra with (nolock)
where campoextra in ('nc_cobro', 'ncv_cobro', 'ncm_cobro')
and id = @id
and mov = @mov
if @idnccobro is not null
insert into ncarccxpadre
select
@padreid,
@idnccobro,
@id,
@dfechaemision,
@importenc,
@destatus
select
@idpadre = idpadre
from dbo.ncarccxpadre with (nolock)
where idncar = @id
if (select
count(*)
from cobrosxpadre with (nolock)
where idpadre = @idpadre
and estatus = 'concluido')
= 1
begin
update cxc with (rowlock)
set calificacionmavi = 0,
ponderacioncalifmavi = '*'
where id = @idpadre
update cxcmavi with (rowlock)
set mopmavi = 0,
mopactmavi = null,
fechaultabono = null
where id = @idpadre
delete dbo.historicomopmavi
where id = @idpadre
end
exec sp_mavidm0279calcularbonif @mov,
@movid,
0,
@id,
'cxc.ca'
end
if (select
clave
from movtipo with (nolock)
where modulo = 'cxc'
and mov = @mov)
= 'cxc.nc'
and @concepto like 'corr cobro%'
begin
select top 1
@daplica = aplica,
@daplicaid = aplicaid
from cxcd with (nolock)
where id = @id
select
@dfechaemision = fechaemision,
@destatus = estatus
from cxc with (nolock)
where id = @id
select
@dpadremavi = padremavi,
@dpadreidmavi = padreidmavi
from cxc with (nolock)
where mov = @daplica
and movid = @daplicaid
select
@padreid = id
from cxc with (nolock)
where mov = @dpadremavi
and movid = @dpadreidmavi
insert into cobrosxpadre
select
@padreid,
@id,
@dfechaemision,
sum(isnull(importe, 0)),
@destatus,
'cxc.nc'
from cxcd with (nolock)
where id = @id
end
if (@mov in ('endoso'))
begin
select
@mov = mov,
@movid = movid,
@cte = cliente,
@cteenviara = clienteenviara
from cxc with (nolock)
where id = @id
select
@seenviaburocte = seenviaburocreditomavi
from cteenviara with (nolock)
where cliente = @cte
and id = @cteenviara
select
@seenviaburocanal = seenviaburocreditomavi
from ventascanalmavi with (nolock)
where id = @cteenviara
if (@seenviaburocte = 1)
exec spcambiarcxcburocanalventa @mov,
@movid
end
if (@mov in ('cta incobrable f', 'cta incobrable nv'))
begin
exec spdesactivaenviarburofactenctainc @id
if (@estatus = 'pendiente')
exec spactualizactaincmigramavicob @id
end
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.de')
begin
exec xpdevolucionanticiposaldomavi @id,
@usuario
update cxc with (rowlock)
set referencia = refanticipomavi
where id = @id
end
if (@mov in ('contra recibo inst'))
begin
select
@origencri = origen,
@origenidcri = origenid
from cxc with (nolock)
where id = @id
select
@escredilana = escredilana,
@mayor12meses = mayor12meses
from cxc with (nolock)
where mov = @origencri
and movid = @origenidcri
and estatus in ('concluido', 'pendiente')
update cxc with (rowlock)
set escredilana = @escredilana,
mayor12meses = @mayor12meses
where id = @id
end
if (@mov in ('cta incobrable nv', 'cta incobrable f'))
begin
select
@aplicacti = aplica,
@aplicaidcti = min(aplicaid)
from cxcd with (nolock)
where id = @id
group by aplica
select
@escredilana = escredilana,
@mayor12meses = mayor12meses
from cxc with (nolock)
where mov = @aplicacti
and movid = @aplicaidcti
and estatus in ('concluido', 'pendiente')
update cxc with (rowlock)
set escredilana = @escredilana,
mayor12meses = @mayor12meses
where id = @id
end
if (@mov in ('anticipo contado', 'anticipo mayoreo',
'apartado', 'enganche', 'devolucion',
'dev anticipo contado', 'dev anticipo mayoreo',
'devolucion enganche', 'devolucion apartado'))
exec spmayor12anticipodev @id
if @mov = 'refinanciamiento'
and @estatus = 'concluido'
begin
exec spgenerarfinanciamientomavi @id,
'cxc'
select
@numerodocumentos = 0
exec spprendemayor12mavi @id
exec spprendebitsmavi @id
update cxc with (rowlock)
set referencia = @mov + ' ' + @movid
where id in (select
idcxc
from refinidinvolucra with (nolock)
where id = @id)
update cxc with (rowlock)
set concepto = 'refinanciamiento'
where referencia = @mov + ' ' + @movid
and mov = 'nota car'
and @estatus = 'concluido'
select
@numerodocumentos = numerodocumentos
from docauto with (nolock)
where modulo = 'cxc'
and mov = @mov
and movid = @movid
if isnull(@numerodocumentos, 0) > 0
begin
select
@financiamiento = @financiamiento
/ @numerodocumentos
update cxc with (rowlock)
set financiamiento = @financiamiento
where origen = @mov
and origenid = @movid
and mov = 'documento'
and estatus = 'pendiente'
end
end
if @mov = 'refinanciamiento'
and @estatus = 'pendiente'
update cxc with (rowlock)
set referencia = @mov + ' ' + @movid
where id in (select
idcxc
from refinidinvolucra with (nolock)
where id = @id)
exec spactualizadesglose @id,
'',
'',
'cxc'
if @mov in ('nota car', 'nota car viu',
'nota car mayoreo')
begin
update cxc with (rowlock)
set fechaoriginal = vencimiento
where id = @id
end
if @mov in ('nota credito', 'nota credito viu',
'nota credito mayoreo', 'cancela prestamo', 'cancela credilana')
and @concepto like 'corr cobro%'
begin
update cxc with (rowlock)
set nota = (select top 1
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
where c.id = @id)
where id = @id
end
end
if @accion = 'cancelar'
and @modulo = 'cxc'
begin
exec spactualizarprogramarecuperacionalcancelarmavi @id
select
@mov = mov,
@estatus = estatus,
@concepto = concepto
from cxc with (nolock)
where id = @id
if (select
clave
from movtipo with (nolock)
where modulo = 'cxc'
and mov = @mov)
= 'cxc.anc'
and @concepto like 'corr cobro%'
update cobrosxpadre with (rowlock)
set estatus = 'cancelado'
where idcobro = @id
if (select
clave
from movtipo with (nolock)
where modulo = 'cxc'
and mov = @mov)
= 'cxc.nc'
and @concepto like 'corr cobro%'
update cobrosxpadre with (rowlock)
set estatus = 'cancelado'
where idcobro = @id
if @mov like 'cobro%'
update cobrosxpadre with (rowlock)
set estatus = 'cancelado'
where idcobro = @id
if (select
clave
from movtipo with (nolock)
where modulo = 'cxc'
and mov = @mov)
= 'cxc.ca'
and @concepto like 'canc cobro%'
update ncarccxpadre with (rowlock)
set estatusncar = 'cancelado'
where idncar = @id
if (@mov in ('cta incobrable f', 'cta incobrable nv'))
exec spactivaenviarburofactenctainc @id
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.aa')
and @estatus = 'cancelado'
begin
exec xpcancelaenganche @id,
@usuario
end
if dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.de')
begin
exec xpcanceladevolucion @id
end
if @mov in ('nota car', 'nota car viu',
'nota car mayoreo', 'nota credito',
'nota credito viu', 'nota credito mayoreo')
and @estatus = 'cancelado'
begin
if exists (select
moduloid
from cfd with (nolock)
where moduloid = @id)
begin
select
@fechacancelacion = fechacancelacion
from cxc with (nolock)
where id = @id
update cfd with (rowlock)
set fechacancelacion = @fechacancelacion
where moduloid = @id
end
end
if (dbo.fnclaveafectacionmavi(@mov, 'cxc') = 'cxc.dm')
and @accion = 'cancelar'
and @ok is null
exec sprevisactaincenviomavicob @id
end
if @accion = 'afectar'
and @modulo = 'af'
begin
exec spactualizarservicioafalafectarmavi @id
end
if @accion = 'cancelar'
and @modulo = 'af'
begin
exec spactualizarservicioafalcancelarmavi @id
end
if @accion = 'afectar'
and @modulo = 'gas'
begin
select
@mov = mov,
@movid = movid
from gasto with (nolock)
where id = @id
if @mov = 'car bancario'
update gasto with (rowlock)
set generardinero = 0
where id = @id
if @mov = 'contrato'
begin
exec spsolgastocontratodf @id
update gasto with (rowlock)
set vencimiento = fecharequerida
where origen = @mov
and origenid = @movid
end
select
@mov = mov,
@movid = movid
from gasto with (nolock)
where id = @id
select
@origenid = id
from cxp with (nolock)
where mov = @mov
and movid = @movid
if @mov = 'gasto'
begin
if (exists (select
retencion2
from movimpuesto with (nolock)
where modulo = 'gas'
and moduloid = @id
and retencion2 > 9)
)
begin
select distinct
@retencionconcepto = retencion2
from concepto with (nolock)
where modulo = 'gas'
and retencion2 > 9
update movimpuesto with (rowlock)
set retencion2 = @retencionconcepto
where modulo = 'gas'
and moduloid = @id
and retencion2 > 9
update movimpuesto with (rowlock)
set retencion2 = @retencionconcepto
where modulo = 'cxp'
and moduloid = @origenid
and retencion2 > 9
end
end
end
if @accion = 'afectar'
and @modulo = 'emb'
begin
select
@mov = mov,
@estatus = estatus
from embarque with (nolock)
where id = @id
if @mov = 'embarque'
and @estatus = 'concluido'
update embarqued with (rowlock)
set paracomisionchofermavi = 1
where estado = 'entregado'
and id = @id
end
if @accion = 'afectar'
and @modulo = 'af'
begin
select
@mov = mov,
@personal = personal
from activofijo with (nolock)
where id = @id
if @mov = 'asignacion'
begin
update personal with (rowlock)
set afcomer = 1
where personal = @personal
end
if @mov = 'devolucion'
begin
update personal with (rowlock)
set afcomer = 0
where personal = @personal
end
end
if @modulo = 'din'
begin
select
@mov = mov,
@dinmovid = movid,
@estatus = estatus,
@origen = origen,
@ctadinerodin = ctadinero,
@ctadinerodesdin = ctadinerodestino
from dinero with (nolock)
where id = @id
if @mov = 'ingreso'
and @estatus = 'concluido'
begin
insert into movflujo (sucursal,
empresa,
omodulo,
oid,
omov,
omovid,
dmodulo,
did,
dmov,
dmovid,
cancelado)
select
c.sucursal,
'mavi',
'cxc',
c.id,
c.mov,
c.movid,
'din',
a.id,
a.mov,
a.movid,
0
from dinero a with (nolock),
venta b with (nolock),
cxc c with (nolock)
where a.id = @id
and a.id = b.idingresomavi
and b.mov = c.origen
and b.movid = c.origenid
if @origen is null
begin
update dinero with (rowlock)
set dinero.origentipo = 'cxc',
dinero.origen = movflujo.omov,
dinero.origenid = movflujo.omovid
from movflujo with (nolock)
where dinero.mov = 'ingreso'
and movflujo.dmodulo = 'din'
and dinero.id = movflujo.did
and dinero.mov = movflujo.dmov
and dinero.movid = movflujo.dmovid
and dinero.id = @id
end
end
if @estatus = 'concluido'
begin
if @mov = 'apertura caja'
begin
update ctadinero with (rowlock)
set estado = 1
where ctadinero = @ctadinerodesdin
end
if @mov = 'corte caja'
begin
update ctadinero with (rowlock)
set estado = 0
where ctadinero = @ctadinerodin
end
end
if @estatus = 'cancelado'
begin
if @mov = 'apertura caja'
begin
update ctadinero with (rowlock)
set estado = 0
where ctadinero = @ctadinerodesdin
end
if @mov = 'corte caja'
begin
update ctadinero with (rowlock)
set estado = 1
where ctadinero = @ctadinerodin
end
end
end
if @modulo = 'cxc'
and dbo.fnclaveafectacionmavi(@mov, 'cxc') in ('cxc.c')
and @estatus = 'cancelado'
begin
declare c2 cursor fast_forward for
select
aplica,
aplicaid
from cxcd with (nolock)
where id = @id
and aplica in ('nota car', 'nota car viu', 'nota car mayoreo')
open c2
fetch next from c2 into @aplica, @aplicaid
while @@fetch_status = 0
begin
select
@idncmor = id
from cxc with (nolock)
where mov = @aplica
and movid = @aplicaid
declare crcancelnc cursor fast_forward for
select
origen,
origenid
from neciamoratoriosmavi with (nolock)
where idcobro = @id
and notacarmorid = @idncmor
group by origen,
origenid
open crcancelnc
fetch next from crcancelnc into @movmor, @movmorid
while @@fetch_status = 0
begin
exec spafectar 'cxc',
@idncmor,
'cancelar',
'todo',
null,
@usuario,
null,
0,
@ok output,
@okref output,
null,
@conexion = 0
fetch next from crcancelnc into @movmor, @movmorid
end
close crcancelnc
deallocate crcancelnc
fetch next from c2 into @aplica, @aplicaid
end
close c2
deallocate c2
end
if db_name() != 'mavicob'
begin
if @modulo = 'cxc'
and isnull(@accion, '') in ('cancelar', 'afectar')
and isnull(@ok, 0) = 0
and exists (select
id
from cxc with (nolock)
where id = @id
and mov in (select distinct
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
and estatus not in ('cancelado', 'sinafectar'))
begin
exec dbo.sp_mavidm0224notacreditoespejo @id,
@accion,
@usuario,
@ok output,
@okref output,
'despues'
end
if @modulo = 'cxc'
and @accion = 'afectar'
and @estatus = 'concluido'
begin
select
@mov = mov,
@movid = movid,
@estatus = estatus,
@concepto = concepto
from cxc with (nolock)
where id = @id
if exists (select
aplica,
aplicaid
from cxcd with (nolock)
where id = @id)
begin
select
@aplica = aplica,
@aplicaid = aplicaid
from cxcd with (nolock)
where id = @id
if exists (select
id
from cxc with (nolock)
join condicion co with (nolock)
on cxc.condicion = co.condicion
where mov = @aplica
and movid = @aplicaid
and dbo.fnclaveafectacionmavi(mov, 'vtas') = 'vtas.f'
and estatus = 'concluido'
and saldo = null
and co.tipocondicion = 'contado'
and co.grupo = 'menudeo')
begin
select
@origenid = v.id,
@movf = cc.mov,
@movidf = cc.movid,
@empresa = v.empresa,
@sucursal = v.sucursal
from venta v with (nolock)
join cxc cc with (nolock)
on v.mov = cc.mov
and v.movid = cc.movid
where cc.mov = @aplica
and cc.movid = @aplicaid
if exists (select
*
from politicasmonederoaplicadasmavi with (nolock)
where modulo = 'vtas'
and id = @origenid
and cveestatus = 'p')
begin
exec xpmovestatuscxc @empresa,
@sucursal,
@modulo,
@origenid,
@estatus,
@estatus,
@usuario,
@fechaemision,
@fecharegistro,
@movf,
@movidf,
'vtas.f',
@ok output,
@okref output
end
end
end
end
if @modulo = 'cxc'
and @accion = 'cancelar'
and @estatus = 'cancelado'
begin
select
@mov = mov,
@movid = movid,
@estatus = estatus,
@concepto = concepto
from cxc with (nolock)
where id = @id
if exists (select
aplica,
aplicaid
from cxcd with (nolock)
where id = @id)
begin
select
@aplica = aplica,
@aplicaid = aplicaid
from cxcd with (nolock)
where id = @id
if exists (select
id
from cxc with (nolock)
join condicion co with (nolock)
on cxc.condicion = co.condicion
where mov = @aplica
and movid = @aplicaid
and dbo.fnclaveafectacionmavi(mov, 'vtas') = 'vtas.f'
and estatus <> 'concluido'
and isnull(saldo, 0) > 0
and co.tipocondicion = 'contado'
and co.grupo = 'menudeo')
begin
select
@origenid = v.id,
@movf = cc.mov,
@movidf = cc.movid,
@empresa = v.empresa,
@sucursal = v.sucursal
from venta v with (nolock)
join cxc cc with (nolock)
on v.mov = cc.mov
and v.movid = cc.movid
where cc.mov = @aplica
and cc.movid = @aplicaid
if exists (select
*
from politicasmonederoaplicadasmavi with (nolock)
where modulo = 'vtas'
and id = @origenid
and isnull(cveestatus, '') = 'a')
begin
exec xpmovestatuscxc @empresa,
@sucursal,
@modulo,
@origenid,
@estatus,
@estatus,
@usuario,
@fechaemision,
@fecharegistro,
@movf,
@movidf,
'vtas.f',
@ok output,
@okref output
end
end
end
end
end
if @modulo = 'cxp'
begin
select
@mov = mov,
@estatus = estatus
from cxp with (nolock)
where id = @id
if @mov = 'acuerdo proveedor'
and @estatus = 'pendiente'
exec sp_dm0310movflujoacuerdoproveedores @id
end
if @modulo = 'cxp'
and @accion = 'cancelar'
begin
select
@mov = mov,
@estatus = estatus,
@origen = origen,
@origenidped = origenid
from cxp with (nolock)
where id = @id
if @mov = 'acuerdo proveedor'
and @estatus = 'cancelado'
update cxp with (rowlock)
set situacion = 'por generar acuerdo'
where mov = @origen
and movid = @origenidped
end
if @accion = 'afectar'
and @mov in ('factura', 'factura viu')
begin
select
@idsoporte = reporteservicio
from venta with (nolock)
where id = @id
if @idsoporte is not null
begin
update s with (rowlock)
set controlrepserv = 1
from soporte s
where s.id = @idsoporte
end
end
if @accion = 'afectar'
and @mov in ('factura', 'factura viu')
begin
select
@idsoporte = reporteservicio
from venta with (nolock)
where id = @id
if @idsoporte is not null
begin
update s with (rowlock)
set controlrepserv = 1
from soporte s
where s.id = @idsoporte
end
end
return
end