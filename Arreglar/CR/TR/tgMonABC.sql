SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgMonABC ON Mon

FOR UPDATE, INSERT, DELETE
AS BEGIN
DECLARE
@Sucursal		int,
@Hoy		datetime,
@MonedaN 		varchar(50),
@MonedaA 		varchar(50),
@TipoCambio		float,
@Mensaje		varchar(255)
DELETE FROM MonMes WHERE Moneda IN (SELECT Moneda FROM DELETED)
INSERT MonMes (Moneda, Descripcion, DescripcionAbreviada, NumeroDecimales, EstatusIntelIMES)
SELECT Moneda, Nombre, ISNULL(Clave,''), 2, 0
FROM INSERTED
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Hoy = GETDATE() 
SELECT @MonedaN = Moneda, @TipoCambio = TipoCambio FROM Inserted
SELECT @MonedaA = Moneda FROM Deleted
SELECT @Sucursal = Sucursal FROM Version
IF UPDATE(TipoCambio)
INSERT INTO MonHist (Sucursal, Moneda, Fecha, TipoCambio, FechaSinHora) VALUES (@Sucursal, @MonedaN, @Hoy, @TipoCambio, dbo.fnFechaSinHora(@Hoy)) 
IF @MonedaA IS NULL AND EXISTS(SELECT * FROM CambioAcum)
BEGIN
EXEC spExtraerFecha @Hoy OUTPUT
INSERT INTO CambioAcum (Sucursal, Empresa, Moneda, Fecha) SELECT DISTINCT @Sucursal, Empresa, @MonedaN, @Hoy FROM CambioAcum
END
END

