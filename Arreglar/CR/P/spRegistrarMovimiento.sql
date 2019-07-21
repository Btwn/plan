SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegistrarMovimiento
@Sucursal		int,
@Empresa		char(5),
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@ID			int,
@Ejercicio		int,
@Periodo		int,
@FechaRegistro		datetime,
@FechaEmision		datetime,
@Concepto		varchar(50),
@Proyecto		varchar(50),
@MovMoneda		char(10),
@MovTipoCambio		float,
@Usuario		char(10),
@Autorizacion		char(10),
@Referencia		varchar(50),
@DocFuente		int,
@Observaciones		varchar(255),
@Generar		bit,
@GenerarMov 		char(20),
@GenerarMovID 		varchar(20),
@GenerarID		int,
@Ok			int		OUTPUT

AS BEGIN
IF @Ok IS NOT NULL RETURN
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @Modulo NOT IN ('EMB', 'ST', 'CAM', 'ASIS', 'TMA', 'RSS', 'CMP', 'FRM', 'CAPT', 'GES', 'PROY'/*, 'ACT'*/, 'SAUX', 'CORTE', 'CONTP')
BEGIN
IF NULLIF(RTRIM(@MovMoneda), '') IS NULL SELECT @Ok = 30040 ELSE
IF NULLIF(@MovTipoCambio, 0) IS NULL SELECT @Ok = 30140
END
IF (SELECT ConsecutivoControl FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1
EXEC spMovTipoConsecutivo @Empresa, @Modulo, @Mov, @MovID, @FechaEmision, @Ok OUTPUT
IF @MovID IS NOT NULL
EXEC spMovInsertar @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
@Concepto, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Ok OUTPUT
IF @Generar = 1 AND @GenerarMovID IS NOT NULL
EXEC spMovInsertar @Sucursal, @Empresa, @Modulo, @GenerarMov, @GenerarMovID, @GenerarID, @Ejercicio, @Periodo, @FechaRegistro, @FechaRegistro,
@Concepto, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Ok OUTPUT
EXEC spTareasPorOmision @Modulo, @ID, @Empresa, @Mov, @Usuario
RETURN
END

