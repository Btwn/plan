SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBuscaEstatusMovFlujo
@Empresa	varchar(255),
@OModulo	varchar(20),
@Oid		int,
@OMov		varchar(20),
@OMovid		varchar(20)

AS
BEGIN
DECLARE @Estatus			varchar(20),
@DModulo			varchar(20),
@Did				int,
@DMov				varchar(20),
@DMovid				varchar(20)
IF EXISTS(SELECT * FROM MovFlujo WHERE Empresa = @Empresa AND OModulo = @OModulo AND OID = @Oid AND OMov = @OMov AND OMovid = @OMovid)
BEGIN
DECLARE crMovPendientes CURSOR LOCAL FOR
SELECT DModulo, DID, DMov, DMovID FROM MovFlujo
WHERE Empresa = @Empresa AND OModulo = @OModulo AND OID = @Oid AND OMov = @OMov AND OMovid = @OMovid
OPEN crMovPendientes
FETCH NEXT FROM crMovPendientes INTO @DModulo, @Did, @DMov, @DMovid
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @DModulo = 'AF'
IF EXISTS(SELECT * FROM ActivoFijo WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM ActivoFijo WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE  CONTINUE
ELSE IF @DModulo = 'COMS'
IF EXISTS(SELECT * FROM Compra WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Compra WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'CONC'
IF EXISTS(SELECT * FROM Conciliacion WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Conciliacion WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'CXC'
IF EXISTS(SELECT * FROM Cxc WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Cxc WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'CXP'
IF EXISTS(SELECT * FROM Cxp WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Cxp WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'DIN'
IF EXISTS(SELECT * FROM Dinero WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Dinero WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'EMB'
IF EXISTS(SELECT * FROM Embarque WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Embarque WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'GAS'
IF EXISTS(SELECT * FROM Gasto WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Gasto WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'GES'
IF EXISTS(SELECT * FROM Gestion WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Gestion WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'INV'
IF EXISTS(SELECT * FROM Inv WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Inv WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'NOM'
IF EXISTS(SELECT * FROM Nomina WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Nomina WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'PROY'
IF EXISTS(SELECT * FROM Proyecto WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Proyecto WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
ELSE IF @DModulo = 'VTAS'
IF EXISTS(SELECT * FROM Venta WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid)
BEGIN
INSERT INTO #RastreoMovFlujo SELECT ID,Empresa,@DModulo,Mov,MovID,Estatus FROM Venta WHERE ID = @Did AND Empresa = @Empresa AND Mov = @DMov AND MovID = @DMovid
EXEC spBuscaEstatusMovFlujo @Empresa, @DModulo, @Did, @DMov, @DMovid
END
ELSE CONTINUE
END
FETCH NEXT FROM crMovPendientes INTO @DModulo, @Did, @DMov, @DMovid
END
CLOSE crMovPendientes
DEALLOCATE crMovPendientes
END
END

