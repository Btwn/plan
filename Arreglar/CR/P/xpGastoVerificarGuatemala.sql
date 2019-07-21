SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpGastoVerificarGuatemala
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@FechaEmision		datetime,
@Estatus			char(15),
@Acreedor			char(10),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
DECLARE
@EsGuatemala				int,
@GtImporteMinimoSinRetencion		float,
@ImporteTotal				float
SELECT @EsGuatemala = EsGuatemala, @GtImporteMinimoSinRetencion = GtImporteMinimoSinRetencion FROM Empresa WHERE Empresa = @Empresa
SELECT @ImporteTotal = Importe FROM Gasto WHERE ID = @ID
If @EsGuatemala = 1 AND @Modulo = 'GAS' AND @Accion = 'AFECTAR' AND @Estatus = 'CONCLUIDO'
BEGIN
IF @ImporteTotal >= @GtImporteMinimoSinRetencion
BEGIN
IF EXISTS(SELECT * FROM GastoD WHERE ID = @ID AND Retencion2 > 0)
BEGIN
SELECT @Ok = 20905
SELECT @OkRef = 'El importe de retenciones excede al mínimo sin retención permitido'
END
END
END
RETURN
END

