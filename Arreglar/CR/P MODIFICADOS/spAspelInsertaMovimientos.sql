SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaMovimientos]
(
@Estacion	int
)

AS BEGIN
IF (SELECT Insertar FROM AspelCfgMovimiento WITH (NOLOCK) WHERE Movimiento = 'Venta') = 1
EXEC spAspelInsertaVentas @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WITH (NOLOCK) WHERE Movimiento = 'Compra') = 1 
EXEC spAspelInsertaCompras @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WITH (NOLOCK) WHERE Movimiento = 'Cxc') = 1 
EXEC spAspelInsertaCxc @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WITH (NOLOCK) WHERE Movimiento = 'Cxp') = 1 
EXEC spAspelInsertaCxp @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WITH (NOLOCK) WHERE Movimiento = 'Inventario') = 1 
EXEC spAspelInsertaInventarios @Estacion
IF (SELECT Insertar FROM AspelCfgMovimiento WITH (NOLOCK) WHERE Movimiento = 'Poliza') = 1 
EXEC spAspelInsertaPolizas @Estacion
END

