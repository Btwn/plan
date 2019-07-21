SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAccionEjecutar
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Modulo					varchar(5),
@Usuario				varchar(10),
@Caja					varchar(10),
@ID						varchar(50)			OUTPUT,
@Codigo					varchar(50)			OUTPUT,
@Accion					varchar(50)			OUTPUT,
@CodigoAccion			varchar(50)			OUTPUT,
@Referencia				varchar(50)			OUTPUT,
@Importe				float				OUTPUT,
@MovClave				varchar(20)			OUTPUT,
@CtaDinero				varchar(20)			OUTPUT,
@Mensaje				varchar(255)		OUTPUT,
@Cajero					varchar(20)			OUTPUT,
@SerieLote				varchar(50)			OUTPUT,
@Articulo				varchar(20)			OUTPUT,
@SubCuenta				varchar(50)			OUTPUT,
@Cantidad				float				OUTPUT,
@CantidadOriginal		float				OUTPUT,
@RenglonUbicado			float				OUTPUT,
@ArtConsulta			varchar(20)			OUTPUT,
@AgruparArticulos		bit,
@Mov					varchar(20)			OUTPUT,
@FechaEmision			dateTime			OUTPUT,
@Concepto				varchar(50)			OUTPUT,
@Agente					varchar(10)			OUTPUT,
@UEN					int					OUTPUT,
@Moneda					varchar(10)			OUTPUT,
@TipoCambio				float				OUTPUT,
@Proyecto				varchar(50)			OUTPUT,
@Cliente				varchar(10)			OUTPUT,
@Condicion				varchar(50)			OUTPUT,
@Almacen				varchar(10)			OUTPUT,
@FormaEnvio				varchar(50)			OUTPUT,
@Vencimiento			dateTime			OUTPUT,
@ListaPreciosEsp		varchar(20)			OUTPUT,
@Descuento				varchar(30)			OUTPUT,
@ArtDescripcion			varchar(100)		OUTPUT,
@DescuentoGlobal		float				OUTPUT,
@Imagen					varchar(255)		OUTPUT,
@ZonaImpuesto			varchar(30)			OUTPUT,
@ImporteSaldoaFavor		float				OUTPUT,
@Ok						int					OUTPUT,
@OkRef					varchar(255)		OUTPUT,
@Expresion				varchar(255) = NULL OUTPUT,
@TorretaMensaje1		varchar(20) = NULL	OUTPUT,
@TorretaMensaje2		varchar(20) = NULL	OUTPUT,
@TorretaPosicion1		varchar(20) = NULL	OUTPUT,
@TorretaPosicion2		varchar(20) = NULL	OUTPUT,
@MovSubClave			varchar(20)  = NULL	OUTPUT

AS BEGIN
DECLARE
@CantidadContador			float,
@Peso						float,
@BasculaPesar				float,
@FormaPago					varchar(50),
@Unidad						varchar(50),
@MovID						varchar(20),
@Estatus					varchar(20),
@Host						varchar(20),
@Cluster					varchar(20),
@EsDevolucion				bit,
@SerieLoteCancelarPartida	bit,
@IDL						varchar(50),
@ArtTipo					varchar(20),
@MonedaPrincipal			varchar(20),
@RedondeoMonetarios			int,
@RenglonID					int,
@Beneficiario				varchar(100),
@UsuarioPerfil				varchar(10),
@MonedaFormaPago			varchar(10),
@CheckSumEO					bigint,
@CheckSumE					bigint,
@CheckSumDO					bigint,
@CheckSumD					bigint,
@Orden						int,
@AlmacenD					varchar(10),
@CondicionPedidoContado		varchar(50),
@WebService					bit,
@NoExiste					bit,
@CajeroActual				varchar(10),
@SugerirFechaCierre			bit,
@FechaCierre				datetime,
@POSMonedaAct				bit,
@IDDevolucionP				varchar(36),
@Renglon					float,
@CantidadCodigo				float,
@NoAfectarSerieLote			bit,
@FormaEnvioV				varchar(50),
@MovNC						varchar(20)
SELECT  @IDDevolucionP = NULLIF(IDDevolucionP,'')
FROM POSL
WHERE ID = @ID
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @FechaCierre = Fecha
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT @NoExiste = 1
SELECT @WebService = WebService
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @UsuarioPerfil = NULLIF(POSPerfil,'')
FROM Usuario
WHERE Usuario = @Usuario
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF @Accion = 'MODIFICAR COMPONENTE' AND @Ok IS NULL
BEGIN
SELECT @RenglonID = RenglonID, @Articulo = Articulo
FROM POSTempArtJuego
WHERE RID = @ID AND Estacion = @Estacion AND ID = @Codigo
SELECT  @Cantidad = Cantidad FROM POSLVenta WHERE ID = @ID AND RenglonID = @RenglonID AND RenglonTipo = 'J'
IF NOT EXISTS(SELECT * FROM ArtJuego WHERE Articulo = @Articulo AND Opcional = 1)
SELECT @Ok = 20626
IF NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND RenglonID = @RenglonID AND RenglonTipo = 'J')
SELECT @Ok = 20336
IF @Ok IS NULL
BEGIN
DELETE POSArtJuegoComponente WHERE Estacion = @Estacion
INSERT POSArtJuegoComponente(
Estacion, RID, RenglonID, Articulo, ArtSubCuenta, Juego, Componente, Opcion, SubCuenta,
Opcional, Cantidad, Recalcular,CantidadComponente)
SELECT
@Estacion, @ID, @RenglonID, j.Articulo,
CASE WHEN NULLIF(j.SubCuenta,'') IS NOT NULL
THEN j.Opcion+' ('+j.SubCuenta+')'
ELSE j.Opcion
END, j.Juego, d.Descripcion, j.Opcion, j.SubCuenta,
ISNULL(d.Opcional,0), 1, 1, @Cantidad
FROM ArtJuegoOmision j
JOIN ArtJuego d ON j.Articulo = d.Articulo AND j.Juego = d.Juego
WHERE j.Articulo = @Articulo
GROUP BY d.Descripcion, d.Opcional, j.Articulo,  j.Opcion, j.SubCuenta ,j.Juego
DELETE POSLVenta WHERE ID = @ID AND RenglonID = @RenglonID AND  RenglonTipo = 'C'
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSArtJuegoComponente'+CHAR(39)+')'
END
END
IF @Accion = 'PESAR'
BEGIN
IF (SELECT dbo.fnEsNumerico(@Codigo)) = 0 OR LEN(@Codigo)>=10
SELECT @Ok = 20010, @OkRef = @Codigo +' FAVOR DE INTRODUCIR EL PESO'
ELSE
SELECT @Peso = @Codigo
IF (SELECT dbo.fnEsNumerico(@Codigo)) = 1 AND (CONVERT(float,(ISNULL(NULLIF(@Codigo,''),'0.0'))) = 0 OR LEN(@Codigo)>=10)
SELECT @Ok = 20010, @OkRef = @Codigo +' FAVOR DE INTRODUCIR EL PESO'
EXEC spPOSLVerArtSeleccionado @ID, @Articulo OUTPUT, @SubCuenta OUTPUT, @CantidadOriginal OUTPUT, @Unidad OUTPUT, NULL
SELECT
@Mov = p.Mov,
@MovID = p.MovID,
@Estatus = p.Estatus,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal
FROM POSL p
WHERE ID = @ID
SELECT @Codigo = MAX(Codigo)
FROM CB
WHERE TipoCuenta = 'Articulos'
AND Cuenta = @Articulo
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
AND Unidad = ISNULL(@Unidad,Unidad)
SELECT @BasculaPesar = a.BasculaPesar
FROM Art a
WHERE a.Articulo = @Articulo
IF ISNULL(@BasculaPesar,0) = 0
SELECT @Ok = 73040, @OkRef = 'El Articulo no esta configurado para pesarse'
IF @Ok IS NULL
BEGIN
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio,
@Condicion, @Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, @Accion,
@Estacion, @Mensaje OUTPUT, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,@Expresion OUTPUT, @Cantidad = @Peso,
@Juego = 0,@TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT,
@TorretaPosicion1= @TorretaPosicion1   OUTPUT,  @TorretaPosicion2 = @TorretaPosicion2  OUTPUT
END
SELECT @Codigo = NULL
END
IF @Accion = 'MODIFICAR AGENTE'
BEGIN
IF NOT EXISTS (SELECT * FROM Agente WHERE Agente = @Codigo)
SELECT @Ok = 26090, @OkRef = @Codigo
IF @Ok IS NULL
UPDATE POSL SET Agente = @Codigo WHERE ID = @ID
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL
END
IF @Accion = 'REFERENCIA FORMA PAGO'
BEGIN
IF @Ok IS NULL
BEGIN
SELECT @Referencia = @Codigo
SELECT @Codigo = FormaPago
FROM POSLAccion
WHERE Host = @Host
AND Caja = @Caja
END
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'REVERSAR COBRO'
BEGIN
IF @Ok IS NULL
BEGIN
SELECT @FormaPago = FormaPago
FROM CB
WHERE Codigo = @Codigo
EXEC spPOSLDIReverso @ID, @FormaPago, @Empresa , @Usuario, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
END
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL
END
IF @Accion = 'INTRODUCIR CONCEPTODIN' AND @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM POSConceptoDINTemp WHERE Estacion = @Estacion and Orden = CONVERT(INT,@Codigo))
SELECT @ok = 20702, @OkRef = @Codigo
SELECT @Concepto = Concepto
FROM POSConceptoDINTemp
WHERE Estacion = @Estacion AND Orden = CONVERT(INT,@Codigo)
UPDATE POSL SET Concepto = @Concepto WHERE ID = @ID
SELECT @Codigo = NULL
END
IF @Accion = 'MODIFICAR CONDICION' AND @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM Condicion WHERE Condicion = @Codigo)
SELECT @ok = 20700, @OkRef = @Codigo
UPDATE POSL SET Condicion = @Codigo WHERE ID = @ID
SELECT @Codigo = NULL
END
IF @Accion = 'MONTO FORMA PAGO'
BEGIN
IF dbo.fnEsNumerico(@Codigo) <> 1
SELECT @Ok = 10060, @OkRef = @Codigo
IF @Ok IS NULL
BEGIN
SELECT @Importe = @Codigo
SELECT @Importe = ROUND(@Importe,@RedondeoMonetarios)
SELECT
@Codigo = FormaPago,
@Referencia = Referencia
FROM POSLAccion
WHERE Host = @Host
AND Caja = @Caja
END
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'INTRODUCIR CUENTA DINERO'
BEGIN
SELECT TOP 1 @MonedaPrincipal = CASE WHEN @POSMonedaAct = 0 THEN ISNULL(NULLIF(fp.Moneda,''), @Moneda) ELSE ISNULL(NULLIF(fp.POSMoneda,''), @Moneda) END
FROM CB cb INNER JOIN FormaPago fp ON cb.FormaPago = fp.FormaPago
WHERE cb.Codigo = @Codigo AND cb.TipoCuenta = 'Forma Pago'
IF @MovClave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.AP','POS.ACM','POS.CCM','POS.CPCM','POS.CAC','POS.CACM','POS.CCC','POS.CCCM')
BEGIN
IF ISNULL(@Codigo,'') NOT IN (SELECT cd.CtaDinero FROM CtaDinero cd WHERE cd.Tipo = 'Banco') AND @Ok IS NULL
SELECT @Ok = 10540, @OkRef = @Codigo
IF (SELECT ISNULL(Moneda, @MonedaPrincipal) FROM CtaDinero cd WHERE cd.Tipo = 'Banco' AND CtaDinero = @Codigo)
NOT IN (SELECT Moneda FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal) AND @Ok IS NULL
SELECT @Ok = 30050, @okRef = @Codigo
END
IF @MovClave IN ('POS.TCM','POS.TRM' )
BEGIN
IF ISNULL(@Codigo,'') NOT IN (SELECT cd.CtaDinero FROM CtaDinero cd WHERE cd.Tipo = 'Caja'
AND cd.Sucursal = @Sucursal AND cd.EsConcentradora = 1 ) AND @Ok IS NULL
SELECT @Ok = 10540, @OkRef = @Codigo
END
IF @Ok IS NULL
BEGIN
IF @MovClave IN('POS.AC','POS.AP')
BEGIN
UPDATE POSL SET CtaDineroDestino = CtaDinero
WHERE ID = @ID
UPDATE POSL SET CtaDinero = @Codigo
WHERE ID = @ID
END
IF @MovClave IN('POS.ACM')
BEGIN
IF (SELECT NULLIF(CtaDineroDestino,'') FROM POSL WHERE ID = @ID)IS NULL
UPDATE POSL SET CtaDineroDestino = CtaDinero
WHERE ID = @ID
UPDATE POSL SET CtaDinero = @Codigo
WHERE ID = @ID
END
IF @MovClave IN ('POS.CC', 'POS.CPC','POS.CCM','POS.CPCM')
UPDATE POSL SET CtaDineroDestino = @Codigo
WHERE ID = @ID
IF @MovClave IN ('POS.TRM','POS.TCM')
UPDATE POSL SET CtaDinero = @Codigo, CtaDineroDestino = @Caja, Caja = @Codigo
WHERE ID = @ID
IF @MovClave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.AP','POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.IC','POS.EC','POS.TRM')
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA FORMA DE PAGO'
END
SELECT @Codigo = NULL
END
IF @Accion = 'MODIFICAR CAJA'
BEGIN
SELECT @CtaDinero = @Codigo
IF @MovClave NOT IN ('POS.AC','POS.ACM')
SELECT @Ok = 20180, @okRef = 'Solo se puede cambiar la Caja en la apertura de Caja'
IF NOT EXISTS(SELECT * FROM CtaDinero WHERE CtaDinero = @CtaDinero AND Tipo = 'Caja') AND @Ok IS NULL
SELECT @Ok = 10510, @OkRef = @CtaDinero
IF @Sucursal <> (SELECT Sucursal FROM CtaDinero WHERE CtaDinero = @CtaDinero) AND @Ok IS NULL
SELECT @Ok = 30270, @OkRef = 'La Caja pertenece a otra Sucursal'
SELECT @CajeroActual  = Cajero FROM POSL WHERE ID  = @ID
IF EXISTS(SELECT * FROM POSEstatusCaja  WHERE Host = @Host AND Caja = @Caja AND Abierto = 1)
SELECT @Ok = 30435, @OkRef = @CajeroActual
IF @OK IS NULL
BEGIN
UPDATE POSL SET CtaDineroDestino = @CtaDinero, Caja = @CtaDinero
WHERE ID = @ID
UPDATE POSLCobro SET  CtaDineroDestino = @CtaDinero
WHERE ID = @ID
END
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL
END
IF @Accion = 'ASIGNAR CAJA'
BEGIN
SELECT @CtaDinero = @Codigo
IF NOT EXISTS(SELECT * FROM CtaDinero WHERE CtaDinero = @CtaDinero AND Tipo = 'Caja') AND @Ok IS NULL
SELECT @Ok = 10510, @OkRef = @CtaDinero
IF @Sucursal <> (SELECT Sucursal FROM CtaDinero WHERE CtaDinero = @CtaDinero) AND @Ok IS NULL
SELECT @Ok = 30270, @OkRef = 'La Caja pertenece a otra Sucursal'
IF @OK IS NULL
BEGIN
UPDATE POSL SET CtaDineroDestino = @CtaDinero
WHERE ID = @ID
UPDATE POSLCobro SET  CtaDinero = @CtaDinero, Caja = @CtaDinero, CtaDineroDestino = NULL
WHERE ID = @ID
UPDATE Usuario SET DefCtaDinero =  @CtaDinero
WHERE Usuario = @Usuario
SELECT @Caja =  @CtaDinero
END
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL, @CodigoAccion = NULL
END
IF @Accion = 'BENEFICIARIO' AND @MovClave IN('POS.EC')
BEGIN
SELECT @Beneficiario = @Codigo
UPDATE POSL SET BeneficiarioNombre = @Beneficiario,CtaDineroDestino = CtaDinero
WHERE ID = @ID
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL, @CodigoAccion = NULL, @Mensaje = 'POR FAVOR INTRODUZCA LA FORMA DE PAGO'
END
IF @Accion = 'INTRODUCIR CONCEPTOCXC' AND @MovClave IN('POS.FA')
BEGIN
SELECT @Concepto = Concepto
FROM POSConceptoCXCTemp
WHERE Estacion = @Estacion AND Orden = @Codigo
IF NOT EXISTS (SELECT * FROM  POSConceptoCXCTemp WHERE Estacion = @Estacion AND Orden = @Codigo)
SELECT @Ok = 20336 , @OkRef = @OkRef+' POR FAVOR INTRODUZCA EL NUMERO DEL CONCEPTO'
IF @OK IS NULL
BEGIN
UPDATE POSL SET Concepto = @Concepto
WHERE ID = @ID
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL, @CodigoAccion = NULL
INSERT POSLAccion (Host, Caja, Accion, FormaPago) VALUES (@Host, @Caja, 'IMPORTE ANTICIPO', @Codigo)
SELECT @Mensaje = 'POR FAVOR INTRODUZCA EL IMPORTE'
END
ELSE
BEGIN
SELECT @CodigoAccion = 'INTRODUCIR CONCEPTOCXC'
SELECT @Accion = NULL
IF  NULLIF(@Codigo,'') IS NULL  AND @Ok = 20336
SELECT @Ok = NULL, @OKRef = NULL
END
END
IF @Accion = 'ALMACEN DESTINO' AND @MovClave IN('POS.INVD', 'POS.INVA')
BEGIN
SELECT @AlmacenD = Almacen
FROM POSAlmTemp
WHERE Estacion = @Estacion AND Orden = @Codigo
IF NOT EXISTS (SELECT * FROM  POSAlmTemp WHERE Estacion = @Estacion AND Orden = @Codigo)
SELECT @Ok = 20336 , @OkRef = @OkRef + CASE WHEN @MovClave = 'POS.INVD'
THEN ' POR FAVOR INTRODUZCA EL ALMACEN DESTINO'
ELSE ' POR FAVOR INTRODUZCA EL ALMACEN ORIGEN'  END
IF @OK IS NULL
BEGIN
IF @MovClave = 'POS.INVD'
UPDATE POSL SET AlmacenDestino = @AlmacenD
WHERE ID = @ID
IF @MovClave = 'POS.INVA'
BEGIN
UPDATE POSL SET AlmacenDestino = Almacen
WHERE ID = @ID
UPDATE POSL SET Almacen = @AlmacenD
WHERE ID = @ID
END
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL, @CodigoAccion = NULL
END
ELSE
BEGIN
SELECT @CodigoAccion = 'ALMACEN DESTINO'
SELECT @Accion = NULL
END
END
IF @Accion =   'IMPORTE ANTICIPO' AND @MovClave IN('POS.FA')
BEGIN
IF (SELECT dbo.fnEsNumerico(@Codigo)) = 0
SELECT @Ok = 30447, @OkRef = @OkRef+' POR FAVOR INTRODUZCA EL IMPORTE'
IF @Ok IS NULL
BEGIN
EXEC spPOSGenerarAnticipo @Estacion,@ID,@Codigo, @Ok OUTPUT, @OkRef OUTPUT
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL, @Accion = NULL, @Mensaje = NULL
END
ELSE
BEGIN
SELECT @CodigoAccion = 'IMPORTE ANTICIPO'
SELECT @Accion = NULL
END
END
IF @Accion =   'IMPORTE ANTICIPO' AND @MovClave IN('POS.CXCC')
BEGIN
IF @Ok IS NULL
BEGIN
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL, @Accion = NULL, @Mensaje = NULL
END
ELSE
BEGIN
SELECT @CodigoAccion = 'IMPORTE ANTICIPO'
SELECT @Accion = NULL
END
IF @Codigo IS NULL AND @Ok NOT IN (30170)
SELECT @Ok = NULL, @Mensaje = @OkRef
IF @Ok = 30170
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'MODIFICAR REFERENCIA'
BEGIN
UPDATE POSL SET Referencia = @Codigo
WHERE ID = @ID
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL
END
IF @Accion = 'MODIFICAR CAJERO'
BEGIN
SELECT @Cajero = @Codigo
IF @MovClave NOT iN('POS.AC','POS.ACM')
SELECT @Ok = 20180, @okRef = 'Solo se puede cambiar el Cajero en la apertura de Caja'
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Cajero AND Tipo = 'Cajero') AND @Ok IS NULL
SELECT @Ok = 10515, @OkRef = @Cajero
IF @Sucursal <> (SELECT SucursalEmpresa FROM Agente WHERE Agente = @Cajero) AND @Ok IS NULL
SELECT @Ok = 10200, @OkRef = 'El Cajero pertenece a otra Sucursal'
SELECT @CajeroActual  = Cajero FROM POSL WHERE ID  = @ID
IF EXISTS(SELECT * FROM POSEstatusCaja  WHERE Host = @Host AND Caja = @Caja AND Abierto = 1)
SELECT @Ok = 30435, @OkRef = @CajeroActual
IF @OK IS NULL
UPDATE POSL SET Cajero = @Cajero
WHERE ID = @ID
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL
END
IF @Accion = 'MATRIZ OPCIONES'
BEGIN
IF NOT EXISTS(SELECT * FROM ArtOpcion  a JOIN CB c ON a.Articulo = c.Cuenta WHERE c.Codigo = @Codigo )
SELECT @Ok = 20740, @OkRef = @Codigo
IF @Ok IS NULL
SELECT @Articulo = Cuenta FROM CB WHERE Codigo = @Codigo
SELECT @Expresion = 'POSMatrizOpciones( '+CHAR(39)+@ID+CHAR(39)+','+ CHAR(39)+@Articulo+CHAR(39)+','+' '+')'
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'CAMBIAR MOVIMIENTO'
BEGIN
IF @Codigo NOT IN (SELECT Mov FROM MovTipo WHERE Modulo = 'POS'
AND Clave NOT IN ('POS.CTCAC','POS.CTCRC','POS.STE','POS.FTE','POS.TCRC','POS.TCAC','POS.SALDOIN'))
AND @Codigo NOT IN (SELECT CONVERT(varchar,Orden) FROM MovTipo WHERE Modulo = 'POS')
SELECT @Ok = 26080, @OkRef = @Codigo
IF @Codigo IN (SELECT CONVERT(varchar, Orden) FROM MovTipo WHERE Modulo = 'POS')
SELECT TOP 1 @Codigo = Mov
FROM MovTipo mt
WHERE mt.Orden = @Codigo
AND mt.Modulo = 'POS'
AND mt.Clave NOT IN ('POS.CTCAC','POS.CTCRC','POS.STE','POS.FTE','POS.TCRC','POS.TCAC','POS.SALDOIN')
IF @Codigo NOT IN (SELECT Mov FROM POSUsuarioMov WHERE Usuario = ISNULL(NULLIF(@UsuarioPerfil,''),@Usuario))
SELECT @ok = 3, @okRef = 'El usuario no tiene acceso a este movimiento'
IF @Ok IS NULL
UPDATE POSL
SET Mov = mt.Mov,
Modulo = mt.ConsecutivoModulo,
FechaEmision = CASE WHEN @SugerirFechaCierre = 1
THEN CASE WHEN mt.Clave IN('POS.AC','POS.ACM')
THEN dbo.fnPOSFechaCierre2(@Empresa,@Sucursal,@FechaCierre,@Caja)
ELSE dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
END
ELSE dbo.fnFechaSinHora(GETDATE())
END
FROM POSL, MovTipo mt
WHERE mt.Modulo = 'POS'
AND mt.Mov = @Codigo
AND ID = @ID
SELECT @MovClave = Clave, @MovSubClave = SubClave
FROM MovTipo mt
INNER JOIN POSL pl ON mt.Mov = pl.Mov AND pl.ID = @ID
WHERE mt.Modulo = 'POS'
SELECT @Codigo = NULL
IF @MovClave IN ('POS.AC', 'POS.CC','POS.AP', 'POS.CPC','POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.TRM')
BEGIN
SELECT @CodigoAccion = 'INTRODUCIR CUENTA DINERO'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.FA') AND @MovSubClave IS NULL
BEGIN
SELECT @CodigoAccion = 'INTRODUCIR CONCEPTOCXC'
SELECT @Accion = NULL
DELETE POSConceptoCXCTemp WHERE Estacion = @Estacion
INSERT POSConceptoCXCTemp(
Estacion, Concepto)
SELECT
@Estacion, Concepto
FROM Concepto
WHERE Modulo = 'CXC'
SELECT @Orden = 0
UPDATE POSConceptoCXCTemp
SET @Orden = Orden = @Orden + 1
FROM POSConceptoCXCTemp
WHERE  Estacion = @Estacion
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.FA') AND @MovSubClave = 'POS.ANTREF'
BEGIN
SELECT @CodigoAccion = 'SELECCIONARCTE'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.N') AND @MovSubClave = 'POS.DREF'
BEGIN
SELECT @CodigoAccion = 'REFERENCIAR VENTA'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.CXCC','POS.CXCD')
BEGIN
SELECT @CodigoAccion = 'SELECCIONARCTE'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.INVD', 'POS.INVA')
BEGIN
SELECT @CodigoAccion = 'ALMACEN DESTINO'
SELECT @Accion = NULL
DELETE POSAlmTemp WHERE Estacion = @Estacion
INSERT POSAlmTemp(
Estacion, Almacen)
SELECT
@Estacion, Almacen
FROM Alm
SELECT @Orden = 0
UPDATE POSAlmTemp
SET @Orden = Orden = @Orden + 1
FROM POSAlmTemp
WHERE Estacion = @Estacion
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.CAC', 'POS.CCC', 'POS.CCPC','POS.CACM','POS.CCCM','POS.CCPCM','POS.CTCM','POS.CTRM')
BEGIN
SELECT @CodigoAccion = 'CANCELACION DINERO'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave IN ('POS.IC')
BEGIN
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA FORMA DE PAGO'
IF @Ok IS NULL
UPDATE POSL SET CtaDineroDestino = CtaDinero
WHERE ID = @ID
END
IF @MovClave IN('POS.EC')
BEGIN
SELECT @CodigoAccion = 'BENEFICIARIO'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @MovClave ='POS.N' AND @MovSubClave = 'POS.PEDCONT'
BEGIN
SELECT @CondicionPedidoContado = NULLIF(CondicionPedidoContado,'') FROM POSCfg WHERE Empresa = @Empresa
UPDATE POSL SET Condicion = @CondicionPedidoContado
WHERE ID = @ID
END
IF @MovClave IN ('POS.TCAC','POS.AC','POS.ACM','POS.AP','POS.CTCAC','POS.CACM','POS.CCCM','POS.CTCRC','POS.CTCM',
'POS.CTRM','POS.CAC','POS.CCC','POS.CC','POS.CCM','POS.CPCM','POS.CPC','POS.EC','POS.FTE','POS.IC','POS.TCM',
'POS.TCRC','POS.STE','POS.TCM','POS.TRM')
BEGIN
UPDATE POSL
SET Estatus = 'PENDIENTE'
WHERE ID = @ID
END
END
IF @Accion = 'REFERENCIAR PEDIDO'
BEGIN
SELECT @CodigoAccion = 'REFERENCIAR PEDIDO'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'REFERENCIAR COBRO'
BEGIN
SELECT @CodigoAccion = 'REFERENCIAR COBRO'
SELECT @Accion = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'SERIE/LOTE'
BEGIN
SELECT @SerieLoteCancelarPartida = CASE WHEN Referencia = 'CANCELAR PARTIDA'
THEN 1
ELSE 0
END
FROM POSLAccion
WHERE Host = @Host
AND Caja = @Caja
SELECT @SerieLote = @Codigo
EXEC spPOSLVerArtSeleccionado @ID, @Articulo OUTPUT, @SubCuenta OUTPUT, @CantidadOriginal OUTPUT, @Unidad OUTPUT, NULL
IF ISNULL(@SerieLoteCancelarPartida,0) = 0
BEGIN
IF ISNULL((SELECT SUM(Cantidad)
FROM POSLVenta plv
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo
AND plv.Unidad = @Unidad
AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')),0) <= 0
SELECT @EsDevolucion = 1
END
IF ISNULL(@SerieLoteCancelarPartida,0) = 1
BEGIN
IF ISNULL((SELECT SUM(Cantidad)
FROM POSLVenta plv
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo
AND plv.Unidad = @Unidad
AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')),0) < 0
SELECT @EsDevolucion = 1
END
SELECT @RenglonUbicado = MAX(RenglonID)
FROM POSLVenta plv
WHERE plv.ID = @ID
AND plv.Articulo = @Articulo
AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')
SELECT @ArtTipo = Tipo
FROM Art
WHERE Articulo = @Articulo
IF @ArtTipo = 'Serie'
BEGIN
IF ISNULL(@SerieLoteCancelarPartida,0) = 0 AND ISNULL(@EsDevolucion,0) = 0
BEGIN
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @ID AND SerieLote = @SerieLote
AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,''))
SELECT @Mensaje = 'El Numero de Serie/Lote Esta Duplicado, ' + ISNULL(@SerieLote,'')
END
IF ISNULL(@SerieLoteCancelarPartida,0) = 1 AND ISNULL(@EsDevolucion,0) = 1
BEGIN
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @ID AND SerieLote = @SerieLote
AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,''))
SELECT @Mensaje = 'El Numero de Serie/Lote Esta Duplicado, ' + ISNULL(@SerieLote,'')
END
END
IF @SerieLote NOT IN ('TEMP','1')
IF NOT EXISTS(SELECT 1 FROM SerieLote WHERE SerieLote = @SerieLote AND Articulo = @Articulo
AND ISNULL(Existencia,0) > 0)AND ISNULL(@EsDevolucion,0) =  0
BEGIN
SELECT @Mensaje = 'El Numero de Serie/Lote No Existe, ' + ISNULL(@SerieLote,'')
END
IF @Mensaje IN ('El Numero de Serie/Lote No Existe, ' + ISNULL(@SerieLote,''), 'El Numero de Serie/Lote Esta Duplicado, ' + ISNULL(@SerieLote,''))
BEGIN
IF @Mensaje IN ('El Numero de Serie/Lote No Existe, ' + ISNULL(@SerieLote,''))
SELECT @NoAfectarSerieLote = 1
ELSE
SELECT @NoAfectarSerieLote = 0
SELECT
@Mov = p.Mov,
@MovID = p.MovID,
@Estatus = p.Estatus,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal
FROM POSL p
WHERE ID = @ID
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT TOP 1 @Codigo = Codigo
FROM CB
WHERE Cuenta = @Articulo
AND ISNULL(Subcuenta, '') = ISNULL(@SubCuenta,'')
IF ISNULL(@SerieLoteCancelarPartida,0) = 1
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, NULL, @Estacion, @Mensaje,
@ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Expresion OUTPUT, @EliminarSerieLote = 1,
@SerieLote = @SerieLote, @TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT,
@TorretaPosicion1= @TorretaPosicion1   OUTPUT,  @TorretaPosicion2 = @TorretaPosicion2  OUTPUT
ELSE
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, 'CANCELAR PARTIDA', @Estacion, @Mensaje,
@ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Expresion OUTPUT, @EliminarSerieLote = 1,
@SerieLote = @SerieLote, @TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT,
@TorretaPosicion1= @TorretaPosicion1   OUTPUT,  @TorretaPosicion2 = @TorretaPosicion2  OUTPUT, @NoAfectarSerieLote = @NoAfectarSerieLote
END
IF @RenglonUbicado IS NOT NULL AND @ok IS NULL
AND @Mensaje NOT IN ('El Numero de Serie/Lote No Existe, ' + ISNULL(@SerieLote,''), 'El Numero de Serie/Lote Esta Duplicado, ' + ISNULL(@SerieLote,'') )
BEGIN
IF ISNULL(@SerieLoteCancelarPartida,0) = 0
BEGIN
IF ISNULL(@EsDevolucion,0) = 0
BEGIN
INSERT POSLSerieLote (ID,  RenglonID,       Articulo,  SubCuenta,  SerieLote)
VALUES (@ID, @RenglonUbicado, @Articulo, ISNULL(@SubCuenta,''), @SerieLote)
END
IF ISNULL(@EsDevolucion,0) = 1
BEGIN
SELECT TOP 1 @IDL = IDL
FROM POSLSerieLote pl
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
AND ISNULL(pl.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND pl.SerieLote = @SerieLote
ORDER BY Orden DESC
IF @IDL IS NULL
SELECT TOP 1 @IDL = IDL
FROM POSLSerieLote pl
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
AND ISNULL(pl.SubCuenta, '') = ISNULL(@SubCuenta, '')
ORDER BY Orden DESC
DELETE FROM POSLSerieLote WHERE IDL = @IDL
END
END
IF ISNULL(@SerieLoteCancelarPartida,0) = 1
BEGIN
IF @EsDevolucion = 1
BEGIN
INSERT POSLSerieLote (
ID, RenglonID, Articulo, SubCuenta, SerieLote)
VALUES (
@ID, @RenglonUbicado, @Articulo, ISNULL(@SubCuenta,''), @SerieLote)
END
IF ISNULL(@EsDevolucion,0) = 0
BEGIN
SELECT TOP 1 @IDL = IDL
FROM POSLSerieLote pl
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
AND ISNULL(pl.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND pl.SerieLote = @SerieLote
ORDER BY Orden DESC
IF @IDL IS NULL
SELECT TOP 1 @IDL = IDL
FROM POSLSerieLote pl
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
AND ISNULL(pl.SubCuenta, '') = ISNULL(@SubCuenta, '')
ORDER BY Orden DESC
DELETE FROM POSLSerieLote WHERE IDL = @IDL
END
END
END
SELECT @Codigo = NULL
IF isnull(@SerieLoteCancelarPartida,0) = 0 AND isnull(@EsDevolucion,0) = 0 AND nullif(@Mensaje,'') IS NULL
BEGIN
SELECT @Renglon = Renglon FROM POSLVenta WHERE ID = @ID AND POSAgentePend = 1
IF @Renglon IS NOT NULL
BEGIN
SELECT @Expresion = 'Asigna(Info.Renglon,'+CONVERT(varchar, @Renglon)+') FormaModal('+CHAR(39)+'POSAgenteDetalle'+CHAR(39)+')'
UPDATE POSLVenta SET POSAgentePend = 0 WHERE ID = @ID AND Renglon = @Renglon
END
END
END
IF @Accion = 'BUSCAR MOVIMIENTO' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSLPorCobrar pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC')
WHERE  pl.Estatus = 'PORCOBRAR' AND LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo)
SELECT @Codigo = ID FROM POSLPorCobrar pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC')
WHERE pl.Estatus = 'PORCOBRAR' AND LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo
IF EXISTS(SELECT * FROM POSLPorCobrar WHERE IDCB  = @Codigo AND Estatus = 'PORCOBRAR')
SELECT @Codigo = ID FROM POSLPorCobrar WHERE IDCB  = @Codigo AND Estatus = 'PORCOBRAR'
IF EXISTS(SELECT 1 FROM POSLPorCobrar WHERE ID = @Codigo AND Estatus = 'PORCOBRAR')
BEGIN
SELECT @Mov = cd.MovOmision
FROM Usuario u
JOIN CtaDinero cd ON u.DefCtaDinero = cd.CtaDinero AND cd.Tipo = 'Caja'
WHERE u.Usuario = @Usuario
IF @Mov IS NULL
SELECT TOP 1 @Mov = mt.Mov
FROM MovTipo mt
WHERE mt.Modulo = 'POS'
AND mt.Clave = 'POS.N'
AND mt.Mov NOT IN ('Dev. Referenciada', 'Nota Devolucion', 'Nota Emida', 'Nota Por Facturar', 'Nota Servicios', 'Pedido Contado', 'Recarga Tel. LDI')
ORDER BY mt.Orden
SELECT
@CtaDinero = DefCtaDinero,
@Cajero = DefCajero
FROM Usuario
WHERE Usuario = @Usuario
SELECT @CheckSumDO = ISNULL(DCheckSum,0), @CheckSumEO = ISNULL(ECheckSum,0) FROM POSLPorCobrar WHERE ID = @Codigo
SELECT @CheckSumE = dbo.fnPOSCheckSumEncabezado(@Codigo)
SELECT @CheckSumD =  ISNULL(SUM(CONVERT(bigint,dbo.fnPOSCheckSumDetalle(@Codigo,Renglon))),0)
FROM POSLPorCobrarD WHERE ID = @Codigo
IF (@CheckSumD <> @CheckSumDO) OR (@CheckSumE <> @CheckSumEO)
SELECT @Ok = 30442
IF @Ok IS NULL
SELECT @ID = NEWID()
IF @Ok IS NULL
INSERT POSL(
ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia,
Observaciones, Estatus, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia,
Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen,  Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero,
Descuento, DescuentoGlobal, Importe, Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal,
OrigenTipo, Origen, OrigenID, Tasa, Prefijo, Consecutivo,  IDR, Monedero, BeneficiarioNombre, HOST, Cluster, Usuario, Cajero, Directo)
SELECT
@ID, Empresa, Modulo, @Mov, NULL, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia,
Observaciones, 'SINAFECTAR', Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia,
Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, EnviarA, Almacen,  Agente, FormaEnvio, Condicion, Vencimiento,  @CtaDinero,
Descuento, DescuentoGlobal, Importe, Impuestos, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, @Sucursal,
OrigenTipo, Origen, OrigenID, Tasa, Prefijo, Consecutivo,  ID, Monedero, BeneficiarioNombre, @Host, @Cluster, @Usuario, @Cajero, Directo
FROM POSLPorCobrar
WHERE ID = @Codigo
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, Puntos, Comision,
CantidadObsequio, OfertaID, SerieLote, LDIServicio, Juego, Aplicado, PrecioImpuestoInc, AplicaDescGlobal, Codigo, Almacen)
SELECT
@ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, Puntos, Comision,
CantidadObsequio, OfertaID, SerieLote, LDIServicio, Juego, Aplicado, PrecioImpuestoInc, AplicaDescGlobal, Codigo, Almacen
FROM POSLPorCobrarD
WHERE ID = @Codigo
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSLVenta p JOIN Art a ON p.Articulo = a.Articulo   WHERE a.Tipo IN ('Serie', 'Lote'))
BEGIN
INSERT POSLSerieLote(
ID,  RenglonID, Articulo, SubCuenta, SerieLote)
SELECT
@ID, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM POSLPorCobrarSerieLote
WHERE ID = @Codigo
END
END
ELSE
SELECT @Ok = 30120, @OkRef = @Codigo
SELECT @Codigo = NULL
END
IF @Accion = 'ORIGEN DEVOLUCION' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC','POS.P')
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo AND pl.Importe >= 0)
SELECT @Codigo = ID FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC', 'POS.P')
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo AND pl.Importe >= 0
IF EXISTS(SELECT * FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB  = @Codigo AND pl.Importe >= 0)
SELECT @Codigo = cb.ID FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo AND pl.Importe >= 0
IF NOT EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC', 'POS.P')
WHERE pl.ID = @Codigo)
SELECT @Ok = 35005
IF EXISTS(SELECT * FROM POSL WHERE ID = @Codigo)
BEGIN
SELECT
plv.Articulo,
plv.Cantidad,
plv.SubCuenta,
plv2.ID
INTO #ArticulosSinDevolucion
FROM POSLVenta plv
LEFT OUTER JOIN POSLVenta plv2 ON plv2.ID = @Codigo
AND plv.Articulo = plv2.Articulo
AND ISNULL(plv.Subcuenta,'') = ISNULL(plv2.Subcuenta,'')
AND plv.Cantidad <= plv2.Cantidad
WHERE plv.ID = @ID
IF EXISTS(SELECT TOP 1 * FROM #ArticulosSinDevolucion asd WHERE asd.ID IS NULL)
SELECT @Ok = 20380, @OkRef = MAX(ID)
FROM #ArticulosSinDevolucion
END
IF @Ok IS NULL AND @ID IS NOT NULL
BEGIN
DELETE POSLValidarDevolucion WHERE ID = @ID
INSERT POSLValidarDevolucion (ID, IDOrigen) VALUES (@ID, @Codigo)
END
SELECT @Codigo = NULL
END
IF @Accion IN ('DEVOLUCION TOTAL', 'DEVOLUCION PARCIAL') AND @Ok IS NULL
BEGIN
SELECT
@Mov = p.Mov,
@MovID = p.MovID,
@Estatus = p.Estatus,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal
FROM POSL p
WHERE ID = @ID
IF EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC')
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo AND pl.Importe >= 0)
SELECT @Codigo = ID FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC')
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo AND pl.Importe >= 0
IF EXISTS(SELECT * FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo AND pl.Importe >= 0)
SELECT @Codigo = cb.ID FROM  POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo AND pl.Importe >= 0
IF NOT EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N','POS.NPC', 'POS.P')
WHERE pl.ID = @Codigo)
SELECT @Ok = '35005'
IF (SELECT Devolucion FROM POSL pl WHERE pl.ID = @Codigo) = 1
SELECT @Ok = '20706'
IF (SELECT DevolucionP FROM POSL pl WHERE pl.ID = @Codigo) = 1 AND @Accion = 'DEVOLUCION TOTAL'
SELECT @Ok = '50001'
IF (SELECT ISNULL(NULLIF(POSDiasDev,''),0) FROM POSCfg WHERE Empresa = @Empresa) = 0
AND ((SELECT CONVERT (INT, dbo.fnFechaSinHora (GETDATE()) - (SELECT dbo.fnFechaSinHora(FechaRegistro) FROM POSL WHERE ID = @Codigo))) >
(SELECT ISNULL(POSDiasDev,365) FROM POSCfg WHERE Empresa = @Empresa))
SELECT @Ok = '20707'
IF EXISTS(SELECT * FROM POSL WHERE ID = @Codigo)
BEGIN
SELECT
plv.Articulo,
plv.Cantidad,
plv.SubCuenta,
plv2.ID
INTO #ArticulosSinDevolucion2
FROM POSLVenta plv
LEFT OUTER JOIN POSLVenta plv2 ON plv2.ID = @Codigo
AND plv.Articulo = plv2.Articulo
AND ISNULL(plv.Subcuenta,'') = ISNULL(plv2.Subcuenta,'')
AND plv.Cantidad <= plv2.Cantidad
WHERE plv.ID = @ID
IF EXISTS(SELECT TOP 1 * FROM #ArticulosSinDevolucion2 asd WHERE asd.ID IS NULL)
SELECT @Ok = 20380, @OkRef = MAX(ID)
FROM #ArticulosSinDevolucion2
END
IF @Ok IS NULL AND @ID IS NOT NULL
BEGIN
DELETE POSLValidarDevolucion WHERE ID = @ID
INSERT POSLValidarDevolucion (ID, IDOrigen) VALUES (@ID, @Codigo)
END
IF @Ok IS NULL AND @ID IS NOT NULL
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio,
@Condicion, @Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, @Accion, @Estacion,
@Mensaje OUTPUT, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Expresion OUTPUT, @Cantidad = @Peso, @Juego = 0,
@TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT, @TorretaPosicion1= @TorretaPosicion1 OUTPUT,
@TorretaPosicion2 = @TorretaPosicion2  OUTPUT
SELECT @Codigo = NULL
END
IF @Accion = 'REFERENCIAR VENTA' AND @Ok IS NULL
BEGIN
SELECT @Mov = p.Mov,
@MovID = p.MovID,
@Estatus = p.Estatus,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal
FROM POSL p
WHERE ID = @ID
IF @Ok IS NULL AND @ID IS NOT NULL
IF ISNULL(@Accion,'') ='REFERENCIAR VENTA'
BEGIN
IF EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N')
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo)
SELECT @Codigo = ID
FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N')
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo
IF EXISTS(SELECT * FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo AND pl.Importe >= 0)
SELECT @Codigo = cb.ID FROM  POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo AND pl.Importe >= 0
IF NOT EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave IN ('POS.F', 'POS.N')
WHERE pl.ID = @Codigo)
BEGIN
IF @WebService = 1
EXEC spPOSWSSolicitudDevRef  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Codigo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSVentaPedidodTemp2 WHERE Estacion = @Estacion)
BEGIN
SELECT @NoExiste = 0
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSVentaPedidoDTemp2'+CHAR(39)+')'
END
END
ELSE
BEGIN
EXEC spPOSImportarDevRefLocal @ID, @Codigo, @Estacion, @Sucursal,@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND EXISTS(SELECT * FROM POSVentaPedidodTemp2 WHERE Estacion = @Estacion)
BEGIN
SELECT @NoExiste = 0
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSVentaPedidoDTemp2'+CHAR(39)+')'
END
END
IF @NoExiste = 1 AND @Ok IS NULL
BEGIN
SELECT @CodigoAccion = 'REFERENCIAR VENTA'
SELECT @Accion = NULL
SELECT @Ok = 14055, @OkRef = @OkRef+' ('+@Codigo+')<BR>POR FAVOR INGRESE EL ID DE LA VENTA ORIGINAL<BR>PARA SALIR PRECIONE CTRL+Q'
END
IF @NoExiste = 1 AND @Ok = 30465
BEGIN
SELECT @CodigoAccion = 'REFERENCIAR VENTA'
SELECT @Accion = NULL
SELECT @OkRef = @OkRef+'  POR FAVOR INGRESE EL ID DE LA VENTA ORIGINAL<BR>PARA SALIR PRECIONE CTRL+Q'
END
END
SELECT @Codigo = NULL
END
IF @Accion = 'REVERSAR MOV' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave =
CASE WHEN @MovClave = 'POS.CAC' THEN 'POS.AC'
WHEN @MovClave = 'POS.CCC' THEN 'POS.CC'
WHEN @MovClave = 'POS.CPC' THEN 'POS.CP'
WHEN @MovClave = 'POS.CACM' THEN 'POS.ACM'
WHEN @MovClave = 'POS.CCCM' THEN 'POS.CCM'
WHEN @MovClave = 'POS.CCPCM' THEN 'POS.CPCM'
WHEN @MovClave = 'POS.CTRM' THEN 'POS.TRM'
WHEN @MovClave = 'POS.CTCM' THEN 'POS.TCM'
END
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo AND pl.Estatus = 'CONCLUIDO')
SELECT @Codigo = ID FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave =
CASE WHEN @MovClave = 'POS.CAC' THEN 'POS.AC'
WHEN @MovClave = 'POS.CCC' THEN 'POS.CC'
WHEN @MovClave = 'POS.CPC' THEN 'POS.CP'
WHEN @MovClave = 'POS.CACM' THEN 'POS.ACM'
WHEN @MovClave = 'POS.CCCM' THEN 'POS.CCM'
WHEN @MovClave = 'POS.CCPCM' THEN 'POS.CPCM'
WHEN @MovClave = 'POS.CTRM' THEN 'POS.TRM'
WHEN @MovClave = 'POS.CTCM' THEN 'POS.TCM'
END
WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @Codigo AND pl.Estatus = 'CONCLUIDO'
IF EXISTS(SELECT * FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo)
SELECT @Codigo = cb.ID  FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @Codigo
IF NOT EXISTS(SELECT * FROM POSL pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'POS' AND mt.Clave =
CASE WHEN @MovClave = 'POS.CAC' THEN 'POS.AC'
WHEN @MovClave = 'POS.CCC' THEN 'POS.CC'
WHEN @MovClave = 'POS.CPC' THEN 'POS.CP'
WHEN @MovClave = 'POS.CACM' THEN 'POS.ACM'
WHEN @MovClave = 'POS.CCCM' THEN 'POS.CCM'
WHEN @MovClave = 'POS.CCPCM' THEN 'POS.CPCM'
WHEN @MovClave = 'POS.CTRM' THEN 'POS.TRM'
WHEN @MovClave = 'POS.CTCM' THEN 'POS.TCM'
END
WHERE pl.ID = @Codigo AND pl.Estatus = 'CONCLUIDO')
SELECT @Ok = 35005
IF @Ok IS NULL  AND  @MovClave NOT IN ('POS.CTCM') AND EXISTS(SELECT * FROM POSL  p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.FechaRegistro > (SELECT FechaRegistro FROM POSL WHERE ID = @Codigo) AND p.Estatus IN('CONCLUIDO','TRASPASADO')
AND m.Clave NOT IN('POS.FTE','POS.STE'))
SELECT @Ok = 30151
IF @Ok IS NULL AND  @MovClave IN ('POS.CTCM') AND EXISTS(SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @Codigo AND p.Estatus IN('CONCLUIDO','TRASPASADO') AND m.Clave = 'POS.CTCM')
SELECT @Ok = 60050
IF @Ok IS NULL AND  @MovClave IN ('POS.CTRM') AND EXISTS(SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @Codigo AND p.Estatus IN('CONCLUIDO','TRASPASADO') AND m.Clave = 'POS.CTRM')
SELECT @Ok = 60050
IF @Ok IS NULL
DELETE POSLAccion
WHERE Host = @Host
AND Accion = @CodigoAccion
AND Caja = @Caja
SELECT @CodigoAccion = 'REVERSAR MOV'
END
IF @Accion IN ('BUSCAR ARTICULOS', 'CONSULTAR INV') AND @Ok IS NULL
BEGIN
SELECT @ArtConsulta = @Codigo
SELECT @Codigo = NULL
END
IF @Accion IN ('VERIFICAR PRECIOS') AND @Ok IS NULL
BEGIN
SELECT @ArtConsulta = @Codigo
SELECT @Codigo = NULL
END
IF @Accion = 'MODIFICAR CANTIDAD' AND @Ok IS NULL
BEGIN
IF (SELECT dbo.fnEsNumerico(@Codigo)) = 0 OR LEN(@Codigo)>=10
SELECT @Ok = 20010, @OkRef = @Codigo
ELSE
SELECT @Cantidad = @Codigo, @CantidadContador = 0
IF  @Cantidad <= 0
SELECT @Ok = 20010, @OkRef = 'No se permiten candidas en Cero o Negativas'
IF @AgruparArticulos = 0
SELECT @Ok = 20500, @OkRef = 'Esta funcionalidad funciona con el POS configurado para Agrupar Articulos'
EXEC spPOSLVerArtSeleccionado @ID, @Articulo OUTPUT, @SubCuenta OUTPUT, @CantidadOriginal OUTPUT, @Unidad OUTPUT, @Codigo OUTPUT
IF (SELECT Tipo FROM Art WHERE Articulo = @Articulo) IN ('Serie', 'Lote')
SELECT @Ok = 73040, @OkRef = 'Esta funcionalidad no aplica para articulos tipo Serie/Lote'
IF (SELECT Tipo FROM Art WHERE Articulo = @Articulo) IN ('Juego')
SELECT @Ok = 73040, @OkRef = 'Esta funcionalidad no aplica para articulos tipo Juego'
IF EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo)  AND @SubCuenta IS NULL
SELECT @Ok = 73040, @OkRef = 'Esta funcionalidad no aplica para articulos con Opciones'
SELECT
@Mov = p.Mov,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal
FROM POSL p
WHERE ID = @ID
SELECT @BasculaPesar = BasculaPesar
FROM Art a
WHERE a.Articulo = @Articulo
IF ISNULL(@BasculaPesar,0) = 1
BEGIN
SELECT @Ok = 73040, @OkRef = 'Debe Utilizar la Acción Pesar en articulos configurados para pesarse'
DELETE POSLAccion WHERE Host = @Host AND Accion = ISNULL(@CodigoAccion, @Accion) AND Caja = @Caja
END
SELECT @CantidadCodigo=Cantidad  FROM CB WHERE Codigo = @Codigo AND TipoCuenta = 'Articulos'
IF @Codigo IS NULL
SELECT @Codigo = MAX(Codigo)
FROM CB
WHERE TipoCuenta = 'Articulos'
AND Cuenta = @Articulo
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
AND Unidad = ISNULL(@Unidad,Unidad)
IF @Ok IS NULL AND @IDDevolucionP IS NULL
BEGIN
SELECT @Cantidad = @Cantidad * ISNULL(@CantidadCodigo,1)
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, @Accion, @Estacion,
@Mensaje OUTPUT, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Expresion OUTPUT, @Juego = 0,
@TorretaMensaje1 = @TorretaMensaje1 OUTPUT, @TorretaMensaje2 = @TorretaMensaje2  OUTPUT, @TorretaPosicion1 = @TorretaPosicion1   OUTPUT,
@TorretaPosicion2 = @TorretaPosicion2  OUTPUT, @Cantidad = @Cantidad
END
ELSE
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, @Accion, @Estacion,
@Mensaje OUTPUT, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Expresion OUTPUT, @Cantidad = @Cantidad, @Juego = 0,
@TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT, @TorretaPosicion1= @TorretaPosicion1   OUTPUT,
@TorretaPosicion2 = @TorretaPosicion2  OUTPUT
SELECT @Codigo = NULL
END
IF @Accion = 'MULTIPLICAR CANTIDAD' AND @Ok IS NULL
BEGIN
IF @AgruparArticulos = 0
SELECT @Ok = 20500, @OkRef = 'Esta funcionalidad funciona con el POS configurado para Agrupar Articulos'
IF (SELECT dbo.fnEsNumerico(@Codigo)) = 0 OR LEN(@Codigo)>=10
SELECT @Ok = 20010, @OkRef = @Codigo
ELSE
SELECT @Cantidad = @Codigo, @CantidadContador = 0
EXEC spPOSLVerArtSeleccionado @ID, @Articulo OUTPUT, @SubCuenta OUTPUT, @CantidadOriginal OUTPUT, @Unidad OUTPUT, NULL
IF (SELECT Tipo FROM Art WHERE Articulo = @Articulo) IN ('Serie', 'Lote')
SELECT @Ok = 73040, @OkRef = 'Esta funcionalidad no aplica para articulos tipo Serie/Lote'
IF (SELECT Tipo FROM Art WHERE Articulo = @Articulo) IN ('Juego')
SELECT @Ok = 73040, @OkRef = 'Esta funcionalidad no aplica para articulos tipo Juego'
IF EXISTS(SELECT * FROM ArtOpcion  WHERE Articulo = @Articulo)  AND @SubCuenta IS NULL
SELECT @Ok = 73040, @OkRef = 'Esta funcionalidad no aplica para articulos con Opciones'
SELECT
@Mov = p.Mov,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal
FROM POSL p
WHERE ID = @ID
SELECT @BasculaPesar = BasculaPesar
FROM Art a
WHERE a.Articulo = @Articulo
IF ISNULL(@BasculaPesar,0) = 1
BEGIN
SELECT @Ok = 73040, @OkRef = 'Debe Utilizar la Acción Pesar en articulos configurados para pesarse'
DELETE POSLAccion WHERE Host = @Host AND Accion = ISNULL(@CodigoAccion, @Accion) AND Caja = @Caja
END
SELECT @Codigo = MAX(Codigo)
FROM CB
WHERE TipoCuenta = 'Articulos'
AND Cuenta = @Articulo
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
AND Unidad = ISNULL(@Unidad,Unidad)
IF @Ok IS NULL
BEGIN
UPDATE POSLVenta SET Cantidad = Cantidad+(@Cantidad-1)
WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Unidad = @Unidad
SET @CantidadContador=0
END
SELECT @Codigo = NULL
END
IF @Accion = 'FORMA ENVIO' AND @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM POSFormaEnvioTemp WHERE Estacion = @Estacion and Orden = CONVERT(INT,@Codigo))
SELECT @ok = 20702, @OkRef = @Codigo
SELECT @FormaEnvioV = FormaEnvio
FROM POSFormaEnvioTemp
WHERE Estacion = @Estacion AND Orden = CONVERT(INT,@Codigo)
UPDATE POSL SET FormaEnvio = @FormaEnvioV WHERE ID = @ID
SELECT @Codigo = NULL
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @Accion = 'COPIAR OTRO MOV VENTAS'
BEGIN
IF EXISTS(SELECT 1 FROM Venta v WHERE UPPER(LTRIM(RTRIM(v.Mov))+ ' ' + LTRIM(RTRIM(v.MovID))) = @Codigo OR CONVERT(varchar,v.ID) = @Codigo
AND v.Empresa = @Empresa)
BEGIN
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Imagen OUTPUT
EXEC spPOSMovCopiar @ID, @Codigo, 'VTAS', @Ok OUTPUT, @OkRef OUTPUT
END
ELSE
SELECT @Ok = 14055, @OkRef = @Codigo
SELECT @Codigo = NULL
END
IF @Accion = 'REFERENCIAR PEDIDOMANUAL'
BEGIN
UPDATE POSL SET PedidoReferencia = @Codigo
WHERE ID = @ID
DELETE POSLAccion WHERE Host = @Host AND Accion = ISNULL(@CodigoAccion, @Accion) AND Caja = @Caja
SELECT @CodigoAccion = 'INTRODUCIR CONCEPTOCXC'
IF EXISTS(SELECT * FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL,@Accion = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA EL NUMERO DEL CONCEPTO'
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,@CodigoAccion )
END
IF @Accion = 'INSERTA AGENTE' AND (SELECT POSAgenteDetalle  FROM POSCFG WHERE EMPRESA = @Empresa) = 1
BEGIN
SELECT TOP 1 @Renglon = Renglon FROM POSLVenta WHERE ID = @ID AND NULLIF(Agente,'') IS NULL
IF @Renglon IS NOT NULL
BEGIN
SELECT @Expresion = 'Asigna(Info.Renglon,'+CONVERT(varchar, @Renglon)+') FormaModal('+CHAR(39)+'POSAgenteDetalle'+CHAR(39)+')'
END
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
END

