SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovReciboEliminar
@Modulo		char(5),
@ID		int,
@Articulo	char(20),
@SubCuenta	varchar(20),
@Unidad		varchar(50),
@Costo		float,
@Lote		varchar(50),
@Caducidad	datetime

AS BEGIN
IF @Caducidad = CONVERT(datetime, '30/12/1899', 103) SELECT @Caducidad = NULL
DELETE MovRecibo WHERE Modulo = @Modulo AND ModuloID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(NULLIF(RTRIM(@SubCuenta), '0'), '') AND ISNULL(Unidad, '') = ISNULL(NULLIF(RTRIM(@Unidad), '0'), '') AND ISNULL(Costo, 0) = ISNULL(@Costo, 0) AND ISNULL(Lote, '') = ISNULL(NULLIF(RTRIM(@Lote), '0'), '') AND Caducidad = @Caducidad
RETURN
END

