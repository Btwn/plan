SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSUAComparacion

AS
BEGIN
DECLARE
@NSS			  varchar(30),
@Nombre			  varchar(100),
@Origen			  int,
@Tipo			  int,
@Fecha			  datetime,
@Dias			  int,
@SDI			  money,
@TipoDescuento	  varchar(10),
@ValorDescuento	  money,
@Credito		  varchar(20),
@Validacion		  bit
DELETE SUAComparacion
DECLARE cComparacion CURSOR FOR
SELECT NSS, Nombre, Origen, Tipo, Fecha, Dias, SDI, TipoDescuento, ValorDescuento, Credito, Validacion FROM SUA
OPEN cComparacion
FETCH NEXT FROM cComparacion INTO @NSS, @Nombre, @Origen, @Tipo, @Fecha, @Dias, @SDI, @TipoDescuento, @ValorDescuento, @Credito, @Validacion
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM SUAImportacion
WHERE NSS = @NSS
AND Nombre = @Nombre
AND Origen = @Origen
AND Tipo = @Tipo
AND Fecha = @Fecha
AND Dias = @Dias
AND SDI = @SDI
AND TipoDescuento = @TipoDescuento
AND ValorDescuento = @ValorDescuento
AND Credito = @Credito)
UPDATE SUA SET Validacion = 1
WHERE NSS = @NSS
AND Nombre = @Nombre
AND Origen = @Origen
AND Tipo = @Tipo
AND Fecha = @Fecha
AND Dias = @Dias
AND SDI = @SDI
AND TipoDescuento = @TipoDescuento
AND ValorDescuento = @ValorDescuento
AND Credito = @Credito
FETCH NEXT FROM cComparacion INTO @NSS, @Nombre, @Origen, @Tipo, @Fecha, @Dias, @SDI, @TipoDescuento, @ValorDescuento, @Credito, @Validacion
END
CLOSE cComparacion
DEALLOCATE cComparacion
INSERT INTO SUAComparacion (OrigenDatos, NSS, Nombre, Origen, Tipo, Fecha, Dias, SDI, TipoDescuento, ValorDescuento, Credito, Validacion)
SELECT 'Intelisis', NSS, Nombre, Origen, Tipo, Fecha, Dias, SDI, TipoDescuento, ValorDescuento, Credito, Validacion FROM SUA
DECLARE cComparacion2 CURSOR FOR
SELECT * FROM SUAImportacion
OPEN cComparacion2
FETCH NEXT FROM cComparacion2 INTO @NSS, @Nombre, @Origen, @Tipo, @Fecha, @Dias, @SDI, @TipoDescuento, @ValorDescuento, @Credito, @Validacion
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM SUA
WHERE NSS = @NSS
AND Nombre = @Nombre
AND Origen = @Origen
AND Tipo = @Tipo
AND Fecha = @Fecha
AND Dias = @Dias
AND SDI = @SDI
AND TipoDescuento = @TipoDescuento
AND ValorDescuento = @ValorDescuento
AND Credito = @Credito)
UPDATE SUAImportacion SET Validacion = 1
WHERE NSS = @NSS
AND Nombre = @Nombre
AND Origen = @Origen
AND Tipo = @Tipo
AND Fecha = @Fecha
AND Dias = @Dias
AND SDI = @SDI
AND TipoDescuento = @TipoDescuento
AND ValorDescuento = @ValorDescuento
AND Credito = @Credito
FETCH NEXT FROM cComparacion2 INTO @NSS, @Nombre, @Origen, @Tipo, @Fecha, @Dias, @SDI, @TipoDescuento, @ValorDescuento, @Credito, @Validacion
END
CLOSE cComparacion2
DEALLOCATE cComparacion2
INSERT INTO SUAComparacion (OrigenDatos, NSS, Nombre, Origen, Tipo, Fecha, Dias, SDI, TipoDescuento, ValorDescuento, Credito, Validacion)
SELECT 'SUA', NSS, Nombre, Origen, Tipo, Fecha, Dias, SDI, TipoDescuento, ValorDescuento, Credito, Validacion FROM SUAImportacion
END

