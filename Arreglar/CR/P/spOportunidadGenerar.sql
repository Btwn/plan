SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOportunidadGenerar
@ID				int,
@Base			char(20),
@Sucursal	int,
@Empresa	char(5),
@Modulo		char(5),
@Ejercicio	int,
@Periodo	int,
@Usuario	char(10),
@FechaEmision	datetime,
@Estatus	char(15),
@Almacen	char(10),
@AlmacenDestino char(10),
@Mov		char(20),
@MovID 		varchar(20),
@GenerarDirecto	bit,
@GenerarMov		char(20),
@GenerarSerie	char(20),
@ContactoTipo	varchar(20),
@GenerarMovID 	varchar(20)	OUTPUT,
@GenerarID		int		OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT

AS BEGIN
DECLARE @Renglon			int,
@RenglonAnt		int,
@Contacto			varchar(10)
SELECT @RenglonAnt = 0
WHILE(1=1)
BEGIN
IF @Base = 'PENDIENTE'
SELECT @Renglon = MIN(Renglon)
FROM OportunidadD
WHERE ID = @ID
AND ISNULL(CantidadPendiente, 0) > 0
AND Renglon > @RenglonAnt
ELSE IF @Base = 'SELECCION'
SELECT @Renglon = MIN(Renglon)
FROM OportunidadD
WHERE ID = @ID
AND ISNULL(CantidadPendiente, 0) > 0
AND ISNULL(CantidadA, 0) > 0
AND Renglon > @RenglonAnt
IF @Renglon IS NULL BREAK
SELECT @RenglonAnt = @Renglon
SELECT @Contacto = Contacto FROM OportunidadD WHERE ID = @ID AND Renglon = @Renglon
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaEmision, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @GenerarID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT * INTO #GenerarInteresadoEn FROM cOportunidadInteresadoEn WHERE ID = @ID
UPDATE #GenerarInteresadoEn SET ID = @GenerarID
INSERT INTO cOportunidadInteresadoEn SELECT * FROM #GenerarInteresadoEn
SELECT * INTO #GenerarCompentencia FROM cOportunidadCompetencia WHERE ID = @ID
UPDATE #GenerarCompentencia SET ID = @GenerarID
INSERT INTO cOportunidadCompetencia SELECT * FROM #GenerarCompentencia
DROP TABLE #GenerarInteresadoEn
DROP TABLE #GenerarCompentencia
UPDATE Oportunidad SET Contacto = @Contacto WHERE ID = @GenerarID
END
UPDATE OportunidadD SET CantidadA = NULL WHERE ID = @ID
RETURN
END

