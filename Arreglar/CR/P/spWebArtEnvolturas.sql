SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtEnvolturas
@ID         int,
@Sucursal	int,
@EnvolturaIDS	varchar(max) OUTPUT

AS BEGIN
DECLARE
@IDEnvoltura     int,
@Columns         varchar(255),
@Tipo			varchar(20),
@SucursaleCommerce	varchar(10)
SELECT @Tipo = OpcionesEnvoltura FROM WebArt WHERE ID = @ID
SELECT @SucursaleCommerce = eCommerceSucursal FROM Sucursal WHERE Sucursal = @Sucursal
IF(@Tipo = 'Ninguna')
SET @Columns = ''
ELSE IF (@Tipo = 'Seleccion')
BEGIN
SELECT @Columns = ISNULL(@Columns,'') + ',' + Convert(varchar,wae.IDEnvoltura)
FROM  WebArtEnvoltura wae
JOIN WebEnvolturaRegalo wer ON (wae.IDEnvoltura=wer.ID)
WHERE wae.IDArt = @ID AND wer.SucursaleCommerce = @SucursaleCommerce
ORDER by wae.IDEnvoltura
END
ELSE IF (@Tipo = 'Omision')
BEGIN
SELECT @Columns = ISNULL(@Columns,'') + ',' + Convert(varchar,eCommerceEnvolturaOmision)
FROM Sucursal
WHERE Sucursal = @Sucursal
END
ELSE IF(@Tipo = 'Todas')
BEGIN
SELECT @Columns = ISNULL(@Columns,'') + ',' + Convert(varchar,ID)
FROM WebEnvolturaRegalo
WHERE SucursaleCommerce = @SucursaleCommerce
END
SELECT @EnvolturaIDS =  stuff(@Columns,1,1,'' )
END

