create procedure [dbo].[spcambiarsituacion]
@modulochar(5),
@idint,
@situacionchar(50),
@situacionfechadatetime,
@usuariochar(10),
@situacionusuariovarchar(10) = null,
@situacionnotavarchar(100) = null
as begin
set nocount on
declare
@fechacomenzo datetime
begin transaction
if @modulo = 'cont' update cont with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'vtas' update venta with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'prod' update prod with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'coms' update compra with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'inv' update inv with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'cxc' update cxc with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'cxp' update cxp with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'agent' update agent with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'gas' update gasto with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'din' update dinero with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'emb' update embarque with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'nom' update nomina with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'rh' update rh with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'asis' update asiste with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'af' update activofijo with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'pc' update pc with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'ofer' update oferta with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'vale' update vale with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'cr' update cr with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'st' update soporte with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'cap' update capital with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'inc' update incidencia with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'conc' update conciliacion with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'ppto' update presup with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'credi' update credito with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'wms' update wms with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'rss' update rss with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'cmp' update campana with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'fis' update fiscal with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'frm' update formaextra with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'proy' update proyecto with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id else
if @modulo = 'cam' update cambio with (rowlock) set situacion = nullif(rtrim(@situacion), ''), situacionfecha = @situacionfecha, situacionusuario = @situacionusuario, situacionnota = @situacionnota where id = @id
select @fechacomenzo = null
select @fechacomenzo = max(fechacomenzo) from movtiempo with (nolock) where modulo = @modulo and id = @id and situacion = @situacion
if @fechacomenzo is not null
update movtiempo with (rowlock) set usuario = @usuario where modulo = @modulo and id = @id and fechacomenzo = @fechacomenzo and situacion = @situacion
commit transaction
return
set nocount off
end