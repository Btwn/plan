SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerFechaTrabajo
@Empresa	varchar(5),
@Sucursal	int

AS BEGIN
DECLARE
@FechaTrabajo datetime
SELECT @FechaTrabajo = FechaTrabajo
FROM FechaTrabajo
WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF @FechaTrabajo IS NULL
BEGIN
SELECT @FechaTrabajo = dbo.fnFechaSinHora(GETDATE())
INSERT FechaTrabajo (
Empresa,  Sucursal,  FechaTrabajo)
VALUES (@Empresa, @Sucursal, @FechaTrabajo)
END
SELECT 'FechaTrabajo' = @FechaTrabajo
RETURN
END

