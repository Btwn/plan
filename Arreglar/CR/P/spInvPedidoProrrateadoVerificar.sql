SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvPedidoProrrateadoVerificar
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
@Clave	varchar(20),
@SubClave	varchar(20),
@Hijos	int
IF @Accion = 'CANCELAR' AND @Base IN ('PENDIENTE','SELECCION')
BEGIN
SELECT @SubClave = SubClave
FROM Venta v
JOIN MovTipo mt
ON mt.Mov = v.Mov
AND mt.Modulo =  'VTAS'
AND v.ID = @ID
IF @MovTipo = 'VTAS.P' AND @SubClave = 'VTAS.PPR'
BEGIN
SELECT @Hijos = COUNT(0) FROM MovFlujo WHERE OID = @ID
IF @Hijos > 0
BEGIN
SELECT @Ok = 60240
SELECT @OkRef = 'Tiene movimientos estadísticos'
END
END
END
END

