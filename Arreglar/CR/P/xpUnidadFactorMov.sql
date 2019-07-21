SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpUnidadFactorMov
@Empresa		char(5),
@CfgMultiUnidades	bit,
@CfgMultiUnidadesNivel	char(20),
@CfgCompraFactorDinamico bit,
@CfgInvFactorDinamico   bit,
@CfgProdFactorDinamico  bit,
@CfgVentaFactorDinamico bit,
@Accion			char(20),
@Base			char(20),
@Modulo			char(5),
@ID			int,
@Renglon		float,
@RenglonSub		int,
@Estatus		char(15),
@EstatusNuevo		char(15),
@MovTipo		char(20),
@EsTransferencia	bit,
@AfectarConsignacion	bit,
@AlmacenTipo		char(15),
@AlmacenDestinoTipo	char(15),
@Articulo		char(20),
@SubCuenta		varchar(50),
@MovUnidad		varchar(50),
@ArtUnidad		varchar(50),
@ArtTipo		varchar(20),
@RenglonTipo		char(1),
@AplicaMovTipo		varchar(20),
@Cantidad		float,
@CantidadInventario	float,
@Factor			float		OUTPUT,
@Decimales		int		OUTPUT,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
SELECT @Factor = 1.0
SELECT @ArtUnidad = NULLIF(RTRIM(@ArtUnidad), ''), @MovUnidad = NULLIF(RTRIM(@MovUnidad), '')
IF @CfgMultiUnidades = 1 AND @MovTipo NOT IN ('COMS.PR')
BEGIN
IF @ArtUnidad IS NULL SELECT @Ok = 20145 ELSE
IF @MovUnidad IS NULL SELECT @Ok = 20150 ELSE
IF @CfgMultiUnidadesNivel = 'ARTICULO'
EXEC xpArtUnidadFactor @Articulo, @SubCuenta, @MovUnidad, @Factor OUTPUT, @Decimales OUTPUT, @OK OUTPUT
ELSE BEGIN
IF @MovUnidad <> @ArtUnidad
BEGIN
IF NOT EXISTS(SELECT * FROM UnidadConversion WHERE Unidad IN (@ArtUnidad, @MovUnidad) AND Conversion IN (@MovUnidad, @ArtUnidad))
SELECT @Ok = 20540
END
IF @Ok IS NULL
EXEC xpUnidadFactor @Articulo, @SubCuenta, @MovUnidad, @Factor OUTPUT, @Decimales OUTPUT
END
IF @Ok IS NULL AND
((@Modulo = 'VTAS' AND @CfgVentaFactorDinamico  = 1) OR
(@Modulo = 'COMS' AND @CfgCompraFactorDinamico = 1) OR
(@Modulo = 'INV'  AND @CfgInvFactorDinamico    = 1) OR
(@Modulo = 'PROD' AND @CfgProdFactorDinamico   = 1))
BEGIN
IF @CantidadInventario = 0.0 AND @MovTipo NOT IN ('VTAS.EST', 'INV.EST') SELECT @Ok = 20570 ELSE SELECT @Factor = ABS(@CantidadInventario) / NULLIF(@Cantidad, 0.0)
IF @Ok = 20570 AND @MovTipo = 'INV.IF' SELECT @Ok = NULL
END
END
IF @Ok IS NOT NULL SELECT @OkRef = @Articulo
RETURN
END

