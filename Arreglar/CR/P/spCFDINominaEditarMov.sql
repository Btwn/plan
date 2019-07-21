SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaEditarMov
@Estacion		int,
@Empresa	varchar(10),
@Usuario	varchar(20)

AS
BEGIN
DELETE CFDINominaDatosMov WHERE Estacion = @Estacion
IF EXISTS(SELECT l.ID FROM ListaModuloID l JOIN Nomina n ON l.ID = n.ID  JOIN CFDINominaMov m ON n.Mov = m.Mov WHERE l.Estacion = @Estacion)
BEGIN
IF NOT EXISTS( SELECT ID FROM CFDINominaDatosMov WHERE Estacion = @Estacion)
INSERT CFDINominaDatosMov (ID, Estacion)
SELECT l.ID, l.Estacion
FROM ListaModuloID l
JOIN Nomina n ON l.ID = n.ID
JOIN CFDINominaMov m ON n.Mov = m.Mov
WHERE l.Estacion = @Estacion
END
END

