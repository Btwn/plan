SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.xcrm_artlinea

AS
select distinct rtrim(Replace(a.linea,char(13)+char(10),'')) linea,min(a.UltimoCambio) crmlastupdate,NULL crmobjectid from art a
left join artLinea c on( rtrim(Replace(a.linea,char(13)+char(10),''))=rtrim(Replace(c.linea,char(13)+char(10),'')))
where a.linea  is not null and c.linea is null and a.linea<>''
group by a.linea
union
select distinct rtrim(Replace(linea,char(13)+char(10),'')) linea,crmlastupdate ,crmobjectid from artlinea where linea<>''

