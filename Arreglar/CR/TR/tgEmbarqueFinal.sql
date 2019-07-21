SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEmbarqueFinal ON EmbarqueD

FOR UPDATE
AS BEGIN
DECLARE
@Modulo		char(5),
@Sucursal		int,
@ID			int,
@EmbarqueMov 	int,
@EstadoA		varchar(50),
@EstadoN		varchar(50),
@Causa		varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EstadoA = Estado FROM Deleted
SELECT @EstadoN = Estado, @EmbarqueMov = EmbarqueMov, @Causa = Causa FROM Inserted
IF @EstadoA <> @EstadoN
BEGIN
SELECT @Modulo = Modulo, @Sucursal = Sucursal, @ID = ModuloID
FROM EmbarqueMov
WHERE ID = @EmbarqueMov
IF @Modulo = 'VTAS' UPDATE Venta  SET EmbarqueEstado = @EstadoN, Causa = @Causa WHERE @Sucursal = Sucursal AND ID = @ID ELSE
IF @Modulo = 'COMS' UPDATE Compra SET EmbarqueEstado = @EstadoN WHERE @Sucursal = Sucursal AND ID = @ID ELSE
IF @Modulo = 'INV'  UPDATE Inv    SET EmbarqueEstado = @EstadoN WHERE @Sucursal = Sucursal AND ID = @ID ELSE
IF @Modulo = 'CXC'  UPDATE Cxc    SET EmbarqueEstado = @EstadoN WHERE @Sucursal = Sucursal AND ID = @ID ELSE
IF @Modulo = 'DIN'  UPDATE DInero SET EmbarqueEstado = @EstadoN WHERE @Sucursal = Sucursal AND ID = @ID
END
END

