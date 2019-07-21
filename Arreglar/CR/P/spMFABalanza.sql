SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFABalanza(
@Empresa varchar(5),
@Ejercicio smallint,
@Periodo smallint,
@pNivel smallint,
@dCuenta varchar(60) = NULL,
@aCuenta varchar(60) = NULL,
@conMov varchar(2) = NULL)

AS BEGIN
DECLARE
@CuentaContable VARCHAR(60),
@ccontrol		VARCHAR(60),
@Nivel			SMALLINT,
@Clase			VARCHAR(2),
@Descripcion	VARCHAR(300),
@Tipo			VARCHAR(2),
@SaldoInicial	FLOAT,
@Debe			FLOAT,
@Haber			FLOAT,
@SaldoFinal		FLOAT,
@Where			VARCHAR(500),
@CadSql			VARCHAR(MAX)
SET @Where = ''
IF @dCuenta IS NULL
SET @dCuenta = ''
IF @aCuenta IS NULL
SET @aCuenta = ''
IF @conMov IS NULL
SET @conMov = 'no'
CREATE TABLE #Balanza(Cuenta VARCHAR(60),ccontrol varchar(60),Nivel SMALLINT,Clase VARCHAR(2),Descripcion VARCHAR(300),Tipo VARCHAR(2),Inicio FLOAT,Cargo FLOAT,Abono FLOAT,Final FLOAT)
CREATE TABLE #Balanza1(Cuenta VARCHAR(60),ccontrol varchar(60),Nivel SMALLINT,Clase VARCHAR(2),Descripcion VARCHAR(300),Tipo VARCHAR(2),Inicio FLOAT,Cargo FLOAT,Abono FLOAT,Final FLOAT)
INSERT INTO #Balanza(Cuenta,ccontrol,Nivel,Clase,Descripcion,Tipo,Inicio,Cargo,Abono,Final)
SELECT DISTINCT cc.CuentaContable,isnull(cc.cuentacontrol,'') cuentacontrol, cc.Nivel,cc.Clase,cc.Descripcion,SUBSTRING(cc.Tipo,1,1) Tipo,
CASE WHEN LOWER(cc.Clase) = 'c' THEN CAST(0 AS FLOAT) ELSE ROUND(ISNULL(t1.SaldoInicial,0),2) END SaldoInicial,
CASE WHEN LOWER(cc.Clase) = 'c' THEN 0.00 ELSE ROUND(ISNULL(t2.Debe,0),2) END Debe,
CASE WHEN LOWER(cc.Clase) = 'c' THEN 0.00 ELSE ROUND(ISNULL(t2.Haber,0),2) END Haber,
CASE WHEN LOWER(cc.Clase) = 'c' THEN 0.00 ELSE ROUND(ISNULL((t1.saldoinicial + t2.Debe) - t2.Haber,0),2) END SaldoFinal
FROM cuentascontables cc
LEFT JOIN(
SELECT A0.CuentaContable,(ISNULL(A0.Inicial,0) + ISNULL(A1.Cargo,0) - ISNULL(A1.Abono,0)) SaldoInicial FROM(
SELECT si.CuentaContable, SUM(ISNULL(si.SaldoInicial,0)) Inicial
FROM SaldosIni si
Where Empresa = @Empresa and Anio = @Ejercicio
GROUP BY si.CuentaContable
) AS A0
LEFT JOIN(
SELECT mv.CuentaContable, SUM(ISNULL(mv.Cargo,0)) Cargo,SUM(ISNULL(mv.Abono,0)) Abono
FROM MovContables mv
WHERE mv.Empresa = @Empresa and mv.Anio = @Ejercicio and mv.Mes < @Periodo
GROUP BY mv.CuentaContable
)AS A1 ON A0.CuentaContable = A1.CuentaContable
)AS t1 ON cc.CuentaContable = t1.CuentaContable AND lower(cc.clase) = 'r'
LEFT JOIN
(
SELECT cuentacontable,SUM(cargo) Debe, SUM(abono) Haber
FROM MovContables
WHERE mes = @Periodo and empresa = @Empresa and anio = @Ejercicio
GROUP BY CuentaContable
)AS t2
ON t1.CuentaContable = t2.CuentaContable
DECLARE cr_balanza CURSOR LOCAL FOR
SELECT DISTINCT CuentaContable,ISNULL(CuentaControl,''),Nivel,Clase,Descripcion,SUBSTRING(Tipo,1,1) Tipo,
CAST(0 AS FLOAT) SaldoInicial,CAST(0 AS FLOAT) Debe,CAST(0 AS FLOAT) Haber,CAST(0 AS FLOAT) SaldoFinal
FROM CuentasContables WHERE LOWER(Clase) = 'r'
OPEN cr_balanza
FETCH NEXT FROM cr_balanza INTO @CuentaContable,@ccontrol,@Nivel, @Clase, @Descripcion,@Tipo,@SaldoInicial,@Debe,@Haber,@SaldoFinal
WHILE @@FETCH_STATUS <> -1 AND @@ERROR = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
/*iniciar proceso de recursividad*/
WITH BalCtas (Cuenta,ccontrol,Nivel,Clase,Descripcion,Tipo,Inicio,Cargo,Abono,Final)
AS
(
SELECT cc.Cuenta,cc.ccontrol,cc.Nivel,cc.Clase,cc.Descripcion,cc.Tipo,cc.Inicio,cc.Cargo,cc.Abono,cc.Final
FROM  #Balanza cc
WHERE cc.Cuenta = @CuentaContable 
UNION ALL
SELECT e.Cuenta, e.ccontrol, e.Nivel, e.Clase, e.Descripcion,e.Tipo,
ROUND(ISNULL(e.Inicio,0) + ISNULL(m.Inicio,0),2) Inicio,
ROUND(e.Cargo + m.Cargo,2) Cargo,
ROUND(e.Abono + m.Abono,2) Abono,
ROUND(e.Final + m.Final,2) Final
FROM #Balanza AS e
JOIN BalCtas AS m ON e.Cuenta = m.ccontrol
)
INSERT INTO #BALANZA1(Cuenta,ccontrol,Nivel,Clase,Descripcion,Tipo,Inicio,Cargo,Abono,Final)
SELECT Cuenta,ccontrol,Nivel,Clase,Descripcion,Tipo,Inicio,Cargo,Abono,Final FROM BalCtas 
END
FETCH NEXT FROM cr_balanza INTO @CuentaContable, @ccontrol, @Nivel, @Clase, @Descripcion,@Tipo,@SaldoInicial,@Debe,@Haber,@SaldoFinal
END
CLOSE cr_balanza
DEALLOCATE cr_balanza
IF @dCuenta<>'' AND @aCuenta<>''
SET @Where = 'AND Cuenta between '''+ @dCuenta + ''' AND ''' + @aCuenta + ''''
IF lower(@conMov)='si'
SET @Where = @Where + ' AND (Inicio<>0 OR Cargo<>0 OR Abono<>0)'
SET @CadSql ='SELECT Cuenta cuenumero,ccontrol cuecontrol,Nivel cuenivel ,Descripcion cuedescri,Tipo cuetipo,'''' TipoDescri,sum(Inicio) Saldo,sum(Cargo) Debe, sum(Abono) Haber, sum(Final) Final
FROM #Balanza1
WHERE Nivel <= '+LTRIM(RTRIM(STR(@pNivel))) + ' '
+ @Where +'
GROUP BY Cuenta,ccontrol,Nivel,Descripcion,Tipo
ORDER BY Cuenta'
EXEC(@CadSql)
END

