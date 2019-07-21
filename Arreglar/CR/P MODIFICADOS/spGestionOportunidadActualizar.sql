SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spGestionOportunidadActualizar
@ID				int,
@FechaEmision	datetime,
@IDOrigen		int,
@Accion			varchar(20),
@Empresa		varchar(5),
@Modulo			varchar(5),
@Mov			varchar(20),
@MovID			varchar(20),
@Avance			float,
@Estado			varchar(30),
@Usuario		varchar(10),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @OrigenTipo	varchar(20),
@Origen		varchar(20),
@OrigenID		varchar(20),
@IDOPORT		int
IF @IDOrigen IS NOT NULL
BEGIN
SELECT @OrigenTipo = ISNULL(OrigenTipo, ''),
@Origen	   = ISNULL(Origen, ''),
@OrigenID   = ISNULL(OrigenID, '')
FROM Gestion
WITH(NOLOCK) WHERE ID = @IDOrigen
IF @OrigenTipo = 'OPORT'
BEGIN
SELECT @IDOPORT = ID
FROM Oportunidad
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov   = @Origen
AND MovID = @OrigenID
IF @Avance <> 100.0 SELECT @FechaEmision = NULL
UPDATE OportunidadD
 WITH(ROWLOCK) SET PorcentajeAvance = @Avance,
Estado	= @Estado,
FechaA = @FechaEmision,
Usuario = @Usuario,
MovGestion = RTRIM(@Mov)+' '+RTRIM(@MovID)
WHERE ID = @IDOPORT
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
IF @OrigenTipo = 'OPORT'
BEGIN
SELECT @IDOPORT = ID
FROM Oportunidad
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov   = @Origen
AND MovID = @OrigenID
UPDATE OportunidadD
 WITH(ROWLOCK) SET PorcentajeAvance = 0,
Estado = 'No Comenzada',
IDGestion = NULL,
Fecha = NULL,
FechaA = NULL,
Usuario = @Usuario,
MovGestion = RTRIM(@Mov)+' '+RTRIM(@MovID)
WHERE ID = @IDOPORT
AND IDGestion = @ID
END
END
END
RETURN
END

