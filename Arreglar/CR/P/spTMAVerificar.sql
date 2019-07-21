SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAVerificar
@ID               	int,
@Accion				char(20),
@Empresa          	char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              	char(20),
@MovID				varchar(20),
@MovTipo	      	char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Almacen			char(10),
@Agente				varchar(10),
@Ok               	int          OUTPUT,
@OkRef            	varchar(255) OUTPUT

AS BEGIN
DECLARE
@Tarima					varchar(20),
@TarimaEstatus			varchar(15),
@TarimaPosicion			varchar(10),
@Posicion				varchar(10),
@PosicionDestino		varchar(10),
@EstaPendiente			bit,
@WMS					bit,
@WMSValidarZona			bit,
@SubClave				char(20),
@TipoMov				varchar(20),
@Renglon				float,
@Articulo				varchar(20),
@Montacarga				varchar(10),
@MontacargaD			varchar(10),
@WMSTipoAcomodador		varchar(50),
@ZonaAgente				varchar(50),
@ZonaDetalle    		varchar(50),
@PesoMaximoMontaCarga	float,
@PesoMovimiento			float,
@Tipo					varchar(20),
@TipoDestino			varchar(20),
@WMSPermitirReacoDom	bit,
@ArtZona				varchar(50),
@AlmPosZona				varchar(50),
@VolumenMovimiento		float,
@VolumenMaximoPosicion	float,
@PosicionDestinoArt		varchar(10),
@PesoMaximoPosicion		float,
@AlmacenArt				varchar(10),
@CantidadAfectar		float,
@CantidadPendiente		float
SELECT @WMS = ISNULL(WMS,0) FROM Alm WHERE Almacen = @Almacen
SELECT @WMSValidarZona		= ISNULL(WMSValidarZona,0),
@WMSTipoAcomodador		= ISNULL(WMSTipoAcomodador,''),
@WMSPermitirReacoDom	= ISNULL(WMSPermitirReacomodosDomicilio,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT TOP 1 @SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
IF @Accion = 'AFECTAR' AND @MovTipo NOT IN ('TMA.SUR', 'TMA.SURPER', 'TMA.SRADO', 'TMA.ORADO', 'TMA.RADO', 'TMA.OPCKTARIMA', 'TMA.OSUR', 'TMA.PCKTARIMA', 'TMA.PCKTARIMATRAN', 'TMA.SURPER', 'TMA.TSUR')
EXEC spTMAVerificarSerieLote @Empresa, @Sucursal, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF @MovTipo IN ('TMA.OSUR', 'TMA.OPCKTARIMA') AND @Estatus IN('PENDIENTE', 'CONCLUIDO') AND EXISTS(SELECT * FROM TMA WHERE Origen = @Mov AND OrigenID = @MovID AND OrigenTipo = 'TMA' AND Estatus IN('CONCLUIDO', 'PROCESAR')) 
SELECT @Ok = 60060
END
IF @Almacen IS NULL AND @OK IS NULL SELECT @Ok = 20390 ELSE
IF @WMS = 0 AND @OK IS NULL SELECT @Ok = 20937, @OkRef = @Almacen
IF @MovTipo IN ('TMA.TSUR', 'TMA.ORADO', 'TMA.OADO', 'TMA.ADO', 'TMA.RADO', 'TMA.ORENT', 'TMA.SURPER', 'TMA.SUR', 'TMA.PCKTARIMATRAN', 'TMA.PCKTARIMA') AND @Accion <> 'CANCELAR' AND @OK IS NULL 
BEGIN
IF ISNULL(@Agente,'') = ''
SELECT @Ok = 20931, @OkRef = '' + CHAR(13) + @Mov + ' - ' + @MovID
IF (SELECT COUNT(0) FROM TMA WHERE ID = @ID AND ISNULL(Montacarga,'') = '') >0
SELECT @Ok = 20919, @OkRef = '' + CHAR(13) + @Mov + ' - ' + @MovID
END
IF @Accion NOT IN('CANCELAR', 'GENERAR') AND @MovTipo IN ('TMA.OADO', 'TMA.SADO', 'TMA.ADO', 'TMA.ORADO', 'TMA.SRADO', 'TMA.RADO', 'TMA.OSUR', 'TMA.TSUR', 'TMA.SUR', 'TMA.OSUR', 'TMA.OPCKTARIMA', 'TMA.PCKTARIMATRAN', 'TMA.PCKTARIMA') AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) 
BEGIN
IF @MovTipo IN ('TMA.OADO', 'TMA.SADO', 'TMA.ADO')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.ADO' AND Modulo = @Modulo
ELSE
IF @MovTipo IN ('TMA.ORADO', 'TMA.SRADO', 'TMA.RADO')
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.RADO' AND Modulo = @Modulo
ELSE
IF @MovTipo IN ('TMA.OSUR', 'TMA.TSUR', 'TMA.SUR', 'TMA.OPCKTARIMA', 'TMA.PCKTARIMATRAN', 'TMA.PCKTARIMA') 
SELECT @TipoMov = Mov FROM MovTipo WHERE Clave = 'TMA.SUR' AND Modulo = @Modulo
END
IF @Ok IS NULL
IF(SELECT COUNT(*) FROM TMAD d LEFT OUTER JOIN Tarima t ON t.Tarima = d.Tarima LEFT OUTER JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima WHERE d.ID = @ID) < 1
SELECT @Ok = 60010
IF @MovTipo IN('TMA.OADO','TMA.ORADO',/*'TMA.OSUR',*/'TMA.SURPER') AND @Agente IS NULL AND @Ok IS NULL
SELECT @Ok = 20931
IF @Ok IS NULL
BEGIN
DECLARE crVerificarTMAD CURSOR LOCAL FOR
SELECT NULLIF(RTRIM(d.Tarima), ''), NULLIF(RTRIM(d.Almacen), ''), NULLIF(RTRIM(d.Posicion), ''), NULLIF(RTRIM(d.PosicionDestino), ''), d.EstaPendiente, t.Estatus, t.Posicion, d.Renglon, a.Articulo, NULLIF(RTRIM(d.Montacarga), '') 
FROM TMAD d
LEFT OUTER JOIN Tarima t ON t.Tarima = d.Tarima
LEFT OUTER JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND d.Articulo=a.Articulo 
WHERE d.ID = @ID
OPEN crVerificarTMAD
FETCH NEXT FROM crVerificarTMAD INTO @Tarima, @Almacen, @Posicion, @PosicionDestino, @EstaPendiente, @TarimaEstatus, @TarimaPosicion, @Renglon, @Articulo, @Montacarga 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF EXISTS(SELECT * FROM Agente WHERE Agente = @Montacarga AND Tipo =  @WMSTipoAcomodador)
SELECT @ZonaAgente = NULLIF(@Montacarga,'') ELSE SELECT @ZonaAgente = Agente FROM TMA WHERE ID = @ID
IF @Ok IS NULL AND @Accion<>'CANCELAR' AND @MovTipo IN('TMA.ORADO', 'TMA.SRADO', 'TMA.RADO')
BEGIN
IF EXISTS(SELECT * FROM WMSTarimasSurtidoPendientes WHERE Empresa=@Empresa AND Articulo=@Articulo AND Tarima=@Tarima AND CantidadPendiente IS NOT NULL)
SELECT @Ok=13040, @OkRef='('+LTRIM(RTRIM(@Articulo))+' - '+LTRIM(RTRIM(@Tarima))+')'
END
IF @MovTipo IN('TMA.OSUR', 'TMA.SUR', 'TMA.SURPER', 'TMA.TSUR','TMA.OPCKTARIMA', 'TMA.PCKTARIMATRAN', 'TMA.PCKTARIMA') 
SELECT @ZonaDetalle = Zona FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen AND Tipo NOT IN('RECIBO', 'SURTIDO')
ELSE
SELECT @ZonaDetalle = Zona FROM AlmPos WHERE Posicion = @PosicionDestino AND Almacen = @Almacen AND Tipo NOT IN('RECIBO', 'SURTIDO')
IF @WMSValidarZona = 1 AND @Accion <> 'CANCELAR' AND NULLIF(@ZonaDetalle,'') IS NULL AND NULLIF(@ZonaAgente,'')<>''
AND EXISTS(SELECT * FROM AgenteZona WHERE Agente = ISNULL(@ZonaAgente,Agente) AND ISNULL(NULLIF(Tipo,''),@TipoMov) NOT IN (@TipoMov,'(Todos)'))
AND @Ok IS NULL
SELECT @Ok = 20946, @OkRef='Flujo: ' + @TipoMov +'<BR><BR>'+ 'Tarima: '+ @Tarima + '<BR><BR>' +'Agente : '+@ZonaAgente
IF @WMSValidarZona = 1 AND @Accion <> 'CANCELAR' AND NULLIF(@ZonaDetalle,'')<>'' AND NULLIF(@ZonaAgente,'')<>'' 
AND EXISTS(SELECT * FROM AgenteZona WHERE Agente = ISNULL(@ZonaAgente,Agente)) 
AND @Ok IS NULL
BEGIN
IF @TipoMov NOT IN (SELECT Tipo
FROM AgenteZona
WHERE Agente = ISNULL(@ZonaAgente,Agente) 
AND ISNULL(NULLIF(Tipo,''),@TipoMov) <>'(Todos)')
AND NOT EXISTS (SELECT Tipo
FROM AgenteZona
WHERE Agente = ISNULL(@ZonaAgente,Agente) 
AND ISNULL(NULLIF(Tipo,''),@TipoMov)='(Todos)') AND @Ok IS NULL
SELECT @Ok = 20945, @OkRef='Tarima: '+ @Tarima + '<BR><BR>' +'Agente : '+@ZonaAgente
IF NOT EXISTS(SELECT *
FROM AgenteZona
WHERE Agente = ISNULL(@ZonaAgente,Agente) 
AND ISNULL(NULLIF(Tipo,''),@TipoMov) IN (@TipoMov,'(Todos)')
AND Zona IN(ISNULL(@ZonaDetalle,Zona),'(TODAS)','(TODOS)')) AND @Ok IS NULL
SELECT @Ok = 20934, @OkRef='Tarima: '+ @Tarima + '<BR><BR>' +'Agente : '+@ZonaAgente
END
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
BEGIN
SELECT @Montacarga = Montacarga FROM TMA WHERE ID = @ID
SELECT @PesoMaximoMontaCarga = ISNULL(PesoMaximo,0.0) FROM Montacarga WHERE Montacarga = @Montacarga
DECLARE crVerificaPesoMontaCarga CURSOR FOR
SELECT a.PesoTarima, a.VolumenTarima
FROM ArtDisponibleTarima adt
JOIN TMAD td ON adt.Almacen = td.Almacen AND adt.Tarima = td.Tarima
JOIN Art a ON adt.Articulo = a.Articulo
WHERE adt.Empresa = @Empresa
AND td.ID = @ID
AND td.Tarima = @Tarima
OPEN crVerificaPesoMontaCarga
FETCH NEXT FROM crVerificaPesoMontaCarga INTO @PesoMovimiento, @VolumenMovimiento
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @PesoMovimiento > @PesoMaximoMontaCarga SET @Ok = 20932
FETCH NEXT FROM crVerificaPesoMontaCarga INTO @PesoMovimiento, @VolumenMovimiento
END
CLOSE crVerificaPesoMontaCarga
DEALLOCATE crVerificaPesoMontaCarga
END
END
IF(SELECT Estatus FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen) <> 'ALTA' AND @Ok IS NULL
SELECT @Ok = 13037, @OkRef = ' Posición Origen - ' + RTRIM(@Posicion)
IF NULLIF(RTRIM(@PosicionDestino), '') IS NOT NULL AND (SELECT Estatus FROM AlmPos WHERE Posicion = @PosicionDestino AND Almacen = @Almacen) <> 'ALTA' AND @Ok IS NULL
SELECT @Ok = 13037, @OkRef = ' Posición Destino - ' + RTRIM(@PosicionDestino)
IF(SELECT Estatus FROM AlmPos WHERE Posicion = @PosicionDestino AND Almacen = @Almacen) <> 'ALTA' AND @Ok IS NULL
SELECT @Ok = 13037, @OkRef = ' Posición Destino - ' + RTRIM(@PosicionDestino)
IF @Ok IS NULL AND @MovTipo IN ('TMA.ORADO', 'TMA.SRADO', 'TMA.RADO', 'TMA.ADO', 'TMA.OADO') AND @Accion <> 'CANCELAR' 
BEGIN
SELECT @Tipo = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
SELECT @TipoDestino = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @PosicionDestino AND Almacen = @Almacen
IF @Tipo NOT IN ('Ubicacion', 'Domicilio', 'Surtido', 'Cross Docking') AND @MovTipo NOT IN ('TMA.ADO', 'TMA.OADO', 'TMA.SADO')
SELECT @Ok = 20924
ELSE
IF @Tipo IN ('Surtido') AND @TipoDestino <> 'Domicilio' AND @MovTipo NOT IN ('TMA.ADO', 'TMA.OADO', 'TMA.SADO')
SELECT @Ok = 20949, @OkRef=@Tarima+' - '+@Articulo
ELSE
IF ISNULL(@Tipo,'') NOT IN ('Recibo', '') AND @MovTipo IN ('TMA.ADO', 'TMA.OADO', 'TMA.SADO')
SELECT @Ok = 20922
ELSE
IF @TipoDestino NOT IN ('Ubicacion', 'Domicilio', 'Cross Docking') AND ISNULL(@PosicionDestino,'') <> '' 
SELECT @Ok = 20925
IF @OK IS NULL AND @MovTipo NOT IN('TMA.ADO', 'TMA.OADO') 
BEGIN
IF @Tipo = 'Domicilio' AND @TipoDestino <> 'Domicilio'
SELECT @Ok = 10038
ELSE
IF @Tipo = 'Domicilio' AND @TipoDestino = 'Domicilio'
BEGIN
IF @WMSPermitirReacoDom = 0
SELECT @OK = 20926
ELSE
IF(SELECT ISNULL(ArticuloEsp,'') FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionDestino) <> '' AND @WMSPermitirReacoDom = 1
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
END
IF @MovTipo IN('TMA.SRADO','TMA.RADO') AND @Ok IS NULL
BEGIN
IF @Tipo = 'Domicilio' AND @TipoDestino = 'Domicilio'
BEGIN
IF EXISTS(SELECT * FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo m ON t.Mov = m.Mov AND m.Modulo = 'TMA'
WHERE t.Estatus IN ('PENDIENTE', 'PROCESAR')
AND d.PosicionDestino = @Posicion
AND m.Clave IN ('TMA.OADO', 'TMA.ORADO', 'TMA.OSUR'))
SELECT @Ok = 20938
END
ELSE
BEGIN
IF EXISTS(SELECT * FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo m ON t.Mov = m.Mov AND m.Modulo = 'TMA'
WHERE t.Estatus IN ('PENDIENTE', 'PROCESAR') 
AND d.Tarima = @Tarima
AND m.Clave NOT IN ('TMA.OADO', 'TMA.ORADO', 'TMA.SADO', 'TMA.SRADO', 'TMA.ADO', 'TMA.RADO'))
SELECT @Ok = 20938
END
END
IF @Ok IS NULL AND @Accion <> 'CANCELAR' AND @MovTipo NOT IN ('TMA.SURPER', 'TMA.SADO') 
BEGIN
IF EXISTS(SELECT * FROM ArtUnidad WHERE Articulo = @Articulo)
DECLARE crVerificaPesoUbicacion CURSOR FOR
SELECT SUM(u.Peso), SUM(u.Volumen), td.PosicionDestino, td.Almacen
FROM ArtDisponibleTarima adt
JOIN TMAD td ON adt.Almacen = td.Almacen AND adt.Tarima = td.Tarima
JOIN Art a ON adt.Articulo = a.Articulo
JOIN ArtUnidad u ON a.Articulo = u.Articulo AND a.Unidad = u.Unidad
WHERE adt.Empresa = @Empresa AND td.ID = @ID
GROUP BY td.PosicionDestino, td.Almacen
ELSE
DECLARE crVerificaPesoUbicacion CURSOR FOR
SELECT SUM(a.PesoTarima), SUM(a.VolumenTarima), td.PosicionDestino, td.Almacen
FROM ArtDisponibleTarima adt
JOIN TMAD td ON adt.Almacen = td.Almacen AND adt.Tarima = td.Tarima
JOIN Art a ON adt.Articulo = a.Articulo
WHERE adt.Empresa = @Empresa AND td.ID = @ID
GROUP BY td.PosicionDestino, td.Almacen
OPEN crVerificaPesoUbicacion
FETCH NEXT FROM crVerificaPesoUbicacion INTO @PesoMovimiento, @VolumenMovimiento, @PosicionDestinoArt, @AlmacenArt
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Tipo = Tipo,
@VolumenMaximoPosicion = Volumen,
@PesoMaximoPosicion = PesoMaximo
FROM AlmPos
WHERE Almacen = @AlmacenArt AND Posicion = @PosicionDestinoArt
IF @PesoMovimiento > @PesoMaximoPosicion AND @Tipo = 'Ubicacion'
SELECT @Ok = 20943, @OkRef= 'Posición: ' + @PosicionDestinoArt + '<BR><BR>' + 'Peso Movimiento: '+ CONVERT(varchar(20), CONVERT(numeric(12,2),@PesoMovimiento)) + '<BR><BR>' + 'Peso Máximo: '  + CONVERT(varchar(20), @PesoMaximoPosicion)
IF @Ok IS NULL AND @VolumenMovimiento > @VolumenMaximoPosicion AND @Tipo = 'Ubicacion'
SELECT @Ok = 20944, @OkRef= 'Posición: ' + @PosicionDestinoArt + '<BR><BR>' + 'Volumen Movimiento: '+ CONVERT(varchar(20), CONVERT(numeric(12,2), @VolumenMovimiento)) + '<BR><BR>' + 'Volumen Máximo: '  + CONVERT(varchar(20), @VolumenMaximoPosicion)
FETCH NEXT FROM crVerificaPesoUbicacion INTO @PesoMovimiento, @VolumenMovimiento, @PosicionDestinoArt, @AlmacenArt
END
CLOSE crVerificaPesoUbicacion
DEALLOCATE crVerificaPesoUbicacion
END
IF @Ok IS NULL AND @Accion <> 'CANCELAR'
BEGIN
IF @MovTipo NOT IN ('TMA.OSUR', 'TMA.SUR', 'TMA.PCKTARIMATRAN', 'TMA.PCKTARIMA') AND @SubClave NOT IN ('TMA.OSURP', 'TMA.SURP') 
BEGIN
SELECT @CantidadAfectar =  ISNULL(CantidadPicking,0) FROM TMAD WHERE ID = @ID AND Renglon = @Renglon
SELECT @CantidadPendiente = ISNULL((CantidadPendiente), CantidadPicking) FROM TMAD WHERE ID = (SELECT TOP 1 t.ID FROM TMA t JOIN TMAD d ON t.mov = d.Aplica AND t.MovID = D.AplicaID AND d.Tarima = @Tarima AND d.ID = @ID) AND Renglon = @Renglon
IF @MovTipo = 'TMA.SURPER'
SELECT @CantidadPendiente = ISNULL(ISNULL(CantidadPendiente,CantidadPicking), 0) FROM TMAD WHERE ID = (SELECT TOP 1 t.ID FROM TMA t JOIN TMAD d ON t.mov = d.Aplica AND t.MovID = D.AplicaID AND d.ID = @ID) AND Renglon = @Renglon
IF @SubClave IS NULL AND @CantidadPendiente = 1
SELECT @CantidadPendiente = Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Articulo = @Articulo
IF @CantidadAfectar > @CantidadPendiente SELECT @Ok = 20160
END
ELSE
IF @Tarima IS NULL AND @MovTipo IN ('TMA.SUR', 'TMA.PCKTARIMA') 
BEGIN
EXEC spConsecutivo 'Tarima', @Sucursal, @Tarima OUTPUT
EXEC spTarimaAlta @Empresa, @Sucursal, '', @Almacen, @FechaEmision, @FechaEmision, @Tarima, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Tarima IS NULL SELECT @Ok = 13130 ELSE
IF @Almacen IS NULL SELECT @Ok = 20390 ELSE
IF @Posicion IS NULL SELECT @Ok = 13050
IF @MovTipo IN ('TMA.SADO', 'TMA.OADO', 'TMA.ADO', 'TMA.RADO', 'TMA.SRADO', 'TMA.ORADO')
BEGIN
IF @Accion <> 'CANCELAR'
BEGIN
IF NULLIF(@PosicionDestino, '') IS NULL AND @MovTipo NOT IN ('TMA.SADO', 'TMA.OADO', 'TMA.ADO')
SELECT @Ok = 13055 ELSE
IF @Posicion = @PosicionDestino SELECT @Ok = 13035 ELSE
IF @MovTipo IN ('TMA.SADO', 'TMA.OADO', 'TMA.RADO', 'TMA.SRADO', 'TMA.ORADO')
BEGIN
IF EXISTS(SELECT *
FROM TMAD d
JOIN TMA e ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
JOIN MovTipo mt ON mt.Modulo = @Modulo AND mt.Mov = e.Mov AND mt.Clave = @MovTipo
WHERE d.Tarima = @Tarima AND d.EstaPendiente = 1)
SELECT @Ok = 13200
IF @Ok IS NULL
BEGIN
IF @MovTipo IN ('TMA.RADO')
IF dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, @PosicionDestino, @Articulo, @ID, 1) = 0 SELECT @Ok = 13220
IF @MovTipo NOT IN ('TMA.RADO', 'TMA.SADO') 
IF dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, @PosicionDestino, @Articulo, @ID, 1) = 0 SELECT @Ok = 13220 
IF @Ok = 13220 AND(SELECT Tipo FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionDestino) = 'Domicilio' AND @MovTipo IN('TMA.ADO', 'TMA.OADO', 'TMA.SADO') SELECT @Ok = NULL
IF @Ok = 13220 AND @PosicionDestino IS NULL AND @MovTipo IN('TMA.ADO', 'TMA.OADO', 'TMA.SADO') SELECT @Ok = NULL 
IF @Ok = 13220
BEGIN
SELECT @Ok = NULL
IF @MovTipo <> 'TMA.OADO'
EXEC spAlmPosTieneCapacidadWMS @Empresa, @Almacen, @PosicionDestino, @Articulo, @Tarima, @Renglon, @ID, 1, @Ok OUTPUT, @OkRef OUTPUT
END
END
END
ELSE
IF @MovTipo = 'TMA.ADO'
BEGIN
IF EXISTS(SELECT *
FROM TMAD d
JOIN TMA e ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
JOIN MovTipo mt ON mt.Modulo = @Modulo AND mt.Mov = e.Mov AND mt.Clave = 'TMA.OADO'
WHERE e.id = @ID AND d.Tarima = @Tarima AND d.EstaPendiente = 1 AND (d.Almacen <> @Almacen OR d.Posicion <> @Posicion OR d.PosicionDestino <> @PosicionDestino))
SELECT @Ok = 13210
SELECT @Articulo = Articulo FROM Tarima WHERE Tarima = @Tarima 
IF @Ok IS NULL AND @MovTipo <> 'TMA.RADO'
IF dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, @PosicionDestino, @Articulo, @ID, 1) = 0 SELECT @Ok = 13220
IF @Ok = 13220 AND (SELECT Tipo FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionDestino) = 'Domicilio' AND @MovTipo IN('TMA.ADO', 'TMA.OADO', 'TMA.SADO')
SELECT @Ok = NULL 
IF @Ok = 13220 AND @PosicionDestino IS NULL AND @MovTipo IN('TMA.ADO', 'TMA.OADO', 'TMA.SADO')
SELECT @Ok = NULL 
IF @Ok = 13220
BEGIN
SELECT @Ok = NULL
IF @MovTipo <> 'TMA.OADO'
EXEC spAlmPosTieneCapacidadWMS @Empresa, @Almacen, @PosicionDestino, @Articulo, @Tarima, @Renglon, @ID, 1, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @MovTipo = 'TMA.OADO' AND @Ok IS NOT NULL
SET @Ok = NULL
IF @Ok IS NULL AND (SELECT Tipo FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @Posicion)<>'Surtido' 
EXEC spTMAVerificarContenidoTarima @ID, @Empresa, @Tarima, @Almacen, @PosicionDestino, @Ok OUTPUT, @OkRef OUTPUT
END
ELSE
BEGIN
IF @MovTipo = 'TMA.ADO' AND @PosicionDestino <> @TarimaPosicion SELECT @Ok = 13190
IF @MovTipo IN ('TMA.SADO', 'TMA.OADO') AND @EstaPendiente = 0 SELECT @Ok = 13020
END
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Tarima
FETCH NEXT FROM crVerificarTMAD INTO @Tarima, @Almacen, @Posicion, @PosicionDestino, @EstaPendiente, @TarimaEstatus, @TarimaPosicion, @Renglon, @Articulo, @Montacarga 
END
CLOSE crVerificarTMAD
DEALLOCATE crVerificarTMAD
END
RETURN
END

