SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpInvAfectarAntes]
 @ID INT
,@Accion CHAR(20)
,@Base CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaEmision DATETIME
,@FechaRegistro DATETIME
,@FechaAfectacion DATETIME
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@UtilizarID INT
,@UtilizarMovTipo CHAR(20)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN

	IF @Modulo = 'VTAS'
		AND @Accion = 'CANCELAR'
		AND @Estatus = 'CONCLUIDO'
		AND @EstatusNuevo = 'CANCELADO'
		AND @MovTipo IN ('VTAS.F', 'VTAS.D')
		AND @OK IS NULL
	BEGIN
		EXEC xpCancelarEstadisticoMonedero @Empresa
										  ,@ID
										  ,@Usuario
										  ,@Sucursal
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT

		IF @OK IS NULL
			AND @MovTipo IN ('VTAS.F')
			EXEC xpCancelarAplicacionNCMonedero @Empresa
											   ,@ID
											   ,@Usuario
											   ,@Sucursal
											   ,@Ok OUTPUT
											   ,@OkRef OUTPUT

		IF @Ok IS NULL
			AND @MovTipo IN ('VTAS.D')
		BEGIN
			EXEC xpCancelarNCargoMonederoDevoluciones @Empresa
													 ,@ID
													 ,@Usuario
													 ,@Sucursal
													 ,@Ok OUTPUT
													 ,@OkRef OUTPUT

			IF @Ok IS NULL
				EXEC xpCancelarNCMonederoDevoluciones @Empresa
													 ,@ID
													 ,@Usuario
													 ,@Sucursal
													 ,@Ok OUTPUT
													 ,@OkRef OUTPUT

		END

	END

	RETURN
END

