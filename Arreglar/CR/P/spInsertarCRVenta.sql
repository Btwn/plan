SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarCRVenta
@CRID int, @Sucursal int, @Renglon float, @Articulo varchar(20), @SubCuenta varchar(50), @Operaciones int, @Almacen varchar(10), @Posicion varchar(10), @Cliente varchar(10), @Cxc bit, @Mov varchar(20), @MovID varchar(20), @Cantidad float, @DescuentoLinea float, @Importe money, @CFDSerie varchar(20), @CFDFolio varchar(20), @Ok int OUTPUT, @OkRef varchar(255) OUTPUT 

AS BEGIN
INSERT CRVenta
(ID,    Sucursal,  Renglon,  Articulo,  SubCuenta,  Operaciones,  Almacen,  Posicion,  Cliente,  Cxc,  Mov,  MovID,  Cantidad,  DescuentoLinea,  Importe,  CFDSerie,  CFDFolio)   
VALUES (@CRID, @Sucursal, @Renglon, @Articulo, @SubCuenta, @Operaciones, @Almacen, @Posicion, @Cliente, @Cxc, @Mov, @MovID, @Cantidad, @DescuentoLinea, @Importe, @CFDSerie, @CFDFolio)  
END

