SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEvaluacionCtoAB ON EvaluacionCto

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Evaluacion	varchar(50),
@Fecha	datetime,
@Punto	varchar(100),
@Contacto	varchar(20),
@Modulo 	varchar(5),
@ModuloID	int
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Calificacion)
INSERT EvaluacionCtoHist (Evaluacion, Punto, Contacto, Fecha, Calificacion)
SELECT Evaluacion, Punto, Contacto, Fecha, Calificacion FROM Inserted WHERE Calificacion IS NOT NULL
IF UPDATE(Contacto)
BEGIN
SELECT @Evaluacion = Evaluacion, @Fecha = Fecha, @Punto = Punto, @Contacto = Contacto FROM Inserted
SELECT @Modulo   = dbo.fnExtraerClaveModulo(@Contacto)
SELECT @ModuloID = dbo.fnExtraerClaveID(@Contacto)
IF EXISTS(SELECT * FROM Modulo WHERE Modulo = @Modulo) AND @ModuloID IS NOT NULL
UPDATE EvaluacionCto SET Modulo = @Modulo, ModuloID = @ModuloID WHERE Evaluacion = @Evaluacion AND Fecha = @Fecha AND /*Punto = @Punto AND */Contacto = @Contacto
END
END

