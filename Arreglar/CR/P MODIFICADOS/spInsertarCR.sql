SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarCR
@CRID int OUTPUT, @Sucursal int, @Empresa varchar(5), @CRMov varchar(20), @Moneda varchar(10), @TipoCambio float, @FechaTrabajo datetime, @CtaCaja varchar(10), @CajaFolio int, @CtaCajero varchar(10), @FechaD datetime, @FechaA datetime, @Referencia varchar(50), @CREstatusSinAfectar varchar(15), @DocFuente int, @Usuario varchar(10), @Ok int OUTPUT, @OkRef varchar(255) OUTPUT

AS BEGIN
INSERT CR (Sucursal,  SucursalOrigen, Empresa,  Mov,    Moneda,  TipoCambio,  FechaEmision,  Caja,     CajaFolio,  Cajero,     FechaD,  FechaA,  Referencia,  Estatus,              DocFuente,  Usuario)
VALUES (@Sucursal, @Sucursal,      @Empresa, @CRMov, @Moneda, @TipoCambio, @FechaTrabajo, @CtaCaja, @CajaFolio, @CtaCajero, @FechaD, @FechaA, @Referencia, @CREstatusSinAfectar, @DocFuente, @Usuario)
SELECT @CRID = SCOPE_IDENTITY()
RETURN
END

