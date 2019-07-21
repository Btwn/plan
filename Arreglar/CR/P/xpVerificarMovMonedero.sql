SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpVerificarMovMonedero
@ID           int,
@Bandera      INT OUTPUT
AS
BEGIN
DECLARE
@UEN				int        ,
@NombreUEN		varchar(100),
@CanalNombre		varchar(50),
@Renglon			float      ,
@Articulo			varchar(20),
@Puntos			float      ,
@Estatus			varchar(15),
@MovTipo			varchar(20),
@Redime			bit		   ,
@AplicaMonedero	varchar(20),
@AplicaOfertas	bit
SET @Bandera = 0
SELECT @UEN = V.UEN, @NombreUEN = U.Nombre, @Estatus = V.Estatus, @Redime = V.RedimePuntos, @MovTipo = M.Clave, @AplicaMonedero = Monedero, @AplicaOfertas = AplicarOfertas
FROM Venta          V
JOIN MovTipo        M ON M.Modulo = 'VTAS' AND V.Mov = M.Mov
LEFT OUTER JOIN Uen U ON V.UEN = U.UEN
WHERE V.ID = @ID
IF EXISTS(SELECT * FROM SerieTarjetaMovM WHERE Modulo = 'VTAS' AND ID = @ID)
SET @Bandera  = 1
IF @Bandera = 0 AND @AplicaOfertas = 1
SET @Bandera  = 1
END

