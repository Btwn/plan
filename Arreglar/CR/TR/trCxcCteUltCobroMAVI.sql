SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER [dbo].[trCxcCteUltCobroMAVI]
ON [dbo].[Cxc]
FOR UPDATE
AS
BEGIN
	DECLARE
		@ID INT
	   ,@Clave VARCHAR(20)
	   ,@Mov VARCHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@Cliente VARCHAR(10)
	   ,@FechaActual DATETIME
	   ,@Empresa VARCHAR(5)
	   ,@Estatus VARCHAR(15)
	   ,@Usuario VARCHAR(10)
	   ,@MovimientoUltimoCobroAux VARCHAR(50)
	   ,@MovimientoUltimoCobro VARCHAR(50)
	   ,@FechaUltimoCobroAux DATETIME

	IF UPDATE(Estatus)
	BEGIN
		SELECT @ID = ID
			  ,@Estatus = Estatus
			  ,@Mov = Mov
			  ,@MovID = MovID
			  ,@Usuario = Usuario
			  ,@Empresa = Empresa
			  ,@Cliente = Cliente
		FROM Inserted
		SELECT @Clave = Clave
		FROM MovTipo
		WHERE Modulo = 'Cxc'
		AND Mov = @Mov
		SET @FechaActual = dbo.fnFechaSinHora(GETDATE())

		IF @Clave IN ('CXC.C', 'CXC.DC', 'CXC.NC')
			AND @Estatus = 'CONCLUIDO'
		BEGIN
			SELECT @MovimientoUltimoCobro = ISNULL(MovimientoUltimoCobro, '')
			FROM Cte
			WHERE Cliente = @Cliente

			IF @MovimientoUltimoCobro <> ''
			BEGIN
				SELECT @MovimientoUltimoCobroAux = MovimientoUltimoCobro
					  ,@FechaUltimoCobroAux = FechaUltimoCobro
				FROM Cte
				WHERE Cliente = @Cliente
				UPDATE Cte
				SET FechaUltimoCobro = @FechaActual
				   ,MovimientoUltimoCobro = @Mov + '-' + @MovID
				   ,FechaUltimoCobroAux = @FechaUltimoCobroAux
				   ,MovimientoUltimoCobroAux = @MovimientoUltimoCobroAux
				WHERE Cliente = @Cliente
			END
			ELSE
				UPDATE Cte
				SET FechaUltimoCobro = @FechaActual
				   ,MovimientoUltimoCobro = @Mov + '-' + @MovID
				   ,FechaUltimoCobroAux = @FechaActual
				   ,MovimientoUltimoCobroAux = @Mov + '-' + @MovID
				WHERE Cliente = @Cliente

		END

		IF @Clave = 'CXC.C'
			AND @Estatus = 'CANCELADO'
		BEGIN
			SELECT @MovimientoUltimoCobroAux = MovimientoUltimoCobroAux
				  ,@FechaUltimoCobroAux = FechaUltimoCobroAux
			FROM Cte
			WHERE Cliente = @Cliente
			UPDATE Cte
			SET FechaUltimoCobro = @FechaUltimoCobroAux
			   ,MovimientoUltimoCobro = @MovimientoUltimoCobroAux
			WHERE Cliente = @Cliente
		END

	END

END

