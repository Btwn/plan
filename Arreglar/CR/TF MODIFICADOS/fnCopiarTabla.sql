SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCopiarTabla
(
@Tabla varchar(50)
)
RETURNS @Resultado TABLE
(
Tabla		varchar(50) COLLATE DATABASE_DEFAULT NULL
)

AS BEGIN
DECLARE @Campo varchar(50)
SELECT @Campo = @Tabla, @Tabla = @Tabla + '%'
INSERT @Resultado
SELECT CASE WHEN @Campo = 'UsuarioAcceso' THEN 'UsuarioMenuOpcion' END Tabla
UNION ALL
SELECT Tabla
FROM SysCampoExt
WHERE Tabla LIKE @Tabla
AND Tabla <> CASE WHEN @Campo = 'UsuarioAcceso' THEN '' ELSE @Campo END
AND Campo = CASE WHEN @Campo = 'UsuarioAcceso' THEN Campo ELSE @Campo END
AND Tabla <> CASE WHEN @Campo = 'Usuario' THEN 'UsuarioAcceso' ELSE '' END
AND Tabla <> CASE WHEN @Campo = 'Usuario' THEN 'UsuarioAccesoForma' ELSE '' END
AND Tabla <> CASE WHEN @Campo = 'Usuario' THEN 'UsuarioMenuOpcion' ELSE '' END
GROUP BY Tabla
ORDER BY Tabla
RETURN
END

