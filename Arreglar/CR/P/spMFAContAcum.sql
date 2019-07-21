SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFAContAcum
@Cuenta		char(20)= NULL

AS BEGIN
SET NOCOUNT ON
DECLARE @Moneda				char(10) ,
@Moneda2				char(10) ,
@SubCuenta			varchar(20),
@SubCuenta2			varchar(50),
@SubCuenta3			varchar(50),
@Proyecto				varchar(50),
@UEN					int,
@CuentaAux			varchar(20),
@Grupo				char(10),
@Cargo				money,
@Abono				money,
@Cargo2				money,
@Abono2				money,
@Conciliado			bit,
@ImporteConciliar		money,
@ImporteConciliar2	money,
@Fecha				datetime,
@Rama					char(5),
@Ejercicio			int,
@Periodo				int,
@Empresa				char(5),
@Sucursal				int
DECLARE @CuentaNew	CHAR(20)
DECLARE @RamaNew		CHAR(20)
DECLARE @Contador		INT
SELECT @Rama = 'CONT', @Fecha = GETDATE(), @Grupo = '', @Ejercicio = NULL, @Periodo =NULL
SET @CuentaAux = @Cuenta
IF @Cuenta IS NOT NULL
BEGIN
SET @RamaNew  = ''
WHILE @RamaNew is not null
BEGIN
DELETE MFAAcum
WHERE Rama = @Rama
AND Empresa 	= ISNULL(@Empresa,Empresa)
AND Sucursal 	= ISNULL(@Sucursal,Sucursal)
AND Cuenta 	= ISNULL(@Cuenta,Cuenta)
AND Ejercicio 	= ISNULL(@Ejercicio,Ejercicio)
AND Periodo 	= ISNULL(@Periodo,Periodo)
SELECT @CuentaNew = b.cuenta, @RamaNew = NULLIF(ISNULL(RTRIM(b.rama), ''), '')
FROM Cta a,Cta b
WHERE a.Cuenta = @Cuenta
AND a.Rama = b.Cuenta
SELECT @RamaNew = NULLIF(ISNULL(RTRIM(@RamaNew), ''), '')
SET @Cuenta = @CuentaNew
END
END
ELSE
BEGIN
DELETE MFAAcum
WHERE Rama = @Rama
AND Empresa = ISNULL(@Empresa,Empresa)
AND Sucursal = ISNULL(@Sucursal,Sucursal)
END
SET @Cuenta = @CuentaAux
SELECT a.Sucursal, a.Empresa, a.Moneda, b.Cuenta, "SubCuenta"=ISNULL(LTRIM(b.SubCuenta),''),
Grupo = '', a.Ejercicio, a.Periodo, "Debe"=SUM(ISNULL(b.Debe,0)), "Haber"=SUM(ISNULL(b.Haber,0)),
"SubCuenta2"=ISNULL(RTRIM(b.SubCuenta2), ''),  "SubCuenta3"=ISNULL(RTRIM(b.SubCuenta3), ''), "Proyecto"=ISNULL(RTRIM(a.Proyecto), ''), "UEN"=ISNULL(a.UEN, 0),
ISNULL(a.OrigenMoneda, a.Moneda) 'Moneda2',
SUM(ISNULL(b.Debe/NULLIF(ISNULL(a.OrigenTipoCambio, a.TipoCambio), 0),0)) "Debe2",
SUM(ISNULL(b.Haber/NULLIF(ISNULL(a.OrigenTipoCambio, a.TipoCambio), 0),0)) "Haber2"
/*
CASE a.OrigenMoneda
WHEN a.Moneda THEN NULL
ELSE a.OrigenMoneda
END 'Moneda2'/*a.Moneda2*/,
CASE a.OrigenMoneda
WHEN a.Moneda THEN NULL
ELSE SUM(ISNULL(b.Debe/NULLIF(a.OrigenTipoCambio, 0),0))
END "Debe2",
CASE a.OrigenMoneda
WHEN a.Moneda THEN NULL
ELSE SUM(ISNULL(b.Haber/NULLIF(a.OrigenTipoCambio, 0),0))
END "Haber2"
*/
INTO #tcrAuxiliar
FROM Cont a, ContD b, Movtipo c
WHERE a.Id = b.Id
AND a.Estatus   = 'CONCLUIDO'
AND a.Empresa = ISNULL(@Empresa,a.Empresa)
AND a.Sucursal = ISNULL(@Sucursal,a.Sucursal)
AND b.Cuenta   = ISNULL(@Cuenta,b.Cuenta)
AND a.Ejercicio = ISNULL(@Ejercicio,a.Ejercicio)
AND a.Periodo   = ISNULL(@Periodo,a.Periodo)
AND a.Mov  = c.Mov
AND c.Modulo  = 'CONT'
AND c.Clave   <> 'CONT.PR'
GROUP BY a.Sucursal, a.Empresa, a.Moneda, b.Cuenta,  ISNULL(LTRIM(b.SubCuenta),''), a.Ejercicio, a.Periodo,
ISNULL(RTRIM(b.SubCuenta2), ''),  ISNULL(RTRIM(b.SubCuenta3), ''), ISNULL(RTRIM(a.Proyecto), ''), ISNULL(a.UEN, 0), a.OrigenMoneda/*a.Moneda2*/
DELETE #tcrAuxiliar WHERE ISNULL(Debe,0)=0 AND ISNULL(Haber,0)=0 AND ISNULL(Debe2,0)=0 AND ISNULL(Haber2,0)=0
DECLARE crAuxiliar CURSOR FOR
SELECT Sucursal, Empresa, Moneda, Cuenta, SubCuenta, Grupo, Ejercicio, Periodo, Debe, Haber, SubCuenta2, SubCuenta3, Proyecto, UEN, Moneda2, Debe2, Haber2
FROM #tcrAuxiliar
ORDER BY Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Grupo, Proyecto, UEN, Ejercicio, Periodo, Moneda, Sucursal, Empresa
OPEN crAuxiliar
FETCH NEXT FROM crAuxiliar INTO @Sucursal, @Empresa, @Moneda, @Cuenta, @SubCuenta, @Grupo, @Ejercicio, @Periodo, @Cargo, @Abono, @SubCuenta2, @SubCuenta3, @Proyecto, @UEN, @Moneda2, @Cargo2, @Abono2
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @RamaNew  = ''
WHILE @RamaNew is not null
BEGIN
SELECT @ImporteConciliar = @Cargo - @Abono,
@ImporteConciliar2 = @Cargo2 - @Abono2
IF ISNULL(@Moneda,'')<>'' AND ISNULL(@Moneda2,'')=ISNULL(@Moneda,'')
BEGIN
UPDATE MFAAcum
SET Cargos		= ISNULL(Cargos, 0.0) + ISNULL(@Cargo,0.0),
Abonos		= ISNULL(Abonos, 0.0) + ISNULL(@Abono,0.0),
UltimoCambio	= @Fecha
WHERE Sucursal		= @Sucursal
AND Empresa		= @Empresa
AND Rama			= @Rama
AND Moneda			= @Moneda
AND Grupo			= @Grupo
AND Cuenta			= @Cuenta
AND SubCuenta		= @SubCuenta
AND Periodo		= @Periodo
AND Ejercicio		= @Ejercicio
AND SubCuenta2		= @SubCuenta2
AND SubCuenta3		= @SubCuenta3
AND Proyecto		= @Proyecto
AND UEN			= @UEN
IF @@ROWCOUNT = 0
INSERT MFAAcum (Sucursal,  Empresa,  Rama,  Moneda,  Cuenta,  SubCuenta,  Grupo,  Ejercicio,  Periodo,  Cargos,  Abonos, UltimoCambio, SubCuenta2, SubCuenta3, Proyecto, UEN)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuenta, @Grupo, @Ejercicio, @Periodo, @Cargo,  @Abono, @Fecha, @SubCuenta2, @SubCuenta3, @Proyecto, @UEN)
END
IF ISNULL(@Moneda2,'')<>'' AND ISNULL(@Moneda2,'')<>ISNULL(@Moneda,'')
BEGIN
UPDATE MFAAcum
SET Cargos			= ISNULL(Cargos, 0.0) + ISNULL(@Cargo2,0.0),
Abonos			= ISNULL(Abonos, 0.0) + ISNULL(@Abono2,0.0),
UltimoCambio	= @Fecha
WHERE Sucursal		= @Sucursal
AND Empresa		= @Empresa
AND Rama			= @Rama
AND Moneda			= @Moneda2
AND Grupo			= @Grupo
AND Cuenta			= @Cuenta
AND SubCuenta		= @SubCuenta
AND Periodo		= @Periodo
AND Ejercicio		= @Ejercicio
AND SubCuenta2		= @SubCuenta2
AND SubCuenta3		= @SubCuenta3
AND Proyecto		= @Proyecto
AND UEN			= @UEN
IF @@ROWCOUNT = 0
INSERT MFAAcum (Sucursal, Empresa,  Rama,  Moneda,  Cuenta,  SubCuenta,  Grupo,  Ejercicio,  Periodo,  Cargos,  Abonos, UltimoCambio, SubCuenta2, SubCuenta3, Proyecto, UEN)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda2, @Cuenta, @SubCuenta, @Grupo, @Ejercicio, @Periodo, @Cargo2,  @Abono2, @Fecha, @SubCuenta2, @SubCuenta3, @Proyecto, @UEN)
END
SELECT @CuentaNew = b.cuenta, @RamaNew = b.rama
FROM Cta a,Cta b
WHERE a.Cuenta = @Cuenta
AND a.Rama = b.Cuenta
SET @Cuenta = @CuentaNew
SET @Contador = @Contador + 1
END
END
FETCH NEXT FROM crAuxiliar INTO @Sucursal, @Empresa, @Moneda, @Cuenta, @SubCuenta, @Grupo, @Ejercicio, @Periodo, @Cargo, @Abono, @SubCuenta2, @SubCuenta3, @Proyecto, @UEN, @Moneda2, @Cargo2, @Abono2
END
CLOSE crAuxiliar
DEALLOCATE crAuxiliar
RETURN
END

