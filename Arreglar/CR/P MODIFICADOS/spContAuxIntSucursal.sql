SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContAuxIntSucursal
( @Empresa 		Char(5),
@Estatus 		Char(10),
@CuentaD 		Char(20),
@CuentaA 		Char(20),
@FechaD 		DateTime,
@FechaA 		DateTime,
@MovEspecifico 	char(20) = NULL,
@CtaCat 		char(50) = NULL,   
@CtaGrupo 	char(50) = NULL ,
@CtaFam 		char(50) = NULL,
@Sucursal            int = NULL,
@IncluirPresupuestos	varchar(2) = 'No' 
)

AS
BEGIN
IF UPPER(@MovEspecifico) IN ('0', 'NULL', '(TODOS)','') SELECT @MovEspecifico = NULL
IF UPPER(@CtaCat)        IN ('0', 'NULL', '(TODOS)','') SELECT @CtaCat = NULL
IF UPPER(@CtaFam)        IN ('0', 'NULL', '(TODOS)','') SELECT @CtaFam = NULL
IF UPPER(@CtaGrupo)      IN ('0', 'NULL', '(TODOS)','') SELECT @CtaGrupo = NULL
SELECT ContAux.ID,
ContAux.Empresa,
ContAux.Cuenta,
ContAux.SubCuenta,
ContAux.Ejercicio,
ContAux.Periodo,
ContAux.Renglon,
ContAux.RenglonSub,
ContAux.Concepto,
ContAux.Debe,
ContAux.Haber,
ContAux.FechaContable,
ContAux.Movimiento,
ContMov = ContAux.Mov,
ContAux.Referencia,
ContAux.Estatus,
ContAux.SucursalContable,
ContAux.Presupuesto 
INTO #TempContAux
FROM ContAux WITH(NOLOCK)
WHERE ContAux.Empresa = @Empresa
AND ContAux.Estatus = @Estatus
AND ContAux.Cuenta  >=  @CuentaD AND ContAux.Cuenta  <=  @CuentaA
AND ContAux.FechaContable  >=  @FechaD AND ContAux.FechaContable  <=  @FechaA
AND ContAux.Mov = ISNULL(@MovEspecifico, ContAux.Mov)
AND ContAux.SucursalContable = ISNULL(@Sucursal, ContAux.SucursalContable)
ORDER BY ContAux.Cuenta, ContAux.FechaContable, ContAux.ID
IF @IncluirPresupuestos = 'No' 
BEGIN
SELECT t.ID,
t.Empresa,
t.Cuenta,
t.SubCuenta,
t.Ejercicio,
t.Periodo,
t.Renglon,
t.RenglonSub,
t.Concepto,
t.Debe,
t.Haber,
t.FechaContable,
t.Movimiento,
t.Referencia,
t.Estatus,
t.SucursalContable,
Cta.Descripcion,
Cta.Cuenta AS 'CtaCuenta'
FROM Cta WITH(NOLOCK)
LEFT OUTER JOIN #TempContAux t ON Cta.Cuenta = t.Cuenta
WHERE Cta.Cuenta BETWEEN @CuentaD AND @CuentaA 
AND Cta.TieneMovimientos = 1 AND Cta.EsAcumulativa = 0
AND ISNULL(Cta.Categoria, 0) = ISNULL(ISNULL(@CtaCat, Cta.Categoria), 0)
AND ISNULL(Cta.Familia, 0) = ISNULL(ISNULL(@CtaFam, Cta.Familia), 0)
AND ISNULL(Cta.Grupo, 0) = ISNULL(ISNULL(@CtaGrupo, Cta.Grupo), 0)
AND ISNULL(t.Presupuesto, 0) = 0 
ORDER BY Cta.Cuenta, t.FechaContable, t.ID  ASC
END
ELSE IF @IncluirPresupuestos = 'Si' 
BEGIN
SELECT t.ID,
t.Empresa,
t.Cuenta,
t.SubCuenta,
t.Ejercicio,
t.Periodo,
t.Renglon,
t.RenglonSub,
t.Concepto,
t.Debe,
t.Haber,
t.FechaContable,
t.Movimiento,
t.Referencia,
t.Estatus,
t.SucursalContable,
Cta.Descripcion,
Cta.Cuenta AS 'CtaCuenta'
FROM Cta WITH(NOLOCK)
LEFT OUTER JOIN #TempContAux t ON Cta.Cuenta = t.Cuenta
WHERE Cta.Cuenta BETWEEN @CuentaD AND @CuentaA 
AND Cta.TieneMovimientos = 1 AND Cta.EsAcumulativa = 0
AND ISNULL(Cta.Categoria, 0) = ISNULL(ISNULL(@CtaCat, Cta.Categoria), 0)
AND ISNULL(Cta.Familia, 0) = ISNULL(ISNULL(@CtaFam, Cta.Familia), 0)
AND ISNULL(Cta.Grupo, 0) = ISNULL(ISNULL(@CtaGrupo, Cta.Grupo), 0)
AND ISNULL(t.Presupuesto, 0) = 0 
UNION ALL 
SELECT t.ID,
t.Empresa,
t.Cuenta,
t.SubCuenta,
t.Ejercicio,
t.Periodo,
t.Renglon,
t.RenglonSub,
t.Concepto,
t.Debe,
t.Haber,
t.FechaContable,
t.Movimiento,
t.Referencia,
t.Estatus,
t.SucursalContable,
Cta.Descripcion,
Cta.Cuenta AS 'CtaCuenta'
FROM Cta WITH(NOLOCK)
LEFT OUTER JOIN #TempContAux t ON Cta.Cuenta = t.Cuenta
WHERE Cta.Cuenta BETWEEN @CuentaD AND @CuentaA 
AND Cta.EsAcumulativa = 0
AND ISNULL(Cta.Categoria, 0) = ISNULL(ISNULL(@CtaCat, Cta.Categoria), 0)
AND ISNULL(Cta.Familia, 0) = ISNULL(ISNULL(@CtaFam, Cta.Familia), 0)
AND ISNULL(Cta.Grupo, 0) = ISNULL(ISNULL(@CtaGrupo, Cta.Grupo), 0)
AND ISNULL(t.Presupuesto, 0) = 1 
ORDER BY Cta.Cuenta, t.FechaContable, t.ID  ASC
END
END

