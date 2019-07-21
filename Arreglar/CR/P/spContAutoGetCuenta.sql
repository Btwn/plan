SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoGetCuenta
@Modulo			varchar(5),
@Cuenta			varchar(20),
@CuentaOmision		varchar(20),
@CtaCtoTipo		varchar(20),
@CtaCtoTipoAplica	varchar(20),
@CtaClase		varchar(50),
@Articulo		varchar(20),
@Almacen		varchar(10),
@AlmacenTipo		varchar(20),
@Concepto		varchar(50),
@Contacto		varchar(10),
@ContactoTipo		varchar(20),
@CtaDinero		varchar(10),
@CtaDineroDestino	varchar(10),
@FormaPago		varchar(50),
@Cta			varchar(20)	OUTPUT,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@TipoImpuesto1		varchar(10) = NULL,
@TipoImpuesto2		varchar(10) = NULL,
@TipoImpuesto3		varchar(10) = NULL,
@TipoImpuesto5		varchar(10) = NULL,
@TipoRetencion1		varchar(10) = NULL,
@TipoRetencion2		varchar(10) = NULL,
@TipoRetencion3		varchar(10) = NULL

AS BEGIN
DECLARE
@CtaRetencion	varchar(20),
@CtaNombre		varchar(100),
@CtaEsAcumulativa	bit,
@CtaRama		varchar(20),
@CategoriaAF	varchar(50),
@Rama		char(20),
@Cuenta2	varchar(20),
@Cuenta3	varchar(20)
SELECT @Cta = NULL
IF UPPER(@Cuenta) IN ('CONTACTO', 'RETENCION CONTACTO', 'CONTACTO ORIGEN', 'RETENCION CTO ORIGEN', 'RAMA CONTACTO', 'CUENTA DINAMICA')
BEGIN
IF NULLIF(RTRIM(@Contacto), '') IS NOT NULL OR UPPER(@Cuenta) = 'CUENTA DINAMICA'
BEGIN
IF UPPER(@ContactoTipo) = 'CLIENTE'   OR @Modulo IN ('VTAS', 'CXC')        SELECT @Cta = Cuenta, @CtaNombre = Nombre, @CtaRetencion = CuentaRetencion, @Rama = Rama     FROM Cte      WHERE Cliente   = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'PROVEEDOR' OR @Modulo IN ('COMS', 'CXP', 'GAS') SELECT @Cta = Cuenta, @CtaNombre = Nombre, @CtaRetencion = CuentaRetencion, @Rama = Rama     FROM Prov     WHERE Proveedor = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'PERSONAL'  OR @Modulo IN ('NOM', 'RH', 'ASIS')  SELECT @Cta = Cuenta, @CtaNombre = RTRIM(ApellidoPaterno)+' '+RTRIM(ApellidoMaterno)+' '+RTRIM(Nombre), @CtaRetencion = CuentaRetencion, @Rama = ReportaA FROM Personal WHERE Personal  = @Contacto
IF UPPER(@Cuenta) IN ('RETENCION CONTACTO', 'RETENCION CTO ORIGEN')
SELECT @Cta = @CtaRetencion
ELSE
IF UPPER(@Cuenta) = 'RAMA CONTACTO'
BEGIN
SELECT @Cta = NULL
IF UPPER(@ContactoTipo) = 'CLIENTE'   OR @Modulo IN ('VTAS', 'CXC')        SELECT @Cta = Cuenta, @CtaNombre = Nombre FROM Cte      WHERE Cliente   = @Rama ELSE
IF UPPER(@ContactoTipo) = 'PROVEEDOR' OR @Modulo IN ('COMS', 'CXP', 'GAS') SELECT @Cta = Cuenta, @CtaNombre = Nombre FROM Prov     WHERE Proveedor = @Rama ELSE
IF UPPER(@ContactoTipo) = 'PERSONAL'  OR @Modulo IN ('NOM', 'RH', 'ASIS')  SELECT @Cta = Cuenta, @CtaNombre = RTRIM(ApellidoPaterno)+' '+RTRIM(ApellidoMaterno)+' '+RTRIM(Nombre) FROM Personal WHERE Personal  = @Rama
END
END
END ELSE
IF UPPER(@Cuenta) IN ('ARTICULO', 'ARTICULO (CUENTA 2)', 'ARTICULO (CUENTA 3)', 'RAMA ARTICULO', 'CATEGORIA AF', 'CATEGORIA AF/FISCAL')
BEGIN
SELECT @Cta = Cuenta, @Cuenta2 = Cuenta2, @Cuenta3 = Cuenta3, @Rama = Rama, @CategoriaAF = CategoriaActivoFijo FROM Art WHERE Articulo = @Articulo
IF UPPER(@Cuenta) = 'RAMA ARTICULO'
BEGIN
SELECT @Cta = NULL
SELECT @Cta = Cuenta FROM Art WHERE Articulo = @Rama
END ELSE
IF UPPER(@Cuenta) IN ('CATEGORIA AF', 'CATEGORIA AF/FISCAL')
BEGIN
SELECT @Cta = NULL
SELECT @Cta = CASE UPPER(@Cuenta) WHEN 'CATEGORIA AF' THEN Cuenta ELSE CuentaFiscal END FROM ActivoFCat WHERE Categoria = @CategoriaAF
END ELSE
IF UPPER(@Cuenta) = 'ARTICULO (CUENTA 2)' SELECT @Cta = @Cuenta2 ELSE
IF UPPER(@Cuenta) = 'ARTICULO (CUENTA 3)' SELECT @Cta = @Cuenta3
END ELSE
IF UPPER(@Cuenta) = 'CUENTA DINERO'   	SELECT @Cta = Cuenta FROM CtaDinero WHERE CtaDinero = @CtaDinero        ELSE
IF UPPER(@Cuenta) = 'CUENTA DESTINO'  	SELECT @Cta = Cuenta FROM CtaDinero WHERE CtaDinero = @CtaDineroDestino ELSE
IF UPPER(@Cuenta) = 'FORMA PAGO'      	SELECT @Cta = Cuenta FROM FormaPago WHERE FormaPago = @FormaPago        ELSE
IF UPPER(@Cuenta) = 'TIPO CONTACTO'   	SELECT @Cta = @CtaCtoTipo  ELSE
IF UPPER(@Cuenta) = 'TIPO CONTACTO APLICA'   	SELECT @Cta = @CtaCtoTipoAplica  ELSE
IF UPPER(@Cuenta) = 'CLASIFICACION'   	SELECT @Cta = @CtaClase	 ELSE
IF UPPER(@Cuenta) = 'CONCEPTO'        	SELECT @Cta = Cuenta FROM Concepto WHERE Modulo = @Modulo AND Concepto = @Concepto ELSE
IF UPPER(@Cuenta) IN ('ALMACEN/AF', 'ALMACEN/AF DESTINO', 'TIPO ALMACEN/AF', 'CATEGORIA AF','DEPRECIACION AF')
BEGIN
IF UPPER(@Cuenta) IN ('ALMACEN/AF', 'ALMACEN/AF DESTINO') SELECT @Cta = Cuenta FROM Alm WHERE Almacen = @Almacen ELSE
IF UPPER(@Cuenta) = 'TIPO ALMACEN/AF' SELECT @Cta = Cuenta FROM CtoTipo WHERE Tipo = 'Almacen' AND SubTipo = @AlmacenTipo ELSE
IF UPPER(@Cuenta) = 'CATEGORIA AF' SELECT @Cta = cat.Cuenta  FROM ActivoFCat cat, Art a  WHERE a.Articulo = @Articulo AND a.CategoriaActivoFijo = cat.Categoria
IF UPPER(@Cuenta) = 'DEPRECIACION AF' SELECT @Cta = cat.CuentaDepreciacion FROM ActivoFCat cat, Art a WHERE a.Articulo = @Articulo AND a.CategoriaActivoFijo = cat.Categoria
END
IF UPPER(@Cuenta) = 'CUENTA DINAMICA'
BEGIN
SELECT @Cta = RTRIM(@CtaCtoTipo)+'/'+RTRIM(@Contacto)
IF NOT EXISTS(SELECT * FROM Cta WHERE Cuenta = @Cta)
BEGIN
SELECT @CtaRama = Rama,
@CtaEsAcumulativa = ISNULL(EsAcumulativa, 0)
FROM Cta
WHERE Cuenta = @CtaCtoTipo
IF @@ROWCOUNT = 0 OR @CtaCtoTipo IS NULL
SELECT @Ok = 50110, @OkRef = @ContactoTipo
ELSE BEGIN
IF @CtaEsAcumulativa = 1
SELECT @CtaRama = @CtaCtoTipo
INSERT Cta (
Cuenta, Rama,     Descripcion, Tipo,        Categoria, Familia, Grupo, EsAcreedora, EsAcumulativa, CentrosCostos, CentroCostosRequerido, CentroCostosOmision, AjusteInflacionario, Bucket, BucketSt, Estatus, Alta)
SELECT @Cta,   @CtaRama, @CtaNombre,  'Auxiliar',  Categoria, Familia, Grupo, EsAcreedora, 0,             CentrosCostos, CentroCostosRequerido, CentroCostosOmision, AjusteInflacionario, Bucket, BucketSt, 'ALTA',  GETDATE()
FROM Cta
WHERE Cuenta = @CtaCtoTipo
INSERT CtaSub (Cuenta, SubCuenta)
SELECT @Cta, SubCuenta
FROM CtaSub
WHERE Cuenta = @CtaCtoTipo
END
END
END
IF @Cuenta IN ('Tipo Imp 1 Acreedora', 'Tipo Imp 1 Deudora', 'Tipo Imp 2 Acreedora', 'Tipo Imp 2 Deudora', 'Tipo Imp 3 Acreedora', 'Tipo Imp 3 Deudora',
'Tipo Ret 1 Acreedora', 'Tipo Ret 1 Deudora', 'Tipo Ret 2 Acreedora', 'Tipo Ret 2 Deudora', 'Tipo Ret 3 Acreedora', 'Tipo Ret 3 Deudora')
BEGIN
IF @Cuenta = 'Tipo Imp 1 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto1  ELSE
IF @Cuenta = 'Tipo Imp 1 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto1  ELSE
IF @Cuenta = 'Tipo Imp 2 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto2  ELSE
IF @Cuenta = 'Tipo Imp 2 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto2  ELSE
IF @Cuenta = 'Tipo Imp 3 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto3  ELSE
IF @Cuenta = 'Tipo Imp 3 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto3  ELSE
IF @Cuenta = 'Tipo Imp 5 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto5  ELSE
IF @Cuenta = 'Tipo Imp 5 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto5  ELSE
IF @Cuenta = 'Tipo Ret 1 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion1 ELSE
IF @Cuenta = 'Tipo Ret 1 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion1 ELSE
IF @Cuenta = 'Tipo Ret 2 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion2 ELSE
IF @Cuenta = 'Tipo Ret 2 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion2 ELSE
IF @Cuenta = 'Tipo Ret 3 Acreedora' SELECT @Cta = CuentaAcreedora FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion3 ELSE
IF @Cuenta = 'Tipo Ret 3 Deudora'   SELECT @Cta = CuentaDeudora   FROM TipoImpuesto WHERE TipoImpuesto = @TipoRetencion3
END
IF NULLIF(RTRIM(@Cta), '') IS NULL SELECT @Cta = @CuentaOmision
SELECT @Cta = NULLIF(RTRIM(@Cta), '')
RETURN
END

