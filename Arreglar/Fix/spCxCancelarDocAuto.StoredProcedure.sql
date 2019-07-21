SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCxCancelarDocAuto]
 @Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@Verificar BIT
,@FechaRegistro DATETIME
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Conteo INT
	   ,@ImporteTotal MONEY
	   ,@SaldoTotal MONEY
	   ,@CxID INT
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@IDGenerar INT

	IF @Verificar = 1
	BEGIN
		SELECT @SaldoTotal = 0

		IF @Modulo = 'CXC'
			SELECT @Conteo = COUNT(*)
				  ,@ImporteTotal = ISNULL(SUM(Importe), 0) + ISNULL(SUM(Impuestos), 0)
				  ,@SaldoTotal = ISNULL(SUM(Saldo), 0)
			FROM Cxc
			WHERE Empresa = @Empresa
			AND OrigenTipo = @Modulo
			AND Origen = @Mov
			AND OrigenID = @MovID
			AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
		ELSE

		IF @Modulo = 'CXP'
			SELECT @Conteo = COUNT(*)
				  ,@ImporteTotal = ISNULL(SUM(Importe), 0) + ISNULL(SUM(Impuestos), 0)
				  ,@SaldoTotal = ISNULL(SUM(Saldo), 0)
			FROM Cxp
			WHERE Empresa = @Empresa
			AND OrigenTipo = @Modulo
			AND Origen = @Mov
			AND OrigenID = @MovID
			AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

		IF @Conteo > 0
			AND ROUND(@ImporteTotal, 2) <> ROUND(@SaldoTotal, 2)
			SELECT @Ok = 60060

	END
	ELSE
	BEGIN

		IF @Modulo = 'CXC'
			DECLARE
				crCancelarDocAuto
				CURSOR LOCAL FOR
				SELECT ID
				FROM Cxc
				WHERE Empresa = @Empresa
				AND OrigenTipo = @Modulo
				AND Origen = @Mov
				AND OrigenID = @MovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
		ELSE

		IF @Modulo = 'CXP'
			DECLARE
				crCancelarDocAuto
				CURSOR LOCAL FOR
				SELECT ID
				FROM Cxp
				WHERE Empresa = @Empresa
				AND OrigenTipo = @Modulo
				AND Origen = @Mov
				AND OrigenID = @MovID
				AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

		OPEN crCancelarDocAuto
		FETCH NEXT FROM crCancelarDocAuto INTO @CxID
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			EXEC spCx @CxID
					 ,@Modulo
					 ,'CANCELAR'
					 ,'TODO'
					 ,@FechaRegistro
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,@CxMov OUTPUT
					 ,@CxMovID OUTPUT
					 ,@IDGenerar OUTPUT
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT

		FETCH NEXT FROM crCancelarDocAuto INTO @CxID
		END
		CLOSE crCancelarDocAuto
		DEALLOCATE crCancelarDocAuto
	END

	RETURN
END
GO