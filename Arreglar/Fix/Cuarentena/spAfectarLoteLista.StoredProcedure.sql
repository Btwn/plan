SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAfectarLoteLista]
 @Estacion INT
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Accion CHAR(20)
,@Base CHAR(20)
,@GenerarMov CHAR(20)
,@Usuario CHAR(10)
,@FacturarLote VARCHAR(20) = 'Movimiento'
,@Conexion BIT = 0
AS
BEGIN
	DECLARE
		@Elimino INT
	   ,@ID INT
	   ,@IDGenerar INT
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@Mensaje VARCHAR(255)
	   ,@MovTipo VARCHAR(20)
	   ,@GenerarMovTipo VARCHAR(20)
	   ,@Continuar BIT
	   ,@Sucursal INT
	   ,@Cliente CHAR(10)
	   ,@Condicion VARCHAR(50)
	   ,@Vencimiento DATETIME
	   ,@DescuentoGlobal FLOAT
	   ,@Renglon FLOAT
		 ,@CFD BIT
	   ,@min INT
	   ,@max INT
	SELECT @GenerarMovTipo = Clave
	FROM MovTipo
	WHERE Modulo = @Modulo
	AND Mov = @GenerarMov
	DELETE ListaIDOk
	WHERE Estacion = @Estacion
	DECLARE
		@crListaCte AS TABLE (
			ident INT IDENTITY (1, 1)
		   ,Clave VARCHAR(10) NULL
		   ,Sucursal INT NULL
		   ,Cliente VARCHAR(10) NULL
		   ,Condicion VARCHAR(50) NULL
		   ,Vencimiento DATETIME NULL
		   ,descuentoglobal FLOAT NULL
		   ,ID INT NULL
		)
	DECLARE
		@crLista AS TABLE (
			ident INT IDENTITY (1, 1)
		   ,ID INT NULL
		)

	IF @FacturarLote = 'Cliente'
	BEGIN
		INSERT INTO @crListaCte
			SELECT mt.Clave
				  ,v.Sucursal
				  ,v.Cliente
				  ,v.Condicion
				  ,v.Vencimiento
				  ,v.DescuentoGlobal
				  ,MIN(l.ID)
			FROM ListaID l
				,Venta v
				,MovTipo mt
			WHERE l.Estacion = @Estacion
			AND v.ID = l.ID
			AND v.Empresa = @Empresa
			AND mt.Modulo = @Modulo
			AND mt.Mov = v.Mov
			GROUP BY mt.Clave
					,v.Sucursal
					,v.Cliente
					,v.Condicion
					,v.Vencimiento
					,v.DescuentoGlobal
			ORDER BY mt.Clave, v.Sucursal, v.Cliente, v.Condicion, v.Vencimiento, v.DescuentoGlobal
		SELECT @min = MIN(ID)
			  ,@max = MAX(ID)
		FROM @crListaCte
		WHILE @min <= @max
		BEGIN
		SELECT @MovTipo = Clave
			  ,@Sucursal = Sucursal
			  ,@Cliente = Cliente
			  ,@Condicion = Condicion
			  ,@Vencimiento = Vencimiento
			  ,@DescuentoGlobal = descuentoglobal
			  ,@ID = ID
		FROM @crListaCte
		WHERE ident = @min
		SELECT @Continuar = 1

		IF @GenerarMovTipo = 'VTAS.F'
		BEGIN
			IF (
					SELECT mt.Clave
					FROM Venta v
						,MovTipo mt
					WHERE v.ID = @ID
					AND mt.Modulo = 'VTAS'
					AND mt.Mov = v.Mov
				)
				NOT IN ('VTAS.P', 'VTAS.S', 'VTAS.VCR')
				SELECT @Continuar = 0

			EXEC spMovTipoCFD @Empresa
								 ,@Modulo
								 ,@GenerarMov
								 ,@CFD OUTPUT

			IF @CFD = 1
				WAITFOR DELAY '00:00:01'
		END

		IF @Continuar = 1
		BEGIN
			SELECT @IDGenerar = NULL
			EXEC @IDGenerar = spAfectar @Modulo
									   ,@ID
									   ,@Accion
									   ,@Base
									   ,@GenerarMov
									   ,@Usuario
									   ,0
									   ,1
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

			IF @Ok = 80030
			BEGIN
				SELECT @Renglon = ISNULL(MAX(Renglon), 0)
				FROM VentaD
				WHERE ID = @IDGenerar
				SELECT *
				INTO #VentaDetalleLote
				FROM cVentaD
				WHERE ID IN (SELECT l.ID FROM ListaID l, Venta v WHERE l.Estacion = @Estacion AND v.ID <> @ID AND v.ID = l.ID AND v.Empresa = @Empresa AND v.Sucursal = @Sucursal AND v.Cliente = @Cliente AND v.Condicion = @Condicion AND v.Vencimiento = @Vencimiento AND v.DescuentoGlobal = @DescuentoGlobal)

				IF EXISTS (SELECT * FROM #VentaDetalleLote)
				BEGIN
					UPDATE #VentaDetalleLote
					SET @Renglon = Renglon = @Renglon + 2048.0
					   ,Aplica = v.Mov
					   ,AplicaID = v.MovID
					FROM #VentaDetalleLote d, Venta v
					WHERE v.ID = d.ID

					IF @MovTipo = 'VTAS.VCR'
						UPDATE #VentaDetalleLote
						SET Almacen = v.AlmacenDestino
						FROM #VentaDetalleLote d, Venta v
						WHERE v.ID = d.ID

					IF @Base = 'TODO'
						UPDATE #VentaDetalleLote
						SET ID = @IDGenerar
						   ,CantidadPendiente = NULL
						   ,CantidadCancelada = NULL
						   ,CantidadReservada = NULL
						   ,CantidadOrdenada = NULL
						   ,CantidadA = NULL
						   ,UltimoReservadoCantidad = NULL
						   ,UltimoReservadoFecha = NULL
					ELSE

					IF @Base = 'SELECCION'
						UPDATE #VentaDetalleLote
						SET ID = @IDGenerar
						   ,Cantidad = CantidadA
						   ,CantidadInventario = CantidadA * CantidadInventario / Cantidad
						   ,CantidadPendiente = NULL
						   ,CantidadCancelada = NULL
						   ,CantidadReservada = NULL
						   ,CantidadOrdenada = NULL
						   ,CantidadA = NULL
						   ,UltimoReservadoCantidad = NULL
						   ,UltimoReservadoFecha = NULL
					ELSE

					IF @Base = 'PENDIENTE'
						UPDATE #VentaDetalleLote
						SET ID = @IDGenerar
						   ,Cantidad = NULLIF(ISNULL(CantidadPendiente, 0.0) + ISNULL(CantidadReservada, 0.0), 0.0)
						   ,CantidadInventario = (NULLIF(ISNULL(CantidadPendiente, 0.0) + ISNULL(CantidadReservada, 0.0), 0.0)) * CantidadInventario / Cantidad
						   ,CantidadPendiente = NULL
						   ,CantidadReservada = NULL
						   ,CantidadCancelada = NULL
						   ,CantidadOrdenada = NULL
						   ,CantidadA = NULL
						   ,UltimoReservadoCantidad = NULL
						   ,UltimoReservadoFecha = NULL
					ELSE

					IF @Base = 'RESERVADO'
						UPDATE #VentaDetalleLote
						SET ID = @IDGenerar
						   ,Cantidad = CantidadReservada
						   ,CantidadInventario = CantidadReservada * CantidadInventario / Cantidad
						   ,CantidadPendiente = NULL
						   ,CantidadCancelada = NULL
						   ,CantidadReservada = NULL
						   ,CantidadOrdenada = NULL
						   ,CantidadA = NULL
						   ,UltimoReservadoCantidad = NULL
						   ,UltimoReservadoFecha = NULL

					IF @@ERROR <> 0
						SELECT @Ok = 1

					UPDATE #VentaDetalleLote
					SET Sucursal = @Sucursal
					   ,SucursalOrigen = @Sucursal
					   ,SustitutoArticulo = NULL
					   ,SustitutoSubCuenta = NULL

					IF @@ERROR <> 0
						SELECT @Ok = 1

					DELETE #VentaDetalleLote
					WHERE Cantidad IS NULL
						OR Cantidad = 0.0

					IF @@ERROR <> 0
						SELECT @Ok = 1

					INSERT INTO cVentaD
						SELECT *
						FROM #VentaDetalleLote

					IF @@ERROR <> 0
						SELECT @Ok = 1

				END

				DROP TABLE #VentaDetalleLote

				IF @@ERROR <> 0
					SELECT @Ok = 1

				IF @Ok IN (NULL, 80030)
				BEGIN

					IF @Modulo = 'VTAS'
						AND @GenerarMov IN (SELECT Mov FROM MovTipo WHERE TipoConsecutivo = 'General' AND Modulo = 'VTAS')
						EXEC SpConsecutivoGral @IDGenerar
											  ,'VTAS'
											  ,0

					EXEC spAfectar @Modulo
								  ,@IDGenerar
								  ,'AFECTAR'
								  ,'TODO'
								  ,NULL
								  ,@Usuario
								  ,@Conexion
								  ,1
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT
				END

				SELECT @Elimino = 0

				IF @Ok NOT IN (NULL, 80030)
					EXEC @Elimino = spEliminarMov @Modulo
												 ,@IDGenerar

				IF @Elimino = 0
					SELECT @ID = @IDGenerar

			END

			INSERT ListaIDOK (Estacion, ID, Empresa, Modulo, Ok, OkRef)
				VALUES (@Estacion, @ID, @Empresa, @Modulo, @Ok, @OkRef)
		END

		SET @min = @min + 1
		END
	END
	ELSE
	BEGIN
		INSERT INTO @crLista
			SELECT ID
			FROM ListaID
			WHERE Estacion = @Estacion
			ORDER BY IDInterno
		SELECT @min = MIN(ident)
			  ,@max = MAX(ident)
		FROM @crLista
		WHILE @min <= @max
		BEGIN
		SELECT @ID = ID
		FROM @crLista
		WHERE Ident = @min
		SELECT @Continuar = 1

		IF @GenerarMovTipo = 'VTAS.F'
		BEGIN
			IF (
					SELECT mt.Clave
					FROM Venta v
						,MovTipo mt
					WHERE v.ID = @ID
					AND mt.Modulo = 'VTAS'
					AND mt.Mov = v.Mov
				)
				NOT IN ('VTAS.P', 'VTAS.S', 'VTAS.VCR')
				SELECT @Continuar = 0

			EXEC spMovTipoCFD @Empresa
								 ,@Modulo
								 ,@GenerarMov
								 ,@CFD OUTPUT

				IF @CFD = 1
					WAITFOR DELAY '00:00:01'
		END

		IF @Continuar = 1
		BEGIN
			SELECT @IDGenerar = NULL
			EXEC @IDGenerar = spAfectar @Modulo
									   ,@ID
									   ,@Accion
									   ,@Base
									   ,@GenerarMov
									   ,@Usuario
									   ,@Conexion
									   ,1
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

			IF @Ok = 80030
			BEGIN

				IF @Modulo = 'VTAS'
					AND @GenerarMov IN (SELECT Mov FROM MovTipo WHERE TipoConsecutivo = 'General' AND Modulo = 'VTAS')
					EXEC SpConsecutivoGral @IDGenerar
										  ,'VTAS'
										  ,0

				EXEC spAfectar @Modulo
							  ,@IDGenerar
							  ,'AFECTAR'
							  ,'TODO'
							  ,NULL
							  ,@Usuario
							  ,@Conexion
							  ,1
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
				SELECT @Elimino = 0

				IF @Ok NOT IN (NULL, 80030)
					EXEC @Elimino = spEliminarMov @Modulo
												 ,@IDGenerar

				IF @Elimino = 0
					SELECT @ID = @IDGenerar

			END

			INSERT ListaIDOK (Estacion, ID, Empresa, Modulo, Ok, OkRef)
				VALUES (@Estacion, @ID, @Empresa, @Modulo, @Ok, @OkRef)
		END

		SET @min = @min + 1
		END
	END

	IF @Ok IN (NULL, 80030)
		SELECT @Mensaje = 'Proceso Concluido'
	ELSE
		SELECT @Mensaje = Descripcion + ' ' + RTRIM(@OkRef)
		FROM MensajeLista
		WHERE Mensaje = @Ok

	SELECT @Mensaje
	RETURN
END
GO