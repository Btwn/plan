SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spEmbarqueManual]
 @Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@Estatus CHAR(15)
,@DesEmbarcar BIT = 0
,@EnSilencio BIT = 0
AS
BEGIN
	SET NOCOUNT ON
	DECLARE
		@AsignadoID INT
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@OkDesc VARCHAR(255)
	   ,@OkTipo VARCHAR(50)
	SELECT @Ok = NULL
		  ,@OkRef = NULL
		  ,@OkDesc = NULL
		  ,@OkTipo = NULL
	EXEC xpEmbarqueManual @Empresa
						 ,@Modulo
						 ,@ID
						 ,@Mov
						 ,@MovID
						 ,@Estatus
						 ,@DesEmbarcar
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	IF @Ok IS NULL
	BEGIN

		IF @DesEmbarcar = 1
		BEGIN

			IF EXISTS (SELECT Empresa FROM EmbarqueMov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND MovID = @MovID)
			BEGIN
				DELETE EmbarqueMov
				WHERE Empresa = @Empresa
					AND Modulo = @Modulo
					AND Mov = @Mov
					AND MovID = @MovID
					AND AsignadoID IS NULL

				IF @@ROWCOUNT = 0
					SELECT @Ok = 42020

				IF @Ok IS NULL
				BEGIN

					IF @Modulo = 'VTAS'
						UPDATE Venta WITH(ROWLOCK)
						SET EmbarqueEstado = NULL
						WHERE ID = @ID
					ELSE

					IF @Modulo = 'COMS'
						UPDATE Compra WITH(ROWLOCK)
						SET EmbarqueEstado = NULL
						WHERE ID = @ID
					ELSE

					IF @Modulo = 'INV'
						UPDATE Inv WITH(ROWLOCK)
						SET EmbarqueEstado = NULL
						WHERE ID = @ID
					ELSE

					IF @Modulo = 'CXC'
						UPDATE Cxc WITH(ROWLOCK)
						SET EmbarqueEstado = NULL
						WHERE ID = @ID
					ELSE

					IF @Modulo = 'DIN'
						UPDATE Dinero WITH(ROWLOCK)
						SET EmbarqueEstado = NULL
						WHERE ID = @ID

				END

			END
			ELSE
				SELECT @Ok = 42030

		END
		ELSE
		BEGIN

			IF @Modulo = 'VTAS'
			BEGIN

				IF EXISTS (SELECT * FROM VentaD d WITH(NOLOCK) JOIN EmbarqueMov e WITH(NOLOCK) ON Empresa = @Empresa AND Modulo = @Modulo AND Mov = Aplica AND MovID = AplicaID WHERE d.ID = @ID)
					SELECT @OKRef = Aplica + ' ' + AplicaID
						  ,@Ok = 42020
					FROM VentaD d WITH(NOLOCK)
					JOIN EmbarqueMov e WITH(NOLOCK)
						ON Empresa = @Empresa
						AND Modulo = @Modulo
						AND Mov = Aplica
						AND MovID = AplicaID
					WHERE d.ID = @ID

			END

			IF EXISTS (SELECT * FROM EmbarqueMov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND MovID = @MovID)
				SELECT @Ok = 42020

			IF @OK IS NULL
				EXEC spEmbarqueMov 'AFECTAR'
								  ,@Empresa
								  ,@Modulo
								  ,@ID
								  ,@Mov
								  ,@MovID
								  ,'SINAFECTAR'
								  ,@Estatus
								  ,1
								  ,@Ok OUTPUT

		END

	END

	IF @EnSilencio = 0
	BEGIN

		IF @Ok IS NULL
			SELECT @OkRef = NULL
		ELSE
			SELECT @OkDesc = Descripcion
				  ,@OkTipo = Tipo
			FROM MensajeLista WITH(NOLOCK)
			WHERE Mensaje = @Ok

		SELECT @Ok
			  ,@OkDesc
			  ,@OkTipo
			  ,@OkRef
			  ,NULL
	END

	RETURN
	SET NOCOUNT OFF
END
GO