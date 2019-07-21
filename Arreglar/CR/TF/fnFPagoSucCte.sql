SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFPagoSucCte
(
@Empresa	varchar(5),
@Cte		varchar(10),
@Sucursal	int
)
RETURNS @FormaPago TABLE(Orden		int identity(1,1),
Cliente		varchar(5),
Sucursal	int NULL,
FormaPago	varchar(50) NULL,
Cuenta		varchar(20) NULL,
Tipo		varchar(20)
)

AS
BEGIN
INSERT INTO @FormaPago(Cliente, Sucursal, FormaPago, Cuenta, Tipo)
SELECT Cliente, ID, FormaPago, Cuenta, 'Sucursales del Cliente'
FROM CteEnviarA
WHERE Cliente = @Cte
AND ID = ISNULL(@Sucursal, ID)
ORDER BY ID
INSERT INTO @FormaPago(Cliente, Sucursal, FormaPago, Cuenta, Tipo)
SELECT Cliente, NULL, InfoFormaPago, Cta, 'Datos CFD Cliente'
FROM CteCFD
WHERE Cliente = @Cte
INSERT INTO @FormaPago(Cliente, Sucursal, FormaPago, Cuenta, Tipo)
SELECT A.Cliente, NULL, B.FormaPago, B.CuentaPago, 'Datos Nivel Empresa'
FROM CteEmpresaCFD A
JOIN CteCFDFormaPago B
ON A.Empresa = B.Empresa
AND A.Cliente = B.Cliente
WHERE A.Empresa = @Empresa
AND A.Cliente = @Cte
INSERT INTO @FormaPago(Cliente, Sucursal, FormaPago, Cuenta, Tipo)
SELECT A.Cliente, NULL, A.InfoPago, B.CuentaPago, 'Información del Pago'
FROM CteCFDInfoPago A
JOIN CteCFDInfoPagoD B
ON A.Cliente = B.Cliente
AND A.InfoPago = B.InfoPago
WHERE A.Cliente = @Cte
RETURN
END

