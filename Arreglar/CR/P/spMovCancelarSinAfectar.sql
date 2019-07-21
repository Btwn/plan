SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCancelarSinAfectar
@Modulo	char(5),
@ID	int,
@Ok	int	OUTPUT,
@EstatusNuevo	varchar(15) = 'CANCELADO'

AS BEGIN
/*INICIO Cambio CFD Flexible */
DECLARE
@eDoc   bit,
@CFDFlex  bit,
@CFDFlexMovTipo bit,
@CFDMovTipo  bit,
@CFD   bit,
@Empresa  varchar(5),
@eDocOk   int,
@eDocOkRef  varchar(255)
IF @Modulo = 'VTAS' SELECT @CFDFlexMovTipo = mt.CFDFlex, @CFDMovTipo = mt.CFD, @Empresa = v.Empresa FROM Venta v JOIN MovTipo mt ON mt.Mov = v.Mov AND mt.Modulo = @Modulo WHERE v.ID = @ID
IF @Modulo = 'CXC'  SELECT @CFDFlexMovTipo = mt.CFDFlex, @CFDMovTipo = mt.CFD, @Empresa = v.Empresa FROM Cxc v JOIN MovTipo mt ON mt.Mov = v.Mov AND mt.Modulo = @Modulo WHERE v.ID = @ID
IF @Modulo IN ('VTAS','CXC')
BEGIN
SELECT
@CFD = CFD
FROM Empresa
WHERE Empresa = @Empresa
SELECT
@CFDFlex = CFDFlex,
@eDoc = eDoc
FROM EmpresaGral
WHERE Empresa = @Empresa
IF ( ((@CFDFlexMovTipo = 1) AND (@CFDFlex = 1) AND (@eDoc = 1)) OR ((@CFDMovTipo = 1) AND (@CFD = 1)) ) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) 
BEGIN
SELECT @eDocOk = NULL, @eDocOkRef = NULL
EXEC spCFDFlexCancelar @@SPID, @Empresa, @Modulo, @ID, @EstatusNuevo, @eDocOk OUTPUT, @eDocOkRef OUTPUT
IF @eDocOk IS NOT NULL SELECT @Ok = @eDocOk
END
END
/*FIN Cambio CFD Flexible */
IF @Ok IS NOT NULL RETURN
BEGIN TRANSACTION
IF @Modulo = 'CONT'  UPDATE Cont         SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	     SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX         SET Estatus = @EstatusNuevo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Modulo = 'VTAS' UPDATE VentaOrigen SET OrigenID = 0 WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

