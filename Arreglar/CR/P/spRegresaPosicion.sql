SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegresaPosicion
@Modulo varchar(5),
@Tipo   varchar(10),
@Sujeto varchar(10),
@Almacen    varchar(10),
@Mov varchar(20) =NULL

AS
BEGIN
DECLARE @Posicion   varchar(10),
@Clave      varchar(20),
@SubClave   varchar(20)
IF @Modulo = 'VTAS'
BEGIN
IF @Tipo = 'ENTRADA'
SELECT @Posicion = DefPosicionRecibo FROM Cte WHERE Cliente = @Sujeto
IF @Tipo = 'SALIDA'
SELECT @Posicion = DefPosicionSurtido FROM Cte WHERE Cliente = @Sujeto
END
IF @Modulo = 'COMS'
BEGIN
IF @Tipo = 'ENTRADA'
SELECT @Posicion = DefPosicionRecibo FROM Prov WHERE Proveedor = @Sujeto
IF @Tipo = 'SALIDA'
SELECT @Posicion = DefPosicionSurtido FROM Prov WHERE Proveedor = @Sujeto
END
IF @Mov IS NOT NULL AND @Modulo = 'INV'
BEGIN
SELECT @Clave = Clave,@SubClave = SubClave
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
IF ISNULL(@SubClave,'') = 'INV.ENT' AND @Tipo = 'SALIDA'
SET @Tipo = 'ENTRADA'
IF ISNULL(@Clave,'') = 'INV.EI' AND @Tipo = 'ENTRADA'
SET @Tipo = 'SALIDA'
IF ISNULL(@Clave,'') = 'INV.SOL' AND ISNULL(@SubClave,'') = '' AND @Tipo = 'ENTRADA'
SET @Tipo = 'SALIDA'
END
IF @Modulo IN('PROD','INV')
BEGIN
IF @Tipo = 'ENTRADA' AND @Posicion IS NULL
SELECT @Posicion = DefPosicionRecibo FROM Alm WHERE Almacen = @Almacen
IF @Tipo = 'SALIDA' AND @Posicion IS NULL
SELECT @Posicion = DefPosicionSurtido FROM Alm WHERE Almacen = @Almacen
END
IF @Tipo = 'ENTRADA' AND @Posicion IS NULL
SELECT @Posicion = DefPosicionRecibo FROM Alm WHERE Almacen = @Almacen
IF @Tipo = 'SALIDA' AND @Posicion IS NULL
SELECT @Posicion = DefPosicionSurtido FROM Alm WHERE Almacen = @Almacen
SELECT @Posicion
END

