SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConsecutivoActualizar
@Modulo		char(5),
@ID			int,
@MovID      		varchar(20)

AS BEGIN
IF @Modulo = 'CONT'  UPDATE Cont           (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta          (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod           (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra         (ROWLOCK) SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent          (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto          (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque       (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH             (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo     (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC             (ROWLOCK) SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale           (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR             (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte        (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital        (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia     (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion   (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito        (ROWLOCK) SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana        (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela   (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad    (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte          (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra     (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura        (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion        (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP             (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto       (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza       (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	       (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL            (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio         (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato	   (ROWLOCK)SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX		   (ROWLOCK)SET MovID = @MovID WHERE ID = @ID
RETURN
END

