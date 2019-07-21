SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOrdenarWebArtOpcionValor
@Estacion	        int,
@Tabla	        varchar(50),
@VariacionID	int,
@OpcionID    	int

AS BEGIN
DECLARE
@Orden		int,
@Clave		varchar(255),
@Actividad		varchar(10),
@ActividadID	int
SELECT @Tabla = UPPER(@Tabla)
BEGIN TRANSACTION
SELECT @Orden = 0
DECLARE crListaSt CURSOR FOR SELECT Clave FROM ListaSt WHERE Estacion = @Estacion ORDER BY ID
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Clave
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Orden = @Orden + 1
IF @Tabla = 'WebArtOpcionValor'  UPDATE WebArtOpcionValor SET Orden = @Orden WHERE Valor  = @Clave   AND  VariacionID = @VariacionID AND OpcionID  = @OpcionID
END
FETCH NEXT FROM crListaSt INTO @Clave
END 
CLOSE crListaSt
DEALLOCATE crListaSt
COMMIT TRANSACTION
RETURN
END

