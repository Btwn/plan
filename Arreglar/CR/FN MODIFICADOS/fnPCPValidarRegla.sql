SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarRegla
(
@ReglaID				int,
@FechaEmision			datetime,
@ClavePresupuestal		varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado					bit,
@Mascara					varchar(50),
@Tipo						varchar(20),
@Estatus					varchar(15),
@MascaraConcordante			bit,
@FechaConcordante			bit
SET @Resultado = 1
SELECT @Mascara = Mascara, @Tipo = Tipo, @Estatus = Estatus FROM ProyClavePresupuestalRegla WITH(NOLOCK) WHERE RID = @ReglaID
IF @Estatus = 'Activo'
BEGIN
SELECT @MascaraConcordante = dbo.fnPCPValidarMascara(@ClavePresupuestal,@Mascara)
SELECT @FechaConcordante = dbo.fnPCPValidarReglaVigencia(@ReglaID,@FechaEmision)
IF @MascaraConcordante = 1
BEGIN
IF @Tipo = 'Incluyente' AND @FechaConcordante = 0 SELECT @Resultado = 0 ELSE
IF @Tipo = 'Excluyente' AND @FechaConcordante = 1 SELECT @Resultado = 0
END
END
RETURN (@Resultado)
END

