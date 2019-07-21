SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMuestraAcciones
@Usuario         varchar(10)

AS
BEGIN
DECLARE
@UsuarioPerfil varchar(10)
SELECT @UsuarioPerfil = POSPerfil
FROM Usuario
WHERE Usuario = @Usuario
SELECT Tipo = 'Accion',
cb.Codigo,
a.Accion
FROM POSUsuarioAccion a JOIN  CB cb ON cb.Accion = a.Accion
WHERE CB.Accion IS NOT NULL AND a.Usuario = ISNULL(NULLIF(@UsuarioPerfil,''),@Usuario)
AND a.Accion NOT IN('CANCELACION DINERO', 'EDITAR ENCABEZADO', 'EDITAR DETALLE', 'CONCLUIR MOVIMIENTO', 'INTRODUCIR CONCEPTOCXC',
'ALMACEN DESTINO','REFERENCIAR PEDIDO','SELECCIONARCTE', 'REFERENCIAR COBRO','REFERENCIAR VENTA')
UNION ALL
SELECT Tipo = 'Forma Pago',
Codigo,
FormaPago
FROM CB
WHERE CB.FormaPago IS NOT NULL
UNION ALL
SELECT Tipo = 'Accion', 'CTRL+P', 'Lista de Movimientos'
UNION ALL
SELECT Tipo = 'Accion', 'ALT+F2', 'Ofertas Puntos'
UNION ALL
SELECT Tipo = 'Accion', 'ALT+F3', 'Cancelar Ofertas Puntos'
UNION ALL
SELECT Tipo = 'Accion', 'ALT+F4', 'Buscar Cliente'
UNION ALL
SELECT Tipo = 'Accion', 'ALT+F7', 'Promociones Cobro'
UNION ALL
SELECT Tipo = 'Accion', 'CTRL+Q', 'Eliminar Movimiento'
UNION ALL
SELECT Tipo = 'Accion', 'CTRL+T', 'Informacion del Cliente'
UNION ALL
SELECT Tipo = 'Accion', 'CTRL+R', 'Regresar'
END

