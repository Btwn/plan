SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtGenerarCombinaciones
@IDArt        int,
@IDVariacion  int,
@Ok           int = NULL OUTPUT

AS BEGIN
DECLARE
@SELECT       varchar(MAX),
@SELECT2      varchar(MAX),
@SELECT3      varchar(MAX),
@SELECT4      varchar(MAX),
@WHERE        varchar(MAX),
@FROM         varchar(MAX),
@Contador     int,
@Nombre       varchar(100),
@ID           int,
@Alias        varchar(50),
@Valor        varchar(100),
@SQL          varchar(MAX),
@SQL2         varchar(MAX),
@IDTabla      int,
@IDTemp       int,
@IDTemp2      int,
@IDValor      varchar(100),
@Orden        int,
@Opciones     varchar(1000),
@SubCuenta    varchar(50),
@Articulo     varchar(20),
@TipoOpcion   varchar(20)
DECLARE @Tabla TABLE (ID int,IDOpcion  int,NombreOpcion varchar(100), IDCombinacion int, Valor varchar(100))
IF @IDArt IS NULL OR @IDVariacion IS NULL SET @Ok = 1
IF NOT EXISTS(SELECT * FROM WebArtVariacion WHERE ID = @IDVariacion) SET @Ok = 1
IF NOT EXISTS(SELECT * FROM WebArtOpcion WHERE VariacionID = @IDVariacion) SET @Ok = 1
IF NOT EXISTS(SELECT * FROM WebArtOpcionValor WHERE VariacionID = @IDVariacion) SET @Ok = 1
IF EXISTS(SELECT * FROM SysObjects WHERE id = object_id('dbo.WebArtCobinacionTemp')) AND @Ok IS NULL
DROP TABLE WebArtCobinacionTemp
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Articulo = Articulo FROM WebArt WHERE ID = @IDArt
SELECT @TipoOpcion = TipoOpcion FROM Art WHERE Articulo = @Articulo
SELECT @SELECT = '', @FROM = '', @SELECT2 = '', @SELECT3 = '', @SELECT4= '', @WHERE = '', @Contador = 1  ,@SQL2 =''
IF EXISTS(SELECT * FROM WebArtOpcion WHERE VariacionID = @IDVariacion) AND @Ok IS NULL
BEGIN
DECLARE crVariacion CURSOR FAST_FORWARD FOR
SELECT o.Nombre, o.ID
FROM WebArtOpcion o
WHERE o.VariacionID = @IDVariacion
ORDER BY o.Orden
OPEN  crVariacion
FETCH NEXT FROM  crVariacion INTO @Nombre, @ID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Alias = CONVERT(varchar,@Contador)
IF @Contador = 1
SELECT @SELECT = @SELECT + ' SELECT NULL ID, v'+ @Alias +'.Valor As ['+ISNULL(@Nombre,'')+'] '
ELSE
SELECT @SELECT = @SELECT + ' , v'+ @Alias +'.Valor As ['+ISNULL(@Nombre,'')+'] '
IF @Contador = 1
SELECT @SELECT2 = @SELECT2 + ',CONVERT(varchar,v'+ @Alias +'.ID)+'+CHAR(39)+','+CHAR(39)
ELSE
SELECT @SELECT2 = @SELECT2 + '+CONVERT(varchar,v'+ @Alias +'.ID)+'+CHAR(39)+','+CHAR(39)
IF @Contador = 1
SELECT @SELECT3 = @SELECT3 + ',o'+@Alias+'.Nombre+'+CHAR(39)+': '+CHAR(39) +'+ v'+ @Alias +'.Valor +'+CHAR(39)+','+CHAR(39)
ELSE
SELECT @SELECT3 = @SELECT3 + '+ o'+@Alias+'.Nombre+'+CHAR(39)+': '+CHAR(39) +'+v'+ @Alias +'.Valor +'+CHAR(39)+','+CHAR(39)
IF @Contador = 1
SELECT @SELECT4 = @SELECT4 + ',ISNULL(o'+ @Alias +'.OpcionIntelisis,'+CHAR(39)+CHAR(39)+')+ISNULL(CONVERT(varchar,v'+@Alias+'.NumeroIntelisis),'+CHAR(39)+CHAR(39)+')+'+CHAR(39)+','+CHAR(39)
ELSE
SELECT @SELECT4 = @SELECT4 + '+ISNULL(o'+ @Alias +'.OpcionIntelisis,'+CHAR(39)+CHAR(39)+')+ISNULL(CONVERT(varchar,v'+@Alias+'.NumeroIntelisis),'+CHAR(39)+CHAR(39)+')+'+CHAR(39)+','+CHAR(39)
IF @Contador = 1
SELECT @FROM = @FROM + ' INTO WebArtCobinacionTemp FROM WebArtOpcion o' + @Alias + ' JOIN WebArtOpcionValor v' + @Alias + ' ON o' + @Alias + '.VariacionID = v' + @Alias + '.VariacionID AND o' + @Alias + '.ID = v' + @Alias +'.OpcionID '
ELSE
SELECT @FROM = @FROM + 'LEFT JOIN WebArtOpcion o' + @Alias + ' ON 1 = 1 JOIN WebArtOpcionValor v' + @Alias + ' ON o' + @Alias + '.VariacionID = v' + @Alias + '.VariacionID AND o' + @Alias + '.ID = v' + @Alias +'.OpcionID '
IF @Contador = 1
SELECT @WHERE = @WHERE + ' WHERE o' + @Alias + '.VariacionID = ' + CONVERT(varchar,@IDVariacion) + ' AND o' + @Alias + '.ID = '+ CONVERT(varchar,@ID) + '  '
ELSE
SELECT @WHERE = @WHERE + ' AND o' + @Alias + '.VariacionID = ' + CONVERT(varchar,@IDVariacion) + ' AND o' + @Alias + '.ID = '+ CONVERT(varchar,@ID) + '  '
SET @Contador = @Contador + 1
FETCH NEXT FROM  crVariacion INTO  @Nombre, @ID
END
CLOSE  crVariacion
DEALLOCATE  crVariacion
END
SELECT @SELECT2 = REVERSE(STUFF(REVERSE(@SELECT2),1,4,''))
SELECT @SELECT3 = REVERSE(STUFF(REVERSE(@SELECT3),1,4,''))
SELECT @SELECT4 = REVERSE(STUFF(REVERSE(@SELECT4),1,4,''))
SELECT @SQL = @SELECT + @SELECT2 + ' IDValor '+@SELECT3 +'Opciones '+@SELECT4 +' SubCuenta '+ @FROM + @WHERE
EXEC (@SQL)
IF @@ERROR <> 0 SET @Ok = 1
SET @Contador = 1
SET @IDTemp2 = 0
IF EXISTS(SELECT * FROM SysObjects WHERE id = object_id('dbo.WebArtCobinacionTemp'))
UPDATE WebArtCobinacionTemp
SET @IDTemp2 = ID = @IDTemp2 + 1
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL AND  EXISTS(SELECT * FROM SysObjects WHERE id = object_id('dbo.WebArtCobinacionTemp'))
BEGIN
DECLARE crVariacion2 CURSOR FAST_FORWARD FOR
SELECT IDValor, ID
FROM WebArtCobinacionTemp
OPEN  crVariacion2
FETCH NEXT FROM  crVariacion2 INTO  @Valor, @Contador
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT @Tabla
SELECT * FROM dbo.fnWebSepararCombinaciones(@Contador,@IDVariacion,@Valor)
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM  crVariacion2 INTO @Valor, @Contador
END
CLOSE  crVariacion2
DEALLOCATE  crVariacion2
END
IF @Ok IS NULL
AND  EXISTS(SELECT * FROM SysObjects WHERE id = object_id('dbo.WebArtCobinacionTemp'))
BEGIN
DECLARE crInsertar CURSOR FAST_FORWARD FOR
SELECT IDValor, ID, Opciones, SubCuenta
FROM WebArtCobinacionTemp
OPEN  crInsertar
FETCH NEXT FROM  crInsertar INTO  @IDValor, @IDTemp, @Opciones, @SubCuenta
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM WebArtVariacionCombinacion WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion AND dbo.fnWebOrdenarCombinacion(IDOpciones)= dbo.fnWebOrdenarCombinacion(@IDValor) )
BEGIN
SET @IDTabla  = NULL
SELECT @Orden = ISNULL(MAX(Orden),0) FROM WebArtVariacionCombinacion WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion
SELECT @Orden = @Orden +1
INSERT WebArtVariacionCombinacion(IDArt, IDVariacion,  Activa, IDOpciones, Orden, Opciones, Cantidad, SubCuenta, Articulo)
SELECT                            @IDArt, @IDVariacion,1,      @IDValor,   @Orden, @Opciones, 1.0, CASE WHEN @TipoOpcion = 'Si' THEN dbo.fnWebOrdenarSubCuenta(@SubCuenta)ELSE NULL END ,CASE WHEN @TipoOpcion = 'Si' THEN @Articulo ELSE NULL END
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDTabla = SCOPE_IDENTITY()
IF @IDTabla IS NOT NULL    AND @Ok IS NULL
INSERT WebArtVariacionCombinacionD(ID,      IDArt,  IDVariacion,  IDOpcion, IDValor)
SELECT                             @IDTabla,@IDArt, @IDVariacion, IDOpcion, IDCombinacion
FROM @Tabla
WHERE ID = @IDTemp
GROUP BY IDOpcion, IDCombinacion
IF @@ERROR <> 0 SET @Ok = 1
END
IF EXISTS(SELECT * FROM WebArtVariacionCombinacion WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion AND dbo.fnWebOrdenarCombinacion(IDOpciones)= dbo.fnWebOrdenarCombinacion(@IDValor) ) AND @Ok IS NULL
UPDATE WebArtVariacionCombinacion SET IDOpciones = @IDValor WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion AND dbo.fnWebOrdenarCombinacion(IDOpciones)= dbo.fnWebOrdenarCombinacion(@IDValor)
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM  crInsertar INTO @IDValor, @IDTemp, @Opciones, @SubCuenta
END
CLOSE  crInsertar
DEALLOCATE  crInsertar
END
IF EXISTS(SELECT * FROM WebArtVariacionCombinacion WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion AND dbo.fnWebOrdenarCombinacion(IDOpciones) NOT IN(SELECT  dbo.fnWebOrdenarCombinacion(IDValor) FROM WebArtCobinacionTemp))AND @Ok IS NULL
DELETE WebArtVariacionCombinacion WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion AND dbo.fnWebOrdenarCombinacion(IDOpciones) NOT IN(SELECT  dbo.fnWebOrdenarCombinacion(IDValor) FROM WebArtCobinacionTemp)
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE WebArtVariacionCombinacionD WHERE ID NOT IN (SELECT ID FROM WebArtVariacionCombinacion WHERE IDArt = @IDArt AND IDVariacion = @IDVariacion)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Proceso Concluido con Exito'
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT 'No Se Pudieron generar Las Combinaciones'
END
RETURN
END

