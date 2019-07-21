SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidarCuentaTipo
@CuentaTipo		varchar(20),
@Cuenta			char(10)

AS BEGIN
DECLARE
@Estatus varchar(15)
SELECT @Estatus = NULL
IF @CuentaTipo = 'Cliente'   SELECT @Estatus = Estatus FROM Cte      WHERE Cliente   = @Cuenta ELSE
IF @CuentaTipo = 'Proveedor' SELECT @Estatus = Estatus FROM Prov     WHERE Proveedor = @Cuenta ELSE
IF @CuentaTipo = 'Personal'  SELECT @Estatus = Estatus FROM Personal WHERE Personal  = @Cuenta ELSE
IF @CuentaTipo = 'Agente'    SELECT @Estatus = Estatus FROM Agente   WHERE Agente    = @Cuenta ELSE
IF @CuentaTipo = 'Almacen'   SELECT @Estatus = Estatus FROM Alm      WHERE Almacen   = @Cuenta ELSE
IF @CuentaTipo = 'Articulo'  SELECT @Estatus = Estatus FROM Art      WHERE Articulo  = @Cuenta
SELECT 'Estatus' = @Estatus
RETURN
END

