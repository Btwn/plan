SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC [dbo].[spValidaNivelAccesoAgente]
 @ID INT
,@Modulo VARCHAR(5)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Agente VARCHAR(10)
	   ,@Agente2 VARCHAR(10)
	   ,@Usuario VARCHAR(30)
	   ,@NivelAcceso VARCHAR(100)
	   ,@NivelAcceso2 VARCHAR(100)
	   ,@Texto VARCHAR(50)
	   ,@Texto2 VARCHAR(50)
	   ,@Origen VARCHAR(20)
	   ,@Valida BIT
	   ,@Estatus VARCHAR(15)
	SELECT @Valida = 1
	SET @Estatus = (
		SELECT Estatus
		FROM Embarque
		WHERE ID = @ID
	)

	IF (@Modulo IN ('COMS', 'CXP', 'VTAS', 'CXC', 'DIN', 'INV', 'ST', 'AGENT', 'EMB'))
	BEGIN

		IF (@Modulo = 'COMS')
			SELECT @Agente = Agente
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Origen = Origen
			FROM Compra
			WHERE ID = @ID

		IF (@Modulo = 'CXP')
			SELECT @Agente = Cajero
				  ,@Usuario = Usuario
				  ,@Texto = 'Cajero: '
				  ,@Origen = Origen
			FROM CxP
			WHERE ID = @ID

		IF (@Modulo = 'VTAS')
		BEGIN
			SELECT @Agente = Agente
				  ,@Agente2 = AgenteServicio
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Origen = Origen
			FROM Venta
			WHERE ID = @ID

			IF ((
					SELECT M.Clave
					FROM Venta V
						,MovTipo M
					WHERE V.ID = @ID
					AND V.Mov = M.Mov
					AND M.Modulo = 'VTAS'
				)
				IN ('VTAS.SD'))

				IF ((
						SELECT TOP 1 IDCopiaMavi
						FROM VentaD
						WHERE ID = @ID
					)
					IS NOT NULL)
					SELECT @Valida = 0

		END

		IF (@Modulo = 'CXC')
			SELECT @Agente = Agente
				  ,@Agente2 = Cajero
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Texto2 = 'Cajero: '
				  ,@Origen = Origen
			FROM CxC
			WHERE ID = @ID

		IF (@Modulo = 'DIN')
			SELECT @Agente = Cajero
				  ,@Usuario = Usuario
				  ,@Texto = 'Cajero: '
				  ,@Origen = Origen
			FROM Dinero
			WHERE ID = @ID

		IF (@Modulo = 'INV')
			SELECT @Agente = Agente
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Origen = Origen
			FROM Inv
			WHERE ID = @ID

		IF (@Modulo = 'ST')
			SELECT @Agente = Agente
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Origen = Origen
			FROM Soporte
			WHERE ID = @ID

		IF (@Modulo = 'AGENT')
			SELECT @Agente = Agente
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Origen = Origen
			FROM Agent
			WHERE ID = @ID

		IF (@Modulo = 'EMB')
			SELECT @Agente = Agente
				  ,@Agente2 = Agente2
				  ,@Usuario = Usuario
				  ,@Texto = 'Agente: '
				  ,@Texto = 'Agente: '
				  ,@Origen = Origen
			FROM Embarque
			WHERE ID = @ID

		IF (@Valida = 1 AND @Origen IS NULL)

			IF (@Agente NOT IN ('', NULL) OR @Agente2 NOT IN ('', NULL))

				IF (@Agente IS NOT NULL AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente) OR (@Agente2 IS NOT NULL AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente2)
					))
					SELECT @Ok = 26090
						  ,@OkRef =
						   CASE
							   WHEN (@Agente IS NOT NULL AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente) AND @Agente2 IS NULL)
								   OR (@Agente IS NOT NULL AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente) AND @Agente2 IS NOT NULL AND EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente2)
								   ) THEN @Agente
							   WHEN (@Agente2 IS NOT NULL AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente2) AND @Agente IS NULL)
								   OR (@Agente2 IS NOT NULL AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente2) AND @Agente IS NOT NULL AND EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente)
								   ) THEN @Agente2
							   WHEN @Agente IS NOT NULL
								   AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente)
								   AND @Agente2 IS NOT NULL
								   AND NOT EXISTS (SELECT Agente FROM Agente WHERE Agente = @Agente2) THEN @Agente + CHAR(10) + @Agente2
						   END
				ELSE
				BEGIN
					SELECT @NivelAcceso = NivelAcceso
					FROM Agente
					WHERE Agente = @Agente
					SELECT @NivelAcceso2 = NivelAcceso
					FROM Agente
					WHERE Agente = @Agente2

					IF (@NivelAcceso NOT IN ('(TODO)', NULL, '(Especifico)') OR @NivelAcceso2 NOT IN ('(TODO)', NULL, '(Especifico)'))
						AND (@Estatus <> 'PENDIENTE' AND @Modulo <> 'EMB')
					BEGIN

						IF (SUBSTRING(@NivelAcceso, 1, 1) <> '(' OR SUBSTRING(@NivelAcceso2, 1, 1) <> '(')
						BEGIN

							IF (@NivelAcceso IS NOT NULL AND @NivelAcceso <> @Usuario AND @Agente IS NOT NULL AND SUBSTRING(@NivelAcceso, 1, 1) <> '(')
								SELECT @Ok = 100034
									  ,@OkRef = @Texto + @Agente

							IF (@NivelAcceso2 IS NOT NULL AND @NivelAcceso2 <> @Usuario AND @Agente2 IS NOT NULL AND SUBSTRING(@NivelAcceso2, 1, 1) <> '(')
								SELECT @Ok = 100034
									  ,@OkRef = @Texto2 + @Agente2

							IF (@NivelAcceso = @Usuario AND NOT EXISTS (SELECT Usuario FROM Usuario WHERE Usuario = @Usuario) AND @Agente IS NOT NULL)
								SELECT @Ok = 100031
									  ,@OkRef = @Texto + @Agente

							IF (@NivelAcceso2 = @Usuario AND NOT EXISTS (SELECT Usuario FROM Usuario WHERE Usuario = @Usuario) AND @Agente2 IS NOT NULL)
								SELECT @Ok = 100031
									  ,@OkRef = @Texto2 + @Agente2

						END

						IF (SUBSTRING(@NivelAcceso, 1, 1) = '(' OR SUBSTRING(@NivelAcceso2, 1, 1) = '(')
							AND (@Estatus <> 'PENDIENTE' AND @Modulo <> 'EMB')
						BEGIN

							IF (@NivelAcceso <> (
									SELECT '(' + GrupoTrabajo + ')'
									FROM Usuario
									WHERE Usuario = @Usuario
								) AND EXISTS (SELECT GrupoTrabajo FROM GrupoTrabajo WHERE '(' + GrupoTrabajo + ')' = @NivelAcceso) AND @NivelAcceso NOT IN ('(TODOS)', '(Especifico)', NULL))
								SELECT @Ok = 100032
									  ,@OkRef = @Texto + @Agente

							IF (@NivelAcceso2 <> (
									SELECT '(' + GrupoTrabajo + ')'
									FROM Usuario
									WHERE Usuario = @Usuario
								) AND EXISTS (SELECT GrupoTrabajo FROM GrupoTrabajo WHERE '(' + GrupoTrabajo + ')' = @NivelAcceso2) AND @NivelAcceso NOT IN ('(TODOS)', '(Especifico)', NULL))
								SELECT @Ok = 100032
									  ,@OkRef = @Texto2 + @Agente2

							IF ((@NivelAcceso = (
									SELECT '(' + GrupoTrabajo + ')'
									FROM Usuario
									WHERE Usuario = @Usuario
								) AND NOT EXISTS (SELECT GrupoTrabajo FROM GrupoTrabajo WHERE '(' + GrupoTrabajo + ')' = @NivelAcceso)
								) OR (@NivelAcceso <> (
									SELECT '(' + GrupoTrabajo + ')'
									FROM Usuario
									WHERE Usuario = @Usuario
								) AND NOT EXISTS (SELECT GrupoTrabajo FROM GrupoTrabajo WHERE '(' + GrupoTrabajo + ')' = @NivelAcceso) AND (CASE
									WHEN SUBSTRING(@NivelAcceso, 1, 1) <> '(' THEN NULL
									ELSE @NivelAcceso
								END) NOT IN ('(TODOS)', '(Especifico)', NULL)))
								SELECT @Ok = 100033
									  ,@OkRef = @Texto + @Agente

							IF ((@NivelAcceso2 = (
									SELECT '(' + GrupoTrabajo + ')'
									FROM Usuario
									WHERE Usuario = @Usuario
								) AND NOT EXISTS (SELECT GrupoTrabajo FROM GrupoTrabajo WHERE '(' + GrupoTrabajo + ')' = @NivelAcceso2)
								) OR (@NivelAcceso2 <> (
									SELECT '(' + GrupoTrabajo + ')'
									FROM Usuario
									WHERE Usuario = @Usuario
								) AND NOT EXISTS (SELECT GrupoTrabajo FROM GrupoTrabajo WHERE '(' + GrupoTrabajo + ')' = @NivelAcceso2) AND (CASE
									WHEN SUBSTRING(@NivelAcceso2, 1, 1) <> '(' THEN NULL
									ELSE @NivelAcceso2
								END) NOT IN ('(TODOS)', '(Especifico)', NULL)))
								SELECT @Ok = 100033
									  ,@OkRef = @Texto2 + @Agente2

						END

					END

					IF (@NivelAcceso = '(Especifico)' OR @NivelAcceso2 = '(Especifico)')
						AND (@Estatus <> 'PENDIENTE' AND @Modulo <> 'EMB')
					BEGIN

						IF (NOT EXISTS (SELECT Usuario FROM AgenteAcceso WHERE Agente = @Agente AND Usuario = @Usuario) AND @Agente IS NOT NULL AND @NivelAcceso = '(Especifico)')
							SELECT @Ok = 100034
								  ,@OkRef = @Texto + @Agente

						IF (NOT EXISTS (SELECT Usuario FROM AgenteAcceso WHERE Agente = @Agente2 AND Usuario = @Usuario) AND @Agente2 IS NOT NULL AND @NivelAcceso2 = '(Especifico)')
							SELECT @Ok = 100034
								  ,@OkRef = @Texto2 + @Agente2

						IF (EXISTS (SELECT Usuario FROM AgenteAcceso WHERE Agente = @Agente AND Usuario = @Usuario) AND NOT EXISTS (SELECT Usuario FROM Usuario WHERE Usuario = @Usuario) AND @Agente IS NOT NULL AND @NivelAcceso = '(Especifico)')
							SELECT @Ok = 100031
								  ,@OkRef = @Texto + @Agente

						IF (EXISTS (SELECT Usuario FROM AgenteAcceso WHERE Agente = @Agente2 AND Usuario = @Usuario) AND NOT EXISTS (SELECT Usuario FROM Usuario WHERE Usuario = @Usuario) AND @Agente2 IS NOT NULL AND @NivelAcceso2 = '(Especifico)')
							SELECT @Ok = 100031
								  ,@OkRef = @Texto2 + @Agente2

					END

				END

	END

	RETURN
END

