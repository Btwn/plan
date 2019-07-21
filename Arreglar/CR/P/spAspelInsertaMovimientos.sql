SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaMovimientos]
(
@Estacion	int
)

AS BEGIN
IF (SELECT Insertar FROM AspelCfgMovimiento WHERE Movimiento = 'Venta') = 1
EXEC spAspelInsertaVentas @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WHERE Movimiento = 'Compra') = 1 
EXEC spAspelInsertaCompras @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WHERE Movimiento = 'Cxc') = 1 
EXEC spAspelInsertaCxc @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WHERE Movimiento = 'Cxp') = 1 
EXEC spAspelInsertaCxp @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WHERE Movimiento = 'Inventario') = 1 
EXEC spAspelInsertaInventarios @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WHERE Movimiento = 'Poliza') = 1 
EXEC spAspelInsertaPolizas @Estacion
END

