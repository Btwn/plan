SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAVerificarPosicion
@ID						int,
@Accion					char(20),
@Empresa				char(5),
@Usuario				char(10),
@Modulo	      			char(5),
@Mov              		char(20),
@MovID					varchar(20),
@MovTipo				char(20),
@Almacen				char(10),
@Posicion				varchar(20),
@PosicionDestino		varchar(20),
@Tipo					varchar(20),
@TipoDestino			varchar(20),
@Articulo				varchar(20),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@ArtZona							varchar(50),
@AlmPosZona							varchar(50),
@WMSPermitirReacomodosDomicilio		bit
SELECT @WMSPermitirReacomodosDomicilio = ISNULL(WMSPermitirReacomodosDomicilio,0) FROM EmpresaCfg WHERE Empresa = @Empresa
IF @Tipo = 'Domicilio' AND @TipoDestino <> 'Domicilio'
SELECT @Ok = 10038
ELSE
IF @Tipo = 'Domicilio' AND @TipoDestino = 'Domicilio'
BEGIN
IF @WMSPermitirReacomodosDomicilio = 0
SELECT @OK = 20926
ELSE
IF(SELECT ISNULL(ArticuloEsp,'') FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionDestino) <> '' AND @WMSPermitirReacomodosDomicilio = 1
SELECT @Ok = 20927, @OkRef = 'Posición  ' + @PosicionDestino
ELSE
IF EXISTS(SELECT * FROM TMA w JOIN TMAD d ON w.ID = d.ID JOIN MovTipo m ON w.mov = m.Mov AND m.Modulo = 'TMA' WHERE m.Clave IN('TMA.ADO', 'TMA.RADO', 'TMA.SUR', 'TMA.TSUR', 'TMA.TSUR') AND w.Estatus IN('PENDIENTE', 'PROCESAR') AND d.PosicionDestino = @PosicionDestino)
SELECT @Ok = 20929, @OkRef = 'Posición  ' + @PosicionDestino
ELSE
BEGIN
SELECT @ArtZona = NULL, @AlmPosZona = NULL
SELECT @ArtZona = NULLIF(Zona,'') FROM  ArtZona WHERE Articulo = @Articulo AND Zona = '(Todas)'
SELECT @AlmPosZona = NULLIF(Zona,'') FROM AlmPos WHERE Posicion = @PosicionDestino AND Zona = '(Todas)'
IF @ArtZona <> @AlmPosZona
BEGIN
IF ISNULL(@ArtZona,'') <> '(Todas)' AND ISNULL(@AlmPosZona,'') <> '(Todas)'
IF NOT EXISTS(SELECT * FROM ArtZona WHERE Articulo = @Articulo AND Zona IN (SELECT Zona FROM AlmPos WHERE Posicion = @PosicionDestino))
SELECT @Ok = 20928, @OkRef = 'Posición  ' + @PosicionDestino
END
END
END
END

