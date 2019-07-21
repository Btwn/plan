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
IF EXISTS(SELECT * FROM Agente WITH(NOLOCK) WHERE Agente = @ClaveA) AND NOT EXISTS(SELECT * FROM Agente WITH(NOLOCK) WHERE Agente = @ClaveN)
BEGIN
BEGIN TRY
IF @Conexion = 0
BEGIN TRANSACTION
UPDATE Agente WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE OutlookNombre WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Calendario WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Registro	SET Agente  = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovReg	WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE MovDReg WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LCHist WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE LC	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cambio	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Capital	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Agent	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Compra	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cxc	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Embarque	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Inv	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Soporte 	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vale WITH(ROWLOCK)		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaResumen WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Nota	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Nota	WITH(ROWLOCK)	SET AgenteServicio= @ClaveN WHERE AgenteServicio= @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Venta	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Venta	WITH(ROWLOCK)	SET AgenteServicio= @ClaveN WHERE AgenteServicio= @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NotaDAgente WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaDAgente WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE NotaD WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VentaD WITH(ROWLOCK)		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Precio	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Recurso 	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Proyecto WITH(ROWLOCK)		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProyD WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Tarea WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteCte WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteAgenda WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgentePersonal WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteComisionTipoFactura WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE EquipoAgente WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AgenteActividad WITH(ROWLOCK) 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarAHist WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteEnviarA WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteHist WITH(ROWLOCK)		SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CteRep	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Cte WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE VIN WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ProvSucursal WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prov	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo WITH(ROWLOCK)		SET Agente2       = @ClaveN WHERE Agente2       = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Vehiculo WITH(ROWLOCK)		SET Agente3       = @ClaveN WHERE Agente3       = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Rep	WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE WebUsuario WITH(ROWLOCK)	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prospecto WITH(ROWLOCK) 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Campana	WITH(ROWLOCK) 	SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CRAgente WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE TMA WITH(ROWLOCK) SET Agente        = @ClaveN WHERE Agente        = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CompraD WITH(ROWLOCK) SET AgenteRef	          = @ClaveN WHERE AgenteRef             = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SIC	WITH(ROWLOCK) 	SET AgentePorOmision      = @ClaveN WHERE AgentePorOmision      = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE SoporteCambio WITH(ROWLOCK)	SET AgenteAnalisisImpacto = @ClaveN WHERE AgenteAnalisisImpacto = @ClaveA SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CB	WITH(ROWLOCK)		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND TipoCuenta = 'Agente'	SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE Prop	WITH(ROWLOCK)	SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE ListaD WITH(ROWLOCK)		SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE AnexoCta	WITH(ROWLOCK) SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
UPDATE CuentaTarea WITH(ROWLOCK) SET Cuenta = @ClaveN	WHERE Cuenta = @ClaveA AND Rama='AGENT'		SELECT @Conteo = @Conteo + @@ROWCOUNT
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

