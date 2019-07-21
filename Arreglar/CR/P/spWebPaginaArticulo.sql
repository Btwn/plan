SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebPaginaArticulo
@SesionID     Uniqueidentifier = null,
@Origen       varchar(255) = null,
@Pagina       Varchar(20) = NULL,
@SubCuenta    Varchar(20) = NULL,
@Valor        smallint = 0,
@Precio       money = 0,
@Usuario       VARCHAR(20)=NULL,
@DescripCorta  Varchar(500)=NULL,
@DescripLarga  Varchar(1000)=null

AS BEGIN
IF EXISTS(SELECT * FROM WebPaginaArticulo WHERE pagina=@Pagina AND (Usuario=@usuario OR SesionID=@SesionID) AND articulo=@Origen ) 
IF LEN(@SubCuenta)>0
UPDATE WebPaginaArticulo SET SubCuenta=@SubCuenta WHERE pagina=@Pagina AND SesionID=@SesionID AND articulo=@Origen
ELSE
IF upper(@Usuario) <> 'ANONIMOS'
UPDATE WebPaginaArticulo SET Cantidad=@Valor,Precio=@Precio WHERE pagina=@Pagina AND Usuario=@usuario AND articulo=@Origen
ELSE
BEGIN
UPDATE WebPaginaArticulo SET Cantidad=@Valor,Precio=@Precio WHERE pagina=@Pagina AND SesionID=@SesionID AND articulo=@Origen
IF @@ROWCOUNT=0
INSERT INTO WebPaginaArticulo(Pagina,SesionID,articulo,SubCuenta,Usuario,Cantidad,Precio,DescripCorta,DescripLarga) VALUES (@Pagina,@SesionID,@Origen,@SubCuenta,@usuario,@Valor,@Precio,@DescripCorta,@DescripLarga)
END
ELSE
INSERT INTO WebPaginaArticulo(Pagina,SesionID,articulo,SubCuenta,Usuario,Cantidad,Precio,DescripCorta,DescripLarga) VALUES (@Pagina,@SesionID,@Origen,@SubCuenta,@usuario,@Valor,@Precio,@DescripCorta,@DescripLarga)
END

