SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFConcluirServicioMAF
@Modulo			varchar(5),
@AplicaEstatusNuevo	varchar(15),
@Accion			varchar(20),
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@AplicaFechaConclusion	datetime,
@IDAplica		int,
@ID			int,
@EstatusNuevo		varchar(15),
@Ok			int OUTPUT,
@OkRef			varchar(255) OUTPUT

AS BEGIN
DECLARE
@SubClaveAplica		varchar(20),
@CfgMAF			bit,
@AFArticuloAplica		varchar(20),
@AFSerieAplica		varchar(50),
@AFID			int,
@EstatusAF			varchar(15),
@Horas			float,
@Costo			money,
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@Tipo			varchar(20),
@Unidad			varchar(50),
@TipoCosteo			varchar(20),
@Moneda			varchar(10),
@TipoCambio			float,
@CostoArticulo		money,
@ServicioMovAFEsp		varchar(20)
IF @Modulo = 'VTAS' AND @AplicaEstatusNuevo IN ('CONCLUIDO','CANCELADO') AND @Accion IN ('AFECTAR','CANCELAR')
BEGIN
SELECT @CfgMAF = MAF FROM EmpresaGral WHERE Empresa = @Empresa
IF @CfgMAF = 1
BEGIN
SELECT @SubClaveAplica = mt.SubClave, @AFArticuloAplica = AFArticulo, @AFSerieAplica = AFSerie FROM Venta v JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS' WHERE ID = @IDAplica
IF @SubClaveAplica = 'MAF.S'
BEGIN
EXEC spMAFGenerarSolicitudInspeccion @Empresa, @Sucursal, @Accion, @AFArticuloAplica, @AFSerieAplica, @Usuario, NULL, @AplicaFechaConclusion, @IDAplica, @Ok OUTPUT, @OkRef OUTPUT
END
END
END
END

