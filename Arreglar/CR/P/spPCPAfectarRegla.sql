SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectarRegla
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
DECLARE
@ReglaID				int,
@ReglaOrden				int,
@ReglaMascara			varchar(50),
@ReglaTipo				varchar(20),
@ReglaDescripcion		varchar(50),
@ReglaOrdenAnt			int,
@ReglaMascaraAnt		varchar(50),
@ReglaTipoAnt			varchar(20),
@ReglaDescripcionAnt	varchar(50),
@Renglon				float
IF (@Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.R')) OR (@Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.ER'))
BEGIN
DECLARE crPCPD CURSOR FOR
SELECT ReglaOrden, ReglaMascara, ReglaTipo, ReglaDescripcion, ReglaOrdenAnt, ReglaMascaraAnt, ReglaTipoAnt, ReglaDescripcionAnt, Renglon
FROM PCPD
WHERE ID = @ID
OPEN crPCPD
FETCH NEXT FROM crPCPD INTO @ReglaOrden, @ReglaMascara, @ReglaTipo, @ReglaDescripcion, @ReglaOrdenAnt, @ReglaMascaraAnt, @ReglaTipoAnt, @ReglaDescripcionAnt, @Renglon
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.R')
BEGIN
INSERT ProyClavePresupuestalRegla (Orden,       Proyecto,  Mascara,       Descripcion,       Tipo,       Estatus)
VALUES (@ReglaOrden, @Proyecto, @ReglaMascara, @ReglaDescripcion, @ReglaTipo, 'Activo')
IF @@ERROR <> 0 SET @Ok = 1
SET @ReglaID = SCOPE_IDENTITY()
IF @Ok IS NULL
BEGIN
INSERT ProyClavePresupuestalReglaVig (ID,       FechaD, FechaA, MascaraFecha)
SELECT  @ReglaID, FechaD, FechaA, MascaraFecha
FROM  PCPDRegla
WHERE  ID = @ID
AND  Renglon = @Renglon
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
UPDATE PCPD SET ReglaID = @ReglaID WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SET @Ok = 1
END
END ELSE IF @Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.ER')
BEGIN
INSERT ProyClavePresupuestalRegla (Orden,          Proyecto,  Mascara,          Descripcion,          Tipo,          Estatus)
VALUES (@ReglaOrdenAnt, @Proyecto, @ReglaMascaraAnt, @ReglaDescripcionAnt, @ReglaTipoAnt, 'Activo')
IF @@ERROR <> 0 SET @Ok = 1
SET @ReglaID = SCOPE_IDENTITY()
IF @Ok IS NULL
BEGIN
INSERT ProyClavePresupuestalReglaVig (ID,       FechaD, FechaA, MascaraFecha)
SELECT  @ReglaID, FechaD, FechaA, MascaraFecha
FROM  PCPDRegla
WHERE  ID = @ID
AND  Renglon = @Renglon
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
UPDATE PCPD SET ReglaID = @ReglaID WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SET @Ok = 1
END
END
FETCH NEXT FROM crPCPD INTO @ReglaOrden, @ReglaMascara, @ReglaTipo, @ReglaDescripcion, @ReglaOrdenAnt, @ReglaMascaraAnt, @ReglaTipoAnt, @ReglaDescripcionAnt, @Renglon
END
CLOSE crPCPD
DEALLOCATE crPCPD
END ELSE IF (@Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.R')) OR (@Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.ER'))
BEGIN
IF @Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.ER')
BEGIN
UPDATE PCPD
SET ReglaOrdenAnt = pcpr.Orden,
ReglaMascaraAnt = pcpr.Mascara,
ReglaTipoAnt = pcpr.Tipo,
ReglaDescripcionAnt = pcpr.Descripcion
FROM ProyClavePresupuestalRegla pcpr JOIN PCPD pd
ON pd.ReglaID = pcpr.RID
WHERE pd.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
DELETE
FROM ProyClavePresupuestalReglaVig
FROM ProyClavePresupuestalReglaVig pcprv JOIN PCPD pd
ON pd.ReglaID = pcprv.ID
WHERE pd.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
DELETE
FROM ProyClavePresupuestalRegla
FROM ProyClavePresupuestalRegla pcpr JOIN PCPD pd
ON pd.ReglaID = pcpr.RID
WHERE pd.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

