SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMovOk
@SincroFinal		bit,
@ID			int,
@Estatus		char(15),
@Sucursal		int,
@Accion			char(20),
@Empresa		char(5),
@Usuario		char(10),
@Modulo			char(5),
@Mov			char(20),
@FechaAfectacion	datetime,
@FechaRegistro		datetime,
@Ejercicio		int,
@Periodo		int,
@Proyecto		varchar(50),
@Ok			int 		OUTPUT,
@OkRef			varchar(255) 	OUTPUT
AS BEGIN
RETURN
END

