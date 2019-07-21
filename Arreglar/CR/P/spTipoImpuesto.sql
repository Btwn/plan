SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTipoImpuesto
@Modulo			varchar(5),
@ID			int,
@Mov			varchar(20),
@Fecha			datetime,
@Empresa		varchar(5),
@Sucursal		int,
@Contacto		varchar(10),
@EnviarA		int		= NULL,
@Articulo		varchar(20)	= NULL,
@Concepto		varchar(50)	= NULL,
@VerTipos		bit		= 0,
@EnSilencio		bit		= 0,
@Impuesto1		float		= NULL	OUTPUT,
@Impuesto2		float		= NULL	OUTPUT,
@Impuesto3		float		= NULL	OUTPUT,
@Retencion1		float		= NULL	OUTPUT,
@Retencion2		float		= NULL	OUTPUT,
@Retencion3		float		= NULL	OUTPUT,
@TipoImpuesto1		varchar(10)	= NULL	OUTPUT,
@TipoImpuesto2		varchar(10)	= NULL	OUTPUT,
@TipoImpuesto3		varchar(10)	= NULL	OUTPUT,
@TipoRetencion1		varchar(10)	= NULL	OUTPUT,
@TipoRetencion2		varchar(10)	= NULL	OUTPUT,
@TipoRetencion3		varchar(10)	= NULL	OUTPUT,
@TipoImpuesto4		varchar(10)	= NULL	OUTPUT,
@Impuesto5			float		= NULL	OUTPUT,
@TipoImpuesto5		varchar(10)	= NULL	OUTPUT,
@ConceptoMov		bit	= 0 

AS BEGIN
DECLARE
@CfgTipoImpuesto		bit,
@CriterioEmpresa		varchar(30),
@CriterioCliente		varchar(30),
@CriterioProveedor		varchar(30),
@RegimenEmpresa			varchar(30),
@ZonaEmpresa			varchar(30),
@RegimenSucursal		varchar(30),
@ZonaSucursal			varchar(30),
@RegimenCliente			varchar(30),
@ZonaCliente			varchar(30),
@RegimenEnviarA			varchar(30),
@ZonaEnviarA			varchar(30),
@RegimenProveedor		varchar(30),
@ZonaProveedor			varchar(30),
@MovTipo				varchar(20), 
@SubMovTipo				varchar(20)  
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
SELECT @RegimenEmpresa = NULL, @RegimenSucursal = NULL, @RegimenCliente = NULL, @RegimenEnviarA = NULL, @RegimenProveedor = NULL,
@TipoImpuesto1 = NULL, @TipoImpuesto2 = NULL, @TipoImpuesto3 = NULL, @TipoImpuesto5 = NULL, @TipoRetencion1 = NULL, @TipoRetencion2 = NULL, @TipoRetencion3 = NULL,
@ZonaEmpresa = NULL, @ZonaSucursal = NULL, @ZonaCliente = NULL, @ZonaEnviarA = NULL, @ZonaProveedor = NULL
SELECT @CfgTipoImpuesto   = ISNULL(TipoImpuesto, 0),
@CriterioEmpresa   = FiscalRegimenCriterioEmpresa,
@CriterioCliente   = FiscalRegimenCriterioCliente,
@CriterioProveedor = FiscalRegimenCriterioProveedor
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @CfgTipoImpuesto = 1 AND @Modulo IN ('VTAS', 'COMS', 'GAS','CREDI','CXC','CXP') 
BEGIN
SELECT @Impuesto1 = NULL, @Impuesto2 = NULL, @Impuesto3 = NULL, @Impuesto5 = NULL, @Retencion1 = NULL, @Retencion2 = NULL, @Retencion3 = NULL
SELECT @RegimenEmpresa = FiscalRegimen, @ZonaEmpresa = FiscalZona
FROM Empresa
WHERE Empresa = @Empresa
SELECT @RegimenSucursal = FiscalRegimen, @ZonaSucursal = FiscalZona
FROM Sucursal
WHERE Sucursal = @Sucursal
IF @Modulo = 'VTAS'
BEGIN
SELECT @RegimenCliente = FiscalRegimen, @ZonaCliente = FiscalZona
FROM Cte
WHERE Cliente = @Contacto
SELECT @RegimenEnviarA = FiscalRegimen, @ZonaEnviarA = FiscalZona
FROM CteEnviarA
WHERE Cliente = @Contacto AND ID = @EnviarA
END ELSE
IF @Modulo IN ('COMS', 'GAS')
BEGIN 
SELECT @RegimenProveedor = FiscalRegimen, @ZonaProveedor = FiscalZona
FROM Prov
WHERE Proveedor = @Contacto
END ELSE 
IF @Modulo IN ('CREDI') 
BEGIN
IF @MovTipo IN ('CREDI.FON','CREDI.DA','CFEDI.FOA')
BEGIN
SELECT @RegimenProveedor = FiscalRegimen, @ZonaProveedor = FiscalZona
FROM Prov
WHERE Proveedor = @Contacto
END ELSE
BEGIN
IF @MovTipo IN ('CREDI.FEX','CREDI.FIN','CREDI.CES','CREDI.DIS','CREDI.BTB')
BEGIN
SELECT @RegimenCliente = FiscalRegimen, @ZonaCliente = FiscalZona
FROM Cte
WHERE Cliente = @Contacto
SELECT @RegimenEnviarA = FiscalRegimen, @ZonaEnviarA = FiscalZona
FROM CteEnviarA
WHERE Cliente = @Contacto AND ID = @EnviarA
END
END
END ELSE
IF @Modulo IN ('CXC') 
BEGIN
SELECT @RegimenCliente = FiscalRegimen, @ZonaCliente = FiscalZona
FROM Cte
WHERE Cliente = @Contacto
SELECT @RegimenEnviarA = FiscalRegimen, @ZonaEnviarA = FiscalZona
FROM CteEnviarA
WHERE Cliente = @Contacto AND ID = @EnviarA
END ELSE
IF @Modulo IN ('CXP') 
BEGIN
SELECT @RegimenProveedor = FiscalRegimen, @ZonaProveedor = FiscalZona
FROM Prov
WHERE Proveedor = @Contacto
END
IF @Modulo IN ('COMS', 'VTAS')
BEGIN 
IF @ConceptoMov = 0 
BEGIN 
SELECT @TipoImpuesto1 = TipoImpuesto1, @TipoImpuesto2 = TipoImpuesto2, @TipoImpuesto3 = TipoImpuesto3,  @TipoImpuesto4 = TipoImpuesto4,  @TipoImpuesto5 = TipoImpuesto5,
@TipoRetencion1 = TipoRetencion1, @TipoRetencion2 = TipoRetencion2, @TipoRetencion3 = TipoRetencion3
FROM Art
WHERE Articulo = @Articulo
END ELSE 
BEGIN 
IF @ConceptoMov = 1
BEGIN
SELECT @TipoImpuesto1 = TipoImpuesto1
FROM Concepto
WHERE Modulo = @Modulo AND Concepto = @Concepto
END
END
END ELSE 
IF @Modulo = 'GAS'
BEGIN 
SELECT @TipoImpuesto1 = TipoImpuesto1, @TipoImpuesto2 = TipoImpuesto2, @TipoImpuesto3 = TipoImpuesto3, @TipoImpuesto4 = TipoImpuesto4,  @TipoImpuesto5 = TipoImpuesto5,
@TipoRetencion1 = TipoRetencion1, @TipoRetencion2 = TipoRetencion2, @TipoRetencion3 = TipoRetencion3
FROM Concepto
WHERE Modulo = @Modulo AND Concepto = @Concepto
END ELSE 
IF @Modulo IN ('CREDI') 
BEGIN
SELECT @TipoImpuesto1 = TipoImpuesto1
FROM Concepto
WHERE Modulo = @Modulo AND Concepto = @Concepto
END ELSE 
IF @Modulo IN ('CXC') 
BEGIN
SELECT @TipoImpuesto1 = TipoImpuesto1
FROM Concepto
WHERE Modulo = @Modulo AND Concepto = @Concepto
END ELSE 
IF @Modulo IN ('CXP') 
BEGIN
SELECT @TipoImpuesto1 = TipoImpuesto1
FROM Concepto
WHERE Modulo = @Modulo AND Concepto = @Concepto
END
IF NULLIF(RTRIM(@TipoImpuesto1), '') IS NOT NULL
BEGIN
SELECT @TipoImpuesto1 = dbo.fnTipoImpuestoRegla(@TipoImpuesto1, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Impuesto1  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto1
END
IF NULLIF(RTRIM(@TipoImpuesto2), '') IS NOT NULL
BEGIN
SELECT @TipoImpuesto2 = dbo.fnTipoImpuestoRegla(@TipoImpuesto2, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Impuesto2  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto2
END
IF NULLIF(RTRIM(@TipoImpuesto3), '') IS NOT NULL
BEGIN
SELECT @TipoImpuesto3 = dbo.fnTipoImpuestoRegla(@TipoImpuesto3, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Impuesto3  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto3
END
IF NULLIF(RTRIM(@TipoImpuesto4), '') IS NOT NULL
BEGIN
SELECT @TipoImpuesto4 = dbo.fnTipoImpuestoRegla(@TipoImpuesto4, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
END
IF NULLIF(RTRIM(@TipoImpuesto5), '') IS NOT NULL
BEGIN
SELECT @TipoImpuesto5 = dbo.fnTipoImpuestoRegla(@TipoImpuesto5, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Impuesto5  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto5
END
IF NULLIF(RTRIM(@TipoRetencion1), '') IS NOT NULL
BEGIN
SELECT @TipoRetencion1 = dbo.fnTipoImpuestoRegla(@TipoRetencion1, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Retencion1  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion1
END
IF NULLIF(RTRIM(@TipoRetencion2), '') IS NOT NULL
BEGIN
SELECT @TipoRetencion2 = dbo.fnTipoImpuestoRegla(@TipoRetencion2, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Retencion2  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion2
END
IF NULLIF(RTRIM(@TipoRetencion3), '') IS NOT NULL
BEGIN
SELECT @TipoRetencion3 = dbo.fnTipoImpuestoRegla(@TipoRetencion3, @Fecha, @Modulo, @ID, @Mov, @CriterioEmpresa, @CriterioCliente, @CriterioProveedor, @RegimenEmpresa, @ZonaEmpresa, @RegimenSucursal, @ZonaSucursal, @RegimenCliente, @ZonaCliente, @RegimenEnviarA, @ZonaEnviarA, @RegimenProveedor, @ZonaProveedor)
SELECT @Retencion3  = Tasa FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion3
END
END
EXEC xpTipoImpuesto @Modulo, @ID, @Mov, @Fecha, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo, @Concepto, @VerTipos, @EnSilencio, @Impuesto1 OUTPUT, @Impuesto2	OUTPUT, @Impuesto3	OUTPUT, @Retencion1	OUTPUT, @Retencion2	OUTPUT, @Retencion3	OUTPUT, @TipoImpuesto1	OUTPUT, @TipoImpuesto2	OUTPUT, @TipoImpuesto3	OUTPUT,  @TipoRetencion1	OUTPUT, @TipoRetencion2	OUTPUT, @TipoRetencion3	OUTPUT, @TipoImpuesto4 OUTPUT, @Impuesto5 OUTPUT, @TipoImpuesto5 OUTPUT
IF @EnSilencio = 0 AND @VerTipos = 0
SELECT Impuesto1 = @Impuesto1,
Impuesto2 = @Impuesto2,
Impuesto3 = @Impuesto3,
Impuesto5 = @Impuesto5,
Retencion1 = @Retencion1,
Retencion2 = @Retencion2,
Retencion3 = @Retencion3
IF @EnSilencio = 0 AND @VerTipos = 1
SELECT Impuesto1 = @Impuesto1,
Impuesto2 = @Impuesto2,
Impuesto3 = @Impuesto3,
Retencion1 = @Retencion1,
Retencion2 = @Retencion2,
Retencion3 = @Retencion3,
TipoImpuesto1 = @TipoImpuesto1,
TipoImpuesto2 = @TipoImpuesto2,
TipoImpuesto3 = @TipoImpuesto3,
TipoRetencion1 = @TipoRetencion1,
TipoRetencion2 = @TipoRetencion2,
TipoRetencion3 = @TipoRetencion3,
TipoImpuesto4 = @TipoImpuesto4,
Impuesto5 = @Impuesto5,
TipoImpuesto5 = @TipoImpuesto5
RETURN
END

