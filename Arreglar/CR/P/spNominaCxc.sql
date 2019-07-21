SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaCxc
@NomCxc          varchar(20),
@NomTipo         varchar(50),
@Empresa         char(5),
@Sucursal        int,
@ID              int,
@Personal        char(10),
@Cliente         char(10),
@FechaD          datetime,
@FechaA          datetime,
@Moneda          char(10),
@TipoCambio      float,
@ConSueldoMinimo bit,
@SueldoMinimo    money,
@PersonalNeto    money        OUTPUT,
@Ok              int          OUTPUT,
@OkRef           varchar(255) OUTPUT

AS BEGIN
DECLARE
@Mov         varchar(20),
@MovID       varchar(20),
@Concepto    varchar(50),
@Referencia  varchar(50),
@Saldo       money,
@Importe     money
SELECT @Ok = NULL
SELECT @Mov = MOV FROM NOMINA WHERE ID=@ID
IF @NomTipo IN ('FINIQUITO', 'LIQUIDACION')
DECLARE crNominaCxc CURSOR FOR
SELECT c.Mov, c.MovID, c.Concepto, ISNULL(c.Saldo, 0.0)*TipoCambio/@TipoCambio
FROM Cxc c
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.CA', 'CXC.CAP', 'CXC.CAD', 'CXC.D')
WHERE c.Empresa = @Empresa AND c.Cliente = @Cliente AND c.Estatus = 'PENDIENTE' AND ISNULL(c.Saldo, 0.0)>0.0 /*AND c.Vencimiento <= @FechaA*/
ORDER BY c.Vencimiento
ELSE  IF @NomTipo IN ('SUELDO COMPLEMENTO')
DECLARE crNominaCxc CURSOR FOR
SELECT c.Mov, c.MovID, c.Concepto, ISNULL(c.Saldo, 0.0)*TipoCambio/@TipoCambio
FROM Cxc c
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.CA', 'CXC.CAP', 'CXC.CAD', 'CXC.D')
JOIN CfgNominaConceptoMov cf ON cf.Mov=mt.Mov AND cf.Concepto = c.Concepto
JOIN NominaConcepto nc ON nc.NominaConcepto = cf.NominaConcepto
WHERE c.Empresa = @Empresa AND c.Cliente = @Cliente AND c.Estatus = 'PENDIENTE' AND ISNULL(c.Saldo, 0.0)>0.0 AND c.Vencimiento <= @FechaA
AND nc.NominaConcepto  in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina =@MOV )
ORDER BY c.Vencimiento
ELSE
DECLARE crNominaCxc CURSOR FOR
SELECT c.Mov, c.MovID, c.Concepto, ISNULL(c.Saldo, 0.0)*TipoCambio/@TipoCambio
FROM Cxc c
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.CA', 'CXC.CAP', 'CXC.CAD', 'CXC.D')
JOIN CfgNominaConceptoMov cf ON cf.Mov=mt.Mov AND cf.Concepto = c.Concepto
JOIN NominaConcepto nc ON nc.NominaConcepto = cf.NominaConcepto
WHERE c.Empresa = @Empresa AND c.Cliente = @Cliente AND c.Estatus = 'PENDIENTE' AND ISNULL(c.Saldo, 0.0)>0.0 AND c.Vencimiento <= @FechaA
AND nc.NominaConcepto  in ( SELECT NominaConcepto FROM MovEspecificoNomina WHERE MovEspecificoNomina =@MOV )
ORDER BY c.Vencimiento
OPEN crNominaCxc
FETCH NEXT FROM crNominaCxc INTO @Mov, @MovID, @Concepto, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Importe = 0.0, @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
IF @ConSueldoMinimo = 1
BEGIN
IF @PersonalNeto - @Saldo >= @SueldoMinimo
SELECT @Importe = @Saldo
ELSE
IF @NomCxc = 'PARCIALES' SELECT @Importe = @PersonalNeto - @SueldoMinimo
END ELSE
SELECT @Importe = @Saldo
IF @Importe > 0.0
BEGIN
EXEC spNominaAgregarClaveInterna @Ok OUTPUT, @OkRef OUTPUT, 'Cxc', @Empresa, @Personal, @Importe = @Importe, @Cuenta = @Cliente, @Referencia = @Referencia, @Mov = @Mov, @Concepto = @Concepto
SELECT @PersonalNeto = @PersonalNeto - @Importe
END
END
FETCH NEXT FROM crNominaCxc INTO @Mov, @MovID, @Concepto, @Saldo
END
CLOSE crNominaCxc
DEALLOCATE crNominaCxc
RETURN
END

