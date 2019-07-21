SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReclutaVerificar
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
@EstatusNuevo		char(15),
@Personal			varchar(10),
@Puesto			varchar(50),
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenEstatus		varchar(15),
@OrigenMovTipo		varchar(20),
@IDOrigen			int,
@OrigenPersonal		varchar(10),
@OrigenPuesto		varchar(50),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Tipo		varchar(50),
@Peso		float
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF @MovTipo = 'RE.SCO'
BEGIN
IF EXISTS(SELECT * FROM ReclutaPlaza WHERE ID = @ID AND EstaPendiente = 0)
SELECT @Ok = 40290
END
END ELSE
BEGIN
IF @Ok IS NULL
BEGIN
IF @MovTipo IN ('RE.SCO')
IF (SELECT SUM(Peso) FROM ReclutaCompetenciaTipo WHERE ID = @ID)<>100
SELECT @Ok = 40330
IF @MovTipo IN ('RE.SCO', 'RE.AP', 'RE.RCO', 'RE.CO') AND NOT EXISTS(SELECT * FROM ReclutaPlaza WHERE ID = @ID)
SELECT @Ok = 40250
IF @MovTipo IN ('RE.ECO', 'RE.CO', 'RE.SEV', 'RE.EV') AND @Personal IS NULL AND @Ok IS NULL
SELECT @Ok = 40025
IF @Puesto IS NULL AND @Ok IS NULL
SELECT @Ok = 40260
IF @MovTipo IN ('RE.ECO', 'RE.CO', 'RE.RCO') AND @Ok IS NULL
BEGIN
IF @OrigenMovTipo <> 'RE.SCO' AND @OrigenEstatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA')
SELECT @Ok = 20380, @OkRef = @Origen+' '+@OrigenID
END
IF @MovTipo IN ('RE.EV') AND @Ok IS NULL
BEGIN
IF @OrigenMovTipo NOT IN ('RE.SCO', 'RE.SEV') AND @OrigenEstatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA')
SELECT @Ok = 20380, @OkRef = @Origen+' '+@OrigenID
END
IF @MovTipo IN ('RE.CO', 'RE.AP', 'RE.RCO') AND @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
SELECT @OkRef = MIN(Plaza)
FROM ReclutaPlaza
WHERE ID = @ID AND Plaza NOT IN (SELECT Plaza FROM ReclutaPlaza WHERE ID = @IDOrigen AND EstaPendiente = 1)
IF @OkRef IS NOT NULL
SELECT @Ok = 20380
IF @Ok IS NULL AND @MovTipo NOT IN ('RE.AP', 'RE.RCO')
IF (SELECT COUNT(*) FROM ReclutaPlaza WHERE ID = @ID)>1
SELECT @Ok = 40320
END
IF @MovTipo IN ('RE.ECO', 'RE.CO', 'RE.EV', 'RE.AP', 'RE.RCO') AND @Ok IS NULL
BEGIN
IF ISNULL(@Puesto, '') <> ISNULL(@OrigenPuesto, '')
SELECT @Ok = 20380, @OkRef = @Puesto
IF ISNULL(@Personal, '') <> ISNULL(@OrigenPersonal, '') AND @MovTipo = 'RE.EV'
SELECT @Ok = 20380, @OkRef = @Personal
END
IF @MovTipo = 'RE.SCO' AND @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
SELECT @OkRef = MIN(rp.Plaza)
FROM ReclutaPlaza rp
JOIN Plaza p ON p.Plaza = rp.Plaza
WHERE rp.ID = @ID AND p.Puesto <> @Puesto
IF @OkRef IS NOT NULL
SELECT @Ok = 40300
ELSE
BEGIN
SELECT @OkRef = MIN(rp.Plaza)
FROM ReclutaPlaza rp
JOIN Recluta r ON r.ID = rp.ID
WHERE r.Empresa = @Empresa AND r.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA') AND rp.EstaPendiente = 1
AND rp.Plaza IN (SELECT Plaza FROM ReclutaPlaza WHERE ID = @ID)
IF @OkRef IS NOT NULL
SELECT @Ok = 40310
END
END
END
IF @MovTipo = 'RE.AP' AND @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
IF @Accion = 'AFECTAR'
BEGIN
SELECT @OkRef = MIN(rp.Plaza)
FROM ReclutaPlaza rp
JOIN Plaza p ON p.Plaza = rp.Plaza
WHERE rp.ID = @ID AND p.Estatus NOT LIKE 'AUTORIZAR%'
IF @OkRef IS NOT NULL
SELECT @Ok = 40270
END ELSE
IF @Accion = 'CANCELAR'
BEGIN
SELECT @OkRef = MIN(rp.Plaza)
FROM ReclutaPlaza rp
JOIN Plaza p ON p.Plaza = rp.Plaza
WHERE rp.ID = @ID AND p.Estatus <> 'ALTA'
IF @OkRef IS NOT NULL
SELECT @Ok = 40280
END
END
IF @Ok IS NULL
BEGIN
SELECT @Tipo = NULL
SELECT TOP(1) @Tipo = c.Tipo, @Peso = SUM(d.Peso)
FROM ReclutaD d
JOIN Competencia c ON c.Competencia = d.Competencia
WHERE d.ID = @ID
GROUP BY c.Tipo
HAVING SUM(d.Peso) <> 100.0
IF @Tipo IS NOT NULL SELECT @Ok = 40240, @OkRef = @Tipo
END
IF @MovTipo IN ('RE.ECO', 'RE.CO', 'RE.EV') AND @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
SELECT @OkRef = MIN(Competencia)
FROM ReclutaD
WHERE ID = @IDOrigen
AND Competencia NOT IN (SELECT Competencia FROM ReclutaD WHERE ID = @ID)
IF @OkRef IS NOT NULL
SELECT @Ok = 40340
IF @Ok IS NULL
BEGIN
SELECT @OkRef = MIN(o.Competencia)
FROM ReclutaD o
JOIN ReclutaD d ON d.ID = @ID AND d.Competencia = o.Competencia
WHERE o.ID = @IDOrigen
AND (ISNULL(d.ValorMinimo, 0) <> ISNULL(o.ValorMinimo, 0) OR ISNULL(d.Peso, 0) <> ISNULL(o.Peso, 0))
IF @OkRef IS NOT NULL
SELECT @Ok = 40350
END
IF @Ok IS NULL
BEGIN
SELECT @OkRef = MIN(Competencia)
FROM ReclutaD
WHERE ID = @ID
AND Valor IS NULL
IF @OkRef IS NOT NULL
SELECT @Ok = 40360
END
END
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM ReclutaD WHERE ID = @ID)
SELECT @Ok = 60010
END
END
RETURN
END

