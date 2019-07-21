SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvVerificarWMS
@ID							int,
@Tarima						varchar(20),
@MovTipo					char(20),
@Almacen					char(10),
@CantidadOriginal			float,
@CantidadA					float,
@CantidadPendiente			float,
@Accion						char(20),
@Articulo					char(20),
@FechaCaducidad				datetime,
@FechaEmision				datetime,
@ArtCaducidadMinima			int,
@Modulo						varchar(5),
@EsTransferencia			bit,
@Mov              			char(20),
@AlmacenTipo				char(15),
@AlmacenDestino				char(10),
@AlmacenDestinoTipo			char(15),
@CfgInvPrestamosGarantias	bit,
@Ok               			int           	= NULL OUTPUT,
@OkRef            			varchar(255)  	= NULL OUTPUT

AS BEGIN
DECLARE
@Disponible				float,
@Posicion				varchar(10),
@PosicionD				varchar(10),
@SubClave				varchar(20),
@WMSGral				bit,
@Empresa				char(5),
@WMSAlm					bit,
@WMSAlmD				bit,
@Tipo					varchar(20),
@BanderaDesentarimado   bit
SET @BanderaDesentarimado = 0
IF @Modulo = 'INV'
SELECT @Empresa = Empresa FROM Inv WHERE ID = @ID
ELSE
IF @Modulo = 'COMS'
SELECT @Empresa = Empresa FROM Compra WHERE ID = @ID
ELSE
IF @Modulo = 'VTAS'
SELECT  @Empresa = Empresa FROM Venta WHERE ID = @ID
ELSE
IF @Modulo = 'PROD'
SELECT  @Empresa = Empresa FROM Prod WHERE ID = @ID
SELECT @WMSGral = WMS FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @WMSAlm = ISNULL(WMS,0) FROM Alm WHERE Almacen = @Almacen
SELECT @WMSAlmD = ISNULL(WMS,0) FROM Alm WHERE Almacen = @AlmacenDestino
IF ISNULL(@WMSGral,0)=0
BEGIN
SET @WMSAlm = 0
SET @WMSAlmD = 0
END
SELECT @SubClave = ISNULL(SubClave,'') FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov AND Clave = @MovTipo
IF @Ok IS NULL AND @Accion NOT IN ('SINCRO', 'CANCELAR') AND @MovTipo NOT IN ('INV.IF', 'INV.A') AND @WMSAlm = 1
BEGIN
IF @Modulo = 'INV'
SELECT @Posicion = NULLIF(PosicionWMS,''), @PosicionD = NULLIF(PosicionDWMS,'') FROM Inv WHERE ID = @ID
ELSE
IF @Modulo = 'COMS'
SELECT @Posicion = NULLIF(PosicionWMS,'') FROM Compra WHERE ID = @ID
ELSE
IF @Modulo = 'VTAS'
SELECT @Posicion = NULLIF(PosicionWMS,'') FROM Venta WHERE ID = @ID
/*
No se requiere validar la posicion ya que al devolver de un almacen WMS a uno normal no se requiere la posicion
IF @Ok IS NULL AND @Posicion IS NULL AND @Modulo IN ('INV', 'COMS', 'VTAS', 'PROD') AND @WMSAlm = 1
SELECT @Ok = 13050
ELSE
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM AlmPos WHERE Posicion = @Posicion)
SELECT @OK = 13030
*/
IF @Ok IS NULL AND @PosicionD IS NULL AND @Modulo IN ('INV') AND @Mov IN ('INV.T','INV.TG','INV.P','INV.R','INV.EI','INV.SI','INV.OT','INV.OI','INV.TI','INV.DTI','INV.TIF','INV.TIS') AND @WMSAlmD = 1
SELECT @Ok = 13050
ELSE
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM AlmPos WHERE Posicion = @PosicionD) AND @Mov IN ('INV.T','INV.TG','INV.P','INV.R','INV.EI','INV.SI','INV.OT','INV.OI','INV.TI','INV.DTI','INV.TIF','INV.TIS')
SELECT @OK = 13030
SELECT @Disponible = Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Articulo  = @Articulo AND Almacen = @Almacen AND Empresa = @Empresa
IF @Accion IN ('RESERVARPARCIAL', 'RESERVAR')
SELECT @Disponible = Disponible FROM ArtDisponible WHERE Articulo  = @Articulo AND Almacen = @Almacen AND Empresa = @Empresa
IF @Ok IS NULL AND @Accion NOT IN ('CANCELAR', 'RESERVARPARCIAL', 'RESERVAR') AND @MovTipo NOT IN ('INV.TI', 'INV.EI') AND @Tarima IS NOT NULL AND @MovTipo <> 'INV.TMA' AND @WMSAlm = 0
IF ISNULL(@Disponible,0) < ISNULL(@CantidadOriginal,0) SELECT @Ok = 20020
IF @Ok IS NULL AND @Accion IN ('RESERVARPARCIAL') AND @Tarima IS NOT NULL AND @MovTipo <> 'INV.TMA'
IF ISNULL(@Disponible,0) < ISNULL(@CantidadA,0) SELECT @Ok = 20020
IF @Ok IS NULL AND @Accion IN ('RESERVAR') AND @Tarima IS NOT NULL AND @MovTipo <> 'INV.TMA'
IF ISNULL(@Disponible,0) < ISNULL(@CantidadA,0) SELECT @Ok = 20020
IF @Ok IS NULL AND @MovTipo IN ('INV.E', 'INV.EI') AND (SELECT ISNULL(TieneCaducidad,0) FROM Art WHERE Articulo = @Articulo) = 1
BEGIN
IF @FechaCaducidad IS NULL
SELECT @OK = 25125
IF DATEADD(DAY, (SELECT ISNULL(CaducidadMinima,0) FROM ART WHERE Articulo = @Articulo),@FechaEmision)> @FechaCaducidad
SELECT @OK = 25126
END
END
IF @Ok IS NULL AND @Accion NOT IN ('SINCRO', 'CANCELAR')
BEGIN
IF @Ok IS NULL AND @Modulo IN ('PROD') AND @WMSAlm = 1
BEGIN
SELECT @PosicionD = NULLIF(PosicionDWMS,'') FROM Prod WHERE ID = @ID
IF @MovTipo IN ('PROD.CO','PROD.E','PROD.O','PROD.A') AND ISNULL(@PosicionD,'') = ''
SELECT @Ok = 13050
END
END
IF @EsTransferencia = 1 AND @Accion <> 'GENERAR' AND @Ok IS NULL AND @SubClave = 'INV.TMA'
BEGIN
IF @AlmacenDestino <> @Almacen OR @AlmacenDestino IS NULL SELECT @Ok = 20120
ELSE
IF @AlmacenTipo <> @AlmacenDestinoTipo AND NOT (@AlmacenTipo IN ('NORMAL','PROCESO') AND @AlmacenDestinoTipo IN ('NORMAL','PROCESO'))
IF (@AlmacenTipo IN ('NORMAL','PROCESO','GARANTIAS') OR @AlmacenDestinoTipo IN ('NORMAL','PROCESO','GARANTIAS'))
BEGIN
IF @CfgInvPrestamosGarantias = 0 OR @MovTipo NOT IN ('INV.P', 'INV.R')
SELECT @Ok = 40130
END ELSE SELECT @Ok = 40130
IF @Ok IS NULL
BEGIN
SELECT @Posicion = Posicion FROM Tarima WHERE Tarima = @Tarima
SELECT @Tipo = Tipo FROM AlmPos WHERE Posicion = @Posicion
IF EXISTS (
SELECT *
FROM WMSTarimasSurtidoPendientes A
JOIN Movtipo B ON A.Modulo = B.Modulo AND A.Mov = B.Mov
WHERE B.Clave    = 'VTAS.P'
AND A.Empresa  = @Empresa
AND A.Articulo = @Articulo
AND A.Tarima   = @Tarima
AND A.CantidadPendiente IS NOT NULL
) AND @Tipo = 'Surtido'
SET @BanderaDesentarimado = 1
IF EXISTS(SELECT * FROM WMSTarimasSurtidoPendientes WHERE Empresa=@Empresa AND Articulo=@Articulo AND Tarima=@Tarima AND CantidadPendiente IS NOT NULL) AND @BanderaDesentarimado = 0
SELECT @Ok=13047, @OkRef='('+LTRIM(RTRIM(@Articulo))+' - '+LTRIM(RTRIM(@Tarima))+')'
END
IF @Ok IS NULL
BEGIN
SELECT @Disponible = Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Articulo  = @Articulo AND Almacen = @Almacen AND Empresa = @Empresa
IF ROUND(@CantidadOriginal,4)<>ROUND(@Disponible,4) AND @Accion <> 'CANCELAR'
SELECT @Ok=13150, @OkRef='La cantidad a desentarimar debe ser por el total de la tarima. ('+LTRIM(RTRIM(@Articulo))+' - '+LTRIM(RTRIM(@Tarima))+')'
END
END
IF @Ok IS NULL AND @Accion NOT IN ('SINCRO', 'CANCELAR') AND ISNULL(@Tarima,'') = '' AND @MovTipo IN('VTAS.F', 'INV.S', 'INV.A', 'INV.F', 'INV.T', 'INV.SI', 'VTAS.VCR') AND @WMSAlm = 1 
SELECT @Ok = 13130
IF @Ok IS NULL AND @Accion NOT IN ('SINCRO', 'CANCELAR') AND @MovTipo IN('VTAS.F', 'INV.S', 'INV.A', 'INV.F', 'INV.T', 'INV.SI', 'VTAS.VCR') AND @WMSAlm = 1 
BEGIN
SELECT @Tipo = p.Tipo FROM Tarima t JOIN AlmPos p ON t.Posicion = p.Posicion WHERE ISNULL(t.Tarima,'') = ISNULL(@Tarima,'')
IF ISNULL(UPPER(@Tipo),'') <> UPPER('Surtido') AND @MovTipo <> 'INV.A'
SELECT @Ok = 13138, @OkRef = 'La Tarima indicada: ' + ISNULL(@Tarima,'') + ' debe ser de tipo Surtido y contar con disponible'
IF @MovTipo = 'INV.T' AND @SubClave = 'INV.TMA' AND @Ok IS NOT NULL
SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(UPPER(@Tipo),'') = '' AND @MovTipo <> 'INV.A'
SELECT @Ok = 13138, @OkRef =  'La Tarima indicada: ' + ISNULL(@Tarima,'') + ' no existe'
END
EXEC xpInvVerificarWMS @ID, @Tarima, @MovTipo, @Almacen, @CantidadOriginal, @CantidadA, @CantidadPendiente, @Accion, @Articulo, @FechaCaducidad, @FechaEmision, @ArtCaducidadMinima, @Modulo, @EsTransferencia, @Mov, @AlmacenTipo, @AlmacenDestino, @AlmacenDestinoTipo, @CfgInvPrestamosGarantias, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

