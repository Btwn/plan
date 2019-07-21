SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAFGenerarGastoInfo
@Empresa				varchar(5),
@Mov					varchar(20),
@GastoConcepto	 		varchar(50)	OUTPUT,
@GastoFactor			float		OUTPUT,
@GastoMov				varchar(20)	OUTPUT,
@GastoAcreedor			varchar(10)	OUTPUT,
@GastoClase				varchar(50)	OUTPUT,
@GastoSubClase			varchar(50)	OUTPUT,
@AFGenerarGastoCfg		varchar(20)	OUTPUT,
@AFMovGenerarGastoCfg	varchar(20)	OUTPUT

AS BEGIN
SELECT @AFGenerarGastoCfg = AFGenerarGastoCfg FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @AFMovGenerarGastoCfg = AFMovGenerarGastoCfg
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'AF' AND Mov = @Mov
IF @AFGenerarGastoCfg = 'Empresa'
BEGIN
SELECT @GastoMov = NULLIF(LTRIM(RTRIM(GastoDepreciacion)), '') FROM EmpresaCfgMov WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @GastoAcreedor = NULLIF(LTRIM(RTRIM(AFAcreedorDepreciacion)), ''), @GastoConcepto = NULLIF(LTRIM(RTRIM(AFConceptoDepreciacion)), '') FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @GastoClase = NULLIF(LTRIM(RTRIM(Clase)), ''), @GastoSubClase = NULLIF(LTRIM(RTRIM(SubClase)), '') FROM Concepto WITH(NOLOCK) WHERE Concepto = @GastoConcepto AND Modulo = 'GAS'
END
ELSE
BEGIN
IF @AFMovGenerarGastoCfg = 'Especifico'
BEGIN
SELECT @GastoFactor = GastoFactor, @GastoMov = NULLIF(LTRIM(RTRIM(GastoMov)), ''), @GastoAcreedor = NULLIF(LTRIM(RTRIM(GastoAcreedor)), ''), @GastoClase = NULLIF(LTRIM(RTRIM(GastoClase)), ''), @GastoSubClase = NULLIF(LTRIM(RTRIM(GastoSubClase)), ''), @GastoConcepto = NULLIF(LTRIM(RTRIM(GastoConcepto)), '')
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'AF' AND Mov = @Mov
END
ELSE
BEGIN
SELECT @GastoFactor = GastoFactor, @GastoMov = NULLIF(LTRIM(RTRIM(GastoMov)), ''), @GastoAcreedor = NULLIF(LTRIM(RTRIM(GastoAcreedor)), ''), @GastoClase = NULL, @GastoSubClase = NULL, @GastoConcepto = NULL
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'AF' AND Mov = @Mov
END
END
END

