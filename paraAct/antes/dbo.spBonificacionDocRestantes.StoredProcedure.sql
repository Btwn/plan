create procedure [dbo].[spbonificaciondocrestantes]
@bonificacion varchar(50),
@encascada varchar(5),
@origen varchar(20),
@origenid varchar(20),
@idventa int,
@lineavta varchar(50),
@sucursal int,
@tiposucursal varchar(50),
@estacion int,
@uen int,
@condicion varchar(50),
@importeventa float,
@tipo varchar(10),
@idcxc int ,
@idcobro int,
@maxdiasatrazo float,
@idbonifica int,
@strbonifica varchar(50),
@baseparaaplicar float,
@incluye char(10),
@montobonifpapa float ,
@fechaemisionbase datetime
as
begin
declare
@empresa varchar(5),
@mov varchar(20),
@movid varchar(20),
@fechaemision datetime,
@concepto varchar(50),
@tipocambio float,
@clienteenviara int,
@vencimiento datetime,
@impuestos float,
@saldo float,
@importedocto float,
@importecasca float,
@referencia varchar(50),
@documento1de int,
@documentototal int,
@origentipo varchar(20),
@extraed int,
@extraea int,
@movidventa varchar(20),
@movventa varchar(20),
@diasmenoresa int,
@diasmayoresa int,
@id int,
@idbonificacion int,
@estatus varchar(15),
@porcbon1 float,
@porcbon1bas float,
@montobonif float,
@financiamiento float,
@fechaini datetime,
@fechafin datetime,
@patotal bit,
@actvigencia bit,
@cascadacalc bit,
@aplicaa char(30),
@plazoejefin int,
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
@nopuedeaplicarsola bit,
@ejercicio int,
@lineacelulares float,
@lineacredilanas float,
@importeventa2 float,
@lineamotos varchar(25),
@mesesadelanto int
,@dvextra int
, @porcbonextra float
if exists(select * from tempdb.sys.sysobjects where id=object_id('tempdb..#movspendientes') and type='u')
drop table #movspendientes
select id, empresa,mov,movid, fechaemision,concepto, estatus,
clienteenviara,vencimiento,importe, impuestos,saldo,referencia,
padremavi, padreidmavi
into #movspendientes
from cxcpendiente cp where cp.padremavi = @origen and cp.padreidmavi = @origenid
and not referencia is null and cp.estatus= 'pendiente'
update m set importe = calc.calculo,impuestos=cast(0.00 as money)
from #movspendientes m
inner join (
select
importe = doc.importe+doc.impuestos,
documentos = con.danumerodocumentos,
doc.padremavi,
doc.padreidmavi,
monedero = isnull(mon.abono,0),
calculo = (((doc.importe+doc.impuestos))-isnull(mon.abono,0))/con.danumerodocumentos
from dbo.cxc doc left join dbo.condicion con on con.condicion=doc.condicion
left join dbo.auxiliarp mon on mon.mov=doc.mov and mon.movid=doc.movid and isnull(mon.abono,0)>0
where doc.mov=@origen and doc.movid=@origenid and doc.estatus<>'cancelado'
)calc on calc.padremavi=m.padremavi and calc.padreidmavi=m.padreidmavi
select @ok = null , @okref = '', @ejercicio = year(getdate()), @periodo = month(getdate()), @mov = '',@diasmenoresa=0, @diasmayoresa=0, @charreferencia= 0 , @importecasca=0.00
select @importeventa2 = 0.00
select @mov = mov from cxc where id = @idcxc
if @incluye = 'incluye'
select
@idbonificacion = id,@porcbon1bas = porcbon1,@financiamiento = financiamiento,@fechaini = fechaini,
@fechafin = fechafin,@patotal = patotal,@aplicaa = aplicaa,@plazoejefin = plazoejefin,@vencimientoantes = vencimientoantes,
@vencimientodesp = vencimientodesp,@diasatrazo = diasatrazo,@diasmenoresa = diasmenoresa,@diasmayoresa = diasmayoresa,
@factor = factor,@linea = linea, @nopuedeaplicarsola = isnull(nopuedeaplicarsola,0)
from
(
select id, porcbon1, financiamiento, fechaini, fechafin, patotal, aplicaa, plazoejefin, vencimientoantes,
vencimientodesp, diasatrazo, diasmenoresa, diasmayoresa, factor, linea, nopuedeaplicarsola
,row_number() over (partition by bonificacion order by id) perbonif
from mavibonificacionconf join mavibonificacionmov bm on id = bm.idbonificacion
where bonificacion = @bonificacion
and estatus = 'concluido'
and fechaini <= @fechaemisionbase and fechafin >= @fechaemisionbase
and bm.movimiento = @mov
)boni
where perbonif = 1
select @mov = ''
if @incluye <> 'incluye'
select
@idbonificacion = id,@porcbon1bas = porcbon1,@financiamiento = financiamiento,@fechaini = fechaini,
@fechafin = fechafin,@patotal = patotal,@aplicaa = aplicaa,@plazoejefin = plazoejefin,@vencimientoantes = vencimientoantes,
@vencimientodesp = vencimientodesp,@diasatrazo = diasatrazo,@diasmenoresa = diasmenoresa,@diasmayoresa = diasmayoresa,
@factor = factor,@linea = linea, @nopuedeaplicarsola = isnull(nopuedeaplicarsola,0)
from mavibonificacionconf where bonificacion = @bonificacion
and id = @idbonifica
and estatus = 'concluido'
and fechaini <= @fechaemisionbase and fechafin >= @fechaemisionbase
if exists(select * from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crcxcpendientes') and type ='u')
drop table #crcxcpendientes
create table #crcxcpendientes( consec int identity, idcxc int, empresa varchar(50),mov varchar(30) ,movid varchar(30), fechaemision datetime ,
clienteenviara int,vencimiento datetime ,importedocto float, impuestos float,saldo float,concepto varchar(50) null, referencia varchar(50) null )
if @tipo = 'total' and @nopuedeaplicarsola = 0
begin
insert into #crcxcpendientes ( idcxc , empresa ,mov ,movid , fechaemision ,clienteenviara ,vencimiento ,importedocto , impuestos ,
saldo ,concepto , referencia )
select id, empresa,mov,movid, fechaemision, clienteenviara,vencimiento,importe, impuestos,saldo,concepto,referencia
from #movspendientes cp
where cp.padremavi = @origen and cp.padreidmavi = @origenid
and not referencia is null and cp.estatus= 'pendiente'
union
select cp.id, cp.empresa,cp.mov,cp.movid, cp.fechaemision,cp.clienteenviara,cp.vencimiento,cp.importe, cp.impuestos,cp.saldo,cp.concepto,cp.referencia
from cxcpendiente cp join neciamoratoriosmavi nmm on(cp.mov = nmm.mov and cp.movid = nmm.movid)
where cp.padremavi = @origen and cp.padreidmavi = @origenid
and cp.estatus= 'pendiente'
and (nmm.mov like '%nota car%' or nmm.mov like '%contra recibo%')
and nmm.idcobro=@idcobro
end
else if isnull(@tipo,'')<>'total' and @nopuedeaplicarsola = 0
begin
insert into #crcxcpendientes ( idcxc , empresa ,mov ,movid , fechaemision ,clienteenviara ,vencimiento ,importedocto , impuestos ,
saldo ,concepto , referencia )
select id, empresa,mov,movid, fechaemision, clienteenviara,vencimiento,importe, impuestos,saldo,concepto,referencia
from #movspendientes cp where cp.padremavi = @origen and cp.padreidmavi = @origenid
and not referencia is null and cp.estatus= 'pendiente'
union
select cp.id, cp.empresa,cp.mov,cp.movid, cp.fechaemision,
cp.clienteenviara,cp.vencimiento,cp.importe, cp.impuestos,cp.saldo,cp.concepto,cp.referencia
from cxcpendiente cp join neciamoratoriosmavi nmm on(cp.mov = nmm.mov and cp.movid = nmm.movid )
where cp.padremavi = @origen and cp.padreidmavi = @origenid
and cp.estatus= 'pendiente'
and (nmm.mov like '%nota car%' or nmm.mov like '%contra recibo%')
and nmm.idcobro=@idcobro
end
select @dvextra = maxdv, @porcbonextra =porcbon from mavibonificacionconvencimiento where idbonificacion = @idbonifica
if @nopuedeaplicarsola = 1
begin
insert into #crcxcpendientes ( idcxc , empresa ,mov ,movid , fechaemision ,clienteenviara ,vencimiento ,importedocto , impuestos ,
saldo ,concepto , referencia )
select top(1)id, empresa,mov,movid, fechaemision, clienteenviara,vencimiento,importe, impuestos,saldo,concepto,referencia
from #movspendientes cp
where cp.padremavi = @origen and cp.padreidmavi = @origenid
and not referencia is null and cp.estatus= 'pendiente'
end
if @idbonificacion is not null
begin
declare @totreg int , @recorre int
select @totreg =max(consec) , @recorre = 1 from #crcxcpendientes
while @recorre <= @totreg
begin
select @idcxc = idcxc , @empresa = empresa ,@mov = mov ,@movid =movid , @fechaemision =fechaemision ,@concepto = concepto,
@clienteenviara =clienteenviara,@vencimiento = vencimiento,@importedocto = importedocto, @impuestos = impuestos,@saldo = saldo,
@concepto = concepto ,@referencia =referencia
from #crcxcpendientes
where consec= @recorre
select @importedocto = @importedocto + isnull(@impuestos,0.00), @porcbon1 = @porcbon1bas, @ok = null, @okref = ''
if @mov like '%nota car%'
begin
if isnull(@concepto,'') not like 'canc cobro%'
select @ok=1, @okref = 'la nota no pertenece a un concepto para bonificaci¢n'
end
if patindex('%/%',@referencia) > 0
begin
select @extraed = patindex('%(%',@referencia), @extraea = patindex('%/%',@referencia)
select @documento1de = substring(@referencia,@extraed+1,@extraea - @extraed -1)
select @extraed = patindex('%/%',@referencia), @extraea = patindex('%)%',@referencia)
select @documentototal = substring(@referencia,@extraed+1,@extraea - @extraed -1)
end
if @vencimientoantes <> 0 and (not @mov like '%nota car%' or not @mov like '%contra%')
begin
set @charreferencia = rtrim(@vencimientoantes) + '/' + rtrim(@documentototal)
if not exists(select id from cxcpendiente where padremavi = @origen and padreidmavi = @origenid
and estatus = 'pendiente' and referencia like '%' + @charreferencia + '%')
select @ok=1, @okref = 'excede el n£mero m¡nimo del pa a jalar'
end
if @vencimientodesp <= @documento1de and @vencimientodesp <> 0 and (not @mov like '%nota car%' or not @mov like '%contra%')
begin
set @charreferencia = rtrim(@documento1de) + '/' + rtrim(@documentototal)
if not exists(select id from cxcpendiente where padremavi = @origen and padreidmavi = @origenid
and estatus = 'pendiente' and referencia like '%' + @charreferencia + '%')
select @ok=1, @okref = 'excede el numero maximo del pa a jalar'
end
if @diasatrazo <> 0 and @mov <> 'nota car'
begin
if @maxdiasatrazo > @diasatrazo select @ok=1, @okref = 'excede el n£mero de dias de atraso permitidos '
end
if @diasmenoresa <> 0 and @bonificacion not like '%contado comercial%'
begin
if @diasmenoresa < datediff(day, @fechaemision, getdate() )
select @ok=1, @okref = 'excede d¡as menores' + convert (char(30),@diasmenoresa)
end
if @diasmayoresa <> 0 and @bonificacion not like '%contado comercial%'
begin
if @diasmayoresa > datediff(day, @fechaemision, getdate() )
select @ok=1, @okref = 'excede d¡as mayores' + convert (char(30),@diasmayoresa)
end
if @vencimientodesp <> 0
begin
set @charreferencia = '(' + rtrim(@vencimientodesp) + '/' + rtrim(@documentototal)
if dbo.fnfechasinhora(getdate()) <= dbo.fnfechasinhora((select c.vencimiento from cxc c where c.origen = @origen and c.origenid = @origenid and c.referencia like '%' + @charreferencia + '%'))
select @ok=1, @okref = 'no cumple con el límite de pa posterior2'
end
if @porcbon1 = 0 and @linea <> 0 select @porcbon1 = @linea
if @linea < (select isnull(porclin,0.00) from mavibonificacionlinea where idbonificacion=@id and linea = @lineavta)
select @linea = (select isnull(porclin,0.00) from mavibonificacionlinea where idbonificacion=@id and linea = @lineavta)
select @lineacredilanas=isnull(porclin,0.00) from mavibonificacionlinea mbl where linea like '%credilana%' and idbonificacion = @idbonificacion
select @lineacelulares=isnull(porclin,0.00) from mavibonificacionlinea mbl where linea like '%celular%' and idbonificacion = @idbonificacion
select @lineamotos=isnull(porclin,0.00) from mavibonificacionlinea mbl where linea like '%motocicleta%' and idbonificacion = @idbonificacion
if exists(select idbonificacion from mavibonificacioncanalvta boncan where boncan.idbonificacion=@idbonificacion)
begin
if not exists(select idbonificacion from mavibonificacioncanalvta boncan where convert(varchar(10),boncan.canalventa)=@clienteenviara and boncan.idbonificacion=@idbonificacion)
select @ok=1, @okref = 'venta de canal no configurada para esta bonificaci¢n'
end
if exists(select idbonificacion from mavibonificacionuen mbu where mbu.idbonificacion=@idbonificacion)
begin
if not @uen is null and not exists(select idbonificacion from mavibonificacionuen mbu where mbu.uen = @uen and mbu.idbonificacion=@idbonificacion)
select @ok=1, @okref = 'uen no configurada para este caso'
end
if exists(select idbonificacion from mavibonificacioncondicion where idbonificacion=@idbonificacion)
begin
if not exists(select idbonificacion from mavibonificacioncondicion where condicion=@condicion and idbonificacion=@idbonificacion)
select @ok=1, @okref = 'condicion no configurada para esta bonificaci¢n'
end
if exists(select idbonificacion from mavibonificacionexcluye exc where bonificacionno=@bonificacion)
begin
if exists(select bontest.idbonificacion from mavibonificaciontest bontest join mavibonificacionexcluye exc on(bontest.idbonificacion = exc.idbonificacion)
where exc.bonificacionno=@bonificacion and bontest.okref = '' and bontest.montobonif > 0
and idcobro = @idcobro and origen=@origen and origenid=@origenid)
select @ok=1, @okref = 'excluye esta bonificacion una anterior detalle'
end
if exists(select idbonificacion from mavibonificacionsucursal exc where idbonificacion=@idbonificacion)
begin
if not @tiposucursal is null and not exists(select idbonificacion from mavibonificacionsucursal where sucursal=@tiposucursal and idbonificacion=@idbonificacion)
select @ok=1, @okref = 'bonificaci¢n no configurada para este tipo de sucursal'
end
if not exists(select idbonificacion from mavibonificaciontest where idbonificacion=rtrim(@idbonificacion) and docto = @idcxc and estacion = @estacion and montobonif = @montobonif)
begin
if @aplicaa = 'importe de factura'
begin
if @linea <> 0 select @porcbon1=@linea
if @lineacelulares <> 0 and @bonificacion not like '%contado%' and @bonificacion not like '%atraso%' select @porcbon1=@lineacelulares
if @lineacredilanas <> 0 and @bonificacion not like '%contado%' and @bonificacion not like '%atraso%' select @porcbon1=@lineacredilanas
if @encascada = 'si' select @importeventa2 = @importeventa - @montobonifpapa
if @encascada <> 'si' select @importeventa2 = @importeventa
select @montobonif = (@porcbon1/100) * @importeventa2
end
if @bonificacion like '%adelanto%' and @tipo = 'total'
begin
if @linea <> 0 select @porcbon1=@linea
if isnull(@lineacelulares,0) <> 0 and @lineavta like '%celular%' select @porcbon1=@lineacelulares
if isnull(@lineacredilanas,0) <> 0 and @lineavta like '%credila%' select @porcbon1=@lineacredilanas
if @bonificacion like '%contado%' select @porcbon1=@lineamotos
if @encascada = 'si' select @importeventa2 = @importeventa - @montobonifpapa
if @encascada <> 'si' select @importeventa2 = @importeventa
select
@mesesadelanto=count(id)
from cxc where padremavi = @origen and padreidmavi = @origenid and padremavi <> mov and vencimiento>getdate()
if @mesesadelanto > @documentototal select @mesesadelanto = @documentototal
select @porcbon1 = @porcbon1 * @mesesadelanto
select @importeventa2 = (@importeventa2 / @documentototal) * @mesesadelanto
select @importeventa2 = @importeventa2 / (select count(id) from (
select id, empresa,mov,movid, fechaemision,concepto,
clienteenviara,vencimiento,importe, impuestos,saldo,referencia
from cxc cp where cp.padremavi = @origen and cp.padreidmavi = @origenid
and not referencia is null and cp.estatus= 'pendiente'
union
select cp.id, cp.empresa,cp.mov,cp.movid, cp.fechaemision,cp.concepto,
cp.clienteenviara,cp.vencimiento,cp.importe, cp.impuestos,cp.saldo,cp.referencia
from cxcpendiente cp join neciamoratoriosmavi nmm on(cp.mov = nmm.mov and cp.movid = nmm.movid)
where cp.padremavi = @origen and cp.padreidmavi = @origenid
and cp.estatus= 'pendiente'
and (nmm.mov like '%nota car%' or nmm.mov like '%contra recibo%')
and nmm.idcobro=@idcobro)x )
end
if @aplicaa <> 'importe de factura' and @bonificacion<>'bonificacion pa puntual'
select @montobonif = (@porcbon1/100) * @importeventa2
if @aplicaa <> 'importe de factura' and @bonificacion='bonificacion pa puntual'
select @montobonif = (@porcbon1/100) * @importedocto
if not @ok is null select @montobonif = 0.00,@porcbon1 = 0.00
if @bonificacion like '%puntual%' and (dbo.fnfechasinhora(getdate()) > (dbo.fnfechasinhora(@vencimiento)))
begin
if ( select dv = datediff(dd,@vencimiento, convert(datetime,convert(varchar(10),getdate(),10))) ) <= @dvextra
select @porcbon1 = @porcbonextra, @montobonif = (@porcbonextra/100) * @importedocto
else
select @ok = 1 , @okref = 'excede el vencimiento', @montobonif = 0.00 , @porcbon1 = 0.00
end
if @bonificacion like '%adelanto%' and dbo.fnfechasinhora(getdate()) >= dbo.fnfechasinhora(@vencimiento)
select @montobonif = 0.00 , @porcbon1 = 0.00, @ok = 1 , @okref = 'por el vencimiento del docto'
if @bonificacion like '%adelanto%' and @tipo<>'total' select @montobonif = 0.00 , @porcbon1 = 0.00 , @ok = 1 , @okref = 'adelanto aplica a puro total'
if @bonificacion like '%atraso%' and @tipo<>'total' select @montobonif = 0.00 , @porcbon1 = 0.00
if @bonificacion like '%atraso%' and @tipo<>'total' select @baseparaaplicar = @baseparaaplicar - @montobonifpapa
if @bonificacion like '%atraso%' select @baseparaaplicar = @importeventa2
if @bonificacion like '%puntual%' select @baseparaaplicar = @importedocto
insert mavibonificaciontest (idbonificacion, idcobro, docto,bonificacion, estacion, documento1de,documentototal,mov, movid,origen,origenid,importeventa,importedocto, montobonif, tiposucursal,lineavta,idventa,uen,condicion,porcbon1,
financiamiento, ok,okref,factor,sucursal1, plazoejefin,fechaemision,vencimiento, lineacelulares, lineacredilanas,diasmenoresa,diasmayoresa,baseparaaplicar)
values(@idbonificacion,@idcobro, @idcxc,isnull(@bonificacion,''),@estacion, isnull(@documento1de,0),isnull(@documentototal,0),isnull(@mov,''),isnull(@movid,''), isnull(@origen,''),isnull(@origenid,''),
round(isnull(@importeventa,0.00),2), round(isnull(@importedocto,0.00),2), round(isnull(@montobonif,0.00),2), isnull(@tiposucursal,''),isnull(@lineavta,''),isnull(@idventa,0),isnull(@uen,0),isnull(@condicion,''),
isnull(@porcbon1,0.00), isnull(@financiamiento,0.00), isnull(@ok,0),isnull(@okref,''),isnull(@factor,0.00),@sucursal,@plazoejefin,@fechaemision,@vencimiento, isnull(@lineacelulares,0.00), isnull(@lineacredilanas,0.00),
@diasmenoresa,@diasmayoresa,round(isnull(@baseparaaplicar,0.00),2))
end
set @recorre = @recorre + 1
end
end
if exists(select * from tempdb.sys.sysobjects where id=object_id('tempdb..#movspendientes') and type='u')
drop table #movspendientes
if exists(select * from tempdb.sys.sysobjects where id=object_id('tempdb.dbo.#crcxcpendientes') and type ='u')
drop table #crcxcpendientes
end