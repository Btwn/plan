SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spValidarCamposCFDFlex]
@Modulo      varchar(5),
@ID          int,
@Ok          int             OUTPUT,
@OkRef       varchar(255)    OUTPUT
 
AS BEGIN
DECLARE
@MovTipo      varchar(20),
@Concepto     varchar(50),
@Referencia	varchar(50),
@Ref1			varchar(20),
@Ref2			varchar(20),
@Ref3			varchar(20),
@Ref4			varchar(20),
@Ref5			varchar(20)
IF @Modulo = 'VTAS'
BEGIN
SELECT @MovTipo = mt.Clave FROM MovTipo mt JOIN Venta v ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS' WHERE v.ID = @ID
SELECT @Referencia = NULLIF(dbo.fneDocVentaReferenciaMetodoCobro(@ID, 1),'')
SELECT @Ref1=  dbo.fnSplitScalar(@Referencia,',', 1)
SELECT @Ref2=  dbo.fnSplitScalar(@Referencia,',', 2)
SELECT @Ref3=  dbo.fnSplitScalar(@Referencia,',', 3)
SELECT @Ref4=  dbo.fnSplitScalar(@Referencia,',', 4)
SELECT @Ref5=  dbo.fnSplitScalar(@Referencia,',', 5)
IF (@Referencia IS NOT NULL)
BEGIN
IF CHARINDEX (',', @Referencia)=0 AND LEN(@Referencia )<4
SELECT @Ok = 71605, @OkRef = ISNULL(@OkRef,'') +' El número de Cuenta es menor a cuatro dígitos '
ELSE
IF (@Ref1 NOT IN (null, '') and len(@Ref1)<4) or (@Ref2 NOT IN (null, '') and len(@Ref2)<4) or (@Ref3 NOT IN (null, '') and len(@Ref3)<4) or (@Ref4 NOT IN (null, '') and len(@Ref4)<4) or (@Ref5 NOT IN (null, '') and len(@Ref5)<4)
SELECT @Ok = 71605, @OkRef = ISNULL(@OkRef,'') +' El número de Cuenta es menor a cuatro dígitos '
END
END
IF @Modulo = 'CXC'
BEGIN
SELECT @MovTipo = mt.Clave, @Concepto = NULLIF(c.Concepto,'') FROM MovTipo mt JOIN Cxc c ON c.Mov = mt.Mov AND mt.Modulo = 'CXC' WHERE c.ID = @ID
IF @Concepto IS NULL
SELECT @Ok = 71605, @OkRef = ISNULL(@OkRef,'') +' Concepto'
END
EXEC xpValidarCamposCFDFlex @MODULO,@ID,@OK OUTPUT,@OKREF OUTPUT
RETURN
END

