SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAuditoriaSaldo
@Empresa	char(5),
@Sucursal	int,
@ContactoTipo	varchar(20),
@ClienteD	char(10),
@ClienteA	char(10),
@ProvD		char(10),
@ProvA		char(10)

AS BEGIN
DECLARE
@CtaActivo		char(20),
@CtaPasivo		char(20)
IF UPPER(@ClienteD) IN ('0', 'NULL', '(TODOS)') SELECT @ClienteD = NULL, @ClienteA = NULL
IF UPPER(@ProvD)    IN ('0', 'NULL', '(TODOS)') SELECT @ProvD = NULL, @ProvA = NULL
SELECT @CtaActivo	  = CtaActivo,
@CtaPasivo	  = CtaPasivo
FROM EmpresaCfg a WITH (NOLOCK) 
WHERE Empresa = @Empresa
CREATE TABLE #Contacto (
Contacto	char(10)	COLLATE Database_Default NULL,
Nombre		varchar(100)	COLLATE Database_Default NULL)
CREATE TABLE #CtaEstruc(
Cuenta			char(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)	COLLATE Database_Default NULL)
IF @ContactoTipo = 'Cliente'
BEGIN
INSERT #CtaEstruc(Cuenta, Descripcion)
SELECT Cta.Cuenta,
Cta.Descripcion
FROM Cta WITH (NOLOCK) 
JOIN Cta E2 ON Cta.Rama = E2.Cuenta
JOIN Cta E1 ON E2.Rama = E1.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaActivo OR E1.Rama = @CtaActivo OR E2.Rama = @CtaActivo)
END
ELSE
BEGIN
INSERT #CtaEstruc(Cuenta, Descripcion)
SELECT Cta.Cuenta,
Cta.Descripcion
FROM Cta WITH (NOLOCK) 
JOIN Cta E2 ON Cta.Rama = E2.Cuenta
JOIN Cta E1 ON E2.Rama = E1.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaPasivo OR E1.Rama = @CtaPasivo OR E2.Rama = @CtaPasivo)
END
IF @ContactoTipo = 'Cliente' AND @ClienteD = NULL AND @ClienteA = NULL
BEGIN
SELECT @ClienteD = MIN(Cliente) FROM Cte WITH (NOLOCK) 
SELECT @ClienteA = MAX(Cliente) FROM Cte WITH (NOLOCK) 
END
IF @ContactoTipo = 'Proveedor' AND @ProvD = NULL AND @ProvA = NULL
BEGIN
SELECT @ProvD = MIN(Proveedor) FROM Prov WITH (NOLOCK) 
SELECT @ProvA = MAX(Proveedor) FROM Prov WITH (NOLOCK) 
END
IF @ContactoTipo = 'Cliente'
BEGIN
INSERT #Contacto(Contacto, Nombre)
SELECT Cliente, Nombre
FROM Cte WITH (NOLOCK) 
WHERE Estatus = 'ALTA'
END
ELSE
BEGIN
INSERT #Contacto(Contacto, Nombre)
SELECT Proveedor, Nombre
FROM Prov WITH (NOLOCK) 
WHERE Estatus = 'ALTA'
END
SELECT a.Contacto, Importe = ISNULL(SUM(b.Debe * a.TipoCambio), 0) - ISNULL(SUM(b.Haber * a.TipoCambio), 0)
INTO #ContaSaldo
FROM Cont a WITH (NOLOCK) 
JOIN ContD b WITH (NOLOCK) ON a.ID = b.ID
JOIN MovTipo mt WITH (NOLOCK) ON a.Mov = mt.Mov
JOIN Cta WITH (NOLOCK) ON b.Cuenta = Cta.Cuenta
WHERE mt.Modulo = 'CONT'
AND mt.Clave = 'CONT.P'
AND a.Empresa = @Empresa
AND a.Estatus = 'CONCLUIDO'
AND ISNULL(a.Contacto, '') <> ''
AND a.ContactoTipo = @ContactoTipo 
AND Cta.Descripcion Like @ContactoTipo+'%'
AND ((Cta.Rama IN (SELECT Cuenta FROM #CtaEstruc)) OR (Cta.Cuenta IN (SELECT Cuenta FROM #CtaEstruc)))
AND a.Sucursal = ISNULL(@Sucursal, a.Sucursal)
AND a.Contacto >= CASE WHEN @ClienteD IS NULL THEN @ProvD ELSE @ClienteD END
AND a.Contacto <= CASE WHEN @ClienteD IS NULL THEN @ProvA ELSE @ClienteA END
GROUP BY a.Contacto, a.ContactoTipo
ORDER BY a.ContactoTipo, a.Contacto
SELECT s.Cuenta, Saldo = ISNULL(SUM(s.Saldo*m.TipoCambio), 0)
INTO #SaldoC
FROM Saldo s WITH (NOLOCK) 
JOIN Mon m WITH (NOLOCK) ON s.Moneda = m.Moneda
WHERE s.Empresa = @Empresa
AND s.Rama = CASE WHEN @ContactoTipo = 'Cliente' THEN 'CXC' ELSE 'CXP' END
AND s.Saldo <> 0
AND s.Sucursal = ISNULL(@Sucursal, Sucursal)
AND s.Cuenta >= CASE WHEN @ClienteD IS NULL THEN @ProvD ELSE @ClienteD END
AND s.Cuenta <= CASE WHEN @ClienteD IS NULL THEN @ProvA ELSE @ClienteA END
GROUP BY s.Cuenta, s.Rama
ORDER BY s.Cuenta
SELECT a.Contacto, a.Nombre, b.Importe, c.Saldo
FROM #Contacto a
LEFT OUTER JOIN #ContaSaldo b ON a.Contacto = b.Contacto
LEFT OUTER JOIN #SaldoC c ON a.Contacto = c.Cuenta
WHERE (ISNULL(b.Importe, 0) <> 0 OR ISNULL(c.Saldo, 0) <> 0)
ORDER BY a.Contacto
END

