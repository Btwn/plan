SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTCProcesadorTransCfg(
@Empresa		varchar(5),
@Sucursal		int
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @ProcesadorTrans		varchar(20)
IF dbo.fnTCNivelCfg(@Empresa) = 'Empresa'
SELECT @ProcesadorTrans = ProcesadorTrans FROM TCCfg WITH(NOLOCK) WHERE Empresa = @Empresa
ELSE IF dbo.fnTCNivelCfg(@Empresa) = 'Sucursal'
SELECT @ProcesadorTrans = ProcesadorTrans FROM TCSucursalCfg WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
RETURN(@ProcesadorTrans)
END

