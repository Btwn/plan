SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAObtenerCuentaEntidad
(
@Modulo						varchar(5),
@Mov							varchar(20),
@Categoria					varchar(50),
@Grupo						varchar(50),
@Familia						varchar(50),
@Entidad						varchar(10),
@EntidadTipo					varchar(20),
@Empresa						varchar(5),
@Poliza						varchar(20),
@PolizaID					varchar(20)
)
RETURNS varchar(20)
AS BEGIN
DECLARE
@Cuenta			varchar(20),
@ID				int
DECLARE @MFATipoCtaEntidad TABLE (
Modulo				varchar(5) COLLATE DATABASE_DEFAULT NULL,
ModuloCalif			int NULL DEFAULT 0,
Mov					varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovCalif			int NULL DEFAULT 0,
Categoria			varchar(50) COLLATE DATABASE_DEFAULT NULL,
CategoriaCalif		int NULL DEFAULT 0,
Grupo				varchar(50) COLLATE DATABASE_DEFAULT NULL,
GrupoCalif			int NULL DEFAULT 0,
Familia				varchar(50) COLLATE DATABASE_DEFAULT NULL,
FamiliaCalif		int NULL DEFAULT 0,
Entidad				varchar(50) COLLATE DATABASE_DEFAULT NULL,
EntidadCalif		int NULL DEFAULT 0,
EntidadTipo			varchar(50) COLLATE DATABASE_DEFAULT NULL,
EntidadTipoCalif	int NULL DEFAULT 0,
CalificacionTotal   int NULL DEFAULT 0,
Cuenta				varchar(20) COLLATE DATABASE_DEFAULT NULL
)
INSERT @MFATipoCtaEntidad (Modulo, Mov, Categoria, Grupo, Familia, Entidad, EntidadTipo)
SELECT  Modulo, Mov, Categoria, Grupo, Familia, Entidad, EntidadTipo
FROM  MFATipoCtaEntidad WITH(NOLOCK)
UPDATE @MFATipoCtaEntidad
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
CategoriaCalif   = CASE
WHEN Categoria = @Categoria THEN 2
WHEN Categoria = '(Todos)'  THEN 1
ELSE 0
END,
GrupoCalif       = CASE
WHEN Grupo = @Grupo    THEN 2
WHEN Grupo = '(Todos)' THEN 1
ELSE 0
END,
FamiliaCalif     = CASE
WHEN Familia = @Familia  THEN 2
WHEN Familia = '(Todos)' THEN 1
ELSE 0
END,
EntidadCalif     = CASE
WHEN Entidad = @Entidad  THEN 2
WHEN Entidad = '(Todos)' THEN 1
ELSE 0
END,
EntidadTipoCalif = CASE
WHEN EntidadTipo = @EntidadTipo  THEN 2
ELSE 0
END
UPDATE @MFATipoCtaEntidad
SET CalificacionTotal = ModuloCalif + MovCalif + CategoriaCalif + GrupoCalif + FamiliaCalif + EntidadCalif + EntidadTipoCalif
SELECT
TOP 1 @Cuenta = Cuenta
FROM @MFATipoCtaEntidad
WHERE CalificacionTotal = (SELECT MAX(CalificacionTotal) FROM @MFATipoCtaEntidad
WHERE ModuloCalif <> 0
AND MovCalif <> 0
AND CategoriaCalif <> 0
AND GrupoCalif <> 0
AND FamiliaCalif <> 0
AND EntidadCalif <> 0
AND EntidadTipoCalif <> 0)
SELECT @ID = ID FROM Cont WITH(NOLOCK) WHERE MovID = @PolizaID AND Mov = @Poliza AND Empresa = @Empresa
IF NOT EXISTS(SELECT 1 FROM ContD WITH(NOLOCK) WHERE Cuenta = @Cuenta AND ID = @ID)
SET @Cuenta = NULL
RETURN @Cuenta
END

