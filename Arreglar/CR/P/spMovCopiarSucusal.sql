SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCopiarSucusal
@Sucursal		int,
@Estacion		int,
@ID		int,
@Usuario		char(10),
@FechaTrabajo	datetime,
@Afectar		bit = 0

AS BEGIN
DECLARE
@Cuantos		int,
@Mov		char(20),
@MovID		varchar(20),
@ResultadoID	int,
@ContID		int,
@Ok			int,
@OkRef		varchar(255),
@VolverAfectar	bit,
@FechaRegistro 	datetime,
@EnviarA		int,
@Clave 		varchar(100),
@IDGenerar 		int
SELECT @FechaRegistro = GETDATE(), @VolverAfectar = 0, @Ok = NULL, @Cuantos = 0
BEGIN TRANSACTION
DECLARE crListaSt CURSOR FOR
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Clave
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF dbo.fnEsNumerico(@Clave) = 1
BEGIN
SELECT @EnviarA = CONVERT(int, @Clave)
EXEC @IDGenerar = spMovCopiar @Sucursal, 'VTAS', @ID, @Usuario, @FechaTrabajo, 1
IF @IDGenerar IS NOT NULL
BEGIN
SELECT @Cuantos = @Cuantos + 1
UPDATE Venta  SET EnviarA = @EnviarA WHERE ID = @IDGenerar
UPDATE VentaD SET EnviarA = @EnviarA WHERE ID = @IDGenerar
IF @Afectar = 1
EXEC spInv @IDGenerar, 'VTAS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
@Mov OUTPUT, @MovID OUTPUT, @ResultadoID OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT
END
END
END
FETCH NEXT FROM crListaSt INTO @Clave
END  
CLOSE crListaSt
DEALLOCATE crListaSt
COMMIT TRANSACTION
SELECT RTRIM(Convert(char, @Cuantos))+' Movimientos generados.'
RETURN
END

