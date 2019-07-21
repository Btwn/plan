SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCHashTableTransaccion
@Estacion			int,
@Modulo				varchar(5),
@ModuloID			int,
@FormaPago			varchar(50),
@Importe			float,
@Columna			varchar(255) = NULL,
@Valor				varchar(255) = NULL

AS
BEGIN
INSERT INTO TCHashTableTransaccion(
Estacion,  Modulo,  ModuloID,  FormaPago,  Importe,  Columna,  Valor)
SELECT @Estacion, @Modulo, @ModuloID, @FormaPago, @Importe, @Columna, @Valor
END

