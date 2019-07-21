SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCopiarMeses
@Sucursal		int,
@Modulo		char(5),
@ID		int,
@Usuario		char(10),
@FechaD		datetime,
@FechaA		datetime,
@Afectar		bit = 0,
@TiempoUnidad	varchar(50) = 'meses',
@Ensilencio	bit = 0

AS BEGIN
DECLARE
@FechaEmision	datetime,
@Cuantos		int,
@Mov		char(20),
@MovID		varchar(20),
@ResultadoID	int,
@ContID		int,
@Ok			int,
@OkRef		varchar(255),
@Mensaje		varchar(255),
@VolverAfectar	bit,
@FechaRegistro 	datetime,
@IDGenerar 		int
SELECT @FechaRegistro = GETDATE(), @VolverAfectar = 0, @Ok = NULL, @Cuantos = 0, @FechaEmision = @FechaD
WHILE @FechaEmision<=@FechaA AND @Ok IS NULL
BEGIN
EXEC @IDGenerar = spMovCopiar @Sucursal, @Modulo, @ID, @Usuario, @FechaEmision, 1, @CopiarSucursalDestino = 1
IF @IDGenerar IS NOT NULL
BEGIN
IF @Afectar = 1
EXEC spAfectar @Modulo, @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, 0, @Ensilencio, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @Cuantos = @Cuantos + 1
IF @TiempoUnidad = 'dias'    SELECT @FechaEmision = DATEADD(day, 1, @FechaEmision) ELSE
IF @TiempoUnidad = 'semanas' SELECT @FechaEmision = DATEADD(week, 1, @FechaEmision) ELSE
IF @TiempoUnidad = 'a�os'    SELECT @FechaEmision = DATEADD(year, 1, @FechaEmision)
ELSE SELECT @FechaEmision = DATEADD(month, 1, @FechaEmision)
END  
END
IF @Ok IS NULL
SELECT @Mensaje = RTRIM(Convert(char, @Cuantos))+' Movimientos generados.'
ELSE
SELECT @Mensaje = RTRIM(Descripcion)+' '+RTRIM(@OkRef) FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
IF @Ensilencio = 0
BEGIN
SELECT @Mensaje
RETURN
END
RETURN
END

