create procedure [dbo].[spdocauto] @id int,
@interesesmov char(20),
@docmov char(20),
@usuario char(10) = null,
@conexion bit = 0,
@sincrofinal bit = 0,
@ok int = null output,
@okref varchar(255) = null output
as
begin
declare @sucursal int,
@a int,
@empresa char(5),
@modulo char(5),
@cuenta char(10),
@moneda char(10),
@mov char(20),
@movid varchar(20),
@movtipo char(20),
@movaplicaimporte money,
@condicion varchar(50),
@importe money,
@impuestos money,
@importedocumentar money,
@importetotal money,
@intereses money,
@interesesimpuestos money,
@interesesconcepto varchar(50),
@interesesaplicaimporte money,
@numerodocumentos int,
@primervencimiento datetime,
@periodo char(15),
@concepto varchar(50),
@observaciones varchar(100),
@estatus char(15),
@docestatus char(15),
@fechaemision datetime,
@fecharegistro datetime,
@movusuario char(10),
@proyecto varchar(50),
@referencia varchar(50),
@tipocambio float,
@saldo money,
@interesesid int,
@interesesmovid varchar(20),
@docid int,
@docmovid varchar(20),
@docimporte money,
@sumaimporte1 money,
@sumaimporte2 money,
@sumaimporte3 money,
@docautofolio char(20),
@importe1 money,
@importe2 money,
@importe3 money,
@dif money,
@vencimiento datetime,
@dia int,
@esquince bit,
@impprimerdoc bit,
@mensaje varchar(255),
@ppfechaemision datetime,
@ppvencimiento datetime,
@ppdias int,
@ppfechaprontopa datetime,
@ppdescuentoprontopa float,
@clienteenviara int,
@cobrador varchar(50),
@personalcobrador char(10),
@agente char(10),
@desglosarimpuestos bit,
@aplicaimpuestos money,
@redondeomonetarios int,
@tasa varchar(50),
@ramaid int,
@interesporcentaje float,
@pamensual money,
@capitalanterior money,
@capitalinsoluto money,
@cfgdocautoborrador bit,
@cortedias int,
@menosdias int
set @cortedias = 2
select
@redondeomonetarios = redondeomonetarios
from version with (nolock)
select
@esquince = 0,
@saldo = 0.0,
@proyecto = null,
@fecharegistro = getdate(),
@sumaimporte1 = 0.0,
@sumaimporte2 = 0.0,
@sumaimporte3 = 0.0,
@desglosarimpuestos = 0
select
@sucursal = sucursal,
@empresa = empresa,
@modulo = modulo,
@cuenta = cuenta,
@moneda = moneda,
@mov = mov,
@movid = movid,
@importedocumentar = importedocumentar,
@intereses = isnull(intereses, 0.0),
@interesesimpuestos = isnull(interesesimpuestos, 0.0),
@interesesconcepto = interesesconcepto,
@numerodocumentos = numerodocumentos,
@primervencimiento = primervencimiento,
@periodo = upper(periodo),
@concepto = concepto,
@observaciones = observaciones,
@estatus = estatus,
@fechaemision = fechaemision,
@movusuario = usuario,
@impprimerdoc = impprimerdoc,
@condicion = condicion,
@interesporcentaje = nullif(interes / 100, 0)
from docauto with (nolock)
where id = @id
select
@tipocambio = tipocambio
from mon with (nolock)
where moneda = @moneda
if nullif(rtrim(@usuario), '') is null
select
@usuario = @movusuario
select
@movtipo = clave
from movtipo with (nolock)
where modulo = @modulo
and mov = @mov
select
@ppfechaemision = @fechaemision,
@docmov = nullif(nullif(rtrim(@docmov), ''), '0')
if @docmov is null
select
@ok = 10160
select
@cfgdocautoborrador = isnull(case @modulo
when 'cxc' then cxcdocautoborrador
else cxpdocautoborrador
end, 0)
from empresacfg2 with (nolock)
where empresa = @empresa
if @cfgdocautoborrador = 1
select
@docestatus = 'borrador'
else
select
@docestatus = 'sinafectar'
if @movtipo in ('cxc.a', 'cxc.ar', 'cxc.da', 'cxc.nc', 'cxc.dac', 'cxp.a', 'cxp.da', 'cxp.nc', 'cxp.dac')
begin
select
@intereses = 0.0,
@interesesimpuestos = 0.0
select
@docautofolio =
case @modulo
when 'cxc' then nullif(rtrim(cxcdocanticipoautofolio), '')
when 'cxp' then nullif(rtrim(cxpdocanticipoautofolio), '')
else null
end
from empresacfg with (nolock)
where empresa = @empresa
end
else
select
@docautofolio =
case @modulo
when 'cxc' then nullif(rtrim(cxcdocautofolio), '')
when 'cxp' then nullif(rtrim(cxpdocautofolio), '')
else null
end
from empresacfg with (nolock)
where empresa = @empresa
if @modulo = 'cxc'
select
@desglosarimpuestos = isnull(cxccobroimpuestos, 0)
from empresacfg2 with (nolock)
where empresa = @empresa
if @estatus = 'sinafectar'
and @numerodocumentos > 0
begin
if @modulo = 'cxc'
select
@ramaid = id,
@importe = isnull(importe, 0.0),
@impuestos = isnull(impuestos, 0.0),
@saldo = isnull(saldo, 0.0),
@proyecto = proyecto,
@clienteenviara = clienteenviara,
@agente = agente,
@cobrador = cobrador,
@personalcobrador = personalcobrador
from cxc with (nolock)
where empresa = @empresa
and cliente = @cuenta
and mov = @mov
and movid = @movid
and estatus = 'pendiente'
else
if @modulo = 'cxp'
select
@ramaid = id,
@importe = isnull(importe, 0.0),
@impuestos = isnull(impuestos, 0.0),
@saldo = isnull(saldo, 0.0),
@proyecto = proyecto
from cxp with (nolock)
where empresa = @empresa
and proveedor = @cuenta
and mov = @mov
and movid = @movid
and estatus = 'pendiente'
select
@importetotal = @importedocumentar + @intereses + @interesesimpuestos
if @saldo < @importedocumentar
select
@ok = 35190
if @ok is null
begin
if @conexion = 0
begin transaction
if @intereses > 0.0
begin
select
@referencia = rtrim(@mov) + ' ' + ltrim(convert(char, @movid))
if @modulo = 'cxc'
begin
insert cxc (sucursal, origentipo, origen, origenid, empresa, mov, fechaemision, concepto, proyecto, moneda, tipocambio, usuario, referencia, observaciones, estatus,
cliente, clientemoneda, clientetipocambio, importe, impuestos,
clienteenviara, agente, cobrador, personalcobrador, tasa, ramaid)
values (@sucursal, @modulo, @mov, @movid, @empresa, @interesesmov, @fechaemision, @interesesconcepto, @proyecto, @moneda, @tipocambio, @usuario, @referencia, @observaciones, @docestatus, @cuenta, @moneda, @tipocambio, @intereses, @interesesimpuestos, @clienteenviara, @agente, @cobrador, @personalcobrador, @tasa, @ramaid)
select
@interesesid = @@identity
end
else
if @modulo = 'cxp'
begin
insert cxp (sucursal, origentipo, origen, origenid, empresa, mov, fechaemision, concepto, proyecto, moneda, tipocambio, usuario, referencia, observaciones, estatus,
proveedor, proveedormoneda, proveedortipocambio, importe, impuestos, tasa, ramaid)
values (@sucursal, @modulo, @mov, @movid, @empresa, @interesesmov, @fechaemision, @interesesconcepto, @proyecto, @moneda, @tipocambio, @usuario, @referencia, @observaciones, @docestatus, @cuenta, @moneda, @tipocambio, @intereses, @interesesimpuestos, @tasa, @ramaid)
select
@interesesid = @@identity
end
if @cfgdocautoborrador = 0
exec spcx @interesesid,
@modulo,
'afectar',
'todo',
@fecharegistro,
null,
@usuario,
1,
0,
@interesesmov output,
@interesesmovid output,
null,
@ok output,
@okref output
end
else
select
@interesesimpuestos = 0.0
if @periodo = 'quincenal'
begin
select
@dia = datepart(dd, @primervencimiento)
select
@menosdias = datepart(dd, dateadd(mm, 1, @primervencimiento))
select
@menosdias = (@dia - @menosdias) + 15
if @dia <= 15
begin
select
@esquince = 1,
@primervencimiento = dateadd(dd, 15 - @dia, @primervencimiento)
set @primervencimiento = dateadd(dd, @cortedias, @primervencimiento)
update venta with (rowlock)
set vencimiento = @primervencimiento
where mov = @mov
and movid = @movid
update cxc with (rowlock)
set vencimiento = @primervencimiento
where mov = @mov
and movid = @movid
end
else
begin
if @dia >= 16
and @dia <= 30
begin
select
@esquince = 0,
@primervencimiento = dateadd(dd, -datepart(dd, @primervencimiento), dateadd(mm, 1, @primervencimiento))
set @primervencimiento = dateadd(dd, @cortedias, @primervencimiento)
if (datepart(dd, @primervencimiento) = 1)
set @primervencimiento = dateadd(dd, 1, @primervencimiento)
if (datepart(dd, @primervencimiento) = 31)
set @primervencimiento = dateadd(dd, 2, @primervencimiento)
update venta with (rowlock)
set vencimiento = @primervencimiento
where mov = @mov
and movid = @movid
update cxc with (rowlock)
set vencimiento = @primervencimiento
where mov = @mov
and movid = @movid
end
else
begin
select
@esquince = 0,
@primervencimiento = dateadd(dd, -datepart(dd, @primervencimiento), dateadd(mm, 1, @primervencimiento))
set @primervencimiento = dateadd(dd, @cortedias + @menosdias, @primervencimiento)
update venta with (rowlock)
set vencimiento = @primervencimiento
where mov = @mov
and movid = @movid
update cxc with (rowlock)
set vencimiento = @primervencimiento
where mov = @mov
and movid = @movid
end
end
end
if @impprimerdoc = 1
and @importedocumentar = @importe + @impuestos
select
@importedocumentar = @importe
select
@a = 1,
@movaplicaimporte = round(@importedocumentar / @numerodocumentos, @redondeomonetarios),
@interesesaplicaimporte = round((@intereses + @interesesimpuestos) / @numerodocumentos, @redondeomonetarios),
@vencimiento = @primervencimiento
select
@pamensual = @movaplicaimporte + isnull(@interesesaplicaimporte, 0)
if @impprimerdoc = 1
select
@docimporte = @movaplicaimporte
else
select
@docimporte = @movaplicaimporte + @interesesaplicaimporte
select
@capitalanterior = @importedocumentar
while (@a <= @numerodocumentos)
and @ok is null
begin
select
@importe1 = 0.0,
@importe2 = 0.0,
@importe3 = 0.0
if @impprimerdoc = 1
and @a = 1
begin
select
@importe1 = @docimporte + @impuestos + @intereses + @interesesimpuestos,
@importe2 = @docimporte + @impuestos,
@importe3 = @intereses + @interesesimpuestos
end
else
begin
select
@importe1 = @docimporte,
@importe2 = @movaplicaimporte
if @impprimerdoc = 1
select
@importe3 = 0.0
else
begin
select
@importe3 = @interesesaplicaimporte
if @interesporcentaje is not null
begin
select
@capitalinsoluto = (@importedocumentar * power(1 + @interesporcentaje, @a)) - (@pamensual * ((power(1 + @interesporcentaje, @a) - 1) / @interesporcentaje))
select
@importe2 = @capitalanterior - @capitalinsoluto
select
@importe3 = @movaplicaimporte + @interesesaplicaimporte - @importe2
select
@capitalanterior = @capitalinsoluto
end
end
end
select
@sumaimporte1 = @sumaimporte1 + @importe1,
@sumaimporte2 = @sumaimporte2 + @importe2,
@sumaimporte3 = @sumaimporte3 + @importe3
if @a = @numerodocumentos
begin
select
@dif = @sumaimporte2 - @importedocumentar
if @dif <> 0.0
select
@importe1 = @importe1 - @dif,
@importe2 = @importe2 - @dif
select
@dif = @sumaimporte3 - (@intereses + @interesesimpuestos)
if @dif <> 0.0
select
@importe1 = @importe1 - @dif,
@importe3 = @importe3 - @dif
end
select
@referencia = rtrim(@mov) + ' ' + ltrim(rtrim(convert(char, @movid))) + ' (' + ltrim(rtrim(convert(char, @a))) + '/' + ltrim(rtrim(convert(char, @numerodocumentos))) + ')'
if @mov = @docautofolio
select
@docmovid = rtrim(@movid) + '-' + ltrim(convert(char, @a))
else
select
@docmovid = null
exec spcalcularvencimientopp @modulo,
@empresa,
@cuenta,
@condicion,
@ppfechaemision,
@ppvencimiento output,
@ppdias output,
@ppfechaprontopa output,
@ppdescuentoprontopa output,
@tasa output,
@ok output
if @modulo = 'cxc'
begin
insert cxc (sucursal, origentipo, origen, origenid, empresa, mov, movid, fechaemision, concepto, proyecto, moneda, tipocambio, usuario, referencia, observaciones, estatus,
cliente, clientemoneda, clientetipocambio, importe, condicion, vencimiento, aplicamanual, fechaprontopa, descuentoprontopa,
clienteenviara, agente, cobrador, personalcobrador, tasa, ramaid)
values (@sucursal, @modulo, @mov, @movid, @empresa, @docmov, @docmovid, @fechaemision, @concepto, @proyecto, @moneda, @tipocambio, @usuario, @referencia, @observaciones, @docestatus, @cuenta, @moneda, @tipocambio, @importe1, '(fecha)', @vencimiento, 1, @ppfechaprontopa, @ppdescuentoprontopa, @clienteenviara, @agente, @cobrador, @personalcobrador, @tasa, @ramaid)
select
@docid = @@identity
if @importe2 > 0.0
insert cxcd (sucursal, id, renglon, aplica, aplicaid, importe)
values (@sucursal, @docid, 2048, @mov, @movid, @importe2)
if @importe3 > 0.0
insert cxcd (sucursal, id, renglon, aplica, aplicaid, importe)
values (@sucursal, @docid, 4096, @interesesmov, @interesesmovid, @importe3)
if @desglosarimpuestos = 1
begin
select
@aplicaimpuestos = nullif(sum(d.importe * c.ivafiscal * isnull(c.iepsfiscal, 1)), 0)
from cxcd d with (nolock),
cxc c with (nolock)
where d.id = @docid
and c.empresa = @empresa
and c.mov = d.aplica
and c.movid = d.aplicaid
and c.estatus = 'pendiente'
and fechaemision = @fechaemision
if @aplicaimpuestos is not null
update cxc with (rowlock)
set importe = importe - @aplicaimpuestos,
impuestos = @aplicaimpuestos
where id = @docid
end
end
else
if @modulo = 'cxp'
begin
insert cxp (sucursal, origentipo, origen, origenid, empresa, mov, movid, fechaemision, concepto, proyecto, moneda, tipocambio, usuario, referencia, observaciones, estatus,
proveedor, proveedormoneda, proveedortipocambio, importe, condicion, vencimiento, aplicamanual, fechaprontopa, descuentoprontopa, tasa, ramaid)
values (@sucursal, @modulo, @mov, @movid, @empresa, @docmov, @docmovid, @fechaemision, @concepto, @proyecto, @moneda, @tipocambio, @usuario, @referencia, @observaciones, @docestatus, @cuenta, @moneda, @tipocambio, @importe1, '(fecha)', @vencimiento, 1, @ppfechaprontopa, @ppdescuentoprontopa, @tasa, @ramaid)
select
@docid = @@identity
if @importe2 > 0.0
insert cxpd (sucursal, id, renglon, aplica, aplicaid, importe)
values (@sucursal, @docid, 2048, @mov, @movid, @importe2)
if @importe3 > 0.0
insert cxpd (sucursal, id, renglon, aplica, aplicaid, importe)
values (@sucursal, @docid, 4096, @interesesmov, @interesesmovid, @importe3)
end
if @cfgdocautoborrador = 0
exec spcx @docid,
@modulo,
'afectar',
'todo',
@fecharegistro,
null,
@usuario,
1,
0,
@docmov output,
@docmovid output,
null,
@ok output,
@okref output
if @ok is null
begin
select
@ppfechaemision = dateadd(day, 1, @vencimiento)
if isnumeric(@periodo) = 1
select
@vencimiento = dateadd(day, convert(int, @periodo) * @a, @primervencimiento)
else
if @periodo = 'semanal'
select
@vencimiento = dateadd(wk, @a, @primervencimiento)
else
if @periodo = 'mensual'
select
@vencimiento = dateadd(mm, @a, @primervencimiento)
else
if @periodo = 'bimestral'
select
@vencimiento = dateadd(mm, @a * 2, @primervencimiento)
else
if @periodo = 'trimestral'
select
@vencimiento = dateadd(mm, @a * 3, @primervencimiento)
else
if @periodo = 'semestral'
select
@vencimiento = dateadd(mm, @a * 6, @primervencimiento)
else
if @periodo = 'anual'
select
@vencimiento = dateadd(yy, @a, @primervencimiento)
else
if @periodo = 'quincenal'
begin
if @esquince = 1
select
@esquince = 0,
@vencimiento = dateadd(dd, -15, dateadd(mm, 1, @vencimiento))
else
select
@esquince = 1,
@vencimiento = dateadd(dd, 15, @vencimiento)
end
else
select
@ok = 55140
select
@a = @a + 1
end
end
if @conexion = 0
begin
if @ok is null
commit transaction
else
rollback transaction
end
end
end
else
select
@ok = 60040
if @ok is null
select
@mensaje = "proceso concluido."
else
begin
select
@mensaje = descripcion
from mensajelista with (nolock)
where mensaje = @ok
if @okref is not null
select
@mensaje = rtrim(@mensaje) + '<br><br>' + @okref
end
if @conexion = 0
select
@mensaje
return
end