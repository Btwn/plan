SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaPagoABC
ON FormaPago

FOR  INSERT, UPDATE, DELETE
AS
BEGIN
DELETE FROM FormaPagoMES WHERE FormaPago IN (SELECT FormaPago FROM DELETED)
INSERT FormaPagoMES (FormaPago,   Descripcion, TipoDocumento, DiasPrimerVencimiento, DiasEntreVencimientos, EstatusIntelIMES)
SELECT FormaPago, FormaPago, '', 0, 0, 0
FROM INSERTED
END

