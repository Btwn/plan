SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgRepConversacionA ON RepConversacion

FOR INSERT
AS BEGIN
DECLARE
@Reporte		varchar(20),
@EsperandoRespuesta bit
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Reporte = Reporte, @EsperandoRespuesta = EsperandoRespuesta FROM Inserted
UPDATE Rep SET EsperandoRespuesta = @EsperandoRespuesta WHERE Reporte = @Reporte
END

