SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spConcluyeProyecto
@Empresa	varchar(255),
@OModulo	varchar(20),
@Oid		int,
@OMov		varchar(20),
@OMovid		varchar(20)

AS BEGIN
DECLARE @Ok		int,
@OkRef	varchar(255)
SET @Ok = null
SET @OkRef = null
IF OBJECT_ID('tempdb..#RastreoMovFlujo') IS NOT NULL
DROP TABLE #RastreoMovFlujo
ELSE
CREATE TABLE #RastreoMovFlujo (
IdFlujo		int				NOT NULL,
Empresa		varchar(255)	NOT NULL,
Modulo		varchar(20)		NOT NULL,
Mov			varchar(20)		NOT NULL,
MovID		varchar(20)		NOT NULL,
Estatus		varchar(20)		NOT NULL)
EXEC spBuscaEstatusMovFlujo @Empresa, @OModulo, @Oid, @OMov, @OMovid
IF EXISTS(SELECT * FROM #RastreoMovFlujo WHERE Estatus = 'PENDIENTE')
SELECT TOP 1 @OkRef = 'Error: Movimiento Pendiente en Modulo '+Modulo+' Mov: '+Mov+' '+MovID, @Ok = 1 FROM #RastreoMovFlujo WHERE Estatus = 'PENDIENTE'
IF @Ok IS NULL AND @OkRef IS NULL
IF EXISTS(SELECT * FROM PROYECTOD WHERE ID = @Oid AND Estado IN ('No comenzada','En Curso') AND EsFase = 0)
SELECT @Ok = 1, @OkRef = 'Error: Existen Actividades Sin Completar'
IF @Ok IS NOT NULL
SELECT @OkRef
ELSE
SELECT 'Todos los Movimientos estan Concluidos'
RETURN
END

