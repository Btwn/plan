SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPersonalDireccionFiscalMapear
@Estacion    int

AS BEGIN
DECLARE
@Personal       varchar(10),
@ID             int,
@ClaveCP        varchar(5),
@ClavePais      varchar(3),
@ClaveEstado    varchar(3),
@ClaveMunicipio varchar(3),
@ClaveLocalidad varchar(2),
@ClaveColonia   varchar(4),
@DescPais       varchar(255),
@DescEstado     varchar(255),
@DescMunicipio  varchar(255),
@DescLocalidad  varchar(255),
@DescColonia    varchar(255),
@CodigoPostal   varchar(15)
SELECT @Personal = MIN(Clave) FROM ListaSt WHERE Estacion = @Estacion
WHILE @Personal IS NOT NULL
BEGIN
SELECT @CodigoPostal = NULL, @ClaveCP = NULL, @ClavePais = NULL, @ClaveEstado = NULL, @ClaveMunicipio = NULL, @ClaveLocalidad = NULL, @ClaveColonia = NULL,
@DescPais = NULL, @DescEstado = NULL, @DescMunicipio = NULL, @DescLocalidad = NULL, @DescColonia = NULL
SELECT @CodigoPostal = CodigoPostal FROM Personal WHERE Personal = @Personal
IF ISNULL(@CodigoPostal,'') <> '' AND ((SELECT COUNT(1) FROM SATDireccionFiscal WHERE ClaveCP = @CodigoPostal) = 1)
BEGIN
SELECT @ClaveCP = ClaveCP, @ClavePais = ClavePais, @DescPais = SATPaisDescripcion,
@ClaveEstado = ClaveEstado, @DescEstado = SATEstadoDescripcion, @ClaveMunicipio = ClaveMunicipio,
@DescMunicipio =  SATMunicipioDescripcion, @ClaveLocalidad = ClaveLocalidad,  @DescLocalidad = SATLocalidadDescripcion,
@ClaveColonia = ClaveColonia, @DescColonia = SATColoniaDescripcion
FROM SATDireccionFiscal WHERE ClaveCP = @CodigoPostal
IF ISNULL(@ClaveCP,'') <> '' AND ISNULL(@ClavePais,'') <> '' AND ISNULL(@ClaveEstado,'') <> '' AND ISNULL(@ClaveMunicipio,'') <> ''
AND ISNULL(@ClaveColonia,'') <> '' 
BEGIN
UPDATE PersonalDireccionFiscal SET Mapeado = 1, Icono = 434, ClaveCP = @ClaveCP, ClavePais = @ClavePais, ClaveEstado = @ClaveEstado,
ClaveMunicipio = @ClaveMunicipio, ClaveLocalidad = @ClaveLocalidad, ClaveColonia = @ClaveColonia
WHERE Personal = @Personal AND ISNULL(Mapeado,0) = 0
UPDATE Personal SET Delegacion = @DescMunicipio, Colonia = @DescColonia, CodigoPostal = @ClaveCP,
Poblacion = @DescLocalidad, Estado = @DescEstado, Pais = @DescPais WHERE Personal = @Personal
END
END
SELECT @Personal = MIN(Clave) FROM ListaSt WHERE Estacion = @Estacion AND Clave > @Personal
END
RETURN
END

