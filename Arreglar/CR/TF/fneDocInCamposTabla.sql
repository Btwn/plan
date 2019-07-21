SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInCamposTabla (@Tabla varchar(50))
RETURNS @Resultado TABLE (Campo  varchar(100), TipoDatos varchar(50))

AS BEGIN
INSERT @Resultado(Campo, TipoDatos)
SELECT           Campo, dbo.fneDocInTipoCampo(TipoDatos)
FROM SysCampoExt
WHERE  Tabla = @Tabla AND EsIdentity = 0 AND EsCalculado = 0 AND AceptaNulos = 0
AND Campo NOT IN (SELECT name FROM syscolumns WHERE id = object_id(@Tabla) AND cdefault > 0)
ORDER BY Orden
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'Estatus') AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'Estatus' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'Estatus', 'TEXTO'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'Usuario') AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'Usuario' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'Usuario', 'TEXTO'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'FechaEmision')AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'FechaEmision' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'FechaEmision', 'FECHA'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'Almacen')AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'Almacen' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'Almacen', 'TEXTO'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'TipoCambio')AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'TipoCambio' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'TipoCambio', 'NUMERICO'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'TipoCambio')AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'TipoCambio' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'TipoCambio', 'NUMERICO'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'RenglonID')AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'RenglonID' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'RenglonID', 'NUMERICO'
IF NOT EXISTS(SELECT Campo FROM @Resultado WHERE Campo = 'RenglonSub')AND EXISTS(SELECT  Campo   FROM SysCampoExt WHERE Campo = 'RenglonSub' AND Tabla = @Tabla)
INSERT @Resultado(Campo, TipoDatos)
SELECT            'RenglonSub', 'NUMERICO'
RETURN
END

