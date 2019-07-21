SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesareCommerce
@Sistema       varchar(100),
@ID		  int,
@iSolicitud	  int,
@Solicitud     varchar(max),
@Version	  float,
@Referencia    varchar(100),
@SubReferencia varchar(100),
@Resultado     varchar(max)    OUTPUT,
@Ok		  int		OUTPUT,
@OkRef	  varchar(255)	OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.eCommerce.Pedido' EXEC speCommercePedido @ID, @iSolicitud,@Solicitud, @Version,  @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.Cte' EXEC spISeCommerceCte @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.Art' EXEC spISeCommerceArt @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.ArtCosto' EXEC spISeCommerceArtCosto @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.Precio' EXEC spISeCommercePrecio @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.PrecioD' EXEC spISeCommercePrecioD @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArt' EXEC spISeCommerceWebArt @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebCatArt' EXEC spISeCommerceWebCatArt @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtImagen' EXEC spISeCommerceWebArtImagen @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtAtributos' EXEC spISeCommerceWebArtAtributos @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtVariacion' EXEC spISeCommerceWebArtVariacion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtVideo' EXEC spISeCommerceWebArtVideo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtVariacionCombinacion' EXEC spISeCommerceWebArtVariacionCombinacion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtOpcion' EXEC spISeCommerceWebArtOpcion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtOpcionValor' EXEC spISeCommerceWebArtOpcionValor @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtCamposConfigurables' EXEC spISeCommerceWebArtCamposConfigurables @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtMarca' EXEC spISeCommerceWebArtMarca @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtExistencia' EXEC spISeCommerceWebArtExistencia @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebArtExistenciaGlobal' EXEC spISeCommerceWebArtExistenciaGlobal @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.ExistenciaSucursal' EXEC spISeCommerceWebArtExistenciaSucursal @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebMovSituacion' EXEC spISeCommerceWebMovSituacion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebSituacion' EXEC spISeCommerceWebSituacion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebSucursalImagen' EXEC spISeCommerceWebSucursalImagen @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebUsuario' EXEC spISeCommerceWebUsuario @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebUsuarioEnviarA' EXEC spISeCommerceWebUsuarioDireccion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebPais' EXEC spISeCommerceWebPais @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebPaisEstado' EXEC spISeCommerceWebPaisEstado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'eCommerce.Intelisis.WebUsuario' EXEC speCommerceWebUsuarioCliente  @ID, @iSolicitud,@Solicitud, @Version,  @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'eCommerce.Intelisis.WebUsuarioEnviarA' EXEC speCommerceWebUsuarioClienteEnviarA  @ID, @iSolicitud,@Solicitud, @Version,  @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.WebCteEnviarA' EXEC spISeCommerceWebCteEnviarA  @ID, @iSolicitud, @Version,  @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.eCommerceMetodoEnvioCfg' EXEC spISeCommerceMetodoEnvioCfg  @ID, @iSolicitud, @Version,  @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.eCommerce.Sucursal' EXEC spISeCommerceSucursal @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.eCommerce.WebEnvolturaRegalo' EXEC spISeCommerceWebEnvolturaRegalo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.eCommerce.WebEstatusExistencia' EXEC spISeCommerceWebEstatusExistencia @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.eCommerce.DiaFestivo' EXEC spISeCommerceDiaFestivo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.eCommerce.WebCertificadosRegalo' EXEC spISeCommerceWebCertificadosRegalo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.eCommerce.ListaPreciosSub' EXEC spISeCommerceListaPreciosSub @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

