SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW EmbarqueMovOC

AS
SELECT EmbarqueMov.*,
"CxcVencimiento"      = Cxc.Vencimiento,
"CxcSaldo"            = Cxc.Saldo,
"CxcPersonalCobrador" = Cxc.PersonalCobrador,
"CxcSituacion"        = Cxc.Situacion,
"CxcSituacionFecha"   = Cxc.SituacionFecha,
"CxcSituacionUsuario" = Cxc.SituacionUsuario,
"CxcSituacionNota"    = Cxc.SituacionNota
FROM EmbarqueMov
JOIN Cxc ON EmbarqueMov.ModuloID = Cxc.ID AND EmbarqueMov.Modulo='CXC'

