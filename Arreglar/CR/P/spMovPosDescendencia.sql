SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovPosDescendencia
@Estacion		int,
@Modulo			varchar(5),
@OModulo		varchar(5),
@OModuloID		int,
@Nivel			int

AS BEGIN
DECLARE
@ID					int,
@OEstatus			varchar(15),
@DModulo			varchar(5),
@DModuloID			int,
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
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WHERE OModulo = @OModulo AND OID = @OModuloID) OR @Nivel > 20 RETURN
DECLARE @MovFlujo TABLE
(
ID				int					IDENTITY(1,1),
DModulo			varchar(5)			COLLATE DATABASE_DEFAULT NOT NULL,
DID				int					NOT NULL,
OMov			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
OMovID			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
DMov			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
DMovID			varchar(20)			COLLATE DATABASE_DEFAULT NOT NULL,
Cancelado		bit					NULL DEFAULT 0,
Sucursal		int					NOT NULL DEFAULT -1,
Empresa			varchar(5)			COLLATE DATABASE_DEFAULT NOT NULL
)
INSERT @MovFlujo (DModulo, DID, OMov, OMovID, DMov, DMovID, Cancelado, Empresa, Sucursal)
SELECT  DModulo, DID, OMov, OMovID, DMov, DMovID, Cancelado, Empresa, ISNULL(Sucursal,-1)
FROM  MovFlujo
WHERE  OModulo = @OModulo
AND  OID = @OModuloID
EXEC spMovInfoEstatus @OModuloID, @OModulo, @OEstatus OUTPUT
IF @Nivel = 1
BEGIN
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WHERE OModulo = @OModulo AND OID = @OModuloID) SELECT @EsAcumulativa = 0 ELSE SELECT @EsAcumulativa = 1
SELECT TOP 1 @DModulo = '', @DModuloID = '', @DMov = '', @DMovID = '', @OMov = OMov, @OMovID = OMovID, @Cancelado = Cancelado, @Empresa = Empresa, @Sucursal = ISNULL(Sucursal,-1) FROM MovFlujo WHERE OModulo = @OModulo AND OID = @OModuloID
INSERT MovPos (Estacion,  Modulo,  Sucursal,  Empresa,  OEstatus,  OModulo,  OID,        OMov,  OMovID,  DEstatus,  DModulo,  DID,        DMov,  DMovID,  Cancelado,  Clave,                                                          Rama, EsAcumulativa,  Movimiento,                                                                             Tipo)
VALUES (@Estacion, @Modulo, @Sucursal, @Empresa, '',        @DModulo, @DModuloID, @DMov, @DMovID, @OEstatus, @OModulo, @OModuloID, @OMov, @OMovID, @Cancelado, 'DESTINO' + RTRIM(@OModulo)+RTRIM(CONVERT(varchar,@OModuloID)), NULL, @EsAcumulativa, RTRIM(@OMov) + ' ' + RTRIM(@OMovID) + ' (' + RTRIM(dbo.fnModuloNombre(@OModulo)) + ')', 'DESTINO')
END
WHILE (SELECT COUNT(ID) FROM @MovFlujo) > 0
BEGIN
SELECT TOP 1 @ID = ID, @DModulo = DModulo, @DModuloID = DID, @OMov = OMov, @OMovID = OMovID, @DMov = DMov, @DMovID = DMovID, @Cancelado = Cancelado, @Empresa = Empresa, @Sucursal = ISNULL(Sucursal,-1) FROM @MovFlujo
EXEC spMovInfoEstatus @DModuloID, @DModulo, @DEstatus OUTPUT
IF NOT EXISTS(SELECT Estacion FROM MovPos WHERE Estacion = @Estacion AND Modulo = @Modulo AND Tipo = 'DESTINO' AND OModulo = @OModulo AND OID = @OModuloID AND DModulo = @DModulo AND DID = @DModuloID AND ISNULL(Sucursal,-1) = ISNULL(@Sucursal,-1) AND Empresa = @Empresa)
BEGIN
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WHERE OModulo = @DModulo AND OID = @DModuloID) SELECT @EsAcumulativa = 0 ELSE SELECT @EsAcumulativa = 1
IF NOT EXISTS(SELECT Estacion FROM MovPos WHERE Estacion = @Estacion AND Modulo = @Modulo AND Tipo = 'DESTINO' AND OModulo = @DModulo AND OID = @DModuloID AND DModulo = @OModulo AND DID = @OModuloID AND Sucursal = @Sucursal AND Empresa = @Empresa)
INSERT MovPos (Estacion,  Modulo,  Sucursal,  Empresa,  OEstatus,  OModulo,  OID,        OMov,  OMovID,  DEstatus,  DModulo,  DID,        DMov,  DMovID,  Cancelado,  Clave,                                                          Rama,                                                           EsAcumulativa,  Movimiento,                                                                             Tipo)
VALUES (@Estacion, @Modulo, @Sucursal, @Empresa, @OEstatus, @OModulo, @OModuloID, @OMov, @OMovID, @DEstatus, @DModulo, @DModuloID, @DMov, @DMovID, @Cancelado, 'DESTINO' + RTRIM(@DModulo)+RTRIM(CONVERT(varchar,@DModuloID)), 'DESTINO' + RTRIM(@OModulo)+RTRIM(CONVERT(varchar,@OModuloID)), @EsAcumulativa, RTRIM(@DMov) + ' ' + RTRIM(@DMovID) + ' (' + RTRIM(dbo.fnModuloNombre(@DModulo)) + ')', 'DESTINO')
EXEC spMovPosDescendencia @Estacion, @Modulo, @DModulo, @DModuloID, @Nivel
END
DELETE FROM @MovFlujo WHERE ID = @ID
END
END

