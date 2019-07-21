SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSugerirVentaCobroEfectivo]
 @ID INT
,@EnSilencio BIT = 0
,@Saldo MONEY = NULL OUTPUT
,@Mov VARCHAR(20) = NULL
AS
BEGIN
	DECLARE
		@Empresa CHAR(5)
	   ,@Cliente CHAR(10)
	   ,@Moneda CHAR(10)
	   ,@OrigenTipo CHAR(10)
	   ,@Origen CHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@Aplicado MONEY
	SELECT @Saldo = NULL
	SELECT @Empresa = Empresa
		  ,@Cliente = Cliente
		  ,@Moneda = Moneda
		  ,@OrigenTipo = OrigenTipo
		  ,@Origen = Origen
		  ,@OrigenID = OrigenID
	FROM Venta
	WHERE ID = @ID

	IF @OrigenTipo = 'VTAS'
	BEGIN

		IF EXISTS (SELECT * FROM Venta v, Condicion c, MovTipo mt WHERE v.Empresa = @Empresa AND v.Mov = @Origen AND v.MovID = @OrigenID AND Cliente = @Cliente AND v.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND v.Condicion = c.Condicion AND UPPER(c.ControlAnticipos) IN ('ABIERTO', 'PLAZOS', 'FECHA REQUERIDA') AND mt.Mov = v.Mov AND mt.Modulo = 'VTAS' AND mt.Clave IN ('VTAS.P', 'VTAS.S'))
		BEGIN
			SELECT @Saldo = 0.0
			SELECT @Saldo = ISNULL(SUM(Abono), 0.0)
			FROM Anticipo
			WHERE Cancelado = 0
			AND Empresa = @Empresa
			AND Cuenta = @Cliente
			AND Moneda = @Moneda
			AND Referencia = RTRIM(@Origen) + ' ' + RTRIM(@OrigenID)
			AND Referencia IS NOT NULL
			SELECT @Aplicado = 0.0
			SELECT @Aplicado = ISNULL(SUM(Importe + Impuestos), 0.0)
			FROM Cxc
			WHERE Empresa = @Empresa
			AND Cliente = @Cliente
			AND Moneda = @Moneda
			AND Referencia = RTRIM(@Origen) + ' ' + RTRIM(@OrigenID)
			AND Mov = @Mov
			AND Estatus = 'CONCLUIDO'
			AND Referencia IS NOT NULL
			--SELECT @Saldo = @Saldo - @Aplicado
		END

	END

	IF @Saldo IS NULL
		AND (
			SELECT VentaSugerirSaldoFavorID
			FROM EmpresaCfg
			WHERE Empresa = @Empresa
		)
		= 0
		SELECT @Saldo = -ISNULL(Saldo, 0.0)
		FROM CxcEfectivo
		WHERE Empresa = @Empresa
		AND Cliente = @Cliente
		AND Moneda = @Moneda

	IF @EnSilencio = 0
		SELECT "Saldo" = @Saldo
	ELSE
		RETURN

END
GO