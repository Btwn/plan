SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER  VIEW dbo.xcrm_ctecat

AS
select distinct rtrim(Replace(a.categoria,char(13)+char(10),'')) categoria,min(a.UltimoCambio) crmlastupdate,NULL crmobjectid from cte a
left join ctecat c on( rtrim(Replace(a.categoria,char(13)+char(10),''))=rtrim(Replace(c.categoria,char(13)+char(10),'')))
where a.categoria is not null and c.categoria is null and a.categoria<>''
group by a.categoria
union
select distinct rtrim(Replace(categoria,char(13)+char(10),'')) ,crmlastupdate ,crmobjectid from ctecat where categoria<>''

