SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInRutaRelativa
(
@Ruta					varchar(max),
@RelativaA				varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado				varchar(max),
@Nodo					varchar(255),
@NodoPadre				varchar(255),
@NodoAnterior			varchar(255),
@Tipo					varchar(50),
@Salir					bit,
@RutaRelativa			varchar(max),
@Estatus				varchar(50),
@NodoPrincipal                      varchar(255)
SET @Resultado = ''
IF @Ruta = @RelativaA
BEGIN
RETURN @Resultado
END
DECLARE @Nodos TABLE
(
Nodo				varchar(255) COLLATE DATABASE_DEFAULT NULL,
NodoPadre			varchar(255) COLLATE DATABASE_DEFAULT NULL,
Tipo				varchar(50) COLLATE DATABASE_DEFAULT NULL
)
INSERT @Nodos (Nodo, NodoPadre, Tipo)
SELECT
Nodo,
NodoPadre,
Tipo
FROM dbo.fneDocInRutaRelativaArbol(@Ruta,@RelativaA)
SELECT @NodoPrincipal = Nodo FROM @Nodos WHERE NULLIF(NodoPadre,'') IS NULL
SET @RutaRelativa = ''
SET @Salir = 0
SET @Estatus = 'Retroceder'
SELECT @Nodo = Nodo, @NodoPadre = NodoPadre FROM @Nodos WHERE Tipo = 'Origen'
IF @Nodo IS NULL RETURN @Resultado
WHILE @Salir = 0
BEGIN
IF @Estatus = 'Retroceder'
BEGIN
SET @RutaRelativa = @RutaRelativa + '../'
SET @NodoAnterior = @Nodo
SELECT @Nodo = Nodo, @NodoPadre = NodoPadre, @Tipo = Tipo FROM @Nodos WHERE Nodo = @NodoPadre
END ELSE
IF @Estatus = 'Avanzar'
BEGIN
SELECT @NodoAnterior = ISNULL(@Nodo,'')
SELECT @Nodo = Nodo, @NodoPadre = NodoPadre, @Tipo = Tipo FROM @Nodos WHERE NodoPadre = @Nodo
IF @Nodo IS NOT NULL
BEGIN
SET @RutaRelativa = @RutaRelativa + ISNULL(@Nodo,'') + '/'
END
IF @Tipo = 'Destino' SET @Salir = 1
END
IF @Estatus = 'Retroceder' AND @Tipo = 'Destino' SET @Salir = 1 ELSE
IF @Estatus = 'Retroceder' AND EXISTS(SELECT 1 FROM @Nodos WHERE NodoPadre = @Nodo AND Nodo <> @NodoAnterior) SET @Estatus = 'Avanzar' ELSE
IF @Estatus = 'Retroceder' AND EXISTS(SELECT 1 FROM @Nodos WHERE Nodo = @Nodo AND NULLIF(NodoPadre,'') IS NULL) SET @Estatus = 'Avanzar'
END
IF REPLACE(@RelativaA,'/','') = @NodoPrincipal AND SUBSTRING(@RutaRelativa,1,3) = '../' SET @RutaRelativa = STUFF(@RutaRelativa,1,1,'')
SET @Resultado = @RutaRelativa
RETURN (@Resultado)
END

