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
IF @Modulo = 'VTAS' SELECT @CFDFlexMovTipo = mt.CFDFlex, @CFDMovTipo = mt.CFD, @Empresa = v.Empresa FROM Venta v  WITH (NOLOCK) JOIN MovTipo mt  WITH (NOLOCK) ON mt.Mov = v.Mov AND mt.Modulo = @Modulo WHERE v.ID = @ID
IF @Modulo = 'CXC'  SELECT @CFDFlexMovTipo = mt.CFDFlex, @CFDMovTipo = mt.CFD, @Empresa = v.Empresa FROM Cxc v  WITH (NOLOCK) JOIN MovTipo mt  WITH (NOLOCK) ON mt.Mov = v.Mov AND mt.Modulo = @Modulo WHERE v.ID = @ID
IF @Modulo IN ('VTAS','CXC')
BEGIN
SELECT
@CFD = CFD
FROM Empresa WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT
@CFDFlex = CFDFlex,
@eDoc = eDoc
FROM EmpresaGral WITH (NOLOCK)
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
IF @Modulo = 'CONT'  UPDATE Cont          WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta         WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod          WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent         WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto         WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque      WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH            WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo    WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC            WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale          WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR            WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte       WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital       WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia    WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion  WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito       WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana       WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela  WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad   WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte         WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra    WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura       WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion       WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP            WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto      WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza      WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	      WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL           WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio        WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato      WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX          WITH (ROWLOCK) SET Estatus = @EstatusNuevo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Modulo = 'VTAS' UPDATE VentaOrigen   WITH (ROWLOCK) SET OrigenID = 0 WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

