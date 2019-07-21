SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovChecarConsecutivo
@Empresa  char(5),
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
FROM MovTipo WITH (NOLOCK)
WHERE Modulo = @Modulo
AND Mov    = @Mov
SELECT @YaExiste = NULL
IF @ConsecutivoPorPeriodo = 1
BEGIN
IF @Serie IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @YaExiste = COUNT(*) FROM Venta     WITH (NOLOCK)        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROD'  SELECT @YaExiste = COUNT(*) FROM Prod      WITH (NOLOCK)         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'COMS'  SELECT @YaExiste = COUNT(*) FROM Compra    WITH (NOLOCK)        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXC'   SELECT @YaExiste = COUNT(*) FROM Cxc       WITH (NOLOCK)         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXP'   SELECT @YaExiste = COUNT(*) FROM Cxp       WITH (NOLOCK)         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AGENT' SELECT @YaExiste = COUNT(*) FROM Agent     WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INV'   SELECT @YaExiste = COUNT(*) FROM Inv       WITH (NOLOCK)         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GAS'   SELECT @YaExiste = COUNT(*) FROM Gasto     WITH (NOLOCK)         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'DIN'   SELECT @YaExiste = COUNT(*) FROM Dinero    WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONT'  SELECT @YaExiste = COUNT(*) FROM Cont      WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'EMB'   SELECT @YaExiste = COUNT(*) FROM Embarque  WITH (NOLOCK)     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'NOM'   SELECT @YaExiste = COUNT(*) FROM Nomina    WITH (NOLOCK)      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RH'    SELECT @YaExiste = COUNT(*) FROM RH        WITH (NOLOCK)      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ASIS'  SELECT @YaExiste = COUNT(*) FROM Asiste    WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AF'    SELECT @YaExiste = COUNT(*) FROM ActivoFijo WITH (NOLOCK)  	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PC'    SELECT @YaExiste = COUNT(*) FROM PC     WITH (NOLOCK)      	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OFER'  SELECT @YaExiste = COUNT(*) FROM Oferta  WITH (NOLOCK)     	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VALE'  SELECT @YaExiste = COUNT(*) FROM Vale    WITH (NOLOCK)     	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CR'    SELECT @YaExiste = COUNT(*) FROM CR      WITH (NOLOCK)     	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ST'    SELECT @YaExiste = COUNT(*) FROM Soporte   WITH (NOLOCK)   	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAP'   SELECT @YaExiste = COUNT(*) FROM Capital   WITH (NOLOCK)   	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INC'   SELECT @YaExiste = COUNT(*) FROM Incidencia WITH (NOLOCK)	  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONC'  SELECT @YaExiste = COUNT(*) FROM Conciliacion WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PPTO'  SELECT @YaExiste = COUNT(*) FROM Presup  WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CREDI' SELECT @YaExiste = COUNT(*) FROM Credito  WITH (NOLOCK)      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'TMA'   SELECT @YaExiste = COUNT(*) FROM TMA     WITH (NOLOCK)     	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RSS'   SELECT @YaExiste = COUNT(*) FROM RSS     WITH (NOLOCK)     	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CMP'   SELECT @YaExiste = COUNT(*) FROM Campana   WITH (NOLOCK)     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FIS'   SELECT @YaExiste = COUNT(*) FROM Fiscal   WITH (NOLOCK)      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONTP' SELECT @YaExiste = COUNT(*) FROM ContParalela WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OPORT' SELECT @YaExiste = COUNT(*) FROM Oportunidad WITH (NOLOCK)   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CORTE' SELECT @YaExiste = COUNT(*) FROM Corte  WITH (NOLOCK)        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FRM'   SELECT @YaExiste = COUNT(*) FROM FormaExtra WITH (NOLOCK)    WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAPT'  SELECT @YaExiste = COUNT(*) FROM Captura   WITH (NOLOCK)     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GES'   SELECT @YaExiste = COUNT(*) FROM Gestion  WITH (NOLOCK)      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CP'    SELECT @YaExiste = COUNT(*) FROM CP      WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PCP'   SELECT @YaExiste = COUNT(*) FROM PCP     WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROY'  SELECT @YaExiste = COUNT(*) FROM Proyecto  WITH (NOLOCK)   	 WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ORG'   SELECT @YaExiste = COUNT(*) FROM Organiza  WITH (NOLOCK)     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RE'    SELECT @YaExiste = COUNT(*) FROM Recluta  WITH (NOLOCK)      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ISL'   SELECT @YaExiste = COUNT(*) FROM ISL    WITH (NOLOCK)        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAM'   SELECT @YaExiste = COUNT(*) FROM Cambio  WITH (NOLOCK)       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'SAUX'  SELECT @YaExiste = COUNT(*) FROM SAUX   WITH (NOLOCK)        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo
END ELSE
BEGIN
IF @Modulo = 'DIN' SELECT @YaExiste = COUNT(*) FROM Dinero WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @Serie AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio AND Periodo = @Periodo
ELSE SELECT @Ok = 60150
END
END ELSE
IF @ConsecutivoPorEjercicio = 1
BEGIN
IF @Serie IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @YaExiste = COUNT(*) FROM Venta        WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PROD'  SELECT @YaExiste = COUNT(*) FROM Prod         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'COMS'  SELECT @YaExiste = COUNT(*) FROM Compra       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CXC'   SELECT @YaExiste = COUNT(*) FROM Cxc          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CXP'   SELECT @YaExiste = COUNT(*) FROM Cxp          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'AGENT' SELECT @YaExiste = COUNT(*) FROM Agent        WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'GAS'   SELECT @YaExiste = COUNT(*) FROM Gasto        WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'INV'   SELECT @YaExiste = COUNT(*) FROM Inv          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'DIN'   SELECT @YaExiste = COUNT(*) FROM Dinero       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CONT'  SELECT @YaExiste = COUNT(*) FROM Cont         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'EMB'   SELECT @YaExiste = COUNT(*) FROM Embarque     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'NOM'   SELECT @YaExiste = COUNT(*) FROM Nomina       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'RH'    SELECT @YaExiste = COUNT(*) FROM RH           WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ASIS'  SELECT @YaExiste = COUNT(*) FROM Asiste       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'AF'    SELECT @YaExiste = COUNT(*) FROM ActivoFijo   WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PC'    SELECT @YaExiste = COUNT(*) FROM PC           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'OFER'  SELECT @YaExiste = COUNT(*) FROM Oferta       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'VALE'  SELECT @YaExiste = COUNT(*) FROM Vale         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CR'    SELECT @YaExiste = COUNT(*) FROM CR           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ST'    SELECT @YaExiste = COUNT(*) FROM Soporte      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CAP'   SELECT @YaExiste = COUNT(*) FROM Capital      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'INC'   SELECT @YaExiste = COUNT(*) FROM Incidencia    WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CONC'  SELECT @YaExiste = COUNT(*) FROM Conciliacion WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PPTO'  SELECT @YaExiste = COUNT(*) FROM Presup       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CREDI' SELECT @YaExiste = COUNT(*) FROM Credito      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'TMA'   SELECT @YaExiste = COUNT(*) FROM TMA          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'RSS'   SELECT @YaExiste = COUNT(*) FROM RSS          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CMP'   SELECT @YaExiste = COUNT(*) FROM Campana      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'FIS'   SELECT @YaExiste = COUNT(*) FROM Fiscal       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CONTP' SELECT @YaExiste = COUNT(*) FROM ContParalela  WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'OPORT' SELECT @YaExiste = COUNT(*) FROM Oportunidad  WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CORTE' SELECT @YaExiste = COUNT(*) FROM Corte        WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'FRM'   SELECT @YaExiste = COUNT(*) FROM FormaExtra   WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CAPT'  SELECT @YaExiste = COUNT(*) FROM Captura      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'GES'   SELECT @YaExiste = COUNT(*) FROM Gestion      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CP'    SELECT @YaExiste = COUNT(*) FROM CP           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PCP'   SELECT @YaExiste = COUNT(*) FROM PCP          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PROY'  SELECT @YaExiste = COUNT(*) FROM Proyecto     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ORG'   SELECT @YaExiste = COUNT(*) FROM Organiza     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'RE'    SELECT @YaExiste = COUNT(*) FROM Recluta      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'ISL'   SELECT @YaExiste = COUNT(*) FROM ISL          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'CAM'   SELECT @YaExiste = COUNT(*) FROM Cambio       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'PACTO' SELECT @YaExiste = COUNT(*) FROM Contrato     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio ELSE
IF @Modulo = 'SAUX'  SELECT @YaExiste = COUNT(*) FROM SAUX         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio
END ELSE
BEGIN
IF @Modulo = 'DIN' SELECT @YaExiste = COUNT(*) FROM Dinero  WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @Serie AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) AND Ejercicio = @Ejercicio
ELSE SELECT @Ok = 60150
END
END ELSE
BEGIN
IF @Serie IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @YaExiste = COUNT(*) FROM Venta         WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'PROD'  SELECT @YaExiste = COUNT(*) FROM Prod          WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'COMS'  SELECT @YaExiste = COUNT(*) FROM Compra       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CXC'   SELECT @YaExiste = COUNT(*) FROM Cxc          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CXP'   SELECT @YaExiste = COUNT(*) FROM Cxp          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'AGENT' SELECT @YaExiste = COUNT(*) FROM Agent        WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'GAS'   SELECT @YaExiste = COUNT(*) FROM Gasto        WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'INV'   SELECT @YaExiste = COUNT(*) FROM Inv           WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'DIN'   SELECT @YaExiste = COUNT(*) FROM Dinero       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CONT'  SELECT @YaExiste = COUNT(*) FROM Cont         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'EMB'   SELECT @YaExiste = COUNT(*) FROM Embarque     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'NOM'   SELECT @YaExiste = COUNT(*) FROM Nomina       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'RH'    SELECT @YaExiste = COUNT(*) FROM RH           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'ASIS'  SELECT @YaExiste = COUNT(*) FROM Asiste       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'AF'    SELECT @YaExiste = COUNT(*) FROM ActivoFijo   WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'PC'    SELECT @YaExiste = COUNT(*) FROM PC           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'OFER'  SELECT @YaExiste = COUNT(*) FROM Oferta       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'VALE'  SELECT @YaExiste = COUNT(*) FROM Vale         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CR'    SELECT @YaExiste = COUNT(*) FROM CR           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'ST'    SELECT @YaExiste = COUNT(*) FROM Soporte      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CAP'   SELECT @YaExiste = COUNT(*) FROM Capital      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'INC'   SELECT @YaExiste = COUNT(*) FROM Incidencia   WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CONC'  SELECT @YaExiste = COUNT(*) FROM Conciliacion WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'PPTO'  SELECT @YaExiste = COUNT(*) FROM Presup        WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CREDI' SELECT @YaExiste = COUNT(*) FROM Credito	 WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'TMA'   SELECT @YaExiste = COUNT(*) FROM TMA          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'RSS'   SELECT @YaExiste = COUNT(*) FROM RSS          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CMP'   SELECT @YaExiste = COUNT(*) FROM Campana      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'FIS'   SELECT @YaExiste = COUNT(*) FROM Fiscal       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CONTP' SELECT @YaExiste = COUNT(*) FROM ContParalela WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'OPORT' SELECT @YaExiste = COUNT(*) FROM Oportunidad  WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CORTE' SELECT @YaExiste = COUNT(*) FROM Corte        WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'FRM'   SELECT @YaExiste = COUNT(*) FROM FormaExtra   WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CAPT'  SELECT @YaExiste = COUNT(*) FROM Captura      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'GES'   SELECT @YaExiste = COUNT(*) FROM Gestion      WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CP'    SELECT @YaExiste = COUNT(*) FROM CP           WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'PCP'   SELECT @YaExiste = COUNT(*) FROM PCP          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'PROY'  SELECT @YaExiste = COUNT(*) FROM Proyecto     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'ORG'   SELECT @YaExiste = COUNT(*) FROM Organiza     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'RE'    SELECT @YaExiste = COUNT(*) FROM Recluta	    WITH (NOLOCK)   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'ISL'   SELECT @YaExiste = COUNT(*) FROM ISL          WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'CAM'   SELECT @YaExiste = COUNT(*) FROM Cambio       WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'PACTO' SELECT @YaExiste = COUNT(*) FROM Contrato     WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) ) ELSE
IF @Modulo = 'SAUX'  SELECT @YaExiste = COUNT(*) FROM SAUX         WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) )
END ELSE
BEGIN
IF @Modulo = 'DIN' SELECT @YaExiste = COUNT(*) FROM Dinero WITH (NOLOCK)  WHERE Empresa = @Empresa AND Mov = @Mov AND CtaDinero = @Serie AND MovID = @MovID AND Estatus NOT IN (SELECT Estatus FROM CfgEstatusConsecutivoDuplicado WITH (NOLOCK) )
ELSE SELECT @Ok = 60150
END
END
IF @@ERROR <> 0 SELECT @Ok = 1
IF ISNULL(@YaExiste, 0) > 0 SELECT @Ok = 30010, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovID)+' ('+RTRIM(@Modulo)+')'
RETURN
END

