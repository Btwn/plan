create procedure [dbo].[spventactedaceptar] @sucursal int,
@estacion int,
@ventaid int,
@movtipo char(20),
@copiaraplicacion bit = 0,
@copiaridventa int = 0
as
begin
declare @empresa char(5),
@id int,
@mov char(20),
@movid varchar(20),
@movreferencia varchar(50),
@tieneal bit,
@directo bit,
@cliente char(10),
@renglon float,
@renglonid int,
@ventadrenglon float,
@ventadrenglonid int,
@ventadrenglonsub int,
@renglontipo char(1),
@zonaimpuesto varchar(30),
@cantidad float,
@cantidadinventario float,
@almacen char(10),
@codi varchar(50),
@articulo char(20),
@subcuenta varchar(50),
@unidad varchar(50),
@precio money,
@descuentotipo char(1),
@descuentolinea money,
@impuesto1 float,
@impuesto2 float,
@impuesto3 money,
@descripcionextra varchar(100),
@costo money,
@contuso varchar(20),
@aplica char(20),
@aplicaid char(20),
@agente char(10),
@agented char(10),
@descuento varchar(30),
@descuentoglobal float,
@formapatipo varchar(50),
@sobreprecio float,
@arttipo varchar(20),
@departamento int,
@departamentod int,
@descuentoimporte money,
@cfgserieslotesautoorden char(20),
@financiamiento float,
@importevd money,
@puntos money
select
@tieneal = 0,
@renglonid = 0
select
@renglon = isnull(max(renglon), 0)
from ventad with (nolock)
where id = @ventaid
select
@empresa = empresa,
@cliente = cliente,
@directo = directo,
@renglonid = isnull(renglonid, 0)
from venta with (nolock)
where id = @ventaid
select
@zonaimpuesto = zonaimpuesto
from cte with (nolock)
where cliente = @cliente
select
@cfgserieslotesautoorden = isnull(upper(rtrim(serieslotesautoorden)), 'no')
from empresacfg with (nolock)
where empresa = @empresa
begin transaction
declare crventacted cursor for
select
d.financiamiento,
l.id,
l.cantidada,
(l.cantidada * d.cantidadinventario / isnull(nullif(d.cantidad, 0.0), 1.0)),
d.renglon,
d.renglonsub,
d.renglonid,
renglontipo,
almacen,
codi,
articulo,
subcuenta,
unidad,
precio,
descuentotipo,
descuentolinea,
descuentoimporte,
impuesto1,
impuesto2,
impuesto3,
costo,
contuso,
aplica,
aplicaid,
agente,
departamento,
d.puntos
from ventad d with (nolock),
ventactedlista l with (nolock)
where l.estacion = @estacion
and isnull(l.cantidada, 0.0) > 0
and d.id = l.id
and d.renglon = l.renglon
and d.renglonsub = l.renglonsub
order by l.id, l.renglon, l.renglonsub
open crventacted
fetch next from crventacted into @financiamiento, @id, @cantidad, @cantidadinventario, @ventadrenglon, @ventadrenglonsub, @ventadrenglonid, @renglontipo, @almacen,
@codi, @articulo, @subcuenta, @unidad, @precio, @descuentotipo, @descuentolinea, @descuentoimporte, @impuesto1, @impuesto2,
@impuesto3, @costo, @contuso, @aplica, @aplicaid, @agented, @departamentod, @puntos
while @@fetch_status <> -1
begin
if @@fetch_status <> -2
begin
if @tieneal = 0
begin
select
@tieneal = 1
select
@empresa = empresa,
@mov = mov,
@movid = movid,
@movreferencia = nullif(rtrim(referencia), ''),
@agente = agente,
@descuento = descuento,
@descuentoglobal = descuentoglobal,
@formapatipo = formapatipo,
@sobreprecio = sobreprecio,
@departamento = departamento
from venta with (nolock)
where id = @id
if exists (select
*
from politicasmonederoaplicadasmavi with (nolock)
where empresa = @empresa
and modulo = 'vtas'
and id = @ventaid)
delete from politicasmonederoaplicadasmavi
where empresa = @empresa
and modulo = 'vtas'
and id = @ventaid
if exists (select
*
from ventactedlista vl with (nolock)
where id = @id
and isnull(vl.cantidada, 0.0) > 0)
insert politicasmonederoaplicadasmavi (empresa, modulo, id, renglon, articulo, idpolitica)
select
v.empresa,
'vtas',
@ventaid,
d.renglon,
d.articulo,
(d.puntos / d.cantidad) * isnull(vl.cantidada, 0.0)
from venta v with (nolock)
join ventad d with (nolock)
on v.id = d.id
join ventactedlista vl with (nolock)
on d.renglon = vl.renglon
and isnull(vl.cantidada, 0.0) > 0
and vl.id = @id
where v.id = @id
if exists (select
*
from tarjetaseriemovmavi with (nolock)
where empresa = @empresa
and modulo = 'vtas'
and id = @ventaid)
delete from tarjetaseriemovmavi
where empresa = @empresa
and modulo = 'vtas'
and id = @ventaid
if exists (select
*
from tarjetaseriemovmavi with (nolock)
where empresa = @empresa
and modulo = 'vtas'
and id = @id)
insert tarjetaseriemovmavi (empresa, modulo, id, serie, importe, sucursal)
select
empresa,
modulo,
@ventaid,
serie,
importe,
sucursal
from tarjetaseriemovmavi with (nolock)
where empresa = @empresa
and modulo = 'vtas'
and id = @id
end
select
@puntos = idpolitica
from politicasmonederoaplicadasmavi with (nolock)
where empresa = @empresa
and modulo = 'vtas'
and id = @ventaid
and renglon = @ventadrenglon
exec spzonaimp @zonaimpuesto,
@impuesto1 output
exec spzonaimp @zonaimpuesto,
@impuesto2 output
select
@renglon = @renglon + 2048,
@renglonid = @renglonid + 1
if @movtipo not in ('vtas.d', 'vtas.df', 'vtas.sd', 'vtas.dfc')
select
@costo = null
if @copiaraplicacion = 0
select
@aplica = null,
@aplicaid = null
if @aplica is not null
select
@directo = 0
if (@copiaridventa = 1)
begin
if not exists (select
*
from ventad with (nolock)
where id = @ventaid
and articulo = @articulo)
begin
insert ventad (financiamiento, idcopiamavi, sucursal, id, renglon, renglonsub, renglonid, renglontipo, almacen, codi, articulo, subcuenta, unidad, cantidad, cantidadinventario, precio, descuentotipo, descuentolinea, descuentoimporte,
impuesto1, impuesto2, impuesto3, costo, contuso, aplica, aplicaid, agente, departamento, puntos)
values (@financiamiento, @id, @sucursal, @ventaid, @renglon, 0, @renglonid, @renglontipo, @almacen, @codi, @articulo, @subcuenta, @unidad, @cantidad, @cantidadinventario, @precio, @descuentotipo, @descuentolinea, @descuentoimporte, @impuesto1, @impuesto2, @impuesto3, @costo, @contuso, @aplica, @aplicaid, @agented, @departamentod, @puntos)
end
else
begin
update ventad with (rowlock)
set puntos = @puntos
where articulo = @articulo and id=@ventaid
end
end
else
begin
insert ventad (financiamiento, idcopiamavi, sucursal, id, renglon, renglonsub, renglonid, renglontipo, almacen, codi, articulo, subcuenta, unidad, cantidad, cantidadinventario, precio, descuentotipo, descuentolinea, descuentoimporte,
impuesto1, impuesto2, impuesto3, costo, contuso, aplica, aplicaid, agente, departamento, puntos)
values (@financiamiento, @id, @sucursal, @ventaid, @renglon, 0, @renglonid, @renglontipo, @almacen, @codi, @articulo, @subcuenta, @unidad, @cantidad, @cantidadinventario, @precio, @descuentotipo, @descuentolinea, @descuentoimporte, @impuesto1, @impuesto2, @impuesto3, @costo, @contuso, @aplica, @aplicaid, @agented, @departamentod, @puntos)
end
exec sparttipo @renglontipo,
@arttipo output
if @arttipo in ('serie', 'lote', 'vin', 'partida')
exec spventactedserielote @empresa,
@sucursal,
@cfgserieslotesautoorden,
@id,
@ventadrenglonid,
@renglonid,
@ventaid,
@articulo,
@subcuenta,
@cantidad
if (@copiaridventa = 0)
begin
if @arttipo = 'jue'
exec spventactedcomponentes @sucursal,
@id,
@ventadrenglon,
@ventadrenglonsub,
@cantidad,
@movtipo,
@ventaid,
@almacen,
@renglon,
@renglonid,
@copiaraplicacion,
@empresa,
@cfgserieslotesautoorden
end
end
fetch next from crventacted into @financiamiento, @id, @cantidad, @cantidadinventario, @ventadrenglon, @ventadrenglonsub, @ventadrenglonid, @renglontipo, @almacen, @codi, @articulo, @subcuenta, @unidad, @precio, @descuentotipo, @descuentolinea, @descuentoimporte, @impuesto1, @impuesto2, @impuesto3, @costo, @contuso, @aplica, @aplicaid, @agented, @departamentod, @puntos
end
close crventacted
deallocate crventacted
if @tieneal = 1
begin
if @movreferencia is null
select
@movreferencia = rtrim(@mov) + ' ' + rtrim(@movid)
update venta with (rowlock)
set referencia = @movreferencia,
directo = @directo,
agente = @agente,
descuento = @descuento,
descuentoglobal = @descuentoglobal,
formapatipo = @formapatipo,
sobreprecio = @sobreprecio,
renglonid = @renglonid,
departamento = @departamento
where id = @ventaid
end
delete ventactedlista
where estacion = @estacion
commit transaction
end