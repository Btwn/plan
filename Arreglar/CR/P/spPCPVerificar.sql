SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPVerificar
@ID               			int,
@Accion						char(20),
@Empresa          			char(5),
@Usuario					char(10),
@Modulo	      				char(5),
@Mov              			char(20),
@MovID						varchar(20),
@MovTipo	      			char(20),
@MovMoneda					char(10),
@MovTipoCambio				float,
@FechaEmision				datetime,
@Estatus					char(15),
@EstatusNuevo				char(15),
@Conexion					bit,
@SincroFinal				bit,
@Sucursal					int,
@Ok               			int          OUTPUT,
@OkRef            			varchar(255) OUTPUT

AS BEGIN
DECLARE
@Proyecto					varchar(50),
@ClavePresupuestalMascara	varchar(50),
@FechaInicio				datetime,
@FechaFin					datetime,
@Origen	                    varchar(20),
@OrigenID                   varchar(20),
@Categoria					varchar(1),
@CategoriaPredominante		varchar(1),
@SubMovTipo					varchar(20)
SELECT @SubMovTipo = SubClave FROM MovTipo WHERE Modulo = 'PCP' AND Mov = @Mov
SELECT
@Proyecto = Proyecto,
@ClavePresupuestalMascara = ClavePresupuestalMascara,
@FechaInicio = FechaInicio,
@FechaFin = FechaFin,
@Origen = Origen,
@OrigenID = OrigenID,
@Categoria = NULLIF(Categoria,''),
@CategoriaPredominante = NULLIF(CategoriaPredominante,'')
FROM PCP
WHERE ID = @ID
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('PENDIENTE') AND EXISTS(SELECT * FROM PCPD WHERE dbo.fnPCPCatalogoTipoTieneCatalogo(CatalogoTipoTipo,@Proyecto) = 1 AND ID = @ID) AND @Ok IS NULL SELECT @Ok = 73600, @OkRef = CatalogoTipoTipo FROM PCPD WHERE dbo.fnPCPCatalogoTipoTieneCatalogo(CatalogoTipoTipo,@Proyecto) = 1 AND ID = @ID
IF @MovTipo IN ('PCP.CAT') AND @Estatus IN ('CONCLUIDO') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTieneSubCatalogo(pd.CatalogoClave,p.Proyecto,p.Categoria) = 1 AND pd.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73710, @OkRef = pd.CatalogoClave FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTieneSubCatalogo(pd.CatalogoClave,p.Proyecto,p.Categoria) = 1 AND pd.ID = @ID
IF @MovTipo IN ('PCP.PP') AND @Estatus IN ('PENDIENTE') AND EXISTS(SELECT * FROM MovFlujo WHERE OID = @ID AND OModulo = 'PCP' AND ISNULL(Cancelado,0) = 0) AND @Ok IS NULL SELECT @Ok = 73870, @OkRef = ISNULL(@Mov,'') + ' ' + ISNULL(@MovID,'')
END ELSE
IF @Accion = 'AFECTAR'
BEGIN
IF @MovTipo IN ('PCP.PP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM Proy WHERE Proyecto = @Proyecto) SELECT @Ok = 26025, @OkRef = @Proyecto ELSE
IF @MovTipo IN ('PCP.PP','PCP.E','PCP.EA','PCP.CAT','PCP.MC','PCP.EC','PCP.CP','PCP.ECP','PCP.P','PCP.PC','PCP.R','PCP.ER') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @Proyecto IS NULL AND @Ok IS NULL SELECT @Ok = 15010 ELSE
IF @MovTipo IN ('PCP.PP','PCP.E','PCP.EA','PCP.CAT','PCP.MC','PCP.EC','PCP.CP','PCP.ECP','PCP.P','PCP.PC','PCP.R','PCP.ER') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @ClavePresupuestalMascara IS NULL AND @Ok IS NULL SELECT @Ok = 73500 ELSE
IF @MovTipo IN ('PCP.E','PCP.EA','PCP.CAT','PCP.MC','PCP.EC','PCP.CP','PCP.P','PCP.R') AND @SubMovTipo NOT IN ('PCP.CPEX','PCP.REX') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND NOT EXISTS(SELECT * FROM PCP p JOIN MovTipo mt ON mt.Mov = p.Mov AND mt.Modulo = 'PCP' WHERE mt.Clave = 'PCP.PP' AND p.Estatus IN ('PENDIENTE') AND p.Proyecto = @Proyecto) AND @Ok IS NULL SELECT @Ok = 73830, @OkRef = @Proyecto ELSE
IF @MovTipo IN ('PCP.ECP','PCP.ER') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND NOT EXISTS(SELECT * FROM PCP p JOIN MovTipo mt ON mt.Mov = p.Mov AND mt.Modulo = 'PCP' WHERE ((mt.Clave = 'PCP.PP' AND p.Estatus IN ('PENDIENTE')) OR (mt.Clave = 'PCP.P' AND p.Estatus IN ('VIGENTE'))) AND p.Proyecto = @Proyecto) AND @Ok IS NULL SELECT @Ok = 73860, @OkRef = @Proyecto ELSE
IF ((@MovTipo IN ('PCP.CP') AND @SubMovTipo IN ('PCP.CPEX')) OR (@MovTipo IN ('PCP.R') AND @SubMovTipo IN ('PCP.REX')) OR @MovTipo IN ('PCP.PC'))AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND NOT EXISTS(SELECT * FROM PCP p JOIN MovTipo mt ON mt.Mov = p.Mov AND mt.Modulo = 'PCP' WHERE mt.Clave = 'PCP.P' AND p.Estatus IN ('VIGENTE') AND p.Proyecto = @Proyecto) AND @Ok IS NULL SELECT @Ok = 73850, @OkRef = @Proyecto ELSE
IF @MovTipo IN ('PCP.PP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @FechaInicio IS NULL AND @Ok IS NULL SELECT @Ok = 55240 ELSE
IF @MovTipo IN ('PCP.PP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @FechaFin IS NULL AND @Ok IS NULL SELECT @Ok = 55240 ELSE
IF @MovTipo IN ('PCP.PP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @FechaInicio > @FechaFin AND @Ok IS NULL SELECT @Ok = 55090 ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCP p JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'PCP' WHERE mt.Clave = 'PCP.E' AND p.Estatus IN ('PENDIENTE','CONCLUIDO') AND p.Origen = @Origen AND p.OrigenID = @OrigenID AND p.Categoria = @Categoria) AND @Ok IS NULL SELECT @Ok = 73510, @OkRef = @Categoria ELSE
IF @MovTipo IN ('PCP.E','PCP.CAT','PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @Categoria IS NULL AND @Ok IS NULL SELECT @Ok = 73530
IF @MovTipo IN ('PCP.E''PCP.CAT','PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND dbo.fnPCPCategoriaEnMascara(@Categoria,@ClavePresupuestalMascara) = 0 AND @Ok IS NULL SELECT @Ok = 73520, @OkRef = @Categoria ELSE
IF @MovTipo IN ('PCP.PP','PCP.CP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND @CategoriaPredominante IS NULL AND @Ok IS NULL SELECT @Ok = 73530
IF @MovTipo IN ('PCP.PP''PCP.CP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND dbo.fnPCPCategoriaEnMascara(@CategoriaPredominante,@ClavePresupuestalMascara) = 0 AND @Ok IS NULL SELECT @Ok = 73520, @OkRef = @Categoria ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND CatalogoTipoTipo = CatalogoTipoRama) AND @Ok IS NULL SELECT @Ok = 73540, @OkRef = CatalogoTipoTipo FROM  PCPD WHERE ID = @ID AND CatalogoTipoTipo = CatalogoTipoRama ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND NULLIF(CatalogoTipoDigitos,0) IS NULL) AND @Ok IS NULL SELECT @Ok = 73550, @OkRef = CatalogoTipoTipo FROM  PCPD WHERE ID = @ID AND NULLIF(CatalogoTipoDigitos,0) IS NULL ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND NULLIF(CatalogoTipoValidacion,'') IS NULL) AND @Ok IS NULL SELECT @Ok = 73560, @OkRef = CatalogoTipoTipo FROM  PCPD WHERE ID = @ID AND NULLIF(CatalogoTipoValidacion,'') IS NULL ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND CatalogoTipoValidacion NOT IN ('Numerico','Alfabetico','Alfanumerico','Abierto')) AND @Ok IS NULL SELECT @Ok = 73570, @OkRef = CatalogoTipoTipo FROM  PCPD WHERE ID = @ID AND CatalogoTipoValidacion NOT IN ('Numerico','Alfabetico','Alfanumerico','Abierto') ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND dbo.fnPCPValidarDigitosCatalogoEnMascara(@Categoria,CatalogoTipoDigitos,@ClavePresupuestalMascara) = 0) AND @Ok IS NULL SELECT @Ok = 73550, @OkRef = CatalogoTipoTipo FROM PCPD WHERE ID = @ID AND dbo.fnPCPValidarDigitosCatalogoEnMascara(@Categoria,CatalogoTipoDigitos,@ClavePresupuestalMascara) = 0 ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTipoExistente(pd.CatalogoTipoTipo,p.Proyecto) = 1 AND pd.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73580, @OkRef = pd.CatalogoTipoTipo FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTipoExistente(pd.CatalogoTipoTipo,p.Proyecto) = 1 AND pd.ID = @ID ELSE
IF @MovTipo IN ('PCP.E') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND NULLIF(CatalogoTipoRama,'') IS NOT NULL AND NULLIF(CatalogoTipoRama,'') NOT IN (SELECT CatalogoTipoTipo FROM PCPD WHERE ID = @ID)) AND @Ok IS NULL SELECT @Ok = 73590, @OkRef = CatalogoTipoTipo FROM PCPD WHERE ID = @ID AND NULLIF(CatalogoTipoRama,'') IS NOT NULL AND NULLIF(CatalogoTipoRama,'') NOT IN (SELECT CatalogoTipoTipo FROM PCPD WHERE ID = @ID) ELSE
IF @MovTipo IN ('PCP.E','PCP.EA','PCP.CAT','PCP.MC','PCP.EC','PCP.CP','PCP.EC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND NOT EXISTS(SELECT * FROM PCPD WHERE ID = @ID) AND @Ok IS NULL SELECT @Ok = 73610 ELSE
IF @MovTipo IN ('PCP.E','PCP.EA') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT TOP 1 COUNT(*) FROM PCPD WHERE ID = @ID GROUP BY CatalogoTipoTipo HAVING COUNT(*) > 1) AND @Ok IS NULL SELECT TOP 1 @Ok = 73620, @OkRef = CatalogoTipoTipo FROM PCPD WHERE ID = @ID GROUP BY CatalogoTipoTipo HAVING COUNT(*) > 1 ELSE
IF @MovTipo IN ('PCP.CAT','PCP.MC','PCP.EC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ISNULL(NULLIF(CatalogoTipo,''),'') = '' AND ID = @ID) AND @Ok IS NULL SELECT @Ok = 73650, @OkRef = CatalogoClave FROM PCPD WHERE ISNULL(NULLIF(CatalogoTipo,''),'') = '' AND ID = @ID ELSE
IF @MovTipo IN ('PCP.CAT','PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTipoExistente(pd.CatalogoTipo,p.Proyecto) = 0 AND p.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73630, @OkRef = pd.CatalogoTipo FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTipoExistente(pd.CatalogoTipo,p.Proyecto) = 0 AND p.ID = @ID
IF @MovTipo IN ('PCP.CAT') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPValidarClaveCatalogo(pd.CatalogoClave,pd.CatalogoTipo,p.Proyecto) = 0 AND p.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73550, @OkRef = pd.CatalogoTipo FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPValidarClaveCatalogo(pd.CatalogoClave,pd.CatalogoTipo,p.Proyecto) = 0 AND p.ID = @ID ELSE
IF @MovTipo IN ('PCP.CAT') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID LEFT OUTER JOIN PCPD pd2 ON NULLIF(pd.CatalogoRama,'') = pd2.CatalogoClave AND pd2.ID = pd.ID LEFT OUTER JOIN ClavePresupuestalCatalogo cpc ON cpc.Clave = pd.CatalogoRama and cpc.Proyecto = p.Proyecto WHERE NULLIF(pd.CatalogoRama,'') IS NOT NULL AND pd2.CatalogoClave IS NULL AND cpc.Clave IS NULL AND p.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73690, @OkRef = PD.CatalogoRama FROM PCPD pd JOIN PCP p ON p.ID = pd.ID LEFT OUTER JOIN PCPD pd2 ON NULLIF(pd.CatalogoRama,'') = pd2.CatalogoClave AND pd2.ID = pd.ID LEFT OUTER JOIN ClavePresupuestalCatalogo cpc ON cpc.Clave = pd.CatalogoRama and cpc.Proyecto = p.Proyecto WHERE NULLIF(pd.CatalogoRama,'') IS NOT NULL AND pd2.CatalogoClave IS NULL AND cpc.Clave IS NULL AND p.ID = @ID ELSE
IF @MovTipo IN ('PCP.CAT','PCP.MC','PCP.EC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT TOP 1 COUNT(*) FROM PCPD WHERE ID = @ID GROUP BY CatalogoClave HAVING COUNT(*) > 1) AND @Ok IS NULL SELECT TOP 1 @Ok = 73640, @OkRef = CatalogoClave FROM PCPD WHERE ID = @ID GROUP BY CatalogoClave HAVING COUNT(*) > 1 ELSE
IF @MovTipo IN ('PCP.CAT','PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTipoCategoria(pd.Catalogotipo,p.Proyecto) <> p.Categoria AND p.ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73520, @OkRef = p.Categoria FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTipoCategoria(pd.Catalogotipo,p.Proyecto) <> p.Categoria AND p.ID = @ID ELSE
IF @MovTipo IN ('PCP.CAT') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ID = @ID AND CatalogoClave = CatalogoRama) AND @Ok IS NULL SELECT @Ok = 73670, @OkRef = CatalogoClave FROM  PCPD WHERE ID = @ID AND CatalogoClave = CatalogoRama ELSE
IF @MovTipo IN ('PCP.CAT') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoExistente(pd.CatalogoClave,p.Proyecto,p.Categoria) = 1 AND pd.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73680, @OkRef = pd.CatalogoClave FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoExistente(pd.CatalogoClave,p.Proyecto,p.Categoria) = 1 AND pd.ID = @ID ELSE
IF @MovTipo IN ('PCP.EC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTieneSubCatalogo(pd.CatalogoClave,p.Proyecto,p.Categoria) = 1 AND pd.ID = @ID) AND @Ok IS NULL SELECT @Ok = 73710, @OkRef = pd.CatalogoClave FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPCatalogoTieneSubCatalogo(pd.CatalogoClave,p.Proyecto,p.Categoria) = 1 AND pd.ID = @ID ELSE
IF @MovTipo IN ('PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE pd.CatalogoTipo <> dbo.fnPCPCatalogoTipo(p.Proyecto,pd.CatalogoClave) AND p.ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73720, @OkRef = pd.CatalogoClave FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE pd.CatalogoTipo <> dbo.fnPCPCatalogoTipo(p.Proyecto,pd.CatalogoClave) AND p.ID = @ID ELSE
IF @MovTipo IN ('PCP.CP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPValidarClavePresupuestal(p.Proyecto,p.ClavePresupuestalMascara,pd.ClavePresupuestal) = 0 AND p.ID = @ID)  AND @Ok IS NULL SELECT @Ok = 73730, @OkRef = pd.ClavePresupuestal FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPValidarClavePresupuestal(p.Proyecto,p.ClavePresupuestalMascara,pd.ClavePresupuestal) = 0 AND p.ID = @ID ELSE
IF @MovTipo IN ('PCP.CP','PCP.ECP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT TOP 1 COUNT(*) FROM PCPD WHERE ID = @ID GROUP BY ClavePresupuestal HAVING COUNT(*) > 1) AND @Ok IS NULL SELECT TOP 1 @Ok = 73740, @OkRef = ClavePresupuestal FROM PCPD WHERE ID = @ID GROUP BY ClavePresupuestal HAVING COUNT(*) > 1 ELSE
IF @MovTipo IN ('PCP.ECP') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE dbo.fnPCPClavePresupuestalExistente(ClavePresupuestal) = 0 AND ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73760, @OkRef = ClavePresupuestal FROM PCPD WHERE dbo.fnPCPClavePresupuestalExistente(ClavePresupuestal) = 0 AND ID = @ID
IF @MovTipo IN ('PCP.R') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT TOP 1 COUNT(*) FROM PCPD WHERE ID = @ID GROUP BY ReglaDescripcion HAVING COUNT(*) > 1) AND @Ok IS NULL SELECT TOP 1 @Ok = 73770, @OkRef = ReglaDescripcion FROM PCPD WHERE ID = @ID GROUP BY ReglaDescripcion HAVING COUNT(*) > 1 ELSE
IF @MovTipo IN ('PCP.R') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPValidarMascaraRegla(p.Proyecto,p.ClavePresupuestalMascara,pd.ReglaMascara) = 0 AND p.ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73780, @OkRef = pd.ReglaMascara FROM PCPD pd JOIN PCP p ON p.ID = pd.ID WHERE dbo.fnPCPValidarMascaraRegla(p.Proyecto,p.ClavePresupuestalMascara,pd.ReglaMascara) = 0 AND p.ID = @ID ELSE
IF @MovTipo IN ('PCP.R') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD WHERE ReglaTipo NOT IN ('Incluyente','Excluyente') AND ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73790, @OkRef = ReglaDescripcion FROM PCPD WHERE ReglaTipo NOT IN ('Incluyente','Excluyente') AND ID = @ID ELSE
IF @MovTipo IN ('PCP.R') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCPDRegla pdr ON pdr.ID = pd.ID AND pdr.Renglon = pd.Renglon WHERE ((pdr.FechaD IS NULL AND pdr.FechaA IS NOT NULL) OR (pdr.FechaD IS NOT NULL AND pdr.FechaA IS NULL)) AND pd.ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73800, @OkRef = ReglaDescripcion FROM PCPD pd JOIN PCPDRegla pdr ON pdr.ID = pd.ID AND pdr.Renglon = pd.Renglon WHERE  ((pdr.FechaD IS NULL AND pdr.FechaA IS NOT NULL) OR (pdr.FechaD IS NOT NULL AND pdr.FechaA IS NULL)) AND pd.ID = @ID ELSE
IF @MovTipo IN ('PCP.R') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCPDRegla pdr ON pdr.ID = pd.ID AND pdr.Renglon = pd.Renglon WHERE pdr.FechaD > pdr.FechaA AND pd.ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73800, @OkRef = ReglaDescripcion FROM PCPD pd JOIN PCPDRegla pdr ON pdr.ID = pd.ID AND pdr.Renglon = pd.Renglon WHERE pdr.FechaD > pdr.FechaA AND pd.ID = @ID ELSE
IF @MovTipo IN ('PCP.ER') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT * FROM PCPD pd JOIN PCP p ON p.ID = pd.ID LEFT OUTER JOIN ProyClavePresupuestalRegla pcpr ON pd.ReglaID = pcpr.RID AND p.Proyecto = pcpr.Proyecto WHERE pcpr.RID IS NULL AND pd.ID = @ID) AND @Ok IS NULL SELECT TOP 1 @Ok = 73810, @OkRef = ReglaID FROM PCPD pd JOIN PCP p ON p.ID = pd.ID LEFT OUTER JOIN ProyClavePresupuestalRegla pcpr ON pd.ReglaID = pcpr.RID AND p.Proyecto = pcpr.Proyecto WHERE pcpr.RID IS NULL AND pd.ID = @ID ELSE
IF @MovTipo IN ('PCP.ER') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND EXISTS(SELECT TOP 1 COUNT(*) FROM PCPD WHERE ID = @ID GROUP BY ReglaID HAVING COUNT(*) > 1) AND @Ok IS NULL SELECT TOP 1 @Ok = 73820, @OkRef = ReglaID FROM PCPD WHERE ID = @ID GROUP BY ReglaID HAVING COUNT(*) > 1
IF @MovTipo IN ('PCP.EA') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND
EXISTS(SELECT
*
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID LEFT OUTER JOIN PCP o
ON o.Mov = pd.Aplica AND o.MovID = pd.AplicaID AND o.Empresa = p.Empresa AND o.Estatus = 'PENDIENTE' LEFT OUTER JOIN PCPD od
ON od.CatalogoTipoTipo = pd.CatalogoTipoTipo AND od.ID = o.ID AND od.Estatus = 'PENDIENTE' LEFT OUTER JOIN MovTipo mt
ON mt.Mov = o.Mov AND mt.Modulo = 'PCP'
WHERE mt.Clave = 'PCP.E'
AND (od.CatalogoTipoTipo IS NULL OR (pd.Aplica <> ISNULL(p.Origen,pd.Aplica) OR pd.AplicaID <> ISNULL(p.OrigenID,pd.AplicaID)))
AND p.ID = @ID) AND
@Ok IS NULL
SELECT
TOP 1 @Ok = 20180,
@OkRef = pd.CatalogoTipoTipo
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID LEFT OUTER JOIN PCP o
ON o.Mov = pd.Aplica AND o.MovID = pd.AplicaID AND o.Empresa = p.Empresa AND o.Estatus = 'PENDIENTE' LEFT OUTER JOIN PCPD od
ON od.CatalogoTipoTipo = pd.CatalogoTipoTipo AND od.ID = o.ID AND od.Estatus = 'PENDIENTE' LEFT OUTER JOIN MovTipo mt
ON mt.Mov = o.Mov AND mt.Modulo = 'PCP'
WHERE mt.Clave = 'PCP.E'
AND (od.CatalogoTipoTipo IS NULL OR (pd.Aplica <> ISNULL(p.Origen,pd.Aplica) OR pd.AplicaID <> ISNULL(p.OrigenID,pd.AplicaID)))
AND p.ID = @ID
IF @MovTipo IN ('PCP.CAT','PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND
NOT EXISTS(SELECT
*
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID LEFT OUTER JOIN PCP o
ON o.Proyecto = p.Proyecto AND o.Categoria = p.Categoria AND o.Empresa = p.Empresa AND o.Estatus = 'PENDIENTE' LEFT OUTER JOIN MovTipo mt
ON mt.Mov = o.Mov AND mt.Modulo = 'PCP'
WHERE mt.Clave = 'PCP.E'
AND p.ID = @ID) AND
@Ok IS NULL
SELECT @Ok = 73700
IF @MovTipo IN ('PCP.CAT','PCP.EC','PCP.MC') AND @Estatus IN ('SINAFECTAR','CONFIRMAR','BORRADOR') AND
EXISTS(SELECT
*
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID LEFT OUTER JOIN PCP o
ON o.Proyecto = p.Proyecto AND o.Categoria = p.Categoria AND o.Empresa = p.Empresa AND o.Estatus = 'PENDIENTE' LEFT OUTER JOIN PCPD od
ON od.CatalogoTipoTipo = pd.CatalogoTipo AND od.ID = o.ID AND od.Estatus = 'PENDIENTE' LEFT OUTER JOIN MovTipo mt
ON mt.Mov = o.Mov AND mt.Modulo = 'PCP'
WHERE mt.Clave = 'PCP.E'
AND od.CatalogoTipoTipo IS NULL
AND p.ID = @ID) AND
@Ok IS NULL
SELECT
TOP 1 @Ok = 73700,
@OkRef = pd.CatalogoTipo
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID LEFT OUTER JOIN PCP o
ON o.Proyecto = p.Proyecto AND o.Categoria = p.Categoria AND o.Empresa = p.Empresa AND o.Estatus = 'PENDIENTE' LEFT OUTER JOIN PCPD od
ON od.CatalogoTipoTipo = pd.CatalogoTipo AND od.ID = o.ID AND od.Estatus = 'PENDIENTE' LEFT OUTER JOIN MovTipo mt
ON mt.Mov = o.Mov AND mt.Modulo = 'PCP'
WHERE mt.Clave = 'PCP.E'
AND od.CatalogoTipoTipo IS NULL
AND p.ID = @ID
END
RETURN
END

