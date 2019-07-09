create procedure [dbo].[spmovcopiaranexos] @sucursal int,
@omodulo char(5),
@oid int,
@dmodulo char(5),
@did int,
@copiarbitacora bit = 0
as
begin
if @omodulo is not null
and @oid is not null
and @dmodulo is not null
and @did is not null
begin
insert anexomov (sucursal, rama, id, nombre, direccion, icono, tipo, orden, comentario)
select
@sucursal,
@dmodulo,
@did,
nombre,
direccion,
icono,
tipo,
orden,
comentario
from anexomov with (nolock)
where rama = @omodulo
and id = @oid
and nombre <> 'comprobante fiscal digital'
if @omodulo in ('vtas', 'inv', 'coms', 'prod')
and @dmodulo in ('vtas', 'inv', 'coms', 'prod')
insert anexomovd (sucursal, rama, id, cuenta, nombre, direccion, icono, tipo, orden, comentario)
select
@sucursal,
@dmodulo,
@did,
cuenta,
nombre,
direccion,
icono,
tipo,
orden,
comentario
from anexomovd with (nolock)
where rama = @omodulo
and id = @oid
if @copiarbitacora = 1
insert movbitacora (sucursal, modulo, id, fecha, evento, usuario)
select
@sucursal,
@dmodulo,
@did,
fecha,
evento,
usuario
from movbitacora with (nolock)
where modulo = @omodulo
and id = @oid
if @omodulo = 'vtas'
and @dmodulo = 'vtas'
begin
insert ventadagente (id, renglon, renglonsub, agente, fecha, horad, horaa, minutos, actividad, estado, comentarios, cantidadestandar, costoactividad, fechaconclusion)
select
@did,
renglon,
renglonsub,
agente,
fecha,
horad,
horaa,
minutos,
actividad,
estado,
comentarios,
cantidadestandar,
costoactividad,
fechaconclusion
from ventadagente with (nolock)
where id = @oid
insert ventaentrega (id, sucursal, embarque, embarquefecha, embarquereferencia, recibo, recibofecha, reciboreferencia,
direccion, direccionnumero, direccionnumeroint, codipostal, delegacion, colonia, poblacion, estado, telefono, telefonomovil)
select
@did,
@sucursal,
embarque,
embarquefecha,
embarquereferencia,
recibo,
recibofecha,
reciboreferencia,
direccion,
direccionnumero,
direccionnumeroint,
codipostal,
delegacion,
colonia,
poblacion,
estado,
telefono,
telefonomovil
from ventaentrega with (nolock)
where id = @oid
insert into ventavalemavi (id, vale)
select
@did,
vv.vale
from ventavalemavi vv with (nolock)
where id = @oid
end
end
end