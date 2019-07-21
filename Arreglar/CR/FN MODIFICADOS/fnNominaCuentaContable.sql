SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNominaCuentaContable (@CuentaBase varchar(50), @Cuenta varchar(20), @Personal varchar(10), @NominaConcepto varchar(10), @Proveedor varchar(10), @Empresa varchar(5))
RETURNS varchar(20)
AS BEGIN
DECLARE
@Resultado		       varchar(20),
@CuentaGrupo	       varchar(20),
@Rama		             varchar(20),
@SubSubGrupo	       varchar(50),
@Proveedor2  	       varchar(10),
@UEN        	       int,
@CuentaGrupo2        varchar(20),
@SucursalTrabajo     int,
@Categoria           varchar(50),
@Puesto              varchar(50)
SELECT @CuentaBase = UPPER(@CuentaBase), @Resultado = NULL
IF @CuentaBase = 'ESPECIFICA' SELECT @Resultado = @Cuenta ELSE
IF @CuentaBase = 'PERSONAL'   SELECT @Resultado = Cuenta FROM Personal WITH(NOLOCK) WHERE Personal = @Personal
ELSE BEGIN
SELECT @CuentaGrupo = ISNULL(CuentaGrupo, '')
FROM NominaConcepto WITH(NOLOCK)
WHERE NominaConcepto = @NominaConcepto
SELECT @CuentaGrupo2 = ISNULL(CuentaGrupo2, '')
FROM NominaConcepto WITH(NOLOCK)
WHERE NominaConcepto = @NominaConcepto
SELECT @Rama        = UPPER(cc.Rama),
@SubSubGrupo = UPPER(cc.SubSubGrupo),
@UEN         = P.UEN
FROM Personal p WITH(NOLOCK)
JOIN CentroCostos cc WITH(NOLOCK) ON cc.CentroCostos = p.CentroCostos
WHERE p.Personal = @Personal
IF @CuentaBase = 'LOCALIDAD'
SELECT @Resultado = @CuentaGrupo + '-' +
CASE @SubSubGrupo
WHEN 'DF' 		THEN '000002'
WHEN 'EDO MEX'	THEN '000003'
WHEN 'PROVINCIA'	THEN '000004'
END
IF @CuentaBase = 'PREFIJO'
SELECT @Resultado = @CuentaGrupo + '-' + @Personal
IF @CuentaBase = 'TIPO GASTO'
SELECT @Resultado =
CASE WHEN @Rama IN ('ALMACEN', 'DEPARTAMENTO')   THEN '602'
WHEN @Rama IN ('FORANEA', 'LOCAL', 'VENTA') THEN '601'
END + '-' + @CuentaGrupo
IF @CuentaBase = 'TIPO GASTO UEN '
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '5100'
WHEN @UEN IN (2,4,5)     THEN '5150'
END + '-' + @CuentaGrupo 
IF @CuentaBase = 'TIPO GASTO UEN 2'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2102'
WHEN @UEN IN (2,4,5)     THEN '2152'
END + '-' + @CuentaGrupo2 
IF @CuentaBase = 'TIPO GASTO UEN 5'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2102'
WHEN @UEN IN (2,4,5)     THEN '2152'
END + '-' + @CuentaGrupo 
IF @CuentaBase = 'TIPO GASTO UEN 4'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '1305'
WHEN @UEN IN (2,4,5)     THEN '1354'
END + '-' + @CuentaGrupo 
IF @CuentaBase = 'TIPO GASTO UEN 3'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2101'
WHEN @UEN IN (2,4,5)     THEN '2151'
END + '-' + @CuentaGrupo 
IF @CuentaBase = 'TIPO GASTO UEN F'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2101'
WHEN @UEN IN (2,4,5)     THEN '2151'
END + '-' + @CuentaGrupo2
IF @CuentaBase = 'TIPO GASTO UEN N'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2103'
WHEN @UEN IN (2,4,5)     THEN '2153'
END + '-' + @CuentaGrupo
IF @CuentaBase = 'TIPO GASTO UEN V'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2103-0001-000'
WHEN @UEN IN (2,4,5)     THEN '2153-0001-000'
END 
IF @CuentaBase = 'TIPO GASTO UEN PF'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '9101-0001-000'
WHEN @UEN IN (2,4,5)     THEN '9101-0001-000'
END 
IF @CuentaBase = 'TIPO GASTO UEN P'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '2101-0006-001'
WHEN @UEN IN (2,4,5)     THEN '2151-0007-001'
END 
IF @CuentaBase = 'TIPO GASTO UEN R'
SELECT @Resultado =
CASE WHEN @UEN IN (1,3)   THEN '1300-1183-000'
WHEN @UEN IN (2,4,5)     THEN '1354-0698-000'
END 
IF @CuentaBase = 'GASTO LOCALIDAD'
BEGIN
SELECT @Proveedor  = PersonalPropValor.VALOR
FROM  Personal WITH(NOLOCK), PersonalPropValor WITH(NOLOCK)
WHERE PersonalPropValor.cuenta=Personal.SucurSaltrabajo
AND PersonalPropValor.Rama='SUC'
AND Personal.personal=@Personal
AND PersonalPropValor.Propiedad='Acreedor Impuesto Estatal'
SELECT @Resultado = CASE WHEN @Rama IN ('ALMACEN', 'DEPARTAMENTO')   THEN '602'
WHEN @Rama IN ('FORANEA', 'LOCAL', 'VENTA') THEN '601'
END + '-' + ( SELECT RIGHT(RTRIM(Prov.CuentaRetencion),6)
FROM PROV WITH(NOLOCK) WHERE  Proveedor = @Proveedor)
END
IF @CuentaBase = 'TIPO ACREEDOR PENSION'
BEGIN
SELECT
@SucursalTrabajo = SucursalTrabajo,
@Categoria       = Categoria,
@Puesto          = Puesto
FROM Personal WITH(NOLOCK)
WHERE PERSONAL         = @Personal
SELECT  @Proveedor2 = Valor
FROM PersonalPropValor WITH(NOLOCK)
WHERE Rama = 'PER' AND Propiedad = 'Acreedor Pension Alimenticia' AND Cuenta = @Personal
IF @Proveedor = @Proveedor2
SELECT  @Resultado = Valor
FROM PersonalPropValor WITH(NOLOCK)
WHERE Rama = 'PER' AND Propiedad = 'Cuenta Pension Alimenticia' AND Cuenta = @Personal
SELECT  @Proveedor2 = Valor
FROM PersonalPropValor WITH(NOLOCK)
WHERE Rama = 'PER' AND Propiedad = 'Acreedor Pension Alimenticia 2' AND Cuenta = @Personal
IF @Proveedor = @Proveedor2
SELECT  @Resultado = Valor
FROM PersonalPropValor WITH(NOLOCK)
WHERE Rama = 'PER'
AND Propiedad = 'Cuenta Pension Alimenticia 2'
AND Cuenta = @Personal
SELECT  @Proveedor2 = Valor
FROM PersonalPropValor WITH(NOLOCK)
WHERE Rama = 'PER' AND Propiedad = 'Acreedor Pension Alimenticia 3' AND Cuenta = @Personal
IF @Proveedor = @Proveedor2
SELECT  @Resultado = Valor
FROM PersonalPropValor WITH(NOLOCK)
WHERE Rama = 'PER' AND Propiedad = 'Cuenta Pension Alimenticia 3' AND Cuenta = @Personal
END
END
RETURN (@Resultado)
END

