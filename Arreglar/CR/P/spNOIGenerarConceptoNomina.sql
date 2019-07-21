SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIGenerarConceptoNomina
@Empresa        varchar(5),
@TablaPeriodo	varchar(10),
@Estacion       int

AS BEGIN
DECLARE
@NominaConcepto    varchar(10),
@Concepto          varchar(50),
@ConceptoOriginal  varchar(50),
@Movimiento        varchar(20),
@GravaISR          varchar(50),
@GravaIMSS         varchar(50),
@GravaImpuestoEstatal   varchar(50),
@Modulo            varchar(5),
@Estatus           varchar(15),
@EstatusOriginal   varchar(15),
@Pais              varchar(30),
@CuentaGrupo       varchar(20),
@EmpresaNOI        varchar(2),
@Ok                int
SELECT @EmpresaNOI = EmpresaAspel
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
DECLARE crDetalle CURSOR FOR
SELECT   NominaConcepto, Concepto, Movimiento, GravaISR, GravaIMSS, GravaImpuestoEstatal, Modulo, Estatus, Pais, CuentaGrupo
FROM NOINominaConcepto
WHERE EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @NominaConcepto, @Concepto, @Movimiento, @GravaISR, @GravaIMSS, @GravaImpuestoEstatal, @Modulo, @Estatus, @Pais, @CuentaGrupo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM NominaConcepto WHERE  NominaConcepto = @NominaConcepto )
BEGIN
SELECT @ConceptoOriginal = Concepto,@EstatusOriginal = Estatus
FROM NominaConcepto
WHERE  NominaConcepto = @NominaConcepto
IF @Concepto <> @ConceptoOriginal  OR @Estatus <> @EstatusOriginal
UPDATE NominaConcepto SET
Concepto = @Concepto ,
Estatus =   @Estatus ,
ConceptoNOI = 1,
ConceptoNOIValidado = 0
WHERE NominaConcepto =  @NominaConcepto
IF @@ERROR <> 0 SET @Ok = 1
IF EXISTS(SELECT * FROM CfgNominaConcepto WHERE ClaveInterna = @NominaConcepto )
UPDATE CfgNominaConcepto SET
ClaveInterna = @NominaConcepto,
Descripcion = @Concepto,
NominaConcepto = @NominaConcepto,
Pais = @Pais
WHERE  ClaveInterna = @NominaConcepto
IF @@ERROR <> 0 SET @Ok = 1
END
IF NOT EXISTS(SELECT * FROM NominaConcepto WHERE  NominaConcepto = @NominaConcepto)
INSERT  NominaConcepto (NominaConcepto,   Concepto,  Movimiento,   Pais,  Estatus,   CuentaGrupo,  GravaISR,  GravaIMSS,  GravaImpuestoEstatal,  Modulo,  ConceptoNOI, ConceptoNOIValidado)
SELECT                 @NominaConcepto , @Concepto , @Movimiento , @Pais, @Estatus , @CuentaGrupo, @GravaISR, @GravaIMSS, @GravaImpuestoEstatal, @Modulo, 1,           0
IF @@ERROR <> 0 SET @Ok = 1
IF NOT EXISTS(SELECT * FROM CfgNominaConcepto WHERE ClaveInterna = @NominaConcepto)
INSERT CfgNominaConcepto(ClaveInterna,     Descripcion, NominaConcepto,   Pais)
SELECT                   @NominaConcepto , @Concepto ,  @NominaConcepto , @Pais
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO  @NominaConcepto, @Concepto, @Movimiento, @GravaISR, @GravaIMSS, @GravaImpuestoEstatal, @Modulo, @Estatus, @Pais, @CuentaGrupo
END
CLOSE crDetalle
DEALLOCATE crDetalle
IF @Ok IS NULL
DELETE  NOINominaConcepto
WHERE Nomina = @TablaPeriodo
AND EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion
IF @Ok IS NULL
SELECT 'Conceptos Importados Correctamente'
ELSE
SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END

