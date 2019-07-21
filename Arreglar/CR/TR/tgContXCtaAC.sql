SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgContXCtaAC ON ContXCta

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@ID			int,
@TipoCuenta		varchar(20),
@Cuenta		varchar(20),
@SubCuenta		varchar(50),
@CuentaContable	varchar(20),
@Mensaje		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ID = ID, @TipoCuenta = ISNULL(TipoCuenta, ''), @Cuenta = ISNULL(Cuenta, ''), @SubCuenta = ISNULL(SubCuenta, ''), @CuentaContable = ISNULL(CuentaContable, '') FROM INSERTED
IF @TipoCuenta NOT IN ('Conceptos Gastos') AND EXISTS(SELECT * FROM ContXCta WHERE ID <> @ID AND ISNULL(TipoCuenta, '') = @TipoCuenta AND ISNULL(Cuenta, '') = @Cuenta AND ISNULL(SubCuenta, '') = @SubCuenta)
BEGIN
SELECT @Mensaje = '"'+@TipoCuenta+' '+@Cuenta+' '+@SubCuenta+' - '+@CuentaContable+'" ' + Descripcion FROM MensajeLista WHERE Mensaje = 40110
RAISERROR (@Mensaje,16,-1)
END
END

