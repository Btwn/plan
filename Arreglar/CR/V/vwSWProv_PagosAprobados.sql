SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWProv_PagosAprobados
AS
SELECT
ID,
Contacto Proveedor,
RTRIM(Mov) Mov,
RTRIM(MovID) MovID,
(RTRIM(Mov) + ' ' + RTRIM(MovID)) as Movimiento,
FechaProgramada,
RTRIM(BeneficiarioNombre) Beneficiario,
RTRIM(Concepto) Concepto,
RTRIM(Referencia) Referencia,
RTRIM(Origen) Origen,
RTRIM(OrigenID) OrigenID,
Importe,
RTRIM(Moneda) Moneda,
RTRIM(Estatus) Estatus,
RTRIM(Observaciones) Observaciones,
Empresa
FROM Dinero
WHERE Mov = 'Solicitud Cheque'

