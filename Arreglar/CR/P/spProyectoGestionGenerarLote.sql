SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spProyectoGestionGenerarLote
@Estacion   int,
@ID         int

AS BEGIN
DECLARE
@Actividad		varchar(50),
@Mov				varchar(20),
@MovID				varchar(20),
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(15),
@Proyecto			varchar(50),
@UEN				int,
@Observaciones		varchar(100),
@Asunto            varchar(100),
@PorcentajeAvance	float,
@Comentarios		varchar(max),
@Comienzo   		datetime,
@Conclusion		datetime,
@IDGestion			int,
@Ok				int,
@OkRef				varchar(255)
SELECT @Mov = Mov,  @MovID = MovID, @Empresa = Empresa,  @Sucursal = Sucursal, @Usuario = Usuario, @Proyecto = Proyecto, @UEN = UEN, @Observaciones = Observaciones
FROM Proyecto WHERE ID = @ID
SELECT @Actividad = MIN(ListaSt.Clave)
FROM ProyectoD JOIN ListaSt ON ProyectoD.ID = @ID AND ProyectoD.Actividad = ListaSt.Clave WHERE ListaSt.Estacion = @Estacion AND ISNULL(ProyectoD.EsFase,0) = 0
WHILE @Actividad IS NOT NULL
BEGIN
SELECT @Asunto = Asunto, @PorcentajeAvance = Avance, @Comentarios = Comentarios, @Comienzo = Comienzo, @Conclusion = Fin, @IDGestion = IDGestion FROM ProyectoD WHERE ID = @ID AND Actividad = @Actividad
EXEC spProyectoGestionGenerar @ID, @Mov, @MovID, @Empresa, @Sucursal, @Usuario, @Proyecto, @UEN, @Observaciones, @Actividad, @Asunto, @PorcentajeAvance, @Comentarios, @Comienzo, @Conclusion, @IDGestion
SELECT @Actividad = MIN(ListaSt.Clave)
FROM ProyectoD JOIN ListaSt ON ProyectoD.ID = @ID AND ProyectoD.Actividad = ListaSt.Clave WHERE ListaSt.Estacion = @Estacion AND ISNULL(ProyectoD.EsFase,0) = 0 AND ListaSt.Clave > @Actividad
END
RETURN
END

