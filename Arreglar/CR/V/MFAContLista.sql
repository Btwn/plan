SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAContLista AS
SELECT
Empresa,
'CONT' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Cont
WHERE Estatus IN ('CONCLUIDO')

