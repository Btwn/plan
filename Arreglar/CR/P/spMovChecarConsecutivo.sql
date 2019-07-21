SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovChecarConsecutivo
@Empresa	char(5),
@Modulo		char(5),
@Mov		char(20),
@MovID		varchar(20),
@Serie		varchar(50),
@Ejercicio	int,
@Periodo	int,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@YaExiste int,
@ConsecutivoPorPeriodo	bit,
@ConsecutivoPorEjercicio	bit
SELECT @ConsecutivoPorPeriodo	  = ConsecutivoPorPeriodo,
@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio
FROM MovTipo
WHERE Modulo = @Modulo
AND Mov    = @Mov
SELECT @YaExiste = NULL
IF @ConsecutivoPorPeriodo = 1
BEGIN
IF @Serie IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @YaExiste = COUNT(*) FROM Venta        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROD'  SELECT @YaExiste = COUNT(*) FROM Prod         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'COMS'  SELECT @YaExiste = COUNT(*) FROM Compra       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXC'   SELECT @YaExiste = COUNT(*) FROM Cxc          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXP'   SELECT @YaExiste = COUNT(*) FROM Cxp          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AGENT' SELECT @YaExiste = COUNT(*) FROM Agent        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INV'   SELECT @YaExiste = COUNT(*) FROM Inv          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GAS'   SELECT @YaExiste = COUNT(*) FROM Gasto        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'DIN'   SELECT @YaExiste = COUNT(*) FROM Dinero       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONT'  SELECT @YaExiste = COUNT(*) FROM Cont         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'EMB'   SELECT @YaExiste = COUNT(*) FROM Embarque     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'NOM'   SELECT @YaExiste = COUNT(*) FROM Nomina       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RH'    SELECT @YaExiste = COUNT(*) FROM RH           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ASIS'  SELECT @YaExiste = COUNT(*) FROM Asiste       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AF'    SELECT @YaExiste = COUNT(*) FROM ActivoFijo 	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PC'    SELECT @YaExiste = COUNT(*) FROM PC         	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OFER'  SELECT @YaExiste = COUNT(*) FROM Oferta     	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VALE'  SELECT @YaExiste = COUNT(*) FROM Vale       	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CR'    SELECT @YaExiste = COUNT(*) FROM CR         	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ST'    SELECT @YaExiste = COUNT(*) FROM Soporte    	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAP'   SELECT @YaExiste = COUNT(*) FROM Capital    	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INC'   SELECT @YaExiste = COUNT(*) FROM Incidencia	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONC'  SELECT @YaExiste = COUNT(*) FROM Conciliacion WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PPTO'  SELECT @YaExiste = COUNT(*) FROM Presup       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CREDI' SELECT @YaExiste = COUNT(*) FROM Credito      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'TMA'   SELECT @YaExiste = COUNT(*) FROM TMA        	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RSS'   SELECT @YaExiste = COUNT(*) FROM RSS        	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CMP'   SELECT @YaExiste = COUNT(*) FROM Campana      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FIS'   SELECT @YaExiste = COUNT(*) FROM Fiscal       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONTP' SELECT @YaExiste = COUNT(*) FROM ContParalela WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OPORT' SELECT @YaExiste = COUNT(*) FROM Oportunidad  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CORTE' SELECT @YaExiste = COUNT(*) FROM Corte        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FRM'   SELECT @YaExiste = COUNT(*) FROM FormaExtra   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAPT'  SELECT @YaExiste = COUNT(*) FROM Captura      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GES'   SELECT @YaExiste = COUNT(*) FROM Gestion      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CP'    SELECT @YaExiste = COUNT(*) FROM CP           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PCP'   SELECT @YaExiste = COUNT(*) FROM PCP          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROY'  SELECT @YaExiste = COUNT(*) FROM Proyecto   	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ORG'   SELECT @YaExiste = COUNT(*) FROM Organiza     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RE'    SELECT @YaExiste = COUNT(*) FROM Recluta      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ISL'   SELECT @YaExiste = COUNT(*) FROM ISL          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAM'   SELECT @YaExiste = COUNT(*) FROM Cambio       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PACTO' SELECT @YaExiste = COUNT(*) FROM Contrato     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'SAUX'  SELECT @YaExiste = COUNT(*) FROM SAUX         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo
END ELSE
BEGIN
IF @Modulo = 'DIN' SELECT @YaExiste = COUNT(*) FROM Dinero  WHERE Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @Serie AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio AND Periodo = @Periodo
ELSE SELECT @Ok = 60150
END
END ELSE
IF @ConsecutivoPorEjercicio = 1
BEGIN
IF @Serie IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @YaExiste = COUNT(*) FROM Venta        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PROD'  SELECT @YaExiste = COUNT(*) FROM Prod         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'COMS'  SELECT @YaExiste = COUNT(*) FROM Compra       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CXC'   SELECT @YaExiste = COUNT(*) FROM Cxc          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CXP'   SELECT @YaExiste = COUNT(*) FROM Cxp          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'AGENT' SELECT @YaExiste = COUNT(*) FROM Agent        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'GAS'   SELECT @YaExiste = COUNT(*) FROM Gasto        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'INV'   SELECT @YaExiste = COUNT(*) FROM Inv          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'DIN'   SELECT @YaExiste = COUNT(*) FROM Dinero       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CONT'  SELECT @YaExiste = COUNT(*) FROM Cont         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'EMB'   SELECT @YaExiste = COUNT(*) FROM Embarque     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'NOM'   SELECT @YaExiste = COUNT(*) FROM Nomina       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'RH'    SELECT @YaExiste = COUNT(*) FROM RH           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ASIS'  SELECT @YaExiste = COUNT(*) FROM Asiste       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'AF'    SELECT @YaExiste = COUNT(*) FROM ActivoFijo   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PC'    SELECT @YaExiste = COUNT(*) FROM PC           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'OFER'  SELECT @YaExiste = COUNT(*) FROM Oferta       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'VALE'  SELECT @YaExiste = COUNT(*) FROM Vale         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CR'    SELECT @YaExiste = COUNT(*) FROM CR           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ST'    SELECT @YaExiste = COUNT(*) FROM Soporte      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CAP'   SELECT @YaExiste = COUNT(*) FROM Capital      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'INC'   SELECT @YaExiste = COUNT(*) FROM Incidencia   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CONC'  SELECT @YaExiste = COUNT(*) FROM Conciliacion WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PPTO'  SELECT @YaExiste = COUNT(*) FROM Presup       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CREDI' SELECT @YaExiste = COUNT(*) FROM Credito      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'TMA'   SELECT @YaExiste = COUNT(*) FROM TMA          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'RSS'   SELECT @YaExiste = COUNT(*) FROM RSS          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CMP'   SELECT @YaExiste = COUNT(*) FROM Campana      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'FIS'   SELECT @YaExiste = COUNT(*) FROM Fiscal       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CONTP' SELECT @YaExiste = COUNT(*) FROM ContParalela WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'OPORT' SELECT @YaExiste = COUNT(*) FROM Oportunidad  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CORTE' SELECT @YaExiste = COUNT(*) FROM Corte        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'FRM'   SELECT @YaExiste = COUNT(*) FROM FormaExtra   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CAPT'  SELECT @YaExiste = COUNT(*) FROM Captura      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'GES'   SELECT @YaExiste = COUNT(*) FROM Gestion      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CP'    SELECT @YaExiste = COUNT(*) FROM CP           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PCP'   SELECT @YaExiste = COUNT(*) FROM PCP          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PROY'  SELECT @YaExiste = COUNT(*) FROM Proyecto     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ORG'   SELECT @YaExiste = COUNT(*) FROM Organiza     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'RE'    SELECT @YaExiste = COUNT(*) FROM Recluta      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ISL'   SELECT @YaExiste = COUNT(*) FROM ISL          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CAM'   SELECT @YaExiste = COUNT(*) FROM Cambio       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PACTO' SELECT @YaExiste = COUNT(*) FROM Contrato     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'SAUX'  SELECT @YaExiste = COUNT(*) FROM SAUX         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio
END ELSE
BEGIN
IF @Modulo = 'DIN' SELECT @YaExiste = COUNT(*) FROM Dinero WHERE Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @Serie AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) AND Ejercicio = @Ejercicio
ELSE SELECT @Ok = 60150
END
END ELSE
BEGIN
IF @Serie IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @YaExiste = COUNT(*) FROM Venta        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'PROD'  SELECT @YaExiste = COUNT(*) FROM Prod         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'COMS'  SELECT @YaExiste = COUNT(*) FROM Compra       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CXC'   SELECT @YaExiste = COUNT(*) FROM Cxc          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CXP'   SELECT @YaExiste = COUNT(*) FROM Cxp          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'AGENT' SELECT @YaExiste = COUNT(*) FROM Agent        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'GAS'   SELECT @YaExiste = COUNT(*) FROM Gasto        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'INV'   SELECT @YaExiste = COUNT(*) FROM Inv          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'DIN'   SELECT @YaExiste = COUNT(*) FROM Dinero       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CONT'  SELECT @YaExiste = COUNT(*) FROM Cont         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'EMB'   SELECT @YaExiste = COUNT(*) FROM Embarque     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'NOM'   SELECT @YaExiste = COUNT(*) FROM Nomina       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'RH'    SELECT @YaExiste = COUNT(*) FROM RH           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'ASIS'  SELECT @YaExiste = COUNT(*) FROM Asiste       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'AF'    SELECT @YaExiste = COUNT(*) FROM ActivoFijo   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'PC'    SELECT @YaExiste = COUNT(*) FROM PC           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'OFER'  SELECT @YaExiste = COUNT(*) FROM Oferta       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'VALE'  SELECT @YaExiste = COUNT(*) FROM Vale         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CR'    SELECT @YaExiste = COUNT(*) FROM CR           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'ST'    SELECT @YaExiste = COUNT(*) FROM Soporte      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CAP'   SELECT @YaExiste = COUNT(*) FROM Capital      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'INC'   SELECT @YaExiste = COUNT(*) FROM Incidencia   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CONC'  SELECT @YaExiste = COUNT(*) FROM Conciliacion WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'PPTO'  SELECT @YaExiste = COUNT(*) FROM Presup       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CREDI' SELECT @YaExiste = COUNT(*) FROM Credito	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'TMA'   SELECT @YaExiste = COUNT(*) FROM TMA          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'RSS'   SELECT @YaExiste = COUNT(*) FROM RSS          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CMP'   SELECT @YaExiste = COUNT(*) FROM Campana      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'FIS'   SELECT @YaExiste = COUNT(*) FROM Fiscal       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CONTP' SELECT @YaExiste = COUNT(*) FROM ContParalela WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'OPORT' SELECT @YaExiste = COUNT(*) FROM Oportunidad  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CORTE' SELECT @YaExiste = COUNT(*) FROM Corte        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'FRM'   SELECT @YaExiste = COUNT(*) FROM FormaExtra   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CAPT'  SELECT @YaExiste = COUNT(*) FROM Captura      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'GES'   SELECT @YaExiste = COUNT(*) FROM Gestion      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CP'    SELECT @YaExiste = COUNT(*) FROM CP           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'PCP'   SELECT @YaExiste = COUNT(*) FROM PCP          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'PROY'  SELECT @YaExiste = COUNT(*) FROM Proyecto     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'ORG'   SELECT @YaExiste = COUNT(*) FROM Organiza     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'RE'    SELECT @YaExiste = COUNT(*) FROM Recluta	     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'ISL'   SELECT @YaExiste = COUNT(*) FROM ISL          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'CAM'   SELECT @YaExiste = COUNT(*) FROM Cambio       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'PACTO' SELECT @YaExiste = COUNT(*) FROM Contrato     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado) ELSE
IF @Modulo = 'SAUX'  SELECT @YaExiste = COUNT(*) FROM SAUX         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado)
END ELSE
BEGIN
IF @Modulo = 'DIN' SELECT @YaExiste = COUNT(*) FROM Dinero WHERE Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @Serie AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado)
ELSE SELECT @Ok = 60150
END
END
IF @@ERROR <> 0 SELECT @Ok = 1
IF ISNULL(@YaExiste, 0) > 0 SELECT @Ok = 30010, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovID)+' ('+RTRIM(@Modulo)+')'
RETURN
END

