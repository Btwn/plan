SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCancelarRequisicionesPendientes
@ID					int,
@Accion				char(20),
@Base				char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo				char(5),
@Mov				char(20),
@MovID				varchar(20),
@MovTipo			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@Estatus			char(15),
@EstatusNuevo		char(15),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion	datetime,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@UtilizarID			int,
@UtilizarMovTipo	char(20),
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CfgCompraAutoCancelaCotizacion		bit,
@CfgCompraEstadoCotizacionCancelado	varchar(30),
@IDC									int,
@EmpresaRef							varchar(5),
@Aplica								varchar(20),
@AplicaID								varchar(20),
@Articulo								varchar(20),
@SubCuenta							varchar(50),
@Almacen								varchar(10)
SELECT @CfgCompraAutoCancelaCotizacion     = ISNULL(CompraAutoCancelaCotizacion, 0),
@CfgCompraEstadoCotizacionCancelado = 'Cancelada' 
FROM EmpresaCfg2 ec
WHERE ec.Empresa = @Empresa
IF @CfgCompraAutoCancelaCotizacion = 0
RETURN
CREATE TABLE #AplicaRequisicion(
ID			int	NULL,
Aplica		varchar(20)	COLLATE Database_Default NULL,
AplicaID		varchar(20)	COLLATE Database_Default NULL,
Articulo		varchar(20)	COLLATE Database_Default NULL)
CREATE TABLE #AplicaCotizacion(
ID			int	NULL,
EmpresaRef	varchar(5)	COLLATE Database_Default NULL,
Aplica		varchar(20)	COLLATE Database_Default NULL,
AplicaID		varchar(20)	COLLATE Database_Default NULL,
Articulo		varchar(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Almacen		varchar(10)	COLLATE Database_Default NULL,)
INSERT INTO #AplicaRequisicion(ID, Aplica, AplicaID, Articulo)
SELECT cd.ID, cd.Aplica, cd.AplicaID, cd.Articulo
FROM CompraD cd
JOIN MovTipo mt ON cd.Aplica = mt.Mov AND mt.Modulo = 'COMS' AND mt.Clave = 'COMS.R'
WHERE ID = @ID
INSERT INTO #AplicaCotizacion(ID, EmpresaRef, Aplica, AplicaID, Articulo, SubCuenta, Almacen)
SELECT DISTINCT c.ID, ISNULL(cd.EmpresaRef, @Empresa), cd.Aplica, cd.AplicaID, cd.Articulo, ISNULL(cd.SubCuenta, ''), ISNULL(cd.Almacen, c.Almacen)
FROM Compra c
JOIN CompraD cd ON c.ID = cd.ID
JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'COMS' AND mt.Clave = 'COMS.C'
JOIN #AplicaRequisicion a ON cd.Aplica = a.Aplica AND cd.AplicaID = a.AplicaID AND cd.Articulo = a.Articulo
WHERE c.Estatus = 'CONFIRMAR'
AND ISNULL(cd.Estado, '') <> @CfgCompraEstadoCotizacionCancelado
DECLARE crCancelarRequisicionesPendientes CURSOR FOR
SELECT c.ID, c.EmpresaRef, c.Aplica, c.AplicaID, c.Articulo, c.SubCuenta, c.Almacen
FROM #AplicaCotizacion c
OPEN crCancelarRequisicionesPendientes
FETCH NEXT FROM crCancelarRequisicionesPendientes INTO @IDC, @EmpresaRef, @Aplica, @AplicaID, @Articulo, @SubCuenta, @Almacen
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
UPDATE CompraD SET Estado = @CfgCompraEstadoCotizacionCancelado
WHERE ID = @IDC AND ISNULL(EmpresaRef, @Empresa) = @EmpresaRef AND Aplica = @Aplica AND AplicaID = @AplicaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND ISNULL(Almacen, @Almacen) = @Almacen
END
FETCH NEXT FROM crCancelarRequisicionesPendientes INTO @IDC, @EmpresaRef, @Aplica, @AplicaID, @Articulo, @SubCuenta, @Almacen
END
CLOSE crCancelarRequisicionesPendientes
DEALLOCATE crCancelarRequisicionesPendientes
DECLARE crCancelarRequisicionesPendientes2 CURSOR FOR
SELECT DISTINCT c.ID
FROM #AplicaCotizacion c
JOIN Compra c2 ON c.ID = c2.ID
WHERE c2.Estatus = 'CONFIRMAR'
OPEN crCancelarRequisicionesPendientes2
FETCH NEXT FROM crCancelarRequisicionesPendientes2 INTO @IDC
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND NOT EXISTS(SELECT * FROM CompraD cd WHERE ID = @IDC AND ISNULL(cd.Estado, '') <> @CfgCompraEstadoCotizacionCancelado)
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spAfectar 'COMS', @IDC, 'CANCELAR', NULL, NULL, @Usuario, 0, 1,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @FechaRegistro = @FechaRegistro, @Conexion = 1
END
FETCH NEXT FROM crCancelarRequisicionesPendientes2 INTO @IDC
END
CLOSE crCancelarRequisicionesPendientes2
DEALLOCATE crCancelarRequisicionesPendientes2
RETURN
END

