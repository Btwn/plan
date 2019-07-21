SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocINRutaTablaD
@eDocIn          varchar(50),
@Ruta            varchar(50),
@Tablas          varchar(50),
@Ok              int = NULL,
@OkRef           varchar(255)= NULL

AS BEGIN
DECLARE
@Campo      varchar(50),
@TipoDatos  varchar(50),
@DetalleDe  varchar(50),
@Nodo       varchar(8000),
@NodoNombre varchar(8000),
@Modulo     varchar(20)
DECLARE @Tabla table(Campo  varchar(50),TipoDatos  varchar(50))
SELECT  @DetalleDe = t.DetalleDe, @Nodo =  t.Nodo, @NodoNombre = t.NodoNombre, @Modulo = r.Modulo
FROM eDocInRutaTabla t JOIN eDocInRuta r ON t.eDocIn = r.eDocIn AND t.Ruta = r.Ruta
WHERE t.eDocIn =  @eDocIn AND t.Ruta = @Ruta AND t.Tablas = @Tablas
IF NOT EXISTS(SELECT * FROM eDocInRutaTablaD WHERE eDocIn =  @eDocIn AND Ruta = @Ruta AND Tablas = @Tablas)
BEGIN
INSERT @Tabla (Campo, TipoDatos)
SELECT * FROM dbo.fneDocInCamposTabla(@Tablas)
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
DECLARE crTablaD CURSOR FOR
SELECT Campo, TipoDatos
FROM @Tabla
OPEN crTablaD
FETCH NEXT FROM crTablaD INTO @Campo, @TipoDatos
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC speDocINInsertarRutaTablaD    @eDocIn, @Ruta, @Tablas, @Campo, @TipoDatos,@DetalleDe, @Nodo, @NodoNombre, @Modulo, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crTablaD INTO @Campo, @TipoDatos
END
CLOSE crTablaD
DEALLOCATE crTablaD
END
END
IF @Ok IS NULL
EXEC speDocINInsertarRutaTablaDOmision @eDocIn, @Ruta, @Tablas,  @Modulo, @Ok OUTPUT, @OkRef OUTPUT
END

