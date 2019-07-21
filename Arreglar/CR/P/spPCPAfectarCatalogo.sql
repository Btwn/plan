SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectarCatalogo
@Accion		varchar(20),
@MovTipo	varchar(20),
@ID			int,
@Proyecto	varchar(50),
@Categoria	varchar(1),
@Ok			int = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ProcesoTerminado				bit,
@CatalogoClave					varchar(20),
@CatalogoRama					varchar(20),
@CatalogoTipo					varchar(50),
@CatalogoRamaTipo				varchar(50),
@CatalogoNombre					varchar(50),
@CatalogoTechoPresupuesto		money,
@CatalogoDescripcion			varchar(255),
@CatalogoObservaciones			varchar(255),
@CatalogoRID					int,
@Procesado						bit,
@RID							varchar(20),
@Orden							int
SELECT @ProcesoTerminado = 0
IF (@Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.CAT')) OR (@Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.EC'))
BEGIN
DECLARE @PCPD TABLE
(
CatalogoClave					varchar(20),
CatalogoRama					varchar(20),
CatalogoTipo					varchar(50),
CatalogoRamaTipo				varchar(50),
CatalogoNombre					varchar(50),
CatalogoTechoPresupuesto		money,
CatalogoDescripcion			varchar(255),
CatalogoObservaciones			varchar(255),
CatalogoRID					int,
Procesado						bit,
Orden							int identity(1,1)
)
IF @MovTipo IN ('PCP.CAT') AND @Accion IN ('AFECTAR')
BEGIN
INSERT @PCPD (CatalogoClave, CatalogoRama, CatalogoTipo, CatalogoRamaTipo, CatalogoNombre, CatalogoTechoPresupuesto, CatalogoDescripcion, CatalogoObservaciones, CatalogoRID, Procesado)
SELECT  CatalogoClave, CatalogoRama, CatalogoTipo, CatalogoRamaTipo, CatalogoNombre, CatalogoTechoPresupuesto, CatalogoDescripcion, CatalogoObservaciones, CatalogoRID, 0
FROM PCPD
WHERE ID = @ID
END ELSE IF @MovTipo IN ('PCP.EC') AND @Accion IN ('CANCELAR') BEGIN
INSERT @PCPD (CatalogoClave, CatalogoRama, CatalogoTipo, CatalogoRamaTipo, CatalogoNombre,         CatalogoTechoPresupuesto,    CatalogoDescripcion,         CatalogoObservaciones,         CatalogoRID, Procesado)
SELECT  CatalogoClave, CatalogoRama, CatalogoTipo, CatalogoRamaTipo, CatalogoNombreAnterior, CatalogoTechoPresupuestoAnt, CatalogoDescripcionAnterior, CatalogoObservacionesAnterior, CatalogoRID, 0
FROM PCPD
WHERE ID = @ID
END
WHILE @ProcesoTerminado = 0 AND @Ok IS NULL
BEGIN
SET @CatalogoClave = NULL
SELECT TOP 1 @CatalogoClave = CatalogoClave, @CatalogoRama = NULLIF(CatalogoRama,''), @CatalogoTipo = CatalogoTipo, @CatalogoRamaTipo = CatalogoRamaTipo, @CatalogoNombre = CatalogoNombre, @CatalogoTechoPresupuesto = CatalogoTechoPresupuesto, @CatalogoDescripcion = CatalogoDescripcion, @CatalogoObservaciones = CatalogoObservaciones, @CatalogoRID = CatalogoRID, @Procesado = Procesado, @Orden = Orden FROM @PCPD WHERE Procesado = 0 ORDER BY Orden
IF @CatalogoClave IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM ClavePresupuestalCatalogo WHERE  Proyecto = @Proyecto AND Clave = @CatalogoRama) OR @CatalogoRama IS NULL
BEGIN
SELECT @RID = CONVERT(varchar(20),RID) FROM ClavePresupuestalCatalogo WHERE Proyecto = @Proyecto AND Clave = @CatalogoRama
INSERT ClavePresupuestalCatalogo (Proyecto,  Clave,          Tipo,          Rama,            Nombre,          TechoPresupuesto,          Descripcion,          Observaciones,          Categoria,  RamaTipo)
VALUES (@Proyecto, @CatalogoClave, @CatalogoTipo, ISNULL(@RID,''), @CatalogoNombre, @CatalogoTechoPresupuesto, @CatalogoDescripcion, @CatalogoObservaciones, @Categoria, ISNULL(dbo.fnPCPCatalogoTipoRama(@Proyecto,@CatalogoTipo),''))
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL UPDATE @PCPD SET Procesado = 1 WHERE CatalogoClave = @CatalogoClave
IF @@ERROR <> 0 SET @Ok = 1
END ELSE
BEGIN
IF @Ok IS NULL
BEGIN
INSERT @PCPD (CatalogoClave,  CatalogoRama,  CatalogoTipo,  CatalogoRamaTipo,  CatalogoNombre,  CatalogoTechoPresupuesto,  CatalogoDescripcion,  CatalogoObservaciones,  CatalogoRID,  Procesado)
VALUES       (@CatalogoClave, @CatalogoRama, @CatalogoTipo, @CatalogoRamaTipo, @CatalogoNombre, @CatalogoTechoPresupuesto, @CatalogoDescripcion, @CatalogoObservaciones, @CatalogoRID, 0)
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE FROM @PCPD WHERE Orden = @Orden
END
END
END ELSE
IF @CatalogoClave IS NULL
SELECT @ProcesoTerminado = 1
END
END ELSE
IF (@Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.CAT')) OR (@Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.EC'))
BEGIN
IF @Ok IS NULL
BEGIN
UPDATE PCPD
SET CatalogoNombreAnterior = cpc.Nombre,
CatalogoDescripcionAnterior = cpc.Descripcion,
CatalogoObservacionesAnterior = cpc.Observaciones,
CatalogoTechoPresupuestoAnt = cpc.TechoPresupuesto,
CatalogoRama = dbo.fnPCPCatalogoClave(cpc.Rama)
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID JOIN ClavePresupuestalCatalogo cpc
ON cpc.Clave = pd.CatalogoClave AND cpc.Proyecto = p.Proyecto
WHERE p.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
DELETE
FROM ClavePresupuestalCatalogo
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID JOIN ClavePresupuestalCatalogo cpc
ON cpc.Clave = pd.CatalogoClave AND cpc.Proyecto = p.Proyecto
WHERE p.ID = @ID
END
END
END ELSE
IF @Accion IN ('AFECTAR','CANCELAR') AND @MovTipo IN ('PCP.MC')
BEGIN
IF @Accion IN ('AFECTAR')
BEGIN
IF @Ok IS NULL
BEGIN
UPDATE PCPD
SET CatalogoNombreAnterior = cpc.Nombre,
CatalogoDescripcionAnterior = cpc.Descripcion,
CatalogoObservacionesAnterior = cpc.Observaciones,
CatalogoTechoPresupuestoAnt = cpc.TechoPresupuesto
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID JOIN ClavePresupuestalCatalogo cpc
ON cpc.Clave = pd.CatalogoClave AND cpc.Proyecto = p.Proyecto
WHERE p.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
UPDATE ClavePresupuestalCatalogo
SET Nombre = pd.CatalogoNombre,
TechoPresupuesto = pd.CatalogoTechoPresupuesto,
Descripcion = pd.CatalogoDescripcion,
Observaciones = pd.CatalogoObservaciones
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID JOIN ClavePresupuestalCatalogo cpc
ON cpc.Clave = pd.CatalogoClave AND cpc.Proyecto = p.Proyecto
WHERE p.ID = @ID
END
END
END ELSE IF @Accion IN ('CANCELAR') BEGIN
IF @Ok IS NULL
BEGIN
UPDATE ClavePresupuestalCatalogo
SET Nombre = pd.CatalogoNombreAnterior,
TechoPresupuesto = pd.CatalogoTechoPresupuestoAnt,
Descripcion = pd.CatalogoDescripcionAnterior,
Observaciones = pd.CatalogoObservacionesAnterior
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID JOIN ClavePresupuestalCatalogo cpc
ON cpc.Clave = pd.CatalogoClave AND cpc.Proyecto = p.Proyecto
WHERE p.ID = @ID
END
END
END
END

