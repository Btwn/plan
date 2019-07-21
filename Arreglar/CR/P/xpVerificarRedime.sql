SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpVerificarRedime
@ID           int
AS
BEGIN
DECLARE
@UEN          int        ,
@NombreUEN    varchar(100),
@CanalNombre  varchar(50),
@Renglon      float      ,
@Articulo     varchar(20),
@Bandera      bit        ,
@Puntos       float      ,
@Estatus      varchar(15),
@MovTipo      varchar(20),
@Redime       bit
SELECT @Bandera = 0
SELECT @UEN = V.UEN, @NombreUEN = U.Nombre, @Estatus = V.Estatus, @Redime = V.RedimePuntos, @MovTipo = M.Clave, @CanalNombre = U.Nombre
FROM Venta          V
JOIN MovTipo        M ON M.Modulo = 'VTAS' AND V.Mov = M.Mov
LEFT OUTER JOIN Uen U ON V.UEN = U.UEN
WHERE V.ID = @ID
IF @Redime = 1
SELECT @Bandera = 1
IF @Redime = 1 AND @Estatus = 'SINAFECTAR' 
SELECT @Bandera = 0
SELECT @Bandera
END

