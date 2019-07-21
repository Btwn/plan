SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE vic_spCopiaAccionesPlano
@Plano            varchar(15),
@Estacion         int

AS BEGIN
DECLARE  @Nombre          varchar(50),
@Estatus         varchar(15),
@AplicaProm      bit,
@QueryColor      varchar(2000),
@Query           varchar(2000),
@Orden           int,
@Color           int,
@LeyendaColor    varchar(20),
@Expresion       varchar(1000),
@ClavePlano      varchar(15),
@Renglon         float,
@Ok              int,
@OkRef           varchar(255)
CREATE TABLE #vic_PlanoAccionesTemp (
Plano           varchar(15)     NULL,
Nombre          varchar(50)     NULL,
Estatus         varchar(15)     NULL,
AplicaProm      bit             NULL,
QueryColor      varchar(2000)   NULL,
Query           varchar(2000)   NULL
)
CREATE TABLE #vic_PlanoAccionesDefTemp (
Plano           varchar(15)     NULL,
Nombre          varchar(50)     NULL,
Orden           int             NULL,
Color           int             NULL,
LeyendaColor    varchar(20)     NULL,
Expresion       varchar(1000)   NULL
)
BEGIN TRAN
IF NOT EXISTS (SELECT 1 FROM vic_PlanoAcciones WHERE Plano = @Plano) SET @Ok = 73040
IF @Ok IS NULL
BEGIN
DECLARE crAcciones CURSOR LOCAL STATIC FOR
SELECT Nombre, Estatus, AplicaProm, QueryColor, Query from vic_PlanoAcciones where Plano=@Plano
OPEN crAcciones
FETCH NEXT FROM crAcciones INTO @Nombre, @Estatus, @AplicaProm, @QueryColor, @Query
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO #vic_PlanoAccionesTemp(Plano, Nombre, Estatus, AplicaProm, QueryColor, Query)
VALUES (@Plano, @Nombre, @Estatus, @AplicaProm, @QueryColor, @Query)
IF @@ERROR <> 0 SET @Ok = 1
END
FETCH NEXT FROM crAcciones INTO @Nombre, @Estatus, @AplicaProm, @QueryColor, @Query
END
CLOSE crAcciones
DEALLOCATE crAcciones
IF @Ok IS NULL BEGIN
DECLARE crAccionesDef CURSOR LOCAL STATIC FOR
SELECT Nombre, Orden, Color, LeyendaColor, Expresion from vic_PlanoAccionesDef where Plano=@Plano
OPEN crAccionesDef
FETCH NEXT FROM crAccionesDef INTO @Nombre, @Orden, @Color, @LeyendaColor, @Expresion
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO #vic_PlanoAccionesDefTemp(Plano, Nombre, Orden, Color, LeyendaColor, Expresion)
VALUES (@Plano, @Nombre, @Orden, @Color, @LeyendaColor, @Expresion)
IF @@ERROR <> 0 SET  @Ok = 1
END
FETCH NEXT FROM crAccionesDef INTO @Nombre, @Orden, @Color, @LeyendaColor, @Expresion
END
CLOSE crAccionesDef
DEALLOCATE crAccionesDef
END
IF @Ok IS NULL BEGIN
DECLARE crCopiaAcciones CURSOR LOCAL STATIC FOR
SELECT Clave from ListaST where Estacion=@Estacion
OPEN crCopiaAcciones
FETCH NEXT FROM crCopiaAcciones INTO @ClavePlano
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF ISNULL(@ClavePlano,'') <> '' AND EXISTS (SELECT 1 FROM vic_Plano WHERE Plano=@ClavePlano) AND @Ok IS NULL
BEGIN
SET @Renglon = 2048
DELETE FROM vic_PlanoAcciones WHERE Plano = @ClavePlano
DELETE FROM vic_PlanoAccionesDef WHERE Plano = @ClavePlano
IF @@ERROR <> 0 SET @Ok = 1
DECLARE crAcciones2 CURSOR LOCAL STATIC FOR
SELECT Nombre, Estatus, AplicaProm, QueryColor, Query from #vic_PlanoAccionesTemp
OPEN crAcciones2
FETCH NEXT FROM crAcciones2 INTO @Nombre, @Estatus, @AplicaProm, @QueryColor, @Query
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO vic_PlanoAcciones(Plano, Renglon, RenglonSub, Nombre, Estatus, AplicaProm, QueryColor, Query)
VALUES (@ClavePlano, @Renglon, 0, @Nombre, @Estatus, @AplicaProm, @QueryColor, @Query)
IF @@ERROR <> 0 SET @Ok = 1
SELECT @Renglon = @Renglon + 2048
IF @Ok IS NULL
INSERT INTO vic_PlanoAccionesDef(Plano, Nombre, RenglonSub, Orden, Color, LeyendaColor, Expresion)
SELECT @ClavePlano, Nombre, 0, Orden, Color, LeyendaColor, Expresion from #vic_PlanoAccionesDefTemp WHERE Nombre=@Nombre
IF @@ERROR <> 0 SET @Ok = 1
END
FETCH NEXT FROM crAcciones2 INTO @Nombre, @Estatus, @AplicaProm, @QueryColor, @Query
END
CLOSE crAcciones2
DEALLOCATE crAcciones2
END
END
FETCH NEXT FROM crCopiaAcciones INTO @ClavePlano
END
CLOSE crCopiaAcciones
DEALLOCATE crCopiaAcciones
END
END
IF @Ok IS NULL BEGIN
COMMIT TRAN
SELECT 'Proceso concluido'
RETURN
END
ELSE BEGIN
ROLLBACK TRAN
SELECT CONVERT(varchar,@Ok) + '. ' + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) + '. ' + ISNULL(@OkRef,'')
RETURN
END
RETURN
END

