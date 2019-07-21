SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE vic_spInsertaDatosPlano
@Ok    int          OUTPUT,
@OkRef varchar(255) OUTPUT

AS BEGIN
DECLARE @Plano       varchar(15),
@Renglon     float,
@Nombre      varchar(50),
@cuantos     integer
SELECT @cuantos = COUNT(*) FROM vic_Plano
IF @cuantos = 1
BEGIN
DELETE FROM vic_planoacciones
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'Error al eliminar acciones de plano'
IF @Ok IS NULL
DELETE FROM vic_planoaccionesdef
IF @@ERROR <> 0 SELECT @Ok = 1,  @OkRef = 'Error al eliminar detalle de acciones de plano'
SET @Renglon = 0
IF @Ok IS NULL BEGIN
DECLARE crAcciones CURSOR LOCAL STATIC FOR
SELECT Plano FROM vic_Plano
OPEN crAcciones
FETCH NEXT FROM crAcciones INTO @Plano
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF NOT EXISTS (SELECT * FROM vic_planoacciones WHERE Plano = @Plano AND Nombre = 'Estatus')
INSERT INTO vic_planoacciones (Plano, Renglon, RenglonSub, Nombre, Estatus, AplicaProm, QueryColor, Query)
VALUES (@Plano, @Renglon, 0, 'Estatus', 'ACTIVA',  0, '', "SELECT DISTINCT vl.Estatus, VL.local FROM vic_Local vl JOIN vic_plano_asignacion VP ON vl.Local = VP.Elemento WHERE VP.Plano = ")
IF @@ERROR <> 0 SET @Ok = 1
END
FETCH NEXT FROM crAcciones INTO @Plano
END
CLOSE crAcciones
DEALLOCATE crAcciones
END
IF @Ok IS NULL BEGIN
DECLARE crAcciones CURSOR LOCAL STATIC FOR
SELECT Plano, Nombre FROM vic_PlanoAcciones
OPEN crAcciones
FETCH NEXT FROM crAcciones INTO @Plano, @Nombre
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Nombre='Estatus' AND @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM vic_PlanoAccionesDef WHERE Plano = @Plano AND Nombre = @Nombre)
INSERT INTO vic_PlanoAccionesDef (Plano, Nombre, RenglonSub, Orden, Color, LeyendaColor, Expresion) VALUES (@Plano, @Nombre, 0, 1, 15859453, 'Alta', 'VALOR =''Alta''')
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
IF NOT EXISTS (SELECT * FROM vic_PlanoAccionesDef WHERE Plano = @Plano AND Nombre = @Nombre)
INSERT INTO vic_PlanoAccionesDef (Plano, Nombre, RenglonSub, Orden, Color, LeyendaColor, Expresion) VALUES (@Plano, @Nombre, 0, 1, 16709867, 'Baja', 'VALOR =''Baja''')
END
END
FETCH NEXT FROM crAcciones INTO @Plano, @Nombre
END
CLOSE crAcciones
DEALLOCATE crAcciones
END
END
RETURN
END

