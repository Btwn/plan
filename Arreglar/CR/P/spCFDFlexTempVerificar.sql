SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexTempVerificar
@Empresa		char(5),
@Sucursal		int,
@Modulo		char(5),
@ID			int,
@Estatus		char(15),
@EstatusNuevo	char(15),
@Usuario		char(10),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@LlamadaExterna      bit = 0,
@Contacto		varchar(10) = NULL,
@Estacion		int = NULL,
@ModificarModulo     bit = 0,
@Continuar           bit = 1 OUTPUT,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CFDFlexEstatus               varchar(20),
@Comprobante			varchar(50),
@Adenda			varchar(50),
@FechaServidor		datetime,
@Timbrado                     bit,
@CFDI                         bit,
@BloquearMovOtraFecha         bit,
@NoValidarOrigenDocumento     bit,
@TipoCambio                   float,
@OrigenModulo			varchar(5),
@OrigenMovimiento		varchar(20),
@MovTipoCFDFlexEstatus        varchar(20),
@MovOrigen                    varchar(20),
@CFDEsParcialidad             bit,
@CorteCuentaDe                varchar(10),
@CorteCuentaA               varchar(10)
IF @Ok IS NULL
SET @CFDFlexEstatus = 'PROCESANDO'
IF ISNULL(@Estatus,'') = @EstatusNuevo
SET @Continuar = 0
SELECT @Comprobante = NULL, @Adenda = NULL, @Timbrado = 0, @FechaServidor = dbo.fnFechaSinHora(GETDATE())
IF NULLIF(@Ok,0) IS NOT NULL
SET @Continuar = 0
SELECT @CFDI = ISNULL(CFDI,0)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @NoValidarOrigenDocumento = ISNULL(NoValidarOrigenDocumento,0)
FROM EmpresaCFD
WHERE Empresa = @Empresa
IF NULLIF(@Contacto,'') IS NULL SET @Contacto = '(Todos)'
IF @LlamadaExterna = 0
BEGIN
IF @Modulo = 'VTAS' SELECT @Contacto = Cliente,   @Mov = Mov, @MovID = MovID, @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal FROM Venta    WHERE ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @Contacto = Cliente,   @Mov = Mov, @MovID = MovID, @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal, @MovOrigen = Origen FROM Cxc      WHERE ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Contacto = Proveedor, @Mov = Mov, @MovID = MovID, @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal FROM Compra   WHERE ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @Contacto = Proveedor, @Mov = Mov, @MovID = MovID, @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal FROM Cxp      WHERE ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @Contacto = Acreedor,  @Mov = Mov, @MovID = MovID, @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal FROM Gasto    WHERE ID = @ID ELSE
IF @Modulo = 'CORTE'SELECT @Contacto = CorteCuentaDe,  @Mov = Mov, @MovID = MovID, @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal FROM Corte WHERE ID = @ID
END ELSE
BEGIN
IF NULLIF(@Contacto,'') IS NULL SET @Contacto = '(Todos)'
IF @Mov IS NULL AND @Ok IS NULL SELECT @Ok = 10160 ELSE
IF @Mov IS NOT NULL AND NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) AND @Ok IS NULL SELECT @Ok = 14055 ELSE
IF @MovID IS NULL AND @Ok IS NULL SELECT @Ok = 20915 ELSE
IF @Contacto IS NOT NULL AND NOT EXISTS(SELECT * FROM MovTipoCFDFlex WHERE Modulo = @Modulo AND Mov = @Mov AND Contacto = @Contacto) AND @Ok IS NULL SELECT @Ok = 28020, @OkRef = @Contacto
END
IF @BloquearMovOtraFecha = 1 AND @Estatus = 'CONCLUIDO'
IF @FechaEmision <> @FechaServidor SET @Ok = 10555
IF NULLIF(@MovTipo,'') IS NULL
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT
@Comprobante = Comprobante,
@Adenda = Adenda,
@MovTipoCFDFlexEstatus = NULLIF(Estatus,''),
@OrigenModulo = NULLIF(OrigenModulo,''),
@OrigenMovimiento = NULLIF(OrigenMov,'')
FROM MovTipoCFDFlex
WHERE Modulo = @Modulo
AND Mov = @Mov
AND Contacto = @Contacto
IF @Comprobante IS NULL AND @Adenda IS NULL
BEGIN
SELECT
@Comprobante = Comprobante,
@Adenda = Adenda,
@MovTipoCFDFlexEstatus = NULLIF(Estatus,''),
@OrigenModulo = NULLIF(OrigenModulo,''),
@OrigenMovimiento = NULLIF(OrigenMov,'')
FROM MovTipoCFDFlex
WHERE Modulo = @Modulo
AND Mov = @Mov
AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Contacto) = @Contacto
END
IF @OK IS NULL
BEGIN
IF EXISTS(SELECT 1 FROM CFD WHERE ModuloID = @ID AND Modulo = @Modulo AND ISNULL(Timbrado,0) = 1 AND @CFDI = 1) 
SET @Continuar = 0
ELSE
IF EXISTS(SELECT 1 FROM CFD WHERE ModuloID = @ID AND Modulo = @Modulo AND Documento IS NOT NULL AND @CFDI = 0) 
SET @Continuar = 0
END
IF @OrigenModulo IS NOT NULL AND @OrigenMovimiento IS NOT NULL AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT 1 
FROM  MovFlujo
WHERE Empresa = @Empresa
AND DModulo = @Modulo
AND DMov = @Mov
AND DMovID = @MovID
AND Cancelado = 0
AND OModulo = @OrigenModulo
AND OMov = @OrigenMovimiento
)
SET @Continuar = 0
END
IF @MovOrigen IS NULL
SELECT @MovOrigen = dbo.fnCFDFlexOrigenDetalle(@ID)
IF @Modulo = 'CXC' AND ('CXC.D' IN(SELECT Clave FROM MovTipo WHERE Mov = @MovOrigen AND Modulo = @Modulo) AND @NoValidarOrigenDocumento = 1)
BEGIN
SELECT @CFDEsParcialidad = ISNULL(CFDEsParcialidad,0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @CFDEsParcialidad = 0
BEGIN
SELECT @Ok = 71670
SET @Continuar = 0
END
END
IF @Modulo = 'CXC' AND @MovTipo = 'CXC.C' AND @CFDEsParcialidad = 1
IF(SELECT COUNT(1) FROM CxcD WHERE ID = @ID AND NULLIF(AplicaID,'') IS NOT NULL) > 1 SELECT @Ok = 60210 
IF @Modulo = 'CORTE'
BEGIN
SELECT @CorteCuentaDe = ISNULL(CorteCuentaDe, ''), @CorteCuentaA = ISNULL(CorteCuentaA, '') FROM Corte WHERE ID = @ID
IF(@CorteCuentaDe <> @CorteCuentaA) OR(@CorteCuentaDe = '') OR(@CorteCuentaA = '')
SELECT @Ok = 28055
END
IF @Comprobante IS NULL AND @Adenda IS NULL SET @Continuar = 0
IF @MovTipoCFDFlexEstatus <> '(VARIOS)'
BEGIN
IF (@MovTipoCFDFlexEstatus <> @Estatus) OR (@MovTipoCFDFlexEstatus IS NULL) OR (NULLIF(@Estatus,'') IS NULL) SET @Continuar = 0
END ELSE
IF @Estatus NOT IN (SELECT NULLIF(Estatus,'') FROM MovTipoCFDFlexEstatus WHERE Modulo = @Modulo AND Mov = @Mov AND Contacto = @Contacto)
BEGIN
IF @Estatus NOT IN (SELECT NULLIF(Estatus,'') FROM MovTipoCFDFlexEstatus WHERE Modulo = @Modulo AND Mov = @Mov AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Contacto) = @Contacto) SET @Continuar = 0
END
IF @OK IS NULL
EXEC spCFDFlexValidarPlantillaConfiguracion @Comprobante, @Modulo, @CFDI, @Ok OUTPUT, @OkRef OUTPUT
IF @ModificarModulo = 1
BEGIN
IF @Modulo = 'VTAS' UPDATE Venta SET CFDFlexEstatus = @CFDFlexEstatus WHERE ID = @ID ELSE
IF @Modulo = 'CXC' UPDATE Cxc SET CFDFlexEstatus = @CFDFlexEstatus WHERE ID = @ID ELSE
IF @Modulo = 'COMS' UPDATE Compra SET CFDFlexEstatus = @CFDFlexEstatus WHERE ID = @ID ELSE
IF @Modulo = 'CXP' UPDATE Cxp SET CFDFlexEstatus = @CFDFlexEstatus WHERE ID = @ID ELSE
IF @Modulo = 'GAS' UPDATE Gasto SET CFDFlexEstatus = @CFDFlexEstatus WHERE ID = @ID     ELSE
IF @Modulo = 'CORTE' UPDATE Corte SET CFDFlexEstatus = @CFDFlexEstatus WHERE ID = @ID
END
RETURN
END

