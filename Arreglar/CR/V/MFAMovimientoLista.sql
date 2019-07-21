SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAMovimientoLista AS
SELECT
Empresa,
'VTAS' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Venta
WHERE Estatus IN ('CONCLUIDO','PENDIENTE')
UNION ALL
SELECT
Empresa,
'COMS' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Compra
WHERE Estatus IN ('CONCLUIDO','PENDIENTE')
UNION ALL
SELECT
Empresa,
'GAS' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Gasto
WHERE Estatus IN ('CONCLUIDO','PENDIENTE')
UNION ALL
SELECT
Empresa,
'CXP' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Cxp
WHERE Estatus IN ('CONCLUIDO','PENDIENTE')
UNION ALL
SELECT
Empresa,
'CXC' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Cxc
WHERE Estatus IN ('CONCLUIDO','PENDIENTE')
UNION ALL
SELECT
Empresa,
'CR' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM CR
WHERE Estatus IN ('CONCLUIDO')
UNION ALL
SELECT
Empresa,
'DIN' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Dinero
WHERE Estatus IN ('PENDIENTE', 'CONCLUIDO')
UNION ALL
SELECT
Empresa,
'NOM' Modulo,
ID,
Mov,
MovID,
Ejercicio,
Periodo,
RTRIM(Mov) + ' ' + RTRIM(MovID) 'Movimiento'
FROM Nomina
WHERE Estatus IN ('CONCLUIDO')

