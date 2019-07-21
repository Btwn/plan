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
		UPDATE Venta
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Venta WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'PROD'
	BEGIN
		UPDATE Prod
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Prod WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'COMS'
	BEGIN
		UPDATE Compra
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Compra WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'INV'
	BEGIN
		UPDATE Inv
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Inv WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CXC'
	BEGIN
		UPDATE Cxc
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Cxc WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CXP'
	BEGIN
		UPDATE Cxp
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Cxp WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'AGENT'
	BEGIN
		UPDATE Agent
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Agent WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'GAS'
	BEGIN
		UPDATE Gasto
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Gasto WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'DIN'
	BEGIN
		UPDATE Dinero
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Dinero WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'EMB'
	BEGIN
		UPDATE Embarque
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Embarque WHERE ContID = @ContID)
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
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Nomina WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'RH'
	BEGIN
		UPDATE RH
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM RH WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'ASIS'
	BEGIN
		UPDATE Asiste
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Asiste WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'AF'
	BEGIN
		UPDATE ActivoFijo
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM ActivoFijo WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'PC'
	BEGIN
		UPDATE PC
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM PC WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'OFER'
	BEGIN
		UPDATE Oferta
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Oferta WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'VALE'
	BEGIN
		UPDATE Vale
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Vale WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CR'
	BEGIN
		UPDATE CR
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM CR WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'ST'
	BEGIN
		UPDATE Soporte
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Soporte WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CAP'
	BEGIN
		UPDATE Capital
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Capital WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'INC'
	BEGIN
		UPDATE Incidencia
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Incidencia WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CONC'
	BEGIN
		UPDATE Conciliacion
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Conciliacion WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'PPTO'
	BEGIN
		UPDATE Presup
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Presup WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CREDI'
	BEGIN
		UPDATE Credito
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Credito WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'FIS'
	BEGIN
		UPDATE Fiscal
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Fiscal WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CONTP'
	BEGIN
		UPDATE ContParalela
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM ContParalela WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'OPORT'
	BEGIN
		UPDATE Oportunidad
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Oportunidad WHERE ContID = @ContID)
	END
	ELSE

	IF @Modulo = 'CAM'
	BEGIN
		UPDATE Cambio
		SET @ID = ID
		   ,GenerarPoliza = @GenerarPoliza
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE ContID = @ContID
		UPDATE Mov
		SET ContID = @ContID
		   ,Poliza = @Poliza
		   ,PolizaID = @PolizaID
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND ID IN (SELECT ID FROM Cambio WHERE ContID = @ContID)
	END

	EXEC xpContSAT @Empresa
				  ,@Modulo
				  ,@ID
				  ,@ContID
	RETURN
END

