SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEjecutaHistoricos

AS BEGIN
DECLARE
@Modulo			 varchar(5),
@Hist			   bit,
@Frecuencia	 int,
@Periodo		 int,
@Dias		 	   int,
@HastaFecha	 datetime
DECLARE crModulo CURSOR FOR
SELECT Modulo, Hist, Cast(HistMin as Int), Cast(HistMinUnidad as Int)
FROM Modulo
WITH(NOLOCK) WHERE Hist = 1
OPEN crModulo
FETCH NEXT FROM crModulo  INTO @Modulo, @Hist, @Frecuencia, @Periodo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Hist = 1
BEGIN
IF @Periodo = 1
SELECT @Dias = @Frecuencia
IF @Periodo = 2
SELECT @Dias = @Frecuencia * 30
IF @Periodo = 3
SELECT @Dias = @Frecuencia * 365
SELECT @HastaFecha = GETDATE()-@Dias
IF @Modulo = 'VTAS'
BEGIN
EXEC spAgregaCampoHist 'VTAS'
EXEC spHistVenta NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'COMS'
BEGIN
EXEC spAgregaCampoHist 'COMS'
EXEC spHistCompra NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'CXC'
BEGIN
EXEC spAgregaCampoHist 'CXC'
EXEC spHistCxc NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'CXP'
BEGIN
EXEC spAgregaCampoHist 'CXP'
EXEC spHistCXP NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'NOM'
BEGIN
EXEC spAgregaCampoHist 'NOM'
EXEC spHistNomina NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'DIN'
BEGIN
EXEC spAgregaCampoHist 'DIN'
EXEC spHistDinero NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'EMB'
BEGIN
EXEC spAgregaCampoHist 'EMB'
EXEC spHistEmbarque NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'AF'
BEGIN
EXEC spAgregaCampoHist 'AF'
EXEC spHistActivoFijo NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'CONC'
BEGIN
EXEC spAgregaCampoHist 'CONC'
EXEC spHistConciliacion NULL, @HastaFecha, NULL, NULL, NULL
END
IF @Modulo = 'ASIS'
BEGIN
EXEC spAgregaCampoHist 'ASIS'
EXEC spHistAsiste NULL, @HastaFecha, NULL, NULL, NULL
END
END
FETCH NEXT FROM crModulo  INTO @Modulo, @Hist, @Frecuencia, @Periodo
END
CLOSE crModulo
DEALLOCATE crModulo
END

