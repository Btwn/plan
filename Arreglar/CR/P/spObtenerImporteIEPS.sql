SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spObtenerImporteIEPS]
@reporte int,
@linea int,
@ejercicio int,
@periodo int,
@empresa varchar(5),
@campo varchar(15) = 'importe'

AS
BEGIN
DECLARE @sql varchar(1000)
set @sql='select SUM(ISNULL('+@campo+',0)) importe
from datosieps
where LOWER(tipo_movimiento) in
(
select mov from Reporlinea_TiposMov where idreplinea = '+ ltrim(str(@linea))+
')
and categoria_concepto in
(
select idclasificacion from Reporlinea_Art_Clasifica where idreplinea = '+ ltrim(str(@linea))+
')
and num_reporte = '+ltrim(str(@reporte))+
' and ejercicio = '+ltrim(str(@ejercicio))+
' and periodo = '+ltrim(str(@periodo))+
' and empresa = '+''''+@empresa+''''
exec (@sql)
END

