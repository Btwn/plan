SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSDatosVueloVerificar
@ID		varchar(36),
@Requiere	bit,
@Expresion	varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @NombreDF			varchar(30),
@ApellidosDF		varchar(60),
@PasaporteDF		varchar(30),
@NacionalidadDF		varchar(30),
@NoVueloDF			varchar(20),
@AerolineaDF		varchar(50),
@OrigenDF			varchar(100),
@DestinoDF			varchar(100),
@Respuesta			bit
SET @Respuesta = 0
SELECT	@NombreDF			= NULLIF(NombreDF,''),
@ApellidosDF		= NULLIF(ApellidosDF,''),
@PasaporteDF		= NULLIF(PasaporteDF,''),
@NacionalidadDF		= NULLIF(NacionalidadDF,''),
@NoVueloDF			= NULLIF(NoVueloDF,''),
@AerolineaDF		= NULLIF(AerolineaDF,''),
@OrigenDF			= NULLIF(OrigenDF,''),
@DestinoDF			= NULLIF(DestinoDF,'')
FROM  POSL
WHERE  ID = @ID
IF @NombreDF IS NULL OR @ApellidosDF IS NULL OR @PasaporteDF IS NULL OR
@NacionalidadDF IS NULL OR @NoVueloDF IS NULL OR @AerolineaDF  IS NULL OR
@OrigenDF IS NULL OR @DestinoDF IS NULL
SET	@Respuesta = 1
IF @Requiere = 0
SELECT @Respuesta
IF @Requiere = 1
IF @Respuesta = 1
SELECT @Expresion = 'FormaModal('+CHAR(39)+'DatosVueloDF'+CHAR(39)+')'
ELSE
SELECT @Expresion = NULL
END

