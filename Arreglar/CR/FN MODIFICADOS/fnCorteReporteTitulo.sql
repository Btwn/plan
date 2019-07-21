SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCorteReporteTitulo(
@ID			int)
RETURNS varchar(100)

AS
BEGIN
DECLARE @Titulo	varchar(255)
SELECT @Titulo = Columna1 FROM CorteDReporte WITH (NOLOCK) WHERE Tipo = 'TIT' AND ID = @ID
IF ISNULL(RTRIM(@Titulo), '') = ''
SELECT @Titulo = RTRIM(Mov)+' '+RTRIM(MovID) FROM Corte WITH (NOLOCK) WHERE ID = @ID
RETURN @Titulo
END

