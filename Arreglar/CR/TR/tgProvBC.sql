SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProvBC ON Prov

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(10),
@ClaveAnterior	varchar(10),
@TipoNuevo		varchar(15),
@TipoAnterior	varchar(15),
@NombreNuevo	varchar(100),
@NombreAnterior	varchar(100),
@RFCNuevo		varchar(20),
@RFCAnterior	varchar(20),
@CURPNuevo		varchar(30),
@CURPAnterior	varchar(30),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Proveedor, @TipoNuevo    = Tipo, @NombreNuevo    = Nombre, @RFCNuevo    = RFC, @CURPNuevo    = CURP  FROM Inserted
SELECT @ClaveAnterior = Proveedor, @TipoAnterior = Tipo, @NombreAnterior = Nombre, @RFCAnterior = RFC, @CURPAnterior = CURP  FROM Deleted
/*IF @NombreNuevo <> @NombreAnterior OR @RFCNuevo <> @RFCAnterior OR @CURPNuevo <> @CURPAnterior*/
IF @ClaveNueva=@ClaveAnterior AND @TipoNuevo=@TipoAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
IF EXISTS (SELECT * FROM Prov WHERE Rama = @ClaveAnterior)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@ClaveAnterior))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30165
RAISERROR (@Mensaje,16,-1)
END ELSE
BEGIN
DELETE ProvAcceso  	WHERE Proveedor = @ClaveAnterior
DELETE ProvCredito 	WHERE Proveedor = @ClaveAnterior
DELETE ProvCuota   	WHERE Proveedor = @ClaveAnterior
DELETE ProvCuotaDesc 	WHERE Proveedor = @ClaveAnterior
DELETE ProvAutoCargos 	WHERE Proveedor = @ClaveAnterior
DELETE ProvSucursal	WHERE Proveedor = @ClaveAnterior
DELETE ProvRelacion	WHERE Proveedor = @ClaveAnterior
DELETE ProvCB		WHERE Proveedor = @ClaveAnterior
DELETE Prop        	WHERE Cuenta = @ClaveAnterior AND Rama='CXP'
DELETE AnexoCta    	WHERE Cuenta = @ClaveAnterior AND Rama='CXP'
DELETE CuentaTarea 	WHERE Cuenta = @ClaveAnterior AND Rama='CXP'
DELETE CtoCampoExtra   WHERE Tipo = 'Proveedor' AND Clave = @ClaveAnterior
DELETE FormaExtraValor WHERE Aplica = 'Proveedor' AND AplicaClave = @ClaveAnterior
DELETE FormaExtraD     WHERE Aplica = 'Proveedor' AND AplicaClave = @ClaveAnterior
END
END ELSE
IF @ClaveNueva <> @ClaveAnterior
BEGIN
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE Prov SET Rama = @ClaveNueva, SincroC = SincroC WHERE Rama = @ClaveAnterior', N'@ClaveNueva varchar(20), @ClaveAnterior varchar(20)', @ClaveNueva = @ClaveNueva, @ClaveAnterior = @ClaveAnterior
ELSE
UPDATE Prov SET Rama = @ClaveNueva WHERE Rama = @ClaveAnterior
UPDATE Prop        SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama = 'CXP'
UPDATE AnexoCta    SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama = 'CXP'
UPDATE CuentaTarea SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama = 'CXP'
UPDATE Auxiliar    SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama IN ('CXP', 'PEFE', 'PRND')
UPDATE Acum        SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama IN ('CXP', 'PEFE', 'PRND')
UPDATE Saldo       SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama IN ('CXP', 'PEFE', 'PRND')
UPDATE AuxiliarRU  SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama = 'COMS'
UPDATE AcumRU      SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama = 'COMS'
UPDATE SaldoRU     SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama = 'COMS'
UPDATE ProvAcceso    SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvCuota	 SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvCuotaDesc SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvCB	 SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ActivoFijo    SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Embarque      SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE EmbarqueMov   SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Anuncio       SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE PlanArtOP     SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE PlanBitacora  SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Art           SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Cxp           SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Compra        SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvCredito   SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvRelacion  SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Vehiculo      SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProyD         SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ArtPlanEx     SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ArtProv       SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ArtProvSucursal    SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Centro             SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE Soporte            SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE SugerirCostoArtCat SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvAutoCargos     SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE ProvSucursal       SET Proveedor = @ClaveNueva WHERE Proveedor = @ClaveAnterior
UPDATE InvGastoDiverso   	SET Acreedor = @ClaveNueva WHERE Acreedor = @ClaveAnterior
UPDATE InvGastoDiversoD  	SET Acreedor = @ClaveNueva WHERE Acreedor = @ClaveAnterior
UPDATE CompraGastoDiverso   SET Acreedor = @ClaveNueva WHERE Acreedor = @ClaveAnterior
UPDATE CompraGastoDiversoD  SET Acreedor = @ClaveNueva WHERE Acreedor = @ClaveAnterior
UPDATE Gasto		SET Acreedor = @ClaveNueva WHERE Acreedor = @ClaveAnterior
UPDATE Tramite		SET Acreedor = @ClaveNueva WHERE Acreedor = @ClaveAnterior
UPDATE CtoCampoExtra	SET Clave   = @ClaveNueva WHERE Clave   = @ClaveAnterior AND Tipo='Proveedor'
UPDATE FormaExtraValor	SET AplicaClave   = @ClaveNueva WHERE AplicaClave   = @ClaveAnterior AND Aplica='Proveedor'
UPDATE FormaExtraD		SET AplicaClave   = @ClaveNueva WHERE AplicaClave   = @ClaveAnterior AND Aplica='Proveedor'
END
END

