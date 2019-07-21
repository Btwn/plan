SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMonConsultarTipoCambio
@Estacion	int

AS BEGIN
DECLARE
@Respuesta			varchar(max),
@LongitudInicial	int,
@LongitudFinal		int,
@LEN				int,
@Longitud			int,
@TipoCambio			float,
@Ok					int,
@OkRef				varchar(255),
@URL				varchar(max),
@ExpInicial			varchar(max),
@ExpFinal			varchar(max),
@Codigo				varchar(5)
DELETE MonActualizarTemp WHERE Estacion = @Estacion
DECLARE crMonConsultarTipoCambio CURSOR LOCAL FOR
SELECT m.CodigoInt, a.Url, a.ExpInicial, a.ExpFinal
FROM Mon m
JOIN MonCodigoInternacional c
ON m.CodigoInt = c.Codigo
JOIN MonActualizacionAuto a
ON c.ActualizacionAuto = a.ActualizacionAuto
OPEN crMonConsultarTipoCambio
FETCH NEXT FROM crMonConsultarTipoCambio INTO @Codigo, @URL, @ExpInicial, @ExpFinal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spWebServiceSolicitud @URL, 'post', '','','', '', @Respuesta out
SELECT @ExpInicial = SUBSTRING(@ExpInicial,48,18)
SELECT @LEN = LEN(@ExpInicial)
SELECT @LongitudInicial = CHARINDEX(@ExpInicial,@Respuesta,0)+ @LEN
SELECT @LongitudFinal = CHARINDEX(@ExpFinal,@Respuesta, @LongitudInicial)
SELECT @Longitud = @LongitudFinal - @LongitudInicial
SELECT @TipoCambio = CASE WHEN dbo.fnEsNumerico(SUBSTRING(@Respuesta,@LongitudInicial,@Longitud))=0 THEN NULL ELSE SUBSTRING(@Respuesta,@LongitudInicial,@Longitud) END
IF @TipoCambio IS NULL
SELECT @Ok = 35110, @OkRef = ISNULL(@Codigo,'') + ' ' + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = 35110)
IF @Ok IS NULL
INSERT MonActualizarTemp(Estacion, Moneda, Codigo,  TipoCambio,  Estatus,    Icono)
SELECT                  @Estacion, Moneda, @Codigo, @TipoCambio, 'Correcto', 339
FROM Mon WHERE CodigoInt = @Codigo
ELSE
INSERT MonActualizarTemp(Estacion, Moneda, Codigo,  TipoCambio, Estatus, Icono)
SELECT                  @Estacion, Moneda, @Codigo, NULL,       'Error', 416
FROM Mon WHERE CodigoInt = @Codigo
SELECT @Ok = NULL
END
FETCH NEXT FROM crMonConsultarTipoCambio INTO @Codigo, @URL, @ExpInicial, @ExpFinal
END
CLOSE crMonConsultarTipoCambio
DEALLOCATE crMonConsultarTipoCambio
END

