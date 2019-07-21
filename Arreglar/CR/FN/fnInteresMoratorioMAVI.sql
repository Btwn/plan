SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fnInteresMoratorioMAVI]
(
@ID	int  
)
RETURNS float 
AS BEGIN
DECLARE	@FactorIM				float,
@Empresa				char(5),
@FechaActual			datetime,
@FechaUltPagoInt		datetime,
@PagosRealizados		money,
@NumPagosRealizados		int,
@Mov					varchar(20),
@MovID					varchar(20),
@SaldoVencido			money,
@InteresesAcumulados	money,
@InteresesOrdinarios	money,
@Moratorio				float,
@TasaDiaria				float,
@Capital				money
SELECT @Mov   = Mov,
@MovID = MovID
FROM CXC WHERE ID = @ID
SELECT @FactorIM = ISNULL(dbo.fnFactorIMMAVI(@ID),0)
SELECT @Empresa = Empresa,
@SaldoVencido = ISNULL(Saldo,0),
@InteresesOrdinarios = ISNULL(InteresesOrdinarios,0),
@InteresesAcumulados = ISNULL(InteresesMoratoriosMAVI,0)
FROM Cxc WHERE ID = @ID
IF @Mov in ('Credilana','Prestamo Personal')
SELECT @SaldoVencido =  @SaldoVencido - ISNULL(@InteresesOrdinarios,0)
SELECT @TasaDiaria = ISNULL(CxcMoratoriosTasa,0.0) FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Moratorio = (( @FactorIM * @TasaDiaria ) * @SaldoVencido) + @InteresesAcumulados
RETURN (ROUND(@Moratorio,2))
END

