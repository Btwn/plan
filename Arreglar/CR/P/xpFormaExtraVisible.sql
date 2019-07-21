SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpFormaExtraVisible
@Aplica		varchar(50),
@Modulo 		varchar(5)	= NULL,
@Movimiento 	varchar(20)	= NULL,
@Categoria 	varchar(50)	= NULL,
@Grupo 		varchar(50)	= NULL,
@Familia 		varchar(50)	= NULL,
@Departamento varchar(50)	= NULL,
@Puesto 		varchar(50)	= NULL,
@SIC 			varchar(10)	= NULL,
@Uso			varchar(50) = NULL
AS BEGIN
RETURN
END

