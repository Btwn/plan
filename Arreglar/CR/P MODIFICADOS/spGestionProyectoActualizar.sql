SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spGestionProyectoActualizar
@ID				int,
@FechaEmision	datetime,
@IDOrigen		int,
@Accion			varchar(20),
@Empresa		varchar(5),
@Modulo			varchar(5),
@Mov			varchar(20),
@MovID			varchar(20),
@Avance			float,
@Esfuerzo		float,
@Estado			varchar(30),
@Usuario		varchar(10),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @OrigenTipo	varchar(20),
@Origen		varchar(20),
@OrigenID		varchar(20),
@IDProyecto   int
IF @IDOrigen IS NOT NULL
BEGIN
SELECT @OrigenTipo = ISNULL(OrigenTipo, ''),
@Origen	   = ISNULL(Origen, ''),
@OrigenID   = ISNULL(OrigenID, '')
FROM Gestion
WITH(NOLOCK) WHERE ID = @IDOrigen
IF @OrigenTipo = 'PROY'
BEGIN
SELECT @IDProyecto = ID
FROM Proyecto
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov   = @Origen
AND MovID = @OrigenID
IF @Avance <> 100.0 SELECT @FechaEmision = NULL
UPDATE ProyectoD
 WITH(ROWLOCK) SET Avance = @Avance,
Estado	= @Estado,
Esfuerzo = @Esfuerzo,
Usuario = @Usuario,
MovGestion = RTRIM(@Mov)+' '+RTRIM(@MovID)
WHERE ID = @IDProyecto
AND IDGestion = @IDOrigen
END
END
ELSE
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
SELECT @OrigenTipo = ISNULL(OrigenTipo, ''),
@Origen	   = ISNULL(Origen, ''),
@OrigenID   = ISNULL(OrigenID, '')
FROM Gestion
WITH(NOLOCK) WHERE ID = @ID
IF @OrigenTipo = 'PROY'
BEGIN
SELECT @IDProyecto = ID
FROM Proyecto
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov   = @Origen
AND MovID = @OrigenID
UPDATE ProyectoD
 WITH(ROWLOCK) SET Avance = 0,
Estado = 'No Comenzada',
IDGestion = NULL,
Usuario = @Usuario,
MovGestion = RTRIM(@Mov)+' '+RTRIM(@MovID)
WHERE ID = @IDProyecto
AND IDGestion = @ID
END
END
END
RETURN
END

