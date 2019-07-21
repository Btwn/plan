SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegresaPosiciones
@Modulo     varchar(5),
@Tipo       varchar(10),
@Sujeto     varchar(10),
@Almacen    varchar(10),
@Mov        varchar(20)=NULL

AS
BEGIN
DECLARE @Almacen1   varchar(10),
@Clave      varchar(20),
@SubClave   varchar(20)
IF @Modulo = 'VTAS'
SELECT @Almacen1 = AlmacenDef FROM Cte WHERE Cliente = @Sujeto
IF @Modulo = 'COMS'
SELECT @Almacen1 = Almacen FROM Prov WHERE Proveedor = @Sujeto
IF @Modulo IN ('PROD','INV')
SELECT @Almacen1 = @Almacen
IF @Mov IS NOT NULL AND @Modulo = 'INV'
BEGIN
SELECT @Clave = Clave, @SubClave = SubClave
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
IF ISNULL(@SubClave,'') = 'INV.ENT' AND @Tipo = 'SALIDA'
SET @Tipo = 'ENTRADA'
IF ISNULL(@Clave,'') = 'INV.EI' AND @Tipo = 'ENTRADA'
SET @Tipo = 'SALIDA'
IF ISNULL(@Clave,'') = 'INV.SOL' AND ISNULL(@SubClave,'') = '' AND @Tipo = 'ENTRADA'
SET @Tipo = 'SALIDA'
END
IF @Tipo = 'ENTRADA' SET @Tipo = 'Recibo'
IF @Tipo = 'SALIDA' SET @Tipo = 'Surtido'
SELECT Posicion
FROM AlmPos
WHERE Almacen = ISNULL(@Almacen,@Almacen1) AND Tipo = @Tipo
END

