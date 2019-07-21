SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaClaveInternaAcumuladoFechasTotal
@Empresa	    char(5),
@ClaveInterna	varchar(50),
@FechaD		    datetime,
@FechaA		    datetime,
@Tope		      money,
@Importe	    money	OUTPUT,
@Cantidad	    float	OUTPUT,
@PTU          bit = 1

AS BEGIN
DECLARE
@Personal		      varchar(10),
@PersonalImporte	money,
@PersonalCantidad	float
SELECT @Importe  = 0.0,
@Cantidad = 0.0
DECLARE crPersonal CURSOR FOR
SELECT Personal
FROM Personal
OPEN crPersonal
FETCH NEXT FROM crPersonal INTO @Personal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spNominaClaveInternaAcumuladoFechas @Empresa, @Personal, @ClaveInterna, @FechaD, @FechaA, NULL, @PersonalImporte OUTPUT, @PersonalCantidad OUTPUT
IF ISNULL(@Tope, 0.0) > 0.0 AND @PersonalImporte > @Tope SELECT @PersonalImporte = @Tope
IF @PTU = 1
BEGIN
IF ISNULL(@PersonalCantidad, 0.0) >= 60.0
SELECT @Importe = @Importe   + ISNULL(@PersonalImporte, 0.0),
@Cantidad = @Cantidad + ISNULL(@PersonalCantidad, 0.0)
END ELSE
SELECT @Importe = @Importe + ISNULL(@PersonalImporte, 0.0), @Cantidad = @Cantidad + ISNULL(@PersonalCantidad, 0.0)
END
FETCH NEXT FROM crPersonal INTO @Personal
END 
CLOSE crPersonal
DEALLOCATE crPersonal
RETURN
END

