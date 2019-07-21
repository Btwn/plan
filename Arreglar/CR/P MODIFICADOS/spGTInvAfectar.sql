SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGTInvAfectar
@ID                	int,
@Accion			char(20),
@Base			char(20),
@Empresa	      	char(5),
@Usuario		char(10),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
@MovTipo     		char(20),
@MovMoneda	      	char(10),
@MovTipoCambio		float,
@Estatus		char(15),
@EstatusNuevo		char(15),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion	datetime,
@Conexion		bit,
@SincroFinal		bit,
@Sucursal		int,
@UtilizarID		int,
@UtilizarMovTipo	char(20),
@IDGenerar		int,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@IDCursor		int,
@Clave			varchar(20),
@SubClave		varchar(20),
@OID			int,
@OMov			varchar(20),
@OMovID			varchar(20),
@ImporteAplicar		money,
@MovDestino		varchar(20),
@MovDestinoID		varchar(20)
SELECT @SubClave = SubClave FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov AND Modulo = @Modulo
IF @Accion = 'GENERAR' AND @Modulo = 'VTAS' AND @SubClave = 'VTAS.FA'
BEGIN
UPDATE VentaD  WITH(ROWLOCK) SET Aplica = NULL, AplicaID = NULL WHERE ID = @IDGenerar
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Accion = 'GENERAR' AND @Modulo = 'VTAS' AND @MovTipo = 'VTAS.F'
BEGIN
SELECT @OMov = Origen, @OMovID = OrigenID FROM Venta WITH(NOLOCK) WHERE ID = @ID
SELECT @OID = ID FROM Venta WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @OMov AND MovID = @OMovID
SELECT @Clave = Clave FROM MovTipo WITH(NOLOCK) WHERE Mov = @OMov AND Modulo = 'VTAS'
IF @Clave = 'VTAS.VCR'
BEGIN
DECLARE crAnticiposFacturados  CURSOR FOR
SELECT
mf.DID
FROM
MovFlujo mf WITH(NOLOCK)
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Mov = mf.DMov
AND mt.Modulo = 'VTAS'
AND mt.Clave = 'VTAS.F'
AND mt.SubClave = 'VTAS.FA'
WHERE mf.OID = (SELECT OID FROM MovFlujo WITH(NOLOCK) WHERE DID = @OID AND DModulo = 'VTAS')
OPEN crAnticiposFacturados
FETCH NEXT FROM crAnticiposFacturados  INTO @IDcursor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @MovDestino = Mov, @MovDestinoID = MovID, @ImporteAplicar = ISNULL(Importe, 0) + ISNULL(Impuestos, 0) FROM Venta WITH(NOLOCK) WHERE ID = @IDCursor
UPDATE Cxc  WITH(ROWLOCK) SET AnticipoAplicar = @ImporteAplicar, AnticipoAplicaModulo = 'VTAS', AnticipoAplicaID = @ID WHERE Mov = @MovDestino AND MovID = @MovDestinoID AND OrigenTipo = 'VTAS' AND Empresa = @Empresa
END
FETCH NEXT FROM crAnticiposFacturados  INTO @IDcursor
END
CLOSE crAnticiposFacturados
DEALLOCATE crAnticiposFacturados
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Clave = 'VTAS.P'
BEGIN
DECLARE crAnticiposFacturados  CURSOR FOR
SELECT
mf.DID
FROM
MovFlujo mf WITH(NOLOCK)
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Mov = mf.DMov
AND mt.Modulo = 'VTAS'
AND mt.Clave = 'VTAS.F'
AND mt.SubClave = 'VTAS.FA'
WHERE mf.OID = @OID
OPEN crAnticiposFacturados
FETCH NEXT FROM crAnticiposFacturados  INTO @IDcursor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @MovDestino = Mov, @MovDestinoID = MovID, @ImporteAplicar = ISNULL(Importe, 0) + ISNULL(Impuestos, 0) FROM Venta WITH(NOLOCK) WHERE ID = @IDCursor
UPDATE Cxc  WITH(ROWLOCK) SET AnticipoAplicar = @ImporteAplicar, AnticipoAplicaModulo = 'VTAS', AnticipoAplicaID = @ID WHERE Mov = @MovDestino AND MovID = @MovDestinoID AND OrigenTipo = 'VTAS' AND Empresa = @Empresa
END
FETCH NEXT FROM crAnticiposFacturados  INTO @IDcursor
END
CLOSE crAnticiposFacturados
DEALLOCATE crAnticiposFacturados
IF @@ERROR <> 0 SET @Ok = 1
END
END
IF @Accion IN('AFECTAR','CANCELAR') AND @Modulo = 'VTAS' AND @SubClave = 'VTAS.FA' AND @Estatus IN('SINAFECTAR','CONCLUIDO') AND @EstatusNuevo IN('CONCLUIDO','CANCELADO')
BEGIN
SELECT @OMov = Origen, @OMovID = OrigenID FROM Venta WITH(NOLOCK) WHERE ID = @ID
SELECT @OID = ID FROM Venta WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @OMov AND MovID = @OMovID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @OID, @OMov, @OMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
RETURN
END

