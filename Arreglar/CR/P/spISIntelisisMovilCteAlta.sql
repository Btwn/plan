SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilCteAlta
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
BEGIN TRY
SELECT @Resultado = '<MovilCteAlta><Cliente>' + 'Cliente' + '</Cliente></MovilCteAlta>'
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
@MapaPrecision		varchar(22),
@Observaciones      varchar(100),
@Extencion1         varchar(10),
@EntreCalles        varchar(100),
@Correcto           bit,
@DefMoneda			varchar(10),
@Tipo           varchar(20),
@Nivel          varchar(20),
@Prefijo        varchar(5),
@Consecutivo    int,
@Sucursal       int
SELECT
@Usuario				= Usuario,
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
@Observaciones          = Observaciones,
@Extencion1             = Extencion1,
@EntreCalles            = EntreCalles,
@Observaciones          = Observaciones
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario            varchar(10),  Cte          varchar(10),  Nombre      varchar(100), Direccion    varchar(100), DireccionNumero varchar(20),
DireccionNumeroInt varchar(20),  Delegacion   varchar(100), Colonia     varchar(100), Poblacion    varchar(100), Estado          varchar(30),
Pais               varchar(30),  CodigoPostal varchar(15),  RFC         varchar(20),  Telefonos    varchar(100), eMail1          varchar(50),
ListaPrecios       varchar(20),  Estatus      varchar(15),  Descuento   varchar(30),  ZonaImpuesto varchar(30),  CreditoLimite   varchar(20),
Contacto1          varchar(50),  Contacto2    varchar(50),  MapaLatitud varchar(20),  MapaLongitud varchar(20),  MapaPrecision   varchar(20),
Observaciones      varchar(100), Extencion1   varchar(10),  EntreCalles varchar(100))
SELECT @DefMoneda = MonedaBase FROM MovilUsuarioCfg WHERE Usuario = @Usuario
SELECT @Prefijo=ISNULL(Prefijo,'C'), @Nivel=Nivel, @Consecutivo=ISNULL(Consecutivo,0) FROM Consecutivo WHERE tipo = 'CTE'
SELECT @Cliente = @Prefijo + CONVERT(varchar(4),@Consecutivo + 1)
IF (@Cliente IS NULL)
BEGIN
WHILE (EXISTS(SELECT Cliente FROM Cte WHERE Cliente = @Cliente) OR @Cliente IS NULL) AND @Ok IS NULL
BEGIN
SELECT @Cliente = ISNULL(EG.CteExpressPrefijo, 'C') + RIGHT('0' + CAST(CAST(RAND() * POWER(10, ISNULL(EG.CteExpressDigitos,5)) AS int) AS VARCHAR(MAX)), ISNULL(EG.CteExpressDigitos,5))
FROM EmpresaGral EG
JOIN MovilUsuarioCfg MU ON EG.Empresa = MU.Empresa AND MU.Usuario = @Usuario
END
END
IF @Cliente IS NULL
SET @Ok = 40010
IF ISNULL(@Agente,'') = ''
SELECT @Agente = Agente
FROM MovilUsuarioCfg
WHERE Usuario = @Usuario
IF (CASE WHEN LEN(@RFC) = 10 THEN ISNUMERIC(RIGHT(@RFC,6)) ELSE 1 END) = 1 AND NOT EXISTS(SELECT RFC FROM Cte WHERE RFC = @RFC AND Cliente <> @Cliente)
BEGIN
EXEC spRegistroOk 'RFC', @RFC, '', 1 , @Correcto OUTPUT
END
IF ISNULL(@Correcto,0) = 0
SET @Ok = 60260
IF NOT EXISTS(SELECT * FROM Cte WHERE RFC = @RFC)
BEGIN
INSERT Cte
(Cliente,        Nombre,      Direccion,                  DireccionNumero,             DireccionNumeroInt,           Delegacion,
Colonia,        Poblacion,   Estado,                     Pais,                        CodigoPostal,                 RFC,
Telefonos,      eMail1,      ListaPrecios,               Estatus,                     Descuento,                    ZonaImpuesto,
CreditoLimite,  Contacto1,   Contacto2,                  MapaLatitud,                 MapaLongitud,                 MapaPrecision,
Observaciones,  Extencion1,  EntreCalles,                Agente,						DefMoneda)
SELECT @Cliente,       @Nombre,     @Direccion,                 @DireccionNumero,            @DireccionNumeroInt,          @Delegacion,
@Colonia,       @Poblacion,  @Estado,		              @Pais,                       @CodigoPostal,                @RFC,
@Telefonos,     @eMail1,     CAST(@ListaPrecios AS INT), @Estatus,                    @Descuento,                   @ZonaImpuesto,
@CreditoLimite, @Contacto1,  @Contacto2,                 CAST(@MapaLatitud AS FLOAT), CAST(@MapaLongitud AS FLOAT), CAST(@MapaLongitud AS FLOAT),
@Observaciones, @Extencion1, @EntreCalles,               @Agente,						@DefMoneda
UPDATE Consecutivo SET consecutivo= (@Consecutivo + 1) WHERE tipo = 'CTE'
END
ELSE
BEGIN
SET @Ok = 55330
END
END TRY
BEGIN CATCH
SELECT @OkRef = REPLACE(ERROR_MESSAGE(), '"', ''), @Ok = 1
END CATCH
SELECT @Resultado = '<MovilCteAlta><Cliente>' + @Cliente + '</Cliente></MovilCteAlta>'
END

