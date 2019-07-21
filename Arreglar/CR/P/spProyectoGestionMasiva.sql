SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spProyectoGestionMasiva
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
DECLARE crGestionMasiva CURSOR LOCAL FOR
SELECT Actividad, Asunto, Avance, Comentarios, Comienzo, Fin, IDGestion FROM ProyectoD
WHERE ID = @ID AND ISNULL(RecursosAsignados,'') <> '' AND EsFase = 0 AND Estado = 'No Comenzada'
OPEN crGestionMasiva
FETCH NEXT FROM crGestionMasiva INTO @Actividad, @Asunto, @PorcentajeAvance, @Comentarios, @Comienzo, @Conclusion, @IDGestion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @IDGestion IS NULL
EXEC spProyectoGestionGenerar @ID, @Mov, @MovID, @Empresa, @Sucursal, @Usuario, @Proyecto, @UEN, @Observaciones, @Actividad, @Asunto, @PorcentajeAvance, @Comentarios, @Comienzo, @Conclusion, @IDGestion, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crGestionMasiva INTO @Actividad, @Asunto, @PorcentajeAvance, @Comentarios, @Comienzo, @Conclusion, @IDGestion
END
CLOSE crGestionMasiva
DEALLOCATE crGestionMasiva
RETURN
END

