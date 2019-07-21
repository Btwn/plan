SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spPolizasIniciales]

AS
DECLARE
@Sql 		nvarchar(max),
@Tabla		varchar(50),
@Cta		varchar(50),
@CtaOri		varchar(50),
@Saldo		decimal(15,7),
@Modulo		varchar(5),
@Mov		varchar(20),
@Empresa	varchar(5),
@Moneda		varchar(30),
@TipoCambio	float(15),
@Usuario	varchar(10),
@Estatus	varchar(15),
@Sucursal	int,
@Renglon	int,
@ID		int,
@Cuenta		int,
@TablaCat	varchar(20),
@TablaCatD	varchar(30),
@Nombre		varchar(50),
@Naturaleza	varchar(1),
@DEBE		decimal(20,7)	,
@HABER		decimal(20,7),
@Periodo	int,
@Digitos	int,
@Formato	varchar(24),
@Depto		int,
@RemglonSub	int
BEGIN
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Moneda = Valor FROM AspelCfg WHERE Descripcion = 'Moneda'
SELECT TOP 1 @Empresa = Empresa, @Mov = Mov, @Estatus = Estatus
FROM AspelCargaReg
WHERE Modulo = 'CONT'
SELECT TOP 1 @Periodo = Periodo FROM PASO_CTAS
ORDER BY Cuenta
SELECT @Formato = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Formato Cuentas Contables'
SET @Digitos = LEN(REPLACE(REPLACE(RTRIM(LTRIM(@Formato)),'-',''),';2',''))
SET @Digitos = CASE WHEN @Digitos = 0 THEN 20 ELSE @Digitos END
/* Insertamos la Póliza de Saldos Iniciales */
INSERT CONT (Empresa,Mov, MovId, FechaEmision,FechaContable,UltimoCambio,Moneda,TipoCambio,Usuario,Estatus,
Observaciones, Concepto, Periodo)
VALUES (@Empresa,'Diario', 0, Getdate(), Getdate(), Getdate(), @Moneda, 1, @Usuario, 'SINAFECTAR',
'Saldo Inicial', 'Saldo Inicial', @Periodo)
SET @ID = SCOPE_IDENTITY()
DECLARE cur_Cuentas CURSOR FOR
SELECT dbo.fnAspelFormateaCuentas(LEFT(Cuenta,@Digitos),@Formato), Nombre, SaldoIni, Naturaleza
FROM PASO_CTAS
WHERE DEPTSINO = 'N'
ORDER BY Cuenta
OPEN cur_Cuentas
FETCH NEXT FROM cur_Cuentas INTO @Cta, @Nombre, @Saldo, @Naturaleza
SET @CtaOri = ''
SET @Renglon = 0
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @CtaOri <> @Cta
BEGIN
SET @Renglon = @Renglon + 2048
SET @CtaOri = @Cta
SELECT @Debe = 0, @Haber = 0
IF @Naturaleza = '0'  	SET @Debe = @Saldo
IF @Naturaleza = '1' 	SET @Haber = @Saldo
/*Insertamos el detalle de la póliza */
SET @Renglon = @Renglon + 2048
INSERT CONTD (ID, Renglon, Cuenta, Concepto, Debe, Haber)
VALUES (@ID, @Renglon, @Cta, @Nombre, @Debe, @Haber)
END
FETCH NEXT FROM cur_Cuentas INTO @Cta, @Nombre, @Saldo, @Naturaleza
END
CLOSE cur_Cuentas
DEALLOCATE cur_Cuentas
DECLARE cur_Cuentas CURSOR FOR
SELECT dbo.fnAspelFormateaCuentas(LEFT(Cuenta,@Digitos),@Formato), Nombre, SaldoIni, Naturaleza, DEPTO
FROM PASO_CTASD
ORDER BY Cuenta
OPEN cur_Cuentas
FETCH NEXT FROM cur_Cuentas INTO @Cta, @Nombre, @Saldo, @Naturaleza, @Depto
SET @CtaOri = ''
SET @Renglon = 0
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Debe = 0, @Haber = 0
IF @Naturaleza = '0'  	SET @Debe = @Saldo
IF @Naturaleza = '1' 	SET @Haber = @Saldo
IF @CtaOri <> @Cta
BEGIN
SET @Renglon = @Renglon + 2048
SET @CtaOri = @Cta
SET @RemglonSub = 1
END
ELSE
BEGIN
SET @RemglonSub = @RemglonSub +1
END
/*Insertamos el detalle de la póliza */
SET @Renglon = @Renglon + 2048
INSERT CONTD (ID, Renglon, RenglonSub, Cuenta, Subcuenta, Concepto, Debe, Haber)
VALUES (@ID, @Renglon, @RemglonSub, @Cta, @Depto, @Nombre, @Debe, @Haber)
FETCH NEXT FROM cur_Cuentas INTO  @Cta, @Nombre, @Saldo, @Naturaleza, @Depto
END
CLOSE cur_Cuentas
DEALLOCATE cur_Cuentas
SELECT @Debe = SUM(Debe)
FROM CONTD
UPDATE CONT SET
Importe = @Debe
END

