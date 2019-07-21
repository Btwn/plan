SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@Evaluacion			varchar(50),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@CfgControlPlazas		varchar(20),
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Personal		char(10),
@PersonalEstatus	char(15),
@PersonalMoneda	char(10),
@PersonalCategoria	varchar(50),
@PersonalEmpresa	varchar(5),
@SueldoDiario	money,
@SDI		money,
@SueldoMaximo	money,
@SueldoMinimo	money,
@SucursalD		int,
@Plaza		varchar(20),
@Puesto		varchar(50),
@Departamento	varchar(50),
@CentroCostos	char(20),
@PlazaPersonal	char(10),
@PlazaPuesto	varchar(50),
@PlazaDepartamento	varchar(50),
@PlazaEmpresa	char(5),
@PlazaSucursal	int,
@PlazaEstatus	char(15),
@PlazaAPartirDe	datetime,
@PlazaCentroCostos	char(20),
@FechaAlta		datetime,
@FechaAntiguedad	datetime,
@Tipo		varchar(20),
@VigenciaD		datetime,
@VigenciaA		datetime,
@IDOrigen		int,
@OrigenTipo		char(10),
@Origen		varchar(20),
@OrigenID		varchar(20),
@OrigenMovTipo	varchar(20),
@CfgValidarAF	varchar(20),
@SubClae		VARCHAR(10)
SELECT @SubClae = SubClave FROM MovTipo
WHERE Modulo = 'RH' AND Mov = @Mov
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END
ELSE BEGIN
/*
IF @CfgControlPlazas = 'AVANZADO' AND @MovTipo in ('RH.A', 'RH.M')
BEGIN
SELECT @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = NULLIF(RTRIM(OrigenID), '') FROM RH WHERE ID = @ID
SELECT @IDOrigen = NULL
SELECT @IDOrigen = ID FROM RH WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
SELECT @OrigenMovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Origen
IF @OrigenMovTipo in ('RH.SA', 'RH.SM')
BEGIN
DECLARE crMatarPlaza CURSOR FOR
SELECT Personal, Plaza
FROM RHD
WHERE ID = @IDOrigen
OPEN crMatarPlaza
FETCH NEXT FROM crMatarPlaza INTO @Personal, @Plaza
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM RHD WHERE ID = @ID AND Personal = @Personal AND Plaza = @Plaza)
SELECT @Ok = 20180, @OkRef = ' Persona ' + RTRIM(@Personal)
FETCH NEXT FROM crMatarPlaza INTO @Personal, @Plaza
END
CLOSE crMatarPlaza
DEALLOCATE crMatarPlaza
END
END
*/
SELECT @CfgValidarAF = UPPER(RHValidarAF)
FROM EmpresaCfg
WHERE Empresa = @Empresa
DECLARE crRHVerificar CURSOR
FOR SELECT NULLIF(RTRIM(d.Personal), ''), p.Empresa, RTRIM(p.Estatus), RTRIM(p.Moneda), NULLIF(RTRIM(d.Categoria), ''), ISNULL(d.SueldoDiario, 0.0), ISNULL(d.SDI, 0.0), ISNULL(c.SueldoMinimo, 0.0), ISNULL(c.SueldoMaximo, 0.0), d.FechaAlta, d.FechaAntiguedad, d.SucursalTrabajo, NULLIF(RTRIM(d.Plaza), ''), NULLIF(RTRIM(d.Puesto), ''), NULLIF(RTRIM(d.Departamento), ''), NULLIF(RTRIM(d.CentroCostos), '')
FROM RHD d
JOIN Personal p ON d.Personal = p.Personal
LEFT OUTER JOIN PersonalCat c ON d.Categoria = c.Categoria
WHERE ID = @ID
OPEN crRHVerificar
FETCH NEXT FROM crRHVerificar INTO @Personal, @PersonalEmpresa, @PersonalEstatus, @PersonalMoneda, @PersonalCategoria, @SueldoDiario, @SDI, @SueldoMinimo, @SueldoMaximo, @FechaAlta, @FechaAntiguedad, @SucursalD, @Plaza, @Puesto, @Departamento, @CentroCostos
IF @@ERROR <> 0 SELECT @Ok = 1
IF @@FETCH_STATUS = -1 SELECT @Ok = 60010
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @MovTipo <> 'RH.A' AND @Empresa <> @PersonalEmpresa SELECT @Ok = 45050 ELSE
IF @MovTipo = 'RH.C'  AND @PersonalEstatus NOT IN ('ASPIRANTE', 'BAJA') SELECT @Ok = 55010 ELSE
IF @MovTipo IN ('RH.SA', 'RH.A') AND @PersonalEstatus NOT IN ('ASPIRANTE', 'CANDIDATO', 'BAJA') SELECT @Ok = 55010 ELSE
IF @MovTipo IN ('RH.SM', 'RH.M', 'RH.SINC', 'RH.INC') AND @PersonalEstatus <> 'ALTA' SELECT @Ok = 55020 ELSE
IF @MovTipo IN ('RH.SM', 'RH.M') AND @PersonalMoneda <> @MovMoneda           SELECT @Ok = 55030 ELSE
IF @MovTipo IN ('RH.SB', 'RH.B') AND @PersonalEstatus <> 'ALTA' /** ='BAJA'**/ SELECT @Ok = 55020 ELSE
IF @MovTipo IN ('RH.A', 'RH.M')
BEGIN
IF (@SueldoDiario = 0.0 AND @SDI = 0.0) OR (@SueldoDiario < 0.0 OR @SDI < 0.0) SELECT @Ok = 55040 ELSE
IF @PersonalCategoria IS NOT NULL
IF @SueldoDiario < @SueldoMinimo SELECT @Ok = 55310 ELSE
IF @SueldoDiario > @SueldoMaximo SELECT @Ok = 55320
END
IF @MovTipo = 'RH.B' AND @CfgValidarAF = 'BAJA'
IF EXISTS(SELECT * FROM ActivoF WHERE Empresa = @Empresa AND Responsable = @Personal)
SELECT @Ok = 44160
IF @Ok = 55020
EXEC xpOk_55020 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona: '+RTRIM(@Personal)
IF @CfgControlPlazas = 'AVANZADO' AND @MovTipo in ('RH.A', 'RH.M', 'RH.SA', 'RH.SM', 'RH.C') AND @OK is null
BEGIN
SELECT @PlazaEmpresa = Empresa, @PlazaSucursal = Sucursal, @PlazaEstatus = Estatus, @Tipo = ISNULL(Tipo, 'Definitiva'),
@VigenciaD = VigenciaD, @VigenciaA = VigenciaA, @PlazaAPartirDe = APartirDe,
@PlazaPersonal = NULLIF(RTRIM(Personal), ''), @PlazaPuesto = NULLIF(RTRIM(Puesto), ''), @PlazaDepartamento = NULLIF(RTRIM(Departamento), ''),
@PlazaCentroCostos = NULLIF(RTRIM(CentroCostos), '')
FROM Plaza WHERE Plaza = @Plaza
IF @SubClae NOT IN ('RH.BRP', 'RH.ARP')
BEGIN
IF @Plaza is null
SELECT @Ok = 55400
ELSE
IF @PlazaPersonal is not null AND @PlazaPersonal <> @Personal
SELECT @Ok = 55410, @OkRef = @Personal
/*          ELSE
IF @MovTipo = 'RH.A' AND @PlazaPersonal IS NOT NULL AND (SELECT Estatus FROM Personal WHERE Personal = @PlazaPersonal) = 'ALTA'
SELECT @Ok = 55413, @OkRef = @PlazaPersonal*/
ELSE
IF @PlazaEmpresa <> @Empresa
SELECT @Ok = 10060, @OkRef = 'La Empresa de la Plaza no corresponde. Personal ' + RTRIM(@Personal)
ELSE
IF @PlazaSucursal <> @SucursalD
SELECT @Ok = 10060, @OkRef = 'La Sucursal de la Plaza no corresponde. Personal ' + RTRIM(@Personal)
ELSE
IF @PlazaEstatus <> 'ALTA'
SELECT @Ok = 10060, @OkRef = 'El Estatus de la Plaza ' + RTRIM(@Plaza) + ' es ' + RTRIM(@PlazaEstatus)
ELSE
IF @Tipo = 'Temporal' AND (@FechaAntiguedad > @VigenciaA OR @FechaAntiguedad < @VigenciaD)
SELECT @Ok = 10060, @OkRef = 'Las Vigencias de la Plaza ' + RTRIM(@Plaza) + ' no corresponde a la Fecha Alta'
ELSE
IF /*@MovTipo = 'RH.A' AND */@PlazaAPartirDe is not null AND @FechaAntiguedad < @PlazaAPartirDe
SELECT @Ok = 10060, @OkRef = 'La Antiguedad indicada es anterior a la fecha de Activación de La Plaza ' + RTRIM(@Plaza)
ELSE
IF @PlazaPuesto <> @Puesto OR @PlazaDepartamento <> @Departamento
SELECT @OK = 55420, @OkRef = @Personal
ELSE
IF @PlazaCentroCostos <> @CentroCostos
SELECT @Ok = 10060, @OkRef = 'El Centro de Costos de la Plaza no corresponde con el indicado. Plaza ' + RTRIM(@Plaza)
END
END
END
FETCH NEXT FROM crRHVerificar INTO @Personal, @PersonalEmpresa, @PersonalEstatus, @PersonalMoneda, @PersonalCategoria, @SueldoDiario, @SDI, @SueldoMinimo, @SueldoMaximo, @FechaAlta, @FechaAntiguedad, @SucursalD, @Plaza, @Puesto, @Departamento, @CentroCostos
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crRHVerificar
DEALLOCATE crRHVerificar
END
IF @Ok IS NULL AND @MovTipo = 'RH.E' AND @Evaluacion IS NULL SELECT @Ok = 55360
IF @Ok IS NULL
EXEC xpRHVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @Estatus, @Evaluacion,
@Conexion, @SincroFinal, @Sucursal,
@CfgControlPlazas, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Ok OUTPUT, @OkRef OUTPUT
RETURN
END

