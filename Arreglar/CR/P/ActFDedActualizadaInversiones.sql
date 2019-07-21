SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[ActFDedActualizadaInversiones]
@Empresa varchar(5),
@Ejercicio as    smallint,
@Periodo as smallint
 
AS BEGIN
DECLARE	@Porcentajededuccion as int,
@MesesUso as int,
@fecha_ope as varchar(10),
@SQL as nvarchar(max);
SET @fecha_ope=cast(@Ejercicio as nvarchar(4))+REPLACE(STR(@Periodo,2),SPACE(1),'0')+'01';
SET @SQL=N'';
SET @SQL = 'SELECT aTipos.Descripcion as Tipo,Vista2.*,
CASE WHEN ROUND(INPCNum/NULLIF(INPCDenom,0),4,1) < 1 THEN 1 ELSE  ROUND(INPCNum/NULLIF(INPCDenom,0),4,1) END  as ''Fact_Act'',
CAST(Deduccion * CASE WHEN CAST(INPCNum/NULLIF(INPCDenom,0) AS decimal(18,4)) < 1 THEN 1 ELSE CAST(INPCNum/NULLIF(INPCDenom,0) AS decimal(18,4)) END AS Decimal(18,2)) as ''DedActDelEje''
FROM (
SELECT	Vista1.*,
CASE WHEN DepFiscalAct >= MOI THEN 0 ELSE CAST(dbo.fgetDeduccion(MOI,pDeduccion,mesesUso)  AS Decimal(18,2)) END AS ''Deduccion'',
CAST(dbo.fgetINPC_Num('+CAST(@Ejercicio as varchar(4))+', ' + CAST(@Periodo AS nvarchar(2)) + ',mesesUso,FechaIniUso) AS Decimal(18,4))AS ''INPCNum'',
CAST(dbo.fgetINPC_Denom(FechaAdqui)  AS Decimal(18,4)) as ''INPCDenom''
FROM
(SELECT	Empresa,
sucursal,
TipoActivo,
Clave,
Descripcion as Concepto,
CASE CAST(Estatus AS varchar(1)) WHEN ''1'' THEN ''Activo''
WHEN ''0'' THEN ''Inactivo'' ELSE Estatus END as ''Estatus'',
FechaAdqui,
FechaIniUso,
CASE WHEN MontoOrig >=MontoFisAuto and EsAuto=1 THEN
MontoFisAuto
ELSE
MontoOrig
END AS ''MOI'',
DepFiscal as ''pDeduccion'',
DepFiscalAct,
CASE WHEN DATEPART(YEAR,FechaIniUso) = DATEPART(YEAR,CAST(''' + @fecha_ope + ''' as DATE)) AND DATEPART(MONTH,FechaIniUso) <= DATEPART(MONTH,CAST(''' + @fecha_ope + ''' as DATE)) THEN
DATEDIFF(MONTH,FechaIniUso,CAST(''' + @fecha_ope + ''' as DATE)) + 1
WHEN DATEPART(YEAR,FechaIniUso) < DATEPART(YEAR,CAST(''' + @fecha_ope + ''' as DATE)) THEN
DATEDIFF(MONTH,CAST(''01/01/' + CAST(@Ejercicio as nvarchar(4)) + ''' as DATE) ,CAST(''' + @fecha_ope + ''' as DATE)) + 1
ELSE 0 END AS ''mesesUso''
FROM dbo.ActivosF WHERE TipoActivo<>8 AND TipoActivo<>9 AND Empresa = '''+@Empresa+'''
) AS Vista1
) AS Vista2 INNER JOIN dbo.ActivosFTipos aTipos
ON Vista2.TipoActivo = aTipos.Tipo ORDER BY aTipos.Tipo,Clave'
EXEC sp_executesql @SQL;
END

