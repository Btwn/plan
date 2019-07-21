SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaPaqueteXMLGenerar
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@Nivel				varchar(20),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@ISReferencia		varchar(100),
@IDEmpresa			int,
@CONTEsCancelacion	bit,
@Detalle			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @OrigenTipo		varchar(5),
@OrigenTipoAnt	varchar(5),
@SQL				nvarchar(max),
@Consulta			nvarchar(max),
@WHERE			nvarchar(max),
@FOR				nvarchar(max),
@XML				nvarchar(max),
@Parametros		nvarchar(max)
SELECT @Detalle = ''
SELECT @WHERE = '       WHERE ContParalelaD.ID = @ID AND ISNULL(Cont.OrigenTipo, '''') = ISNULL(@OrigenTipo, '''')'
SELECT @FOR = '         FOR XML AUTO '
SELECT @Parametros = '@XML			varchar(max) OUTPUT,
@ID				int,
@OrigenTipo		varchar(5)'
SELECT @OrigenTipoAnt = MAX(OrigenTipo) + '.'
FROM ContParalelaD
JOIN Cont ON ContParalelaD.ContID = Cont.ID
WHERE ContParalelaD.ID = @ID
WHILE(1=1)
BEGIN
SELECT @OrigenTipo = MAX(ISNULL(OrigenTipo, ''))
FROM ContParalelaD
JOIN Cont ON ContParalelaD.ContID = Cont.ID
WHERE ContParalelaD.ID = @ID
AND ISNULL(OrigenTipo, '') < @OrigenTipoAnt
IF @OrigenTipo IS NULL BREAK
SELECT @OrigenTipoAnt = @OrigenTipo, @SQL = '', @Consulta = '', @XML = ''
SELECT @Consulta = Consulta FROM ContParalelaXMLPlantilla WHERE Modulo = @OrigenTipo
IF @CONTEsCancelacion = 1
BEGIN
SELECT @Consulta = REPLACE(@Consulta, 'ContD.Debe',  '-1*ContD.Debe  ''Debe''')
SELECT @Consulta = REPLACE(@Consulta, 'ContD.Haber', '-1*ContD.Haber ''Haber''')
END
SELECT @SQL = 'SELECT @XML = (' + CHAR(13) + @Consulta + CHAR(13) + @WHERE + CHAR(13) + @FOR + ')'
BEGIN TRY
EXEC sp_executesql @SQL, @Parametros, @XML = @XML OUTPUT, @ID = @ID, @OrigenTipo = @OrigenTipo
SELECT @Detalle = @Detalle + ISNULL(@XML, '')
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
RETURN
END CATCH
END
RETURN
END

