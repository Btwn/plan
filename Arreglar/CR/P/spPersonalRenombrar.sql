SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPersonalRenombrar
@ClaveA         varchar(20),
@ClaveN        	varchar(20),
@EnSilencio	bit		= 0,
@Conexion	bit		= 0,
@Conteo		int		= 0	OUTPUT,
@Ok		int		= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT

AS BEGIN
IF EXISTS(SELECT * FROM Personal WHERE Personal = @ClaveA) AND NOT EXISTS(SELECT * FROM Personal WHERE Personal = @ClaveN)
BEGIN
BEGIN TRY
IF @Conexion = 0
BEGIN TRANSACTION
UPDATE Personal	        SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Personal	        SET ReportaA = @ClaveN WHERE ReportaA  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Personal	        SET RecomendadoPor = @ClaveN WHERE RecomendadoPor = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE OutlookNombre	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovPersonal 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovReg		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovDReg		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE BPlan		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE GastoD		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ActivoFijo 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AsisteD		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Incidencia 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE IncidenciaH 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Inv		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaD		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaPersonal 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaPersonalFecha SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaPersonalProy SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaLog		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaH		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE TipoLiquidacionNominaPanama SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaImportar	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProdD 		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE RHD		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Soporte		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Recurso 		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Proyecto		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProyD		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tarea 		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgentePersonal 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Agente		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteRep		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Plaza		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalTarjeta 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalUltimoPago SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalSuc	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalAcceso 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalCfg 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalEntrada 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalEntradaH 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Rep		SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE WebUsuario 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalDatosAcademicos SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalDatosLaborales  SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalHerman	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalSpranger	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalCleaver 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NomXPersonalGrupo 	SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
/*UPDATE CompetenciaFormatoCalificacion SET Personal = @ClaveN WHERE Personal  = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompetenciaFormatoCalificacion SET EvaluaPersonal = @ClaveN WHERE EvaluaPersonal = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT*/
UPDATE CxcPersonalCobradorLog SET PersonalCobrador = @ClaveN WHERE PersonalCobrador = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cxc		    SET PersonalCobrador = @ClaveN WHERE PersonalCobrador = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Embarque		    SET PersonalCobrador = @ClaveN WHERE PersonalCobrador = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarAHist	    SET PersonalCobrador = @ClaveN WHERE PersonalCobrador = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarA 	    SET PersonalCobrador = @ClaveN WHERE PersonalCobrador = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cte		    SET PersonalCobrador = @ClaveN WHERE PersonalCobrador = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CB			SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND TipoCuenta = 'Personal'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cont		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Personal'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Dinero		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Personal'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE FiscalD 		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Personal'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CampanaD		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Personal'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prop		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='NOM'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ListaD		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='NOM'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AnexoCta		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='NOM'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CuentaTarea	SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='NOM'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalPropValor	SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='EMP'		SELECT @Conteo = @Conteo + @@ROWCOUNT
IF @Conexion = 0
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = ERROR_MESSAGE()
IF @Conexion = 0
ROLLBACK TRANSACTION
END CATCH
END ELSE
SELECT @Ok =10066, @OkRef = 'De '+ISNULL(@ClaveA, '')+' al '+ISNULL(@ClaveN, '')
RETURN
END

