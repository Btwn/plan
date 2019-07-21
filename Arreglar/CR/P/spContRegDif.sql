SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContRegDif
@Estacion	int,
@Empresa	char(5)

AS BEGIN
create table #c (id int primary key, importe money null)
create table #r (id int primary key, importe money null)
DELETE FROM ContRegDif WHERE Estacion=@Estacion 
insert #c (id, importe)
select c.id, sum(d.debe)
from Cont c
join contd d on d.id = c.id
join MovTipo mt ON mt.Modulo = 'CONT' AND mt.Mov = c.Mov
where c.estatus = 'CONCLUIDO' and c.empresa = @Empresa AND mt.Clave IN ('CONT.P', 'CONT.C')
group by c.id
insert #r (id, importe)
select c.id, sum(debe)
from Cont c
join MovTipo mt ON mt.Modulo = 'CONT' AND mt.Mov = c.Mov
join contreg r on r.id = c.id
where c.estatus = 'CONCLUIDO' and c.empresa = @Empresa AND mt.Clave IN ('CONT.P', 'CONT.C')
group by c.id
insert ContRegDif (Estacion, ID, ContImporte, RegImporte)
select @Estacion, c.id, c.importe, r.Importe
from #c c
left outer join #r r on r.id = c.id
where isnull(c.importe, 0.0) <> isnull(r.importe, 0.0)
END

