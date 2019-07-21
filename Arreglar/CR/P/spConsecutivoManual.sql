SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConsecutivoManual
@Sucursal		int,
@Empresa     	char(5),
@Modulo		char(5),
@ID			int,
@Mov      		char(20),
@Ejercicio	        int,
@Periodo	        int,
@Serie		varchar(50) 	OUTPUT,
@MovIDSt		varchar(20) 	OUTPUT,
@Ok			int	 	OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Consecutivo		bigint,
@ConsecutivoPorPeriodo	bit,
@ConsecutivoPorEjercicio	bit,
@ConsecutivoPorEmpresa	char(20),
@ConsecutivoSerial		bit,
@ConsecutivoDigitos		int,
@ConsecutivoSucursalEsp	bit,
@SucursalEsp		int,
@ModuloAfectacion		char(5),
@MovID			bigint
IF dbo.fnEsNumerico(@MovIDSt) = 0 OR CHARINDEX('.', @MovIDSt) > 0 OR SUBSTRING(@MovIDSt, 1, 1) = '0' RETURN
SELECT @MovID = CONVERT(bigint, @MovIDSt)
EXEC xpConsecutivoSerie @Empresa, @Modulo, @ID, @Mov, @Serie OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @ModuloAfectacion = @Modulo
SELECT @Modulo                  = ConsecutivoModulo,
@Mov    		  = ConsecutivoMov,
@ConsecutivoPorPeriodo   = ConsecutivoPorPeriodo,
@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio,
@ConsecutivoPorEmpresa   = ISNULL(UPPER(ConsecutivoPorEmpresa), 'SI'),
@ConsecutivoSucursalEsp  = ISNULL(ConsecutivoSucursalEsp, 0),
@SucursalEsp             = SucursalEsp
FROM MovTipo
WHERE Modulo = @Modulo
AND Mov    = @Mov
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @ConsecutivoSerial  = ConsecutivoSerial,
@ConsecutivoDigitos = ConsecutivoDigitos
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @ConsecutivoPorPeriodo   = 0 SELECT @Periodo = NULL
IF @ConsecutivoPorEjercicio = 0 SELECT @Ejercicio = NULL
IF @ConsecutivoPorEmpresa   = 'NO'    SELECT @Empresa = NULL ELSE
IF @ConsecutivoPorEmpresa   = 'GRUPO' SELECT @Empresa = Clave FROM EmpresaGrupo, Empresa WHERE EmpresaGrupo.Grupo = Empresa.Grupo AND Empresa.Empresa = @Empresa
IF @ConsecutivoSucursalEsp = 1 AND @SucursalEsp IS NOT NULL SELECT @Sucursal = @SucursalEsp
EXEC spConsecutivoUltimo @Sucursal, @Empresa, @Modulo, @Mov, @Ejercicio, @Periodo, @Serie, @Consecutivo OUTPUT, @Ok OUTPUT
IF @Consecutivo < @MovID
BEGIN
IF @Modulo = 'CONT'  UPDATE ContC         WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VTAS'  UPDATE VentaC        WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROD'  UPDATE ProdC         WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'COMS'  UPDATE CompraC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INV'   UPDATE InvC          WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXC'   UPDATE CxcC          WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXP'   UPDATE CxpC          WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AGENT' UPDATE AgentC        WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GAS'   UPDATE GastoC        WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'DIN'   UPDATE DineroC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'EMB'   UPDATE EmbarqueC     WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'NOM'   UPDATE NominaC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RH'    UPDATE RHC           WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ASIS'  UPDATE AsisteC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijoC   WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PC'    UPDATE PCC           WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OFER'  UPDATE OfertaC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VALE'  UPDATE ValeC         WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CR'    UPDATE CRC           WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ST'    UPDATE SoporteC      WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAP'   UPDATE CapitalC      WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INC'   UPDATE IncidenciaC   WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONC'  UPDATE ConciliacionC WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PPTO'  UPDATE PresupC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CREDI' UPDATE CreditoC      WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'TMA'   UPDATE TMAC          WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RSS'   UPDATE RSSC          WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CMP'   UPDATE CampanaC      WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FIS'   UPDATE FiscalC       WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONTP' UPDATE ContParalelaC WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OPORT' UPDATE OportunidadC  WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CORTE' UPDATE CorteC        WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtraC   WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAPT'  UPDATE CapturaC      WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GES'   UPDATE GestionC      WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CP'    UPDATE CPC           WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PCP'   UPDATE PCPC          WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROY'  UPDATE ProyectoC     WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ORG'   UPDATE OrganizaC	WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RE'    UPDATE ReclutaC	WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ISL'   UPDATE ISLC		WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAM'   UPDATE CambioC		WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PACTO' UPDATE ContratoC	WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'SAUX'  UPDATE SAUXC	    WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PREV'  UPDATE PrevencionLDC WITH (ROWLOCK) SET Consecutivo = @MovID WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo
IF @@ROWCOUNT = 0
BEGIN
IF @Modulo = 'CONT'  INSERT INTO ContC         (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'VTAS'  INSERT INTO VentaC        (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PROD'  INSERT INTO ProdC         (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'COMS'  INSERT INTO CompraC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'INV'   INSERT INTO InvC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CXC'   INSERT INTO CxcC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CXP'   INSERT INTO CxpC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'AGENT' INSERT INTO AgentC        (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'GAS'   INSERT INTO GastoC        (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'DIN'   INSERT INTO DineroC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'EMB'   INSERT INTO EmbarqueC     (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'NOM'   INSERT INTO NominaC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'RH'    INSERT INTO RHC           (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'ASIS'  INSERT INTO AsisteC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'AF'    INSERT INTO ActivoFijoC   (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PC'    INSERT INTO PCC           (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'OFER'  INSERT INTO OfertaC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'VALE'  INSERT INTO ValeC         (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CR'    INSERT INTO CRC           (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'ST'    INSERT INTO SoporteC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CAP'   INSERT INTO CapitalC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'INC'   INSERT INTO IncidenciaC   (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CONC'  INSERT INTO ConciliacionC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PPTO'  INSERT INTO PresupC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CREDI' INSERT INTO CreditoC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'TMA'   INSERT INTO TMAC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'RSS'   INSERT INTO RSSC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CMP'   INSERT INTO CampanaC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'FIS'   INSERT INTO FiscalC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CONTP' INSERT INTO ContParalelaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'OPORT' INSERT INTO OportunidadC  (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CORTE' INSERT INTO CorteC        (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'FRM'   INSERT INTO FormaExtraC   (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CAPT'  INSERT INTO CapturaC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'GES'   INSERT INTO GestionC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CP'    INSERT INTO CPC           (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PCP'   INSERT INTO PCPC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PROY'  INSERT INTO ProyectoC     (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'ORG'   INSERT INTO OrganizaC     (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'RE'    INSERT INTO ReclutaC      (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'ISL'   INSERT INTO ISLC          (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'CAM'   INSERT INTO CambioC       (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PACTO' INSERT INTO ContratoC     (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'SAUX'  INSERT INTO SAUXC         (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID) ELSE
IF @Modulo = 'PREV'  INSERT INTO PrevencionLDC  (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo) VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, @MovID)
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @ConsecutivoSerial = 1
BEGIN
SELECT @Serie = LTRIM(RTRIM(@Serie))
IF @Serie IS NOT NULL AND dbo.fnEsNumerico(@Serie) = 1
BEGIN
EXEC spLlenarCeros @MovID, @ConsecutivoDigitos, @MovIDSt OUTPUT
SELECT @MovID = CONVERT(int, LTRIM(RTRIM(@Serie)) + RTRIM(LTRIM(@MovIDSt)))
EXEC spConsecutivoActualizar @Modulo, @ID, @MovID
END
END
SELECT @MovIDSt = CONVERT(char, @MovID)
/*  IF @Ok IS NULL
EXEC spConsecutivoControl @Empresa, @ModuloAfectacion, @Mov, @Ejercicio, @Periodo, @Serie, @MovID, @Ok OUTPUT*/
RETURN
END

