SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spTipoPagoBonifMAVI]
 @SugerirPago VARCHAR(20)
,@ID INT
AS
BEGIN
	DECLARE
		@Empresa CHAR(5)
	   ,@Sucursal INT
	   ,@Hoy DATETIME
	   ,@Vencimiento DATETIME
	   ,@DiasCredito INT
	   ,@DiasVencido INT
	   ,@TasaDiaria FLOAT
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Contacto CHAR(10)
	   ,@Renglon FLOAT
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@AplicaMovTipo VARCHAR(20)
	   ,@Capital MONEY
	   ,@Intereses MONEY
	   ,@InteresesOrdinarios MONEY
	   ,@InteresesFijos MONEY
	   ,@InteresesMoratorios MONEY
	   ,@ImpuestoAdicional FLOAT
	   ,@Importe MONEY
	   ,@SumaImporte MONEY
	   ,@Impuestos MONEY
	   ,@DesglosarImpuestos BIT
	   ,@LineaCredito VARCHAR(20)
	   ,@Metodo INT
	   ,@GeneraMoratorioMAVI CHAR(1)
	   ,@MontoMinimoMor FLOAT
	   ,@CondonaMoratorios INT
	   ,@IDDetalle INT
	   ,@ImpReal MONEY
	   ,@MoratorioAPagar MONEY
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@TipoPago CHAR(1)
	   ,@ImporteReal MONEY
	   ,@ImporteAPagar MONEY
	   ,@DocsPend INT
	   ,@DocsPendNeg INT
	   ,@NotasCargoCanc INT
	   ,@Padre VARCHAR(20)
	   ,@PadreID VARCHAR(20)
	   ,@min INT
	   ,@max INT
	SELECT @Empresa = Empresa
		  ,@Sucursal = Sucursal
		  ,@Hoy = FechaEmision
		  ,@Moneda = Moneda
		  ,@TipoCambio = TipoCambio
		  ,@Contacto = Cliente
	FROM Cxc WITH(NOLOCK)
	WHERE ID = @ID

	IF @SugerirPago = 'SALDO TOTAL'
		SELECT @TipoPago = 'T'

	UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
	SET TipoPago = @TipoPago
	WHERE IDCobro = @ID

	IF @SugerirPago <> 'SALDO TOTAL'
	BEGIN
		DECLARE
			@crFactLiq AS TABLE (
				ID INT IDENTITY (1, 1)
			   ,Mov VARCHAR(25)
			   ,MovId VARCHAR(25)
			   ,ImporteReal MONEY
			   ,ImportePagar MONEY
			   ,Origen VARCHAR(25)
			   ,OrigenId VARCHAR(25)
			)
		INSERT INTO @crFactLiq (Mov, MovId, ImporteReal, ImportePagar, Origen, OrigenId)
			SELECT Mov
				  ,MovID
				  ,ImporteReal
				  ,ImporteAPagar
				  ,Origen
				  ,OrigenId
			FROM NegociaMoratoriosMAVI WITH(NOLOCK)
			WHERE IDCobro = @ID
		SELECT @min = MIN(ID)
			  ,@max = MAX(ID)
		FROM @crFactLiq
		WHILE @min <= @max
		BEGIN
		SELECT @Aplica = Mov
			  ,@AplicaID = MovId
			  ,@ImporteReal = ImporteReal
			  ,@ImporteAPagar = ImportePagar
			  ,@Origen = Origen
			  ,@OrigenID = OrigenId
		FROM @crFactLiq
		WHERE ID = @min

		IF @Origen <> NULL
		BEGIN
			SELECT @DocsPend = 0
				  ,@DocsPendNeg = 0
				  ,@NotasCargoCanc = 0
			SELECT @DocsPend = COUNT(*)
			FROM Cxc WITH(NOLOCK)
			WHERE PadreMAVI = @Origen
			AND PAdreIDMAVI = @OrigenID
			AND Estatus = 'PENDIENTE'
			SELECT @DocsPendNeg = COUNT(*)
			FROM NegociaMoratoriosMAVI WITH(NOLOCK)
			WHERE Origen = @Origen
			AND OrigenID = @OrigenID
			AND IDCobro = @ID
			AND ImporteReal = ImporteAPagar

			IF @DocsPend = @DocsPendNeg
			BEGIN
				UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
				SET TipoPago = 'T'
				WHERE Origen = @Origen
				AND OrigenID = @OrigenID
				AND IDCobro = @ID
				AND ImporteReal = ImporteAPagar
			END

		END
		ELSE
		BEGIN
			SELECT @IDDetalle = ID
			FROM CXC WITH(NOLOCK)
			WHERE Mov = @Aplica
			AND MovId = @AplicaID
			SELECT @DocsPend = 0
				  ,@DocsPendNeg = 0
			SELECT @DocsPend = COUNT(*)
			FROM Cxc WITH(NOLOCK)
			WHERE PadreMAVI = @Origen
			AND PadreIDMavi = @OrigenID
			AND OrigenTipo = 'CXC'
			AND Estatus = 'PENDIENTE'
			SELECT @DocsPendNeg = COUNT(*)
			FROM NegociaMoratoriosMAVI WITH(NOLOCK)
			WHERE Origen = @Origen
			AND OrigenID = @OrigenID
			AND IDCobro = @ID
			AND ImporteReal = ImporteAPagar

			IF @DocsPend = @DocsPendNeg
				UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
				SET TipoPago = 'T'
				WHERE Origen = @Origen
				AND OrigenID = @OrigenID
				AND IDCobro = @ID
				AND ImporteReal = ImporteAPagar

		END

		SET @min = @min + 1
		END
	END

	RETURN
END
GO
