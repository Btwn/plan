SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW [dbo].[xcrm_artgrupo]

AS
select distinct rtrim(Replace(a.grupo,char(13)+char(10),'')) grupo,min(a.UltimoCambio) crmlastupdate,NULL crmobjectid from art a WITH (NOLOCK)
left join artgrupo c WITH (NOLOCK) on( rtrim(Replace(a.grupo,char(13)+char(10),''))=rtrim(Replace(c.grupo,char(13)+char(10),'')))
where a.grupo is not null and c.grupo is null and a.grupo<>''
group by a.grupo
union
select distinct rtrim(Replace(grupo,char(13)+char(10),'')),crmlastupdate ,crmobjectid from artgrupo WITH (NOLOCK) where grupo<>''

GO
