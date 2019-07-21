SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAccesoA ON Acceso

FOR INSERT
AS BEGIN
DECLARE
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@EstacionTrabajo	int,
@FechaTrabajo	datetime,
@UltimoCierre	datetime,
@Ayer		datetime,
@Ok			int,
@OkRef		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Usuario = Usuario, @FechaTrabajo = FechaTrabajo, @EstacionTrabajo = EstacionTrabajo FROM INSERTED
IF (SELECT CerrarDiaAuto FROM EmpresaGral WHERE Empresa = @Empresa) = 1
BEGIN
IF dbo.fnFechaSinHora(GETDATE()) = @FechaTrabajo
BEGIN
SELECT @UltimoCierre = NULL
SELECT @UltimoCierre = FechaTrabajo FROM FechaTrabajo WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF @UltimoCierre IS NULL OR @UltimoCierre < @FechaTrabajo
BEGIN
SELECT @Ayer = DATEADD(day, -1, @FechaTrabajo)
EXEC spCerrarDia @Empresa, @Sucursal, @Ayer, @Usuario, @EstacionTrabajo, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END ELSE
SELECT @Ok = 10551
END
EXEC spOk_RAISERROR @Ok, @OkRef
END

