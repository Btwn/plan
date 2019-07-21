SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnWebArticuloCR
(
@Sucursal	int,
@Monto	float
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255),
@Modo			varchar(20)
SELECT @Modo = eCommerceCRModo FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal
IF (@Modo = 'No')
SELECT @Resultado = ''
ELSE IF (@Modo = 'Lista')
SELECT @Resultado = ISNULL(Articulo, '') FROM WebCertificadosRegalo WITH(NOLOCK)
WHERE Monto = @Monto
ELSE IF (@Modo = 'Personalizable')
SELECT @Resultado = eCommerceCRArticulo FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal
ELSE
SELECT @Resultado = ''
RETURN (@Resultado)
END

