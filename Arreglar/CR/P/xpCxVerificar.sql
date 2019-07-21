SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpCxVerificar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@FormaPago VARCHAR(50)
,@ClienteProv CHAR(10)
,@CPMoneda CHAR(10)
,@CPFactor FLOAT
,@CPTipoCambio FLOAT
,@Importe MONEY
,@Impuestos MONEY
,@Saldo MONEY
,@CtaDinero CHAR(10)
,@AplicaManual BIT
,@ConDesglose BIT
,@CobroDesglosado MONEY
,@CobroDelEfectivo MONEY
,@CobroCambio MONEY
,@Indirecto BIT
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@EstatusNuevo CHAR(15)
,@AfectarCantidadPendiente BIT
,@AfectarCantidadA BIT
,@CfgContX BIT
,@CfgContXGenerar CHAR(20)
,@CfgEmbarcar BIT
,@CfgAutoAjuste MONEY
,@CfgFormaCobroDA VARCHAR(50)
,@CfgRefinanciamientoTasa FLOAT
,@MovAplica CHAR(20)
,@MovAplicaID VARCHAR(20)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	EXEC spValidaNoCancelarNCxBonif @Modulo
								   ,@ID
								   ,@Accion
								   ,@Conexion
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
	RETURN
END

