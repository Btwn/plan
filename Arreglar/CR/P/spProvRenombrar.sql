SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProvRenombrar
@ClaveA		varchar(20),
@ClaveN		varchar(20),
@EnSilencio	bit		= 0,
@Conexion	bit		= 0,
@Conteo		int		= 0	OUTPUT,
@Ok		int		= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT

AS BEGIN
IF EXISTS(SELECT * FROM Prov WHERE Proveedor = @ClaveA) AND NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @ClaveN)
BEGIN
BEGIN TRY
IF @Conexion = 0
BEGIN TRANSACTION
UPDATE Prov		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Compra		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE OutlookNombre 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Anuncio		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PC			SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Oferta 		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ActivoFijo 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Neteo		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE EmbarqueMov  	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Embarque		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Soporte		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Recurso		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Proyecto		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProyD		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Proy		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tarea		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteRep		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtProvUnidad 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtProvSucursal 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtProvHist 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtProv		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ArtPlanEx		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Art		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvAutoCargos 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvCuotaDesc 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvCuota		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvCuota		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvSucursal  	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvCredito 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvRelacion  	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvCB		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SugerirCostoArtCat SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Centro		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Rep		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE WebUsuario 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PlanArtOP		SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PlanArtOPHist 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PlanBitacora 	SET Proveedor = @ClaveN	WHERE Proveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE InvGastoDiversoD		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE InvGastoDiverso		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraGastoDiversoD	SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraGastoDiverso		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Gasto			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tramite			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovReg			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ConciliacionD		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Credito			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LCHist			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LC				SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Incidencia 		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaParticipacion 	SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ObligacionFiscal		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Fiscal			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ConceptoAcreedor 		SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tramite			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CtaDinero			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Agente			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CtePension			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE InstitucionFinConcepto  	SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Socio			SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE FordParticipaciones 	SET Acreedor = @ClaveN	WHERE Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE GastoD			SET AcreedorRef = @ClaveN	WHERE AcreedorRef = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NominaConcepto 		SET AcreedorDef = @ClaveN	WHERE AcreedorDef = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Concepto			SET AcreedorDef = @ClaveN	WHERE AcreedorDef = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Venta			SET GastoAcreedor = @ClaveN	WHERE GastoAcreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Nota			SET GastoAcreedor = @ClaveN	WHERE GastoAcreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovTipo			SET GastoAcreedor = @ClaveN	WHERE GastoAcreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cxp		SET Proveedor = @ClaveN			WHERE Proveedor = @ClaveA		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cxp		SET ProveedorAutoEndoso = @ClaveN	WHERE ProveedorAutoEndoso = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraD		SET ProveedorRef = @ClaveN		WHERE ProveedorRef = @ClaveA		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraD		SET ProveedorArt = @ClaveN		WHERE ProveedorArt = @ClaveA		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraD		SET ImportacionProveedor = @ClaveN	WHERE ImportacionProveedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalCfg  	SET PA1Acreedor = @ClaveN		WHERE PA1Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalCfg  	SET PA2Acreedor = @ClaveN		WHERE PA2Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE PersonalCfg  	SET PA3Acreedor = @ClaveN		WHERE PA3Acreedor = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Dinero		SET Proveedor = @ClaveN			WHERE Proveedor = @ClaveA		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Dinero		SET ProveedorAutoEndoso = @ClaveN	WHERE ProveedorAutoEndoso = @ClaveA	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Dinero		SET Contacto = @ClaveN			WHERE Contacto = @ClaveA AND ContactoTipo = 'Proveedor'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NotaD		SET ProveedorRef = @ClaveN		WHERE ProveedorRef = @ClaveA		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaD       	SET ProveedorRef = @ClaveN		WHERE ProveedorRef = @ClaveA		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CB			SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND TipoCuenta = 'Proveedor'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cont		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Proveedor'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE FiscalD 		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Proveedor'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CampanaD		SET Contacto = @ClaveN	WHERE Contacto = @ClaveA AND ContactoTipo = 'Proveedor'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prop		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXP'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ListaD		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXP'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AnexoCta		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXP'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CuentaTarea	SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='CXP'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Auxiliar		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama IN ('CXP','PEFE','PRND')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Acum		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama IN ('CXP','PEFE','PRND')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Saldo		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama IN ('CXP','PEFE','PRND')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AuxiliarRU		SET Grupo = @ClaveN	WHERE Grupo = @ClaveA AND Rama IN ('COMS')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AcumRU		SET Grupo = @ClaveN	WHERE Grupo = @ClaveA AND Rama IN ('COMS')	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SaldoRU		SET Grupo = @ClaveN	WHERE Grupo = @ClaveA AND Rama IN ('COMS')	SELECT @Conteo = @Conteo + @@ROWCOUNT
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

