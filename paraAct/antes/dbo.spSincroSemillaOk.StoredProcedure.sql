create procedure [dbo].[spsincrosemillaok]
@modulovarchar(5),
@idint,
@movvarchar(20),
@okintoutput,
@okrefvarchar(255)output
as begin
declare
@delint,
@alint,
@sucursalprincipalint,
@validarsincrosemillabit,
@seguimientovarchar(20),
@origentipovarchar(10)
select @validarsincrosemilla = validarsincrosemilla, @sucursalprincipal = sucursal from version if @validarsincrosemilla = 1
begin
if @sucursalprincipal = 0 select @del = 0 else select @del = 50000000 + (@sucursalprincipal * 7000000)
select @al = 50000000 + (( @sucursalprincipal + 1) * 7000000)
if not (@id between @del and @al-1)
begin
exec spsucursalmovseguimiento @sucursalprincipal, @modulo, @mov, @seguimiento output
if not (@seguimiento = 'matriz' and @sucursalprincipal = 0)
begin
exec spmovinfo @id, @modulo, @origentipo = @origentipo output
if @origentipo <> 'e/collab'
select @ok = 72070, @okref = convert(varchar, @id)
end
end
end
end