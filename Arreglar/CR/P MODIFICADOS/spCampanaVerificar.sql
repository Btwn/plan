SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaVerificar
@ID               	int,
@Accion				char(20),
@Empresa          	char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              	char(20),
@MovID				varchar(20),
@MovTipo	      	char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@CampanaTipo		varchar(50),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               	int          OUTPUT,
@OkRef            	varchar(255) OUTPUT

AS BEGIN
DECLARE
@HoraMin  datetime,
@HoraMax  datetime,
@HoraCMin datetime,
@HoraCMax datetime
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WITH (NOLOCK) WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END ELSE
BEGIN
IF @CampanaTipo IS NULL SELECT @Ok = 43010 /*ELSE
IF NOT EXISTS(SELECT * FROM CampanaD WHERE ID = @ID) SELECT @Ok = 43020*/
END
IF @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR' AND @MovTipo = 'CMP.A'
BEGIN
IF NOT EXISTS(SELECT * FROM CampanaD WITH (NOLOCK) WHERE ID = @ID) SELECT @Ok = 43020
IF EXISTS(SELECT * FROM CampanaD WITH (NOLOCK) WHERE ID = @ID AND (FechaD IS NULL OR FechaA IS NULL)) SELECT @Ok = 43021
IF EXISTS(SELECT * FROM CampanaMovilCfg WITH (NOLOCK) WHERE Empresa = @Empresa)
BEGIN
SELECT @HoraCMin = MIN(FechaD-dbo.fnFechaSinHora(FechaD)), @HoraCMax = MAX(FechaA-dbo.fnFechaSinHora(FechaA)) FROM CampanaD WITH (NOLOCK) WHERE ID = @ID
SELECT @HoraMin = MIN(HorarioD-dbo.fnFechaSinHora(HorarioD)), @HoraMax = MAX(HorarioA-dbo.fnFechaSinHora(HorarioA)) FROM CampanaMovilCfg WITH (NOLOCK) WHERE Empresa = @Empresa
IF @HoraCMin < @HoraMin OR @HoraCMax > @HoraMax
SELECT @Ok = 43022
END
END
IF @Accion = 'AFECTAR' AND @Estatus = 'PENDIENTE' AND @MovTipo = 'CMP.A'
BEGIN
IF EXISTS(SELECT * FROM Campana c WITH (NOLOCK) JOIN CampanaD d WITH (NOLOCK) ON(c.ID = d.ID) JOIN CampanaTipoSituacion s WITH (NOLOCK) ON(c.CampanaTipo = s.CampanaTipo AND d.Situacion = s.Situacion) WHERE c.ID = @ID AND s.Flujo <>'Final')
SELECT @Ok = 43023
END
RETURN
END

