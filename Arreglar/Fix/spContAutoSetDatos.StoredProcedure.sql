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
	UPDATE Mov WITH(ROWLOCK)
	SET ContID = @ContID
	   ,Poliza = @ContMov
	   ,PolizaID = @ContMovID
	WHERE Empresa = @Empresa
	AND Modulo = @Modulo
	AND ID = @ID

	IF @Modulo = 'DIN'
		UPDATE Dinero WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'COMS'
		UPDATE Compra WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VALE'
		UPDATE Vale WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CR'
		UPDATE CR WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAP'
		UPDATE Capital WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INC'
		UPDATE Incidencia WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CONC'
		UPDATE Conciliacion WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PPTO'
		UPDATE Presup WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CP'
		UPDATE CP WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CREDI'
		UPDATE Credito WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAM'
		UPDATE Cambio WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXC'
		UPDATE Cxc WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXP'
		UPDATE Cxp WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VTAS'
		UPDATE Venta WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'GAS'
		UPDATE Gasto WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AF'
		UPDATE ActivoFijo WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AGENT'
		UPDATE Agent WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROD'
		UPDATE Prod WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INV'
		UPDATE Inv WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'EMB'
		UPDATE Embarque WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'NOM'
		UPDATE Nomina WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'RH'
		UPDATE RH WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ASIS'
		UPDATE Asiste WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PC'
		UPDATE PC WITH(ROWLOCK)
		SET ContID = @ContID
		   ,Poliza = @ContMov
		   ,PolizaID = @ContMovID
		   ,GenerarPoliza = 0
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ST'
		UPDATE Soporte WITH(ROWLOCK)
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
GO