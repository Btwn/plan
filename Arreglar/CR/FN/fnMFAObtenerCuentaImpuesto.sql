SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAObtenerCuentaImpuesto
(
@Modulo						varchar(5),
@Mov							varchar(20),
@ImpuestoTasa					float,
@ImpuestoTipo				varchar(20),
@Empresa						varchar(5),
@Poliza						varchar(20),
@PolizaID					varchar(20)
)
RETURNS varchar(20)
AS BEGIN
DECLARE
@Cuenta			varchar(20),
@ID				int
DECLARE @MFATipoCtaImpuesto TABLE (
Modulo				varchar(5) COLLATE DATABASE_DEFAULT NULL,
ModuloCalif			int NULL DEFAULT 0,
Mov					varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovCalif			int NULL DEFAULT 0,
Minimo				int NULL DEFAULT 0,
Maximo				int NULL DEFAULT 0,
ImpuestoCalif		int NULL DEFAULT 0,
ImpuestoTipo		varchar(20) COLLATE DATABASE_DEFAULT NULL,
ImpuestoTipoCalif	int NULL DEFAULT 0,
CalificacionTotal   int NULL DEFAULT 0,
Cuenta				varchar(20) COLLATE DATABASE_DEFAULT NULL
)
INSERT @MFATipoCtaImpuesto (Modulo, Mov, Minimo, Maximo, ImpuestoTipo)
SELECT  Modulo, Mov, Minimo, Maximo, ImpuestoTipo
FROM  MFATipoCtaImpuesto
WHERE  ImpuestoTipo = @ImpuestoTipo
UPDATE @MFATipoCtaImpuesto
SET
ModuloCalif      = CASE
WHEN Modulo = @Modulo   THEN 2
WHEN Modulo = '(Todos)' THEN 1
ELSE 0
END,
MovCalif         = CASE
WHEN Mov = @Mov      THEN 2
WHEN Mov = '(Todos)' THEN 1
ELSE 0
END,
ImpuestoCalif    = CASE
WHEN @ImpuestoTasa BETWEEN Minimo AND Maximo THEN 2
ELSE 0
END,
ImpuestoTipoCalif = CASE
WHEN ImpuestoTipo = @ImpuestoTipo  THEN 2
ELSE 0
END
UPDATE @MFATipoCtaImpuesto
SET CalificacionTotal = ModuloCalif + MovCalif + ImpuestoCalif + ImpuestoTipoCalif
SELECT
TOP 1 @Cuenta = Cuenta
FROM @MFATipoCtaImpuesto
WHERE CalificacionTotal = (SELECT MAX(CalificacionTotal) FROM @MFATipoCtaImpuesto
WHERE ModuloCalif <> 0
AND MovCalif <> 0
AND ImpuestoCalif <> 0
AND ImpuestoTipoCalif <> 0)
SELECT @ID = ID FROM Cont WHERE MovID = @PolizaID AND Mov = @Poliza AND Empresa = @Empresa
IF NOT EXISTS(SELECT 1 FROM ContD WHERE Cuenta = @Cuenta AND ID = @ID)
SET @Cuenta = NULL
RETURN @Cuenta
END

