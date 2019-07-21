SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[getBaseCalculoISR]
@idempresa			as nvarchar(20),		
@anio				as smallint,	
@mes				as tinyint,		
@idbc				as bigint,		
@idreporte			as bigint,		
@saldofin			as nvarchar(4),	
@saldoini			as nvarchar(4),	
@cargo				as nvarchar(4),	
@abono				as nvarchar(4),	
@saldomes			as nvarchar(4)	

AS
BEGIN
declare	@campo nvarchar(200)
declare @where nvarchar(200)
declare @sql nvarchar(2000)
declare @operador nvarchar(2)
declare @validaidbc as varchar(100)
set @where = ''
set @operador = '<='
if (@saldofin='1')
set @campo = '(isnull(si.SaldoInicial,0) + sum(isnull(mm.Cargo,0)) - sum(isnull(mm.Abono,0))) as importe'
else
if (@saldoini='1')
set @campo ='isnull(si.SaldoInicial,0) as importe'
else
if (@cargo='1')
set @campo ='sum(isnull(mm.Cargo,0)) as importe'
else
if (@abono='1')
set @campo='sum(isnull(mm.Abono,0)) as importe'
else
set @campo='0 as importe'
if(DATALENGTH(@saldomes)!=0)
begin
if(@saldomes='1')
set @operador='='
else
set @operador='<='
end
set @validaidbc = ''
if(@idbc<>'0')
set @validaidbc = ' and bc.ClaveBC = ' + '' + cast(@idbc as nvarchar(5)) + ''
if (@saldofin='1') or  (@saldoini='1')
BEGIN
set @sql='
select tt1.Reporte,tt1.idBaseDeCalculo,tt1.rubro, (tt1.importe * (rff.porcentajededuccion / 100.00)) importe from(
select Reporte,idBaseDeCalculo,rubro, sum(importe) importe from(
select  bc.Reporte,bct.idBaseDeCalculo,ct.rubro, ' + @campo + '
from	/*		Reportes rep
inner join  ReporteBaseCalculo rbc
on rep.Reporte=rbc.Reporte
inner join */ BasesDeCalculo bc
/*on rbc.idBaseDeCalculo=bc.idBaseDeCalculo*/
inner join  BaseCalculoRubroFiscal bct
on bc.idBaseDeCalculo=bct.idBaseDeCalculo
inner join  RubrosFiscales ct
on bct.rubro=ct.rubro
inner join CuentaRubro cr
on ct.Rubro = cr.rubro
inner join  CuentasContables cc
on cr.CuentaContable=cc.CuentaContable
left join   SaldosIni si
on cc.CuentaContable=si.CuentaContable and si.Empresa=''' + @idempresa + '''  and si.Anio=' + cast(@anio as nvarchar(4))  +'
left join   MovContables mm
on cc.CuentaContable=mm.CuentaContable and mm.Empresa=''' + @idempresa + '''  and mm.Anio=' + cast(@anio as nvarchar(4)) + ' and mm.Mes'+ @operador + cast(@mes as nvarchar(2)) +'
where  bc.Reporte=' + cast(@idreporte as nvarchar(5))  +  @validaidbc + '
/*
/*and bc.ClaveBC = ' + cast(@idbc as nvarchar(5)) + '*/
and upper(cc.clase)='''+'R'+'''
group by bc.Reporte,bct.idBaseDeCalculo,ct.rubro,si.SaldoInicial
) as t1
group by Reporte,idBaseDeCalculo,rubro
) as tt1
join rubrosfiscales rff on tt1.rubro = rff.rubro '
END
ELSE
BEGIN
set @sql='
select t1.Reporte,t1.idBaseDeCalculo,t1.rubro, (t1.importe * (rff.porcentajededuccion / 100.00)) importe from(
select  bc.Reporte,bct.idBaseDeCalculo,ct.rubro, ' + @campo + '
from	/*		Reportes rep
inner join  ReporteBaseCalculo rbc
on rep.Reporte=rbc.Reporte
inner join */ BasesDeCalculo bc
/*on rbc.idBaseDeCalculo=bc.idBaseDeCalculo*/
inner join  BaseCalculoRubroFiscal bct
on bc.idBaseDeCalculo=bct.idBaseDeCalculo
inner join  RubrosFiscales ct
on bct.rubro=ct.rubro
inner join CuentaRubro cr
on ct.Rubro = cr.rubro
inner join  CuentasContables cc
on cr.CuentaContable=cc.CuentaContable
left join   SaldosIni si
on cc.CuentaContable=si.CuentaContable and si.Empresa=''' + @idempresa + '''  and si.Anio=' + cast(@anio as nvarchar(4))  +'
left join   MovContables mm
on cc.CuentaContable=mm.CuentaContable and mm.Empresa=''' + @idempresa + '''  and mm.Anio=' + cast(@anio as nvarchar(4)) + ' and mm.Mes'+ @operador + cast(@mes as nvarchar(2)) +'
where  bc.Reporte=' + cast(@idreporte as nvarchar(5)) + @validaidbc + '
/*
/*and bc.ClaveBC = ' + cast(@idbc as nvarchar(5)) + '*/
and upper(cc.clase)='''+'R'+'''
group by bc.Reporte,bct.idBaseDeCalculo,ct.rubro
) as t1
join rubrosfiscales rff on t1.rubro = rff.rubro
order by t1.Reporte,t1.idBaseDeCalculo,t1.rubro'
END
begin try
exec(@sql)
end try
begin catch
SELECT
ERROR_NUMBER() AS Numero_de_Error,
ERROR_SEVERITY() AS Gravedad_del_Error,
ERROR_STATE() AS Estado_del_Error,
ERROR_PROCEDURE() AS Procedimiento_del_Error,
ERROR_LINE() AS Linea_de_Error,
ERROR_MESSAGE() AS Mensaje_de_Error;
end catch
END

