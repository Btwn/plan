SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE ActFDedAcumuladaInversiones
@Empresa varchar(5),
@Ejercicio as smallint,
@Periodo as smallint

AS BEGIN
DECLARE	@Porcentajededuccion as int,
@MesesUso as int,
@fecha_ope as varchar(10),
@SQL as Nvarchar(max)
SET @fecha_ope=cast(@Ejercicio - 1 as nvarchar(4))+'1201';
SET @SQL=N'';
SET @SQL = 'SELECT aTipos.Descripcion as Tipo,Vista1.*,
CASE WHEN CAST(dbo.fgetDeduccion(MOI,pDeduccion,mesesUso)  AS Decimal(18,2)) >= MOI THEN MOI ELSE CAST(dbo.fgetDeduccion(MOI,pDeduccion,mesesUso)  AS Decimal(18,2)) END as ''DeduccionAcumulada''
FROM (
SELECT	Empresa,
sucursal,
TipoActivo,
Clave,
Descripcion as Concepto,
CASE Estatus WHEN ''1'' THEN ''Activo''
WHEN ''0'' THEN ''Inactivo'' ELSE Estatus END AS ''Estatus'',
FechaAdqui,
FechaIniUso,
CASE WHEN MontoOrig >=MontoFisAuto and EsAuto=1 THEN
MontoFisAuto
ELSE
MontoOrig
END AS ''MOI'',
DepFiscal as ''pDeduccion'',
DATEDIFF(MONTH,FechaIniUso ,CAST(''' + @fecha_ope + ''' as DATE)) + 1 AS ''mesesUso''
FROM	dbo.ActivosF WHERE TipoActivo<>8 AND TipoActivo<>9 AND Empresa = '''+@Empresa+'''
) AS Vista1
INNER JOIN dbo.ActivosFTipos aTipos
ON Vista1.TipoActivo = aTipos.Tipo ORDER BY aTipos.Tipo,Clave
'
Exec sp_ExecuteSql @SQL;
END

