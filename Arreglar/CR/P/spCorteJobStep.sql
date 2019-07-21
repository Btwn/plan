SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteJobStep
@Sucursal				int,
@Empresa				varchar(5),
@Usuario				varchar(10)

AS
BEGIN
DECLARE @Fecha		datetime,
@Estacion		int,
@Ok			int,
@OkRef		varchar(255)
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @Estacion = @@SPID
EXEC spCorteCerrarDia @Sucursal, @Empresa, @Usuario, @Fecha, @Estacion, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

