SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGeneraAbonoCaja
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@ID				varchar(36),
@MovClave       varchar(20),
@Ok				int				OUTPUT,
@OkRef			varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@IDGenerar     varchar(36),
@Mov           varchar(20),
@Caja          varchar(20)
IF @MovClave IN('POS.TCM','POS.CTCM')
BEGIN
IF @MovClave = 'POS.TCM'
SELECT TOP 1 @Mov = Mov FROM MovTipo WHERE Modulo = 'POS' AND Clave = 'POS.TCAC'
IF @MovClave = 'POS.CTCM'
SELECT TOP 1 @Mov = Mov FROM MovTipo WHERE Modulo = 'POS' AND Clave = 'POS.CTCAC'
SELECT @Caja = CtaDineroDestino
FROM POSL WHERE ID = @ID
SELECT @IDGenerar = NEWID()
INSERT POSL(
ID, Host, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia,
Observaciones, Estatus, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion,
Estado, Pais, Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen, Agente, Cajero, FormaEnvio, Condicion, Vencimiento, CtaDinero,
CtaDineroDestino, Descuento, DescuentoGlobal, Importe, Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto,
Sucursal, OrigenTipo, Origen, OrigenID, Tasa, Prefijo, Consecutivo, noAprobacion, fechaAprobacion, CadenaOriginal, Sello, Certificado,
DocumentoXML, FechaCancelacion, FechaEntrega, FechaSello, UsuarioAutoriza, IDR, Monedero, Cluster, Caja, FechaNacimiento, EstadoCivil,
Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion)
SELECT
@IDGenerar, Host, Empresa, Modulo, @Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia,
Observaciones, 'CONCLUIDO', Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion,
Estado, Pais, Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen, Agente, Cajero, FormaEnvio, Condicion, Vencimiento, CtaDineroDestino,
CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto,
Sucursal, OrigenTipo, Origen, OrigenID, Tasa, Prefijo, Consecutivo, noAprobacion, fechaAprobacion, CadenaOriginal, Sello, Certificado,
DocumentoXML, FechaCancelacion, FechaEntrega, FechaSello, UsuarioAutoriza, @ID, Monedero, Cluster, CtaDineroDestino, FechaNacimiento, EstadoCivil,
Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion
FROM POSL
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLCobro(
ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio, Voucher, Banco,
MonedaRef, CtaDineroDestino)
SELECT
@IDGenerar, FormaPago, Importe, Referencia, Monedero, CtaDineroDestino, Fecha, @Caja,  Cajero, Host, ImporteRef, TipoCambio, Voucher, Banco,
MonedaRef, CtaDinero
FROM POSLCobro
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
END
END

