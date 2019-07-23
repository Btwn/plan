SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpMovGenerar]
 @Sucursal INT
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@Usuario CHAR(10)
,@FechaEmision DATETIME
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@GenerarDirecto BIT
,@GenerarMov CHAR(20)
,@GenerarSerie CHAR(20)
,@GenerarMovID VARCHAR(20)
,@GenerarID INT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) = NULL OUTPUT
AS
BEGIN
	DECLARE
		@IVAFiscal FLOAT
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@Importe FLOAT
	   ,@IVA FLOAT
	   ,@Condicion VARCHAR(50)
	   ,@Vence DATETIME
	   ,@Financia FLOAT
	   ,@Fin2 FLOAT
	   ,@Cliente VARCHAR(10)
	   ,@Dias INT
	   ,@OrigenVenta VARCHAR(20)
	   ,@DesgloseIVA BIT
	   ,@Redime BIT

	IF @Modulo = 'CXC'
	BEGIN

		IF @Mov = 'Sol Refinanciamiento'
			AND @GenerarMov = 'Refinanciamiento'
		BEGIN
			SELECT @Importe = 0
				  ,@Cliente = NULL
				  ,@Condicion = NULL
				  ,@Financia = 0
			UPDATE MaviRefinaciamientos WITH(ROWLOCK)
			SET IDDestino = @GenerarID
			WHERE ID = @ID
			SELECT @Importe = (ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0))
				  ,@Cliente = Cliente
				  ,@Condicion = CondRef
				  ,@Financia = Financiamiento
			FROM Cxc WITH(NOLOCK)
			WHERE ID = @ID
			EXEC spCalcularVencimiento 'CXC'
									  ,@Empresa
									  ,@Cliente
									  ,@Condicion
									  ,@FechaEmision
									  ,@Vence OUTPUT
									  ,@Dias OUTPUT
									  ,@Ok OUTPUT
			SELECT @Fin2 = 1.00 + (ISNULL(DefImpuesto, 0) / 100)
			FROM EmpresaGral WITH(NOLOCK)
			WHERE Empresa = @Empresa
			SET @Fin2 = (@Financia / @Fin2)
			UPDATE Cxc WITH(ROWLOCK)
			SET Importe = @Importe + @Fin2
			   ,Impuestos = @Financia - @Fin2
			   ,Concepto = 'REFINANCIAMIENTO'
			   ,Condicion = @Condicion
			   ,Vencimiento = @Vence
			   ,Financiamiento = @Financia
			WHERE ID = @GenerarID
		END

		IF @GenerarMov = 'Devolucion'
		BEGIN
			UPDATE Cxc WITH(ROWLOCK)
			SET Vencimiento = Fechaemision
			WHERE ID = @GenerarID
		END

	END

	IF @Modulo = 'VTAS'
	BEGIN
		SELECT @OrigenVenta = ISNULL((
			 SELECT Origen
			 FROM Venta WITH(NOLOCK)
			 WHERE ID = @GenerarID
		 )
		 , 'Base')
		SELECT @Redime = RedimePtos
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID

		IF @Redime IS NOT NULL
			UPDATE Venta WITH(ROWLOCK)
			SET RedimePtos = @Redime
			WHERE ID = @GenerarID

		IF @OrigenVenta <> 'Base'
		BEGIN
			SELECT @DesgloseIVA = (
				 SELECT FacDesgloseIVA
				 FROM Venta WITH(NOLOCK)
				 WHERE ID = @ID
			 )
			UPDATE Venta WITH(ROWLOCK)
			SET FacDesgloseIVA = @DesgloseIVA
			WHERE ID = @GenerarID
		END

		IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WITH(NOLOCK) WHERE Modulo = 'VTAS' AND ID = @ID)
			INSERT TarjetaSerieMovMAVI (Empresa, Modulo, ID, Serie, Importe, Sucursal)
				SELECT Empresa
					  ,Modulo
					  ,@GenerarID
					  ,Serie
					  ,Importe
					  ,Sucursal
				FROM TarjetaSerieMovMAVI WITH(NOLOCK)
				WHERE Modulo = 'VTAS'
				AND ID = @ID

		IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WITH(NOLOCK) WHERE Modulo = 'VTAS' AND ID = @ID)
			INSERT PoliticasMonederoAplicadasMavi (Empresa, Modulo, ID, Renglon, Articulo, IDPolitica)
				SELECT Empresa
					  ,Modulo
					  ,@GenerarID
					  ,Renglon
					  ,Articulo
					  ,IDPolitica
				FROM PoliticasMonederoAplicadasMavi WITH(NOLOCK)
				WHERE Modulo = 'VTAS'
				AND ID = @ID

	END

	RETURN
END
GO