SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarCRCobro
@CRID int, @Sucursal int, @Renglon float, @FormaPago varchar(50), @Referencia varchar(50), @Moneda varchar(10), @TipoCambio float, @Cliente varchar(10), @Cxc bit, @Vencimiento datetime, @Importe money, @CFDSerie varchar(20), @CFDFolio varchar(20), @Ok int OUTPUT, @OkRef varchar(255) OUTPUT 

AS BEGIN
INSERT CRCobro
(ID,    Sucursal,  Renglon,  FormaPago,  Referencia,  Moneda,  TipoCambio,  Cliente,  Cxc,  Vencimiento,  Importe,  CFDSerie,  CFDFolio) 
VALUES (@CRID, @Sucursal, @Renglon, @FormaPago, @Referencia, @Moneda, @TipoCambio, @Cliente, @Cxc, @Vencimiento, @Importe, @CFDSerie, @CFDFolio) 
END

