SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetCrearCampanaEvento
@Usuario       varchar(10) = NULL,
@Empresa       varchar(5)  = NULL,
@Sucursal      int         = NULL,
@ID            int         = NULL,
@Prospecto     varchar(10) = NULL,
@FechaHora     datetime    = NULL,
@Tipo          varchar(10) = NULL,
@Situacion     varchar(50) = NULL,
@Observaciones varchar(100) = NULL
AS BEGIN
DECLARE
@RID           int
SELECT TOP 1 @RID = RID FROM CampanaD WITH(NOLOCK) WHERE ID = @ID AND ContactoTipo = 'Prospecto' AND Contacto = @Prospecto
INSERT INTO CampanaEvento(ID, RID, FechaHora, Tipo, Situacion, SituacionFecha, Observaciones, Sucursal, SucursalOrigen)
SELECT @ID, @RID, @FechaHora, @Tipo, @Situacion, @FechaHora, @Observaciones, @Sucursal, @Sucursal
IF ISNULL(@Situacion,'') <> ''
UPDATE CampanaD WITH(ROWLOCK) SET Situacion = @Situacion, SituacionFecha = @FechaHora, Observaciones = @Observaciones WHERE ID = @ID AND RID = @RID
SELECT 'La Actividad se creó correctamente'
RETURN
END

