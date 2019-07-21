SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarNomina
@Sucursal			int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@ID				int,
@Mov				char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@MovMoneda	      		char(10),
@MovTipoCambio	 	float,
@FechaAfectacion  		datetime,
@FechaRegistro   		datetime,
@Concepto	      		varchar(50),
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Personal			char(10),
@NominaID			int		OUTPUT,
@NominaMov			char(20)	OUTPUT,
@NominaMovID			varchar(20)	OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Renglon		float,
@Importe		money,
@Referencia		varchar(50),
/*    @PersonalMoneda	char(10),
@PersonalFactor	float,
@PersonalTipoCambio	float,*/
@PersonalEstatus	char(15),
@IDGenerar 		int
IF @Accion <> 'CANCELAR'
BEGIN
SELECT @Accion = 'AFECTAR', @PersonalEstatus = NULL
SELECT /*@PersonalMoneda = Moneda, */@PersonalEstatus = Estatus FROM Personal WHERE Personal = @Personal
IF @PersonalEstatus <> 'ALTA' SELECT @Ok = 55020
IF @Ok = 55020
EXEC xpOk_55020 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL RETURN
INSERT INTO Nomina (Sucursal,  Empresa,  Mov,        MovID,        FechaEmision,     Concepto,  Proyecto,  Moneda,     TipoCambio,     Usuario,  Autorizacion,  DocFuente,  Observaciones,  Estatus,      OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Empresa, @NominaMov, @NominaMovID, @FechaAfectacion, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @DocFuente, @Observaciones, 'SINAFECTAR', @Modulo,    @Mov,   @MovID)
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @NominaID = SCOPE_IDENTITY()
EXEC spMovCopiarAnexos @Sucursal, @Modulo, @ID, 'NOM', @NominaID
IF @MovTipo IN ('AGENT.P', 'AGENT.CO')
BEGIN
DECLARE crAgentD CURSOR
FOR SELECT d.Importe, u.Referencia
FROM AgentD d, AgentUnico u
WITH(NOLOCK) WHERE d.ID = @ID AND u.Empresa = @Empresa AND u.Mov = d.Aplica AND u.MovID = d.AplicaID
SELECT @Renglon = 0.0
OPEN crAgentD
FETCH NEXT FROM crAgentD  INTO @Importe, @Referencia
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Renglon = @Renglon + 2048
IF @MovTipo = 'AGENT.CO' SELECT @Importe = -@Importe
INSERT NominaD (Sucursal,  ID,        Renglon,  Personal,  Importe,  Referencia,  FechaD)
VALUES (@Sucursal, @NominaID, @Renglon, @Personal, @Importe, @Referencia, @FechaAfectacion)
END
FETCH NEXT FROM crAgentD  INTO @Importe, @Referencia
END  
CLOSE crAgentD
DEALLOCATE crAgentD
END
END ELSE
BEGIN
SELECT @NominaID = DID, @NominaMov = DMov, @NominaMovID = DMovID
FROM MovFlujo
WITH(NOLOCK) WHERE Cancelado = 0
AND Empresa = @Empresa
AND OModulo = @Modulo
AND OID     = @ID
AND DModulo = 'NOM'
IF @@ERROR <> 0 SELECT @Ok = 1
IF @NominaID IS NULL SELECT @Ok = 60060, @OkRef = RTRIM(@NominaMov)+' '+LTRIM(Convert(Char, @NominaMovID))
END
IF @Ok IS NULL
EXEC spNomina @NominaID, 'NOM', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@NominaMov OUTPUT, @NominaMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'NOM', @NominaID, @NominaMov, @NominaMovID, @Ok OUTPUT
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
SELECT @Ok = 80030, @OkRef = 'Movimiento - '+RTRIM(@NominaMov)+' '+LTRIM(Convert(Char, @NominaMovID))
IF @Ok IS NULL
EXEC xpGenerarNomina @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @FechaRegistro, @Concepto, @Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Personal, @NominaID OUTPUT, @NominaMov OUTPUT, @NominaMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

