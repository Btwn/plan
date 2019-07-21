SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarNominaAuto
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
@Ok		            int         OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Renglon		float,
@Importe		money,
@Referencia		varchar(50),
@PersonalEstatus	char(15),
@IDGenerar 		int,
@NominaConcepto     varchar (10),
@Cantidad   float,
@Porcentaje float,
@Repetir bit,
@Prorratear bit,
@Veces float,
@ImporteUnitario money,
@Frecuencia varchar (20),
@IncMovID varchar(20)
IF @Accion <> 'CANCELAR'
BEGIN
SELECT @Accion = 'AFECTAR', @PersonalEstatus = NULL
SELECT @PersonalEstatus = Estatus FROM Personal WHERE Personal = @Personal
IF @PersonalEstatus <> 'ALTA' SELECT @Ok = 55020
IF @Ok = 55020
EXEC xpOk_55020 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL RETURN
SELECT @NominaConcepto=NominaConcepto, @Cantidad= 1.0, @Porcentaje = 100.0,@Repetir=0,@Prorratear=0,@Veces=0, @ImporteUnitario =0, @Frecuencia='Cada Nomina'  FROM NominaConcepto nc
WHERE nc.Concepto='Comisiones'
IF @MovTipo IN ('AGENT.P', 'AGENT.CO')
BEGIN
DECLARE crAgentD CURSOR
FOR SELECT d.Importe, u.Referencia
FROM AgentD d, AgentUnico u
WHERE d.ID = @ID AND u.Empresa = @Empresa AND u.Mov = d.Aplica AND u.MovID = d.AplicaID
SELECT @Renglon = 0.0
OPEN crAgentD
FETCH NEXT FROM crAgentD INTO @Importe, @Referencia
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Renglon = @Renglon + 2048
IF @MovTipo = 'AGENT.CO' SELECT @Importe = -@Importe
SET @IDGenerar=0
INSERT INTO Incidencia
(Empresa, Mov, FechaEmision, UltimoCambio, Usuario, Estatus, GenerarPoliza, Sucursal, SucursalOrigen, Moneda, TipoCambio, FechaAplicacion, Personal,
NominaConcepto, FechaD, FechaA,					Cantidad, Valor,      Porcentaje,   Repetir, Prorratear, Veces, ImporteUnitario, Frecuencia,Referencia,Proyecto)
VALUES     (@Empresa, 'Incidencia', @FechaAfectacion,@FechaAfectacion,  @Usuario, 'SINAFECTAR', 0, @Sucursal, @Sucursal, @MovMoneda,@MovTipoCambio, @FechaAfectacion, @Personal,
@NominaConcepto,@FechaAfectacion, @FechaAfectacion, @Cantidad, @Importe, @Porcentaje, @Repetir, @Prorratear, @Veces, @ImporteUnitario, @Frecuencia,@Referencia,@Proyecto)
SET @IDGenerar=SCOPE_IDENTITY()
IF @IDGenerar>0
EXEC  spAfectar 'INC', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crAgentD INTO @Importe, @Referencia
END  
CLOSE crAgentD
DEALLOCATE crAgentD
END
END
SELECT @IncMovID=MovID FROM Incidencia WHERE ID=@IDGenerar
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INC', @IDGenerar, 'Incidencia', @IncMovID, @Ok OUTPUT
IF @Ok IS NULL
EXEC xpGenerarNominaAuto @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @FechaRegistro, @Concepto, @Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Personal, @IDGenerar, @NominaID OUTPUT, @NominaMov OUTPUT, @NominaMovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

