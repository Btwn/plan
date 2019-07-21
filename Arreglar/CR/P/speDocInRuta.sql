SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInRuta
@XML                                    varchar(max),
@Empresa                                varchar(5),
@Usuario                                varchar(10),
@Sucursal                               int,
@Origen                                 varchar(max),
@Estacion                               int,
@Ok					int = NULL OUTPUT,
@OkRef	 				varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@eDocIn                varchar(50),
@Ruta                  varchar(50),
@XSD                   varchar(50),
@Valido                bit,
@Verificado            bit,
@Fecha                 datetime
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SET @Valido = 0
SET @Verificado = 0
DECLARE creDocINRuta CURSOR FOR
SELECT eDocIn, Ruta, NULLIF(XSD,'')
FROM eDocInRuta
WHERE @Fecha BETWEEN ISNULL(VigenciaDe,@Fecha) AND ISNULL(VigenciaA,@Fecha)
GROUP BY eDocIn, Ruta, XSD
OPEN creDocINRuta
FETCH NEXT FROM creDocINRuta INTO @eDocIn, @Ruta, @XSD
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Ok IS NULL
BEGIN
EXEC speDocInRutaCondiciones  @eDocIn, @Ruta, @XML,'Condicion', @Origen, @Empresa, @Valido  OUTPUT, @Ok   OUTPUT, @OkRef  OUTPUT
IF @Ok IS NULL AND @XSD IS NOT NULL
EXEC speDocINValidarXMLTyped  @eDocIn, @Ruta, @XML, @Ok   OUTPUT, @OkRef  OUTPUT
IF @Ok IS NULL AND @XSD IS  NULL
EXEC speDocINValidarXML @XML, @Ok   OUTPUT, @OkRef  OUTPUT
IF @Ok IS NULL
EXEC speDocInRutaCondiciones  @eDocIn, @Ruta, @XML,'Validar', @Origen, @Empresa, @Verificado  OUTPUT, @Ok   OUTPUT, @OkRef  OUTPUT
IF EXISTS(SELECT * FROM eDocInRutaD WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND Tipo = 'Validar') AND @Verificado = 0 AND @Ok IS NULL
SELECT  @Ok = 72363 ,@OkRef = '('+@eDocIn+','+ @Ruta+')'
IF @Valido = 1 AND @Verificado = 1 AND @Ok IS NULL
EXEC speDocInXML   @eDocIn, @Ruta, @XML, @Empresa, @Usuario, @Sucursal, @Origen, @Ok  OUTPUT, @OkRef  OUTPUT
END
FETCH NEXT FROM creDocINRuta INTO @eDocIn, @Ruta, @XSD
END
CLOSE creDocINRuta
DEALLOCATE creDocINRuta
IF @Ok IS NOT NULL 
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END

