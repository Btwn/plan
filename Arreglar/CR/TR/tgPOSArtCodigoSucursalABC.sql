SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSArtCodigoSucursalABC ON POSArtCodigoSucursal

FOR UPDATE, DELETE,INSERT
AS BEGIN
DECLARE
@EsOrigen           bit,
@SincronizaArtSuc   bit
SELECT @EsOrigen = ISNULL(EsOrigen,0), @SincronizaArtSuc = ISNULL(SincronizaArtSuc,0) FROM POSiSync
IF @EsOrigen = 1 RETURN
IF @SincronizaArtSuc = 0 RETURN
IF EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED)
DELETE CB
FROM CB c JOIN DELETED d ON c.Codigo = d.Codigo
IF EXISTS(SELECT * FROM DELETED) AND  EXISTS(SELECT * FROM INSERTED)
UPDATE CB SET  Codigo = i.Codigo, Cuenta = i.Articulo, SubCuenta = i.SubCuenta, Cantidad = i.Cantidad, Unidad = i.Unidad
FROM CB c JOIN INSERTED i ON c.Codigo = i.Codigo
IF NOT EXISTS(SELECT * FROM DELETED) AND  EXISTS(SELECT * FROM INSERTED)
BEGIN
INSERT CB(Codigo, TipoCuenta,  Cuenta, SubCuenta, Cantidad, Unidad)
SELECT    Codigo, 'Articulos', Articulo, SubCuenta, Cantidad, Unidad
FROM Inserted
WHERE Codigo NOT IN (SELECT Codigo FROM CB)
GROUP BY  Codigo, Articulo, SubCuenta, Cantidad, Unidad
UPDATE CB SET  Codigo = i.Codigo, Cuenta = i.Articulo, SubCuenta = i.SubCuenta, Cantidad = i.Cantidad, Unidad = i.Unidad
FROM CB c JOIN INSERTED i ON c.Codigo = i.Codigo
END
RETURN
END

