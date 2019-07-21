SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectarCatalogoTipo
@Accion		varchar(20),
@ID			int,
@Proyecto	varchar(50),
@Categoria	varchar(1),
@Ok			int = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ProcesoTerminado				bit,
@CatalogoTipoTipo				varchar(50),
@CatalogoTipoRama				varchar(50),
@CatalogoTipoDigitos			int,
@CatalogoTipoValidacion			varchar(50),
@CatalogoTipoEsAcumulativa		bit,
@CatalogoTipoTechoPresupuesto	bit,
@Procesado						bit,
@Orden							int
SELECT @ProcesoTerminado = 0
IF @Accion IN ('AFECTAR')
BEGIN
DECLARE @PCPD TABLE
(
CatalogoTipoTipo				varchar(50),
CatalogoTipoRama				varchar(50),
CatalogoTipoDigitos			int,
CatalogoTipoValidacion			varchar(50),
CatalogoTipoEsAcumulativa		bit,
CatalogoTipoTechoPresupuesto	bit,
Procesado						bit,
Orden							int identity(1,1)
)
INSERT @PCPD (CatalogoTipoTipo, CatalogoTipoRama, CatalogoTipoDigitos, CatalogoTipoValidacion, CatalogoTipoEsAcumulativa, CatalogoTipoTechoPresupuesto, Procesado)
SELECT  CatalogoTipoTipo, CatalogoTipoRama, CatalogoTipoDigitos, CatalogoTipoValidacion, CatalogoTipoEsAcumulativa, CatalogoTipoTechoPresupuesto, 0
FROM PCPD
WHERE ID = @ID
WHILE @ProcesoTerminado = 0 AND @Ok IS NULL
BEGIN
SET @CatalogoTipoTipo = NULL
SELECT TOP 1 @CatalogoTipoTipo = CatalogoTipoTipo, @CatalogoTipoRama = NULLIF(CatalogoTipoRama,''), @CatalogoTipoDigitos = CatalogoTipoDigitos, @CatalogoTipoValidacion = CatalogoTipoValidacion, @CatalogoTipoEsAcumulativa = CatalogoTipoEsAcumulativa, @CatalogoTipoTechoPresupuesto = CatalogoTipoTechoPresupuesto, @Orden = Orden FROM @PCPD WHERE Procesado = 0 ORDER BY Orden
IF @CatalogoTipoTipo IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM ClavePresupuestalCatalogoTipo WHERE  Proyecto = @Proyecto AND Tipo = @CatalogoTipoRama) OR @CatalogoTipoRama IS NULL
BEGIN
INSERT ClavePresupuestalCatalogoTipo (Proyecto,  Tipo,              Categoria,  Digitos,              Rama,              TechoPresupuesto,              EsAcumulativa,                                                                                      Validacion)
SELECT  @Proyecto, @CatalogoTipoTipo, @Categoria, @CatalogoTipoDigitos, @CatalogoTipoRama, @CatalogoTipoTechoPresupuesto, CASE WHEN EXISTS(SELECT * FROM @PCPD WHERE CatalogoTipoRama = @CatalogoTipoTipo) THEN 1 ELSE 0 END, @CatalogoTipoValidacion
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL UPDATE @PCPD SET Procesado = 1 WHERE CatalogoTipoTipo = @CatalogoTipoTipo
IF @@ERROR <> 0 SET @Ok = 1
END ELSE
BEGIN
IF @Ok IS NULL
BEGIN
INSERT @PCPD (CatalogoTipoTipo,  CatalogoTipoRama,  CatalogoTipoDigitos,  CatalogoTipoValidacion,  CatalogoTipoEsAcumulativa,  CatalogoTipoTechoPresupuesto,  Procesado)
VALUES       (@CatalogoTipoTipo, @CatalogoTipoRama, @CatalogoTipoDigitos, @CatalogoTipoValidacion, @CatalogoTipoEsAcumulativa, @CatalogoTipoTechoPresupuesto, 0)
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE FROM @PCPD WHERE Orden = @Orden
END
END
END ELSE
IF @CatalogoTipoTipo IS NULL
SELECT @ProcesoTerminado = 1
END
END ELSE
IF @Accion IN ('CANCELAR')
BEGIN
IF EXISTS(SELECT * FROM PCPD WHERE dbo.fnPCPCatalogoTipoTieneCatalogo(CatalogoTipoTipo,@Proyecto) = 1 AND ID = @ID) AND @Ok IS NULL SELECT @Ok = 73600, @OkRef = CatalogoTipoTipo FROM PCPD WHERE dbo.fnPCPCatalogoTipoTieneCatalogo(CatalogoTipoTipo,@Proyecto) = 1 AND ID = @ID
IF @Ok IS NULL
DELETE
FROM ClavePresupuestalCatalogoTipo
FROM PCPD pd JOIN PCP p
ON p.ID = pd.ID JOIN ClavePresupuestalCatalogoTipo cpct
ON cpct.Tipo = pd.CatalogoTipoTipo AND cpct.Proyecto = p.Proyecto
WHERE p.ID = @ID
END
END

