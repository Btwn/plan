SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.xcrm_fabricante

AS
select distinct rtrim(Replace(a.fabricante,char(13)+char(10),'')) fabricante,min(a.UltimoCambio) crmlastupdate,NULL crmobjectid  from art a
left join fabricante c on( rtrim(Replace(a.fabricante,char(13)+char(10),''))=rtrim(Replace(c.fabricante,char(13)+char(10),'')))
where a.fabricante  is not null and c.fabricante is null and a.fabricante<>''
group by a.fabricante
union
select distinct rtrim(Replace(fabricante,char(13)+char(10),'')) fabricante,crmlastupdate ,crmobjectid from fabricante where fabricante<>''

