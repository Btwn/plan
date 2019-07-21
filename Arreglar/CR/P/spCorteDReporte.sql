SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDReporte
@ID                	int,
@Accion				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
@MovTipo     		char(20),
@SubMovTipo     	char(20),
@FechaEmision      	datetime,
@FechaAfectacion    datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@MovUsuario			char(10),
@CorteFrecuencia	varchar(50),
@CorteGrupo			varchar(50),
@CorteTipo			varchar(50),
@CortePeriodo		int,
@CorteEjercicio		int,
@CorteOrigen		varchar(50),
@CorteCuentaTipo	varchar(20),
@CorteGrupoDe		varchar(10),
@CorteGrupoA		varchar(10),
@CorteSubGrupoDe	varchar(20),
@CorteSubGrupoA		varchar(20),
@CorteCuentaDe		varchar(10),
@CorteCuentaA		varchar(10),
@CorteSubCuentaDe	varchar(50),
@CorteSubCuenta2A	varchar(50),
@CorteSubCuenta2De	varchar(50),
@CorteSubCuenta3A	varchar(50),
@CorteSubCuenta3De	varchar(50),
@CorteSubCuentaA	varchar(50),
@CorteUENDe			int,
@CorteUENA			int,
@CorteProyectoDe	varchar(50),
@CorteProyectoA		varchar(50),
@CorteFechaD		datetime,
@CorteFechaA		datetime,
@Moneda				varchar(10),
@TipoCambio			float,
@CorteTitulo		varchar(100),
@CorteMensaje		varchar(100),
@CorteEstatus		varchar(15),
@CorteSucursalDe	int,
@CorteSucursalA		int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@SucursalDestino	int,
@SucursalOrigen		int,
@Estacion			int,
@CorteValuacion		varchar(50),
@CorteDesglosar		varchar(20),
@CorteFiltrarFechas	bit,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @FechaA			datetime,
@CuentaAux		varchar(10),
@CuentaAuxAnt		varchar(10),
@MonedaAux		varchar(10),
@MonedaAuxAnt		varchar(10),
@AplicaAux		varchar(20),
@AplicaAuxAnt		varchar(20),
@AplicaIDAux		varchar(20),
@AplicaIDAuxAnt	varchar(20)
IF @MovTipo IN('CORTE.EDOCTACXC', 'CORTE.EDOCTACXP')
BEGIN
EXEC spCorteDReporteCx @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
END
ELSE IF @MovTipo IN('CORTE.INVVAL')
BEGIN
IF @CorteValuacion NOT IN('PEPS', 'UEPS')
EXEC spCorteDReporteInvVal
@ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
ELSE IF @CorteValuacion IN('PEPS', 'UEPS')
EXEC spCorteDReporteInvValOtraMoneda
@ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
END
ELSE IF @MovTipo IN('CORTE.CORTEIMPORTE') AND ISNULL(@SubMovTipo, '') = ''
BEGIN
EXEC spCorteDReporteCorteImp @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Ok OUTPUT, @OkRef OUTPUT
END
ELSE IF @MovTipo IN('CORTE.CORTECONTABLE') AND ISNULL(@SubMovTipo, '') = ''
BEGIN
EXEC spCorteDReporteCorteCont @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Ok OUTPUT, @OkRef OUTPUT
END
ELSE IF @MovTipo IN('CORTE.CORTEUNIDADES') AND ISNULL(@SubMovTipo, '') = ''
BEGIN
EXEC spCorteDReporteCorteUnidades @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Ok OUTPUT, @OkRef OUTPUT
END
ELSE IF @MovTipo IN('CORTE.CORTECX') AND ISNULL(@SubMovTipo, '') = ''
BEGIN
EXEC spCorteDReporteCorteCx @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Ok OUTPUT, @OkRef OUTPUT
END
EXEC xpCorteDReporte @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
INSERT INTO CorteDReporte(
ID,				Renglon,			RenglonSub,				Tipo,			Columna1,			Columna2,			Columna3,
Columna4,		Columna5,			Columna6,				Columna7,		Columna8,			Columna9,			Columna10,
Columna11,		Columna12,			Columna13,				Columna14,		Columna15,			Columna16,			Columna17,
Columna18,		Columna19,			Columna20,				Columna21,		Columna22,			Columna23,			Columna24,
Columna25,		Columna26,			Columna27,				Columna28,		Columna29,			Columna30,			Columna31,
Columna32,		Columna33,			Columna34,				Columna35,		Columna36,			Columna37,			Columna38,
Columna39,		Columna40,			Columna41,				Columna42,		Columna43,			Columna44,			Columna45,
Columna46,		Columna47,			Columna48,				Columna49,		Columna50,			Agrupador1,			Agrupador2,
Agrupador3,		Agrupador4,			Agrupador5,				Agrupador6,		Agrupador7,			Agrupador8,			Agrupador9,
Agrupador10)
SELECT ID,				RID * 2048,			0,						Tipo,			Columna1,			Columna2,			Columna3,
Columna4,		Columna5,			Columna6,				Columna7,		Columna8,			Columna9,			Columna10,
Columna11,		Columna12,			Columna13,				Columna14,		Columna15,			Columna16,			Columna17,
Columna18,		Columna19,			Columna20,				Columna21,		Columna22,			Columna23,			Columna24,
Columna25,		Columna26,			Columna27,				Columna28,		Columna29,			Columna30,			Columna31,
Columna32,		Columna33,			Columna34,				Columna35,		Columna36,			Columna37,			Columna38,
Columna39,		Columna40,			Columna41,				Columna42,		Columna43,			Columna44,			Columna45,
Columna46,		Columna47,			Columna48,				Columna49,		Columna50,			Agrupador1,			Agrupador2,
Agrupador3,		Agrupador4,			Agrupador5,				Agrupador6,		Agrupador7,			Agrupador8,			Agrupador9,
Agrupador10
FROM #CorteDReporte
RETURN
END

