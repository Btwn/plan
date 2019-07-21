SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnContactoDireccionHorizontal
(
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@IncluirNombre				bit,
@IncluirContacto			bit,
@IncluirRFC					bit,
@IncluirTelefono			bit
)
RETURNS @Resultado TABLE
(
ContactoTipo	varchar(20) COLLATE DATABASE_DEFAULT NULL,
Contacto		varchar(10) COLLATE DATABASE_DEFAULT NULL,
Direccion1		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion2		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion3		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion4		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion5		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion6		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion7		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion8		varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion9		varchar(255) COLLATE DATABASE_DEFAULT NULL
)

AS BEGIN
DECLARE
@ContactoCursor				varchar(10),
@ContactoTipoCursor			varchar(20),
@DireccionCursor			varchar(255),
@ID							int
SET @Contacto = NULLIF(@Contacto,'')
DECLARE @Direccion TABLE
(
ContactoTipo	varchar(20) COLLATE DATABASE_DEFAULT NULL,
Contacto		varchar(10) COLLATE DATABASE_DEFAULT NULL,
ID			int,
Direccion		varchar(255) COLLATE DATABASE_DEFAULT NULL
)
INSERT @Direccion (ContactoTipo, Contacto, ID, Direccion)
SELECT  ContactoTipo, Contacto, ID, Direccion
FROM dbo.fnContactoDireccion(@ContactoTipo,@Contacto,@IncluirNombre,@IncluirContacto,@IncluirRFC, @IncluirTelefono)
DECLARE crContacto CURSOR FOR
SELECT ContactoTipo, Contacto
FROM @Direccion
GROUP BY ContactoTipo, Contacto
OPEN crContacto
FETCH NEXT FROM crContacto INTO @ContactoTipoCursor, @ContactoCursor
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @Resultado (ContactoTipo,        Contacto,        Direccion1)
SELECT  @ContactoTipoCursor, @ContactoCursor, d.Direccion
FROM  @Direccion d
WHERE  d.ID = 1
AND  d.Contacto = @ContactoCursor
AND  d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion2 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 2
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion3 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 3
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion4 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 4
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion5 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 5
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion6 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 6
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion7 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 7
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion8 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 8
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
UPDATE @Resultado SET Direccion9 = d.Direccion
FROM @Resultado r JOIN @Direccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 9
AND d.Contacto = @ContactoCursor
AND d.ContactoTipo = @ContactoTipoCursor
FETCH NEXT FROM crContacto INTO @ContactoTipoCursor, @ContactoCursor
END
CLOSE crContacto
DEALLOCATE crContacto
RETURN
END

