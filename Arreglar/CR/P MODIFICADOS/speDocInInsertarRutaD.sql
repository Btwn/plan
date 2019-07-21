SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInInsertarRutaD
@eDocIn          varchar(50),
@Ruta            varchar(50),
@Tipo            varchar(50),
@Operador        varchar(1)

AS BEGIN
INSERT eDocInRutaD(eDocIn,  Ruta,  OperadorLogico, Tipo)
SELECT             @eDocIn, @Ruta, @Operador, @Tipo
END

