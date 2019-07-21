SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInvVerificarGuatemala
@ID                		int,
@Accion			char(20),
@Base			char(20),
@Empresa	      		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@MovMoneda	      		char(10),
@MovTipoCambio	 	float,
@Estatus	 	      	char(15),
@EstatusNuevo	      	char(15),
@FechaEmision		datetime,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
DECLARE
@EsGuatemala				int,
@GtImporteMinimoSinRetencion		float,
@ImporteTotal				float
SELECT @EsGuatemala = EsGuatemala, @GtImporteMinimoSinRetencion = GtImporteMinimoSinRetencion FROM Empresa WHERE Empresa = @Empresa
SELECT @ImporteTotal = Importe FROM Compra WHERE ID = @ID
If @EsGuatemala = 1 AND @Modulo = 'COMS' AND @Accion = 'AFECTAR' AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
IF @ImporteTotal >= @GtImporteMinimoSinRetencion
BEGIN
IF EXISTS(SELECT * FROM CompraD WHERE ID = @ID AND Retencion2 > 0)
BEGIN
SELECT @Ok = 20905
SELECT @OkRef = 'El importe de retenciones excede al mínimo sin retención permitido'
END
END
END
RETURN
END

