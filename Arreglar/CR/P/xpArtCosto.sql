SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpArtCosto
@Empresa                char(5),
@Sucursal		int,
@Accion		        char(20),
@Modulo                 char(5),
@ID                     int,
@RenglonID		int,
@Articulo		char(20),
@SubCuenta		varchar(50),
@CostoEstandar		float		OUTPUT,
@CostoReposicion 	float		OUTPUT,
@CostoPromedio		float		OUTPUT,
@UltimoCosto 		float		OUTPUT,
@UltimoCostoSinGastos 	float		OUTPUT,
@Ok 			int		OUTPUT
AS BEGIN
/* Esta rutina sirve para cambiar el Costo a gravar en la transaccion */
RETURN
END

