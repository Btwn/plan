SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaAgregarClaveInterna
@Ok           int  OUTPUT,
@OkRef        varchar(255) OUTPUT,
@ClaveInterna varchar(50),
@Empresa      char(5),
@Personal     char(10),
@Cantidad     float       = NULL,
@Importe      money       = NULL,
@Cuenta       varchar(10) = NULL,
@Vencimiento  datetime    = NULL,
@Referencia   varchar(50) = NULL,
@Mov          varchar(20) = NULL,
@Concepto     varchar(50) = NULL,
@Semana       int  = NULL,
@Beneficiario varchar(100) = NULL ,
@UEN          int  = NULL

AS BEGIN
DECLARE
@RedondeoMonetarios int,
@NominaConcepto     varchar(10),
@AcreedorBase       varchar(20),
@AcreedorPropiedad  varchar(50),
@AcreedorDef        varchar(10),
@SucursalTrabajo    int,
@Categoria          varchar(50),
@Puesto             varchar(50)
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @Importe  = NULLIF(@Importe, 0.0),
@Cantidad = NULLIF(@Cantidad, 0.0),
@Cuenta   = NULLIF(RTRIM(@Cuenta), '')
IF @Importe IS NOT NULL OR @Cantidad IS NOT NULL
BEGIN
SELECT @NominaConcepto = NULL
IF @Mov IS NOT NULL
SELECT @NominaConcepto    = NULLIF(RTRIM(nc.NominaConcepto), ''),
@AcreedorBase      = UPPER(NULLIF(RTRIM(nc.AcreedorBase), '')),
@AcreedorPropiedad = NULLIF(RTRIM(nc.AcreedorPropiedad), ''),
@AcreedorDef       = NULLIF(RTRIM(nc.AcreedorDef), '')
FROM CfgNominaConceptoMov cfg
JOIN NominaConcepto nc ON nc.NominaConcepto = cfg.NominaConcepto
WHERE cfg.ClaveInterna = @ClaveInterna AND cfg.Mov = @Mov AND ISNULL(cfg.Concepto, '') = ISNULL(@Concepto, '')
IF @NominaConcepto IS NULL
SELECT @NominaConcepto = NULLIF(RTRIM(nc.NominaConcepto), ''),
@AcreedorBase = UPPER(NULLIF(RTRIM(nc.AcreedorBase), '')),
@AcreedorPropiedad = NULLIF(RTRIM(nc.AcreedorPropiedad), ''),
@AcreedorDef = NULLIF(RTRIM(nc.AcreedorDef), '')
FROM CfgNominaConcepto cfg
JOIN NominaConcepto nc ON nc.NominaConcepto = cfg.NominaConcepto
WHERE cfg.ClaveInterna = @ClaveInterna
IF @Cuenta IS NULL
BEGIN
IF @AcreedorBase = 'ESPECIFICO' SELECT @Cuenta = @AcreedorDef ELSE
IF @AcreedorBase = 'PROPIEDAD'
BEGIN
SELECT @SucursalTrabajo = SucursalTrabajo, @Categoria = Categoria, @Puesto = Puesto FROM Personal WHERE Personal = @Personal
EXEC spPersonalPropValor @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, @AcreedorPropiedad, @Cuenta OUTPUT
END
END
IF @UEN IS NULL
SELECT @UEN = UEN FROM Personal WHERE Personal = @Personal
IF @NominaConcepto IS NULL
SELECT @Ok = 10034, @OkRef = @ClaveInterna
ELSE
INSERT #Nomina (
Personal,  NominaConcepto,  Cantidad,  Importe,                              Cuenta,  Vencimiento,  Referencia,  Semana,  Beneficiario,   UEN)
VALUES (@Personal, @NominaConcepto, @Cantidad, ROUND(@Importe, @RedondeoMonetarios), @Cuenta, @Vencimiento, @Referencia, @Semana, @Beneficiario, @UEN)
END
RETURN
END

