SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISDropBoxNombreArchivo(
@ID					int,
@SucursalOrigen		int,
@SucursalDestino	int,
@SincroTabla		varchar(100),
@SubReferencia		varchar(100)
)
RETURNS varchar(255)
AS
BEGIN
DECLARE @Nombre	varchar(255)
IF ISNULL(@SincroTabla, '') = ''
SELECT @Nombre = 'SincroIS_' + CONVERT(varchar, @ID) + '_' + CONVERT(varchar, @SucursalOrigen) + '_' + CONVERT(varchar, @SucursalDestino) + '_' + ISNULL(@SubReferencia, '')
ELSE
SELECT @Nombre = 'SincroIS_' + CONVERT(varchar, @ID) + '_' + CONVERT(varchar, @SucursalOrigen) + '_' + CONVERT(varchar, @SucursalDestino) + '_' + ISNULL(@SincroTabla, '')
RETURN @Nombre
END

