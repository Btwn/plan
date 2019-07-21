SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSCheckSumEncabezado (
@ID   varchar(36)
)
RETURNS int

AS
BEGIN
DECLARE
@Resultado  int
SELECT @Resultado = CHECKSUM(ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia,
Observaciones, Estatus, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais,
Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CajaOrigen, CtaDinero, Descuento, DescuentoGlobal, Importe,
Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Tasa, Prefijo, Consecutivo, IDR,
Monedero, BeneficiarioNombre)
FROM POSLPorCobrar WHERE ID = @ID
RETURN (@Resultado)
END

