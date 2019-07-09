create procedure [dbo].[spbonificacionescalculatabla] @idcxc int,
@estacion int = 1,
@tipo char(10),
@idcobro int
as
begin
declare
@empresa varchar(5),
@mov varchar(20),
@movid varchar(20),
@fechaemision datetime,
@concepto varchar(50),
@uen int,
@tipocambio float,
@clienteenviara int,
@condicion varchar(50),
@vencimiento datetime,
@importeventa float,
@importedocto float,
@importecasca float,
@impuestos float,
@saldo float,
@referencia varchar(50),
@documento1de int,
@documentototal int,
@origentipo varchar(20),
@origen varchar(20),
@origenid varchar(20),
@sucursal int,
@tiposucursal varchar(50),
@extraed int,
@extraea int,
@idventa int,
@movidventa varchar(20),
@movventa varchar(20),
@lineavta varchar(50),
@maxdiasatrazo float,
@diasmenoresa int,
@diasmayoresa int,
@id int,
@bonificacion varchar(50),
@estatus varchar(15),
@porcbon1 float,
@montobonif float,
@financiamiento float,
@fechaini datetime,
@fechafin datetime,
@patotal bit,
@actvigencia bit,
@cascadacalc bit,
@aplicaa char(30),
@plazoejefin int,
@valbonif float,
@vencimientoantes int,
@vencimientodesp int,
@diasatrazo int,
@factor float,
@mesesexced int,
@linea float,
@fechacancelacion datetime,
@fecharegistro datetime,
@usuario varchar(10),
@ok int,
@okref varchar(50),
@periodo int,
@charreferencia varchar(20),
@ejercicio int,
@bonifichijo varchar(50),
@bonifichijocascad varchar(5),
@refinan varchar(5),
@lineacelulares float,
@diasvencimiento int,
@lineacredilanas float,
@baseparaaplicar float
,@padremavi varchar(20)
,@padremaviid varchar(20),
@esorigennulo int
,@lineamotos float
,@lineabonif varchar(25)
, @fechaemisionfact datetime
select @okref = '', @ejercicio = year(getdate()), @periodo = month(getdate()), @maxdiasatrazo = 0.00, @mov = '',@diasmenoresa=0, @diasmayoresa=0
select @charreferencia= 0 , @importeventa = 0.00, @importedocto = 0.00, @mesesexced=0, @importecasca = 0.00, @baseparaaplicar = 0.00,@esorigennulo=0
if @idcobro = null select @idcobro= 0
select @empresa=c.empresa,@mov=c.mov,@movid=c.movid, @fechaemision=c.fechaemision,@concepto=c.concepto,@uen=c.uen, @fechaemisionfact = c.fechaemision ,
@tipocambio=c.tipocambio,@clienteenviara=c.clienteenviara,@condicion=c.condicion,@vencimiento=c.vencimiento,@importedocto=c.importe+c.impuestos,
@impuestos=c.impuestos,@saldo=c.saldo,@vencimiento=c.vencimiento,@concepto=c.concepto,@referencia=isnull(c.referenciamavi,c.referencia),
@origentipo=c.origentipo,@origen=c.origen, @origenid=c.origenid,@sucursal=c.sucursalorigen,@maxdiasatrazo=isnull(cm.maxdiasvencidosmavi,0.00)
,@padremavi = c.padremavi, @padremaviid = c.padreidmavi
from cxc c left join cxcmavi cm on cm.id=c.id
where c.id = @idcxc
if @origen is null
begin
select @empresa=c.empresa,@mov=c.mov,@movid=c.movid, @fechaemision=c.fechaemision,@concepto=c.concepto,@uen=c.uen,
@tipocambio=c.tipocambio,@clienteenviara=c.clienteenviara,@condicion=c.condicion,@vencimiento=c.vencimiento,@importedocto=c.importe+c.impuestos,
@impuestos=c.impuestos,@saldo=c.saldo,@vencimiento=c.vencimiento,@concepto=c.concepto,@referencia=isnull(c.referenciamavi,c.referencia),
@origentipo=c.origentipo,@origen=c.origen, @origenid=c.origenid,@sucursal=c.sucursalorigen,@maxdiasatrazo=isnull(cm.maxdiasvencidosmavi,0.00)
from cxc c left join cxcmavi cm on cm.id=c.id
where c.mov = @mov and c.movid = @movid
select @origen = @mov , @origenid = @movid
select @esorigennulo=1
select top(1)@lineavta = linea, @importeventa = preciototal, @sucursal = sucursalventa
from bonifsimavi where idcxc = @idcxc
end
delete mavibonificaciontest where origen= @padremavi and origenid = @padremaviid
if @referencia is null or rtrim(@referencia)= '' or not @referencia like '%/%'
begin
select top (1) @referencia=referencia from cxc where padremavi = @mov and padreidmavi = @movid and mov = 'documento' order by movid
end
if patindex('%/%',@referencia) > 0
begin
select @extraed = patindex('%(%',@referencia), @extraea = patindex('%/%',@referencia)
select @documento1de = substring(@referencia,@extraed+1,@extraea - @extraed -1)
select @extraed = patindex('%/%',@referencia), @extraea = patindex('%)%',@referencia)
select @documentototal = substring(@referencia,@extraed+1,@extraea - @extraed -1)
end
exec spmavibuscacxcventabonif @movid,@mov, @movidventa output , @movventa output, @idventa output
if @importeventa is null
select top(1)@lineavta = linea, @importeventa = preciototal, @sucursal = sucursalventa
from bonifsimavi where idcxc = @idventa
if @mov like '%refinan%' select @refinan='ok',@importeventa = importe+impuestos from cxc where mov=@mov and movid=@movid
if @refinan is null or @lineavta is null
begin
select @lineavta = isnull(a.linea,'') from venta ,ventad left outer join art a on a.articulo = ventad.articulo
where venta.id = ventad.id
and venta.id = @idventa
if @importeventa is null or @importeventa =0
select @importeventa = preciototal from venta where id = @idventa
end else
begin
select @sucursal=39, @lineavta = ''
select @importeventa = importe from cxc where id = @idventa
end
select @tiposucursal=sucursaltipo.tipo from sucursal , sucursaltipo where sucursal.tipo = sucursaltipo.tipo
and sucursal.sucursal=@sucursal
if exists ( select
solc.fechaemision
from venta fac inner join venta ped on fac.origen = ped.mov and fac.origenid = ped.movid
inner join venta anac on ped.origen = anac.mov and ped.origenid = anac.movid
inner join venta solc on anac.origen = solc.mov and anac.origenid = solc.movid
where fac.mov = @mov and fac.movid = @movid)
begin
select
@fechaemision = solc.fechaemision
from venta fac inner join venta ped on fac.origen = ped.mov and fac.origenid = ped.movid
inner join venta anac on ped.origen = anac.mov and ped.origenid = anac.movid
inner join venta solc on anac.origen = solc.mov and anac.origenid = solc.movid
where fac.mov = @mov and fac.movid = @movid
end
select
@importeventa = (((doc.importe+doc.impuestos))-isnull(mon.abono,0))
from dbo.cxc doc left join dbo.condicion con on con.condicion=doc.condicion
left join dbo.auxiliarp mon on mon.mov=doc.mov and mon.movid=doc.movid and isnull(mon.abono,0)>0
where doc.mov=@mov and doc.movid=@movid
if exists(select * from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crbonifaplicar') and type ='u')
drop table #crbonifaplicar
create table #crbonifaplicar (reg int identity, id int, bonificacion varchar(100),porcbon1 float null, financiamiento float null, fechaini datetime,fechafin datetime, patotal bit , actvigencia bit
,aplicaa varchar(30) null , plazoejefin int,vencimientoantes int null,vencimientodesp int null ,diasatrazo int null,diasmenoresa int null, diasmayoresa int null ,
factor float null ,linea float null , fechacancelacion datetime null,fecharegistro datetime null ,usuario varchar(10) null ,lineabonif varchar(50) null)
if @tipo = 'total'
begin
insert into #crbonifaplicar (id , bonificacion ,porcbon1 , financiamiento , fechaini ,fechafin , patotal , actvigencia ,aplicaa , plazoejefin ,vencimientoantes
,vencimientodesp ,diasatrazo ,diasmenoresa , diasmayoresa , factor ,linea , fechacancelacion ,fecharegistro ,usuario ,lineabonif )
select mbc.id, mbc.bonificacion,mbc.porcbon1,mbc.financiamiento, mbc.fechaini,mbc.fechafin,mbc.patotal,mbc.actvigencia
,mbc.aplicaa,mbc.plazoejefin,vencimientoantes=isnull(mbc.vencimientoantes,0),vencimientodesp=isnull(mbc.vencimientodesp,0)
,diasatrazo=isnull(mbc.diasatrazo,0),diasmenoresa=isnull(mbc.diasmenoresa,0),diasmayoresa=isnull(mbc.diasmayoresa,0),
mbc.factor,linea=isnull(mbc.linea,0.00),mbc.fechacancelacion,mbc.fecharegistro,mbc.usuario,mbl.linea
from mavibonificacionconf mbc inner join mavibonificacionmov mbmv on mbc.id = mbmv.idbonificacion
inner join dbo.mavibonificacioncondicion mbc2 on mbc2.idbonificacion=mbc.id
left join dbo.mavibonificacionlinea mbl on mbl.idbonificacion=mbc.id
where mbmv.movimiento = @mov
and condicion = @condicion
and mbc.estatus = 'concluido'
and @fechaemision between mbc.fechaini and mbc.fechafin
and mbc.nopuedeaplicarsola = 0
order by mbc.orden desc
end
else
begin
insert into #crbonifaplicar (id , bonificacion ,porcbon1 , financiamiento , fechaini ,fechafin , patotal , actvigencia ,aplicaa , plazoejefin ,vencimientoantes
,vencimientodesp ,diasatrazo ,diasmenoresa , diasmayoresa , factor ,linea , fechacancelacion ,fecharegistro ,usuario ,lineabonif )
select mbc.id, mbc.bonificacion,mbc.porcbon1,mbc.financiamiento, mbc.fechaini,mbc.fechafin,mbc.patotal,mbc.actvigencia,mbc.aplicaa,mbc.plazoejefin,
isnull(mbc.vencimientoantes,0), isnull(mbc.vencimientodesp,0),
isnull(mbc.diasatrazo,0),isnull(mbc.diasmenoresa,0),isnull(mbc.diasmayoresa,0),
mbc.factor,isnull(mbc.linea,0.00),mbc.fechacancelacion,mbc.fecharegistro,mbc.usuario,null
from mavibonificacionconf mbc inner join mavibonificacionmov mbmv on mbc.id = mbmv.idbonificacion
inner join dbo.mavibonificacioncondicion mbc2 on mbc2.idbonificacion=mbc.id
where mbmv.movimiento = @mov
and condicion = @condicion
and mbc.estatus = 'concluido'
and @fechaemision between mbc.fechaini and mbc.fechafin
and mbc.nopuedeaplicarsola = 0
and not mbc.bonificacion like '%contado comercial%'
order by mbc.orden desc
end
declare @totbonifs int, @recorre int , @tincluye int,@avanza int
select @totbonifs = max(reg) , @recorre = 1
from #crbonifaplicar
while @recorre <= @totbonifs
begin
select @ok = null, @okref = null ,
@id=id, @bonificacion = bonificacion ,@porcbon1 = porcbon1 ,@financiamiento = financiamiento ,@fechaini = fechaini ,@fechafin = fechafin,@patotal = patotal
,@actvigencia = actvigencia ,@aplicaa = aplicaa,@plazoejefin = plazoejefin, @vencimientoantes = vencimientoantes, @vencimientodesp = vencimientodesp,
@diasatrazo = diasatrazo, @diasmenoresa = diasmenoresa, @diasmayoresa = diasmayoresa, @factor = factor ,@linea = linea,@fechacancelacion = fechacancelacion
,@fecharegistro = fecharegistro ,@usuario = usuario ,@lineabonif = lineabonif
from #crbonifaplicar
where reg = @recorre
declare @lineaventabonif varchar(50)
select top 1 @lineaventabonif = isnull(linea,@lineavta)
from bonifsimavi where idcxc = @idventa and linea in (select mbl.linea
from mavibonificacionconf mbc inner join mavibonificacionmov mbmv on mbc.id = mbmv.idbonificacion
inner join mavibonificacioncondicion mbc2 on mbc2.idbonificacion=mbc.id
left join mavibonificacionlinea mbl on id=mbl.idbonificacion
where mbmv.movimiento = @mov
and condicion = @condicion
and mbc.estatus = 'concluido'
and @fechaemision between mbc.fechaini and mbc.fechafin
and mbc.nopuedeaplicarsola = 0
and bonificacion like '%contado comercial%'
)
select @lineaventabonif = isnull(a.linea,@lineavta) from venta ,ventad left outer join art a on a.articulo = ventad.articulo
where venta.id = ventad.id
and venta.id = @idventa
and a.linea in (select mbl.linea
from mavibonificacionconf mbc inner join mavibonificacionmov mbmv on mbc.id = mbmv.idbonificacion
inner join mavibonificacioncondicion mbc2 on mbc2.idbonificacion=mbc.id
left join mavibonificacionlinea mbl on id=mbl.idbonificacion
where mbmv.movimiento = @mov
and condicion = @condicion
and mbc.estatus = 'concluido'
and @fechaemision between mbc.fechaini and mbc.fechafin
and mbc.nopuedeaplicarsola = 0
and bonificacion like '%contado comercial%')
select @lineaventabonif = isnull(@lineaventabonif,@lineavta)
select @lineavta=@lineaventabonif
if @lineaventabonif in (select mbl.linea
from mavibonificacionconf mbc inner join mavibonificacionmov mbmv on mbc.id = mbmv.idbonificacion
inner join mavibonificacioncondicion mbc2 on mbc2.idbonificacion=mbc.id
left join mavibonificacionlinea mbl on id=mbl.idbonificacion
where mbmv.movimiento = @mov
and condicion = @condicion
and mbc.estatus = 'concluido'
and @fechaemision between mbc.fechaini and mbc.fechafin
and mbc.nopuedeaplicarsola = 0
and bonificacion like '%contado comercial%') and @bonificacion like '%contado comercial%'
begin
if isnull(@lineabonif,'')<>'' and isnull(@lineaventabonif,'')<>'' and @bonificacion like '%contado comercial%'
begin
if @lineabonif = @lineaventabonif
select @ok = null, @okref = null
end
else select @ok = 1, @okref = 'no cumple con el parametro linea para esta bonificacion'
end
else if isnull(@lineabonif,'')='' and isnull(@lineaventabonif,'')<>'' and @bonificacion like '%contado comercial%'
begin
if exists(select bonificacion from dbo.mavibonificaciontest where bonificacion=@bonificacion and ok=0 and idcobro=@idcobro)
select @ok = 1, @okref = 'no cumple con el parametro de la linea para esta bonificacion'
else
select @ok = null, @okref = null
end
else if @bonificacion like '%contado comercial%'
select @ok = 1, @okref = 'no cumple con el parametro de la linea para esta bonificacion'
select @lineabonif=''
if @bonificacion like '%adelanto%' and @lineavta<>@lineabonif and @tipo = 'total'
and exists (select * from mavibonificaciontest where idcobro=@idcobro and ok=0 and bonificacion=@bonificacion)
select @ok = 1, @okref = 'no cumple con el parametro de la linea para esta bonificacion'
if @tipo = 'total' and @bonificacion not like '%adelanto%'
and exists (select idbonificacion from mavibonificacionexcluye where bonificacionno=@bonificacion
and idbonificacion in (
select id from (
select mbc.id
,ok=case when @esorigennulo = 0
then
case when dbo.fnfechasinhora(getdate()) >= dbo.fnfechasinhora((select c.vencimiento+1 from cxc c where c.origen = @origen and c.origenid = @origenid and c.referencia like '%' + '(' + rtrim(mbc.vencimientoantes) + '/' + rtrim(@documentototal) + '%'))
then 1 else 0 end
else
case when dbo.fnfechasinhora(getdate()) > dbo.fnfechasinhora(isnull((select c.vencimiento from cxc c where c.origen = @origen and c.origenid = @origenid
and c.referencia like '%' + '(' + rtrim(mbc.vencimientoantes) + '/' + rtrim(@documentototal) + '%'),
(case when mbc.vencimientoantes=1 then @vencimiento
when mbc.vencimientoantes>1 then dateadd(mm, (mbc.vencimientoantes - @documento1de), (select vencimiento from cxc where origen=@origen and origenid=@origenid and referencia=@referencia) ) end ) ) )
then 1 else 0 end
end,
diasatrazo=case when @maxdiasatrazo > mbc.diasatrazo and mbc.diasatrazo <> 0 then 1 else 0 end,
diasmenoresa=case when @condicion like '%pp%' and mbc.diasmenoresa <> 0 then
case when mbc.diasmenoresa < datediff(day,@fechaemisionfact,getdate()) then 1 else 0 end
when @condicion like '%dif%' and mbc.diasmenoresa <> 0 then
case when mbc.diasmenoresa < datediff(day, @fechaemisionfact, getdate()) then 1 else 0 end
else 0 end,
diasmayoresa=case when @condicion like '%pp%' and mbc.diasmayoresa <> 0 then
case when mbc.diasmayoresa >= datediff(dd,@fechaemisionfact,@vencimiento) then 1 else 0 end
when @condicion like '%dif%' and mbc.diasmayoresa <> 0 then
case when mbc.diasmayoresa <= datediff(day, @fechaemisionfact, getdate()) then 1 else 0 end
else 0 end
from mavibonificacionconf mbc inner join mavibonificacionmov mbmv on mbc.id = mbmv.idbonificacion
inner join mavibonificacioncondicion mbc2 on mbc2.idbonificacion=mbc.id
left join mavibonificacionlinea mbl on id=mbl.idbonificacion
where mbmv.movimiento = @mov
and condicion = @condicion
and mbc.estatus = 'concluido'
and @fechaemision between mbc.fechaini and mbc.fechafin
and mbc.nopuedeaplicarsola = 0
and bonificacion = 'bonificacion contado comercial'
)cont where ok = 0 and diasatrazo = 0 and diasmenoresa = 0 and diasmayoresa = 0 ) )
select @ok = 1, @okref = 'se excluye esta bonificacion por otra'
if @vencimientoantes <> 0 and @bonificacion not like '%adelanto%' and @tipo = 'total'
begin
set @charreferencia = '(' + rtrim(@vencimientoantes) + '/' + rtrim(@documentototal)
if @esorigennulo=0
begin
if dbo.fnfechasinhora(getdate()) >= dbo.fnfechasinhora((select c.vencimiento+1 from cxc c where c.origen = @origen and c.origenid = @origenid and c.referencia like '%' + @charreferencia + '%'))
select @ok=1, @okref = 'no cumple con el límite de pa posterior1'
end
else
begin
if ( dbo.fnfechasinhora(getdate()) > dbo.fnfechasinhora(isnull((select c.vencimiento from cxc c where c.origen = @origen and c.origenid = @origenid
and c.referencia like '%' + @charreferencia + '%'),
(case when @vencimientoantes=1 then @vencimiento
when @vencimientoantes>1 then dateadd(mm, (@vencimientoantes - @documento1de), (select vencimiento from cxc where origen=@origen and origenid=@origenid and referencia=@referencia) ) end ) ) ) )
select @ok=1, @okref = 'no cumple con el límite de pa posterior1'
end
end
if @vencimientoantes <> 0 and @bonificacion like '%adelanto%' and @tipo = 'total'
begin
set @charreferencia = '(' + rtrim(@vencimientoantes) + '/' + rtrim(@documentototal)
if dbo.fnfechasinhora(getdate()) >= dbo.fnfechasinhora((select c.vencimiento + 1 from cxc c where c.origen = @origen and c.origenid = @origenid and c.referencia like '%' + @charreferencia + '%'))
select @ok=1, @okref = 'no cumple con el límite de pa posterior1'
end
if @vencimientodesp <> 0 and @bonificacion like '%adelanto%' and @tipo = 'total'
begin
set @charreferencia = '(' + rtrim(@vencimientodesp) + '/' + rtrim(@documentototal)
if (dbo.fnfechasinhora(getdate()) <=
dbo.fnfechasinhora(isnull((select c.vencimiento from cxc c where c.origen = @origen and c.origenid = @origenid
and c.referencia like '%' + @charreferencia + '%'),
(case when @vencimientodesp=1 then @vencimiento
when @vencimientodesp>1 then dateadd(mm, (@vencimientodesp - @documento1de), (select vencimiento from cxc where origen=@origen and origenid=@origenid and referencia=@referencia) ) end ) ) ) )
select @ok=1, @okref = 'no cumple con el límite de pa posterior1'
end
if @diasatrazo <> 0 and @bonificacion like '%contado comercial%'
begin
if @maxdiasatrazo > @diasatrazo select @ok=1, @okref = 'excede el número de dias de atraso permitidos '
end
if @diasmenoresa <> 0 and @bonificacion like '%contado comercial%' and @condicion like '%pp%'
begin
if @diasmenoresa < datediff(day,@fechaemisionfact,getdate()) select @ok=1, @okref = 'excede días menores'
end
if @diasmayoresa <> 0 and @bonificacion like '%contado comercial%' and @condicion like '%pp%'
begin
if @diasmayoresa >= datediff(dd,@fechaemisionfact,@vencimiento) select @ok=1, @okref = 'excede dias mayores'
end
if @diasmenoresa <> 0 and @bonificacion like '%contado comercial%' and @condicion like '%dif%'
begin
if @diasmenoresa < datediff(day,@fechaemisionfact, getdate() )
select @ok=1, @okref = 'excede días menores' + convert (char(30),@diasmenoresa)
end
if @diasmayoresa <> 0 and @bonificacion like '%contado comercial%' and @condicion like '%dif%'
begin
if getdate() >= (@fechaemisionfact + @diasmayoresa)
select @ok=1, @okref = 'excede días mayores' + convert (char(30),@diasmayoresa)
end
if @porcbon1 = 0 and @linea <> 0 select @porcbon1 = @linea
if @linea < (select isnull(porclin,0.00) from mavibonificacionlinea where idbonificacion=@id and linea = @lineavta)
select @linea = (select isnull(porclin,0.00) from mavibonificacionlinea where idbonificacion=@id and linea = @lineavta)
select @lineacelulares=isnull(porclin,0.00) from mavibonificacionlinea mbl where linea like '%credilana%' and idbonificacion = @id
select @lineacredilanas=isnull(porclin,0.00) from mavibonificacionlinea mbl where linea like '%celular%' and idbonificacion = @id
select @lineamotos=isnull(porclin,0.00) from mavibonificacionlinea mbl inner join mavibonificacioncondicion mbc on mbc.idbonificacion=mbl.idbonificacion
where mbc.condicion=@condicion and @bonificacion like '%contado comercial%'
and mbl.idbonificacion = @id and linea=@lineabonif
if exists(select idbonificacion from mavibonificacioncanalvta boncan where boncan.idbonificacion=@id)
begin
if not exists(select idbonificacion from mavibonificacioncanalvta boncan where convert(varchar(10),boncan.canalventa)=@clienteenviara and boncan.idbonificacion=@id)
select @ok=1, @okref = 'venta de canal no configurada para esta bonificación'
end
if exists(select idbonificacion from mavibonificacionuen mbu where mbu.idbonificacion=@id)
begin
if not @uen is null and not exists(select idbonificacion from mavibonificacionuen mbu where mbu.uen = @uen and mbu.idbonificacion=@id)
select @ok=1, @okref = 'uen no configurada para este caso'
end
if exists(select idbonificacion from mavibonificacioncondicion where idbonificacion=@id)
begin
if not exists(select idbonificacion from mavibonificacioncondicion where condicion=@condicion and idbonificacion=@id)
select @ok=1, @okref = 'condicion no configurada para esta bonificación'
end
if exists(select idbonificacion from mavibonificacionexcluye exc where bonificacionno=@bonificacion)
begin
if exists(select bontest.idbonificacion from mavibonificaciontest bontest , mavibonificacionexcluye exc where bontest.idbonificacion = exc.idbonificacion
and bontest.okref = '' and exc.bonificacionno=@bonificacion and bontest.idcobro = @idcobro
and bontest.montobonif > 0 and bontest.origen = @mov and bontest.origenid = @movid
)
select @ok=1, @okref = 'excluye esta bonificacion una anterior '
end
if not @tiposucursal is null and not exists(select idbonificacion from mavibonificacionsucursal where sucursal=rtrim(@tiposucursal) and idbonificacion=rtrim(@id))
select @ok=1, @okref = 'bonificación no configurada para este tipo de sucursal'
if not exists(select idbonificacion from mavibonificaciontest where idbonificacion=rtrim(@id) and docto = @idcxc )
begin
select @mesesexced = isnull(@documentototal,0) - isnull(@plazoejefin,0)
select @factor = 1 + (@mesesexced * (isnull(@financiamiento,0.00)/100))
select @baseparaaplicar = isnull(@importeventa / @factor,0.00)
if @aplicaa = 'importe de factura'
begin
if @linea <> 0 select @porcbon1=@linea
if @lineacelulares <> 0 and @bonificacion not like '%contado%' and @bonificacion not like '%atraso%' select @porcbon1=isnull(@lineacelulares,0.00)
if @lineacredilanas <> 0 and @bonificacion not like '%contado%' and @bonificacion not like '%atraso%' select @porcbon1=isnull(@lineacredilanas,0.00)
if @bonificacion like '%contado%' select @porcbon1=isnull(@lineamotos,@porcbon1)
select @montobonif = (@porcbon1/100) * (@importeventa / @factor)
end
if @aplicaa <> 'importe de factura' select @montobonif = (@porcbon1/100) * @importedocto
if @bonificacion like '%contado comercial%' and @ok is null
begin
select @montobonif = @importeventa - ((@importeventa / @factor)-@montobonif)
end
if not @ok is null select @montobonif = 0.00,@porcbon1 = 0.00
if @bonificacion like '%adelanto%' and dbo.fnfechasinhora(getdate()) = dbo.fnfechasinhora(@vencimiento) select @montobonif = 0.00 , @porcbon1 = 0.00
if @bonificacion like '%contado comercial%' and @ok is null
select @montobonif=isnull(@montobonif,0)-bonif from (
select cmov.mov,cmov.movid,bonif=isnull( sum(cd.importe),0) from cxc cmov inner join cxc ccte on ccte.cliente=cmov.cliente and ccte.mov like 'nota credito%' and ccte.estatus='concluido'
inner join cxc cbonif on ccte.id=cbonif.id
inner join cxcd cd on cbonif.id = cd.id
inner join cxc cpadre on cpadre.mov=cd.aplica and cpadre.movid=cd.aplicaid and cpadre.padremavi=cmov.mov and cpadre.padreidmavi=cmov.movid
where ccte.concepto like '%pa puntual%' and cmov.mov=@mov and cmov.movid=@movid
group by cmov.mov,cmov.movid
)resta
if @bonificacion like '%contado comercial%'
begin
insert mavibonificaciontest (idbonificacion,idcobro,docto, bonificacion, estacion, documento1de,documentototal,mov,
movid, origen,origenid, importedocto,importeventa, montobonif, tiposucursal,lineavta,idventa,uen,condicion,porcbon1,financiamiento, ok,okref, factor,sucursal1,plazoejefin, fechaemision, vencimiento, lineacelulares, lineacredilanas,diasmenoresa,diasmayoresa,baseparaaplicar)
values(@id ,@idcobro,@idcxc,isnull(@bonificacion,''), @estacion, isnull(@documento1de,0),isnull(@documentototal,0),isnull(@mov,''),
isnull(@movid,''),isnull(@origen,''),isnull(@origenid,''), round(isnull(@importedocto,0.00),2), round(isnull(@importeventa,0.00),2),
round(isnull(@montobonif,0.00),2) , isnull(@tiposucursal,''),isnull(@lineavta,''),isnull(@idventa,0),isnull(@uen,0),isnull(@condicion,''),isnull(@porcbon1,0.00), isnull(@financiamiento,0.00), isnull(@ok,0),isnull(@okref,''),isnull(@factor,0.00),@sucursal,@plazoejefin,@fechaemision,@vencimiento, isnull(@lineacelulares,0.00), isnull(@lineacredilanas,0.0),@diasmenoresa,@diasmayoresa,round(isnull(@baseparaaplicar,0.00),2))
end
end
if (@ok is null and exists(select idbonificacion from mavibonificacionincluye exc where exc.idbonificacion=@id)
and exists (select movimiento from mavibonificacionmov where movimiento = @mov and idbonificacion in
(select id from mavibonificacionconf where bonificacion like '%atraso%' ))) or
(@ok is null and @tipo = 'total' and not @bonificacion like '%contado comercial%') or
(@ok is null and @tipo = 'total' and not @bonificacion like '%adelanto%') or
(@ok is null and @tipo <> 'total' and not @bonificacion like '%contado comercial%')
begin
if (@ok is null and exists(select idbonificacion from mavibonificacionincluye exc where exc.idbonificacion=@id)
and exists (select movimiento from mavibonificacionmov where movimiento = @mov and idbonificacion in
( select id from mavibonificacionconf where bonificacion like '%atraso%' )))
begin
if exists(select * from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crverificadetalle') and type ='u')
drop table #crverificadetalle
select row_number() over (order by bonificacionno )ind , bonifichijo = bonificacionno, bonifichijocascad = encascada
into #crverificadetalle
from mavibonificacionincluye where idbonificacion = @id
order by orden
set @tincluye =0
set @avanza = 0
select @tincluye = max(ind),@avanza = 1 from #crverificadetalle
while @avanza <= @tincluye and @ok is null
begin
select @bonifichijo = bonifichijo , @bonifichijocascad = bonifichijocascad
from #crverificadetalle
where ind = @avanza
if rtrim(@bonifichijo) like '%atraso%' and @bonificacion like '%adelanto%' select @baseparaaplicar = @importeventa
if rtrim(@bonifichijo) like '%atraso%' and @bonificacion like '%comercial%' select @baseparaaplicar = @importeventa * (@porcbon1/100)
exec spbonificaciondocrestantes @bonifichijo,@bonifichijocascad, @padremavi, @padremaviid ,@idventa , @lineavta,
@sucursal , @tiposucursal, @estacion ,@uen,@condicion, @importeventa, @tipo, @idcxc, @idcobro,@maxdiasatrazo, @id,@bonificacion,@baseparaaplicar, 'incluye', @montobonif, @fechaemision
set @avanza = @avanza + 1
end
end
if (@ok is null and @tipo = 'total' and not @bonificacion like '%contado comercial%') or
(@ok is null and @tipo <> 'total' and not @bonificacion like '%contado comercial%')
begin
exec spbonificaciondocrestantes @bonificacion,'no', @padremavi, @padremaviid ,@idventa , @lineavta,
@sucursal , @tiposucursal, @estacion ,@uen,@condicion, @importeventa, @tipo, @idcxc,@idcobro, @maxdiasatrazo, @id, @bonificacion, @baseparaaplicar, '', @montobonif, @fechaemision
end
end
set @recorre = @recorre+1
end
end