SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAutorizacionModuloAPP
@Modulo   char(5),
@ID       int,
@Usuario  varchar(10),
@OkRef    varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaTrabajo        datetime,
@Situacion           varchar(50),
@Mov                 varchar(20),
@Estatus             varchar(20),
@UsuarioSituacion    varchar(10),
@SituacionSiguiente  varchar(50),
@Ok                  int
SELECT @FechaTrabajo = GETDATE(),  @OkRef = 'Proceso Concluido'
IF @Modulo = 'VTAS'  SELECT @Mov = Venta.Mov,  @Estatus = Venta.Estatus,  @Situacion = Venta.Situacion,  @UsuarioSituacion = Venta.SituacionUsuario  FROM Venta  WHERE Venta.ID  = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Mov = Compra.Mov, @Estatus = Compra.Estatus, @Situacion = Compra.Situacion, @UsuarioSituacion = Compra.SituacionUsuario FROM Compra WHERE Compra.ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Mov = Gasto.Mov,  @Estatus = Gasto.Estatus,  @Situacion = Gasto.Situacion,  @UsuarioSituacion = Gasto.SituacionUsuario  FROM Gasto  WHERE Gasto.ID  = @ID
SELECT  @SituacionSiguiente =  NULLIF(dbo.fnSituacionSiguiente(@Modulo, @Mov, @Estatus, @Situacion),'')
IF @SituacionSiguiente = @Situacion SELECT @Ok = 10060, @OkRef = 'Este Movimiento ya fue Autorizado por Otro Usuario'
IF @Ok IS NULL AND NULLIF(RTRIM(@SituacionSiguiente), '') IS NOT NULL
BEGIN
IF @Modulo = 'VTAS'  UPDATE Venta  SET Situacion = @SituacionSiguiente, SituacionFecha = @FechaTrabajo, SituacionUsuario = @Usuario WHERE  ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra SET Situacion = @SituacionSiguiente, SituacionFecha = @FechaTrabajo, SituacionUsuario = @Usuario WHERE  ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto  SET Situacion = @SituacionSiguiente, SituacionFecha = @FechaTrabajo, SituacionUsuario = @Usuario WHERE  ID = @ID
END
END
RETURN

