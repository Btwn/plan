SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepDineroAuxDesglosado
@Empresa        varchar(5),
@CuentaD        varchar(10),
@CuentaA        varchar(10),
@FechaD         datetime,
@FechaA         datetime,
@Moneda         varchar(10),
@Mov            varchar(20),
@Uso            varchar(20)

AS
BEGIN
DECLARE
@Cuenta     varchar(10),
@SaldoI     money,
@Cargo      money,
@Abono      money
DECLARE @Tabla table
(ID             int,
Fecha          datetime,
Cargo          money,
Abono          money,
CtaDinero      varchar(10),
Descripcion    varchar(100),
NumeroCta      varchar(100),
Mov            varchar(20),
MovID          varchar(20),
Uso            varchar(20),
ModuloID       int,
EsCancelacion  bit)
IF UPPER(@Mov) IN ('0', 'NULL', '(TODOS)','') SELECT @Mov = NULL
IF UPPER(@Uso) IN ('0', 'NULL', '(TODOS)','') SELECT @Uso = NULL
INSERT @Tabla (ID, Fecha, Cargo, Abono, CtaDinero, Descripcion, NumeroCta, Mov,  MovID,  Uso, ModuloID,EsCancelacion)
SELECT        d.ID , d.Fecha Fecha, ISNULL(d.Cargo,0), ISNULL(d.Abono,0), c.CtaDinero, c.Descripcion, c.NumeroCta , d.Mov, d.MovID,  c.Uso, d.ModuloID, ISNULL(d.EsCancelacion,0)
FROM DineroAux  d JOIN CtaDinero  c ON d.CtaDinero=c.CtaDinero
WHERE d.Empresa= @Empresa
AND d.Moneda = ISNULL(@Moneda,d.Moneda)
AND c.CtaDinero  >= @CuentaD AND c.CtaDinero  <=  @CuentaA
AND d.Fecha  >=  @FechaD
AND d.Fecha  <=  @FechaA
AND d.Mov  = ISNULL(@Mov,d.Mov)
AND ISNULL(c.Uso,'')  = ISNULL(@Uso,ISNULL(c.Uso,''))
UNION ALL
SELECT DISTINCT NULL, @FechaA, 0.0, 0.0, CtaDinero, Descripcion, NumeroCta, NULL, NULL, Uso, NULL,0
FROM   CtaDinero
WHERE CtaDinero  >=  @CuentaD AND CtaDinero  <=  @CuentaA
AND CtaDinero NOT IN(SELECT DISTINCT CtaDinero FROM DineroAux WHERE Empresa = @Empresa AND Moneda = ISNULL(@Moneda,Moneda)  AND Fecha  >=  @FechaD  AND Fecha  <=  @FechaA  AND Mov  = ISNULL(@Mov,Mov))
AND Empresa = @Empresa
AND ISNULL(Uso,'') = ISNULL(@Uso,ISNULL(Uso,''))
AND Moneda = ISNULL(@Moneda,Moneda)
DECLARE crCuenta CURSOR FOR
SELECT  CtaDinero, Cargo, Abono
FROM @Tabla
OPEN crCuenta
FETCH NEXT FROM crCuenta INTO @Cuenta, @Cargo, @Abono
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spVerSaldoInicialM2 @Empresa, 'DIN', @Moneda, @Cuenta, @FechaD,NULL,@SaldoI output
IF ISNULL(@SaldoI,0) = 0.0 AND ISNULL(@Cargo,0.0) = 0.0 AND ISNULL(@Abono,0.0) = 0.0
DELETE @Tabla WHERE CtaDinero = @Cuenta
FETCH NEXT FROM crCuenta INTO @Cuenta, @Cargo, @Abono
END
CLOSE crCuenta
DEALLOCATE crCuenta
SELECT ID, Fecha, Cargo, Abono, CtaDinero, Descripcion, NumeroCta, Mov,  MovID,  Uso, ModuloID, EsCancelacion
FROM @Tabla
ORDER BY CtaDinero, Fecha, ID
RETURN
END

