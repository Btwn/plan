SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMovDPrecioImpuestos
@Empresa	char(5),
@Modulo 	char(5),
@ID 		int,
@Mov		char(20),
@MovID		varchar(20),
@MovTipo	char(20),
@Renglon	float,
@RenglonSub	int,
@RenglonID 	int,
@ArtTipo	char(20),
@Articulo	char(20),
@SubCuenta	varchar(50),
@Almacen	char(10),
@Cantidad	float,
@Precio		float		OUTPUT,
@Impuesto1	float 		OUTPUT,
@Impuesto2	float 		OUTPUT,
@Impuesto3	float 		OUTPUT,
@Impuesto5	float 		OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT
AS BEGIN
RETURN
END

