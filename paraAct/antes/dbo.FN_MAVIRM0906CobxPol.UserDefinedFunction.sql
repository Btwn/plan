create function [dbo].[fn_mavirm0906cobxpol] (@id int)
returns varchar(10)
as
begin
declare @cob varchar(10),
@dv int,
@di int,
@dvec int,
@dinac int,
@secc varchar(50),
@cliente varchar(10),
@quincena int,
@year int = year(getdate())
select
@cliente = c.cliente,
@secc = isnull(ce.seccioncobranzamavi, ''),
@dvec = isnull(cm.diasvencactmavi, 0),
@dinac = isnull(cm.diasinacactmavi, 0)
from cxcmavi cm with (nolock)
join cxc c with (nolock)
on c.id = cm.id
join tablastd t with (nolock)
on t.tablast = 'movimientos cobro x politica'
and t.nombre = c.mov
left join cteenviara ce with (nolock)
on ce.id = c.clienteenviara
and ce.cliente = c.cliente
where cm.id = @id
if isnull(@cliente, '') != ''
and isnull(@secc, '') != 'instituciones'
and (isnull(@dvec, 0) > 0
or isnull(@dinac, 0) > 0)
begin
set @quincena =
case
when day(getdate()) > 16 then month(getdate()) * 2
else (month(getdate()) * 2) - 1
end
set @quincena =
case
when day(getdate()) = 1 then @quincena - 1
else @quincena
end
select
@year =
case
when day(getdate()) = 1 and
month(getdate()) = 1 then @year - 1
else @year
end,
@quincena =
case
when day(getdate()) = 1 and
month(getdate()) = 1 then 24
else @quincena
end
select top 1
@dv = isnull(con.dv, 0),
@di = isnull(con.di, 0)
from tcirm0906_configdivisionyparam con with (nolock)
join mavirecuperacion ma with (nolock)
on isnull(con.division, '') = isnull(ma.division, '')
and ma.quincena = @quincena
and ma.ejercicio = @year
and ma.cliente = @cliente
select
@dv = isnull(@dv, 0),
@di = isnull(@di, 0),
@dvec = isnull(@dvec, 0),
@dinac = isnull(@dinac, 0)
set @cob =
case
when ((@dvec >= @dv and
@dv <> 0) or
(@dinac >= @di and
@di <> 0)) then 'si'
else 'no'
end
end
set @cob = isnull(@cob, 'no')
return @cob
end