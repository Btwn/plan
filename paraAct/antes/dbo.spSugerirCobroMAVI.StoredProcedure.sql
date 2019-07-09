create procedure [dbo].[spsugerircobromavi]
@sugerirpavarchar(20),
@modulochar(5),
@idint,
@importetotalmoney,
@usuariovarchar(10),
@estacionint
as begin
declare
@empresachar(5),
@sucursalint,
@hoydatetime,
@vencimientodatetime,
@diascreditoint,
@diasvencidoint,
@tasadiariafloat,
@monedachar(10),
@tipocambiofloat,
@contactochar(10),
@renglonfloat,
@aplicavarchar(20),
@aplicaidvarchar(20),
@aplicamovtipovarchar(20),
@capitalmoney,
@interesesmoney,
@interesesordinariosmoney,
@interesesfijosmoney,
@interesesmoratoriosmoney,
@impuestoadicionalfloat,
@importemoney,
@sumaimportemoney,
@impuestosmoney,
@desglosarimpuestos bit,
@lineacreditovarchar(20),
@metodoint,
@generamoratoriomavichar(1),
@montominimomorfloat,
@condonamoratoriosint,
@iddetalleint,
@imprealmoney,
@moratorioapagarmoney,
@origenvarchar(20),
@origenidvarchar(20),
@movpadrevarchar(20),
@movpadreidvarchar(20),
@movpadre1varchar(20),
@movidpadrevarchar(20)
,@padremavipend varchar(20)
,@padremaviidpend varchar(20)
,@notacredxcanc char(1),
@mov varchar(20),
@aplicanota varchar(20),
@aplicaidnota varchar(20)
delete neciamoratoriosmavi where idcobro = @id
delete from histcobromoratoriosmavi where idcobro = @id
if exists(select * from tipocobromavi with (nolock) where idcobro = @id)
update tipocobromavi with (rowlock) set tipocobro = 0 where idcobro = @id
else
insert into tipocobromavi(idcobro, tipocobro) values(@id, 0)
create table #notaxcanc(mov varchar(20) null,movid varchar(20) null)
insert into #notaxcanc(mov,movid)
select distinct d.mov,d.movid from neciamoratoriosmavi c with (nolock), cxcpendiente d with (nolock), cxc n with (nolock) where c.mov in('nota car','nota car viu') and d.cliente=@contacto
and d.mov=c.mov and d.movid=c.movid and d.padremavi in ('credilana','prestamo personal') and n.mov=c.mov and n.movid=c.movid
and n.concepto in ('canc cobro cred y pp')
select @desglosarimpuestos = 0 , @renglon = 0.0, @sumaimporte = 0.0, @importetotal = nullif(@importetotal, 0.0), @sugerirpa = upper(@sugerirpa)
select @empresa = empresa, @sucursal = sucursal, @hoy = fechaemision, @moneda = moneda, @tipocambio = tipocambio, @contacto = cliente, @mov = mov from cxc with (nolock) where id = @id
if @sugerirpa <> 'importe especifico' select @importetotal = 9999999
select @montominimomor = isnull(montominmoratoriomavi,0.0) from empresacfg2 with (nolock) where empresa = @empresa
if @modulo = 'cxc'
begin
select @empresa = empresa, @sucursal = sucursal, @hoy = fechaemision, @moneda = moneda, @tipocambio = tipocambio, @contacto = cliente from cxc with (nolock) where id = @id
delete cxcd where id = @id
declare craplica cursor for
select p.mov, p.movid, p.vencimiento, mt.clave, isnull(p.saldo*mt.factor*p.movtipocambio/@tipocambio, 0.0), isnull(p.interesesordinarios*mt.factor*p.movtipocambio/@tipocambio, 0.0), isnull(p.interesesfijos*p.movtipocambio/@tipocambio, 0.0),
isnull(p.interesesmoratorios*mt.factor*p.movtipocambio/@tipocambio, 0.0), isnull(p.origen, p.mov), isnull(p.origenid, p.movid)
,p.padremavi, p.padreidmavi
from cxcpendiente p with (nolock)
join movtipo mt with (nolock) on mt.modulo = @modulo and mt.mov = p.mov
left outer join cfgaplicaorden a with (nolock) on a.modulo = @modulo and a.mov = p.mov
left outer join cxc r with (nolock) on r.id = p.ramaid
left outer join tipoamortizacion ta with (nolock) on ta.tipoamortizacion = r.tipoamortizacion
where p.empresa = @empresa and p.cliente = @contacto and mt.clave not in ('cxc.sch','cxc.sd', 'cxc.nc')
order by a.orden, p.vencimiento, p.mov, p.movid
select @desglosarimpuestos = isnull(cxccobroimpuestos, 0) from empresacfg2 with (nolock) where empresa = @empresa
end else
return
open craplica
fetch next from craplica into @aplica, @aplicaid, @vencimiento, @aplicamovtipo, @capital, @interesesordinarios, @interesesfijos, @interesesmoratorios, @origen, @origenid
,@padremavipend, @padremaviidpend
while @@fetch_status <> -1 and ((@sugerirpa = 'saldo vencido' and @vencimiento<=@hoy and @importetotal > @sumaimporte ) or (@sugerirpa = 'importe especifico' and @importetotal > @sumaimporte) or @sugerirpa = 'saldo total')
begin
if @@fetch_status <> -2
begin
select @condonamoratorios = 0, @generamoratoriomavi = null, @iddetalle = 0, @moratorioapagar = 0
select @iddetalle = id from cxc with (nolock) where mov = @aplica and movid = @aplicaid
select @generamoratoriomavi = dbo.fngeneramoratoriomavi(@iddetalle)
if @generamoratoriomavi = '1'
begin
select @interesesmoratorios = 0
select @interesesmoratorios = dbo.fninteresmoratoriomavi(@iddetalle)
select @moratorioapagar = @interesesmoratorios
if @interesesmoratorios <= @montominimomor and @interesesmoratorios > 0
begin
if exists(select * from condonamorxsistmavi with (nolock) where idcobro = @id and idmov = @iddetalle and estatus = 'alta')
update condonamorxsistmavi with (rowlock)
set montooriginal = @interesesmoratorios,
montocondonado = @interesesmoratorios
where idcobro = @id and idmov = @iddetalle and estatus = 'alta'
else
insert into condonamorxsistmavi(usuario, fechaautorizacion, idmov,renglonmov,mov,movid,montooriginal, montocondonado, tipocondonacion, estatus, idcobro)
values(@usuario, getdate(), @iddetalle,0,@aplica, @aplicaid, @interesesmoratorios, @interesesmoratorios, 'por sistema', 'alta', @id)
select @interesesmoratorios = 0
end
if @interesesmoratorios > 0 and @interesesmoratorios > @montominimomor
begin
if @sumaimporte + @interesesmoratorios > @importetotal select @moratorioapagar = @importetotal - @sumaimporte
select @sumaimporte = @sumaimporte + @moratorioapagar
if @interesesmoratorios > 0
begin
insert neciamoratoriosmavi( idcobro, estacion, usuario, mov, movid, importereal, importeapagar, importemoratorio, importeacondonar, moratorioapagar, origen, origenid)
values(@id, @estacion, @usuario, @aplica, @aplicaid, @capital, 0, @interesesmoratorios, 0, @moratorioapagar, @padremavipend, @padremaviidpend)
if @aplica in ('nota car','nota car viu')
begin
select @aplicanota= isnull(mov,'na'), @aplicaidnota = isnull(movid,'na') from #notaxcanc where mov=@aplica and movid=@aplicaid
if @aplicanota <> 'na' and @aplicaidnota <> 'na'
update neciamoratoriosmavi with (rowlock) set notacreditoxcanc = '1' where idcobro = @id and estacion = @estacion and mov = @aplica and movid = @aplicaid
end
end
end
end
else select @interesesmoratorios = 0
fetch next from craplica into @aplica, @aplicaid, @vencimiento, @aplicamovtipo, @capital, @interesesordinarios, @interesesfijos, @interesesmoratorios, @origen, @origenid
,@padremavipend, @padremaviidpend
end
end
close craplica
deallocate craplica
if @modulo = 'cxc' and @sumaimporte <= @importetotal
begin
select @empresa = empresa, @sucursal = sucursal, @hoy = fechaemision, @moneda = moneda, @tipocambio = tipocambio, @contacto = cliente from cxc with (nolock) where id = @id
declare crdocto cursor for
select p.mov, p.movid, p.vencimiento, mt.clave, round(isnull(p.saldo*mt.factor*p.movtipocambio/@tipocambio, 0.0),2), isnull(p.interesesordinarios*mt.factor*p.movtipocambio/@tipocambio, 0.0), isnull(p.interesesfijos*p.movtipocambio/@tipocambio, 0.0),
isnull(p.interesesmoratorios*mt.factor*p.movtipocambio/@tipocambio, 0.0), isnull(p.origen,p.mov), isnull(p.origenid, p.movid)
,p.padremavi , p.padreidmavi
from cxcpendiente p with (nolock)
join movtipo mt with (nolock) on mt.modulo = @modulo and mt.mov = p.mov
left outer join cfgaplicaorden a with (nolock) on a.modulo = @modulo and a.mov = p.mov
left outer join cxc r with (nolock) on r.id = p.ramaid
left outer join tipoamortizacion ta with (nolock) on ta.tipoamortizacion = r.tipoamortizacion
where p.empresa = @empresa and p.cliente = @contacto and mt.clave not in ('cxc.sch','cxc.sd', 'cxc.nc')
order by a.orden, p.vencimiento, p.mov, p.movid
end else
return
open crdocto
fetch next from crdocto into @aplica, @aplicaid, @vencimiento, @aplicamovtipo, @capital, @interesesordinarios, @interesesfijos, @interesesmoratorios, @origen, @origenid
,@padremavipend, @padremaviidpend
while @@fetch_status <> -1 and ((@sugerirpa = 'saldo vencido' and @vencimiento<=@hoy and @importetotal > @sumaimporte ) or (@sugerirpa = 'importe especifico' and @importetotal > @sumaimporte) or @sugerirpa = 'saldo total')
begin
if @@fetch_status <> -2
begin
select @impreal = @capital
if @sumaimporte + @capital > @importetotal select @capital = @importetotal - @sumaimporte
if @capital > 0
begin
select @sumaimporte = @sumaimporte + @capital
if exists(select * from neciamoratoriosmavi with (nolock) where idcobro = @id and estacion = @estacion and mov = @aplica and movid = @aplicaid)
begin
update neciamoratoriosmavi with (rowlock)
set importeapagar = @capital
where estacion = @estacion
and mov = @aplica
and movid = @aplicaid
and idcobro = @id
if @aplica in ('nota car','nota car viu')
begin
select @aplicanota= isnull(mov,'na'), @aplicaidnota = isnull(movid,'na') from #notaxcanc where mov=@aplica and movid=@aplicaid
if @aplicanota <> 'na' and @aplicaidnota <> 'na'
update neciamoratoriosmavi with (rowlock) set notacreditoxcanc = '1' where idcobro = @id and estacion = @estacion and mov = @aplica and movid = @aplicaid
end
end
else
begin
insert neciamoratoriosmavi( idcobro, estacion, usuario, mov, movid, importereal, importeapagar, importemoratorio, importeacondonar, origen, origenid)
values(@id, @estacion, @usuario, @aplica, @aplicaid, @impreal, @capital, 0, 0, @padremavipend, @padremaviidpend)
if @aplica in ('nota car','nota car viu')
begin
select @aplicanota= isnull(mov,'na'), @aplicaidnota = isnull(movid,'na') from #notaxcanc where mov=@aplica and movid=@aplicaid
if @aplicanota <> 'na' and @aplicaidnota <> 'na'
update neciamoratoriosmavi with (rowlock) set notacreditoxcanc = '1' where idcobro = @id and estacion = @estacion and mov = @aplica and movid = @aplicaid
end
end
end
fetch next from crdocto into @aplica, @aplicaid, @vencimiento, @aplicamovtipo, @capital, @interesesordinarios, @interesesfijos, @interesesmoratorios, @origen, @origenid
,@padremavipend, @padremaviidpend
end
end
close crdocto
deallocate crdocto
drop table #notaxcanc
exec sporigenncxcancmavi @id
exec sporigencobrosinstmavi @id
exec sptipopabonifmavi @sugerirpa, @id
exec spbonifmonto@id
exec spimptotalbonifmavi @id
return
end