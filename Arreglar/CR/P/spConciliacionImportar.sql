SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionImportar
@Estacion		Int,
@ID			int

AS
BEGIN
DECLARE
@Empresa		char(5),
@CtaDinero		varchar(10),
@Moneda		char(10),
@NumeroCta		varchar(100),
@Institucion	varchar(20),
@Layout		varchar(20),
/*@SaldoAnterior	money,
@Cargos		money,
@Abonos		money,*/
@FechaD		datetime,
@FechaA		datetime
SELECT @Empresa = Empresa, @CtaDinero = CtaDinero FROM Conciliacion WHERE ID = @ID
SELECT @Moneda = Moneda, @NumeroCta = NumeroCta, @Institucion = Institucion FROM CtaDinero WHERE CtaDinero = @CtaDinero
SELECT @Layout = UPPER(Layout) FROM InstitucionFin WHERE Institucion = @Institucion
CREATE TABLE #ConciliacionBanco(
ID		int		NOT NULL IDENTITY (1,1)	PRIMARY KEY,
Fecha		datetime	NULL,
Concepto	varchar(50)	COLLATE Database_Default NULL,
Referencia	varchar(50)	COLLATE Database_Default NULL,
Cargo		money		NULL,
Abono		money		NULL,
Observaciones	varchar(100)	COLLATE Database_Default NULL
)
IF @Layout = 'BANCOMER'
Exec spConciliacionBancomer @Institucion, @NumeroCta, @Estacion
IF @Layout = 'SANTANDER'
Exec spConciliacionSantander @Institucion, @NumeroCta, @Estacion
IF @Layout = 'HSBC'
Exec spConciliacionHSBC @Institucion, @NumeroCta, @Estacion
IF @Layout = 'HSBC2'
Exec spConciliacionHSBC2 @Institucion, @NumeroCta, @Estacion
IF @Layout = 'BANREGIO'
Exec spConciliacionBanregio @Institucion, @NumeroCta, @Estacion
IF @Layout = 'BANORTE'
Exec spConciliacionBanorte @Institucion, @NumeroCta, @Estacion
IF @Layout = 'BANAMEX'
Exec spConciliacionBanamex @Institucion, @NumeroCta, @Estacion
IF @Layout = 'BANORTE2'
Exec spConciliacionBanorte2 @Institucion, @NumeroCta, @Estacion
IF @Layout = 'SCOTIABANK'
Exec spConciliacionScotiabank @Institucion, @NumeroCta, @Estacion
DELETE #ConciliacionBanco
WHERE Concepto IN (SELECT ConceptoBanco FROM InstitucionFinConcepto WHERE Institucion = @Institucion AND TipoMovimiento = 'N/A')
DELETE ConciliacionD WHERE ID = @ID
INSERT ConciliacionD (
ID,  Fecha, Concepto,                    Referencia,                    Cargo,              Abono,              Observaciones)
SELECT @ID, Fecha, NULLIF(RTRIM(Concepto), ''), NULLIF(RTRIM(Referencia), ''), NULLIF(Cargo, 0.0), NULLIF(Abono, 0.0), NULLIF(RTRIM(Observaciones), '')
FROM #ConciliacionBanco
ORDER BY ID, Fecha
SELECT @FechaD = MIN(Fecha), @FechaA = MAX(Fecha)
FROM ConciliacionD
WHERE ID = @ID
/*SELECT @SaldoAnterior = SaldoConciliado FROM DineroSaldo WHERE Empresa = @Empresa AND Moneda = @Moneda AND CtaDinero = @CtaDinero*/
UPDATE Conciliacion
SET FechaD = @FechaD, FechaA = @FechaA/*, SaldoAnterior = @SaldoAnterior, Cargos = @Cargos, Abonos = @Abonos */
WHERE ID = @ID
SELECT 'Importacion Completada con Exito'
END

