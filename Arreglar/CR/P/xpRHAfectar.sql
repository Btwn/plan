SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpRHAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Concepto			varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgControlPlazas		varchar(20),
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@GenerarMov			char(20),
@IDGenerar			int,
@GenerarMovID	  	varchar(20),
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT
AS BEGIN
RETURN
END

