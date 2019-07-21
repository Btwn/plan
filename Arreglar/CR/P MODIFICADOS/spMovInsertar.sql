SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovInsertar
@Sucursal	int,
@Empresa	char(5),
@Modulo		char(5),
@Mov		char(20),
@MovID		varchar(20),
@ID		int,
@Ejercicio	int,
@Periodo	int,
@FechaRegistro	datetime,
@FechaEmision	datetime,
@Concepto	varchar(50),
@Proyecto	varchar(50),
@Moneda		char(10),
@TipoCambio	float,
@Usuario	char(10),
@Autorizacion	char(10),
@Referencia	varchar(50),
@DocFuente	int,
@Observaciones	varchar(255),
@Ok		int	OUTPUT

AS BEGIN
DECLARE
@Turno		int,
@Integradora	bit
IF @Ok IS NOT NULL RETURN
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Turno = NULL, @Integradora = 0
EXEC xpMovInsertar @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision, @Concepto, @Proyecto, @Moneda, @TipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones,
@Turno OUTPUT, @Integradora OUTPUT, @Ok OUTPUT
UPDATE Mov WITH(ROWLOCK)
SET Sucursal	= @Sucursal,
Empresa 	= @Empresa,
Modulo	 	= @Modulo,
Mov		= @Mov,
MovID		= @MovID,
ID		= @ID,
Ejercicio	= @Ejercicio,
Periodo	= @Periodo,
FechaRegistro	= @FechaRegistro,
FechaEmision	= @FechaEmision,
Concepto	= @Concepto,
Proyecto	= @Proyecto,
Moneda		= @Moneda,
TipoCambio	= @TipoCambio,
Usuario	= @Usuario,
Autorizacion	= @Autorizacion,
Referencia	= @Referencia,
DocFuente	= @DocFuente,
Observaciones	= @Observaciones,
Turno          = @Turno,
Integradora	= @Integradora
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
AND ID	 = @ID
IF @@ROWCOUNT = 0
BEGIN
INSERT INTO Mov (Sucursal, Empresa, Modulo, Mov, MovID, ID, Ejercicio, Periodo, FechaRegistro, FechaEmision,
Concepto, Proyecto, Moneda, TipoCambio,
Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Turno, Integradora)
VALUES (@Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
@Concepto, @Proyecto, @Moneda, @TipoCambio,
@Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @Turno, @Integradora)
IF (SELECT TieneMovimientos FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario) = 0
UPDATE Usuario WITH(ROWLOCK) SET TieneMovimientos = 1 WHERE Usuario = @Usuario
IF (SELECT TieneMovimientos FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa) = 0
UPDATE Empresa WITH(ROWLOCK) SET TieneMovimientos = 1 WHERE Empresa = @Empresa
END
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
BEGIN
IF @Modulo = 'CONT'  UPDATE Cont       WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta      WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod       WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent      WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto      WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque   WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH         WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC         WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale       WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR         WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte    WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital    WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito    WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana    WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte      WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura    WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion    WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP         WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto   WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza   WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	   WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL        WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio     WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato   WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX       WITH(ROWLOCK) SET FechaRegistro = @FechaRegistro, Periodo = @Periodo, Ejercicio = @Ejercicio WHERE ID = @ID
END
RETURN
END

