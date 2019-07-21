SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInRutaCopiar
@Estacion		int,
@eDocIn                 varchar(50),
@RutaO                  varchar(50),
@RutaD                  varchar(50)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok			int,
@OkRef			varchar(255),
@Ruta                   varchar(50),
@OperadorLogico         varchar(1),
@Tipo                   varchar(50),
@GUID                   varchar(36),
@NuevoGUID              varchar(36)
SET @Transaccion = 'speDocInRutaCopiar' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
EXEC sp_msforeachtable "ALTER TABLE ? DISABLE TRIGGER  all"
IF @Ok IS NULL
INSERT eDocInRuta(eDocIn,   Ruta,   Descripcion, XSD, Modulo, Mov, Afectar, VigenciaDe, VigenciaA, AntesAfectar)
SELECT            @eDocIn,  @RutaD, Descripcion, XSD, Modulo, Mov, Afectar, VigenciaDe, VigenciaA, AntesAfectar
FROM eDocInRuta
WHERE eDocIn = @eDocIn AND Ruta = @RutaO
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
DECLARE creDocInRutaD CURSOR FOR
SELECT Ruta,   OperadorLogico, Tipo, GUID
FROM eDocInRutaD
WHERE eDocIn = @eDocIn AND Ruta = @RutaO
OPEN creDocInRutaD
FETCH NEXT FROM creDocInRutaD INTO @Ruta, @OperadorLogico, @Tipo, @GUID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @NuevoGUID = NEWID()
INSERT eDocInRutaD(eDocIn,   Ruta,   OperadorLogico,  Tipo,  GUID)
SELECT             @eDocIn,  @RutaD, @OperadorLogico, @Tipo, @NuevoGUID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT eDocInRutaDCondicion(eDocIn,   Ruta,   GUID,       Operando1, Operador, Operando2)
SELECT                      @eDocIn,  @RutaD,  @NuevoGUID, Operando1, Operador, Operando2
FROM eDocInRutaDCondicion
WHERE eDocIn = @eDocIn AND GUID = @GUID
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM creDocInRutaD INTO @Ruta, @OperadorLogico, @Tipo, @GUID
END
CLOSE creDocInRutaD
DEALLOCATE creDocInRutaD
END
IF @Ok IS NULL
INSERT eDocInRutaTabla(eDocIn,   Ruta,  Tablas, DetalleDe, Nodo, NodoNombre)
SELECT                 @eDocIn, @RutaD, Tablas, DetalleDe, Nodo, NodoNombre
FROM eDocInRutaTabla
WHERE  eDocIn = @eDocIn AND Ruta = @RutaO
IF @Ok IS NULL
INSERT eDocInRutaTablaD(eDocIn,   Ruta,   Tablas, CampoXML, ExpresionXML, CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaSt)
SELECT                  @eDocIn,  @RutaD, Tablas, CampoXML, ExpresionXML, CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaSt
FROM eDocInRutaTablaD
WHERE  eDocIn = @eDocIn AND Ruta = @RutaO
EXEC sp_msforeachtable "ALTER TABLE ? ENABLE TRIGGER all"
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT 'Proceso Exitoso'
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR  ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

