SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetActualizarCargo
@Usuario       varchar(10) = NULL,
@Empresa       varchar(5)  = NULL,
@Sucursal      int         = NULL,
@Cargo         varchar(50) = NULL
AS BEGIN
IF NOT EXISTS(SELECT 1 FROM Cargo WHERE Cargo = ISNULL(@Cargo,''))
INSERT INTO Cargo(Cargo) SELECT @Cargo
ELSE
UPDATE Cargo SET Cargo = @Cargo WHERE Cargo = ISNULL(@Cargo,'')
SELECT 'El registro se actualiz� con �xito'
RETURN
END

