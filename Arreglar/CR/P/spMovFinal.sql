SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovFinal
@Empresa			char(5),
@Sucursal		int,
@Modulo			char(5),
@ID				int,
@Estatus			char(15),
@EstatusNuevo	char(15),
@Usuario			char(10),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Mov				char(20),
@MovID			varchar(20),
@MovTipo			char(20),
@IDGenerar		int,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@Estacion		int = NULL		

AS BEGIN
DECLARE
@OkTemp			int,
@OkRefTemp			varchar(255),
@SoporteID			int,
@SubModulo  		char(5),
@GenerarParalelo		varchar(50),
@AfectarFiscal		varchar(20),
@AfectarCP			varchar(20),
@AplicarCP			varchar(20),
@eCollaboration		bit,
@Fiscal			bit,
@CP				bit,
@CPContinua			bit,
@Registro			bit,
@ContAuto			bit,
@CFD			bit,
@FechaCancelacion		datetime,
@CPEmpresa			varchar(5),
@CPSucursal			int,
@CPModulo			varchar(5),
@CPID			int,
@CPEstatus			varchar(15),
@CPEstatusNuevo		varchar(15),
@CPUsuario			varchar(10),
@CPFechaEmision		datetime,
@CPFechaRegistro		datetime,
@CPMov			varchar(20),
@CPMovID			varchar(20),
@CPMovTipo			varchar(20),
@CPAfectarCP		varchar(20),
@ExportacionXML		bit,
@eDoc				bit,          
@CFDFlex			bit,          
@MovTipoCFDFlex		bit,          
@XML				varchar(max), 
@eDocOk				int,
@eDocOkRef			varchar(255),
@CRCFDSerie			varchar(20),
@CRCFDFolio			varchar(20),
@SubMovTipo			varchar(20),	
@InterfazEmida		bit,				
@OrigenTipo			varchar(20),  
@IDSurtido          int
SELECT @CRCFDSerie = NULL, @CRCFDFolio = NULL
/***********     ACtualizaciòn Valor Adquisición Activo Fijo     ********************/
IF @Estatus <> @EstatusNuevo AND @Modulo IN ('COMS','GAS') AND @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO')
EXEC spAplicaValAdquisicionAF @ID, @Modulo, @EstatusNuevo, @Empresa, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
/***********************************************************************************/
IF @Estatus <> @EstatusNuevo AND @EstatusNuevo = 'CANCELADO' AND @MovTipo IN (SELECT Clave FROM WMSModuloMovimiento WHERE Modulo = @Modulo)
BEGIN
DECLARE crCancelarSurtido CURSOR FOR
SELECT ID
FROM TMA
WHERE OrigenTipo = @Modulo
AND Origen = @Mov
AND OrigenID = @MovID
OPEN crCancelarSurtido
FETCH NEXT FROM crCancelarSurtido INTO @IDSurtido
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE MovFlujo
SET Cancelado = 1
WHERE Empresa = @Empresa AND OModulo = @Modulo AND OID = @ID
EXEC spAfectar 'TMA', @IDSurtido, 'CANCELAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1 ,@Ok = @Ok, @OkRef = @OkRef
FETCH NEXT FROM crCancelarSurtido INTO @IDSurtido
END
CLOSE crCancelarSurtido
DEALLOCATE crCancelarSurtido
END
IF @Estatus <> @EstatusNuevo
BEGIN
IF @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO', 'CANCELADO')
EXEC spMovCampoExtraAfectarContacto @Modulo, @Mov, @ID, @Estatus, @EstatusNuevo
INSERT MovEstatusLog (Sucursal,  Modulo,  ModuloID, Estatus,       Usuario,  Fecha)
VALUES (@Sucursal, @Modulo, @ID,      @EstatusNuevo, @Usuario, @FechaRegistro)
IF @Modulo <> 'ST' AND @Mov IS NOT NULL AND @MovID IS NOT NULL AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO', 'CANCELADO')
BEGIN
SELECT @GenerarParalelo = NULL, @AfectarFiscal = NULL, @AfectarCP = NULL, @AplicarCP = NULL
SELECT @GenerarParalelo = NULLIF(NULLIF(RTRIM(UPPER(GenerarParalelo)), ''), 'NO'),
@AfectarFiscal = UPPER(NULLIF(RTRIM(AfectarFiscal), '')),
@AfectarCP = UPPER(NULLIF(RTRIM(AfectarCP), '')),
@AplicarCP = UPPER(NULLIF(RTRIM(AplicarCP), '')),
@CFD = CFD,
@MovTipoCFDFlex = ISNULL(CFDFlex,0),
@SubMovTipo = ISNULL(SubClave, '') 
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @SubModulo = NULL
IF @GenerarParalelo IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = 'ST' AND Mov = @Mov)
BEGIN
SELECT @Ok = 70120, @OkRef = @Mov
RETURN
END
IF @GenerarParalelo  = 'ATENCION CLIENTES'    SELECT @SubModulo = 'ST' 	  ELSE
IF @GenerarParalelo  = 'ATENCION PROVEEDORES' SELECT @SubModulo = 'STPRO' ELSE
IF @GenerarParalelo  = 'ATENCION PERSONAL'    SELECT @SubModulo = 'STPER' ELSE
IF @GenerarParalelo  = 'PROYECTOS'	      SELECT @SubModulo = 'PROY'  ELSE
IF @GenerarParalelo  = 'SERVICIOS INTERNOS'   SELECT @SubModulo = 'SI'
IF @SubModulo IS NOT NULL
BEGIN
SELECT @OkTemp = @Ok, @OkRefTemp = @OkRef
SELECT @Ok = NULL, @OkRef = NULL
SELECT @SoporteID = NULL
SELECT @SoporteID = ID FROM Soporte WHERE Mov = @Mov AND MovID = @MovID AND SubModulo = @SubModulo
IF @EstatusNuevo = 'CANCELADO'
BEGIN
IF @SoporteID IS NOT NULL
EXEC spSoporte @SoporteID, 'ST', 'CANCELAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @Mov, @MovID, NULL, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
IF @SoporteID IS NULL
BEGIN
IF @Modulo = 'CXC'
INSERT Soporte (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo, Origen,   OrigenID,  Empresa,  Usuario,  UsuarioResponsable,  Estatus,      Mov, MovID,  FechaEmision,  Estado,         SubModulo,  Concepto, Proyecto, Referencia, Observaciones, UEN, Cliente, EnviarA)
SELECT GETDATE(), @Sucursal, @Sucursal,      @Sucursal,       @Modulo,    @Mov,     @MovID,   @Empresa,  @Usuario, @Usuario,           'SINAFECTAR', @Mov, @MovID, @FechaEmision, 'No comenzado', @SubModulo, Concepto, Proyecto, Referencia, Observaciones, UEN, Cliente, ClienteEnviarA FROM Cxc WHERE ID = @ID
ELSE IF @Modulo = 'VTAS'
INSERT Soporte (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo, Origen,   OrigenID,  Empresa,  Usuario,  UsuarioResponsable,  Estatus,      Mov, MovID,  FechaEmision,  Estado,         SubModulo,  Concepto, Proyecto, Referencia, Observaciones, UEN, Cliente, EnviarA)
SELECT GETDATE(), @Sucursal, @Sucursal,      @Sucursal,       @Modulo,    @Mov,     @MovID,   @Empresa,  @Usuario, @Usuario,           'SINAFECTAR', @Mov, @MovID, @FechaEmision, 'No comenzado', @SubModulo, Concepto, Proyecto, Referencia, Observaciones, UEN, Cliente, EnviarA FROM Venta WHERE ID = @ID
ELSE IF @Modulo = 'CXP'
INSERT Soporte (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo, Origen,   OrigenID,  Empresa,  Usuario,  UsuarioResponsable,  Estatus,      Mov, MovID,  FechaEmision,  Estado,         SubModulo,  Concepto, Proyecto, Referencia, Observaciones, UEN, Proveedor)
SELECT GETDATE(), @Sucursal, @Sucursal,      @Sucursal,       @Modulo,    @Mov,     @MovID,   @Empresa,  @Usuario, @Usuario,           'SINAFECTAR', @Mov, @MovID, @FechaEmision, 'No comenzado', @SubModulo, Concepto, Proyecto, Referencia, Observaciones, UEN, Proveedor FROM Cxp WHERE ID = @ID
ELSE IF @Modulo = 'COMS'
INSERT Soporte (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo, Origen,   OrigenID,  Empresa,  Usuario,  UsuarioResponsable,  Estatus,      Mov, MovID,  FechaEmision,  Estado,         SubModulo,  Concepto, Proyecto, Referencia, Observaciones, UEN, Proveedor)
SELECT GETDATE(), @Sucursal, @Sucursal,      @Sucursal,       @Modulo,    @Mov,     @MovID,   @Empresa,  @Usuario, @Usuario,           'SINAFECTAR', @Mov, @MovID, @FechaEmision, 'No comenzado', @SubModulo, Concepto, Proyecto, Referencia, Observaciones, UEN, Proveedor FROM Compra WHERE ID = @ID
ELSE IF @Modulo = 'GAS'
INSERT Soporte (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo, Origen,   OrigenID,  Empresa,  Usuario,  UsuarioResponsable,  Estatus,      Mov, MovID,  FechaEmision,  Estado,         SubModulo,  Proyecto, Observaciones, UEN, Proveedor)
SELECT GETDATE(), @Sucursal, @Sucursal,      @Sucursal,       @Modulo,    @Mov,     @MovID,   @Empresa,  @Usuario, @Usuario,           'SINAFECTAR', @Mov, @MovID, @FechaEmision, 'No comenzado', @SubModulo, Proyecto, Observaciones, UEN, Acreedor FROM Gasto WHERE ID = @ID
ELSE
INSERT Soporte (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo, Origen,   OrigenID,  Empresa,  Usuario,  UsuarioResponsable,  Estatus,      Mov,   MovID,  FechaEmision,  Estado,         SubModulo,  Concepto, Proyecto, Referencia, Observaciones)
SELECT GETDATE(), @Sucursal, @Sucursal,      @Sucursal,       @Modulo,    @Mov,     @MovID,   @Empresa,  @Usuario, @Usuario,           'SINAFECTAR', @Mov,  @MovID, @FechaEmision,  'No comenzado', @SubModulo, Concepto, Proyecto, Referencia, Observaciones
FROM Mov
WHERE Modulo = @Modulo AND ID = @ID
SELECT @SoporteID = SCOPE_IDENTITY()
IF @SoporteID IS NOT NULL
BEGIN
EXEC spSoporte @SoporteID, 'ST', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @Mov, @MovID, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'ST', @SoporteID, @Mov, @MovID, @Ok OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
SELECT @Ok = @OkTemp, @OkRef = @OkRefTemp
END
END
END
END
END
SELECT @Fiscal = ISNULL(Fiscal, 0),
@CP = ISNULL(CP, 0),
@eCollaboration = ISNULL(eCollaboration, 0),
@ContAuto = ISNULL(ContAuto, 0),
@Registro = ISNULL(Registro, 0),
@eDoc = ISNULL(eDoc, 0),
@CFDFlex = ISNULL(CFDFlex, 0),
@InterfazEmida = ISNULL(InterfazEmida, 0) 
/*,
@CfgRegistro = CfgRegistro*/
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @eCollaboration = 1 AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spECollaboration @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT
IF @Fiscal = 1 AND @AfectarFiscal NOT IN (NULL, 'NO')
BEGIN
SELECT @OkTemp = @Ok, @OkRefTemp = @OkRef
SELECT @Ok = NULL, @OkRef = NULL
EXEC spGenerarFiscal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @AfectarFiscal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000 SELECT @Ok = @OkTemp, @OkRef = @OkRefTemp
END
IF @CP = 1 AND (@AfectarCP NOT IN (NULL, 'NO') OR @AplicarCP NOT IN (NULL, 'NO'))
BEGIN
SELECT @CPContinua = 1
IF @Estatus = 'CONCLUIDO' AND @EstatusNuevo = 'PENDIENTE'
SELECT @CPContinua = 0
ELSE
IF @Estatus = 'PENDIENTE' AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
SELECT @CPContinua = 0
IF NOT EXISTS (SELECT * FROM sysobjects where id = object_id('#CPEsAjuste') and type = 'U')
CREATE TABLE #CPEsAjuste(
Empresa		varchar(5)	COLLATE Database_Default NULL,
Sucursal	int		NULL,
Modulo		varchar(5)	COLLATE Database_Default NULL,
ID		int             NULL,
Estatus		varchar(15)	COLLATE Database_Default NULL,
EstatusNuevo	varchar(15)	COLLATE Database_Default NULL,
Usuario		varchar(10)	COLLATE Database_Default NULL,
FechaEmision	datetime	NULL,
FechaRegistro	datetime	NULL,
Mov		varchar(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
MovTipo		varchar(20)	COLLATE Database_Default NULL,
AfectarCP	varchar(20)	COLLATE Database_Default NULL)
INSERT #CPEsAjuste (
Empresa,  Sucursal,  Modulo,  ID,  Estatus,  EstatusNuevo,  Usuario,  FechaEmision,  FechaRegistro,  Mov,  MovID,  MovTipo,  AfectarCP)
VALUES (@Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @AfectarCP)
END
IF @CPContinua = 1
BEGIN
SELECT @OkTemp = @Ok, @OkRefTemp = @OkRef
SELECT @Ok = NULL, @OkRef = NULL
EXEC spGenerarCP @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @AfectarCP, 0, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL
IF EXISTS (SELECT * FROM sysobjects where id = object_id('#CPEsAjuste') and type = 'U') AND @Ok IS NULL
BEGIN
DECLARE crCPEsAjuste CURSOR LOCAL FOR
SELECT Empresa, Sucursal, Modulo, ID, Estatus, EstatusNuevo, Usuario, FechaEmision, FechaRegistro, Mov, MovID, MovTipo, AfectarCP
FROM #CPEsAjuste
OPEN crCPEsAjuste
FETCH NEXT FROM crCPEsAjuste INTO @CPEmpresa, @CPSucursal, @CPModulo, @CPID, @CPEstatus, @CPEstatusNuevo, @CPUsuario, @CPFechaEmision, @CPFechaRegistro, @CPMov, @CPMovID, @CPMovTipo, @CPAfectarCP
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spGenerarCP @CPEmpresa, @CPSucursal, @CPModulo, @CPID, @CPEstatus, @CPEstatusNuevo, @CPUsuario, @CPFechaEmision, @CPFechaRegistro, @CPMov, @CPMovID, @CPMovTipo, @CPAfectarCP, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL
END
FETCH NEXT FROM crCPEsAjuste INTO @CPEmpresa, @CPSucursal, @CPModulo, @CPID, @CPEstatus, @CPEstatusNuevo, @CPUsuario, @CPFechaEmision, @CPFechaRegistro, @CPMov, @CPMovID, @CPMovTipo, @CPAfectarCP
END
CLOSE crCPEsAjuste
DEALLOCATE crCPEsAjuste
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
SELECT @Ok = @OkTemp, @OkRef = @OkRefTemp
END
END
IF @ContAuto = 1 AND @Modulo <> 'CONT' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spMovContAuto @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
/*    IF @CfgRegistro IS NOT NULL
EXEC spRegistro @CfgRegistro, @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT
*/
IF @Modulo = 'VTAS'
SELECT @CRCFDSerie = NULLIF(CRCFDSerie,''), @CRCFDFolio = NULLIF(CRCFDFolio,'') FROM Venta WHERE ID = @ID
IF (@CFD = 1 OR (@CRCFDSerie IS NOT NULL OR @CRCFDFolio IS NOT NULL)) AND @EstatusNuevo = 'CANCELADO'
BEGIN
IF @Modulo = 'CXC'
SELECT @FechaCancelacion = FechaCancelacion FROM CXC WHERE ID = @ID
IF @Modulo = 'VTAS'
SELECT @FechaCancelacion = FechaCancelacion FROM Venta WHERE ID = @ID
IF (SELECT FechaCancelacion FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID) IS NULL
UPDATE CFD SET FechaCancelacion = @FechaCancelacion WHERE Modulo = @Modulo AND ModuloID = @ID
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC xpOperacionRelevante @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND (SELECT ModuloCentral FROM Version) = 1
IF (SELECT ModuloCentral FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1
EXEC spMCMov @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC xpMovEstatus @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT
END
/*IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC vic_spRegistrarMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, @OK OUTPUT*/
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC xpMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC xpInterfacesMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND @eDoc = 1 AND @MovTipoCFDFlex = 0 
BEGIN
SELECT @eDocOk = NULL, @eDocOkRef = NULL
EXEC speDocXML @@SPID, @Empresa, @Modulo, @Mov, @ID, NULL, @EstatusNuevo, 1, 0, @XML OUTPUT, @eDocOk OUTPUT, @eDocOkRef OUTPUT
IF @eDocOk IS NOT NULL SELECT @Ok = @eDocOk, @OkRef = @eDocOkRef
END
IF (@MovTipoCFDFlex = 1) AND (@CFDFlex = 1) AND (@eDoc = 1) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) 
BEGIN
IF EXISTS(SELECT * FROM CFDFlexTemp WHERE ID = @ID AND Modulo = @Modulo)
DELETE CFDFlexTemp WHERE ID = @ID AND Modulo = @Modulo
EXEC spInsertarCFDFlexTemp @@SPID, @Empresa, @Modulo, @ID, @EstatusNuevo, @Estatus, @Mov, @MovID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDFlexTempVerificar  @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, 0,NULL, @Estacion, 1, 1, @Ok  OUTPUT, @OkRef   OUTPUT
END
IF (@MovTipoCFDFlex = 1) AND (@CFDFlex = 1) AND (@eDoc = 1) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) 
BEGIN
SELECT @eDocOk = NULL, @eDocOkRef = NULL
EXEC spCFDFlexCancelar @@SPID, @Empresa, @Modulo, @ID, @EstatusNuevo, @eDocOk OUTPUT, @eDocOkRef OUTPUT
IF @eDocOk IS NOT NULL SELECT @Ok = @eDocOk, @OkRef = @eDocOkRef
END
IF @Modulo = 'VTAS' AND @InterfazEmida = 1 AND @Estatus <> @EstatusNuevo AND @EstatusNuevo = 'PROCESAR' 
BEGIN
SELECT @SubMovTipo = ISNULL(SubClave, '') 
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @OrigenTipo = OrigenTipo FROM Venta WHERE ID = @ID 
IF @SubMovTipo = 'VTAS.NEMIDA' AND @OrigenTipo NOT IN ('POS')
EXEC spEmidaRecargaTelefonica @Modulo, @ID, @Estacion, @Empresa, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Modulo = 'DIN' AND @InterfazEmida = 1 AND @Estatus <> @EstatusNuevo AND @EstatusNuevo = 'CONCLUIDO' AND @MovTipo IN('DIN.CHE', 'DIN.CH', 'DIN.DE', 'DIN.D')
BEGIN
EXEC spEmidaDineroSubmitPayment @Modulo, @ID, @Empresa, @Estacion, @Usuario, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
END
IF (SELECT IntelMESInterfase FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
EXEC xpMESMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spMonederoFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

