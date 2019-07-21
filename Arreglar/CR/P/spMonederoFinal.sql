SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMonederoFinal
@Empresa				varchar(5),
@Sucursal				int,
@Modulo					varchar(5),
@ID						int,
@Estatus				varchar(15),
@EstatusNuevo			varchar(15),
@Usuario				varchar(10),
@FechaEmision			datetime,
@FechaRegistro			datetime,
@Mov					varchar(20),
@MovID					varchar(20),
@MovTipo				varchar(20),
@IDGenerar				int,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT
AS BEGIN
DECLARE @VentaMon	bit,
@OrigenTipo	varchar(10)
SELECT @VentaMon = ISNULL(VentaMonederoA,0)  FROM EmpresaCFG2   WHERE Empresa = @Empresa
IF @Modulo = 'VTAS' AND @MovTipo IN ('VTAS.N','VTAS.F','VTAS.D') AND @EstatusNuevo IN ('PROCESAR','CONCLUIDO','CANCELADO')
AND @VentaMon = 1
BEGIN
SELECT @OrigenTipo = NULLIF(OrigenTipo,'') FROM Venta WHERE ID = @ID
EXEC xpMovFinalMonedero @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID,
@MovTipo,@Ok OUTPUT, @OkRef	OUTPUT
IF EXISTS (SELECT * FROM AuxiliarPMon WHERE Modulo = 'VTAS' AND Rama = 'MONEL' AND Empresa = @Empresa AND ModuloID = @ID AND NULLIF(MovID,'') IS NULL) AND @OrigenTipo <> 'POS'
UPDATE AuxiliarPMon SET MovID = @MovID WHERE Modulo = 'VTAS' AND Rama = 'MONEL' AND Empresa = @Empresa AND ModuloID = @ID AND NULLIF(MovID,'') IS NULL
IF EXISTS (SELECT * FROM AuxiliarPMon WHERE Modulo = 'VTAS' AND Rama = 'MONEL' AND Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND NULLIF(ModuloID,'') IS NULL) AND @OrigenTipo = 'POS'
UPDATE AuxiliarPMon SET ModuloID = @ID WHERE Modulo = 'VTAS' AND Rama = 'MONEL' AND Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND NULLIF(ModuloID,'') IS NULL
END
RETURN
END

