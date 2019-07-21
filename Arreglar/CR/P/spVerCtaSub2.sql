SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerCtaSub2
@Cuenta		char(20),
@Empresa	varchar(50)	= NULL,
@Usuario	varchar(50)	= NULL,
@GrupoTrabajo	varchar(50)	= NULL

AS BEGIN
IF @Empresa      IS NOT NULL SELECT @Empresa = '('+RTRIM(@Empresa)+')'
IF @GrupoTrabajo IS NOT NULL SELECT @GrupoTrabajo = '('+RTRIM(@GrupoTrabajo)+')'
IF NOT EXISTS (SELECT * FROM CtaSub2 WHERE Cuenta = @Cuenta)
SELECT CentroCostos2
FROM CentroCostos2
WHERE EsAcumulativo = 0
AND NULLIF(RTRIM(NivelAcceso), '') IN (NULL, '(Todos)', @Usuario, @GrupoTrabajo, @Empresa)
ELSE
SELECT SubCuenta2 FROM CtaSub2 WHERE Cuenta = @Cuenta
RETURN
END

