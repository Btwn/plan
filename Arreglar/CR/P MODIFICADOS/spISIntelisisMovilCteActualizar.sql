SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilCteActualizar
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
BEGIN TRY
DECLARE
@Agente				varchar(10),
@Usuario			varchar(10),
@Cliente			varchar(10),
@Nombre				varchar(100),
@Direccion			varchar(100),
@DireccionNumero	varchar(20),
@DireccionNumeroInt	varchar(20),
@Delegacion			varchar(100),
@Colonia			varchar(100),
@Poblacion			varchar(100),
@Estado				varchar(30),
@Pais				varchar(30),
@CodigoPostal		varchar(15),
@RFC				varchar(20),
@Telefonos			varchar(100),
@eMail1				varchar(50),
@ListaPrecios		varchar(22),
@Estatus			varchar(15),
@Descuento			varchar(30),
@ZonaImpuesto		varchar(30),
@CreditoLimite		varchar(22),
@Contacto1			varchar(50),
@Contacto2			varchar(50),
@MapaLatitud		varchar(22),
@MapaLongitud		varchar(22),
@MapaPrecision		varchar(10),
@Extencion1         varchar(10),
@EntreCalles        varchar(100),
@Observaciones      varchar(100),
@Correcto           bit
SELECT
@Usuario				= Usuario,
@Cliente				= Cte,
@Nombre					= Nombre,
@Direccion				= Direccion,
@DireccionNumero		= DireccionNumero,
@DireccionNumeroInt		= DireccionNumeroInt,
@Delegacion				= Delegacion,
@Colonia				= Colonia,
@Poblacion				= Poblacion,
@Estado					= Estado,
@Pais					= Pais,
@CodigoPostal			= CodigoPostal,
@RFC					= RFC,
@Telefonos				= Telefonos,
@eMail1					= eMail1,
@ListaPrecios			= ListaPrecios,
@Estatus				= Estatus,
@Descuento				= Descuento,
@ZonaImpuesto			= ZonaImpuesto,
@CreditoLimite			= CreditoLimite,
@Contacto1				= Contacto1,
@Contacto2				= Contacto2,
@MapaLatitud			= MapaLatitud,
@MapaLongitud			= MapaLongitud,
@MapaPrecision			= MapaPrecision,
@Extencion1             = Extencion1,
@EntreCalles            = EntreCalles,
@Observaciones          = Observaciones
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario            varchar(10), Cte          varchar(10),  Nombre      varchar(100), Direccion    varchar(100), DireccionNumero varchar(20),
DireccionNumeroInt varchar(20), Delegacion   varchar(100), Colonia     varchar(100), Poblacion    varchar(100), Estado          varchar(30),
Pais               varchar(30), CodigoPostal varchar(15),  RFC         varchar(20),  Telefonos    varchar(100), eMail1          varchar(50),
ListaPrecios       varchar(20), Estatus      varchar(15),  Descuento   varchar(30),  ZonaImpuesto varchar(30),  CreditoLimite   varchar(20),
Contacto1          varchar(50), Contacto2    varchar(50),  MapaLatitud varchar(20),  MapaLongitud varchar(20),  MapaPrecision   float,
Extencion1         varchar(10), EntreCalles  varchar(100), Observaciones varchar(100))
IF (CASE WHEN LEN(@RFC) = 10 THEN ISNUMERIC(RIGHT(@RFC,6)) ELSE 1 END) = 1 AND NOT EXISTS(SELECT RFC FROM Cte WITH (NOLOCK) WHERE RFC = @RFC AND Cliente <> @Cliente) AND ISNULL(@RFC,'') <> ''
BEGIN
EXEC spRegistroOk 'RFC', @RFC, '', 1 , @Correcto OUTPUT
END
SELECT @Correcto
IF ISNULL(@Correcto,0) = 0
BEGIN
SET @Ok = 60260
END
ELSE
BEGIN
IF EXISTS(SELECT Cliente FROM Cte WITH (NOLOCK) WHERE	Cliente = @Cliente)
BEGIN
SELECT
@Nombre = NULLIF(@Nombre,''),
@Direccion = NULLIF(@Direccion,''),
@DireccionNumero = NULLIF(@DireccionNumero,''),
@DireccionNumeroInt=NULLIF(@DireccionNumeroInt,''),
@Delegacion = NULLIF(@Delegacion,''),
@Colonia = NULLIF(@Colonia,''),
@Poblacion = NULLIF(@Poblacion,''),
@Estado= NULLIF(@Estado,''),
@Pais=NULLIF(@Pais,''),
@CodigoPostal=NULLIF(@CodigoPostal,''),
@RFC=NULLIF(@RFC,''),
@Telefonos=NULLIF(@Telefonos,''),
@eMail1=NULLIF(@eMail1,''),
@ListaPrecios=NULLIF(@ListaPrecios,''),
@Estatus=NULLIF(@Estatus,''),
@Descuento=NULLIF(@Descuento,''),
@ZonaImpuesto=NULLIF(@ZonaImpuesto,''),
@CreditoLimite=NULLIF(@CreditoLimite,''),
@Contacto1=NULLIF(@Contacto1,''),
@Contacto2=NULLIF(@Contacto2,''),
@MapaLatitud=NULLIF(@MapaLatitud,''),
@MapaLongitud=NULLIF(@MapaLongitud,''),
@MapaPrecision=NULLIF(@MapaPrecision,''),
@Extencion1=NULLIF(@Extencion1,''),
@EntreCalles=NULLIF(@EntreCalles,''),
@Observaciones=NULLIF(@Observaciones,'')
UPDATE Cte WITH (ROWLOCK)
SET
Nombre             = ISNULL(@Nombre,             Nombre            ),
Direccion          = ISNULL(@Direccion,          Direccion         ),
DireccionNumero    = ISNULL(@DireccionNumero,    DireccionNumero   ),
DireccionNumeroInt = ISNULL(@DireccionNumeroInt, DireccionNumeroInt),
Delegacion         = ISNULL(@Delegacion,         Delegacion        ),
Colonia            = ISNULL(@Colonia,            Colonia           ),
Poblacion          = ISNULL(@Poblacion,          Poblacion         ),
Estado             = ISNULL(@Estado,             Estado            ),
Pais               = ISNULL(@Pais,               Pais              ),
CodigoPostal       = ISNULL(@CodigoPostal,       CodigoPostal      ),
RFC                = ISNULL(@RFC,                RFC               ),
Telefonos          = ISNULL(@Telefonos,          Telefonos         ),
eMail1             = ISNULL(@eMail1,             eMail1            ),
ListaPrecios       = ISNULL(@ListaPrecios,       ListaPrecios      ),
Estatus            = ISNULL(@Estatus,            Estatus           ),
Descuento          = ISNULL(@Descuento,          Descuento         ),
ZonaImpuesto       = ISNULL(@ZonaImpuesto,       ZonaImpuesto      ),
CreditoLimite      = ISNULL(@CreditoLimite,      CreditoLimite     ),
Contacto1          = ISNULL(@Contacto1,          Contacto1         ),
Contacto2          = ISNULL(@Contacto2,          Contacto2         ),
MapaLatitud        = ISNULL(@MapaLatitud,        MapaLatitud       ),
MapaLongitud       = ISNULL(@MapaLongitud,       MapaLongitud      ),
MapaPrecision      = ISNULL(@MapaPrecision,      MapaPrecision     ),
Extencion1         = ISNULL(@Extencion1,         Extencion1        ),
EntreCalles        = ISNULL(@EntreCalles,        EntreCalles       ),
Observaciones      = ISNULL(@Observaciones,      Observaciones       )
WHERE
Cliente = @Cliente
END
ELSE
BEGIN
SET @Ok = 26060
END
END
END TRY
BEGIN CATCH
SELECT @OkRef = REPLACE(ERROR_MESSAGE(), '"', ''), @Ok = 1
END CATCH
SELECT @Resultado = '<MovilCteActualizar><Cliente>' + @Cliente + '</Cliente></MovilCteActualizar>'
END

