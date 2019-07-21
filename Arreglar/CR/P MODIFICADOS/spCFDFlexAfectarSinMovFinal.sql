SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexAfectarSinMovFinal
@Empresa        varchar(5),
@Modulo         varchar(5),
@Mov            varchar(20),
@MovID          varchar(20),
@ID             int,
@EstatusNuevo   varchar(15),
@Estatus        varchar(15)= NULL,
@Ok             int  = NULL    OUTPUT,
@OkRef          varchar(255)= NULL     OUTPUT

AS BEGIN
DECLARE
@eDoc			bit,
@CFDFlex			bit,
@MovTipoCFDFlex		bit ,
@CFD                        bit
SELECT @eDoc = ISNULL(eDoc, 0),
@CFDFlex = ISNULL(CFDFlex, 0)
FROM EmpresaGral WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @CFD = CFD,
@MovTipoCFDFlex = ISNULL(CFDFlex,0)
FROM MovTipo WITH (NOLOCK)
WHERE Modulo = @Modulo AND Mov = @Mov
IF EXISTS(SELECT * FROM CFDFlexTemp WITH (NOLOCK) WHERE Estacion = @@SPID)
DELETE CFDFlexTemp WHERE Estacion = @@SPID
IF (@MovTipoCFDFlex = 1) AND (@CFDFlex = 1) AND (@eDoc = 1) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) 
BEGIN
EXEC spInsertarCFDFlexTemp @@SPID, @Empresa, @Modulo, @ID, @EstatusNuevo,  @Estatus, @Mov, @MovID, @Ok OUTPUT, @OkRef OUTPUT
END
IF (@MovTipoCFDFlex = 1) AND (@CFDFlex = 1) AND (@eDoc = 1) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) 
BEGIN
EXEC spCFDFlexCancelar @@SPID, @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
END
IF EXISTS(SELECT * FROM CFDFlexTemp WITH (NOLOCK) WHERE Estacion = @@SPID) AND @Ok IS NULL
EXEC  spCFDFlexGenerar @@SPID, @ID, @Modulo, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

