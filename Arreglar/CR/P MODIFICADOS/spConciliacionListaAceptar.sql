SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionListaAceptar
@ID			int,
@Sucursal	int,
@Estacion	int

AS BEGIN
/*  DECLARE
@SaldoAnterior	money,
@Cargos		money,
@Abonos		money*/
DECLARE @CtaDinero	varchar(10)
SELECT @CtaDinero = CtaDinero FROM Conciliacion WITH (NOLOCK)  WHERE ID = @ID
INSERT ConciliacionD (
ID,  Sucursal,  Fecha,   Referencia,        Cargo,   Abono,   Manual)
SELECT @ID, @Sucursal, a.Fecha, a.Mov+' '+a.MovID, a.Abono, a.Cargo, a.ID
FROM Auxiliar a WITH (NOLOCK) 
JOIN Dinero d WITH (NOLOCK)  ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
JOIN ListaID l  WITH (NOLOCK) ON l.Estacion = @Estacion AND l.ID = a.ModuloID
WHERE a.Rama = 'DIN' AND a.Modulo = 'DIN' AND l.ID NOT IN (SELECT DISTINCT Manual FROM ConciliacionD  WITH (NOLOCK) WHERE ID = @ID)
AND a.Cuenta = @CtaDinero
/*SELECT @Cargos = SUM(Cargo), @Abonos = SUM(Abono)
FROM ConciliacionD
WHERE ID = @ID
SELECT @SaldoAnterior = SUM(s.SaldoConciliado)
FROM Conciliacion c
JOIN DineroSaldo s ON s.CtaDinero = c.CtaDinero AND s.Empresa = c.Empresa
WHERE c.ID = @ID
UPDATE Conciliacion SET SaldoAnterior = ISNULL(SaldoAnterior, @SaldoAnterior), Cargos = @Cargos, Abonos = @Abonos WHERE ID = @ID*/
RETURN
END

