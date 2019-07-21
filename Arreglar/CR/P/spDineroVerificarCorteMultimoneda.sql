SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroVerificarCorteMultimoneda
@ID                  int,
@Renglon             float,
@Empresa             varchar(5),
@Estatus             varchar(15),
@MovTipo             varchar(20),
@FormaPagoD		varchar(50),
@ReferenciaD	        varchar(50),
@ImporteD		money,
@Ok                  int	        OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CtaDinero	        varchar(10),
@CtaDineroTipo		varchar(20),
@CtaDineroDestinoTipo	varchar(20),
@CtaDineroDestino	varchar(10),
@CtaDineroMoneda	varchar(10),
@CtaEmpresa		varchar(5)
SELECT @CtaDinero =  CtaDineroDestino    ,@CtaDineroDestino=    CtaDinero FROM DineroD WHERE ID = @ID AND Renglon = @Renglon
SELECT @CtaDineroTipo = UPPER(Tipo), @CtaDineroMoneda = Moneda, @CtaEmpresa = NULLIF(RTRIM(Empresa), '') FROM CtaDinero WHERE CtaDinero = @CtaDinero
SELECT @CtaDineroDestinoTipo = UPPER(Tipo)FROM CtaDinero WHERE CtaDinero = @CtaDineroDestino
IF  @CtaDineroTipo <> 'CAJA'
IF @CtaDinero IS NULL SELECT @Ok = 40120
IF @MovTipo IN ('DIN.T', 'DIN.TI', 'DIN.INV', 'DIN.RET', 'DIN.TC', 'DIN.A', 'DIN.AP', 'DIN.CP', 'DIN.C')
BEGIN
IF @CtaDineroDestino IS NULL SELECT @Ok = 40040 ELSE
IF @CtaDineroDestino = @CtaDinero AND @Estatus = 'SINAFECTAR' SELECT @Ok = 40050
END
IF @CtaDineroTipo = 'CAJA' OR @CtaDineroDestinoTipo <> 'CAJA'
SELECT @Ok = 30460
IF @CtaDineroTipo = 'ESTRUCTURA' OR @CtaDineroDestinoTipo = 'ESTRUCTURA' SELECT @Ok = 20680
END

