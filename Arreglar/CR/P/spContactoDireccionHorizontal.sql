SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContactoDireccionHorizontal
@Estacion					int,
@ContactoTipo				varchar(20),
@ContactoDesde				varchar(10),
@ContactoHasta				varchar(10),
@IncluirNombre				bit,
@IncluirContacto			bit,
@IncluirRFC					bit,
@IncluirTelefono			bit

AS BEGIN
SET NOCOUNT ON
DECLARE
@ContactoCursor				varchar(10),
@ContactoTipoCursor			varchar(20),
@DireccionCursor			varchar(255),
@ID							int,
@ContactoCursor2				varchar(10)
DELETE ContactoDireccionHorizontal WHERE Estacion = @Estacion
SET @ContactoDesde = NULLIF(NULLIF(NULLIF(@ContactoDesde,''),'(Todos)'),'(Todas)')
SET @ContactoHasta = NULLIF(NULLIF(NULLIF(@ContactoHasta,''),'(Todos)'),'(Todas)')
EXEC spContactoDireccion @Estacion, @ContactoTipo, @ContactoDesde, @ContactoHasta, @IncluirNombre, @IncluirContacto, @IncluirRFC, @IncluirTelefono
INSERT ContactoDireccionHorizontal (Estacion, ContactoTipo, Contacto,   Direccion1)
SELECT  Estacion, ContactoTipo, d.Contacto, d.Direccion
FROM  ContactoDireccion d
WHERE  d.ID = 1
AND  Estacion = @Estacion
UPDATE ContactoDireccionHorizontal SET Direccion2 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 2
UPDATE ContactoDireccionHorizontal SET Direccion3 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 3
UPDATE ContactoDireccionHorizontal SET Direccion4 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 4
UPDATE ContactoDireccionHorizontal SET Direccion5 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 5
UPDATE ContactoDireccionHorizontal SET Direccion6 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 6
UPDATE ContactoDireccionHorizontal SET Direccion7 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 7
UPDATE ContactoDireccionHorizontal SET Direccion8 = d.Direccion
FROM ContactoDireccionHorizontal r JOIN ContactoDireccion d
ON d.ContactoTipo = r.ContactoTipo AND d.Contacto = r.Contacto
WHERE d.ID = 8
END

