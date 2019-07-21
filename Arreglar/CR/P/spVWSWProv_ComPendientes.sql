SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spVWSWProv_ComPendientes
@Proveedor  varchar(10),
@Empresa	varchar(5),
@FechaD		datetime,
@FechaA		datetime
AS BEGIN
SELECT Mov, MovID,(RTrim(Mov) + ' ' + RTrim(MovID)) as Movimiento,FechaEmision,SubTotal,Impuestos,Saldo,Total,Moneda,Referencia,Empresa,Proveedor
FROM vwSWProv_ComPendientes
WHERE Proveedor = @Proveedor AND Empresa = @Empresa AND FechaEmision BETWEEN @fechaD AND @fechaA
RETURN
END

