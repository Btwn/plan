SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spOrigenVentaPMMavi]
 @Empresa CHAR(5)
,@Cliente CHAR(10)
,@Estacion INT
,@TipoCobro INT
AS
BEGIN
	DECLARE
		@IdCxc INT
	   ,@IdOrigen INT
	   ,@MovIDCxC VARCHAR(20)
	   ,@MovCxC VARCHAR(20)
	   ,@Clave VARCHAR(20)
	   ,@Concepto VARCHAR(50)
	   ,@DiasVencActMAVI FLOAT
	   ,@DiasVencidos FLOAT
	   ,@DiasInacActMAVI FLOAT
	   ,@DiasInactivos FLOAT
	   ,@CanalVentas INT
	   ,@SeccionCobranza VARCHAR(50)
	   ,@PasaMov INT
	   ,@min INT
	   ,@max INT
	DELETE ListaSt
	WHERE Estacion = @Estacion
	DELETE CXCFacturaCteMavi
	WHERE Cliente = @Cliente

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crCxCCte2') AND type = 'U')
		DROP TABLE #crCxCCte2

	CREATE TABLE #crCxCCte2 (
		IDI INT IDENTITY (1, 1)
	   ,ID INT
	   ,Mov VARCHAR(25)
	   ,Movid VARCHAR(25)
	)
	INSERT INTO #crCxCCte2 (ID, Mov, Movid)
		SELECT Id
			  ,c.Mov
			  ,c.MovID
		FROM Cxc C
		JOIN MovTipo
			ON MovTipo.Mov = C.Mov
		WHERE c.Empresa = @Empresa
		AND c.Cliente = @Cliente
		AND C.Estatus = 'PENDIENTE'
		AND MovTipo.Mov
		IN ('Factura', 'Factura VIU', 'Factura Mayoreo', 'Credilana', 'Prestamo Personal',
		'Seguro Auto', 'Seguro Vida', 'Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo', 'Refinanciamiento',
		'Cheque Devuelto', 'Documento')
		AND Modulo = 'CxC'
	SELECT @min = MIN(IDI)
		  ,@max = MAX(IDI)
	FROM #crCxCCte2
	WHILE @min <= @max
	BEGIN
	SELECT @PasaMov = 1
	SELECT @IdCxc = ID
		  ,@MovCxC = Mov
		  ,@MovIDCxC = Movid
	FROM #crCxCCte2
	WHERE IDI = @min
	SELECT @Concepto = Concepto
	FROM CXC
	WHERE ID = @IdCxc

	IF @MovCxC IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')

		IF @Concepto IN ('CANC COBRO CRED Y PP', 'CANC COBRO FACTURA', 'CANC COBRO SEG AUTO', 'CANC COBRO SEG VIDA', 'CANC COBRO FACTURA VIU', 'CANC COBRO MAYOREO')
			SELECT @PasaMov = 1
		ELSE
			SELECT @PasaMov = 1

	IF @PasaMov = 1
	BEGIN
		SELECT @Clave = Clave
		FROM MovTipo
		WHERE Modulo = 'CXC'
		AND Mov = @MovCxC

		IF @Clave NOT IN ('CXC.F', 'CXC.DM', 'CXC.FAC')
		BEGIN
			EXEC spMAviBuscaCxCVentaTest @MovIDCxC
										,@MovCxC
										,@MovIDCxC OUTPUT
										,@MovCxC OUTPUT
										,@IdOrigen OUTPUT

			IF (LEFT(@MovCxC, 10) = 'Nota Cargo')
				OR (LEFT(@MovCxC, 5) = 'Prest')
			BEGIN
				SELECT @MovCxC = PadreMAVI
				FROM CXC
				WHERE ID = @IdCxC
				SELECT @MovIDCxC = PadreIDMAVI
				FROM cxc
				WHERE ID = @IdCxC
				SELECT @IdOrigen = ID
				FROM CXC
				WHERE Mov = @MovCxC
				AND MovID = @MovIDCxC
			END

			IF NOT @MovIDCxC IS NULL
				AND NOT @IdOrigen IS NULL
			BEGIN

				IF NOT EXISTS (SELECT * FROM CXCFacturaCteMavi WHERE cliente = @Cliente AND Empresa = @Empresa AND IdOrigen = @IdOrigen AND IdCxcOrigen = @MovIDCxC AND IdCxCOrigenMov = @MovCxC)
				BEGIN

					IF @TipoCobro = 1
					BEGIN
						SELECT @CanalVentas = ClienteEnviarA
						FROM CXC
						WHERE ID = @IdOrigen
						SELECT @SeccionCobranza = SeccionCobranzaMAVI
						FROM CteEnviarA
						WHERE Cliente = @Cliente
						AND ID = @CanalVentas

						IF @SeccionCobranza <> 'INSTITUCIONES'
						BEGIN

							IF EXISTS (SELECT * FROM CxcMavi WHERE ID = @IdOrigen)
							BEGIN
								SELECT @DiasVencActMAVI = ISNULL(DiasVencActMAVI, 0)
									  ,@DiasInacActMAVI = ISNULL(DiasInacActMAVI, 0)
								FROM CxcMavi
								WHERE ID = @IdOrigen
								SELECT @DiasVencidos = Numero
									  ,@DiasInactivos = Valor
								FROM TablaNumD
								WHERE TablaNum = 'CFG DV-DI POLITICA QUITA MORATORIOS'

								IF @DiasVencActMAVI >= @DiasVencidos
									OR @DiasInacActMAVI >= @DiasInactivos
									INSERT INTO CXCFacturaCteMavi (Cliente, Empresa, IdCxC, IdOrigen, IdCxCOrigen, IdCxCOrigenMov, Estacion)
										VALUES (@Cliente, @Empresa, @IdCxC, @IdOrigen, @MovIDCxC, @MovCxC, @Estacion)

							END

						END

					END
					ELSE
					BEGIN
						INSERT INTO CXCFacturaCteMavi (Cliente, Empresa, IdCxC, IdOrigen, IdCxCOrigen, IdCxCOrigenMov, Estacion)
							VALUES (@Cliente, @Empresa, @IdCxC, @IdOrigen, @MovIDCxC, @MovCxC, @Estacion)
					END

				END

			END

		END

		IF @Clave IN ('CXC.F', 'CXC.CD', 'CXC.DM', 'CXC.FAC')
		BEGIN
			SELECT @IdOrigen = @IdCxc

			IF NOT EXISTS (SELECT * FROM CXCFacturaCteMavi ccm WHERE cliente = @Cliente AND ccm.IdOrigen = @IdOrigen AND ccm.IdCxCOrigenMov = @MovCxC AND Estacion = @Estacion)
			BEGIN

				IF @TipoCobro = 1
				BEGIN
					SELECT @CanalVentas = ClienteEnviarA
					FROM CXC
					WHERE ID = @IdOrigen
					SELECT @SeccionCobranza = SeccionCobranzaMAVI
					FROM CteEnviarA
					WHERE Cliente = @Cliente
					AND ID = @CanalVentas

					IF @SeccionCobranza <> 'INSTITUCIONES'
					BEGIN

						IF EXISTS (SELECT * FROM CxcMavi WHERE ID = @IdOrigen)
						BEGIN
							SELECT @DiasVencActMAVI = ISNULL(DiasVencActMAVI, 0)
								  ,@DiasInacActMAVI = ISNULL(DiasInacActMAVI, 0)
							FROM CxcMavi
							WHERE ID = @IdOrigen
							SELECT @DiasVencidos = Numero
								  ,@DiasInactivos = Valor
							FROM TablaNumD
							WHERE TablaNum = 'CFG DV-DI POLITICA QUITA MORATORIOS'

							IF @DiasVencActMAVI >= @DiasVencidos
								OR @DiasInacActMAVI >= @DiasInactivos
								INSERT INTO CXCFacturaCteMavi (Cliente, Empresa, IdCxC, IdOrigen, IdCxCOrigen, IdCxCOrigenMov, Estacion)
									VALUES (@Cliente, @Empresa, @IdCxC, @IdCxC, @MovIDCxC, @MovCxC, @Estacion)

						END

					END

				END
				ELSE
				BEGIN
					INSERT INTO CXCFacturaCteMavi (Cliente, Empresa, IdCxC, IdOrigen, IdCxCOrigen, IdCxCOrigenMov, Estacion)
						VALUES (@Cliente, @Empresa, @IdCxC, @IdCxC, @MovIDCxC, @MovCxC, @Estacion)
				END

			END

		END

	END

	SET @min = @min + 1
	END
END

