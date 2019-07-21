SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTipoAddenda
@Modulo		char(5),
@ID		int

AS BEGIN
DECLARE
@Cliente		varchar(10),
@TipoAddenda	varchar(50)
IF @Modulo = 'VTAS' SELECT @Cliente = Cliente FROM Venta WHERE ID = @ID
IF @Modulo = 'CXC' SELECT @Cliente = Cliente FROM CXC WHERE ID = @ID
SELECT @TipoAddenda = TipoAddenda FROM CteCFD WHERE Cliente = @Cliente
EXEC xpTipoAddenda @Modulo, @ID, @TipoAddenda OUTPUT
SELECT 'TipoAddenda' = @TipoAddenda
RETURN
END

