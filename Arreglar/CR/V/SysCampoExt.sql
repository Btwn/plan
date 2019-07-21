SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SysCampoExt

AS
SELECT 'Tabla' = tablas.name,
'Campo' = columnas.name,
'Orden' = columnas.ColID,
'TipoDatos' = tipos.name,
'Ancho' = columnas.length,
'Precision' = columnas.prec,
'Escala' = columnas.scale,
'AceptaNulos' = isnullable,
'EsIdentity' = convert(bit, CASE WHEN columnas.status = 128 THEN 1 ELSE 0 END),
'EsCalculado' = columnas.iscomputed,
'Collation' = columnas.Collation,
'Tipo' = tablas.type
FROM syscolumns columnas
JOIN systypes tipos ON tipos.xtype = columnas.xtype
JOIN sysobjects tablas ON columnas.ID = tablas.ID

