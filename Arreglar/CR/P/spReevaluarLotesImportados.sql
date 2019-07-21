SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReevaluarLotesImportados
@Empresa		char(5),
@Usuario		char(10),
@FechaEmision 	datetime

AS BEGIN
DECLARE
@Moneda		char(10),
@TipoCambio		float,
@Renglon		float,
@RenglonID		int,
@UltAlmacen		char(10),
@Almacen		char(10),
@Articulo		char(20),
@SubCuenta		varchar(20),
@Unidad		varchar(50),
@SerieLote		varchar(50),
@Cantidad		float,
@Costo		float,
@Sucursal		int,
@ReevaluacionID	int,
@ReevaluacionMov	char(20),
@Conteo		int,
@UltFactor		float,
@Factor		float,
@Referencia		varchar(50),
@Mensaje		varchar(255)
SELECT @Conteo = 0, @UltAlmacen = NULL, @UltFactor = NULL
SELECT @ReevaluacionMov = InvReevaluacion
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
CREATE TABLE #Lotes (
ID			int		NOT NULL IDENTITY(1, 1) PRIMARY KEY,
Almacen			char(10)	COLLATE Database_Default NULL,
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(20)	COLLATE Database_Default NULL,
Unidad			varchar(50)	COLLATE Database_Default NULL,
SerieLote		varchar(20)	COLLATE Database_Default NULL,
Cantidad		float		NULL,
Costo			float		NULL)
INSERT INTO #Lotes (Almacen, Articulo, SubCuenta, Unidad, SerieLote, Cantidad, Costo)
SELECT s.Almacen, d.Articulo, s.SubCuenta, d.Unidad, s.SerieLote, s.Existencia, "Costo" = (SUM(d.Cantidad*ISNULL(d.CostoInv, d.Costo))/SUM(d.Cantidad)*Mon.TipoCambio)/@TipoCambio
FROM SerieLote s, SerieLoteMov m, Compra c, CompraD d, MovTipo mt, Mon
WHERE s.Empresa = @Empresa AND s.Empresa = m.Empresa AND s.Articulo = m.Articulo AND s.SubCuenta = m.SubCuenta AND s.SerieLote = m.SerieLote
AND m.Modulo = 'COMS' AND m.ID = c.ID AND c.Estatus = 'CONCLUIDO' AND c.Empresa = s.Empresa
AND d.ID = c.ID AND d.Almacen = s.Almacen AND d.Articulo = s.Articulo AND ISNULL(d.SubCuenta, '') = s.SubCuenta AND d.RenglonID = m.RenglonID
AND mt.Modulo = m.Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
AND c.TipoCambio <> 1 AND s.Existencia > 0
AND Mon.Moneda = c.Moneda
GROUP BY s.Almacen, d.Articulo, s.SubCuenta, d.Unidad, s.SerieLote, s.Existencia, Mon.TipoCambio
ORDER BY s.Almacen, d.Articulo, s.SubCuenta, d.Unidad, s.SerieLote, s.Existencia, Mon.TipoCambio
SELECT @UltAlmacen = NULL
DECLARE crLotes CURSOR FOR
SELECT se.Factor, l.Almacen, a.Sucursal, l.Articulo, l.SubCuenta, l.Unidad, SUM(l.Cantidad)*se.Factor, SUM(l.Costo*l.Cantidad)/SUM(l.Cantidad)
FROM SalidaEntrada se, #Lotes l, Alm a
WHERE l.Almacen = a.Almacen
GROUP BY se.Factor, l.Almacen, a.Sucursal, l.Articulo, l.SubCuenta, l.Unidad
ORDER BY se.Factor, l.Almacen, a.Sucursal, l.Articulo, l.SubCuenta, l.Unidad
OPEN crLotes
FETCH NEXT FROM crLotes INTO @Factor, @Almacen, @Sucursal, @Articulo, @SubCuenta, @Unidad, @Cantidad, @Costo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Factor <> @UltFactor OR @Almacen <> @UltAlmacen
BEGIN
IF @Factor = -1 SELECT @Referencia = 'Salida' ELSE SELECT @Referencia = 'Entrada'
INSERT Inv (Sucursal,  Empresa,  Mov,              FechaEmision,  Referencia,  Moneda,  TipoCambio,  Almacen,  Usuario,  Estatus)
VALUES (@Sucursal, @Empresa, @ReevaluacionMov, @FechaEmision, @Referencia, @Moneda, @TipoCambio, @Almacen, @Usuario, 'CONFIRMAR')
SELECT @ReevaluacionID = SCOPE_IDENTITY()
SELECT @UltAlmacen = @Almacen, @UltFactor = @Factor, @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
END
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
IF @Factor = -1 SELECT @Costo = NULL
INSERT InvD (Sucursal,  ID,              Renglon,  RenglonSub, RenglonID,  Almacen,  Articulo,  SubCuenta,              Unidad,  Cantidad,  CantidadInventario, Costo)
VALUES (@Sucursal, @ReevaluacionID, @Renglon, 0,          @RenglonID, @Almacen, @Articulo, NULLIF(@SubCuenta, ''), @Unidad, @Cantidad, @Cantidad,          @Costo)
INSERT SerieLoteMov (Sucursal,  Empresa,  Modulo, ID,              RenglonID,  Articulo,  SubCuenta,  SerieLote, Cantidad)
SELECT @Sucursal, @Empresa, 'INV',  @ReevaluacionID, @RenglonID, @Articulo, @SubCuenta, SerieLote, Cantidad
FROM #Lotes
WHERE Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta
END
FETCH NEXT FROM crLotes INTO @Factor, @Almacen, @Sucursal, @Articulo, @SubCuenta, @Unidad, @Cantidad, @Costo
END 
CLOSE crLotes
DEALLOCATE crLotes
SELECT @Mensaje = LTRIM(CONVERT(char, @Conteo))+' Reevaluaciones Generadas (por Confirmar).<BR><BR>Favor de Afectar Primero las Salidas y Despues las Entradas.'
SELECT @Mensaje
RETURN
END

