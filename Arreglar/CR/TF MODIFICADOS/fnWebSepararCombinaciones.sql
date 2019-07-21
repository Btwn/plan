SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebSepararCombinaciones
(
@ID                                     int,
@VariacionID                            int,
@Expresion				varchar(255)
)
RETURNS @Tabla TABLE (ID int,IDOpcion  int,NombreOpcion varchar(100), IDCombinacion int, Valor varchar(100))

AS BEGIN
DECLARE
@Resultado			varchar(MAX),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado				int,
@EstadoAnterior		int,
@Variable			varchar(255),
@Valor				varchar(MAX),
@Tipo				varchar(50),
@Posicion                   int,
@IDOpcion                   int
SET @Resultado = ''
IF NULLIF(@Expresion,'') IS NULL RETURN
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 0
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado = 0 AND @Caracter =','   SET @Estado =1
IF @Estado = 0 AND @Contador = @Longitud SET @Estado =3
IF @Estado IN( 0,3) AND ISNUMERIC(@Caracter)=1
SELECT @Variable = @Variable + @Caracter
IF  @Estado IN( 1,3)
BEGIN
IF ISNUMERIC(@Variable)=1
INSERT @Tabla(ID,IDOpcion  , IDCombinacion,NombreOpcion,Valor )
SELECT       @ID, v.OpcionID,  v. ID, o.Nombre, v.Valor
FROM WebArtOpcionValor v WITH(NOLOCK) JOIN WebArtOpcion o WITH(NOLOCK) ON v.VariacionID = o.VariacionID AND o.ID = v.OpcionID
WHERE v.ID =  @Variable AND v.VariacionID = @VariacionID
SET @Estado = 0
SELECT @Variable = ''
END
SET @Contador = @Contador + 1
END
RETURN
END

