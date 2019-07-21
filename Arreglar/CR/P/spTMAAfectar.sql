SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAAfectar
@ID                	int,
@Accion				char(20),
@Base				char(20),
@Empresa	      		char(5),
@Modulo              char(5),
@Mov	  	      		char(20),
@MovID             	varchar(20)	OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      	datetime,
@FechaAfectacion     datetime,
@FechaConclusion		datetime,
@Proyecto	      	varchar(50),
@Usuario	      		char(10),
@Autorizacion      	char(10),
@DocFuente	      	int,
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      		int,
@MovUsuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@Generar				bit,
@GenerarMov			char(20),
@GenerarAfectado		bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Almacen				char(10),
@Agente				varchar(10),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@CancelarID			        int,
@FechaCancelacion	        datetime,
@GenerarMovTipo		        char(20),
@GenerarPeriodo		        int,
@GenerarEjercicio	        int,
@Tarima				        varchar(20),
@TarimaEstatus		        char(15),
@Posicion			        varchar(10),
@PosicionDestino	        varchar(10),
@AlmacenDetalle		        varchar(10),
@SubClave     		        varchar(20),
@WMSDispararReaco	        bit,
@TarimaSurtido		        varchar(20),
@Articulo			        varchar(20),
@MovOrigen			        varchar(20),
@MovIDOrigen		        varchar(20),
@IDOrigen			        int,
@OrigenTipo			        varchar(5),
@OrigenEstatus		        varchar(20),
@CantidadPicking	        float,
@TarimaPCK			        varchar(20),
@LEN				        int,
@TipoPos			        varchar(20),
@SucursalAlmacen	        int,
@Disponible			        float,
@Costo				        money,
@ArtMoneda			        char(10),
@Artipo				        varchar(50),
@Renglon			        int,
@TarimaM			        varchar(20),
@TarimaOrigen		        varchar(20) ,
@SerieLote			        varchar(50),
@RenglonID			        int,
@CantidadExistencia         float,
@Existencia			        float,
@CantidadSurtido	        float,
@CantidadTransito	        float,
@SubTarima			        varchar(20),
@Tipo                       varchar(20),
@CantidadUnidad		        float,
@Unidad				        varchar(50),
@SubCuenta                  varchar(50),
@ArticuloAux                varchar(20), 	
@SubCuentaAux               varchar(50),
@WMSDispararReacomodos	    bit,
@WMSReacomodoSurtido        bit,
@TarimaReacomodo	        varchar(20),
@OTarima			        varchar(20),	
@Es50				        bit,
@Es50TarimaDom		        varchar(20),
@Es50Cantidad		        float,
@PosicionDomicilio	        varchar(10),
@PosicionDestinoAux         varchar(10), 
@TipoPosc                   varchar(30),
@Sucursalc				    int,
@Almacenc                   varchar(10),
@Existe                     float,
@Movimiento			        char(20), 
@ModuloOrigen		        varchar(10),
@CantidadOrigenPendiente    float,	 
@IdO                        int,
@Disponible2		        float, 
@Cantidad                   float,
@CostoPromedio              float,
@TipoOrigen                 varchar(20),
@TotalSerie                 float,
@Necesito                   float,
@DisponibleA                float,
@Apartado                   float,
@CantidadA                  float,
@CantidadPendiente          float
DECLARE crArtInvs CURSOR FOR
SELECT Articulo, Renglon, CantidadA, CantidadPicking, CantidadPendiente, Tarima, Almacen
FROM TMAD
WHERE ID = @ID
GROUP BY Articulo, Renglon, CantidadA, CantidadPicking, CantidadPendiente, Tarima, Almacen
OPEN crArtInvs
FETCH NEXT FROM crArtInvs INTO @Articulo, @Renglon, @CantidadA, @CantidadPicking, @CantidadPendiente, @Tarima, @Almacen
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @DisponibleA = Disponible
FROM ArtDisponibleTarima
WHERE TARIMA   = @Tarima
AND Articulo = @Articulo
AND Empresa  = @Empresa
AND Almacen  = @Almacen
IF ISNULL(@CantidadA,0) > ISNULL(@DisponibleA,0)
BEGIN
SELECT @Ok = 20020, @OkRef = 'Artículo: ' + @Articulo
END
IF @MovTipo = 'TMA.OPCKTARIMA'
IF ISNULL(@CantidadA,0) > @CantidadPicking
BEGIN
SELECT @Ok = 20020, @OkRef = 'Artículo: ' + @Articulo
END
IF ISNULL(@CantidadA,0) < 0
BEGIN
SELECT @Ok = 20011, @OkRef = 'Artículo: ' + @Articulo
END
FETCH NEXT FROM crArtInvs INTO @Articulo, @Renglon, @CantidadA, @CantidadPicking, @CantidadPendiente, @Tarima, @Almacen
END
CLOSE crArtInvs
DEALLOCATE crArtInvs
IF (OBJECT_ID('Tempdb..#TarimaAux')) IS NOT NULL
DROP TABLE #TarimaAux
CREATE TABLE #TarimaAux (Tarima varchar(20) COLLATE Database_Default NOT NULL,  SubTarima varchar(20) COLLATE Database_Default NOT NULL, Cantidad float  NULL, CantidadA float  NULL, )
SELECT @SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo AND Clave = @MovTipo
SELECT @WMSDispararReacomodos = ISNULL(WMSDispararReacomodos,0), @WMSReacomodoSurtido = ISNULL(WMSReacomodoSurtido, 0) FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TarimaSurtido = TarimaSurtido, @Sucursalc = Sucursal, @Almacenc = Almacen FROM TMA WHERE ID = @ID
IF @MovTipo IN('TMA.SADO', 'TMA.SRADO', 'TMA.OADO', 'TMA.ORADO', 'TMA.OSUR', 'TMA.OPCKTarima')  AND @Estatus = 'SINAFECTAR' 
SET @EstatusNuevo = 'PENDIENTE'
ELSE
IF @MovTipo IN ('TMA.TSUR','TMA.PCKTarimaTran') AND @Estatus = 'SINAFECTAR' AND @SubClave <> 'TMA.TSURP' 
SET @EstatusNuevo = 'PENDIENTE'
ELSE
IF @MovTipo = 'TMA.TSUR' AND @Estatus = 'SINAFECTAR' AND @SubClave = 'TMA.TSURP' SET @EstatusNuevo = 'PROCESAR'
ELSE
IF @MovTipo IN('TMA.SADO', 'TMA.SRADO', 'TMA.OADO', 'TMA.ORADO', 'TMA.OSUR', 'TMA.TSUR', 'TMA.OPCKTarima', 'TMA.PCKTarimaTran') AND @Estatus = 'PENDIENTE' AND @Accion <> 'CANCELAR' 
BEGIN SET @EstatusNuevo = 'CONCLUIDO' END
ELSE
IF @MovTipo IN('TMA.SURPER') AND @Estatus = 'SINAFECTAR' AND @Accion <> 'CANCELAR' SET @EstatusNuevo = 'CONCLUIDO'
IF @MovTipo IN ('TMA.OSUR','TMA.TSUR','TMA.SRADO','TMA.ORADO','TMA.SADO','TMA.OADO', 'TMA.OPCKTarima', 'TMA.PCKTarimaTran') AND @Estatus <> 'CANCELAR' AND @Accion = 'GENERAR' AND @Base = 'Seleccion'  
UPDATE TMAD SET EstaPendiente = 1 WHERE ID = @ID AND ISNULL(CantidadA,0) > 0 AND ISNULL(Procesado,0) = 0
IF @MovTipo IN ('TMA.OSUR','TMA.TSUR','TMA.SRADO','TMA.ORADO','TMA.SADO','TMA.OADO', 'TMA.OPCKTarima', 'TMA.PCKTarimaTran') AND @Estatus <> 'CANCELAR' AND @Accion = 'GENERAR' AND @Base = 'Pendiente'  
UPDATE TMAD SET EstaPendiente = 1 WHERE ID = @ID AND ISNULL(Procesado,0) = 0
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion  SELECT @Ok = 80060, @OkRef = @MovID  RETURN END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR', NULL, NULL, @Mov, @MovID, 0, @GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Base = 'PENDIENTE'
DECLARE crSubTarima CURSOR LOCAL FOR SELECT Renglon, Tarima, PosicionDestino FROM TMAD d WHERE ID = @ID AND EstaPendiente = 1
ELSE
DECLARE crSubTarima CURSOR LOCAL FOR SELECT Renglon, Tarima, PosicionDestino FROM TMAD WHERE ID = @ID AND ISNULL(CantidadA,0) > 0
OPEN crSubTarima
FETCH NEXT FROM crSubTarima INTO @Renglon, @Tarima, @PosicionDestinoAux 
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SubTarima = CASE WHEN @GenerarMovTipo <> 'TMA.SURPER' THEN dbo.fnRegresaSubTarima(@Tarima, @MovTipo) ELSE @Tarima END
IF @MovTipo NOT IN ('TMA.SRADO', 'TMA.ORADO', 'TMA.RADO')
BEGIN
IF NOT EXISTS(SELECT * FROM #TarimaAux WHERE Tarima = @Tarima)
INSERT #TarimaAux SELECT @Tarima, @SubTarima, NULL, NULL 
ELSE
BEGIN
SET @Len = LEN(@SubTarima)
SELECT @SubTarima = SUBSTRING(@SubTarima, 1, CHARINDEX('-',@SubTarima)) + CONVERT(varchar(10),SUBSTRING(@SubTarima, @Len, @Len - CHARINDEX('-',@SubTarima)) + 1)
UPDATE #TarimaAux SET SubTarima = @SubTarima WHERE Tarima = @Tarima
END
END
IF @Base = 'PENDIENTE'
BEGIN
IF @PosicionDestinoAux IS NOT NULL 
BEGIN
INSERT TMAD (ID,         Renglon,   Tarima,     Almacen,   Posicion,   PosicionDestino,   EstaPendiente,   Sucursal,   SucursalOrigen,   Zona,   CantidadPicking,                                                                            CantidadA, Aplica, AplicaID, AplicaRenglon, Prioridad,   Montacarga,   Procesado, Unidad,   CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave) 
SELECT       @IDGenerar, d.Renglon, @SubTarima, d.Almacen, d.Posicion, d.PosicionDestino, d.EstaPendiente, d.Sucursal, d.SucursalOrigen, d.Zona, dbo.fnTMACantidadGenerar(@Empresa, @ID, Renglon, @Mov, @MovID, @Base, @MovTipo, @SubClave), 0,         @Mov,   @MovID,   d.Renglon,     d.Prioridad, d.Montacarga, 0,         d.Unidad, d.CantidadUnidad, d.Articulo, d.SubCuenta, d.FechaCaducidad, d.ArtCambioClave  
FROM TMAD d
WHERE ID = @ID AND EstaPendiente = 1 AND d.Renglon = @Renglon
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDGenerar)
EXEC spMovCopiarSerielote @Sucursal, @Modulo, @ID, @IDGenerar 
END
IF @PosicionDestinoAux IS NULL AND @MovTipo<>'TMA.SADO' 
BEGIN
INSERT TMAD (ID,         Renglon,   Tarima,     Almacen,   Posicion,   PosicionDestino,   EstaPendiente,   Sucursal,   SucursalOrigen,   Zona,   CantidadPicking,                                                                            CantidadA, Aplica, AplicaID, AplicaRenglon, Prioridad,   Montacarga,   Procesado, Unidad,   CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave ) 
SELECT       @IDGenerar, d.Renglon, @SubTarima, d.Almacen, d.Posicion, d.PosicionDestino, d.EstaPendiente, d.Sucursal, d.SucursalOrigen, d.Zona, dbo.fnTMACantidadGenerar(@Empresa, @ID, Renglon, @Mov, @MovID, @Base, @MovTipo, @SubClave), 0,         @Mov,   @MovID,   d.Renglon,     d.Prioridad, d.Montacarga, 0,         d.Unidad, d.CantidadUnidad, d.Articulo, d.SubCuenta, d.FechaCaducidad, d.ArtCambioClave  
FROM TMAD d WHERE ID = @ID AND EstaPendiente = 1 AND d.Renglon = @Renglon
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDGenerar)
EXEC spMovCopiarSerielote @Sucursal, @Modulo, @ID, @IDGenerar  
END
DELETE TMAD WHERE ID = @IDGenerar AND CantidadPicking = 0 AND Renglon = @Renglon
UPDATE TMAD SET CantidadA = 0 WHERE ID = @ID AND EstaPendiente = 1 AND Renglon = @Renglon
END ELSE
BEGIN
IF @PosicionDestinoAux IS NOT NULL 
BEGIN
INSERT TMAD (Sucursal,  ID,         Renglon, Tarima,	    Almacen, Posicion, PosicionDestino, Zona, CantidadPicking,                                                                      Procesado, Aplica, AplicaID, AplicaRenglon, AplicaRenglonID, Prioridad, Montacarga, EstaPendiente, Unidad, CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave ) 
SELECT       @Sucursal, @IDGenerar, Renglon, @SubTarima, Almacen, Posicion, PosicionDestino, Zona, dbo.fnTMACantidadGenerar(@Empresa, @ID, Renglon, '', '', @Base, @MovTipo, @SubClave), 0,         @Mov,   @MovID,   Renglon,       1,			   Prioridad, Montacarga, 1,             Unidad, NULL, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave  
FROM TMAD  WHERE ID = @ID AND ISNULL(CantidadA,0) > 0 AND Renglon = @Renglon
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDGenerar)
EXEC spMovCopiarSerielote @Sucursal, @Modulo, @ID, @IDGenerar
END
IF @PosicionDestinoAux IS NULL AND @MovTipo<>'TMA.SADO' 
BEGIN
INSERT TMAD (Sucursal,  ID,         Renglon, Tarima,	    Almacen, Posicion, PosicionDestino, Zona, CantidadPicking,                                                                      Procesado, Aplica, AplicaID, AplicaRenglon, AplicaRenglonID, Prioridad, Montacarga, EstaPendiente, Unidad, CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave ) 
SELECT       @Sucursal, @IDGenerar, Renglon, @SubTarima, Almacen, Posicion, PosicionDestino, Zona, dbo.fnTMACantidadGenerar(@Empresa, @ID, Renglon, '', '', @Base, @MovTipo, @SubClave), 0,         @Mov,   @MovID,   Renglon,       1,			   Prioridad, Montacarga, 1,             Unidad, NULL, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave 
FROM TMAD WHERE ID = @ID AND ISNULL(CantidadA,0) > 0 AND Renglon = @Renglon
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Modulo = @Modulo AND ID = @IDGenerar)
EXEC spMovCopiarSerielote @Sucursal, @Modulo, @ID, @IDGenerar
END
IF @MovTipo IN('TMA.ORADO','TMA.SRADO')
UPDATE TMAD SET Procesado = 1, CantidadA = 0 WHERE ID = @ID AND ISNULL(CantidadA,0) = (CASE @Base WHEN 'PENDIENTE' THEN ISNULL(CantidadA,0) ELSE 1 END) AND ISNULL(Procesado,0) = 0
END
FETCH NEXT FROM crSubTarima INTO @Renglon, @Tarima, @PosicionDestinoAux 
END
CLOSE crSubTarima
DEALLOCATE crSubTarima
DECLARE crTarimaAlta CURSOR LOCAL FOR
SELECT Tarima, Almacen, Posicion, Articulo, SubCuenta 
FROM TMAD WHERE ID = @IDGenerar AND @GenerarMovTipo = 'TMA.SURPER'
OPEN crTarimaAlta
FETCH NEXT FROM crTarimaAlta INTO @Tarima, @Almacen, @Posicion, @ArticuloAux, @SubCuentaAux 
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Tarima IS NOT NULL AND NOT EXISTS(SELECT * FROM Tarima WHERE Tarima = @Tarima) AND NOT EXISTS(SELECT * FROM SaldoUWMS WHERE SubGrupo = @Tarima) 
BEGIN
INSERT Tarima (Tarima,   Almacen,   Posicion,   Estatus, Alta,            Articulo, SubCuenta) 
VALUES (       @Tarima, @Almacen, @Posicion, 'ALTA',  @FechaRegistro, @ArticuloAux, @SubCuentaAux)  
INSERT SaldoUWMS (Sucursal,  Empresa,  Rama,  Moneda, Grupo,     SubGrupo, Cuenta,     SubCuenta, Saldo, SaldoU, PorConciliar, PorConciliarU, UltimoCambio) 
VALUES (       @Sucursal, @Empresa, 'INV',     '',   @Almacen,   @Tarima, @ArticuloAux, @SubCuentaAux,	      0,	  0,      0,            0,       @FechaRegistro) 
END
FETCH NEXT FROM crTarimaAlta INTO @Tarima, @Almacen, @Posicion, @ArticuloAux, @SubCuentaAux 
END
CLOSE crTarimaAlta
DEALLOCATE crTarimaAlta
IF @Ok IS NULL SELECT @Ok = 80030
IF @MovTipo IN ('TMA.TSUR', 'TMA.ORADO', 'TMA.OADO', 'TMA.PCKTarimaTran') AND @Ok BETWEEN 80000 AND 81000 
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
SELECT @FechaConclusion  = @FechaEmision
IF @MovTipo<>'TMA.OADO' AND (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0 
AND NOT EXISTS (SELECT * FROM TMAD WHERE ID = @IDOrigen AND ISNULL(CantidadPendiente, 0) > 0)  
UPDATE TMA SET FechaConclusion  = @FechaConclusion, FechaCancelacion = @FechaCancelacion, UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN GETDATE() ELSE UltimoCambio END, Estatus          = @EstatusNuevo, Situacion 		  = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END WHERE ID = @IDOrigen
ELSE
IF @MovTipo='TMA.OADO' AND (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0 AND EstaPendiente = 1) = 0 
UPDATE TMA SET FechaConclusion  = @FechaConclusion, FechaCancelacion = @FechaCancelacion, UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN GETDATE() ELSE UltimoCambio END, Estatus          = @EstatusNuevo, Situacion 		  = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END WHERE ID = @IDOrigen
END
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
IF (SELECT COUNT(0) FROM TMA WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')) > 0
BEGIN
SELECT @CancelarID = ID FROM TMA WHERE OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
EXEC spAfectar @Modulo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF (SELECT COUNT(0) FROM TMA WHERE ISNULL(OrigenTipo, @Modulo) <> @Modulo AND Estatus IN ('PENDIENTE', 'CONCLUIDO') AND ID = @ID) > 0
BEGIN
SELECT @OrigenTipo = OrigenTipo, @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID
IF @OrigenTipo = 'INV'
BEGIN
SELECT @CancelarID = ID, @OrigenEstatus = Estatus FROM Inv WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
IF @OrigenEstatus <> 'CANCELADO'
EXEC spAfectar @OrigenTipo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision, NULL, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones, @Generar, @GenerarMov, @GenerarMovID, @IDGenerar, @Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
DECLARE crAfectarTMAD CURSOR LOCAL FOR
SELECT NULLIF(RTRIM(d.Tarima), ''), NULLIF(RTRIM(d.Almacen), ''), NULLIF(RTRIM(d.Posicion), ''), NULLIF(RTRIM(d.PosicionDestino), ''), t.Estatus, ISNULL(CantidadPicking,0), NULLIF(RTRIM(d.TarimaPCK), ''), 
CantidadUnidad, d.Unidad, d.Articulo, d.SubCuenta, ISNULL(Es50, 0), Es50TarimaDom, ISNULL(Es50Cantidad, 0)
FROM TMAD d LEFT OUTER JOIN Tarima t ON t.Tarima = d.Tarima WHERE d.ID = @ID
OPEN crAfectarTMAD
FETCH NEXT FROM crAfectarTMAD INTO @Tarima, @AlmacenDetalle, @Posicion, @PosicionDestino, @TarimaEstatus, @CantidadPicking, @TarimaPCK, @CantidadUnidad, @Unidad, @ArticuloAux, @SubCuentaAux, @Es50, @Es50TarimaDom, @Es50Cantidad 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
IF @ArticuloAux IS NOT NULL IF @SubCuentaAux IS NULL
EXEC spTMAArtDomicilioInicializar @Empresa, @AlmacenDetalle, @ArticuloAux, '' 
END
IF @Accion = 'AFECTAR' AND @Movtipo IN('TMA.SADO', 'TMA.OADO', 'TMA.ADO')
BEGIN
IF(SELECT Tipo FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionDestino) = 'Domicilio'
BEGIN
UPDATE TMAD SET Es50 = 1 WHERE CURRENT OF crAfectarTMAD
IF @Movtipo  = 'TMA.ADO' SELECT @Es50 = 1
END
END
IF @MovTipo = 'TMA.ORENT'
EXEC spTMAReEntarimar @ID, @Mov, @MovID, @Usuario, @Accion, @Empresa, @Sucursal, @Tarima, @AlmacenDetalle, @Posicion, @PosicionDestino, @CantidadUnidad, @Unidad, @CantidadPicking, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'TMA.OADO'
EXEC spTMAAplicar @ID, @Accion, @Empresa, @Tarima, @AlmacenDetalle, @Posicion, @PosicionDestino, 'TMA.SADO', @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'TMA.ADO'
BEGIN
EXEC spTMAAplicar @ID, @Accion, @Empresa, @Tarima, @AlmacenDetalle, @Posicion, @PosicionDestino, 'TMA.OADO', @Ok OUTPUT, @OkRef OUTPUT
IF @Es50 = 0 EXEC spTMAAcomodar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @FechaEmision, @FechaRegistro, @Tarima, @AlmacenDetalle, @Posicion, @PosicionDestino, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo = 'TMA.ORADO' AND @EstatusNuevo = 'PENDIENTE'
BEGIN
SELECT @Tarima = dbo.fnTMATarimaOriginal(@Tarima)
IF @Base = 'Seleccion'
UPDATE TMAD SET CantidadA = 0, Procesado = 1 WHERE ID = @IDOrigen AND Tarima = @Tarima AND CantidadA > 0     
IF @Base IN ('Pendiente','TODO')
UPDATE TMAD SET CantidadA = 0, Procesado = 1 WHERE ID = @IDOrigen AND Tarima = @Tarima AND EstaPendiente > 0 
END
IF @Es50 = 1 AND @Accion ='AFECTAR' AND @MovTipo = 'TMA.SADO'
BEGIN
SELECT @PosicionDomicilio = NULL
SELECT @PosicionDomicilio = Posicion FROM AlmPos WHERE Almacen = @Almacen AND ArticuloEsp = @ArticuloAux AND Tipo = 'Domicilio' 
UPDATE TMAD SET PosicionDestino = @PosicionDomicilio WHERE CURRENT OF crAfectarTMAD
END
IF @MovTipo IN ('TMA.SUR','TMA.RADO','TMA.ADO', 'TMA.PCKTarima') AND @EstatusNuevo = 'CONCLUIDO' OR @MovTipo IN ('TMA.TSUR','TMA.PCKTarimaTran') AND @EstatusNuevo = 'PENDIENTE'  
BEGIN
IF @MovTipo NOT IN ('TMA.PCKTarima') SELECT @Tarima = dbo.fnTMATarimaOriginal(@Tarima) 
UPDATE TMAD SET CantidadA = 0, Procesado = 1 WHERE ID = @IDOrigen AND Tarima = @Tarima
IF @MovTipo = 'TMA.ADO' AND @Es50 = 1
BEGIN
SELECT @ArtMoneda = MonedaCosto FROM Art WHERE Articulo = @ArticuloAux 
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @AlmacenDetalle
SELECT @Disponible = Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Empresa = @Empresa AND Almacen = @AlmacenDetalle
SELECT @Costo = ISNULL(CostoPromedio,0.0) * ISNULL(@Disponible,0) FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
IF  @Accion = 'AFECTAR'
BEGIN
SELECT @TarimaSurtido = NULL
SELECT @TarimaSurtido = MIN(t.Tarima)
FROM ArtDisponibleTarima a
JOIN Tarima t ON t.Tarima = a.Tarima
JOIN AlmPos p ON p.Posicion = t.Posicion AND p.Almacen = @AlmacenDetalle
WHERE a.Articulo =  @ArticuloAux 
AND p.ArticuloEsp =  @ArticuloAux 
AND t.SubCuenta = @SubCuentaAux 
AND p.Tipo = 'Domicilio'
AND t.Estatus = 'ALTA'
AND t.Tarima NOT LIKE '%-%'
IF @TarimaSurtido IS NULL
SELECT @TarimaSurtido = MIN(t.Tarima)
FROM Tarima t
JOIN AlmPos p ON p.Posicion = t.Posicion  AND p.Almacen = @AlmacenDetalle
WHERE t.Articulo =  @ArticuloAux 
AND p.ArticuloEsp =  @ArticuloAux 
AND t.SubCuenta = @SubCuentaAux 
AND p.Tipo = 'Domicilio'
AND t.Estatus = 'ALTA'
AND t.Tarima NOT LIKE '%-%'
IF @TarimaSurtido IS NULL
SELECT @TarimaSurtido = MIN(t.Tarima)
FROM ArtDisponibleTarima a JOIN Tarima t ON t.Tarima = a.Tarima JOIN AlmPos p ON p.Posicion = t.Posicion  AND p.Almacen = @AlmacenDetalle
WHERE a.Articulo =  @ArticuloAux AND p.ArticuloEsp =  @ArticuloAux AND t.SubCuenta = @SubCuentaAux AND p.Tipo = 'Domicilio' AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'
IF @TarimaSurtido IS NULL
SELECT @TarimaSurtido = MIN(t.Tarima)
FROM ArtDisponibleTarima a JOIN Tarima t ON t.Tarima = a.Tarima JOIN AlmPos p ON p.Posicion = t.Posicion  AND p.Almacen = @AlmacenDetalle
WHERE a.Articulo =  @ArticuloAux AND p.ArticuloEsp =  @ArticuloAux AND t.SubCuenta = @SubCuentaAux AND p.Tipo = 'Domicilio' AND t.Estatus = 'BAJA' AND t.Tarima NOT LIKE '%-%'
IF @TarimaSurtido IS NULL BEGIN SELECT @Ok = 13016, @OkRef = @Articulo END
UPDATE TMAD SET Es50TarimaDom = @TarimaSurtido, Es50Cantidad = @Disponible WHERE CURRENT OF crAfectarTMAD
SELECT @Costo = Saldo
FROM SaldoUWMS 
WHERE Cuenta = @ArticuloAux AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,ISNULL(SubCuenta,'')) AND Grupo = @Almacen AND SubGrupo = @Tarima
IF @Ok IS NULL AND @Tarima IS NOT NULL AND @TarimaSurtido IS NOT NULL
BEGIN
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1,  @ArticuloAux, @SubCuentaAux, @AlmacenDetalle,NULL, @Modulo, @ID, @Mov, @MovID, 0, 0, @Disponible, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @Tarima
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1,  @ArticuloAux, @SubCuentaAux, @AlmacenDetalle, NULL, @Modulo, @ID, @Mov, @MovID, 1, 0, @Disponible, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @TarimaSurtido
EXEC spMoverSeriesLotesWMS @Accion, @Tarima, @TarimaSurtido, @Disponible, @Ok OUTPUT, @OkRef OUTPUT
END
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @ArticuloAux AND a.Empresa=@Empresa) <= 0
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro, Alta = NULL WHERE Tarima = @Tarima
SELECT @TipoPosc = Tipo FROM AlmPos WHERE Posicion = @PosicionDestino
IF (SELECT Estatus FROM Tarima	WHERE Tarima = @TarimaSurtido) <> 'ALTA'
UPDATE Tarima SET Estatus = 'ALTA', Baja = NULL, Alta = @FechaRegistro WHERE Tarima = @TarimaSurtido
END
END
SELECT @TipoPos = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
IF (SELECT Estatus FROM Tarima WHERE Tarima = @Tarima) <> 'ALTA' AND @Es50 = 0 
UPDATE Tarima SET Estatus = 'ALTA', Baja = NULL, Alta = @FechaRegistro WHERE Tarima = @Tarima
IF @MovTipo NOT IN('TMA.RADO', 'TMA.TSUR', 'TMA.PCKTarimaTran', 'TMA.PCKTARIMA')  AND @Es50 = 0  AND @TipoPos <> 'Cross Docking'
UPDATE Tarima SET Posicion = @PosicionDestino, Alta = GETDATE() WHERE Tarima = @Tarima AND Posicion = @Posicion
IF @MovTipo IN ('TMA.SUR') AND @SubClave IS NULL AND @Es50 = 0  AND @TipoPos <> 'Cross Docking' 
UPDATE Tarima SET Posicion = @PosicionDestino, Alta = GETDATE() WHERE Tarima = @Tarima
END
IF @MovTipo IN ('TMA.SADO', 'TMA.OADO')
UPDATE TMAD SET EstaPendiente = 1 WHERE CURRENT OF crAfectarTMAD
END
IF @MovTipo IN('TMA.OADO', 'TMA.TSUR', 'TMA.PCKTarimaTran') AND @EstatusNuevo <> 'SINAFECTAR'  
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
IF @MovTipo NOT IN ('TMA.TSUR', 'TMA.PCKTarimaTran') 
BEGIN
IF CHARINDEX('-',@Tarima) = 0 UPDATE TMAD SET CantidadA = 0, Procesado = 1 WHERE ID = @IDOrigen AND Tarima = @Tarima
ELSE
UPDATE TMAD SET CantidadA = 0, Procesado = 1 WHERE ID = @IDOrigen AND Tarima = SUBSTRING(@Tarima, 1, CHARINDEX('-', @Tarima)-1)
IF (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0 UPDATE TMA SET Estatus = 'CONCLUIDO' WHERE ID = @IDOrigen
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'TMA', @IDOrigen, @MovOrigen, @MovIDOrigen, 'TMA', @ID, @Mov, @MovID, @Ok OUTPUT
END
ELSE  BEGIN
IF CHARINDEX('-',@Tarima) = 0
BEGIN
UPDATE TMAD SET  CantidadA = 0, CantidadPendiente = ISNULL(CantidadPendiente, CantidadPicking) - CantidadA WHERE ID = @IDOrigen AND Tarima = @Tarima
UPDATE TMAD SET  Procesado = 1 WHERE ID = @IDOrigen AND Tarima = @Tarima 
END
ELSE  BEGIN
IF @MovTipo IN ('TMA.TSUR','TMA.PCKTarimaTran') AND @SubClave <> 'TMA.TSURP' OR @MovTipo <> 'TMA.TSUR'   
BEGIN
UPDATE TMAD SET  CantidadA = 0, CantidadPendiente = ISNULL(CantidadPendiente, CantidadPicking) - CantidadA WHERE ID = @IDOrigen AND Tarima = SUBSTRING(@Tarima, 1, CHARINDEX('-', @Tarima)-1)
UPDATE TMAD SET  Procesado = 1 WHERE ID = @IDOrigen AND Tarima = SUBSTRING(@Tarima, 1, CHARINDEX('-', @Tarima)-1)
END
END
IF (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0 AND @MovTipo NOT IN ('TMA.TSUR', 'TMA.PCKTarimaTran') OR (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0 AND @MovTipo IN ('TMA.TSUR', 'TMA.PCKTarimaTran') AND @SubClave <> 'TMA.TSURP'  
UPDATE A SET A.CantidadPendiente = A.CantidadPendiente + B.CantidadPendiente
FROM TMAD A
JOIN TMAD B ON A.ID = @IDOrigen AND A.Renglon = B.Renglon  AND A.Tarima = B.Tarima AND A.Almacen = B.Almacen AND A.Posicion = B.Posicion AND A.PosicionDestino = B.PosicionDestino AND B.ID = @ID
UPDATE TMA SET Estatus = 'PENDIENTE' WHERE ID = @IDOrigen  
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'TMA', @IDOrigen, @MovOrigen, @MovIDOrigen, 'TMA', @ID, @Mov, @MovID, @Ok OUTPUT
END
END
IF @MovTipo = 'TMA.RADO' AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
SET @Disponible=NULL 
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @TarimaSurtido = TarimaSurtido FROM TMA WHERE ID = @ID
SELECT @Disponible = Disponible FROM ArtDisponibleTarima WHERE Tarima = @TarimaSurtido AND Almacen = @Almacen
SELECT @Articulo = @ArticuloAux
SELECT @Costo = ISNULL(CostoPromedio,0.0) * ISNULL(@CantidadPicking,0) FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
SELECT @CantidadPicking = @CantidadPicking + @Disponible - (SELECT Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Articulo = @Articulo)
SELECT @ArtMoneda = MonedaCosto FROM Art WHERE Articulo = @Articulo
SELECT @TipoPos = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @PosicionDestino AND Almacen = @Almacen 
IF @TarimaSurtido IS NULL AND @TipoPos = 'Domicilio'
BEGIN
SELECT @TarimaSurtido = MIN(t.Tarima) FROM Tarima t JOIN AlmPos p ON p.Posicion = t.Posicion AND p.Almacen = @Almacen LEFT JOIN ArtDisponibleTarima a ON t.Tarima = a.Tarima WHERE p.ArticuloEsp = @Articulo AND p.Tipo = 'Domicilio' AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'  
SELECT @Disponible = Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Articulo=@Articulo AND Empresa=@Empresa
SELECT @CantidadPicking = (SELECT SUM(Disponible) FROM ArtDisponibleTarima WHERE Tarima = @TarimaSurtido AND Empresa=@Empresa AND Almacen = @Almacen) 
END
ELSE
IF @TarimaSurtido IS NULL AND @TipoPos = 'Ubicacion'
BEGIN
SELECT @TarimaSurtido = t.Tarima FROM ArtDisponibleTarima a JOIN Tarima t ON t.Tarima = a.Tarima JOIN AlmPos p ON p.Posicion = t.Posicion AND p.Almacen = @Almacen WHERE a.Articulo = @Articulo AND p.Tipo = 'Ubicacion' AND a.Disponible > 0 AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%' AND t.Posicion = @PosicionDestino
SELECT @Disponible = Disponible FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Articulo=@Articulo AND Empresa=@Empresa 
SELECT @CantidadPicking = (SELECT SUM(Disponible) FROM ArtDisponibleTarima WHERE Tarima = @TarimaSurtido AND Empresa=@Empresa AND Almacen = @Almacen) 
END
SELECT @Artipo = Tipo FROM Art WHERE Articulo = @Articulo
/* Es importante que no se actualice la Tabla Tarima si la posición Origen es de Surtido y solo se tiene actualizarse si la posición destino es Ubicación */
SELECT @TipoOrigen = RTRIM(LTRIM(Tipo)) FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
IF @TipoOrigen <> 'Surtido'
IF @TipoPos = 'Ubicacion'
UPDATE Tarima SET Posicion = @PosicionDestino WHERE Posicion = @Posicion AND Almacen = @Almacen AND Tarima = @Tarima
/* Es importante que no se actualice la Tabla Tarima si la posición Origen es de Surtido y solo se tiene actualizarse si la posición destino es Ubicación */
IF @Artipo <> 'SERIE' AND @TipoPos = 'Domicilio'
BEGIN
SELECT @Costo = Saldo FROM SaldoUWMS  WHERE Cuenta = @ArticuloAux AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,ISNULL(SubCuenta,'')) AND SubGrupo = @Tarima
IF @Tarima IS NOT NULL AND @TarimaSurtido IS NOT NULL
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @Articulo, @SubCuenta, @Almacen, NULL, @Modulo, @ID, @Mov, @MovID, 0, 0, @Disponible, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @Tarima
IF @Tarima IS NOT NULL AND @TarimaSurtido IS NOT NULL
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @Articulo, @SubCuenta, @Almacen, NULL, @Modulo, @ID, @Mov, @MovID, 1, 0, @Disponible, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @TarimaSurtido
SELECT @TipoPosc = Tipo FROM AlmPos WHERE Posicion = @PosicionDestino
IF @TipoPosc = 'Domicilio' AND @MovTipo = 'TMA.RADO'
BEGIN
IF EXISTS (SELECT * FROM SerieLote WHERE tarima = @TarimaSurtido AND Articulo = @ArticuloAux AND Almacen = @Almacenc AND empresa = @Empresa AND Sucursal = @Sucursalc) 
BEGIN
DECLARE crAfectaSerieLote CURSOR LOCAL STATIC FOR
SELECT s.SerieLote, b.Disponible
FROM SerieLote s JOIN WMSEstatusTarima b ON s.SerieLote=b.SerieLote AND s.Articulo=b.Articulo AND s.Almacen=b.Almacen AND s.Empresa=b.Empresa AND s.Tarima=b.Tarima
WHERE b.SerieLote IS NOT NULL AND s.Tarima=@Tarima AND s.Empresa=@Empresa AND s.Articulo=@Articulo
OPEN crAfectaSerieLote
FETCH NEXT FROM crAfectaSerieLote INTO @SerieLote, @Disponible2
WHILE @@FETCH_STATUS=0
BEGIN
IF EXISTS(SELECT SerieLote FROM SerieLote WHERE Empresa=@Empresa AND Articulo=@Articulo AND Almacen=@Almacen AND Tarima=@TarimaSurtido AND SerieLote=@SerieLote)
BEGIN
UPDATE SerieLote SET Existencia=ISNULL(Existencia,0)+@Disponible2 WHERE Empresa=@Empresa AND Articulo=@Articulo AND Almacen=@Almacen AND Tarima=@TarimaSurtido AND SerieLote=@SerieLote
UPDATE SerieLote SET Existencia=ISNULL(Existencia,0)-@Disponible2 WHERE Empresa=@Empresa AND Articulo=@Articulo AND Almacen=@Almacen AND Tarima=@Tarima AND SerieLote=@SerieLote
END
ELSE
BEGIN
UPDATE SerieLote SET Tarima=@TarimaSurtido WHERE Empresa=@Empresa AND Articulo=@Articulo AND Almacen=@Almacen AND Tarima=@Tarima AND SerieLote=@SerieLote
END
FETCH NEXT FROM crAfectaSerieLote INTO @SerieLote, @Disponible2
END CLOSE crAfectaSerieLote DEALLOCATE crAfectaSerieLote
END
END
IF @TipoOrigen='Surtido'
BEGIN
IF (SELECT SUM(ISNULL(a.Disponible,0)) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Tarima = @Tarima AND t.Estatus = 'ALTA' /*AND a.Articulo = @Articulo */AND a.Empresa=@Empresa AND a.Almacen = @Almacen) <= 0  
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
END
ELSE
BEGIN
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Empresa=@Empresa AND a.Almacen = @Almacen) <= 0  
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
END
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Tarima = @TarimaSurtido AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Empresa=@Empresa AND a.Almacen = @Almacen) <= 0  
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @TarimaSurtido
/*
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Empresa=@Empresa AND a.Almacen = @Almacen) <= 0  
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Tarima = @TarimaSurtido AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Empresa=@Empresa AND a.Almacen = @Almacen) <= 0  
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @TarimaSurtido
*/
END
IF @Artipo IN ('LOTE') AND @Tarima IS NOT NULL AND @TarimaSurtido IS NOT NULL AND @TipoPos = 'Domicilio' AND @Tarima <> @TarimaSurtido AND @MovTipo <> 'TMA.RADO'
BEGIN
IF EXISTS (SELECT * FROM SerieLote WHERE Tarima = @TarimaSurtido) AND @Tarima IS NOT NULL AND @TarimaSurtido IS NOT NULL
BEGIN
IF (SELECT ISNULL(SerieLote,'') FROM SerieLote WHERE Tarima = @Tarima) IN (SELECT TOP 1 ISNULL(SerieLote,'') FROM SerieLote WHERE Tarima = @TarimaSurtido)
UPDATE SerieLote  SET Existencia = ISNULL(Existencia,0) + (SELECT ISNULL(Existencia,0) FROM SerieLote WHERE Tarima = @Tarima AND Articulo = @Articulo AND Almacen = @Almacen AND Empresa = @Empresa) 
WHERE Tarima = @TarimaSurtido AND Articulo = @Articulo AND Almacen = @Almacen  AND Empresa = @Empresa AND Sucursal = @Sucursal
ELSE
INSERT SerieLote (Sucursal, Empresa, Articulo, SubCuenta, SerieLote,                                                                 Almacen, Tarima,         Propiedades, Cliente, Localizacion, ExistenciaActivoFijo, UltimaEntrada, UltimaSalida, Existencia, CostoPromedio)
SELECT TOP 1      Sucursal, Empresa, Articulo, SubCuenta, (SELECT TOP 1 ISNULL(SerieLote,'') FROM SerieLote WHERE Tarima = @Tarima), Almacen, @TarimaSurtido, Propiedades, Cliente, Localizacion, ExistenciaActivoFijo, GETDATE(),     NULL,         @Disponible, CostoPromedio
FROM SerieLote WHERE Tarima = @TarimaSurtido AND Articulo = @Articulo AND SerieLote = (SELECT TOP 1 ISNULL(SerieLote,'') FROM SerieLote WHERE Tarima = @TarimaSurtido) AND Almacen = @Almacen AND Empresa = @Empresa AND Sucursal = @Sucursal
UPDATE SerieLote SET Existencia = 0 WHERE Tarima = @Tarima AND Articulo = @Articulo AND Almacen = @Almacen AND Empresa = @Empresa AND Sucursal = @Sucursal
END
ELSE
UPDATE SerieLote SET Tarima = @TarimaSurtido WHERE Tarima = @Tarima AND Articulo = @Articulo AND Almacen = @Almacen AND Empresa = @Empresa AND Sucursal = @Sucursal
END
IF @Ok IS NULL EXEC spTMAAfectarPosicion @ID, @Accion, @Base, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @Usuario, @Estatus, @EstatusNuevo, @Almacen, @Agente, @Tarima, @Posicion, @PosicionDestino, @Articulo, @Ok OUTPUT, @OkRef OUTPUT
END
SELECT @TipoPos = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
IF @MovTipo IN ('TMA.SUR','TMA.PCKTarima') AND @EstatusNuevo = 'CONCLUIDO' AND @TipoPos IN ('Ubicacion', 'Cross Docking')
BEGIN
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @TarimaM = dbo.fnTMATarimaOriginal(@Tarima)
SELECT @TarimaOrigen = d.Tarima, @TarimaSurtido = t.TarimaSurtido
FROM TMA o JOIN TMA t ON o.Mov = t.Origen AND o.MovID = t.OrigenID JOIN TMAD d ON o.ID = d.ID WHERE t.ID = @ID AND d.Posicion= @Posicion AND d.PosicionDestino = @PosicionDestino AND d.Almacen = @Almacen AND o.Empresa = @Empresa
IF @TarimaOrigen IS NOT NULL
SELECT @TarimaM = @TarimaOrigen
IF @MovTipo='TMA.PCKTarima' SELECT @TarimaM = CASE WHEN CHARINDEX('-', @TarimaOrigen) > 0  THEN SUBSTRING(@TarimaOrigen, 1, CHARINDEX('-', @TarimaOrigen)-1) ELSE @TarimaOrigen END 
SELECT @Articulo=ISNULL(Articulo,@ArticuloAux), @SubCuenta=ISNULL(SubCuenta, @SubCuentaAux) FROM Tarima WHERE Almacen = @AlmacenDetalle AND Tarima = @TarimaM 
SELECT @Articulo = ISNULL(@Articulo,@ArticuloAux)
SELECT @ArtMoneda = MonedaCosto FROM Art WHERE Articulo = @Articulo
SELECT @Costo = ISNULL(CostoPromedio,0.0) * ISNULL(@CantidadPicking,0) FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
IF @TarimaSurtido IS NOT NULL AND NOT EXISTS(SELECT * FROM Tarima WHERE Tarima = @TarimaSurtido)
BEGIN
EXEC spTarimaAlta @Empresa, @Sucursal, @Usuario, @Almacen, @FechaRegistro, @FechaEmision, @TarimaSurtido, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE Tarima SET Posicion = @PosicionDestino, FechaCaducidad = (SELECT FechaCaducidad FROM Tarima WHERE Tarima = @TarimaM), Articulo=@Articulo, SubCuenta=@SubCuenta WHERE Tarima = @TarimaSurtido 
END
IF(SELECT Posicion FROM Tarima WHERE Tarima = @TarimaSurtido) <> @PosicionDestino
UPDATE Tarima SET Posicion = @PosicionDestino WHERE Tarima = @TarimaSurtido
IF @TarimaM IS NOT NULL EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @Articulo, @SubCuenta, @Almacen, NULL, @Modulo, @ID, @Mov, @MovID, 0, 0, @CantidadPicking, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT,@Renglon = @Renglon, @SubGrupo = @TarimaM
IF @TarimaSurtido IS NOT NULL  EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @Articulo, @SubCuenta, @Almacen, NULL, @Modulo, @ID, @Mov, @MovID, 1, 0, @CantidadPicking, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT,@Renglon = @Renglon, @SubGrupo = @TarimaSurtido
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @TarimaM AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 0 
BEGIN
SELECT @Tipo = AlmPos.Tipo FROM Tarima JOIN AlmPos ON AlmPos.Almacen = @Almacen AND Tarima.Posicion = AlmPos.Posicion WHERE Tarima = @TarimaM
IF @Tipo <> 'Domicilio'
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @TarimaM
END
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 0 
BEGIN
SELECT @Tipo = AlmPos.Tipo
FROM Tarima JOIN AlmPos ON AlmPos.Almacen = @Almacen AND Tarima.Posicion = AlmPos.Posicion WHERE Tarima = @Tarima
IF @Tipo <> 'Domicilio'
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
END
UPDATE TMAD SET Tarima = @TarimaSurtido WHERE Tarima = @TarimaM AND ID = @ID
SELECT @Artipo = Tipo FROM Art WHERE Articulo = @Articulo
IF @Artipo IN ('SERIE', 'LOTE') AND @Tarima IS NOT NULL AND @TarimaSurtido IS NOT NULL
BEGIN
SET @CantidadExistencia = 0
END
END
SELECT @TipoPos = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
IF @MovTipo = 'TMA.SUR' AND @EstatusNuevo = 'CONCLUIDO' AND @TipoPos = 'Domicilio'
BEGIN
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
IF CHARINDEX('-', @TarimaPCK) > 0
SELECT @Articulo=ISNULL(Articulo,@ArticuloAux), @SubCuenta=ISNULL(SubCuenta, @SubCuentaAux) FROM Tarima WHERE Almacen = @AlmacenDetalle AND Tarima = SUBSTRING(@TarimaPCK, 1, CHARINDEX('-', @TarimaPCK)-1)
ELSE
SELECT @Articulo=ISNULL(Articulo,@ArticuloAux), @SubCuenta=ISNULL(SubCuenta, @SubCuentaAux) FROM Tarima WHERE Almacen = @AlmacenDetalle AND Tarima = @TarimaPCK 
SELECT @ArtMoneda = MonedaCosto FROM Art WHERE Articulo = @Articulo
SELECT @Costo = ISNULL(CostoPromedio,0.0) * ISNULL(@CantidadPicking,0) FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
IF @Tarima IS NOT NULL AND NOT EXISTS(SELECT * FROM Tarima WHERE Tarima = @Tarima)
BEGIN
EXEC spTarimaAlta @Empresa, @Sucursal, @Usuario, @Almacen, @FechaRegistro, @FechaEmision, @Tarima, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE Tarima SET Posicion = @PosicionDestino, FechaCaducidad = (SELECT FechaCaducidad FROM Tarima WHERE Tarima = @TarimaPCK), Articulo=@ArticuloAux, SubCuenta=@SubCuentaAux WHERE Tarima = @Tarima  
END
IF @ArticuloAux IS NULL 
SELECT @Articulo=ISNULL(Articulo,@ArticuloAux), @SubCuenta=ISNULL(SubCuenta, @SubCuentaAux) FROM Tarima WHERE Tarima = @Tarima 
IF @Ok IS NULL AND @TarimaPCK IS NOT NULL
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @ArticuloAux, @SubCuentaAux, @Almacen, 
NULL, @Modulo, @ID, @Mov, @MovID, 0, 0, @CantidadPicking, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @TarimaPCK
IF @Ok IS NULL AND @Tarima IS NOT NULL
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @ArticuloAux, @SubCuentaAux, @Almacen, 
NULL, @Modulo, @ID, @Mov, @MovID, 1, 0, @CantidadPicking, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @Tarima
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @TarimaM AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 0 
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @TarimaM
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 1 
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
SELECT @Artipo = Tipo FROM Art WHERE Articulo = @Articulo
IF @Ok IS NULL AND @Artipo IN ('SERIE', 'LOTE') AND @TarimaPCK IS NOT NULL AND @Tarima IS NOT NULL
BEGIN
IF CHARINDEX('-', @TarimaPCK, 1) > 0
SELECT @TarimaM = SUBSTRING(@TarimaPCK, 1, CHARINDEX('-', @TarimaPCK, 1)-1)
ELSE
SELECT @TarimaM = @TarimaPCK
SET @CantidadExistencia = 0
END
END
SELECT @TipoPos = ISNULL(Tipo,'') FROM AlmPos WHERE Posicion = @Posicion AND Almacen = @Almacen
IF @MovTipo = 'TMA.TSUR' AND @SubClave = 'TMA.TSURP' AND @EstatusNuevo = 'PROCESAR' AND @TipoPos IN ('Domicilio','Cross Docking')  
BEGIN
SELECT @SucursalAlmacen = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @TarimaM = dbo.fnTMATarimaOriginal(@Tarima)
UPDATE TMAD SET CantidadA = 0, Procesado = 1 WHERE ID = @IDOrigen AND Tarima = @Tarima
UPDATE Tarima SET /*Posicion = @PosicionDestino,*/ Alta = GETDATE() WHERE Tarima = @Tarima /*AND Almacen = @AlmacenDetalle*/ AND Posicion = @Posicion
SELECT @Articulo=ISNULL(Articulo,@ArticuloAux), @SubCuenta=ISNULL(SubCuenta, @SubCuentaAux) FROM Tarima WHERE Almacen = @AlmacenDetalle AND Tarima = @TarimaM 
SELECT @ArtMoneda = MonedaCosto FROM Art WHERE Articulo = @Articulo
SELECT @Costo = ISNULL(CostoPromedio,0.0) * ISNULL(@CantidadPicking,0) FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
SELECT @TotalSerie = SUM(Cantidad) FROM SerieLoteMov WHERE ID = @ID AND Modulo = @Modulo AND Articulo = @ArticuloAux
IF @Ok IS NULL AND @TarimaM IS NOT NULL
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @ArticuloAux, @SubCuentaAux, @Almacen,  
NULL, @Modulo, @ID, @Mov, @MovID, 0, 0, @CantidadPicking, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @TarimaM
IF @Ok IS NULL AND @Tarima IS NOT NULL
EXEC spSaldo @SucursalAlmacen, @Accion, @Empresa, @Usuario, 'WMS', @ArtMoneda, 1, @ArticuloAux, @SubCuentaAux, @Almacen, 
NULL, @Modulo, @ID, @Mov, @MovID, 1, 0, @CantidadPicking, 1, @FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @SubGrupo = @Tarima
END
IF @MovTipo = 'TMA.RADO' AND @EstatusNuevo = 'CANCELADO' AND @Accion = 'CANCELAR'
UPDATE Tarima SET Posicion = @Posicion WHERE Tarima = @Tarima
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @TarimaM AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 0 
BEGIN
SELECT @Tipo = AlmPos.Tipo FROM Tarima  JOIN AlmPos ON AlmPos.Almacen = @Almacen AND Tarima.Posicion = AlmPos.Posicion WHERE Tarima = @TarimaM
IF @Tipo <> 'Domicilio'
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @TarimaM
END
IF @TipoOrigen='Surtido'
BEGIN
IF (SELECT SUM(ISNULL(a.Disponible,0)) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @Tarima AND t.Estatus = 'ALTA' /*AND a.Articulo = @Articulo */AND a.Almacen = @Almacen) <= 0 
BEGIN
SELECT @Tipo = AlmPos.Tipo
FROM Tarima JOIN AlmPos ON AlmPos.Almacen = @Almacen AND Tarima.Posicion = AlmPos.Posicion WHERE Tarima = @Tarima
IF @Tipo <> 'Domicilio'
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
END
END
ELSE
BEGIN
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 0 
BEGIN
SELECT @Tipo = AlmPos.Tipo
FROM Tarima JOIN AlmPos ON AlmPos.Almacen = @Almacen AND Tarima.Posicion = AlmPos.Posicion WHERE Tarima = @Tarima
IF @Tipo <> 'Domicilio'
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
END
END
/* 
IF (SELECT ISNULL(a.Disponible,0) FROM ArtDisponibleTarima a JOIN Tarima t ON a.Tarima = t.Tarima WHERE a.Empresa = @Empresa AND a.Tarima = @Tarima AND t.Estatus = 'ALTA' AND a.Articulo = @Articulo AND a.Almacen = @Almacen) <= 0 
BEGIN
SELECT @Tipo = AlmPos.Tipo
FROM Tarima JOIN AlmPos ON AlmPos.Almacen = @Almacen AND Tarima.Posicion = AlmPos.Posicion WHERE Tarima = @Tarima
IF @Tipo <> 'Domicilio'
UPDATE Tarima SET Estatus = 'BAJA', Baja = @FechaRegistro WHERE Tarima = @Tarima
END
*/ 
IF @WMSDispararReacomodos = 1 AND @MovTipo = 'TMA.TSUR' AND @SubClave = 'TMA.TSURP' AND @EstatusNuevo IN('PROCESAR', 'CANCELADO')
BEGIN
SELECT @Articulo=ISNULL(Articulo,@ArticuloAux), @SubCuenta=ISNULL(SubCuenta, @SubCuentaAux) FROM Tarima WHERE Almacen = @AlmacenDetalle AND Tarima = @Tarima 
IF @Tarima LIKE '%-%'
BEGIN
SELECT @LEN = LEN(@Tarima)
WHILE SUBSTRING(@Tarima,@LEN,1) <> '-'
SELECT @LEN = @LEN -1
SELECT @TarimaReacomodo = SUBSTRING(@Tarima,1, @LEN)
SELECT @TarimaReacomodo = SUBSTRING(@TarimaReacomodo,1, @LEN-1)
END
IF @SubCuenta IS NULL 
EXEC spTMAReacomodoSolicitar @ID, @@SPID, @IDOrigen, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion,
@FechaConclusion, @Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus,
@EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @Sucursal, @SucursalDestino, @SucursalOrigen,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @TarimaEsp = @TarimaReacomodo, @PosicionEsp = @Posicion, @ArticuloEsp = NULL
END
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Tarima
FETCH NEXT FROM crAfectarTMAD INTO @Tarima, @AlmacenDetalle, @Posicion, @PosicionDestino, @TarimaEstatus, @CantidadPicking, @TarimaPCK,
@CantidadUnidad, @Unidad, 
@ArticuloAux, @SubCuentaAux, 
@Es50, @Es50TarimaDom, @Es50Cantidad 
END
CLOSE crAfectarTMAD
DEALLOCATE crAfectarTMAD
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE TMA
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion  = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @MovTipo NOT IN ('TMA.OADO','TMA.SRADO', 'TMA.SADO', 'TMA.ORADO')  AND @EstatusNuevo = 'CONCLUIDO' 
UPDATE TMAD SET Procesado = 1, CantidadA = 0 WHERE ID = @ID AND EstaPendiente = 1
IF @MovTipo IN ('TMA.SUR','TMA.RADO','TMA.ADO', 'TMA.SURPER', 'TMA.PCKTARIMA', 'TMA.PCKTARIMATRAN') AND @Ok IS NULL OR @MovTipo = 'TMA.TSUR' AND @SubClave = 'TMA.TSURP' AND @EstatusNuevo = 'PROCESAR' AND @Ok IS NULL
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
SELECT @FechaConclusion  = @FechaEmision
IF (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0 AND @SubClave <> 'TMA.TSURP' AND @MovTipo <> 'TMA.SURPER'
BEGIN
UPDATE TMA SET FechaConclusion  = @FechaConclusion, FechaCancelacion = @FechaCancelacion,  UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN GETDATE() ELSE UltimoCambio END,
Estatus          = CASE WHEN @EstatusNuevo = 'CANCELADO' THEN 'PENDIENTE' ELSE @EstatusNuevo END,   Situacion  = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END
WHERE ID = @IDOrigen
IF @MovTipo = 'TMA.TSUR' AND @SubClave = 'TMA.TSURP' AND @EstatusNuevo = 'PROCESAR'
UPDATE TMA SET Estatus = 'CONCLUIDO' WHERE ID = @IDOrigen
END
IF @MovTipo = 'TMA.TSUR' AND @SubClave = 'TMA.TSURP' OR @MovTipo = 'TMA.SURPER' OR @MovTipo = 'TMA.PCKTARIMATRAN'  
BEGIN
DECLARE crTarimaD CURSOR LOCAL FOR
SELECT CASE WHEN (CHARINDEX('-', Tarima)-1)  < 0 THEN  Tarima ELSE SUBSTRING(Tarima, 1, (CHARINDEX('-', Tarima)-1) )END, SUM(ISNULL(CantidadPicking,0)), Renglon
FROM TMAD WHERE ID = @IDOrigen  AND CASE WHEN (CHARINDEX('-', Tarima)-1)  < 0 THEN  Tarima ELSE SUBSTRING(Tarima, 1, (CHARINDEX('-', Tarima)-1) )END IN(SELECT  CASE WHEN (CHARINDEX('-', Tarima)-1)  < 0 THEN Tarima ELSE SUBSTRING(Tarima, 1, (CHARINDEX('-', Tarima)-1) )END FROM TMAD WHERE ID = @ID)
GROUP BY CASE WHEN (CHARINDEX('-', Tarima)-1)  < 0 THEN  Tarima ELSE SUBSTRING(Tarima, 1, (CHARINDEX('-', Tarima)-1) )END, Renglon
OPEN crTarimaD
FETCH NEXT FROM crTarimaD INTO @TarimaOrigen, @CantidadSurtido, @Renglon
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadTransito = SUM(ISNULL(CantidadPicking,0))
FROM TMA t JOIN TMAD d ON t.ID = d.ID JOIN MovTipo m ON m.Modulo = 'TMA' AND m.Mov = t.Mov
WHERE t.Origen = @MovOrigen
AND t.OrigenID = @MovIDOrigen AND t.Empresa = @Empresa AND t.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND CASE WHEN (CHARINDEX('-', d.Tarima)-1)  < 0 THEN  d.Tarima ELSE SUBSTRING(d.Tarima, 1, (CHARINDEX('-', d.Tarima)-1) )END = @TarimaOrigen
AND m.Clave <> 'TMA.SURPER' AND d.Renglon = @Renglon 
UPDATE TMAD SET Procesado = 0 WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon
IF @Accion = 'AFECTAR'
BEGIN
UPDATE TMAD SET CantidadPendiente = ISNULL(CantidadPicking, 0) - ISNULL(@CantidadTransito, 0) WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon  
END
ELSE
IF @Accion = 'CANCELAR'
BEGIN
UPDATE TMAD SET CantidadPendiente = ISNULL(CantidadPicking, 0) + ISNULL(@CantidadTransito, 0) WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon  
END
IF NOT EXISTS (SELECT * FROM TMAD WHERE ID = @IDOrigen AND ISNULL(CantidadPendiente, 0) > 0)
UPDATE TMA SET Estatus = 'CONCLUIDO' WHERE ID = @IDOrigen
IF @CantidadSurtido < @CantidadTransito AND @MovTipo <> 'TMA.SURPER'
SELECT @Ok = 20020
UPDATE TMAD SET CantidadA = 0 WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon
IF @MovTipo = 'TMA.SURPER'
BEGIN
SELECT @CantidadPicking = CantidadPicking FROM TMAD WHERE ID = @ID AND Tarima = @TarimaOrigen AND Renglon = @Renglon
IF @Accion <> 'CANCELAR'
BEGIN
UPDATE TMAD SET CantidadPendiente = ISNULL(CantidadPendiente,CantidadPicking) - @CantidadPicking WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon
IF NOT EXISTS (SELECT * FROM TMAD WHERE ID = @IDOrigen AND ISNULL(CantidadPendiente, CantidadPicking) <> 0)
UPDATE TMA SET Estatus = 'CONCLUIDO' WHERE ID = @IDOrigen
END
ELSE
BEGIN
UPDATE TMAD SET CantidadPendiente =  CantidadPendiente + @CantidadPicking WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon
IF EXISTS (SELECT * FROM TMAD WHERE ID = @IDOrigen AND CantidadPendiente <> 0) AND (SELECT Estatus FROM TMA WHERE ID = @IDOrigen) IN ('CONCLUIDO')
UPDATE TMA SET Estatus = 'PENDIENTE' WHERE ID = @IDOrigen AND Estatus <> 'CANCELADO'
END
END
FETCH NEXT FROM crTarimaD INTO @TarimaOrigen, @CantidadSurtido, @Renglon
END
CLOSE crTarimaD
DEALLOCATE crTarimaD
END
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'TMA', @IDOrigen, @MovOrigen, @MovIDOrigen, 'TMA', @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @MovTipo IN ('TMA.ORADO') AND @Ok IS NULL AND @EstatusNuevo <> 'CANCELADO'
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
SELECT @FechaConclusion  = @FechaEmision
IF (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0
BEGIN
UPDATE TMA SET FechaConclusion  = @FechaConclusion, FechaCancelacion = @FechaCancelacion, UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN GETDATE() ELSE UltimoCambio END,
Estatus          = 'CONCLUIDO', Situacion  = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END WHERE ID = @IDOrigen
END
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'TMA', @IDOrigen, @MovOrigen, @MovIDOrigen, 'TMA', @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @MovTipo IN ('TMA.ORADO', 'TMA.OADO') AND @Ok IS NULL AND @EstatusNuevo = 'CANCELADO'
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
IF (SELECT Estatus FROM TMA WHERE ID = @IDOrigen) = 'CONCLUIDO'
UPDATE TMA SET Estatus = 'PENDIENTE' WHERE ID = @IDOrigen
DECLARE crCancelar CURSOR FOR
SELECT CASE WHEN (CHARINDEX('-', Tarima)-1) < 0 THEN Tarima ELSE SUBSTRING(Tarima, 1, (CHARINDEX('-', Tarima)-1) ) END,
Renglon
FROM TMAD
WHERE ID = @ID
AND Procesado = 0
GROUP BY CASE WHEN (CHARINDEX('-', Tarima)-1)  < 0 THEN  Tarima ELSE SUBSTRING(Tarima, 1, (CHARINDEX('-', Tarima)-1) ) END, Renglon
OPEN crCancelar
FETCH NEXT FROM crCancelar INTO @TarimaOrigen, @Renglon
WHILE @@FETCH_STATUS = 0
BEGIN
IF (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon AND ISNULL(Procesado,0) = 1) = 1
UPDATE TMAD SET Procesado = 0 WHERE ID = @IDOrigen AND Tarima = @TarimaOrigen AND Renglon = @Renglon
FETCH NEXT FROM crCancelar INTO @TarimaOrigen, @Renglon
END
CLOSE crCancelar
DEALLOCATE crCancelar
END
END
END
IF @Ok IS NULL AND @Accion = 'AFECTAR' OR @Ok BETWEEN 80030 AND 81000 AND @Accion = 'AFECTAR'
BEGIN
IF (SELECT Estatus FROM TMA WHERE ID = @ID) IN ('PENDIENTE') AND @MovTipo IN ('TMA.OADO', 'TMA.ORADO', 'TMA.OSUR',  'TMA.OPCKTARIMA')   
UPDATE TMA SET FechaInicio = GETDATE() WHERE ID = @ID
UPDATE TMAD SET CantidadPendiente = CantidadUnidad WHERE ID = @ID
IF @MovTipo IN ('TMA.TSUR') AND (@Ok IS NULL OR @Ok BETWEEN 80000 AND 81000)
BEGIN
SELECT @MovOrigen = Origen, @MovIDOrigen = OrigenID FROM TMA WHERE ID = @ID AND OrigenTipo = 'TMA'
SELECT @IDOrigen = ID FROM TMA WHERE Mov = @MovOrigen AND MovID = @MovIDOrigen AND Empresa = @Empresa
SELECT @FechaConclusion  = @FechaEmision
IF (SELECT ESTATUS FROM TMA WHERE ID = @IDOrigen) = 'PENDIENTE'
BEGIN
UPDATE A SET A.CantidadPendiente = CASE WHEN (A.CantidadPendiente - B.CantidadPendiente) >= 0 THEN (A.CantidadPendiente - B.CantidadPendiente) ELSE A.CantidadPendiente END
FROM TMAD A JOIN TMAD B ON A.ID = @IDOrigen AND A.Renglon = B.Renglon AND A.Tarima = B.Tarima AND A.Almacen = B.Almacen  AND A.Posicion = B.Posicion AND A.PosicionDestino = B.PosicionDestino AND B.ID = @ID
END
IF @MovTipo<>'TMA.OADO' AND (SELECT COUNT(0) FROM TMAD WHERE ID = @IDOrigen AND ISNULL(Procesado,0) = 0) = 0 AND NOT EXISTS (SELECT * FROM TMAD WHERE ID = @IDOrigen AND ISNULL(CantidadPendiente, 0) > 0)
BEGIN
UPDATE TMA SET Estatus = 'CONCLUIDO' WHERE ID = @IDOrigen
END
END
IF (SELECT Estatus FROM TMA WHERE ID = @ID) IN ('CONCLUIDO', 'PROCESAR') AND @MovTipo IN ('TMA.ADO', 'TMA.RADO', 'TMA.SUR', 'TMA.TSUR', 'TMA.PCKTarima', 'TMA.PCKTarimaTran')  
BEGIN
SELECT @IDOrigen = ID FROM TMA WHERE Origen = @Mov AND OrigenID = @MovID AND Empresa = @Empresa
UPDATE TMA SET FechaFin = GETDATE() WHERE ID = @IDOrigen
UPDATE TMA SET FechaFin = GETDATE(), FechaInicio = (SELECT FechaFin FROM TMA WHERE ID = @IDOrigen) WHERE ID = @ID
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
begin
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
end
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

