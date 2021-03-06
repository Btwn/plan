SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnSaldoPMMAVI(@ID int)
RETURNS float
AS
BEGIN
DECLARE @IDC              int,
@Padre            varchar(30),
@PadreID          varchar(30),
@SaldoCapital     float
SELECT  @SaldoCapital= 0.00
SELECT @Padre = PadreMAVI, @PadreID = PadreIDMAVI FROM CXC WITH(NOLOCK) WHERE ID = @ID
SELECT @SaldoCapital = SUM(Saldo) FROM CXC WITH(NOLOCK) WHERE PadreMAVI = @Padre and PadreIDMAVI = @PadreID AND Estatus = 'PENDIENTE'
RETURN (ISNULL(@SaldoCapital,0))
END

