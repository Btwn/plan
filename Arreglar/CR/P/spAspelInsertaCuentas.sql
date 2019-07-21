SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelInsertaCuentas]

AS BEGIN
DECLARE	@Cuenta			varchar(50),
@Rubro			int,
@Usuario		varchar(20),
@Rama			varchar(50),
@NivelMax		varchar(1),
@NivelMin		varchar(1),
@Empresa		varchar(5),
@Formato		varchar(30),
@Digitos		int,
@Observaciones	varchar(30)
EXEC spinsertagrupos			
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Empresa = Valor FROM AspelCfg WHERE Descripcion = 'Empresa'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
IF NOT EXISTS(SELECT Grupo FROM CtaGrupo WHERE Grupo = @Observaciones)
INSERT INTO CtaGrupo (Grupo) VALUES (@Observaciones)
SELECT @Formato = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Formato Cuentas Contables'
UPDATE EmpresaCfg SET CtaFormato = LEFT(@Formato,20) WHERE Empresa = @Empresa
SET @Digitos = LEN(REPLACE(REPLACE(RTRIM(LTRIM(@Formato)),'-',''),';2',''))
SET @Digitos = CASE WHEN @Digitos = 0 THEN 20 ELSE @Digitos END
SELECT ValorNumero, Valor, Rama INTO #Rubro FROM AspelCargaProp WHERE Campo = 'Rubro' ORDER BY ValorNumero
SELECT ValorNumero, Valor INTO #RubroCuenta FROM AspelCargaProp WHERE Campo = 'RubroCuenta' ORDER BY ValorNumero
SELECT Valor, Nombre, Estatus, Tipo, Rama,Valornumero,Descripcion INTO #Cuenta FROM AspelCargaProp WHERE Campo = 'Cuenta'
DECLARE crRubroCuenta CURSOR FOR
SELECT A.ValorNumero, A.Valor, B.Rama
FROM #RubroCuenta A JOIN #Rubro B
ON A.ValorNumero = B.ValorNumero
ORDER BY B.ValorNumero
OPEN crRubroCuenta
FETCH NEXT FROM crRubroCuenta INTO @Rubro, @Cuenta, @Rama
WHILE @@FETCH_STATUS <> -1
BEGIN
UPDATE #Cuenta SET Rama = CASE WHEN @Rama IS NOT NULL THEN @Rama ELSE Rama END
WHERE Valor = @Cuenta
FETCH NEXT FROM crRubroCuenta INTO @Rubro, @Cuenta, @Rama
END
CLOSE crRubroCuenta
DEALLOCATE crRubroCuenta
SELECT @NivelMax = MAX(RIGHT(Valor,1)) from #Cuenta
SELECT @NivelMin = MIN(RIGHT(Valor,1)) from #Cuenta
INSERT CTA (Cuenta, Rama, Descripcion, Tipo, EsAcumulativa, Estatus, UltimoCambio, Alta,Grupo,Centroscostos,Centrocostosrequerido,EsAcreedora)
SELECT
dbo.fnAspelFormateaCuentas(LEFT(Valor,@Digitos),@Formato),
dbo.fnAspelFormateaCuentas(LEFT(Rama,@Digitos),@Formato),
LEFT(Nombre,100),
dbo.fnAspelTipoCuentas(RIGHT(Valor,1),@NivelMin,@NivelMax),
CASE WHEN Tipo = 'A' THEN 1 ELSE 0 END,
Estatus,
getdate(),
getdate(),
@Observaciones,
Valornumero,
Valornumero,
Descripcion
FROM #Cuenta
where dbo.fnAspelFormateaCuentas(LEFT(Valor,@Digitos),@Formato) not in (select cuenta from cta)	
END

