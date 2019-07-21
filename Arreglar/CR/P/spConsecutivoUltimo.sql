SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConsecutivoUltimo
@Sucursal		int,
@Empresa     	char(5),
@Modulo		char(5),
@Mov      		char(20),
@Ejercicio	        int,
@Periodo	        int,
@Serie		varchar(50),
@Consecutivo		bigint		OUTPUT,
@Ok			int		OUTPUT

AS BEGIN
SELECT @Consecutivo = NULL
IF @Modulo = 'CONT'  SELECT @Consecutivo = MAX(Consecutivo) FROM ContC         WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VTAS'  SELECT @Consecutivo = MAX(Consecutivo) FROM VentaC        WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROD'  SELECT @Consecutivo = MAX(Consecutivo) FROM ProdC         WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'COMS'  SELECT @Consecutivo = MAX(Consecutivo) FROM CompraC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INV'   SELECT @Consecutivo = MAX(Consecutivo) FROM InvC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXC'   SELECT @Consecutivo = MAX(Consecutivo) FROM CxcC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXP'   SELECT @Consecutivo = MAX(Consecutivo) FROM CxpC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AGENT' SELECT @Consecutivo = MAX(Consecutivo) FROM AgentC        WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GAS'   SELECT @Consecutivo = MAX(Consecutivo) FROM GastoC        WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'DIN'   SELECT @Consecutivo = MAX(Consecutivo) FROM DineroC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'EMB'   SELECT @Consecutivo = MAX(Consecutivo) FROM EmbarqueC     WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'NOM'   SELECT @Consecutivo = MAX(Consecutivo) FROM NominaC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RH'    SELECT @Consecutivo = MAX(Consecutivo) FROM RHC           WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ASIS'  SELECT @Consecutivo = MAX(Consecutivo) FROM AsisteC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AF'    SELECT @Consecutivo = MAX(Consecutivo) FROM ActivoFijoC   WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PC'    SELECT @Consecutivo = MAX(Consecutivo) FROM PCC           WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OFER'  SELECT @Consecutivo = MAX(Consecutivo) FROM OfertaC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VALE'  SELECT @Consecutivo = MAX(Consecutivo) FROM ValeC         WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CR'    SELECT @Consecutivo = MAX(Consecutivo) FROM CRC           WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ST'    SELECT @Consecutivo = MAX(Consecutivo) FROM SoporteC      WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAP'   SELECT @Consecutivo = MAX(Consecutivo) FROM CapitalC      WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INC'   SELECT @Consecutivo = MAX(Consecutivo) FROM IncidenciaC   WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONC'  SELECT @Consecutivo = MAX(Consecutivo) FROM ConciliacionC WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PPTO'  SELECT @Consecutivo = MAX(Consecutivo) FROM PresupC 	 WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CREDI' SELECT @Consecutivo = MAX(Consecutivo) FROM CreditoC 	 WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'TMA'   SELECT @Consecutivo = MAX(Consecutivo) FROM TMAC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RSS'   SELECT @Consecutivo = MAX(Consecutivo) FROM RSSC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CMP'   SELECT @Consecutivo = MAX(Consecutivo) FROM CampanaC      WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FIS'   SELECT @Consecutivo = MAX(Consecutivo) FROM FiscalC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONTP' SELECT @Consecutivo = MAX(Consecutivo) FROM ContParalelaC WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OPORT' SELECT @Consecutivo = MAX(Consecutivo) FROM OportunidadC  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CORTE' SELECT @Consecutivo = MAX(Consecutivo) FROM CorteC        WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FRM'   SELECT @Consecutivo = MAX(Consecutivo) FROM FormaExtraC   WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAPT'  SELECT @Consecutivo = MAX(Consecutivo) FROM CapturaC      WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GES'   SELECT @Consecutivo = MAX(Consecutivo) FROM GestionC      WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CP'    SELECT @Consecutivo = MAX(Consecutivo) FROM CPC           WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PCP'   SELECT @Consecutivo = MAX(Consecutivo) FROM PCPC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROY'  SELECT @Consecutivo = MAX(Consecutivo) FROM ProyectoC     WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ORG'   SELECT @Consecutivo = MAX(Consecutivo) FROM OrganizaC     WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RE'    SELECT @Consecutivo = MAX(Consecutivo) FROM ReclutaC      WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ISL'   SELECT @Consecutivo = MAX(Consecutivo) FROM ISLC          WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAM'   SELECT @Consecutivo = MAX(Consecutivo) FROM CambioC       WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PACTO' SELECT @Consecutivo = MAX(Consecutivo) FROM ContratoC     WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'SAUX'  SELECT @Consecutivo = MAX(Consecutivo) FROM SAUXC         WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PREV'  SELECT @Consecutivo = MAX(Consecutivo) FROM PrevencionLDC WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo
RETURN
END

