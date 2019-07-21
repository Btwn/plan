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
IF @Modulo = 'CONT'  SELECT @Consecutivo = MAX(Consecutivo) FROM ContC          WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VTAS'  SELECT @Consecutivo = MAX(Consecutivo) FROM VentaC         WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROD'  SELECT @Consecutivo = MAX(Consecutivo) FROM ProdC          WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'COMS'  SELECT @Consecutivo = MAX(Consecutivo) FROM CompraC        WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INV'   SELECT @Consecutivo = MAX(Consecutivo) FROM InvC          WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXC'   SELECT @Consecutivo = MAX(Consecutivo) FROM CxcC          WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CXP'   SELECT @Consecutivo = MAX(Consecutivo) FROM CxpC           WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AGENT' SELECT @Consecutivo = MAX(Consecutivo) FROM AgentC         WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GAS'   SELECT @Consecutivo = MAX(Consecutivo) FROM GastoC        WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'DIN'   SELECT @Consecutivo = MAX(Consecutivo) FROM DineroC        WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'EMB'   SELECT @Consecutivo = MAX(Consecutivo) FROM EmbarqueC     WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'NOM'   SELECT @Consecutivo = MAX(Consecutivo) FROM NominaC       WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RH'    SELECT @Consecutivo = MAX(Consecutivo) FROM RHC           WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ASIS'  SELECT @Consecutivo = MAX(Consecutivo) FROM AsisteC       WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'AF'    SELECT @Consecutivo = MAX(Consecutivo) FROM ActivoFijoC    WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PC'    SELECT @Consecutivo = MAX(Consecutivo) FROM PCC            WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OFER'  SELECT @Consecutivo = MAX(Consecutivo) FROM OfertaC       WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'VALE'  SELECT @Consecutivo = MAX(Consecutivo) FROM ValeC         WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CR'    SELECT @Consecutivo = MAX(Consecutivo) FROM CRC           WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ST'    SELECT @Consecutivo = MAX(Consecutivo) FROM SoporteC       WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAP'   SELECT @Consecutivo = MAX(Consecutivo) FROM CapitalC      WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'INC'   SELECT @Consecutivo = MAX(Consecutivo) FROM IncidenciaC    WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONC'  SELECT @Consecutivo = MAX(Consecutivo) FROM ConciliacionC  WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PPTO'  SELECT @Consecutivo = MAX(Consecutivo) FROM PresupC 	 WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CREDI' SELECT @Consecutivo = MAX(Consecutivo) FROM CreditoC 	  WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'TMA'   SELECT @Consecutivo = MAX(Consecutivo) FROM TMAC          WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RSS'   SELECT @Consecutivo = MAX(Consecutivo) FROM RSSC          WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CMP'   SELECT @Consecutivo = MAX(Consecutivo) FROM CampanaC      WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FIS'   SELECT @Consecutivo = MAX(Consecutivo) FROM FiscalC        WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CONTP' SELECT @Consecutivo = MAX(Consecutivo) FROM ContParalelaC WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'OPORT' SELECT @Consecutivo = MAX(Consecutivo) FROM OportunidadC  WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CORTE' SELECT @Consecutivo = MAX(Consecutivo) FROM CorteC        WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'FRM'   SELECT @Consecutivo = MAX(Consecutivo) FROM FormaExtraC   WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAPT'  SELECT @Consecutivo = MAX(Consecutivo) FROM CapturaC      WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'GES'   SELECT @Consecutivo = MAX(Consecutivo) FROM GestionC      WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CP'    SELECT @Consecutivo = MAX(Consecutivo) FROM CPC           WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PCP'   SELECT @Consecutivo = MAX(Consecutivo) FROM PCPC          WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PROY'  SELECT @Consecutivo = MAX(Consecutivo) FROM ProyectoC     WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ORG'   SELECT @Consecutivo = MAX(Consecutivo) FROM OrganizaC     WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'RE'    SELECT @Consecutivo = MAX(Consecutivo) FROM ReclutaC      WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'ISL'   SELECT @Consecutivo = MAX(Consecutivo) FROM ISLC          WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'CAM'   SELECT @Consecutivo = MAX(Consecutivo) FROM CambioC       WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PACTO' SELECT @Consecutivo = MAX(Consecutivo) FROM ContratoC     WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'SAUX'  SELECT @Consecutivo = MAX(Consecutivo) FROM SAUXC          WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo ELSE
IF @Modulo = 'PREV'  SELECT @Consecutivo = MAX(Consecutivo) FROM PrevencionLDC WITH (NOLOCK)  WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Serie = @Serie AND Ejercicio = @Ejercicio AND Periodo = @Periodo
RETURN
END

