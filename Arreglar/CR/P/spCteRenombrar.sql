SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCteRenombrar
@ClaveA		varchar(20),
@ClaveN		varchar(20),
@EnSilencio	bit		= 0,
@Conexion	bit		= 0,
@Conteo		int		= 0	OUTPUT,
@Ok		int		= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT

AS BEGIN
IF EXISTS(SELECT * FROM Cte WHERE Cliente = @ClaveA) AND NOT EXISTS(SELECT * FROM Cte WHERE Cliente = @ClaveN)
BEGIN
BEGIN TRY
IF @Conexion = 0
BEGIN TRANSACTION
UPDATE Cte		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cxc		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Venta		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Excel		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE OutlookNombre	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovDReg		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE EmpresaCfgPV 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Sucursal       	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MensajeSalida     	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SerieLote		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SerieLoteMov 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE EspacioAsignacion 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AutoBoleto 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cambio		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Compra		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraD		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CxcAplicaDif 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Neteo 		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Dinero		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE EmbarqueMov 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE InvD		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProdD		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Soporte		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vale		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ValeSerie		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaResumen 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Nota		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Precio		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Recurso		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Proyecto		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tarea		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteCte		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarAOtrosDatos SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarAHist	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarA 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarALimite 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteRelacion 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteArtBloqueo  	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteBonificacion  	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteHist 		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCtoComites 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCtoActividad 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCtoDireccion 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCtoHist 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCto		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteAcceso 		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CtePedidoDef 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteOtrosDatos 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEvento		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCtoEvento 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteTel		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteUEN 		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CtePension 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCapacidadPago 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CtePresupuesto 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteRep		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteDepto		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteMapeoMov 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteDeptoEnviarA 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEntregaMercancia SET Cliente = @ClaveN  WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEstadoFinanciero SET Cliente = @ClaveN  WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEmpresaCFD	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteCFD		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteUsoServicio 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtCte		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtCteCompetencia 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VINHist		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VIN		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ActivoF 		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Personal		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Beneficiario 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Rep		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Socio		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE WebUsuario 	SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRVenta		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRCobro		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRSoporte		SET Cliente = @ClaveN	WHERE Cliente = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Usuario		SET Cliente = @ClaveN		WHERE Cliente = @ClaveA					SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Usuario		SET DefCliente = @ClaveN	WHERE DefCliente = @ClaveA				SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Gasto		SET ClienteRef = @ClaveN	WHERE ClienteRef = @ClaveA				SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LCAval		SET Aval = @ClaveN		WHERE Aval = @ClaveA					SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRMov		SET ClienteIntelisis = @ClaveN	WHERE ClienteIntelisis = @ClaveA			SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRMovSoporte 	SET ClienteIntelisis = @ClaveN	WHERE ClienteIntelisis = @ClaveA			SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CB			SET Cuenta = @ClaveN		WHERE Cuenta = @ClaveA AND TipoCuenta = 'Cliente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CtaSituacionProg  	SET Cuenta = @ClaveN		WHERE Cuenta = @ClaveA AND TipoCuenta = 'Cliente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cont		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Cliente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Dinero		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Cliente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE FiscalD 		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Cliente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CampanaD		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Cliente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prop		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXC'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ListaD		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXC'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AnexoCta		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXC'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CuentaTarea	SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXC'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Auxiliar		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama IN ('CXC','CEFE','CNO','CRND','CVALE')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Acum		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama IN ('CXC','CEFE','CNO','CRND','CVALE')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Saldo		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama IN ('CXC','CEFE','CNO','CRND','CVALE')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AuxiliarRU		SET Grupo = @ClaveN	WHERE Grupo = @ClaveA AND Rama IN ('VTAS')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AcumRU		SET Grupo = @ClaveN	WHERE Grupo = @ClaveA AND Rama IN ('VTAS')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SaldoRU		SET Grupo = @ClaveN	WHERE Grupo = @ClaveA AND Rama IN ('VTAS')	SELECT @Conteo = @Conteo + @@ROWCOUNT
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

