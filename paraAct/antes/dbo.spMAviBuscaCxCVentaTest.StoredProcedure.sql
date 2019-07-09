create procedure [dbo].[spmavibuscacxcventatest]
@movidcxc varchar(20),
@movcxc varchar(20),
@idmovresul varchar(20) output,
@movresul varchar(20) output,
@idorigen int output
as begin
declare
@tipo varchar(20),
@idnvo varchar(20),
@idmovnvo varchar(20),
@idmovnvo2 varchar(20),
@movtiponvo varchar(20),
@idorigennvo int,
@idcxc int,
@aplica varchar(20),
@aplicaid varchar(20),
@iddetalle varchar(20),
@contador int ,
@contadord int,
@concepto varchar(50),
@cveafecta varchar(20)
select @tipo = 'cxc', @idnvo = @movidcxc, @idmovnvo= @movcxc, @contador = 0, @contadord = 0, @movtiponvo = ''
select @idcxc = id, @concepto = concepto from cxc where mov = @movcxc and movid = @movidcxc
select @cveafecta = clave from movtipo where modulo = 'cxc' and mov = @movcxc
if @cveafecta = 'cxc.ca' and @concepto = 'monedero electronico'
select @idmovresul=@movidcxc, @movresul=@movcxc, @idorigen= @idcxc
else
begin
while @movtiponvo not in('vtas.f','cxc.est') and @contador < 10
begin
select @tipo=omodulo, @idmovnvo=omov, @idnvo=(omovid),@idorigennvo=isnull(mf.oid,0), @movtiponvo = mt.clave
from movflujo mf , movtipo mt where mf.omov=mt.mov
and mf.dmov = @idmovnvo and mf.dmovid = @idnvo and dmodulo = 'cxc'
order by omovid desc
if @movtiponvo = 'cxc.est'
begin
select @idorigennvo = oid,@idnvo = omovid,@idmovnvo = omov
from movflujo mf , movtipo mt where mf.omov=mt.mov
and mf.dmov = @movcxc and mf.dmovid = @movidcxc and dmodulo = 'cxc'
order by omovid desc
end
select @contador = @contador + 1
end
if @contador > 10 select @idnvo = null, @idmovnvo = null, @idorigennvo = 0
select @aplica = aplica, @aplicaid = aplicaid from cxcd where id = @idorigen
if not @aplicaid is null
begin
declare crcxccte cursor for
select id from cxc where mov = @aplica and movid = @aplicaid
open crcxccte
fetch next from crcxccte into @idmovnvo2
while @movtiponvo <> 'vtas.f' and @contadord < 10
begin
select @tipo=omodulo, @idmovnvo=omov, @idnvo=(omovid),@idorigennvo=mf.oid, @movtiponvo = mt.clave
from movflujo mf , movtipo mt where mf.omov = mt.mov
and mf.dmov = @idmovnvo2 and mf.dmovid = @idnvo and dmodulo = 'cxc'
order by omovid desc
select @contadord = @contadord + 1
fetch next from crcxccte into @idmovnvo2
end
close crcxccte
deallocate crcxccte
end
select @idmovresul=@idnvo, @movresul=@idmovnvo, @idorigen= @idorigennvo
return
end
end