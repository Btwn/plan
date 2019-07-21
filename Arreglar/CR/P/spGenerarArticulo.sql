SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarArticulo
@ID				int,
@Empresa		varchar(5),
@Sucursal		int

AS
BEGIN
DECLARE
@Mensaje				varchar(MAX),
@Articulo				varchar(20),
@ListaModificarP		varchar(20),
@FechainicioP			datetime,
@FechaterminoP			datetime,
@Unidad					varchar(50),
@Nuevo					money,
@Anterior				money,
@MonedaPrecio			varchar(10),
@Usuario				varchar(10),
@IDPrecios				int,
@MovID					varchar(20)
SELECT @Articulo = Articulo
FROM HArticulos
WHERE ID = @ID
IF NOT EXISTS (SELECT Articulo FROM Art WHERE Articulo = @Articulo )
BEGIN
INSERT INTO Art (
Articulo, Tipo, Descripcion1, Unidad, UnidadCompra, Unidadtraspaso, TipoCosteo, Grupo, Familia, Linea, Categoria,
Impuesto1, Impuesto2, Impuesto3, TipoCompra, Proveedor, SeVende, SeCompra, Cuenta, Cuenta2,   Cuenta3, BasculaPesar,
Estatus, MonedaCosto, MonedaPrecio)
SELECT
Articulo, Tipo, Descripcion1, Unidad, UnidadCompra, Unidadtraspaso, TipoCosteo,  Grupo, Familia, Linea, Categoria,
Impuesto1, Impuesto2, Impuesto3, TipoCompra, Proveedor, SeVende, SeCompra, Cuenta, Cuenta2, Cuenta3, BasculaPesar,
Estatus, MonedaCosto, MonedaPrecio
FROM HArticulos
WHERE ID = @ID
INSERT INTO CB (
Codigo,    TipoCuenta,    Cuenta,   Cantidad, Unidad)
SELECT
CodigoCB, TipoCuentaCB, Articulo, CantidadCB, UnidadCB
FROM HArticulos
WHERE ID = @ID
DECLARE crCabecero CURSOR FOR
SELECT ListaModificarP, FechainicioP, FechaterminoP, Unidad, Nuevo, Anterior, MonedaPrecio, ISNULL(Usuario, 'DEMO'), Articulo
FROM HArticulos
WHERE ID = @ID
OPEN crCabecero
FETCH NEXT FROM crCabecero INTO @ListaModificarP, @FechainicioP, @FechaterminoP, @Unidad, @Nuevo, @Anterior, @MonedaPrecio, @Usuario, @Articulo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO PC(
Empresa, Mov, Fechaemision, Moneda, TipoCambio, Usuario, Estatus, Fechainicio, FechaTermino, Sucursal, ListaModificar,
SucursalOrigen, SucursalDestino, OrigenID, Observaciones)
VALUES(
@Empresa, 'Precios', GETDATE(), @MonedaPrecio, 1.00, @Usuario, 'SINAFECTAR', @FechainicioP, @FechaterminoP,	 @Sucursal, @ListaModificarP,
@Sucursal, @Sucursal, @ID, 'Movimiento Generado desde la Herramienta de Alta de Articulos (POS) por el Usuario: '+CONVERT(varchar, @Usuario))
SELECT @IDPrecios = SCOPE_IDENTITY()
INSERT INTO PCD(
Id, Renglon, Articulo, Unidad, Nuevo, Anterior, baja, ListaModificar, Sucursal, SucursalOrigen)
VALUES(
@IDPrecios, 2048, @Articulo, @Unidad, @Nuevo, @Anterior, 0, @ListaModificarP, @Sucursal, @Sucursal)
EXEC spAfectar 'PC', @IDPrecios, 'AFECTAR', 'Todo', NULL, @Usuario
UPDATE HArticulos SET EstatusRegistro = 'PROCESADO'
UPDATE HArticulos SET DestinoID = @IDPrecios WHERE ID = @ID
SELECT @MovID = MovID
FROM PC
WHERE ID = @IDPrecios
SELECT @Mensaje = 'El alta del Articulo: '+CONVERT(varchar, @Articulo)+' se Genero de manera correcta'+'<BR><BR>'+
'y se Genero el Movimento de asignacion de Precio no: '+ CONVERT(varchar, @MovID)
END
FETCH NEXT FROM crCabecero INTO @ListaModificarP, @FechainicioP, @FechaterminoP, @Unidad, @Nuevo, @Anterior
END
CLOSE crCabecero
DEALLOCATE crCabecero
END
ELSE
SELECT @Mensaje = 'El articulo ya existe en el catalogo'
SELECT @Mensaje
END

