SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSEditarPOSLVenta (
@ID			varchar(36),
@Empresa	varchar(5),
@Articulo	varchar(20),
@Renglon	float
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado                    bit,
@CodigoRedondeo               varchar(30),
@ArticuloRedondeo             varchar(20),
@ArtOfertaImporte             varchar(20),
@ArtOfertaFP                  varchar(20),
@CfgAnticipoArticuloServicio  varchar(20),
@AnticipoFacturado            bit
SELECT @AnticipoFacturado  = ISNULL(AnticipoFacturado,0)
FROM POSLVenta
WHERE ID = @ID AND Renglon = @Renglon
SELECT @CodigoRedondeo = RedondeoVentaCodigo , @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB
WHERE CB.Cuenta = @CodigoRedondeo AND CB.TipoCuenta = 'Articulos'
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Resultado = 1
IF @Articulo IN (@ArticuloRedondeo, @ArtOfertaImporte, @ArtOfertaFP, @CfgAnticipoArticuloServicio)
SELECT @Resultado = 0
IF @AnticipoFacturado = 1
SELECT @Resultado = 0
RETURN (@Resultado)
END

