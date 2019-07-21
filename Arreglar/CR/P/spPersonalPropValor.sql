SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPersonalPropValor
@Empresa	char(5),
@Sucursal	int,
@Categoria	varchar(50),
@Puesto		varchar(50),
@Personal	char(10),
@Propiedad	varchar(50),
@Valor		varchar(50) OUTPUT,
@SinError	bit	= 0

AS BEGIN
DECLARE
@Mensaje	varchar(255)
SELECT @Valor = NULL
IF @Personal IS NOT NULL
SELECT @Valor = NULLIF(RTRIM(Valor), '') FROM PersonalPropValor WHERE Rama = 'PER' AND Cuenta = @Personal AND Propiedad = @Propiedad
IF @Categoria IS NOT NULL AND @Valor IS NULL
SELECT @Valor = NULLIF(RTRIM(Valor), '') FROM PersonalPropValor WHERE Rama = 'CAT' AND Cuenta = @Categoria AND Propiedad = @Propiedad
IF @Puesto IS NOT NULL AND @Valor IS NULL
SELECT @Valor = NULLIF(RTRIM(Valor), '') FROM PersonalPropValor WHERE Rama = 'PUE' AND Cuenta = @Puesto AND Propiedad = @Propiedad
IF @Sucursal IS NOT NULL AND @Valor IS NULL
SELECT @Valor = NULLIF(RTRIM(Valor), '') FROM PersonalPropValor WHERE Rama = 'SUC' AND Cuenta = CONVERT(varchar, @Sucursal) AND Propiedad = @Propiedad
IF @Empresa IS NOT NULL AND @Valor IS NULL
SELECT @Valor = NULLIF(RTRIM(Valor), '') FROM PersonalPropValor WHERE Rama = 'EMP' AND Cuenta = @Empresa AND Propiedad = @Propiedad
IF NOT EXISTS(SELECT * FROM PersonalProp WHERE Propiedad = @Propiedad) AND @SinError = 0
BEGIN
SELECT @Mensaje = '"'+REPLACE(@Propiedad,'%','%%')+'" '+RTRIM(Descripcion) FROM MensajeLista WHERE Mensaje = 10460
RAISERROR (@Mensaje, 16, -1)
END
RETURN
END

