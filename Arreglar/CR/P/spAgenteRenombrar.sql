SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAgenteRenombrar
@ClaveA         varchar(20),
@ClaveN        	varchar(20),
@EnSilencio	bit		= 0,
@Conexion	bit		= 0,
@Conteo		int		= 0	OUTPUT,
@Ok		int		= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT

AS BEGIN
IF EXISTS(SELECT * FROM Agente WHERE Agente = @ClaveA) AND NOT EXISTS(SELECT * FROM Agente WHERE Agente = @ClaveN)
BEGIN
BEGIN TRY
IF @Conexion = 0
BEGIN TRANSACTION
UPDATE Agente		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE OutlookNombre	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Calendario		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Registro		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovReg		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovDReg		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LCHist 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LC			SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cambio		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Capital		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Agent		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Compra		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cxc		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Embarque		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Inv		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Soporte 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vale 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaResumen 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Nota		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Nota		SET AgenteServicio= @ClaveN WHERE AgenteServicio= @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Venta		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Venta		SET AgenteServicio= @ClaveN WHERE AgenteServicio= @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NotaDAgente 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaDAgente 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NotaD		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaD 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Precio		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Recurso 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Proyecto 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProyD 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tarea 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteCte 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteAgenda 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgentePersonal 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteComisionTipoFactura SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE EquipoAgente 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteActividad 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarAHist 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarA 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteHist 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteRep		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cte 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VIN  		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvSucursal 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prov		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo 		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo 		SET Agente2       = @ClaveN WHERE Agente2       = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo 		SET Agente3       = @ClaveN WHERE Agente3       = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Rep		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE WebUsuario 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prospecto  	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Campana	 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRAgente 	 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE TMA 	 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraD 	 	SET AgenteRef	          = @ClaveN WHERE AgenteRef             = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SIC	 	SET AgentePorOmision      = @ClaveN WHERE AgentePorOmision      = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SoporteCambio	SET AgenteAnalisisImpacto = @ClaveN WHERE AgenteAnalisisImpacto = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CB			SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND TipoCuenta = 'Agente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prop		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ListaD		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AnexoCta		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CuentaTarea	SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
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

