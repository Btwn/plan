SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER  VIEW dbo.xcrm_ctefam

AS
select rtrim(Replace(a.familia,char(13)+char(10),'')) familia,min(a.UltimoCambio) crmlastupdate,NULL crmobjectid from cte a
left join ctefam c on( rtrim(Replace(a.familia,char(13)+char(10),''))=rtrim(Replace(c.familia,char(13)+char(10),'')))
where a.familia is not null and a.familia<>'' and c.familia is null
group by a.familia
union
select distinct rtrim(Replace(familia,char(13)+char(10),'')) familia,crmlastupdate ,crmobjectid from ctefam where familia<>''

