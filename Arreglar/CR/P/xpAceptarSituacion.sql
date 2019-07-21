SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpAceptarSituacion
@Empresa		varchar(5),
@Sucursal		int,
@Estacion		int,
@EsMovimiento		bit,
@Modulo			varchar(5),
@ModuloID		int,
@SituacionAnterior	varchar(50),
@SituacionNueva		varchar(50),
@FechaSeguimiento	datetime,
@UsuarioSeguimiento	varchar(10),
@Comentarios		varchar(255)
AS BEGIN
DECLARE
@Expresion	varchar(max)
SELECT 'Expresion' = @Expresion
END

