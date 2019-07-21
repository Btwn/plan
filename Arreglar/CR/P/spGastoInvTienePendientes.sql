SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoInvTienePendientes
@ID			int,
@MovTipo		varchar(20),
@TienePendientesInv	bit	OUTPUT

AS BEGIN
SELECT @TienePendientesInv = 0
IF @MovTipo = 'GAS.S'
IF EXISTS(SELECT *
FROM GastoD d
JOIN InvD i ON i.ID = d.InvID AND i.Renglon = d.Renglon AND i.RenglonSub = d.RenglonSub
WHERE d.ID = @ID AND (ISNULL(i.CantidadPendiente, 0.0) > 0 OR ISNULL(i.CantidadOrdenada, 0.0) > 0.0 OR ISNULL(i.CantidadReservada, 0.0) > 0.0) )
SELECT @TienePendientesInv = 0
END

