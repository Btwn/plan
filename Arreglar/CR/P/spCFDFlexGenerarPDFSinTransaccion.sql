SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexGenerarPDFSinTransaccion
@Modulo				varchar(5),
@ID					int,
@Accion				char(20),
@Usuario			varchar(10),
@Ok					int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa				varchar(5),
@Mov					varchar(20),
@Contacto				varchar(10),
@Estatus				varchar(15),
@CFDFlex				bit,
@CFDFlexMovTipo			bit,
@EnviarAlAfectar		bit,
@AlmacenarTipo			varchar(20),
@MovTipoCFDFlexEstatus	varchar(15)
IF @Modulo = 'VTAS'
SELECT @Empresa = Empresa, @Mov = Mov, @Contacto = Cliente, @Estatus = Estatus FROM Venta WHERE ID = @ID
ELSE
IF @Modulo = 'CXC'
SELECT @Empresa = Empresa, @Mov = Mov, @Contacto = Cliente, @Estatus = Estatus FROM Cxc WHERE ID = @ID
SELECT @CFDFlex = ISNULL(CFDFlex,0) FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @CFDFlexMovTipo = ISNULL(CFDFlex,0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @EnviarAlAfectar = ISNULL(EnviarAlAfectar,0) FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @MovTipoCFDFlexEstatus = NULLIF(Estatus,'') FROM MovTipoCFDFlex WHERE Modulo = @Modulo AND Mov = @Mov AND Contacto = @Contacto
IF @MovTipoCFDFlexEstatus IS NULL
SELECT @MovTipoCFDFlexEstatus = NULLIF(Estatus,'') FROM MovTipoCFDFlex WHERE Modulo = @Modulo AND Mov = @Mov AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Contacto) = @Contacto
IF (@Ok IS NULL AND @EnviarAlAfectar = 1 AND @CFDFlex = 1 AND @CFDFlexMovTipo = 1 AND @MovTipoCFDFlexEstatus IS NOT NULL)
IF @Estatus = @MovTipoCFDFlexEstatus OR (@MovTipoCFDFlexEstatus = '(VARIOS)' AND (@Estatus IN (SELECT NULLIF(Estatus,'') FROM MovTipoCFDFlexEstatus WHERE Modulo = @Modulo AND Mov = @Mov AND Contacto = @Contacto) OR @Estatus IN (SELECT NULLIF(Estatus,'') FROM MovTipoCFDFlexEstatus WHERE Modulo = @Modulo AND Mov = @Mov AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Contacto) = @Contacto)))
BEGIN
SELECT @AlmacenarTipo = NULL
SELECT @AlmacenarTipo = NULLIF(AlmacenarTipo,'') FROM CteCFD WHERE Cliente = @Contacto
EXEC spCFDFlexGenerarPDF @Empresa, @Modulo, @Mov, @ID, @Usuario, 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @AlmacenarTipo = 'Adicional'
EXEC spCFDFlexGenerarPDF @Empresa, @Modulo, @Mov, @ID, @Usuario, 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END

