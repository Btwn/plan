SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spNetRegistrarEvento
@Fecha			datetime = NULL,
@Identificacion varchar(100) = NULL,
@Acomp			varchar(255) = NULL,
@Apartamento	varchar(100) = NULL,
@Cliente		varchar(10)  = NULL,
@Torre			varchar(100) = NULL,
@Matricula		varchar(20)  = NULL,
@Cajon			varchar(50)  = NULL,
@Comentarios	varchar(max) = NULL
AS BEGIN
INSERT INTO pNetEventualidades(Fecha,Identificacion,Acomp,Apartamento,Cliente,Torre,Matricula, Cajon, Comentarios)
SELECT @Fecha,@Identificacion,@Acomp,@Apartamento,@Cliente,@Torre,@Matricula,@Cajon,@Comentarios
SELECT 'Evento registrado'
RETURN
END

