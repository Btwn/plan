SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spContAutoSetDatos]
 @Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@ContID INT
,@ContMov CHAR(20)
,@ContMovID VARCHAR(20)
AS
BEGIN
	UPDATE Mov
	SET ContID = @ContID
	   ,Poliza = @ContMov
	   ,PolizaID = @ContMovID
	WHERE Empresa = @Empresa
	AND Modulo = @Modulo
	AND ID = @ID

	IF @Modulo = 'DIN'
		UPDATE Dinero
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'COMS'
		UPDATE Compra
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VALE'
		UPDATE Vale
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CR'
		UPDATE CR
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAP'
		UPDATE Capital
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INC'
		UPDATE Incidencia
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CONC'
		UPDATE Conciliacion
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PPTO'
		UPDATE Presup
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CP'
		UPDATE CP
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CREDI'
		UPDATE Credito
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAM'
		UPDATE Cambio
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXC'
		UPDATE Cxc
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXP'
		UPDATE Cxp
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VTAS'
		UPDATE Venta
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'GAS'
		UPDATE Gasto
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AF'
		UPDATE ActivoFijo
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AGENT'
		UPDATE Agent
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROD'
		UPDATE Prod
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INV'
		UPDATE Inv
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'EMB'
		UPDATE Embarque
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'NOM'
		UPDATE Nomina
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'RH'
		UPDATE RH
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ASIS'
		UPDATE Asiste
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PC'
		UPDATE PC
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ST'
		UPDATE Soporte
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID

	EXEC xpContSAT @Empresa
				  ,@Modulo
				  ,@ID
				  ,@ContID
	RETURN
END

