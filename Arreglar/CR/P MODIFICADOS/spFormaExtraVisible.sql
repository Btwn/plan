SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaExtraVisible
@Aplica		varchar(50),
@Modulo 	varchar(5)	= NULL,
@Movimiento 	varchar(20)	= NULL,
@Categoria 	varchar(50)	= NULL,
@Grupo 		varchar(50)	= NULL,
@Familia 	varchar(50)	= NULL,
@Departamento 	varchar(50)	= NULL,
@Puesto 	varchar(50)	= NULL,
@SIC 		varchar(10)	= NULL,
@Uso		varchar(50)	= NULL

AS BEGIN
SELECT 'Conteo' = ISNULL(COUNT(*), 0), 'FormaTipo' = MIN(FormaTipo) FROM dbo.fnFormaExtraVisible(@Aplica, @Modulo, @Movimiento, @Categoria, @Grupo, @Familia, @Departamento, @Puesto, @SIC)
IF @Uso IS NOT NULL OR @Aplica IN ('Inmuebles', 'Contratos')
EXEC xpFormaExtraVisible @Aplica, @Modulo, @Movimiento, @Categoria, @Grupo, @Familia, @Departamento, @Puesto, @SIC, @USO
RETURN
END

