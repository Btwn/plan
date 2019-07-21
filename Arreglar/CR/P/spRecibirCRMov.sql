SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecibirCRMov
@xml		text,
@Sesion	varchar(50)

AS BEGIN
DECLARE
@ixml		 int,
@Sucursal		 int
BEGIN TRANSACTION
EXEC sp_xml_preparedocument @ixml OUTPUT, @xml
SELECT @Sucursal = Sucursal
FROM OPENXML (@ixml, 'CR')
WITH (Sucursal int)
SET IDENTITY_INSERT crMovTemp ON
INSERT crMovTemp (Sesion,  Sucursal, ID, FechaRegistro, Tipo, Cxc, Folio, FechaEmision, Estatus, Caja, CajaRef, Banco, Cajero, ClienteSucursal, Cliente, ClienteIntelisis, Referencia, Corte, FechaD, FechaA, Vencimiento, Concepto, FechaBanco, Enviado, CajeroCancelacion, OrigenID, OrigenTipo, OrigenFolio, Proveedor, ListaPrecios, CFDGenerado, CFDID, CFDSerie, CFDFolio) 
SELECT            @Sesion, Sucursal, ID, FechaRegistro, Tipo, Cxc, Folio, FechaEmision, Estatus, Caja, CajaRef, Banco, Cajero, ClienteSucursal, Cliente, ClienteIntelisis, Referencia, Corte, FechaD, FechaA, Vencimiento, Concepto, FechaBanco, Enviado, CajeroCancelacion, OrigenID, OrigenTipo, OrigenFolio, Proveedor, ListaPrecios, CFDGenerado, CFDID, CFDSerie, CFDFolio  
FROM OPENXML (@ixml, 'CR/crMov/row')
WITH (Sucursal int, ID int, FechaRegistro datetime, Tipo varchar(20), Cxc bit, Folio int, FechaEmision datetime, Estatus char(15), Caja int, CajaRef int, Banco int, Cajero int, ClienteSucursal int, Cliente int, ClienteIntelisis varchar(10), Referencia varchar(50), Corte int, FechaD datetime, FechaA datetime, Vencimiento datetime, Concepto varchar(50), FechaBanco datetime, Enviado bit, CajeroCancelacion int, OrigenID int, OrigenTipo varchar(20), OrigenFolio int, Proveedor int, ListaPrecios varchar(20), CFDGenerado bit, CFDID int, CFDSerie varchar(20), CFDFolio varchar(20)) 
WHERE Sucursal = @Sucursal
SET IDENTITY_INSERT crMovTemp OFF
SET IDENTITY_INSERT crMovDTemp ON
INSERT crMovDTemp (Sesion,  Sucursal, ID, RID, Tipo, Vendedor, FormaPago, Referencia, Articulo, SubCuenta, Departamento, Cantidad, Descuento1, Descuento2, Importe, Moneda, TipoCambio, Concepto, Unidad, Codigo, Ubicacion, Posicion, RenglonTipo, UsuarioAutorizacion, EsJuego, PrecioEspecial, PrecioNormal, Cancelado, Costo)
SELECT             @Sesion, Sucursal, ID, RID, Tipo, Vendedor, FormaPago, Referencia, Articulo, SubCuenta, Departamento, Cantidad, Descuento1, Descuento2, Importe, Moneda, TipoCambio, Concepto, Unidad, Codigo, Ubicacion, Posicion, RenglonTipo, UsuarioAutorizacion, EsJuego, PrecioEspecial, PrecioNormal, Cancelado, Costo
FROM OPENXML (@ixml, 'CR/crMovD/row')
WITH (Sucursal int, ID int, RID int, Tipo varchar(20), Vendedor int, FormaPago int, Referencia varchar(50), Articulo varchar(20), SubCuenta varchar(50), Departamento int, Cantidad float, Descuento1 float, Descuento2 float, Importe money, Moneda int, TipoCambio float, Concepto varchar(50), Unidad varchar(50), Codigo varchar(30), Ubicacion varchar(10), Posicion varchar(10), RenglonTipo char(1), UsuarioAutorizacion varchar(10), EsJuego bit, PrecioEspecial bit, PrecioNormal float, Cancelado bit, Costo money)
WHERE Sucursal = @Sucursal
SET IDENTITY_INSERT crMovDTemp OFF
EXEC sp_xml_removedocument @ixml
COMMIT TRANSACTION
END

