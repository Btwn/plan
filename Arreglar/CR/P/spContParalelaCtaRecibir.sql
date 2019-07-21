SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalelaCtaRecibir
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@IDEmpresa			int,
@Ok					int			 OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
BEGIN TRY
UPDATE ContParalelaD
SET CtaEstatus = 'Actualizada'
FROM ContParalelaD
JOIN ContParalelaCta ON ContParalelaD.Cuenta = ContParalelaCta.Cuenta AND ContParalelaCta.Empresa = @Empresa AND ContParalelaCta.ID = @IDEmpresa
WHERE ContParalelaD.ID = @ID
UPDATE ContParalelaCta
SET Rama				= ContParalelaD.Rama,
Descripcion		= ContParalelaD.Descripcion,
Tipo				= ContParalelaD.Tipo,
Categoria		= ContParalelaD.Categoria,
Familia			= ContParalelaD.Familia,
Grupo			= ContParalelaD.Grupo,
EsAcreedora		= ContParalelaD.EsAcreedora,
EsAcumulativa	= ContParalelaD.EsAcumulativa,
TieneMovimientos	= ContParalelaD.TieneMovimientos,
Estatus			= ContParalelaD.Estatus
FROM ContParalelaD
JOIN ContParalelaCta ON ContParalelaD.Cuenta = ContParalelaCta.Cuenta AND ContParalelaCta.Empresa = @Empresa AND ContParalelaCta.ID = @IDEmpresa
WHERE ContParalelaD.ID = @ID
UPDATE ContParalelaD
SET CtaEstatus = 'Registrada'
FROM ContParalelaD
WHERE Cuenta NOT IN(SELECT Cuenta FROM ContParalelaCta WHERE Empresa = @Empresa AND ID = @IDEmpresa)
AND ID = @ID
INSERT INTO ContParalelaCta(
ID,         Empresa, Cuenta, Rama, Descripcion, Tipo, Categoria, Familia, Grupo, EsAcreedora, EsAcumulativa, TieneMovimientos, Estatus, Alta)
SELECT @IDEmpresa, @Empresa, Cuenta, Rama, Descripcion, Tipo, Categoria, Familia, Grupo, EsAcreedora, EsAcumulativa, TieneMovimientos, Estatus, GETDATE()
FROM ContParalelaD
WHERE Cuenta NOT IN(SELECT Cuenta FROM ContParalelaCta WHERE Empresa = @Empresa AND ID = @IDEmpresa)
AND ID = @ID
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
RETURN
END CATCH
RETURN
END

