SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCDevolucion
@Empresa		varchar(5),
@Sucursal		int,
@Estacion		int,
@FormaPago		varchar(50),
@Modulo			varchar(5),
@ModuloID		int

AS
BEGIN
DECLARE @Cliente		varchar(10)
DELETE TCDevolucion WHERE Estacion = @Estacion
DELETE TCEstacionTransaccion WHERE Estacion = @Estacion
IF @Modulo = 'VTAS'
BEGIN
SELECT @Cliente = Cliente FROM Venta WHERE ID = @ModuloID
INSERT INTO TCDevolucion(
Estacion, IDTransaccion, Modulo,   ModuloID,   IDOrden)
SELECT @Estacion, t.RID,         t.Modulo, t.ModuloID, t.IDOrden
FROM TCTransaccion t
JOIN Venta v ON t.ModuloID = v.ID AND t.Modulo = 'VTAS'
WHERE v.Cliente = @Cliente
AND t.Ok IS NULL
AND t.Accion = 'Auth'
AND v.Empresa = @Empresa
AND t.FormaPago = @FormaPago
END
DELETE TCDevolucion
FROM TCDevolucion
JOIN TCTransaccion ON TCDevolucion.IDOrden = TCTransaccion.IDOrden
WHERE TCTransaccion.Accion = 'Void'
AND Ok IS NULL
RETURN
END

