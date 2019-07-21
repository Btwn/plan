SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectarClavePresupuestal
@Accion			varchar(20),
@Usuario		varchar(10),
@Fecha			datetime,
@MovTipo		varchar(20),
@ID				int,
@Proyecto		varchar(50),
@Categoria		varchar(1),
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
IF (@Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.CP')) OR (@Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.ECP'))
BEGIN
IF @Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.CP')
BEGIN
INSERT ClavePresupuestal (ClavePresupuestal, Nombre,                  Descripcion,                  Estatus, Alta,   UltimoCambio, UsuarioCambio, Proyecto,  TieneArticulosEsp,             ObjetoGasto)  
SELECT  ClavePresupuestal, ClavePresupuestalNombre, ClavePresupuestalDescripcion, 'ALTA',  @Fecha, @Fecha,       @Usuario,      @Proyecto, ClavePresupuestalArticulosEsp, ObjetoGasto   
FROM  PCPD
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END ELSE IF @Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.ECP')
BEGIN
INSERT ClavePresupuestal (ClavePresupuestal, Nombre,                   Descripcion,                   Estatus, Alta,   UltimoCambio, UsuarioCambio, Proyecto,  TieneArticulosEsp,              ObjetoGasto) 
SELECT  ClavePresupuestal, ClavePresupuestalNombreA, ClavePresupuestalDescripcionA, 'ALTA',  @Fecha, @Fecha,       @Usuario,      @Proyecto, ClavePresupuestalArticulosEspA, ObjetoGastoAnt 
FROM  PCPD
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
END ELSE IF (@Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.CP')) OR (@Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.ECP'))
BEGIN
IF @Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.ECP')
BEGIN
UPDATE PCPD
SET ClavePresupuestalNombreA = cp.Nombre,
ClavePresupuestalDescripcionA = cp.Descripcion,
ClavePresupuestalArticulosEspA = cp.TieneArticulosEsp,
ObjetoGastoAnt = cp.ObjetoGasto
FROM ClavePresupuestal cp JOIN PCPD pd
ON pd.ClavePresupuestal = cp.ClavePresupuestal
WHERE pd.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
DELETE
FROM ClavePresupuestal
FROM ClavePresupuestal cp JOIN PCPD pd
ON pd.ClavePresupuestal = cp.ClavePresupuestal
WHERE pd.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
END

