SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutDatos
@ArchivoID		int,
@Layout			varchar(50),
@LayoutInsertarVacios	bit,
@Lista			varchar(255),
@Registro		int,
@Campo			varchar(50),
@SubCampo		varchar(50),
@Valor			varchar(8000),
@Mayusculas		bit,
@Minusculas		bit,
@DividirEntre100	bit

AS BEGIN
SELECT @Valor = NULLIF(LTRIM(RTRIM(@Valor)), '')
IF @Valor IS NOT NULL
BEGIN
IF @Mayusculas = 1 SELECT @Valor = UPPER(@Valor) ELSE
IF @Minusculas = 1 SELECT @Valor = LOWER(@Valor)
IF @DividirEntre100 = 1 AND dbo.fnEsNumerico(@Valor) = 1
SELECT @Valor = LTRIM(CONVERT(varchar, CONVERT(money, CONVERT(bigint, @Valor)/100.0)))
END
IF @Valor IS NOT NULL OR @LayoutInsertarVacios = 1
INSERT LayoutDatos (
ArchivoID,  Layout,  Lista,  Registro,  Campo,  SubCampo,  Valor)
VALUES (@ArchivoID, @Layout, @Lista, @Registro, @Campo, @SubCampo, @Valor)
END

