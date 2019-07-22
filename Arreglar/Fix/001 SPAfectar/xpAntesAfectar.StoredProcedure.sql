SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC [dbo].[xpAntesAfectar]
 @Modulo CHAR(5)
,@ID INT
,@Accion CHAR(20)
,@Base CHAR(20)
,@GenerarMov CHAR(20)
,@Usuario CHAR(10)
,@SincroFinal BIT
,@EnSilencio BIT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@FechaRegistro DATETIME
AS
BEGIN
	DECLARE
		@Mov VARCHAR(20)
	   ,@Estatus VARCHAR(20)
	   ,@MovTipo VARCHAR(20)
	   ,@Situacion VARCHAR(50)
	   ,@Proveedor VARCHAR(20)
	   ,@Encontrado INT
	   ,@Diferente INT
	   ,@NumReg INT
	   ,@Comentarios VARCHAR(255)
	   ,@Cliente VARCHAR(15)
	   ,@Empresa CHAR(5)
	   ,@Cantidad INT
	   ,@RenglonID VARCHAR(3)
	   ,@Articulo VARCHAR(20)
	   ,@reg INT
	   ,@Error INT
	   ,@ProvTipo VARCHAR(30)
	   ,@Concepto VARCHAR(50)
	   ,@TipoCte VARCHAR(15)
	   ,@PrefijoCte VARCHAR(2)
	   ,@NuloCopia BIT
	   ,@GpoTrabajo VARCHAR(50)
	   ,@Condicion VARCHAR(50)
	   ,@Condicion2 VARCHAR(50)
	   ,@CteEnviarA INT
	   ,@ImporteTotal MONEY
	   ,@DineroID INT
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@Clave VARCHAR(20)
	   ,@IDOrigen INT
	   ,@Costo MONEY
	   ,@CostoAnt MONEY
	   ,@Almacen VARCHAR(10)
	   ,@Mensaje VARCHAR(100)
	   ,@IVA FLOAT
	   ,@IVAFiscal FLOAT
	   ,@Financiamiento MONEY
	   ,@Capital FLOAT
	   ,@Renglon FLOAT
	   ,@SaldoTotal MONEY
	   ,@Agente VARCHAR(10)
	   ,@NivelCobranza VARCHAR(100)
	   ,@ImporteARefinanciar MONEY
	   ,@CondRef VARCHAR(50)
	   ,@AplicaManual BIT
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@Vencimiento DATETIME
	   ,@AplicaManualCxc BIT
	   ,@OrigenCob VARCHAR(20)
	   ,@CCategoria INT
	   ,@Personal VARCHAR(10)
	   ,@Estado BIT
	   ,@PadreMavi VARCHAR(20)
	   ,@PadreMaviID VARCHAR(20)
	   ,@cont INT
	   ,@contfinal INT
	   ,@idAux INT
	   ,@RFCCompleto INT
	   ,@DevOrigen INT
	   ,@FacDesgloseIVA BIT
	   ,@ArtP VARCHAR(20)
	   ,@Precio MONEY
	   ,@PrecioArt MONEY
	   ,@PrecioAnterior MONEY
	   ,@Agente2 VARCHAR(20)
	   ,@Licencia VARCHAR(20)
	   ,@Licencia2 VARCHAR(20)
	   ,@Ruta VARCHAR(50)
	   ,@EstatusSol VARCHAR(20)
	   ,@MovIDSol VARCHAR(20)
	   ,@MovSol VARCHAR(20)
	   ,@FechaEmision DATETIME
	   ,@FechaActual DATETIME
	   ,@TipoCobro INT
	   ,@FechaCobroAntxpol DATETIME
	   ,@Directo BIT
	   ,@ConDesglose BIT
	   ,@AlmacenOrigen VARCHAR(15)
	   ,@AlmacenDestino VARCHAR(15)
	   ,@AlmacenOrigenTipo VARCHAR(15)
	   ,@AlmacenDestinoTipo VARCHAR(15)
	   ,@Redime BIT
	   ,@bloq VARCHAR(15)
	   ,@suc INT
	SET @suc = (
		SELECT TOP 1 Sucursal
		FROM venta WITH(NOLOCK)
		WHERE id = @ID
	)
	SET @FechaActual = GETDATE()
	SET @FechaActual = CONVERT(VARCHAR(8), @FechaActual, 112)

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#ValidaConceptoGas') AND TYPE = 'U')
		DROP TABLE #ValidaConceptoGas

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#cobro') AND TYPE = 'U')
		DROP TABLE #cobro

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#cobroAplica') AND TYPE = 'U')
		DROP TABLE #cobroAplica

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#temp2') AND TYPE = 'U')
		DROP TABLE #temp2

	SELECT @Mov = NULL
	SELECT @MovTipo = NULL
	SELECT @Cliente = NULL
	SELECT @TipoCte = NULL
	SELECT @PrefijoCte = NULL
	SELECT @NuloCopia = 0
	SET @DineroID = NULL

	IF @Modulo = 'VTAS'
	BEGIN
		SELECT @Mov = Mov
			  ,@Estatus = Estatus
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID

		IF @Mov IN ('Factura', 'Factura Mayoreo', 'Factura VIU')
			AND @Estatus <> 'CONCLUIDO'
			AND @Accion <> 'CANCELAR'
		BEGIN

			IF dbo.fn_ValidarExistenciaInv(@ID) IN (2)
				SELECT @Ok = 20020

		END

	END

	IF @Modulo = 'COMS'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'COMS'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'CXC'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'CXC'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'CXP'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'CXP'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'VTAS'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'VTAS'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'DIN'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'DIN'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'INV'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'INV'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
		SELECT @Mov = Mov
		FROM Inv WITH(NOLOCK)
		WHERE ID = @ID

		IF (@Mov = 'Recibo Traspaso')
			EXEC spValidaSerieDevuelta @ID
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT

		SELECT @AlmacenOrigen = Almacen
			  ,@AlmacenDestino = AlmacenDestino
		FROM INV WITH(NOLOCK)
		WHERE ID = @ID

		IF (@AlmacenOrigen IS NOT NULL)
			AND (@AlmacenDestino IS NOT NULL)
		BEGIN
			SELECT @AlmacenOrigenTipo = Tipo
			FROM Alm WITH(NOLOCK)
			WHERE Almacen = @AlmacenOrigen
			SELECT @AlmacenDestinoTipo = Tipo
			FROM Alm WITH(NOLOCK)
			WHERE Almacen = @AlmacenDestino

			IF @AlmacenOrigenTipo <> @AlmacenDestinoTipo
				SELECT @OK = 20120

		END

	END

	IF @Modulo = 'ST'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'ST'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'AGENT'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'AGENT'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'EMB'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		EXEC spValidaNivelAccesoAgente @ID
									  ,'EMB'
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
	END

	IF @Modulo = 'CXP'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
		FROM CXP WITH(NOLOCK)
		WHERE ID = @ID

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Aplicacion', 'Canc Acuerdo Espejo')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END

	END

	IF @Modulo = 'DIN'
		AND @Accion <> 'CANCELAR'
	BEGIN
		SELECT @Mov = Mov
			  ,@Directo = Directo
			  ,@ConDesglose = ConDesglose
		FROM Dinero WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @Clave = Clave
		FROM Movtipo WITH(NOLOCK)
		WHERE Mov = @Mov

		IF @Clave = 'DIN.TC'
			AND @ConDesglose = 0
			AND @Directo = 1
			DELETE DineroD
			WHERE ID = @ID

	END

	IF @Modulo = 'DIN'
		AND @Accion = ('AFECTAR')
	BEGIN
		SELECT @Mov = Mov
			  ,@ImporteTotal = Importe
		FROM Dinero WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @Clave = Clave
		FROM Movtipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo

		IF (@Clave = 'DIN.A')
		BEGIN

			IF (@ImporteTotal > 0)
				UPDATE Dinero WITH(ROWLOCK)
				SET Importe = 0.0
				WHERE ID = @ID

		END

	END

	IF @Modulo = 'INV'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
		FROM INV WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Devolucion Transito', 'Ajuste')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END

		IF @Estatus = 'SINAFECTAR'
			AND @MovTipo IN ('INV.IF')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END

		IF @MovTipo IN ('INV.A', 'INV.IF')
		BEGIN

			IF EXISTS (SELECT * FROM Art a WITH(NOLOCK), Inv b WITH(NOLOCK), InvD c WITH(NOLOCK) WHERE b.Id = c.Id AND c.Articulo = a.Articulo AND b.Id = @Id AND a.Categoria IN ('ACTIVOS FIJOS'))
			BEGIN
				SELECT @Ok = 100026
			END

		END

	END

	IF @Modulo = 'GAS'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
		FROM Gasto WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Comprobante Inst', 'Amortizacion', 'Consumo')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Contrato')
		BEGIN
			EXEC spSolGastoContratoAF @ID
		END

		IF @Estatus = 'SINAFECTAR'
			AND EXISTS (SELECT TOP 1 Mov FROM Empresaconceptovalidar WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov)
		BEGIN

			IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#ValidaConceptoGas') AND TYPE = 'U')
				DROP TABLE #ValidaConceptoGas

			SELECT G.ID
				  ,G.Mov
				  ,G.MovID
				  ,GasConcepto = D.Concepto
				  ,ValidaConcepto = C.Concepto
			INTO #ValidaConceptoGas
			FROM dbo.Gasto G WITH(NOLOCK)
			INNER JOIN dbo.GastoD D WITH(NOLOCK)
				ON G.ID = D.ID
				AND G.ID = @ID
			LEFT JOIN dbo.EmpresaConceptoValidar C WITH(NOLOCK)
				ON C.Mov = G.Mov
				AND C.Empresa = G.Empresa
				AND C.Modulo = @Modulo
				AND C.Concepto = D.Concepto
			GROUP BY G.ID
					,G.Mov
					,G.MovID
					,D.Concepto
					,C.Concepto
			SELECT @Concepto = ISNULL(GasConcepto, '')
			FROM #ValidaConceptoGas
			WHERE ISNULL(GasConcepto, '') <> ISNULL(ValidaConcepto, '')

			IF EXISTS (SELECT GasConcepto FROM #ValidaConceptoGas WHERE GasConcepto = '*')
				SELECT @Ok = 20481
					  ,@OkRef = 'Concepto"*" '

			IF ISNULL(@Concepto, '') <> ''
				SELECT @Ok = 20485
					  ,@OkRef = RTRIM(@Mov) + ' (' + RTRIM(@Concepto) + ')'

			IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#ValidaConceptoGas') AND TYPE = 'U')
				DROP TABLE #ValidaConceptoGas

		END

	END

	IF @Modulo = 'COMS'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		SELECT @Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
			  ,@Origen = Origen
			  ,@OrigenId = OrigenID
		FROM COMPRA WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Compra Consignacion', 'Entrada Compra', 'Entrada con Gastos', 'Remision')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END

		IF NOT EXISTS (SELECT c.Proveedor, d.Articulo FROM compra c WITH(NOLOCK) INNER JOIN CompraD d WITH(NOLOCK) ON d.ID = c.ID INNER JOIN DM0289ConfigArticulos ca WITH(NOLOCK) ON ca.Articulo = d.Articulo INNER JOIN DM0289ConfigProveedores cp  WITH(NOLOCK)ON cp.Proveedor = c.Proveedor INNER JOIN Usuario u WITH(NOLOCK) ON u.Usuario = c.Usuario INNER JOIN DM0289ConfigGrupoTrabajo gt WITH(NOLOCK) ON gt.GrupoTrabajo = u.GrupoTrabajo WHERE c.ID = @ID AND Mov = 'Devolucion Compra')
		BEGIN

			IF @Mov IN ('Orden Devolucion', 'Devolucion Compra')
			BEGIN

				IF EXISTS (SELECT IDCopiaMAVI FROM CompraD WITH(NOLOCK) WHERE IDCopiaMAVI IS NULL AND ID = @ID)
					SELECT @NuloCopia = 1

				IF @NuloCopia = 1
					SELECT @Ok = 99992
				ELSE
					EXEC spValidarCantidadDevMAVI @ID
												 ,@Modulo
												 ,@Ok OUTPUT
												 ,@OkRef OUTPUT

			END

		END

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Solicitud Compra')
		BEGIN

			IF EXISTS (SELECT C.Id FROM CompraD CD WITH(NOLOCK) INNER JOIN Compra C WITH(NOLOCK) ON CD.Id = C.ID INNER JOIN Art A WITH(NOLOCK) ON CD.Articulo = A.Articulo WHERE C.Planeador = 0 AND A.Categoria = 'VENTA' AND C.Id = @Id)
				SELECT @Ok = 99990

		END

		IF @MovTipo IN ('COMS.F', 'COMS.EI', 'COMS.EG')
		BEGIN
			SELECT @Clave = Clave
			FROM MovTipo WITH(NOLOCK)
			WHERE Modulo = 'COMS'
			AND Mov = @Origen

			IF @Clave = 'COMS.O'
			BEGIN
				SELECT @IDOrigen = ID
				FROM Compra WITH(NOLOCK)
				WHERE Mov = @Origen
				AND MovID = @OrigenID
				DECLARE
					CRDetalle
					CURSOR LOCAL FOR
					SELECT Articulo
						  ,ISNULL(Costo, 0)
						  ,Almacen
					FROM CompraD WITH(NOLOCK)
					WHERE ID = @ID
				OPEN CRDetalle
				FETCH NEXT FROM CRDetalle INTO @Articulo, @Costo, @Almacen
				WHILE @@FETCH_STATUS <> -1
				BEGIN

				IF @@FETCH_STATUS <> -2
				BEGIN
					SELECT @CostoAnt = ISNULL(Costo, 0)
					FROM CompraD WITH(NOLOCK)
					WHERE ID = @IDOrigen
					AND Articulo = @Articulo

					IF @Costo > @CostoAnt
					BEGIN
						SET @Ok = 80110
						SET @OkRef = 'Movimiento bloqueado: El costo excede al m ximo indicado en la orden de Compra. Art¡culo: ' + CAST(@Articulo AS VARCHAR(50)) + ' Costo:$' + CAST(@Costo AS VARCHAR(15))
					END

				END

				FETCH NEXT FROM CRDetalle INTO @Articulo, @Costo, @Almacen
				END
				CLOSE CRDetalle
				DEALLOCATE CRDetalle
			END

		END

	END

	IF @Modulo = 'CXC'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		SELECT @AplicaManual = AplicaManual
			  ,@Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@Concepto = Concepto
		FROM CXC WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @AplicaManualCxc = AplicacionManualCxcMAVI
		FROM UsuarioCfg2 WITH(NOLOCK)
		WHERE Usuario = @Usuario
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo

		IF (@AplicaManual = 0 AND EXISTS (SELECT ID FROM CxcD WITH(NOLOCK) WHERE ID = @ID) AND @Mov <> 'Sol Refinanciamiento')
			DELETE FROM CxcD
			WHERE ID = @ID

		IF @Mov IN ('Nota Cargo')
			EXEC spValidarMayor12meses @ID
									  ,@Mov
									  ,'CXC'

		IF NOT EXISTS (SELECT COUNT(*) FROM NegociaMoratoriosMAVI WITH(NOLOCK) WHERE IDCobro = @ID)
			AND @Origen IS NULL
			AND (@AplicaManualCxc = 0 OR @AplicaManualCxc IS NULL)
			AND @MovTipo = 'CXC.C'
		BEGIN
			SET @Ok = 100029
		END
		ELSE

		IF (@AplicaManualCxc = 0 OR @AplicaManualCxc IS NULL)
			AND @MovTipo = 'CXC.C'
			AND @Origen IS NOT NULL
		BEGIN
			SET @Ok = 100022
		END
		ELSE

		IF @Origen IS NULL
			AND (@AplicaManualCxc = 0 OR @AplicaManualCxc IS NULL)
			AND @MovTipo = 'CXC.C'
			AND (
				SELECT COUNT(*)
				FROM NegociaMoratoriosMAVI WITH(NOLOCK)
				WHERE IDCobro = @ID
			)
			= 0
		BEGIN
			SET @Ok = 100029
		END

		IF @MovTipo = 'CXC.C'
		BEGIN
			SELECT @TipoCobro = TipoCobro
			FROM TipoCobroMAVI WITH(NOLOCK)
			WHERE IdCobro = @ID

			IF @TipoCobro = 0
			BEGIN
				DECLARE
					crCobroP
					CURSOR FOR
					SELECT Origen
						  ,OrigenID
					FROM NegociaMoratoriosMAVI WITH(NOLOCK)
					WHERE IDCobro = @ID
					GROUP BY Origen
							,OrigenId
				OPEN crCobroP
				FETCH NEXT FROM crCobroP INTO @Origen, @OrigenID
				WHILE @@FETCH_STATUS <> -1
				BEGIN

				IF @@FETCH_STATUS <> -2
				BEGIN
					SELECT @FechaCobroAntxpol = dbo.fnfechasinhora(FechaEmision)
					FROM CXC WITH(NOLOCK)
					WHERE ID = (
						SELECT MAX(IDCobro)
						FROM NegociaMoratoriosMAVI WITH(NOLOCK)
						WHERE Origen = @Origen
						AND OrigenID = @OrigenID
						AND IDCobro < @ID
						AND IDCobro IN (SELECT t.IDCobro FROM TipoCobroMAVI t WITH(NOLOCK) WHERE t.TipoCobro = 1)
					)

					IF dbo.fnfechaSinHora(@FechaCobroAntxpol) = dbo.fnfechaSinHora(GETDATE())
					BEGIN
						SET @Ok = '100036'
						SET @OkRef = 'Ya existe un cobro previo por politica'
					END

				END

				FETCH NEXT FROM crCobroP INTO @Origen, @OrigenID
				END
				CLOSE crCobroP
				DEALLOCATE crCobroP
			END

		END

		IF @Estatus = 'SINAFECTAR'
			AND (@MovTipo IN ('CXC.C', 'CXC.DP') OR @Mov = 'Cheque Posfechado')
			AND @AplicaManual = 1
			AND @OK IS NULL
			AND NOT EXISTS (SELECT idCobro FROM NegociaMoratoriosMavi WITH(NOLOCK) WHERE idCobro = @id)
		BEGIN
			CREATE TABLE #temp2 (
				Origen VARCHAR(20)
			   ,OrigenID VARCHAR(20)
			   ,Mov VARCHAR(20)
			   ,MovID VARCHAR(20)
			   ,Vencimiento DATETIME
			)
			CREATE TABLE #cobro (
				Mov VARCHAR(20) NOT NULL
			   ,MovID VARCHAR(20) NOT NULL
			   ,importeCobro MONEY NULL
			)
			CREATE TABLE #cobroAplica (
				idmov INT
			   ,Mov VARCHAR(20) NOT NULL
			   ,MovID VARCHAR(20) NOT NULL
			   ,PadreMavi VARCHAR(20) NULL
			   ,PadreMaviID VARCHAR(20) NULL
			   ,concepto VARCHAR(50) NULL
			   ,NumDoc INT NULL
			   ,listo BIT DEFAULT 0
			   ,idVence INT
			   ,importeCobro MONEY NULL
			   ,Saldo MONEY NULL
			   ,Vencimiento DATETIME
			)
			INSERT INTO #cobro (Mov, MovID, importeCobro)
				SELECT Aplica
					  ,AplicaID
					  ,Importe
				FROM CxcD WITH(NOLOCK)
				WHERE ID = @ID
				AND Aplica IN ('Documento', 'Contra Recibo', 'Contra Recibo Inst', 'Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
			INSERT INTO #cobroAplica (idmov, Mov, MovID, PadreMavi, PadreMaviID, concepto, Vencimiento, numDoc, idVence, importeCobro, Saldo)
				SELECT c.id
					  ,ca.mov
					  ,ca.MovID
					  ,c.PadreMAVI
					  ,c.PadreIDMAVI
					  ,c.Concepto
					  ,c.Vencimiento
					  ,COUNT(0) OVER (PARTITION BY c.PadreMAVI, c.PadreIDMAVI)
					  ,ROW_NUMBER() OVER (PARTITION BY c.PadreMAVI, c.PadreIDMAVI ORDER BY c.Vencimiento)
					  ,ca.importeCobro
					  ,c.Saldo
				FROM cxc c WITH(NOLOCK)
				JOIN #cobro ca
					ON ca.Mov = c.Mov
					AND ca.MovID = c.MovID
				WHERE (c.Mov IN ('Documento', 'Contra Recibo', 'Contra Recibo Inst') OR (c.mov IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo') AND c.Concepto IN ('CANC COBRO FACTURA', 'CANC COBRO FACTURA VIU', 'CANC COBRO MAYOREO', 'CANC COBRO CRED Y PP', 'CANC COBRO SEG AUTO', 'CANC COBRO SEG VIDA')))
				AND c.Estatus NOT IN ('CANCELADO')
			DECLARE
				crCxcD
				CURSOR FOR
				SELECT ca.PadreMavi
					  ,ca.PadreMaviID
					  ,ca.NumDoc
				FROM #cobroAplica ca
				GROUP BY ca.PadreMavi
						,ca.PadreMaviID
						,ca.NumDoc
			OPEN crCxcD
			FETCH NEXT FROM crCxcD INTO @PadreMavi, @PadreMaviID, @contfinal
			WHILE @@FETCH_STATUS <> -1
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN
				SELECT @cont = 1
				WHILE @cont <= @contfinal
				BEGIN
				SELECT @Aplica = mov
					  ,@AplicaID = ca.MovID
					  ,@Vencimiento = Vencimiento
					  ,@idAux = ca.idmov
				FROM #cobroAplica ca
				WHERE ca.PadreMavi = @PadreMavi
				AND ca.PadreMaviID = @PadreMaviID
				AND ca.idVence = @cont

				IF @Aplica IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
				BEGIN
					INSERT INTO #temp2
						SELECT PadreMAVI
							  ,PadreIDMAVI
							  ,mov
							  ,MovID
							  ,Vencimiento
						FROM cxc WITH(NOLOCK)
						WHERE id IN (SELECT id FROM MovCampoExtra WITH(NOLOCK) WHERE Modulo = 'CXC' AND Valor = @PadreMavi + '_' + @PadreMaviID)
						AND Estatus IN ('PENDIENTE')
						AND id <> @idAux
						AND Vencimiento < @Vencimiento
						AND id NOT IN (SELECT idmov FROM #cobroAplica ca WHERE PadreMavi = @PadreMavi AND PadreMaviID = @PadreMaviID AND ca.listo = 1)
						ORDER BY Vencimiento DESC
				END
				ELSE
				BEGIN
					INSERT INTO #temp2
						SELECT Origen
							  ,OrigenID
							  ,Mov
							  ,MovID
							  ,Vencimiento
						FROM CxcPendiente WITH(NOLOCK)
						WHERE Origen = @PadreMavi
						AND OrigenID = @PadreMaviID
						AND NOT (MovID = @AplicaID AND Mov = @Aplica)
						AND Vencimiento < @Vencimiento
						AND id NOT IN (SELECT idmov FROM #cobroAplica ca WHERE PadreMavi = @PadreMavi AND PadreMaviID = @PadreMaviID AND ca.listo = 1)
						ORDER BY Vencimiento ASC
				END

				IF @cont <> @contfinal
				BEGIN
					UPDATE #cobroAplica
					SET listo = 1
					WHERE importeCobro = Saldo
					AND PadreMavi = @PadreMavi
					AND PadreMaviID = @PadreMaviID
					AND idVence = @cont
				END

				SELECT @cont = @cont + 1
				END

				IF EXISTS (SELECT Vencimiento FROM #temp2)
				BEGIN
					SELECT @Ok = 100020
				END

			END

			FETCH NEXT FROM crCxcD INTO @PadreMavi, @PadreMaviID, @contfinal
			END
			CLOSE crCxcD
			DEALLOCATE crCxcD
		END

		IF @Mov IN ('Nota Credito', 'Nota Credito VIU', 'Nota Credito Mayoreo', 'Cancela Prestamo', 'Cancela Credilana')
			AND @Concepto LIKE 'CORR COBRO%'
		BEGIN

			IF (
					SELECT COUNT(*)
					FROM (
						SELECT DISTINCT Padre.ID
						FROM CXC c WITH(NOLOCK)
						JOIN CXCd d WITH(NOLOCK)
							ON d.ID = c.ID
						JOIN CXC f WITH(NOLOCK)
							ON f.Mov = d.Aplica
							AND f.MovID = d.AplicaID
						JOIN CXC Padre WITH(NOLOCK)
							ON Padre.Mov = f.PadreMAVI
							AND Padre.MovID = f.PadreIDMAVI
						WHERE c.ID = @ID
					) AS Padres
				)
				> 1
				SELECT @OK = 100035

		END

	END

	IF @Modulo = 'CXC'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
		AND @OK IS NULL
	BEGIN
		SELECT @Agente = Agente
			  ,@Financiamiento = Financiamiento
			  ,@Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@SaldoTotal = (ISNULL(Importe, 0) + ISNULL(Impuestos, 0))
		FROM CXC WITH(NOLOCK)
		WHERE ID
		=
		@ID
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo
		SELECT @ImporteTotal = Importe
		FROM CXC WITH(NOLOCK)
		WHERE ID = @ID

		IF @Mov = 'Cobro'
		BEGIN

			IF (
					SELECT ValorAfectar
					FROM CXC WITH(NOLOCK)
					WHERE ID = @ID
				)
				= 1
			BEGIN

				IF ISNULL(@ImporteTotal, 0) = 0
				BEGIN
					SELECT @Ok = 40140
				END

				IF (
						SELECT AplicaManual
						FROM CXC WITH(NOLOCK)
						WHERE ID = @ID
					)
					<> 1
					AND ISNULL(@ImporteTotal, 0) <> 0
				BEGIN
					SELECT @Ok = 20170
				END

				UPDATE Cxc WITH(ROWLOCK)
				SET ValorAfectar = 0
				WHERE id = @ID
			END

		END

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Dev Anticipo Contado', 'Devolucion Apartado')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END

		IF @Mov = 'Aplicacion'
		BEGIN
			EXEC spValidarCtasIncobrableMAVI @ID
											,@Mov
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,0
		END
		ELSE

		IF (@Mov IN ('Nota Credito Mayoreo', 'Nota Credito', 'Nota Credito VIU', 'Cancela Credilana', 'Cancela Prestamo', 'Cancela Seg Auto', 'Cancela Seg Vida'))
		BEGIN
			EXEC spValidarCtasIncobrableMAVI @ID
											,@Mov
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,0
		END

		IF @Mov IN ('Prestamo', 'Diversos Deudores')
		BEGIN
			SELECT @PrefijoCte = SUBSTRING(Cte.Cliente, 1, 1)
				  ,@TipoCte = Cte.Tipo
				  ,@Condicion = Cxc.Condicion
				  ,@CteEnviarA = Cxc.ClienteEnviarA
			FROM CTE WITH(NOLOCK)
				,CXC WITH(NOLOCK)
			WHERE Cte.Cliente = Cxc.Cliente
			AND Cxc.ID = @ID
			SELECT @Condicion2 = Cadena
			FROM VentasCanalMAVI WITH(NOLOCK)
			WHERE ID = @CteEnviarA

			IF @TipoCte <> 'Deudor'
				OR @PrefijoCte <> 'D'
				OR @Condicion2 <> 'CONTADO MA'
				OR @CteEnviarA <> 2
				OR @Condicion <> 'CONTADO DEUDOR'
			BEGIN
				SELECT @Ok = 99990
			END

		END

		IF @Mov = 'Cobro Div Deudores'
		BEGIN
			SELECT @PrefijoCte = SUBSTRING(Cte.Cliente, 1, 1)
				  ,@TipoCte = Cte.Tipo
				  ,@Condicion = Cxc.Condicion
				  ,@CteEnviarA = Cxc.ClienteEnviarA
			FROM CTE WITH(NOLOCK)
				,CXC WITH(NOLOCK)
			WHERE Cte.Cliente = Cxc.Cliente
			AND Cxc.ID = @ID
			SELECT @Condicion2 = Cadena
			FROM VentasCanalMAVI WITH(NOLOCK)
			WHERE ID = @CteEnviarA

			IF @TipoCte <> 'Deudor'
				OR @PrefijoCte <> 'D'
				OR @Condicion2 <> 'CONTADO MA'
				OR @CteEnviarA <> 2
			BEGIN
				SELECT @Ok = 99990
			END

		END

		IF ((
				SELECT DB_NAME()
			)
			= 'MAVICOB')

			IF @Mov = 'Documento'
				AND @Estatus = 'SINAFECTAR'
				AND @MovTipo = 'CXC.D'
				SELECT @Ok = 60160

		IF ((
				SELECT DB_NAME()
			)
			= 'INTELISISTMP')

			IF @Mov = 'Documento'
				AND @Estatus = 'SINAFECTAR'
				SELECT @Ok = 60160

		IF @Mov = 'Contra Recibo Inst'
			AND @Estatus = 'SINAFECTAR'
		BEGIN

			IF (
					SELECT COUNT(ID)
					FROM CxcD WITH(NOLOCK)
					WHERE ID = @ID
				)
				> 1
				SELECT @Ok = 100001

			IF EXISTS (SELECT ID FROM CxcD WITH(NOLOCK) WHERE ID = @ID AND Aplica IN ('Contra Recibo Inst', 'Cta Incobrable F', 'Cta Incobrable NV'))
				SELECT @Ok = 100002

		END

		IF @MovTipo = 'CXC.FAC'
			AND @Estatus = 'SINAFECTAR'
		BEGIN

			IF EXISTS (SELECT ID FROM Cxc WITH(NOLOCK) WHERE ID = @ID AND MovAplica IN ('Contra Recibo Inst', 'Cta Incobrable F', 'Cta Incobrable NV'))
				SELECT @Ok = 100003
			ELSE
				EXEC spValidarCtasIncobrableMAVI @ID
												,'Endoso'
												,@Ok OUTPUT
												,@OkRef OUTPUT
												,0

		END

		IF @Mov IN ('Cta Incobrable NV')
			EXEC spValidarCtasIncobrableMAVI @ID
											,@Mov
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,1

		IF @Mov IN ('Cta Incobrable F')
			EXEC spValidarCtasIncobrableMAVI @ID
											,@Mov
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,1

		IF @Mov = 'React Incobrable F'
		BEGIN

			IF EXISTS (SELECT CD.ID FROM CxcD CD WITH(NOLOCK) WHERE CD.ID = @ID AND CD.Aplica NOT IN ('Cta Incobrable F'))
				SELECT @Ok = 100002

			IF (
					SELECT COUNT(ID)
					FROM CxcD
					WHERE ID = @ID
				)
				> 1
				SELECT @Ok = 100001

		END

		IF @Mov = 'React Incobrable NV'
		BEGIN

			IF EXISTS (SELECT CD.ID FROM CxcD CD WITH(NOLOCK) WHERE CD.ID = @ID AND CD.Aplica NOT IN ('Cta Incobrable NV'))
				SELECT @Ok = 100002

			IF (
					SELECT COUNT(ID)
					FROM CxcD
					WHERE ID = @ID
				)
				> 1
				SELECT @Ok = 100001

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.AA')
		BEGIN
			SELECT @Ok =
			 CASE dbo.fnEsMismoCanalMAVI(@ID)
				 WHEN 0 THEN 100007
				 WHEN 2 THEN 100013
			 END

			IF (
					SELECT dbo.fnValidarValorAnticipoMAVI(@ID)
				)
				<> 1
				SELECT @Ok = 100008

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.DE')
		BEGIN
			EXEC xpValidarDevolucionMAVI @ID
										,@Ok OUTPUT

			IF (@OK IS NULL)
			BEGIN
				SELECT @ImporteTotal = Importe
				FROM Cxc WITH(NOLOCK)
				WHERE ID = @ID

				IF (@ImporteTotal IS NULL)
					SELECT @OK = 40140

			END

		END

		IF @Mov = 'Sol Refinanciamiento'
			AND @Estatus IN ('SINAFECTAR', 'PENDIENTE')
		BEGIN
			SELECT @ImporteARefinanciar = 0

			IF (
					SELECT ISNULL(Importe, 0.0)
					FROM Cxc WITH(NOLOCK)
					WHERE ID = @ID
				)
				<= 0.0
				SELECT @Ok = 99996

			IF @Ok = NULL

				IF EXISTS (SELECT CxcD.ID FROM CxcD WITH(NOLOCK) WHERE CxcD.ID = @ID AND dbo.fnIDDelMovimientoMAVI(CxcD.Aplica, CxcD.AplicaID) NOT IN (SELECT IDOrigen FROM MaviRefinaciamientos WITH(NOLOCK) WHERE ID = @ID))
					SELECT @Ok = 100015

			IF @Ok IS NULL
			BEGIN
				SELECT @ImporteARefinanciar = SUM(ISNULL(dbo.fnSaldoPendienteMovPadreMAVI(IDOrigen), 0))
				FROM MaviRefinaciamientos WITH(NOLOCK)
				WHERE ID = @ID

				IF ISNULL(@SaldoTotal, 0) <> ISNULL(@ImporteARefinanciar, 0)
					SELECT @Ok = 100016

			END

			IF @Ok IS NULL

				IF (@Agente IS NULL)
					OR (@Agente = '')
					OR (ISNULL(@Agente, '') = '')
					SELECT @Ok = 20930

		END

		IF @Mov = 'Refinanciamiento'
			AND ISNULL(@Origen, '') = ''
			AND ISNULL(@OrigenID, '') = ''
		BEGIN
			SET @Ok = 60160
			SELECT @Mensaje = Descripcion
			FROM MensajeLista WITH(NOLOCK)
			WHERE Mensaje = @Ok
		END

		IF @Mov = 'Refinanciamiento'
			AND @Estatus = 'SINAFECTAR'
		BEGIN
			UPDATE Cxc WITH(ROWLOCK)
			SET EsCredilana = 1
			WHERE ID = @ID
		END

		IF @Mov = 'Refinanciamiento'
			AND @Estatus = 'SINAFECTAR'
			AND @SaldoTotal = 0
		BEGIN
			SET @Ok = 99996
		END

		IF @Mov = 'Refinanciamiento'
			AND @Estatus = 'SINAFECTAR'
		BEGIN

			IF @Ok = NULL
			BEGIN
				SELECT @ImporteARefinanciar = NULL
				SELECT @IDOrigen = dbo.fnIDDelMovimientoMAVI(@Origen, @OrigenID)
				SELECT @ImporteARefinanciar = SUM(ISNULL(dbo.fnSaldoPendienteMovPadreMAVI(IDOrigen), 0))
				FROM MaviRefinaciamientos WITH(NOLOCK)
				WHERE ID = @IDorigen
				SELECT @SaldoTotal = ISNULL(@SaldoTotal, 0) - ISNULL(@Financiamiento, 0)

				IF ISNULL(@SaldoTotal, 0) <> ISNULL(@ImporteARefinanciar, 0)
					SELECT @Ok = 100016

			END

		END

		IF (@Mov IN ('Cta Incobrable F', 'Cta Incobrable NV') AND @Estatus = 'SINAFECTAR' AND @Ok IS NULL)
			EXEC spCtaIncMigraMaviCob @ID
									 ,@Usuario
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT

		IF (@MovTipo = 'CXC.NC' AND @Estatus = 'SINAFECTAR')
			EXEC spCambiaEstadoEnvioMaviCob @ID
										   ,@Accion

		IF (@Mov = 'Cheque Posfechado' AND @Ok IS NULL)
			EXEC spValidaAplicacionChequePos @ID
											,@Ok OUTPUT
											,@OkRef OUTPUT

	END

	IF @Modulo = 'CXC'
		AND @Accion = 'GENERAR'
	BEGIN
		SELECT @ImporteARefinanciar = 0
		SELECT @Financiamiento = Financiamiento
			  ,@CondRef = CondRef
			  ,@Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@SaldoTotal = (ISNULL(Importe, 0) + ISNULL(Impuestos, 0))
		FROM CXC WITH(NOLOCK)
		WHERE ID = @ID

		IF @Mov = 'Sol Refinanciamiento'
			AND @Estatus = 'PENDIENTE'
		BEGIN

			IF @Estatus = 'PENDIENTE'
				AND @Ok = NULL
			BEGIN

				IF (ISNULL(@CondRef, '') = '' OR @CondRef = '')
					SELECT @Ok = 100017

				IF @Financiamiento <= 0
					SELECT @Ok = 100018

			END

			IF @SaldoTotal <= 0.0
				SELECT @Ok = 99996

			IF @Ok = NULL

				IF EXISTS (SELECT CxcD.ID FROM CxcD WITH(NOLOCK) WHERE CxcD.ID = @ID AND dbo.fnIDDelMovimientoMAVI(CxcD.Aplica, CxcD.AplicaID) NOT IN (SELECT IDOrigen FROM MaviRefinaciamientos WITH(NOLOCK) WHERE ID = @ID))
					SELECT @Ok = 100015

			IF @Ok = NULL
			BEGIN
				SELECT @ImporteARefinanciar = SUM(ISNULL(dbo.fnSaldoPendienteMovPadreMAVI(IDOrigen), 0))
				FROM MaviRefinaciamientos WITH(NOLOCK)
				WHERE ID = @ID

				IF ISNULL(@SaldoTotal, 0) <> ISNULL(@ImporteARefinanciar, 0)
					SELECT @Ok = 100016

			END

		END

	END

	IF @Modulo = 'CXC'
		AND @Accion = 'CANCELAR'
	BEGIN
		EXEC spValidaNoCancelarCobrosIntermediosMAVI @Modulo
													,@ID
													,@Accion
													,@Base
													,@EnSilencio
													,@Ok OUTPUT
													,@OkRef OUTPUT
													,@FechaRegistro
		SELECT @Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
		FROM Cxc WITH(NOLOCK)
		WHERE ID = @ID

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.AA')
		BEGIN

			IF (
					SELECT ISNULL(SaldoAplicadoMavi, 0.0) + ISNULL(SaldoDevueltoMavi, 0.0)
					FROM Cxc WITH(NOLOCK)
					WHERE ID = @ID
				)
				> 0
				SET @Ok = 100009

		END

		IF @Mov = 'Aplicacion Saldo'
		BEGIN
			DECLARE
				@MovRef VARCHAR(50)
			   ,@MovIDRef VARCHAR(50)
			SELECT @MovRef = Aplica
				  ,@MovIDRef = AplicaID
			FROM CxcD WITH(NOLOCK)
			WHERE ID = @ID

			IF (
					SELECT Estatus
					FROM Cxc WITH(NOLOCK)
					WHERE Mov = @MovRef
					AND MovID = @MovIDRef
				)
				= 'Concluido'
				SET @Ok = 100010

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.C')
			 AND @Mov <> 'Cobro Div Deudores'--  Se verifica su fecha de emision
		BEGIN
			SELECT @FechaEmision = CONVERT(VARCHAR(8), FechaEmision, 112)
			FROM Cxc WITH(NOLOCK)
			WHERE ID = @ID

			IF @FechaEmision <> @FechaActual
			BEGIN
				SET @Ok = '60050'
			END

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.EST')
			AND @Mov = 'Sol Refinanciamiento'
		BEGIN
			SELECT @EstatusSol = Estatus
				  ,@MovSol = Mov
				  ,@MovIDSol = MovID
			FROM CXC WITH(NOLOCK)
			WHERE ID = @ID

			IF @EstatusSol IN ('CONCLUIDO', 'PENDIENTE')
			BEGIN

				IF EXISTS (SELECT Mov FROM CXC WHERE Origen = @MovSol AND OrigenID = @MovIDSol AND Mov = 'Refinanciamiento' AND estatus NOT IN ('CANCELADO'))
					SET @Ok = 30151

			END

		END

		IF (dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') = 'CXC.NC')
		BEGIN

			IF (
					SELECT h.Estatus
					FROM CXCD D WITH(NOLOCK)
					JOIN MOVTIPO M
						ON D.APLICA = M.MOV
						AND M.CLAVE = 'CXC.DM'
						AND M.MODULO = 'CXC'
					JOIN CXC C WITH(NOLOCK)
						ON C.MOV = D.APLICA
						AND C.MOVID = D.APLICAID
					JOIN CtasMaviCobHist H WITH(NOLOCK)
						ON C.ID = H.IDCtaIncobrable
					WHERE d.id = @id
				)
				= 'ENVIADO'
			BEGIN
				SELECT @ok = 100036
			END
			ELSE
			BEGIN
				EXEC spCambiaEstadoEnvioMaviCob @ID
											   ,@Accion
			END

		END

		IF (dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') = 'CXC.DM')
			AND @Accion = 'CANCELAR'
		BEGIN

			IF (
					SELECT Estatus
					FROM CtasMaviCobHist WITH(NOLOCK)
					WHERE IDCtaIncobrable = @ID
				)
				= 'ENVIADO'
				SELECT @ok = 100036

		END

	END

	IF @Modulo = 'EMB'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Agente = Agente
			  ,@Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
		FROM Embarque WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @NivelCobranza = NivelCobranzaMAVI
		FROM Agente WITH(NOLOCK)
		WHERE Agente = @Agente
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = @Modulo

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Embarque Mayoreo', 'Embarque', 'Embarque Sucursal', 'Embarque Magisterio')
			AND @Situacion IS NULL
		BEGIN
			SELECT @Ok = 99990
		END
		ELSE

		IF (@Mov = 'Orden Cobro' AND @Estatus = 'SINAFECTAR')

			IF EXISTS (SELECT Cx.Mov, Cx.MovID FROM EmbarqueD ED WITH(NOLOCK) JOIN EmbarqueMov EM WITH(NOLOCK) ON ED.EmbarqueMov = EM.ID AND EM.Modulo = 'CXC' JOIN Cxc Cx WITH(NOLOCK) ON EM.ModuloID = Cx.ID JOIN Cte Cte WITH(NOLOCK) ON Cte.Cliente = Cx.Cliente LEFT OUTER JOIN CteEnviarA E WITH(NOLOCK) ON E.ID = Cx.ClienteEnviarA AND E.Cliente = Cx.Cliente WHERE ED.ID = @ID AND ISNULL(E.NivelCobranzaMAVI, 'SIN NIVEL') <> @NivelCobranza)
				SELECT @Ok = 100014

		SELECT @Agente = Agente
			  ,@Mov = Mov
			  ,@Agente2 = Agente2
			  ,@Licencia = LicenciaAgente
			  ,@Licencia2 = LicenciaAgente2
			  ,@Ruta = Ruta
		FROM Embarque WITH(NOLOCK)
		WHERE ID = @ID

		IF (@Estatus = 'SINAFECTAR' AND @Mov <> 'Orden Cobro')
		BEGIN

			IF (LTRIM(RTRIM(@Agente)) IN ('', NULL))
				SELECT @Ok = 60260
					  ,@OkRef = ' Agente '

			IF (LTRIM(RTRIM(@licencia)) IN ('', NULL))
				SELECT @Ok = 60260
					  ,@OkRef = ' Licencia '

			IF (LTRIM(RTRIM(@Ruta)) IN ('', NULL))
				SELECT @Ok = 60260
					  ,@OkRef = ' Ruta '

			IF (@Agente2 NOT IN ('', NULL) AND LTRIM(RTRIM(@Licencia2)) IN ('', NULL))
				SELECT @Ok = 60260
					  ,@OkRef = ' Licencia Agente 2 '

		END

	END

	IF @Modulo = 'AF'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Estatus = Estatus
			  ,@Mov = Mov
			  ,@Situacion = Situacion
			  ,@Concepto = Concepto
			  ,@Personal = ISNULL(Personal, 'SINASIGNAR')
		FROM ActivoFijo WITH(NOLOCK)
		WHERE ID = @ID

		IF @Estatus = 'SINAFECTAR'
			AND @Mov IN ('Mantenimiento Ligero', 'Mantenimiento Severo')
			AND ((@Situacion IS NULL) OR (@Situacion = 'Por Autorizar'))
		BEGIN

			IF @Concepto = 'OMITIR MANNTO'
				SELECT @Ok = 99990

		END

		IF @Mov = 'Asignacion'
		BEGIN

			IF @Personal IN ('SINASIGNAR', ' ')
			BEGIN
				SELECT @Ok = 100027
			END

		END

		SELECT @Proveedor = Proveedor
		FROM ActivoFijo WITH(NOLOCK)
		WHERE ID = @ID

		IF (@Estatus = 'SINAFECTAR' AND @Mov IN ('Mannto Maquinaria', 'Mantenimiento', 'Mantenimiento Ligero', 'Mantenimiento Severo',
			'Poliza Mantenimiento', 'Poliza Seguro', 'Reparacion'))
		BEGIN

			IF (LTRIM(RTRIM(@Proveedor)) IN ('', NULL))
				SELECT @Ok = 40020

		END

	END

	IF @Modulo = 'VTAS'
		AND @Accion = 'AFECTAR'
	BEGIN
		SELECT @Mov = Mov
			  ,@Cliente = Cliente
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @ImporteTotal = SUM(ISNULL(Cantidad, 0) * ISNULL(Precio, 0))
		FROM VentaD WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Mov = @Mov
		AND Modulo = 'VTAS'

		IF @Mov IN ('Devolucion Venta', 'Devolucion Venta VIU', 'Devolucion Mayoreo', 'Cancela Credilana', 'Cancela Prestamo', 'Cancela Seg Auto', 'Cancela Seg Vida')
		BEGIN
			SELECT @mov = (
				 SELECT Origen
				 FROM Venta WITH(NOLOCK)
				 WHERE ID = @ID
			 )

			IF (
					SELECT Origen
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				= 'Sol Dev Unicaja'
			BEGIN
				EXEC xpValidarMovSolDevUnicaja @ID
											  ,@Ok OUTPUT
											  ,2
			END
			ELSE

			IF (
					SELECT Origen
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				= 'Solicitud Devolucion'
			BEGIN
				EXEC xpValidarMovSolDevolucion @ID
											  ,@Ok OUTPUT
											  ,2
			END
			ELSE

			IF (
					SELECT Origen
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				= 'Sol Dev Mayoreo'
			BEGIN
				EXEC xpValidarMovSolDevolucion @ID
											  ,@Ok OUTPUT
											  ,4
			END

		END

		IF @ImporteTotal <= 0
			AND dbo.fnClaveAfectacionMAVI(@Mov, 'VTAS') IN ('VTAS.P', 'VTAS.F')
			SELECT @Ok = 99996

		IF @Mov NOT IN ('Analisis Mayoreo', 'Solicitud Mayoreo', 'Analisis Credito', 'Solicitud Credito')
		BEGIN
			SELECT @TipoCte = Tipo
			FROM Cte WITH(NOLOCK)
			WHERE Cliente = @Cliente
			SELECT @PrefijoCte = LEFT(@Cliente, 1)

			IF @PrefijoCte = 'P'
				OR @TipoCte = 'Prospecto'
				SELECT @Ok = 99991

		END
		ELSE
		BEGIN

			IF @Mov IN ('Analisis Credito', 'Solicitud Credito')

				IF EXISTS (SELECT * FROM Venta V WITH(NOLOCK) LEFT OUTER JOIN Condicion C WITH(NOLOCK) ON V.Condicion = C.Condicion WHERE V.ID = @ID AND C.TipoCondicion = 'Contado')
					SELECT @Ok = 99997

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'VTAS') IN ('VTAS.D', 'VTAS.SD')
		BEGIN

			IF @Mov = 'Sol Dev Unicaja'
			BEGIN

				IF EXISTS (SELECT IDCopiaMavi FROM VentaD WITH(NOLOCK) WHERE IdCopiaMavi IS NOT NULL AND ID = @ID)
					SELECT @Ok = 99995
				ELSE
				BEGIN
					EXEC xpValidarMovSolDevUnicaja @ID
												  ,@Ok OUTPUT
												  ,1
					SELECT @NuloCopia = 0
					SELECT @GpoTrabajo = GrupoTrabajo
					FROM Usuario WITH(NOLOCK)
					WHERE Usuario = @Usuario

					IF EXISTS (SELECT IDCopiaMavi FROM VentaD WITH(NOLOCK) WHERE ((IDCopiaMavi IS NULL) OR (IdCopiaMAVI = '')) AND ID = @ID)
						SELECT @NuloCopia = 1

					IF @NuloCopia = 1
						AND @GpoTrabajo NOT IN ('CONTABILIDAD')
						SELECT @Ok = 100028

				END

			END
			ELSE
			BEGIN

				IF (
						SELECT Origen
						FROM Venta WITH(NOLOCK)
						WHERE ID = @ID
					)
					<> 'Sol Dev Unicaja'
				BEGIN

					IF EXISTS (SELECT IDCopiaMavi FROM VentaD WITH(NOLOCK) WHERE IdCopiaMavi IS NULL AND ID = @ID)
						SELECT @Ok = 99992

				END

				IF (@Mov = 'Sol Dev Mayoreo')
				BEGIN
					EXEC xpValidarMovSolDevolucion @ID
												  ,@Ok OUTPUT
												  ,3
				END
				ELSE
				BEGIN
					EXEC xpValidarMovSolDevolucion @ID
												  ,@Ok OUTPUT
												  ,1
				END

				EXEC spValidarCantidadDevMAVI @ID
											 ,@Modulo
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

				IF @Mov IN ('Cancela Credilana', 'Cancela Prestamo')
					AND @Ok IS NULL
					EXEC spGenerarIngresoAlDevolverMAVI @ID
													   ,@Usuario
													   ,@Ok OUTPUT
													   ,@OkRef OUTPUT

			END

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'VTAS') IN ('VTAS.P', 'VTAS.F')
		BEGIN
			EXEC xpValidarSerieLoteMAVI @ID
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

			IF ISNULL((
					SELECT Agente
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				, '') = ''
				SELECT @Ok = 100004

		END

		IF @Mov IN ('Solicitud Mayoreo', 'Analisis Mayoreo', 'Pedido Mayoreo')
		BEGIN

			IF ISNULL((
					SELECT FormaEnvio
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				, '') = ''
				SELECT @Ok = 100005

		END

		IF @Mov = 'FACTURA MAYOREO'
		BEGIN

			IF 'ACTIVOS FIJOS' IN (SELECT a.categoria FROM art a WITH(NOLOCK), ventad vd WITH(NOLOCK) WHERE vd.ID = @ID AND a.articulo = vd.articulo)
			BEGIN
				DECLARE
					@Serie VARCHAR(20)
				   ,@Art VARCHAR(20)
				DECLARE
					AFSeries_Cursor
					CURSOR FOR
					SELECT SerieLote
						  ,Articulo
					FROM serielotemov WITH(NOLOCK)
					WHERE ID = @ID
				OPEN AFSeries_Cursor
				FETCH NEXT FROM AFSeries_Cursor
				INTO @Serie, @Art
				WHILE @@FETCH_STATUS = 0
				AND @Ok IS NULL
				BEGIN

				IF (
						SELECT responsable
						FROM ActivoF WITH(NOLOCK)
						WHERE Serie = @Serie
						AND Articulo = @Art
					)
					<> NULL
					SELECT @Ok = 100024

				FETCH NEXT FROM AFSeries_Cursor
				INTO @Serie, @Art
				END
				CLOSE AFSeries_Cursor
				DEALLOCATE AFSeries_Cursor
			END

			IF ISNULL((
					SELECT FormaEnvio
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				, '') = ''
				SELECT @Ok = 100005

		END

		IF (@Mov IN ('Solicitud Credito', 'Pedido', 'Solicitud Mayoreo'))
		BEGIN
			SELECT @Cliente = Cliente
			FROM Venta WITH(NOLOCK)
			WHERE ID = @ID

			IF ((
					SELECT FacDesgloseIVA
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				)
				= 1)
			BEGIN
				SELECT @RFCCompleto = dbo.fnValidaRFC(@Cliente)

				IF (@RFCCompleto = 1)
					SELECT @OK = 80110
						  ,@OKRef = 'El RFC del Cliente No Está Completo'

				IF (@RFCCompleto = 2)
					SELECT @OK = 80110
						  ,@OKRef = 'El RFC del Cliente Está Incorrecto'

			END

		END

		IF @Mov IN ('Solicitud Devolucion', 'Sol Dev Mayoreo')
		BEGIN
			SELECT @DevOrigen = ISNULL(IDCopiaMavi, 0)
			FROM VentaD WITH(NOLOCK)
			WHERE ID = @ID
			SELECT @FacDesgloseIVA = FacDesgloseIVA
			FROM Venta WITH(NOLOCK)
			WHERE Id = @DevOrigen
			UPDATE Venta WITH(ROWLOCK)
			SET FacDesgloseIVA = @FacDesgloseIVA
			WHERE ID = @ID
		END

		IF @Mov IN ('Solicitud Credito', 'Analisis Credito', 'Pedido', 'Factura', 'Factura VIU')
			EXEC spValidarMayor12meses @ID
									  ,@Mov
									  ,'VTAS'

		SELECT @Estatus = Estatus
			  ,@Origen = Origen
			  ,@OrigenId = OrigenID
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'VTAS') IN ('VTAS.P')
			AND @Origen IS NULL
			AND @OrigenID IS NULL
			AND @Estatus = 'SINAFECTAR'
		BEGIN
			SELECT @Redime = RedimePtos
			FROM Venta WITH(NOLOCK)
			WHERE ID = @ID
			DECLARE
				crArtPrecio
				CURSOR LOCAL FORWARD_ONLY FOR
				SELECT Renglon
					  ,D.Articulo
					  ,Precio
					  ,D.PrecioAnterior
					  ,A.Estatus
				FROM VentaD D WITH(NOLOCK)
				LEFT JOIN Art A WITH(NOLOCK)
					ON A.Articulo = D.Articulo
					AND A.Familia = 'Calzado'
					AND A.Estatus = 'Bloqueado'
				WHERE ID = @ID
			OPEN crArtPrecio
			FETCH NEXT FROM crArtPrecio INTO @Renglon, @ArtP, @PrecioArt, @PrecioAnterior, @bloq
			WHILE @@FETCH_STATUS <> -1
			AND @Ok IS NULL
			BEGIN

			IF @@FETCH_STATUS <> -2
				AND NULLIF(@ArtP, '') IS NOT NULL
			BEGIN
				SET @Precio = dbo.fnPropreprecio(@ID, @ArtP, @Renglon, @Redime)

				IF (ISNULL(@PrecioAnterior, @PrecioArt) <> @Precio)
					AND (@bloq <> 'Bloqueado')
					AND (@suc NOT IN (SELECT Nombre FROM TablaStD WITH(NOLOCK) WHERE TablaSt = 'SUCURSALES LINEA')
					)
					SELECT @Ok = 20305
						  ,@OkRef = RTRIM(@ArtP)

			END

			FETCH NEXT FROM crArtPrecio INTO @Renglon, @ArtP, @PrecioArt, @PrecioAnterior, @bloq
			END
			CLOSE crArtPrecio
			DEALLOCATE crArtPrecio
		END

		IF (dbo.fnClaveAfectacionMAVI(@Mov, 'VTAS') IN ('VTAS.P') AND (
				SELECT Origen
				FROM Venta WITH(NOLOCK)
				WHERE ID = @ID
			)
			IS NULL AND @Ok IS NULL)
		BEGIN
			EXEC spValidaVentaSinImpuestosMAVI @ID
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT
		END

	END

	IF @Modulo = 'VTAS'
		AND @Accion = 'CANCELAR'
	BEGIN
		SELECT @Mov = Mov
			  ,@Estatus = Estatus
			  ,@DineroID = IDIngresoMAVI
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID

		IF EXISTS (SELECT VD.ID FROM VentaD VD WITH(NOLOCK) INNER JOIN Venta V WITH(NOLOCK) ON VD.ID = V.ID WHERE VD.IDCopiaMavi = @ID AND V.Estatus NOT IN ('CANCELADO', 'SINAFECTAR'))
			SELECT @Ok = 100000

		IF EXISTS (SELECT EM.AsignadoID FROM EmbarqueMov EM WITH(NOLOCK) INNER JOIN Embarque E WITH(NOLOCK) ON EM.AsignadoID = E.ID WHERE EM.ModuloID = @ID AND EM.Modulo = 'VTAS' AND E.Estatus NOT IN ('CANCELADO', 'SINAFECTAR'))
			SELECT @Ok = 100000

		IF @Mov IN ('Cancela Credilana', 'Cancela Prestamo')
		BEGIN

			IF EXISTS (SELECT ID FROM Dinero WITH(NOLOCK) WHERE ID = @DineroID AND Estatus IN ('PENDIENTE', 'CONCLUIDO'))
				SELECT @Ok = 60060

		END

	END

	IF @Modulo = 'CXC'
		AND ISNULL(@Accion, '') IN ('CANCELAR', 'AFECTAR')
		AND ISNULL(@Ok, 0) = 0
		AND EXISTS (SELECT ID FROM CXC WITH(NOLOCK) WHERE ID = @ID AND ((Mov IN (SELECT DISTINCT MovCargo FROM TcIDM0224_ConfigNotasEspejo WITH(NOLOCK) UNION ALL SELECT DISTINCT MovCredito FROM TcIDM0224_ConfigNotasEspejo WITH(NOLOCK)) AND ISNULL(Concepto, '') IN (SELECT DISTINCT ConceptoCargo FROM TcIDM0224_ConfigNotasEspejo WITH(NOLOCK) UNION ALL SELECT DISTINCT ConceptoCredito FROM TcIDM0224_ConfigNotasEspejo WITH(NOLOCK))) OR Mov = 'Aplicacion') AND Estatus NOT IN ('CANCELADO'))
	BEGIN
		EXEC dbo.SP_MAVIDM0224NotaCreditoEspejo @ID
											   ,@Accion
											   ,@Usuario
											   ,@Ok OUTPUT
											   ,@OkRef OUTPUT
											   ,'ANTES'
	END

	RETURN

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#ValidaConceptoGas') AND TYPE = 'U')
		DROP TABLE #ValidaConceptoGas

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#cobro') AND TYPE = 'U')
		DROP TABLE #cobro

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#cobroAplica') AND TYPE = 'U')
		DROP TABLE #cobroAplica

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#temp2') AND TYPE = 'U')
		DROP TABLE #temp2

END
GO