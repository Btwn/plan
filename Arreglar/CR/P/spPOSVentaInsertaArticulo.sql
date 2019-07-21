SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVentaInsertaArticulo
@Modulo					varchar(5),
@Usuario				varchar(10),
@Codigo					varchar(36),
@CodigoAccion			varchar(50),
@ID						varchar(50),
@FechaEmision			datetime,
@Agente					varchar(10),
@Moneda					varchar(10),
@TipoCambio				float,
@Condicion				varchar(50),
@Almacen				varchar(10),
@Proyecto				varchar(50),
@FormaEnvio				varchar(50),
@Mov					varchar(20),
@Empresa				varchar(5),
@Sucursal				int,
@ListaPreciosEsp		varchar(20),
@Cliente				varchar(10),
@CtaDinero				varchar(10),
@Accion					varchar(50),
@Estacion				int,
@Mensaje				varchar(255) OUTPUT,
@ArtDescripcion			varchar(100) OUTPUT,
@Imagen					varchar(255) OUTPUT,
@Ok						int	     OUTPUT,
@OkRef					varchar(255) OUTPUT,
@Expresion				varchar(255) = NULL OUTPUT,
@Cantidad				float	= NULL,
@Juego					bit	= 0,
@EliminarSerieLote		bit	= 0,
@SerieLote				varchar(50) = NULL,
@TorretaMensaje1		varchar(20)= NULL OUTPUT,
@TorretaMensaje2		varchar(20)= NULL OUTPUT,
@TorretaPosicion1		varchar(20)= NULL OUTPUT,
@TorretaPosicion2		varchar(20)= NULL OUTPUT,
@NoAfectarSerieLote		bit = 0

AS
BEGIN
DECLARE
@Renglon						float,
@RenglonSub						int,
@RenglonID						float,
@RenglonTipo					varchar(1),
@Estatus						varchar(20),
@Cobrado						bit,
@Amortizado						bit,
@Articulo						varchar(20),
@Unidad							varchar(50),
@Factor							float,
@ArtTipo						varchar(20),
@SubCuenta						varchar(50),
@Impuesto1						float,
@Impuesto2						float,
@Impuesto3						float,
@Precio							float,
@PrecioCImp						float,
@DescuentoLinea					float,
@ImagenNombreAnexo				varchar(255),
@AgruparArticulos				bit,
@OFER							bit,
@CantidadArticuloTotal			float,
@Componente						varchar(20),
@ComponenteSubCuenta			varchar(50),
@ComponenteCodigo				varchar(50),
@ComponenteCantidad				float,
@BasculaPesar					bit,
@Servicio						varchar(20),
@Caja							varchar(10),
@Host							varchar(20),
@Cluster						varchar(20),
@EsDevolucion					bit,
@IDL							varchar(50),
@MovTipo						varchar(20),
@ZonaImpuestoUsuario			varchar(50),
@ZonaImpuestoCliente			varchar(50),
@ZonaImpuesto					varchar(50),
@Contacto						varchar(10),
@EnviarA						int,
@RedondeoMonetarios				int,
@JuegoComponentes				bit,
@JuegoComponentesCB				bit,
@Monedero						varchar(20),
@TipoOpcion						varchar(20),
@CodigoArt						varchar(30),
@MatrizOpciones					bit,
@CfgMultiUnidades				bit,
@CfgVentaFactorDinamico			bit,
@UnidadFactor					float,
@LDIForma						varchar(50),
@ArticuloOfertaFP				varchar(20),
@MovClave						varchar(20),
@MovSubClave					varchar(20),
@ContMoneda						varchar(10),
@ContMonedaTC					float,
@WebService						bit,
@NoExiste						bit,
@OfertaID						int,
@ArticuloRedondeo				varchar(20),
@CodigoRedondeo					varchar(50),
@POSDefMovServ					varchar(20),
@POSDefMovDev					varchar(20),
@IDDevolucionP					varchar(36),
@CantidadD						float,
@CantidadInvD					float,
@PrecioD						float,
@DescuentoLineaD				float,
@Impuesto1D						float,
@Impuesto2D						float,
@Impuesto3D						float,
@PrecioImpuestoIncD				float,
@CantidadObsequioD				float,
@PrecioSugeridoD				float,
@BanderaDP						bit,
@CantidadR						float,
@CantidadRBis					float,
@ArticuloD						varchar(20),
@RenglonD						int,
@POSAgenteDetalle				bit,
@POSAgenteDetMaestro			varchar(15),
@POSValidaAgente				bit = 0,
@POSValidaAgenteR				varchar(20),
@ArtRama						varchar(20),
@ArtGrupo						varchar(50),
@ArtCategoria					varchar(50),
@ArtFamilia						varchar(50),
@ArtLinea						varchar(50),
@ArtFabricante					varchar(50),
@ArtObservaciones				varchar (255),
@ArtPOSAgenteDetalle			varchar (255),
@ArtPOSAgenteDetalleInfo		varchar (255),
@PuntosD						money,
@SerieLoteDevP					varchar(50),
@OrdenDevP						int,
@CantidadAd						float,
@Cantidad2						float,
@SeVende						bit,
@EstatusArt						varchar(15),
@CfgPrecioNivelUnidad			bit,
@CfgNivelFactorMultiUnidad		varchar(20),
@SeriesLotesAutoOrden			varchar(20),
@ExpresionBis					varchar(255),
@ValidaComponente				bit,
@PrecioSugerido					float,
@CfgVentaPreciosImpuestoIncluido bit,
@CfgVentaMonederoA				bit
SELECT @POSDefMovServ = NULLIF(RTRIM(POSDefMovServ),''), @POSDefMovDev = NULLIF(POSDefMovDev,''),  @POSAgenteDetalle = ISNULL(POSAgenteDetalle,0), @POSAgenteDetMaestro = NULLIF(POSAgenteDetMaestro,'')
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @SeriesLotesAutoOrden = ISNULL(NULLIF(SeriesLotesAutoOrden,''), 'NO')
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF ISNULL(@Accion,'') ='DEVOLUCION PARCIAL'
BEGIN
IF @POSDefMovDev IS NOT NULL
UPDATE POSL SET MOV = @POSDefMovDev WHERE ID = @ID
UPDATE POSL SET IDDevolucionP =  @Codigo WHERE ID = @ID
SELECT @Mensaje = 'INGRESE LOS ARTICULOS A DEVOLVER'
SET @Mov = @POSDefMovDev
RETURN
END
SELECT @BanderaDP = 0, @IDDevolucionP = NULL, @CantidadD = NULL, @PrecioD = NULL, @DescuentoLineaD = NULL, @Impuesto1D = NULL, @Impuesto2D = NULL,
@Impuesto3D = NULL, @PrecioImpuestoIncD = NULL, @CantidadObsequioD = NULL, @PrecioSugeridoD = NULL, @CantidadInvD = NULL
SELECT @IDDevolucionP = NULLIF(IDDevolucionP,'')
FROM POSL
WHERE ID = @ID
IF @IDDevolucionP IS NOT NULL
SELECT @Accion = 'CANCELAR PARTIDA', @BanderaDP = 1
SET @NoExiste = 0
IF NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID) AND (SELECT FechaInicio FROM POSL WHERE ID = @ID) IS NULL
BEGIN
UPDATE POSL SET FechaInicio = GETDATE() WHERE ID = @ID
END
SELECT @POSDefMovServ = NULLIF(POSDefMovServ,'') FROM POSCfg WHERE Empresa = @Empresa
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
SELECT @ContMoneda = ec.ContMoneda,
@CfgVentaPreciosImpuestoIncluido = isnull(ec.VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @TipoCambio = CASE WHEN @Moneda <> @ContMoneda THEN  (ISNULL(@TipoCambio,1)/@ContMonedaTC) ELSE ISNULL(@TipoCambio,1) END
SELECT @MovClave = Clave, @MovSubClave = NULLIF(SubClave,'') FROM MovTipo WHERE Mov = @Mov AND Modulo = 'POS'
IF (SELECT POSDutyFree FROM POSCfg WHERE Empresa = @Empresa) = 1 AND @MovClave IN ('POS.N', 'POS.F', 'POS.P')
AND ISNULL(@Accion,'') NOT IN('DEVOLUCION TOTAL','REFERENCIAR VENTA', 'DEVOLUCION PARCIAL', 'PESAR')
BEGIN
SET @ExpresionBis = NULL
EXEC spPOSDatosVueloVerificar @ID, 1, @ExpresionBis OUTPUT
IF @ExpresionBis IS NOT NULL
BEGIN
SELECT @Expresion = @ExpresionBis
RETURN
END
END
IF @MovClave IN('POS.TCAC', 'POS.AC', 'POS.ACM', 'POS.AP', 'POS.CTCAC', 'POS.CACM', 'POS.CCCM', 'POS.CTCRC', 'POS.CTCM', 'POS.CTRM', 'POS.CAC', 'POS.CCC',
'POS.CXCC', 'POS.CC', 'POS.CCM', 'POS.CPCM', 'POS.CPC', 'POS.CXCD', 'POS.EC', 'POS.FTE', 'POS.IC', 'POS.TCM', 'POS.TCRC', 'POS.STE', 'POS.TCM', 'POS.TRM',
'POS.INVA', 'POS.INVD')
OR (@MovClave ='POS.FA' AND	@MovSubClave = 'POS.ANTREF')OR(@MovClave = 'POS.N' AND @MovSubClave =  'POS.DREF')
SELECT @Ok = 25460,@OkRef ='('+@Mov+')'
EXEC spPOSVentaInsertaRedondeo @ID, 'ELIMINAR', NULL
SELECT @ArticuloOfertaFP = pc.ArtOfertaFP, @WebService = ISNULL(WebService,0)
FROM POSCfg pc
WHERE Empresa = @Empresa
IF EXISTS(SELECT * FROM POSLVenta WHERE Articulo = @ArticuloOfertaFP AND ID = @ID)
DELETE POSLVenta WHERE Articulo = @ArticuloOfertaFP AND ID = @ID
SELECT @Monedero =  Monedero	  FROM POSL WHERE ID = @ID
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Amortizado = 0, @EsDevolucion = 0, @Cobrado = 0
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT @OFER = eg.OFER
FROM EmpresaGral eg
WHERE Empresa = @Empresa
SELECT
@CfgMultiUnidades = ISNULL(MultiUnidades,0),
@CfgVentaFactorDinamico = ISNULL(VentaFactorDinamico,0),
@CfgPrecioNivelUnidad = ISNULL(PrecioNivelUnidad,0),
@CfgNivelFactorMultiUnidad = ISNULL(NivelFactorMultiUnidad,0),
@CfgVentaMonederoA	= ISNULL(VentaMonederoA,0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @JuegoComponentes = ISNULL(JuegoComponentes,1), @JuegoComponentesCB = ISNULL(JuegoComponentesCB,0), @MatrizOpciones = ISNULL(MatrizOpciones,0)
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @MovTipo = mt.Clave
FROM MovTipo mt
WHERE mt.Modulo = 'POS'
AND mt.Mov = @Mov
SELECT @Estatus = p.Estatus,@Contacto = p.Cliente, @EnviarA = p.EnviarA, @ZonaImpuestoCliente = c.ZonaImpuesto
FROM POSL p JOIN Cte c ON p.Cliente = c.Cliente
WHERE p.ID = @ID
SELECT @Caja = u.DefCtaDinero,@ZonaImpuestoUsuario = u.DefZonaImpuesto
FROM Usuario u
WHERE u.Usuario = @Usuario
SELECT @ZonaImpuesto = ISNULL(NULLIF(@ZonaImpuestoCliente,''),@ZonaImpuestoUsuario)
IF EXISTS(SELECT * FROM POSLAmortizacionPagos WHERE ID = @ID)
SELECT @Amortizado = 1
IF ISNULL((SELECT SUM(Importe) FROM POSLCobro WHERE ID = @ID),0) <> 0
SELECT @Cobrado = 1
IF (@Amortizado = 1 AND @Cobrado = 1) OR (isnull(nullif(@Estatus,''),'SINAFECTAR') <>  'SINAFECTAR')
SELECT @Ok = 10015, @okRef = 'El movimiento no puede tener amortizaciones y tener cobros aplicados para poder añadir articulos'
IF @Cantidad IS NULL
SELECT
@Articulo = c.Cuenta,
@CodigoArt = c.Codigo,
@ArtDescripcion = a.Descripcion1,
@ArtTipo = a.Tipo,
@TipoOpcion = a.TipoOpcion,
@SubCuenta = NULLIF(c.SubCuenta, ''),
@Cantidad = CASE WHEN a.BasculaPesar = 1 THEN 0 ELSE ISNULL(NULLIF(c.Cantidad,''), 1) END,
@Unidad = ISNULL(NULLIF(c.Unidad,''),a.Unidad),
@Impuesto1 = a.Impuesto1,
@Impuesto2 = a.Impuesto2,
@Impuesto3 = a.Impuesto3,
@BasculaPesar = a.BasculaPesar,
@ArtRama = a.Rama,
@ArtGrupo = a.Grupo,
@ArtCategoria = a.Categoria,
@ArtFamilia = a.Familia,
@ArtLinea = a.Linea,
@ArtFabricante = a.Fabricante,
@ArtPOSAgenteDetalle = CASE WHEN @POSAgenteDetalle = 1 THEN @POSAgenteDetMaestro ELSE NULL END,
@SeVende    = ISNULL(a.SeVende,0),
@EstatusArt = Estatus
FROM CB c
INNER JOIN Art a ON c.Cuenta = a.Articulo
WHERE c.Codigo = @Codigo
IF @Cantidad IS NOT NULL
SELECT
@Articulo = c.Cuenta,
@CodigoArt = c.Codigo,
@ArtDescripcion = a.Descripcion1,
@ArtTipo = a.Tipo,
@SubCuenta = NULLIF(c.SubCuenta, ''),
@Unidad = ISNULL(NULLIF(c.Unidad,''),a.Unidad),
@Impuesto1 = a.Impuesto1,
@Impuesto2 = a.Impuesto2,
@Impuesto3 = a.Impuesto3,
@BasculaPesar = a.BasculaPesar,
@ArtRama = a.Rama,
@ArtGrupo = a.Grupo,
@ArtCategoria = a.Categoria,
@ArtFamilia = a.Familia,
@ArtLinea = a.Linea,
@ArtFabricante = a.Fabricante,
@ArtPOSAgenteDetalle = CASE WHEN @POSAgenteDetalle = 1 THEN @POSAgenteDetMaestro ELSE NULL END,
@SeVende    = ISNULL(a.SeVende,0),
@EstatusArt = Estatus
FROM CB c
INNER JOIN Art a ON c.Cuenta = a.Articulo
WHERE c.Codigo = @Codigo
IF @POSAgenteDetalle = 1 AND @ArtPOSAgenteDetalle IS NOT NULL
BEGIN
IF @ArtPOSAgenteDetalle = 'Categoría'
BEGIN
IF EXISTS (SELECT * FROM ArtCat WHERE Categoria = @ArtCategoria AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Categoria', @ArtPOSAgenteDetalleInfo = @ArtCategoria
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtCategoria = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Grupo'
BEGIN
IF EXISTS (SELECT * FROM ArtGrupo WHERE Grupo = @ArtGrupo AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Grupo', @ArtPOSAgenteDetalleInfo = @ArtGrupo
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtGrupo = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Familia'
BEGIN
IF EXISTS (SELECT * FROM ArtFam WHERE Familia = @ArtFamilia AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Familia', @ArtPOSAgenteDetalleInfo = @ArtFamilia
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtFamilia = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Línea'
BEGIN
IF EXISTS (SELECT * FROM ArtLinea WHERE Linea = @ArtLinea AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Linea', @ArtPOSAgenteDetalleInfo =@ArtLinea
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtLinea = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Fabricante'
BEGIN
IF EXISTS (SELECT * FROM Fabricante WHERE Fabricante = @ArtFabricante AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Fabricante', @ArtPOSAgenteDetalleInfo = @ArtFabricante
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtFabricante = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
END
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, 0, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
IF @SeVende = 0
BEGIN
SELECT @Ok = 10530, @OkRef = 'La Configuración del Artículo no Permite su Venta'
RETURN
END
IF @EstatusArt = 'Baja'
BEGIN
SELECT @Ok = 10530, @OkRef = 'El Estatus del Artículo no Permite su Venta'
RETURN
END
IF @CfgMultiUnidades = 1 OR @CfgVentaFactorDinamico = 1
BEGIN
EXEC spUnidadFactor @Empresa, @Articulo, NULL, @Unidad, @UnidadFactor OUTPUT
END
IF @ArtTipo IN ('Juego')
BEGIN
IF EXISTS(SELECT cb.Codigo FROM ArtJuegoD ajd LEFT OUTER JOIN CB cb ON cb.Cuenta = ajd.Opcion AND ISNULL(cb.SubCuenta, '') = ISNULL(ajd.SubCuenta,'')
WHERE cb.Codigo IS NULL AND ajd.Articulo = @Articulo )
SELECT @Ok = '72040', @OkRef = 'Falta indicar codigo a alguno de los componentes'
END
IF @ArtTipo IN ('Juego') AND @Ok IS NULL
BEGIN
IF EXISTS (SELECT * FROM Art WHERE Articulo IN (SELECT DISTINCT Opcion FROM ArtJuegoD WHERE Articulo = @Articulo) AND Tipo IN ('Lote', 'Serie'))
IF @Mov <> @POSDefMovDev
SELECT @Mensaje = @Mensaje + 'EL JUEGO CONTIENE ARTICULOS SERIE O LOTE, DEBE DE ENTRAR A EDITAR DETALLE PARA ASIGNAR LA SERIE O LOTE'
END
IF @ArtTipo IN  ('Serie', 'Lote') AND (@MovTipo IN('POS.N','POS.F','POS.NPC')AND @MovSubClave <> 'POS.PEDCONT' )
BEGIN
IF @TipoOpcion = 'Si' AND @SubCuenta IS NULL AND @MatrizOpciones = 1 AND EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo)
BEGIN
SELECT @Mensaje = NULL
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
END
IF @ArtTipo IN  ('Serie', 'Lote') AND (@MovTipo = 'POS.P'  AND @MovSubClave IN('POS.FACCRED','POS.DEVCRED'))
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE'
INSERT POSLAccion (Host, Caja, Accion, Referencia) VALUES (@Host, @Caja, 'SERIE/LOTE', @Accion)
IF @TipoOpcion = 'Si' AND @SubCuenta IS NULL AND @MatrizOpciones = 1 AND EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo)
BEGIN
SELECT @Mensaje = NULL
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
END
IF @TipoOpcion = 'Si' AND @SubCuenta IS NULL AND @MatrizOpciones = 0 AND EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo AND Requerido = 1)
SELECT @Ok = 20046
IF @TipoOpcion = 'Si' AND @SubCuenta IS NULL AND @MatrizOpciones = 1 AND EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo AND Requerido = 1)
AND @ArtTipo IN  ('Serie', 'Lote')
BEGIN
SELECT @Ok = 20046, @OkRef = 'LA MATRIZ DE OPCIONES NO PUEDE SER MOSTRADA EN ARTSCULOS TIPO/SERIE DEBIDO A QUE NO SE PUEDE ASIGNAR MaS DE UNA SERIE/LOTE A LA VEZ.'
RETURN
END
IF ISNULL(@BasculaPesar,0) = 1 AND ISNULL(@Accion,'') NOT IN ('CANCELAR PARTIDA', 'PESAR') AND NULLIF(@Cantidad,0) IS NULL
BEGIN
SELECT @CodigoAccion = 'PESAR'
EXEC spPOSAccionDisparar @Empresa, @Sucursal, @Modulo, @Usuario, @Caja, @Estacion, @ID OUTPUT, @Codigo OUTPUT, @CodigoAccion OUTPUT, @Accion OUTPUT,
@FormaPago = NULL, @Importe= NULL, @CantidadNotasEnProceso = NULL, @Imagen = @Imagen OUTPUT, @Mensaje = @Mensaje  OUTPUT, @Ok = @Ok OUTPUT,
@OkRef = @OkRef OUTPUT, @Expresion = @Expresion OUTPUT
END
IF ISNULL(@Accion,'') NOT IN('DEVOLUCION TOTAL','REFERENCIAR VENTA', 'DEVOLUCION PARCIAL')
BEGIN
IF @Articulo IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC xpPOSVentaInsertaArticuloVerificar @Codigo, @Articulo, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion, @Almacen, @Proyecto, @FormaEnvio,
@Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @Accion, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT,
@OkRef OUTPUT
SELECT @ImagenNombreAnexo = pc.ImagenNombreAnexo,
@AgruparArticulos = ISNULL(pc.AgruparArticulos,0)
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
IF @Juego = 0
SELECT @Imagen = MAX(ac.Direccion)
FROM AnexoCta ac
WHERE ac.Nombre = @ImagenNombreAnexo
AND Rama = 'INV'
AND ac.Cuenta = @Articulo
AND ac.Tipo = 'Imagen'
SET @Servicio = NULL
SELECT @Servicio = plart.Servicio
FROM POSLDIArtRecargaTel plart
WHERE plart.Articulo = @Articulo
IF @Servicio IS NOT NULL
BEGIN
IF (SELECT SUM(Cantidad) FROM POSLVenta WHERE ID = @ID) <> 0
SELECT @Ok = 10530, @OkRef = UPPER('Un Servicio no se puede Combinar con otros productos y/o Servicios')
END
IF EXISTS(SELECT 1 FROM POSLVenta WHERE ID = @ID AND NULLIF(LDIServicio, '') IS NOT NULL )
SELECT @Ok = 10530, @OkRef = 'Un Servicio no se puede Combinar con otros productos y/o Servicios'
IF @POSDefMovServ IS NOT NULL AND @Ok IS NULL AND @Servicio IS NOT NULL
UPDATE POSL SET Mov = @POSDefMovServ WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(plv.Renglon),0) + 2048,
@RenglonSub = 0,
@RenglonID = ISNULL(MAX(plv.RenglonID),0) + 1,
@RenglonTipo = dbo.fnRenglonTipo(@ArtTipo)
FROM POSLVenta plv
INNER JOIN POSL p ON p.ID = plv.ID
WHERE plv.ID = @ID
IF @Juego = 1
SELECT @RenglonTipo = 'C'
SELECT @CantidadArticuloTotal = SUM(Cantidad)
FROM POSLVenta plv
INNER JOIN POSL p ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo
AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND plv.Unidad = @Unidad
IF @Accion = 'CANCELAR PARTIDA' AND @Ok IS NULL
BEGIN
IF @BanderaDP = 1 AND NOT EXISTS (SELECT * FROM POSLVenta WHERE ID = @IDDevolucionP AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND RenglonTipo <> 'C' )
BEGIN
SELECT @Ok = 50000
RETURN
END
IF @BanderaDP = 1 AND ISNULL(@BasculaPesar,0) = 1 AND NULLIF(@Cantidad,0) IS NULL
BEGIN
SELECT @Cantidad = Cantidad FROM POSLVenta WHERE ID = @IDDevolucionP AND Articulo = @Articulo
END
IF @BanderaDP = 1 AND EXISTS (SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo = @Articulo) AND ISNULL(@BasculaPesar,0) = 1
BEGIN
SELECT @Ok = 50002
RETURN
END
IF @BanderaDP = 1 AND EXISTS (SELECT * FROM POSLVenta WHERE ID = @IDDevolucionP AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND RenglonTipo <> 'C' )
BEGIN
IF @BasculaPesar = 0
SELECT @CantidadAd = 1
ELSE
SELECT @CantidadAd = 0.001
SELECT @CantidadR = SUM(ISNULL(CantidadSaldo,0))
FROM POSLVenta
WHERE ID = @IDDevolucionP
AND Articulo = @Articulo
AND RenglonTipo <> 'C'
SELECT @CantidadRBis = SUM(ISNULL(Cantidad,0)*-1) + @Cantidad
FROM POSLVenta
WHERE ID = @ID
AND Articulo = @Articulo
AND RenglonTipo <> 'C'
IF @CantidadR < ISNULL(@CantidadRBis,@CantidadAd)
BEGIN
SELECT @Ok = 50002
RETURN
END
END
IF @BanderaDP = 1 AND EXISTS (SELECT * FROM POSLVenta WHERE ID = @IDDevolucionP AND Articulo = @Articulo AND OfertaID IS NOT NULL)
SELECT @MENSAJE = 'Articulo con Ofertas en su Venta Original'
IF (SELECT TOP 1 EliminaRenglon FROM POSCancelarPartida WHERE ID = @ID) = 1 AND @BanderaDP = 0
SELECT @Cantidad = @CantidadArticuloTotal
SET @OfertaID = 0
SELECT @OfertaID = OfertaID
FROM POSLVenta
WHERE ID = @ID AND Articulo = @Articulo
DELETE FROM POSCancelarPartida WHERE ID = @ID
IF ISNULL((SELECT SUM(Cantidad)
FROM POSLVenta plv
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo AND plv.Unidad = @Unidad
AND plv.RenglonTipo <> 'C' AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')),0) <= 0
AND ISNULL((SELECT SUM(Cantidad)
FROM POSLVenta plv
WHERE plv.ID = @ID),0) > 0
SELECT @Ok = 10530, @OkRef = @Articulo
IF(SELECT plv.RenglonTipo
FROM POSLVenta plv
WHERE plv.ID = @ID AND plv.Articulo = @Articulo AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND plv.Unidad = @Unidad AND Renglon = @Renglon ) ='C'
SELECT @Ok = 10531, @OkRef = @Articulo
SELECT @Precio = ISNULL(Precio,0)
FROM POSLVenta
WHERE ID = @ID AND Articulo = @Articulo AND Unidad = @Unidad
AND RenglonTipo <> 'C'
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
IF @ArtTipo IN ('Serie', 'Lote') AND @Ok IS NULL
BEGIN
IF ISNULL((SELECT SUM(Cantidad)
FROM POSLVenta plv
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo
AND plv.Unidad = @Unidad
AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')),0) < 0
SELECT @EsDevolucion = 1
END
IF @Ok IS NULL
BEGIN
IF @ArtTipo IN ('Serie', 'Lote')
BEGIN
IF @EliminarSerieLote = 1
BEGIN
IF @EsDevolucion = 0
SELECT @Cantidad = @Cantidad * (-1)
IF @EsDevolucion = 1
SELECT @Cantidad = @Cantidad
END
IF @EliminarSerieLote = 0
BEGIN
SELECT @Cantidad = @Cantidad * (-1)
END
END
ELSE
BEGIN
IF ISNULL(@BasculaPesar,0) = 1
SELECT @Cantidad = @CantidadArticuloTotal * (-1)
ELSE
IF @ArtTipo IN ('Juego')
BEGIN
SELECT @Cantidad = @Cantidad * (-1)
DELETE POSArtJuegoComponente WHERE Estacion = @Estacion
EXEC spInsertarJuegoOmision @Empresa, @Sucursal, 0, @Articulo, @Cantidad, @Almacen, @FechaEmision, @Moneda, @TipoCambio,
@Renglon, @RenglonID, NULL, 'POS', @ID, @Estacion
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID
AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Unidad = @Unidad  AND RenglonTipo = 'J')
SELECT @Renglon = MAX(Renglon) ,
@RenglonID = MAX(RenglonID)
FROM POSLVenta
WHERE ID = @ID AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Unidad = @Unidad
AND RenglonTipo = 'J'
UPDATE POSArtJuegoComponente SET EsDevolucion = 1 WHERE RID = @ID AND RenglonID = @RenglonID AND  Estacion = @Estacion
IF @JuegoComponentes = 0 AND EXISTS(SELECT * FROM ArtJuego WHERE Articulo = @Articulo AND Opcional = 1)
BEGIN
IF @JuegoComponentesCB = 1
BEGIN
UPDATE POSArtJuegoComponente SET ArtSubCuenta = null, Opcion = NULL, SubCuenta = NULL
WHERE Opcional =1
AND RID = @ID
AND RenglonID = @RenglonID
AND Estacion = @Estacion
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSArtJuegoComponente2'+CHAR(39)+')'
END
ELSE
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSArtJuegoComponente'+CHAR(39)+')'
END
ELSE
BEGIN
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo = @Articulo)
BEGIN
SELECT @RenglonID = RenglonID
FROM POSLVenta
WHERE ID = @ID
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Unidad = @Unidad
END
IF @BanderaDP = 0
EXEC spPOSInsertarArtComponentes @Estacion, @ID, @Empresa, @Sucursal, @RenglonID, @Articulo, @Cantidad
END
END
ELSE
SELECT @Cantidad = @Cantidad * (-1)
END
END
IF @Ok IS NULL AND @BanderaDP = 0
INSERT POSCancelacionArticulos(	ID,	 Empresa,  Sucursal,  Cajero,   Caja,  Articulo,  Precio, Fecha,		Cantidad)
SELECT							@ID, @Empresa, @Sucursal, @Usuario, @Caja, @Articulo, @Precio, GETDATE(),	@Cantidad
IF ISNULL(@BasculaPesar,0) = 1 AND NULLIF(@Cantidad,0) IS NULL
SELECT @Ok = 10100, @OkRef = 'Para hacer una devolución de un articulo que se pese deberá hacerse a través de Editar Detalle'
END
IF @CodigoAccion <> 'PESAR' 
BEGIN
SELECT @CantidadArticuloTotal = ISNULL(@CantidadArticuloTotal,0) + ISNULL(@Cantidad,0)
SELECT @Cantidad2 = @Cantidad / @Cantidad
END
IF ISNULL(@Juego,0) = 0
EXEC spPOSArtPrecio @Articulo = @Articulo, @Cantidad = @CantidadArticuloTotal, @UnidadVenta = @Unidad, @Precio = @Precio OUTPUT, @Descuento = @DescuentoLinea OUTPUT,
@SubCuenta = @SubCuenta, @FechaEmision = @FechaEmision, @Agente = @Agente, @Moneda = @Moneda, @TipoCambio = @TipoCambio, @Condicion = @Condicion,
@Almacen = @Almacen, @Proyecto = @Proyecto, @FormaEnvio = @FormaEnvio, @Mov = @Mov, @Empresa = @Empresa, @Sucursal = @Sucursal,
@ListaPreciosEsp = @ListaPreciosEsp, @Cliente = @Cliente, @VentaID = @ID
ELSE
SELECT @Precio = 0
SELECT @Precio = dbo.fnPOSPrecio(@Empresa, @Precio, @Impuesto1, @Impuesto2, @Impuesto3)
SELECT @PrecioCImp = dbo.fnPOSPrecioConImpuestos(@Precio, @Impuesto1, @Impuesto2, @Impuesto3, @Empresa)
SELECT @Precio = ROUND(@Precio,@RedondeoMonetarios), @PrecioCImp = ROUND(@PrecioCImp,@RedondeoMonetarios)
SELECT @PrecioSugerido = CASE WHEN @CfgVentaPreciosImpuestoIncluido = 0 THEN @Precio ELSE @PrecioCImp END
IF ISNULL(@Precio,0.00) = 0.00 AND ISNULL(@ArtTipo, '') != 'SERVICIO'
BEGIN
SELECT @Ok = 20305, @OkRef = 'ESTE ARTICULO NO SE PUEDE VENDER'
RETURN
END
SELECT @DescuentoLinea = ROUND(@DescuentoLinea,@RedondeoMonetarios)
SELECT @TipoCambio = ROUND(@TipoCambio,@RedondeoMonetarios)
IF @TipoOpcion = 'Si' AND @SubCuenta IS NULL AND @MatrizOpciones = 1 AND EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo) AND @Accion IS NULL
BEGIN
SELECT @CodigoAccion = 'MATRIZ OPCIONES'
END
IF @TipoOpcion = 'Si' AND @SubCuenta IS NULL AND @MatrizOpciones = 1 AND EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo) AND @Accion = 'CANCELAR PARTIDA'
SELECT @CodigoAccion = 'MATRIZ OPCIONES NEGATIVA'
IF @Ok IS NULL AND ISNULL(@CodigoAccion,'') NOT IN ('PESAR','MATRIZ OPCIONES','MATRIZ OPCIONES NEGATIVA'  )
BEGIN
IF EXISTS(SELECT * FROM POSLVenta plv
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND plv.RenglonTipo = @RenglonTipo
AND RenglonTipo <> 'C'
AND  Unidad = @Unidad
AND ISNULL(Aplicado,0) = 0)
AND @AgruparArticulos = 1
BEGIN
UPDATE POSLVenta SET Cantidad = Cantidad + @Cantidad,
CantidadInventario = CantidadInventario + (@Cantidad*ISNULL(@UnidadFactor,1)),
Precio = CASE WHEN @CfgPrecioNivelUnidad = 0 THEN @Precio* (ABS(@Cantidad2)*ISNULL(@UnidadFactor,1))
ELSE @Precio* @Cantidad2 END,
PrecioSugerido = CASE WHEN @CfgPrecioNivelUnidad = 0 THEN @PrecioSugerido * (ABS(@Cantidad2)*ISNULL(@UnidadFactor,1))
ELSE @PrecioSugerido * @Cantidad2 END,
Impuesto1 =@Impuesto1,
Impuesto2 =@Impuesto2,
Impuesto3 =@Impuesto3,
PrecioImpuestoInc = CASE WHEN @CfgPrecioNivelUnidad = 0 THEN @PrecioCImp * (ABS(@Cantidad2)*ISNULL(@UnidadFactor,1))
ELSE @PrecioCImp * @Cantidad2 END,
DescuentoLinea = ISNULL(NULLIF(@DescuentoLinea,0.0),DescuentoLinea),
ArtObservaciones = @ArtPOSAgenteDetalleInfo
WHERE ID = @ID
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND RenglonTipo = @RenglonTipo
AND Unidad = @Unidad AND RenglonTipo <> 'C'
AND ISNULL(Aplicado,0)=0
END
ELSE
BEGIN
IF (@TipoOpcion = 'Si' AND ISNULL(@SubCuenta,'') <> '') OR @TipoOpcion <> 'Si'
INSERT POSLVenta (ID,	Renglon,	RenglonID,	RenglonTipo,	Cantidad,	Articulo,	SubCuenta,	DescuentoLinea,		Impuesto1,	Impuesto2,	Impuesto3,
Unidad,	Factor,			CantidadInventario,					LDIServicio,	Codigo,		Almacen,	ArtObservaciones,
Precio,
PrecioSugerido,
PrecioImpuestoInc)
VALUES			 (@ID,	@Renglon,	@RenglonID, @RenglonTipo,	@Cantidad,	@Articulo,	@SubCuenta, @DescuentoLinea,	@Impuesto1, @Impuesto2,	@Impuesto3,
@Unidad,	@UnidadFactor,	@Cantidad*ISNULL(@UnidadFactor,1),	@Servicio,		@CodigoArt, @Almacen,	@ArtPOSAgenteDetalleInfo,
CASE WHEN @CfgPrecioNivelUnidad = 0 THEN @Precio*(ABS(@Cantidad2)*ISNULL(@UnidadFactor,1))
ELSE @Precio * @Cantidad2 END,
CASE WHEN @CfgPrecioNivelUnidad = 0 THEN @PrecioSugerido *(ABS(@Cantidad2)*ISNULL(@UnidadFactor,1))
ELSE @PrecioSugerido * @Cantidad2 END,
CASE WHEN @CfgPrecioNivelUnidad = 0 THEN @PrecioCImp*(ABS(@Cantidad2)*ISNULL(@UnidadFactor,1))
ELSE @PrecioCImp * @Cantidad2 END)
END
END
IF @Ok IS NULL AND ISNULL(@CodigoAccion,'') IN ('MATRIZ OPCIONES')
BEGIN
SELECT @Expresion = 'POSMatrizOpciones( '+CHAR(39)+@ID+CHAR(39)+','+ CHAR(39)+@Articulo+CHAR(39)+','+CHAR(39)+@Codigo+CHAR(39)+','+' '+')'
END
IF @Ok IS NULL AND ISNULL(@CodigoAccion,'') IN ('MATRIZ OPCIONES NEGATIVA' )
BEGIN
SELECT @Expresion = 'POSMatrizOpcionesCancelar( '+CHAR(39)+@ID+CHAR(39)+','+ CHAR(39)+@Articulo+CHAR(39)+','+ CHAR(39)+@Codigo+CHAR(39)+','+' '+')'
END
IF @Ok IS NULL AND @Accion NOT IN('DEVOLUCION TOTAL','REFERENCIAR VENTA', 'DEVOLUCION PARCIAL')AND @RenglonTipo NOT IN('C')
BEGIN
SELECT @TorretaMensaje1   = NombreCorto
FROM Art
WHERE Articulo = @Articulo
SELECT @TorretaMensaje2 ='PRECIO ' + dbo.fnFormatoMoneda(@Precio,@Empresa), @TorretaPosicion1 = 'Izquierda', @TorretaPosicion2 = 'Derecha'
END
IF @AgruparArticulos = 0
BEGIN
UPDATE POSLVenta SET DescuentoLinea = ISNULL(@DescuentoLinea,DescuentoLinea)
WHERE ID = @ID
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Unidad = @Unidad
END
IF @OFER = 1 AND @Ok IS NULL
BEGIN
EXEC spPOSOfertaAplicar	@ID
EXEC spPOSOfertaPuntosInsertarTemp @ID, NULL, 1, @Estacion
END
ELSE
IF @OFER = 0 AND @Monedero IS NOT NULL AND @CfgVentaMonederoA = 0
EXEC spPOSVentaMonedero @Empresa, @ID, 'AFECTAR', @FechaEmision, @Usuario, @Sucursal, @Moneda, @TipoCambio, @Monedero, @Ok OUTPUT, @OkRef OUTPUT
IF @ArtTipo IN ('Juego') AND @Accion NOT IN ('CANCELAR PARTIDA')
BEGIN
DELETE POSArtJuegoComponente WHERE Estacion = @Estacion
EXEC spInsertarJuegoOmision @Empresa, @Sucursal, 0, @Articulo, @Cantidad, @Almacen, @FechaEmision, @Moneda, @TipoCambio, @Renglon, @RenglonID, NULL, 'POS', @ID, @Estacion
IF EXISTS (SELECT * FROM POSLVenta WHERE  ID = @ID AND Articulo = @Articulo  AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Unidad = @Unidad  AND RenglonTipo = 'J')
SELECT @Renglon = MAX(Renglon) , @RenglonID = MAX(RenglonID)
FROM POSLVenta
WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Unidad = @Unidad AND RenglonTipo = 'J'
IF @JuegoComponentes = 0 AND EXISTS(SELECT * FROM ArtJuego WHERE Articulo = @Articulo AND Opcional = 1)
BEGIN
IF @JuegoComponentesCB = 1
BEGIN
UPDATE POSArtJuegoComponente SET ArtSubCuenta = null, Opcion = NULL, SubCuenta = NULL
WHERE Opcional =1
AND RID = @ID
AND RenglonID = @RenglonID
AND Estacion = @Estacion
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSArtJuegoComponente2'+CHAR(39)+')'
END
ELSE
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSArtJuegoComponente2'+CHAR(39)+')'
END
ELSE
BEGIN
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Unidad = @Unidad)
BEGIN
SELECT @RenglonID = RenglonID FROM POSLVenta WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Unidad = @Unidad
END
EXEC spPOSInsertarArtComponentes @Estacion, @ID, @Empresa, @Sucursal, @RenglonID, @Articulo, @Cantidad
END
END
END
END
IF @BanderaDP = 1
BEGIN
IF @RenglonTipo = 'J'
EXEC spPOSInsertarArtComponentes @Estacion, @ID, @Empresa, @Sucursal, @RenglonID, @Articulo, @Cantidad
DECLARE crTST CURSOR LOCAL FOR
SELECT Articulo, Renglon
FROM POSLventa
WHERE ID = @ID
AND RenglonTipo <> 'C'
OPEN crTST
FETCH NEXT FROM crTST INTO @ArticuloD, @RenglonD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @CantidadD = SUM(Cantidad),
@PrecioD = Precio,
@DescuentoLineaD = SUM(ISNULL(DescuentoLinea,0)),
@Impuesto1D = Impuesto1,
@Impuesto2D = Impuesto2,
@Impuesto3D = Impuesto3,
@PrecioImpuestoIncD = PrecioImpuestoInc,
@CantidadObsequioD = SUM(ISNULL(CantidadObsequio,0)),
@PrecioSugeridoD = PrecioSugerido,
@PuntosD = SUM(ISNULL(Puntos,0)),
@CantidadInvD = SUM(ISNULL(CantidadInventario,0))
FROM POSLVenta
WHERE ID = @IDDevolucionP
AND Articulo = @ArticuloD
AND RenglonTipo <> 'C'
GROUP BY Precio, Impuesto1, Impuesto2, Impuesto3, PrecioImpuestoInc, PrecioSugerido
IF @CantidadInvD = 0
SELECT @CantidadInvD = NULL
SELECT @CantidadD = @CantidadD / @CantidadD
SELECT @DescuentoLineaD = @DescuentoLineaD / @CantidadD, @PuntosD = @PuntosD  / @CantidadD,  @CantidadInvD = @CantidadInvD / @CantidadD
SELECT TOP 1 @Agente = Agente
FROM POSLVenta
WHERE ID = @IDDevolucionP
AND Articulo = @ArticuloD
UPDATE POSLVenta
SET Precio = (((ISNULL(@PrecioD,0)*(1-(ISNULL(@DescuentoLineaD,0)/100))) * (ISNULL(@CantidadD,0) - ISNULL(@CantidadObsequioD,0)))/ISNULL(@CantidadD,0)),
DescuentoLinea = 0,
PrecioImpuestoInc = (((ISNULL(@PrecioImpuestoIncD,0)*(1-(ISNULL(@DescuentoLineaD,0)/100)))*(ISNULL(@CantidadD,0)-ISNULL(@CantidadObsequioD,0)))/ISNULL(@CantidadD,0)),
PrecioSugerido = (((ISNULL(@PrecioSugeridoD,0)*(1-(ISNULL(@DescuentoLineaD,0)/100)))*(ISNULL(@CantidadD,0) - ISNULL(@CantidadObsequioD,0)))/ISNULL(@CantidadD,0)),
OfertaID = @OfertaID,
@CantidadInvD = @CantidadInvD,
CantidadObsequio = NULL,
Puntos = @PuntosD,
OfertaIDG1 = NULL,
OfertaIDG2 = NULL,
OfertaIDG3 = NULL,
OfertaIDP1 = NULL,
OfertaIDP2 = NULL,
OfertaIDP3 = NULL,
DescuentoG1 = NULL,
DescuentoG2 = NULL,
DescuentoG3 = NULL,
DescuentoP1 = NULL,
DescuentoP2 = NULL,
DescuentoP3 = NULL,
Agente = @Agente
WHERE ID = @ID
AND Articulo = @ArticuloD
AND Renglon = @RenglonD
AND RenglonTipo <> 'C'
END
FETCH NEXT FROM crTST INTO @ArticuloD, @RenglonD
END
CLOSE crTST
DEALLOCATE crTST
END
IF ISNULL(@Accion,'') ='DEVOLUCION TOTAL'
BEGIN
IF @POSDefMovDev IS NOT NULL
UPDATE POSL SET Mov = @POSDefMovDev WHERE ID = @ID
UPDATE POSL SET IDDevolucion =  @Codigo WHERE ID = @ID
UPDATE POSL
SET Descuento = (SELECT Descuento FROM POSL WHERE ID = @Codigo), DescuentoGlobal = (SELECT DescuentoGlobal FROM POSL WHERE ID = @Codigo)
WHERE ID = @ID
IF (SELECT Ofertados FROM POSDevolucionTotal WHERE ID = @ID) = 1
INSERT POSLVenta (ID,	Renglon, RenglonID, RenglonTipo, Cantidad,											Articulo, SubCuenta,
Precio,
DescuentoLinea,	Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, LDIServicio,
PrecioImpuestoInc,
Codigo, Almacen, CantidadObsequio, OfertaID,
PrecioSugerido,
Puntos, Agente)
SELECT            @ID,	Renglon, RenglonID, RenglonTipo, ((ISNULL(Cantidad,0) + ISNULL(CantidadM,0))*-1),	Articulo, SubCuenta,
(((ISNULL(Precio,0)*(1-(ISNULL(DescuentoLinea,0)/100)))*(ISNULL(Cantidad,0)-ISNULL(CantidadObsequio,0)))/ISNULL(Cantidad,0)),
0,				Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, LDIServicio,
(((ISNULL(PrecioImpuestoInc,0)*(1-(ISNULL(DescuentoLinea,0)/100)))*(ISNULL(Cantidad,0)-ISNULL(CantidadObsequio,0)))/ISNULL(Cantidad,0)),
Codigo, Almacen, 0,				   NULL,
(((ISNULL(PrecioSugerido,0)*(1-(ISNULL(DescuentoLinea,0)/100)))*(ISNULL(Cantidad,0)-ISNULL(CantidadObsequio,0)))/ISNULL(Cantidad,0)),
Puntos, Agente
FROM POSLVenta
WHERE ID = @Codigo
AND Articulo NOT IN(@ArticuloRedondeo, NULL)
ELSE
INSERT POSLVenta (ID, Renglon, RenglonID, RenglonTipo, Cantidad,										Articulo, SubCuenta, Precio,
DescuentoLinea,	Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, LDIServicio, PrecioImpuestoInc,
Codigo, Almacen, CantidadObsequio, OfertaID,
PrecioSugerido,
Puntos, Agente)
SELECT			 @ID, Renglon, RenglonID, RenglonTipo, ((ISNULL(Cantidad,0) + ISNULL(CantidadM,0))*-1),	Articulo, SubCuenta, (((ISNULL(Precio,0)*(1-(ISNULL(DescuentoLinea,0)/100)))*(ISNULL(Cantidad,0)-ISNULL(CantidadObsequio,0)))/ISNULL(Cantidad,0)),
0,				Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, LDIServicio, (((ISNULL(PrecioImpuestoInc,0)*(1-(ISNULL(DescuentoLinea,0)/100)))*(ISNULL(Cantidad,0)-ISNULL(CantidadObsequio,0)))/ISNULL(Cantidad,0)),
Codigo, Almacen, 0,					NULL,
(((ISNULL(PrecioSugerido,0)*(1-(ISNULL(DescuentoLinea,0)/100)))*(ISNULL(Cantidad,0)-ISNULL(CantidadObsequio,0)))/ISNULL(Cantidad,0)),
Puntos, Agente
FROM POSLVenta
WHERE ID = @Codigo
AND Articulo NOT IN(@ArticuloRedondeo, NULL) AND (DescuentoLinea IS NULL OR OfertaID IS NULL)
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @Codigo)
INSERT POSLSerieLote(ID,  RenglonID, Articulo, SubCuenta,			 SerieLote)
SELECT				 @ID, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM POSLSerieLote
WHERE ID = @Codigo
ORDER BY Orden
DELETE FROM POSDevolucionTotal WHERE ID = @ID
END
IF ISNULL((SELECT SUM(Cantidad) FROM POSLVenta WHERE ID = @ID),0) < 0 AND @MovTipo NOT IN ('POS.N','POS.NPC','POS.INVD','POS.INVA')
SELECT @ok = 10180, @okRef = 'Solamente las Notas se pueden utilizar como Devolución'
IF @Ok IS NULL
EXEC xpPOSVentaInsertaArticulo @Codigo, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion, @Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal,
@ListaPreciosEsp, @Cliente, @CtaDinero, @Accion, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spPOSLArtSeleccionado @ID, @Articulo, @SubCuenta, @Unidad, @CodigoArt
IF @Ok IS NULL AND ISNULL(@Accion,'') NOT IN('DEVOLUCION TOTAL', 'DEVOLUCION PARCIAL') AND @BanderaDP = 0
DELETE POSLValidarDevolucion WHERE ID = @ID
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Cantidad = 0)
DELETE POSLVenta WHERE ID = @ID AND Cantidad = 0
IF @Ok IS NULL   AND @Articulo IN(SELECT Articulo FROM POSLDIArtRecargaTel WHERE Servicio NOT IN ('IUSACELL','MOVISTAR','NEXTEL','TELCEL','UNEFON'))
BEGIN
SELECT @LDIForma = Forma FROM POSLDIArtRecargaTel WHERE Articulo = @Articulo
IF @LDIForma IS NOT NULL
SELECT @Expresion = 'FormaModal('+CHAR(39)+@LDIForma+CHAR(39)+')'
END
IF @POSAgenteDetalle = 1 AND @Accion NOT IN ('CANCELAR PARTIDA')
BEGIN
SET @POSValidaAgente =  0
IF NULLIF(@ArtPOSAgenteDetalle,'') IS NOT NULL
SET @POSValidaAgente =  1
IF @POSAgenteDetalle = 1 AND @CodigoAccion = NULL
BEGIN
IF (SELECT COUNT(ID) FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo) > 1
UPDATE POSLVenta SET Agente = (SELECT TOP 1 Agente FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo)
WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND RenglonTipo = @RenglonTipo AND  Unidad = @Unidad AND RenglonTipo <> 'C' AND ISNULL(Aplicado,0)=0
IF @POSValidaAgente = 1 AND (SELECT TOP 1 Agente FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo) IS NULL
SELECT @Expresion = 'Asigna(Info.Renglon,'+CONVERT(varchar, @Renglon)+') FormaModal('+CHAR(39)+'POSAgenteDetalle'+CHAR(39)+')'
END
IF EXISTS (SELECT * FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo AND Articulo <> @Articulo) AND @CodigoAccion <> 'MATRIZ OPCIONES'
BEGIN
UPDATE POSLVenta SET Agente = (SELECT TOP 1 Agente FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo AND Articulo <> @Articulo) WHERE ID = @ID AND Renglon = @Renglon
SELECT @POSValidaAgente = 0
IF @CodigoAccion = 'MATRIZ OPCIONES'
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = 'INSERTA AGENTE'
END
IF EXISTS (SELECT * FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo) AND @CodigoAccion = 'MATRIZ OPCIONES'
BEGIN
UPDATE POSLVenta SET Agente = (SELECT TOP 1 Agente FROM POSLVenta WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo) WHERE ID = @ID AND Renglon = @Renglon
SELECT @POSValidaAgente = 0
IF @CodigoAccion = 'MATRIZ OPCIONES'
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = 'INSERTA AGENTE'
END
END
IF @ArtTipo IN  ('Serie', 'Lote') AND (@MovTipo IN('POS.N','POS.F','POS.NPC')AND @MovSubClave <> 'POS.PEDCONT' )
BEGIN
IF @Accion NOT IN ('CANCELAR PARTIDA', 'DEVOLUCION TOTAL') AND @ArtTipo = 'Lote'
BEGIN
IF @SeriesLotesAutoOrden <> 'NO'
BEGIN
IF EXISTS (SELECT 1 FROM SerieLote WHERE Articulo = @Articulo AND ISNULL(Existencia,0) > 0 AND Sucursal = @Sucursal AND Almacen = @Almacen)
INSERT POSLSerieLote(ID,  RenglonID,	Articulo,	SubCuenta,				SerieLote)
SELECT TOP 1		@ID, p.RenglonID,	s.Articulo, NULLIF(s.SubCuenta,''), s.SerieLote
FROM SerieLote s JOIN POSLVenta p ON s.Articulo = p.Articulo AND ISNULL(s.SubCuenta,'') = ISNULL(p.SubCuenta,'')
JOIN CB ON cb.Cuenta = s.Articulo
WHERE cb.Codigo = @Codigo AND ISNULL(s.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND s.Existencia > 0
AND p.ID = @ID
AND s.Sucursal = @Sucursal
AND s.Almacen = @Almacen
ORDER BY s.SerieLote
END
IF @SeriesLotesAutoOrden = 'NO' OR NOT EXISTS (SELECT 1 FROM SerieLote WHERE Articulo = @Articulo AND ISNULL(Existencia,0) > 0 AND Sucursal = @Sucursal AND Almacen = @Almacen)
BEGIN
IF @POSAgenteDetalle = 1
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE, EL AGENTE LO DEBERa ASIGNAR EDITANDO EL DETALLE' 
SET @Expresion = NULL
END
ELSE
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE'
INSERT POSLAccion (Host, Caja, Accion, Referencia) VALUES (@Host, @Caja, 'SERIE/LOTE', @Accion)
END
END
IF @Accion = 'CANCELAR PARTIDA'
BEGIN
IF @BanderaDP = 0
BEGIN
IF ABS(@Cantidad) = 1
BEGIN
IF @NoAfectarSerieLote = 0
DELETE FROM POSLSerieLote
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND ID = @ID
AND Orden = (SELECT MAX(Orden) FROM POSLSerieLote WHERE Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') )
END
IF ABS(@Cantidad) > 1
BEGIN
DELETE FROM POSLSerieLote WHERE Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND ID = @ID
END
END
ELSE
BEGIN
IF @ArtTipo NOT IN ('Serie')
BEGIN
SELECT TOP 1 @SerieLoteDevP = SerieLote, @OrdenDevP = Orden
FROM POSLSerieLote
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND ID = @IDDevolucionP
AND Orden NOT IN (SELECT OrdenDPRef FROM POSLSerieLote WITH (NOLOCK) WHERE ID = @ID)
INSERT POSLSerieLote(ID,  RenglonID, Articulo, SubCuenta,			 SerieLote,			OrdenDPRef)
SELECT TOP 1		 @ID, RenglonID, Articulo, ISNULL(SubCuenta,''), @SerieLoteDevP,	@OrdenDevP
FROM POSLVenta
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND ID = @ID
END
END
END
END
IF @ArtTipo IN  ('Serie') AND (@MovTipo IN('POS.N','POS.F','POS.NPC')AND @MovSubClave <> 'POS.PEDCONT' ) 
AND @Accion NOT IN ('CANCELAR PARTIDA', 'DEVOLUCION TOTAL')
BEGIN
IF @POSAgenteDetalle = 1
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE, ± BIEN LO DEBERa DE ASIGNAR EDITANDO EL DETALLE'
SET @Expresion = NULL
END
ELSE
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE'
INSERT POSLAccion (Host, Caja, Accion, Referencia) VALUES (@Host, @Caja, 'SERIE/LOTE', @Accion)
END
IF @ArtTipo IN  ('Serie') AND (@MovTipo IN('POS.N','POS.F','POS.NPC')AND @MovSubClave <> 'POS.PEDCONT' ) 
AND @Accion IN ('CANCELAR PARTIDA') AND @BanderaDP = 1
BEGIN
IF @POSAgenteDetalle = 1
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE, ± BIEN LO DEBERa DE ASIGNAR EDITANDO EL DETALLE'
SET @Expresion = NULL
END
ELSE
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE'
INSERT POSLAccion (Host, Caja, Accion, Referencia) VALUES (@Host, @Caja, 'SERIE/LOTE', @Accion)
END
IF @ArtTipo IN  ('Serie', 'Lote') AND (@MovTipo IN('POS.N','POS.F','POS.NPC')AND @MovSubClave <> 'POS.PEDCONT' ) AND EXISTS (SELECT 1 FROM ValeSerie WHERE Articulo = @Articulo)
BEGIN
IF @POSAgenteDetalle = 1
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE, ± BIEN LO DEBERa DE ASIGNAR EDITANDO EL DETALLE'
SET @Expresion = NULL
END
ELSE
SELECT @Mensaje = 'POR FAVOR INGRESE EL NO. DE SERIE/LOTE'
INSERT POSLAccion (Host, Caja, Accion, Referencia) VALUES (@Host, @Caja, 'SERIE/LOTE', @Accion)
END
IF (SELECT ISNULL(DescuentoGlobal,0) FROM POSL WITH (NOLOCK) WHERE ID = @ID) > 0
UPDATE POSLVenta SET AplicaDescGlobal = 1 WHERE ID = @ID
END

