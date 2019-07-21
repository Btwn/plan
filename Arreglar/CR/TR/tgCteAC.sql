SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCteAC ON Cte

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@RFCNuevo		varchar(20),
@RegistroDup	varchar(50),
@ClaveNueva  	varchar(10),
@ClienteDup  	varchar(10),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @RFCNuevo = RFC, @ClaveNueva = Cliente FROM Inserted
IF UPDATE(Nombre) OR UPDATE(NombreCorto) OR UPDATE(Direccion) OR UPDATE(Delegacion) OR UPDATE(Colonia) OR UPDATE(Poblacion) OR
UPDATE(Estado) OR UPDATE(Pais) OR UPDATE(Zona) OR UPDATE(CodigoPostal) OR UPDATE(RFC) OR UPDATE(CURP) OR UPDATE(IEPS) OR UPDATE(PITEX) OR UPDATE(Tipo) OR
UPDATE(Situacion) OR UPDATE(Credito) OR UPDATE(ZonaImpuesto) OR UPDATE(Descuento) OR UPDATE(Agente) OR UPDATE(AgenteServicio) OR UPDATE(EnviarA) OR UPDATE(Proyecto) OR
UPDATE(FormaEnvio) OR UPDATE(Condicion) OR UPDATE(Ruta) OR UPDATE(ListaPrecios) OR UPDATE(ListaPreciosEsp) OR
UPDATE(DefMoneda) OR UPDATE(NivelAcceso) OR UPDATE(Estatus)
INSERT CteHist (Cliente, Fecha,  Nombre, NombreCorto, Direccion, Delegacion, Colonia,
Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, IEPS, PITEX, Tipo, Situacion, Credito, ZonaImpuesto, Descuento, Agente, AgenteServicio,
EnviarA, Proyecto, FormaEnvio, Condicion, Ruta, ListaPrecios, ListaPreciosEsp, DefMoneda, NivelAcceso, Estatus, Usuario)
SELECT Cliente, GETDATE(), Nombre, NombreCorto, Direccion, Delegacion, Colonia,
Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, IEPS, PITEX, Tipo, Situacion, Credito, ZonaImpuesto, Descuento, Agente, AgenteServicio,
EnviarA, Proyecto, FormaEnvio, Condicion, Ruta, ListaPrecios, ListaPreciosEsp, DefMoneda, NivelAcceso, Estatus, Usuario
FROM Inserted
SELECT @ClienteDup = NULL
IF NULLIF(@RFCNuevo, '') IS NOT NULL AND @RFCNuevo NOT IN ('XAXX010101000', 'XEXX010101000') 
BEGIN
SELECT @ClienteDup = MIN(Cliente) FROM CTE WHERE RFC = @RFCNuevo AND Cliente <> @ClaveNueva
IF @ClienteDup IS NOT NULL SELECT @RegistroDup = 'RFC - ' + @RFCNuevo
END
IF @ClienteDup IS NOT NULL
BEGIN
SELECT @Mensaje = 'Error al Actualizar a "'+RTRIM(@ClaveNueva)+'", la clave del "'+@RegistroDup+'", ya Existe en la Persona "'+LTRIM(RTRIM(@ClienteDup))+ '".'
RAISERROR (@Mensaje,16,-1)
END
END

