SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSConsecutivoAuto
@Empresa			varchar(20),
@Sucursal			int,
@Mov				varchar(20),
@MovID				varchar(20)		OUTPUT,
@Prefijo			varchar(5)		OUTPUT,
@Consecutivo		int				OUTPUT,
@noAprobacion		int				OUTPUT,
@FechaAprobacion	datetime		OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Host				varchar(20),
@Cluster			varchar(20),
@CFDAnterior		bit,
@CFDFlex			bit,
@CFD				bit,
@PrefijoSucursal	varchar(5)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT
@CFDAnterior = ISNULL(CFD,0),
@CFDFlex = ISNULL(CFDFlex,0)
FROM MovTipo mt WITH (NOLOCK)
WHERE mt.Modulo = 'POS'
AND mt.Mov = @Mov
IF ISNULL(@CFDAnterior,0) = 1 OR ISNULL(@CFDFlex,0) = 1
SELECT @CFD = 1
IF NOT EXISTS(SELECT 1 FROM POSC pc WITH (NOLOCK) WHERE pc.Empresa = @Empresa AND pc.Sucursal = @Sucursal AND pc.Host = @Host AND pc.Mov = @Mov) AND @Ok IS NULL
BEGIN
IF ISNULL(@CFD,0) = 1
SELECT @Ok = 53040
ELSE
BEGIN
SELECT @PrefijoSucursal = Prefijo
FROM Sucursal s WITH (NOLOCK)
WHERE s.Sucursal = @Sucursal
IF @Mov IS NOT NULL
INSERT POSC (
Empresa, Sucursal, Mov, Prefijo, Consecutivo, Host, FolioD, FolioA)
VALUES (
@Empresa, @Sucursal, @Mov, ISNULL(@Host,'POS')+'-', 0, @Host, 1, 999999999)
END
END
IF @Ok IS NULL
BEGIN
SELECT TOP 1
@Consecutivo = pc.Consecutivo,
@Prefijo = pc.Prefijo,
@noAprobacion = pc.noAprobacion,
@FechaAprobacion = pc.fechaAprobacion
FROM POSC pc WITH (NOLOCK)
WHERE pc.Empresa = @Empresa
AND pc.Sucursal = @Sucursal
AND pc.Host = @Host
AND pc.Mov = @Mov
AND ISNULL(pc.Consecutivo,0) < pc.FolioA
ORDER BY FolioA
SELECT @Consecutivo = @Consecutivo + 1
UPDATE POSC WITH (ROWLOCK) SET Consecutivo = @Consecutivo
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Host = @Host
AND Mov = @Mov
AND ISNULL(@Consecutivo,0) < FolioA
AND ISNULL(@Consecutivo,0) >= FolioD
SELECT @MovID = ISNULL(@Prefijo, '') + CONVERT(varchar, @Consecutivo)
END
RETURN
END

