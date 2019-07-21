SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovPosAscendencia
@Estacion		int,
@Modulo			varchar(5),
@DModulo		varchar(5),
@DModuloID		int,
@Nivel			int

AS BEGIN
DECLARE
@ID					int,
@OEstatus			varchar(15),
@OModulo			varchar(5),
@OModuloID			int,
@Empresa			varchar(5),
@Sucursal			int,
@DEstatus			varchar(15),
@DMov				varchar(20),
@DMovID				varchar(20),
@OMov				varchar(20),
@OMovID				varchar(20),
@Cancelado			bit,
@EsAcumulativa		bit
SELECT @Nivel = @Nivel + 1
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WITH(NOLOCK) WHERE DModulo = @DModulo AND DID = @DModuloID) OR @Nivel > 20 RETURN
DECLARE @MovFlujo TABLE
(
ID				int					IDENTITY(1,1),
OModulo			varchar(5)			COLLATE DATABASE_DEFAULT NOT NULL,
OID				int					NOT NULL,
OMov			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
OMovID			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
DMov			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
DMovID			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
Cancelado		bit					NULL DEFAULT 0,
Sucursal		int					NOT NULL DEFAULT -1,
Empresa			varchar(5)			COLLATE DATABASE_DEFAULT NOT NULL
)
INSERT @MovFlujo (OModulo, OID, OMov, OMovID, DMov, DMovID, Cancelado, Empresa, Sucursal)
SELECT  OModulo, OID, OMov, OMovID, DMov, DMovID, Cancelado, Empresa, ISNULL(Sucursal,-1)
FROM  MovFlujo WITH(NOLOCK)
WHERE  DModulo = @DModulo
AND  DID = @DModuloID
EXEC spMovInfoEstatus @DModuloID, @DModulo, @DEstatus OUTPUT
IF @Nivel = 1
BEGIN
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WITH(NOLOCK) WHERE DModulo = @DModulo AND DID = @DModuloID) SELECT @EsAcumulativa = 0 ELSE SELECT @EsAcumulativa = 1
SELECT TOP 1 @OModulo = '', @OModuloID = '', @OMov = '', @OMovID = '', @DMov = DMov, @DMovID = DMovID, @Cancelado = Cancelado, @Empresa = Empresa, @Sucursal = ISNULL(Sucursal,-1) FROM MovFlujo WITH(NOLOCK) WHERE DModulo = @DModulo AND DID = @DModuloID
INSERT MovPos (Estacion,  Modulo,  Sucursal,  Empresa,  OEstatus,  OModulo,  OID,        OMov,  OMovID,  DEstatus,  DModulo,  DID,        DMov,  DMovID,  Cancelado,  Clave,                                                         Rama, EsAcumulativa,  Movimiento,                                                                             Tipo)
VALUES (@Estacion, @Modulo, @Sucursal, @Empresa, '',        @OModulo, @OModuloID, @OMov, @OMovID, @DEstatus, @DModulo, @DModuloID, @DMov, @DMovID, @Cancelado, 'ORIGEN' + RTRIM(@DModulo)+RTRIM(CONVERT(varchar,@DModuloID)), NULL, @EsAcumulativa, RTRIM(@DMov) + ' ' + RTRIM(@DMovID) + ' (' + RTRIM(dbo.fnModuloNombre(@DModulo)) + ')', 'ORIGEN')
END
WHILE (SELECT COUNT(ID) FROM @MovFlujo) > 0
BEGIN
SELECT TOP 1 @ID = ID, @OModulo = OModulo, @OModuloID = OID, @OMov = OMov, @OMovID = OMovID, @DMov = DMov, @DMovID = DMovID, @Cancelado = Cancelado, @Empresa = Empresa, @Sucursal = ISNULL(Sucursal,-1) FROM @MovFlujo
EXEC spMovInfoEstatus @OModuloID, @OModulo, @OEstatus OUTPUT
IF NOT EXISTS(SELECT Estacion FROM MovPos WITH(NOLOCK) WHERE Estacion = @Estacion AND Modulo = @Modulo AND Tipo = 'ORIGEN' AND OModulo = @OModulo AND OID = @OModuloID AND DModulo = @DModulo AND DID = @DModuloID AND ISNULL(Sucursal,-1) = ISNULL(@Sucursal,-1) AND Empresa = @Empresa)
BEGIN
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WITH(NOLOCK) WHERE DModulo = @OModulo AND DID = @OModuloID) SELECT @EsAcumulativa = 0 ELSE SELECT @EsAcumulativa = 1
IF NOT EXISTS(SELECT Estacion FROM MovPos WITH(NOLOCK) WHERE Estacion = @Estacion AND Modulo = @Modulo AND Tipo = 'ORIGEN' AND OModulo = @DModulo AND OID = @DModuloID AND DModulo = @OModulo AND DID = @OModuloID AND Sucursal = @Sucursal AND Empresa = @Empresa)
INSERT MovPos (Estacion,  Modulo,  Sucursal,  Empresa,  OEstatus,  OModulo,  OID,        OMov,  OMovID,  DEstatus,  DModulo,  DID,        DMov,  DMovID,  Cancelado,  Clave,                                                         Rama,                                                          EsAcumulativa,  Movimiento,                                                                             Tipo)
VALUES (@Estacion, @Modulo, @Sucursal, @Empresa, @DEstatus, @DModulo, @DModuloID, @DMov, @DMovID, @OEstatus, @OModulo, @OModuloID, @OMov, @OMovID, @Cancelado, 'ORIGEN' + RTRIM(@OModulo)+RTRIM(CONVERT(varchar,@OModuloID)), 'ORIGEN' + RTRIM(@DModulo)+RTRIM(CONVERT(varchar,@DModuloID)), @EsAcumulativa, RTRIM(@OMov) + ' ' + RTRIM(@OMovID) + ' (' + RTRIM(dbo.fnModuloNombre(@OModulo)) + ')', 'ORIGEN')
EXEC spMovPosAscendencia @Estacion, @Modulo, @OModulo, @OModuloID, @Nivel
END
DELETE FROM @MovFlujo WHERE ID = @ID
END
END

