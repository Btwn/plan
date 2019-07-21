SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnReabastecerDomicilio (@Empresa varchar(5), @Almacen varchar(10), @Articulo varchar(20), @Domicilio varchar(20))
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado		varchar(20),
@Tipo		varchar(20),
@Pasillo		int,
@Fila		int,
@Zona		varchar(50)
SELECT @Resultado = NULL
SELECT @Tipo = UPPER(Tipo), @Pasillo = Pasillo, @Fila = Fila, @Zona = Zona
FROM AlmPos WITH(NOLOCK)
WHERE Almacen = @Almacen AND Posicion = @Domicilio
IF @Tipo = 'DOMICILIO'
BEGIN
IF @Resultado IS NULL
SELECT TOP(1) @Resultado = t.Tarima
FROM AlmPos ap WITH(NOLOCK)
JOIN Tarima t WITH(NOLOCK) ON t.Posicion = ap.Posicion AND dbo.fnExistenciaDeTarima(@Empresa, @Almacen, t.Tarima, @Articulo) > 0.0
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA'
AND ap.Zona = @Zona AND ap.Pasillo = @Pasillo
GROUP BY t.Tarima, ISNULL(t.FechaCaducidad, t.Alta)
ORDER BY ISNULL(t.FechaCaducidad, t.Alta), t.Tarima
IF @Resultado IS NULL
SELECT TOP(1) @Resultado = t.Tarima
FROM AlmPos ap WITH(NOLOCK)
JOIN Tarima t WITH(NOLOCK) ON t.Posicion = ap.Posicion AND dbo.fnExistenciaDeTarima(@Empresa, @Almacen, t.Tarima, @Articulo) > 0.0
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA'
AND ap.Pasillo = @Pasillo
GROUP BY t.Tarima, ISNULL(t.FechaCaducidad, t.Alta)
ORDER BY ISNULL(t.FechaCaducidad, t.Alta), t.Tarima
IF @Resultado IS NULL
SELECT TOP(1) @Resultado = t.Tarima
FROM AlmPos ap WITH(NOLOCK)
JOIN Tarima t WITH(NOLOCK) ON t.Posicion = ap.Posicion AND dbo.fnExistenciaDeTarima(@Empresa, @Almacen, t.Tarima, @Articulo) > 0.0
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA'
GROUP BY t.Tarima, ISNULL(t.FechaCaducidad, t.Alta)
ORDER BY ISNULL(t.FechaCaducidad, t.Alta), t.Tarima
END
RETURN(@Resultado)
END

