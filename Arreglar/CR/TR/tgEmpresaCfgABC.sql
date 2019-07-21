SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEmpresaCfgABC ON EmpresaCfg

FOR UPDATE
AS BEGIN
DECLARE
@EmpresaN						varchar(10),
@TieneAuxiliares				bit,
@MonedaCosteoA				varchar(10),
@TipoCosteoA					varchar(20),
@CosteoNivelSubCuentaA		bit,
@CosteoLotesA					bit,
@CosteoSeriesA				bit,
@CosteoMultipleSimultaneoA	bit,
@MonedaCosteoN				varchar(10),
@TipoCosteoN					varchar(20),
@CosteoNivelSubCuentaN		bit,
@CosteoLotesN					bit,
@CosteoSeriesN				bit,
@CosteoMultipleSimultaneoN	bit,
@CambioCfgCosteo				bit,
@OkRef						varchar(255),
@Preconfigurado				bit,
@FormacosteoA					varchar(20),
@FormacosteoN					varchar(20)
SELECT @Preconfigurado = Preconfigurado FROM Version
SELECT @FormacosteoA=FormaCosteo,@MonedaCosteoA =MonedaCosteo, @TipoCosteoA = TipoCosteo, @CosteoNivelSubCuentaA = CosteoNivelSubCuenta, @CosteoLotesA = CosteoLotes, @CosteoSeriesA = CosteoSeries, @CosteoMultipleSimultaneoA = CosteoMultipleSimultaneo FROM DELETED
SELECT @FormacosteoN=FormaCosteo,@EmpresaN = Empresa, @MonedaCosteoN =MonedaCosteo, @TipoCosteoN = TipoCosteo, @CosteoNivelSubCuentaN = CosteoNivelSubCuenta, @CosteoLotesN = CosteoLotes, @CosteoSeriesN = CosteoSeries, @CosteoMultipleSimultaneoN = CosteoMultipleSimultaneo FROM INSERTED
IF @Preconfigurado = 1
BEGIN
IF EXISTS (SELECT ID FROM AuxiliarU WHERE Empresa = @EmpresaN) SELECT @TieneAuxiliares = 1
IF (@MonedaCosteoA <> @MonedaCosteoN)							SELECT @CambioCfgCosteo =1, @okREf = 'Moneda Costeo' ELSE
IF (@TipoCosteoA <> @TipoCosteoN)								SELECT @CambioCfgCosteo =1, @okREf = 'Tipo Costeo' ELSE
IF (@CosteoNivelSubCuentaA <> @CosteoNivelSubCuentaN)			SELECT @CambioCfgCosteo =1, @okREf = 'Costeo Nivel Opción' ELSE
IF (@CosteoLotesA <> @CosteoLotesN)							SELECT @CambioCfgCosteo =1, @okREf = 'Costeo Por Lotes' ELSE
IF (@CosteoSeriesA <> @CosteoSeriesN)							SELECT @CambioCfgCosteo =1, @okREf = 'Costeo Por Series' ELSE
IF (@CosteoMultipleSimultaneoA <> @CosteoMultipleSimultaneoN) SELECT @CambioCfgCosteo =1, @okREf = 'Costeo Multiple Simultaneo'
IF (@FormacosteoA <> @FormacosteoN)							  SELECT @CambioCfgCosteo =1, @okREf = 'Forma Costeo '
SELECT @OkRef = 'Ya Existen Auxiliares. No Puede Modificar la Configuración '+@OkRef
IF @TieneAuxiliares = 1 AND @CambioCfgCosteo = 1
RAISERROR (@OkRef,16,-1)
END
END

