SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spLigarMovCont]
 @Accion CHAR(20)
,@Empresa CHAR(5)
,@OrigenTipo CHAR(10)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@ContID INT
,@Poliza CHAR(20)
,@PolizaID VARCHAR(20)
,@ID INT = NULL OUTPUT
AS
BEGIN
	DECLARE
		@Modulo CHAR(5)
	   ,@GenerarPoliza BIT

	IF @Accion <> 'CANCELAR'
		SELECT @GenerarPoliza = 0
	ELSE
		SELECT @GenerarPoliza = 1
			  ,@Poliza = NULL
			  ,@PolizaID = NULL
			  ,@ID = NULL

	SELECT @Poliza = NULLIF(RTRIM(@Poliza), '')
		  ,@Mov = NULLIF(RTRIM(@Mov), '')
		  ,@Modulo = @OrigenTipo

	IF @Modulo = 'VTAS'
	BEGIN
		UPDATE Venta WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Venta WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'PROD'
	BEGIN
		UPDATE Prod WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Prod WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'COMS'
	BEGIN
		UPDATE Compra WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Compra  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'INV'
	BEGIN
		UPDATE Inv WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Inv WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CXC'
	BEGIN
		UPDATE Cxc WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Cxc WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CXP'
	BEGIN
		UPDATE Cxp WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Cxp WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'AGENT'
	BEGIN
		UPDATE Agent WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Agent WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'GAS'
	BEGIN
		UPDATE Gasto WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Gasto WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'DIN'
	BEGIN
		UPDATE Dinero WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Dinero  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'EMB'
	BEGIN
		UPDATE Embarque WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Embarque  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'NOM'
	BEGIN
		UPDATE Nomina
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Nomina  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'RH'
	BEGIN
		UPDATE RH WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM RH  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'ASIS'
	BEGIN
		UPDATE Asiste WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Asiste WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'AF'
	BEGIN
		UPDATE ActivoFijo WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM ActivoFijo  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'PC'
	BEGIN
		UPDATE PC WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM PC WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'OFER'
	BEGIN
		UPDATE Oferta WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Oferta WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'VALE'
	BEGIN
		UPDATE Vale WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Vale  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CR'
	BEGIN
		UPDATE CR WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM CR WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'ST'
	BEGIN
		UPDATE Soporte WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Soporte  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CAP'
	BEGIN
		UPDATE Capital WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Capital WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'INC'
	BEGIN
		UPDATE Incidencia WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Incidencia  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CONC'
	BEGIN
		UPDATE Conciliacion WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Conciliacion  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'PPTO'
	BEGIN
		UPDATE Presup WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Presup WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CREDI'
	BEGIN
		UPDATE Credito WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Credito WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'FIS'
	BEGIN
		UPDATE Fiscal WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Fiscal WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CONTP'
	BEGIN
		UPDATE ContParalela WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM ContParalela WITH (NOLOCK)   WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'OPORT'
	BEGIN
		UPDATE Oportunidad WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Oportunidad  WITH (NOLOCK)  WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CAM'
	BEGIN
		UPDATE Cambio WITH (ROWLOCK) 
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov WITH (ROWLOCK) 
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Cambio WITH (NOLOCK)   WHERE ContID = @ContID)
	END

	EXEC xpContSAT @Empresa
				  ,@Modulo
				  ,@ID
				  ,@ContID
	RETURN
END

