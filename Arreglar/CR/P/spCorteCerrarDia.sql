SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteCerrarDia
@Sucursal				int,
@Empresa				varchar(5),
@Usuario				varchar(10),
@Fecha					datetime,
@Estacion				int,
@Ok						int OUTPUT,
@OkRef					varchar(255) OUTPUT

AS
BEGIN
DECLARE @ID			int,
@IDAnt		int,
@IDGenera		int,
@VigenciaD	datetime,
@VigenciaA	datetime,
@MovGenera	varchar(20),
@SubMovTipo	varchar(20),
@GenerarCorte	bit
IF ISNULL(@Estacion, 0) = 0
SELECT @Estacion = @@SPID
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(ID)
FROM Corte
JOIN MovTipo ON Corte.Mov = MovTipo.Mov AND Modulo = 'CORTE' AND ISNULL(SubClave, '') IN('CORTE.GENERACORTECON', 'CORTE.GENERACORTECX', 'CORTE.GENERACORTEIMP', 'CORTE.GENERACORTEU')
WHERE Estatus = 'VIGENTE'
AND ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @VigenciaD = NULL, @VigenciaA = NULL, @MovGenera = NULL, @SubMovTipo = NULL, @Ok = NULL, @OkRef = NULL, @IDGenera = NULL, @GenerarCorte = 0
SELECT @VigenciaD = VigenciaD,
@VigenciaA = VigenciaA
FROM Corte
WHERE ID = @ID
IF @Fecha BETWEEN @VigenciaD AND @VigenciaA
BEGIN
EXEC spCorteEnFrecuencia @ID, @Fecha, @GenerarCorte OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @GenerarCorte = 1
BEGIN
SELECT @SubMovTipo = MovTipo.SubClave
FROM Corte
JOIN MovTipo ON Corte.Mov = MovTipo.Mov AND Modulo = 'CORTE'
WHERE ID = @ID
IF @SubMovTipo = 'CORTE.GENERACORTECON'
SELECT @MovGenera = CorteContable FROM EmpresaCfgMovCorte WHERE Empresa = @Empresa
ELSE IF @SubMovTipo = 'CORTE.GENERACORTECX'
SELECT @MovGenera = CorteCx FROM EmpresaCfgMovCorte WHERE Empresa = @Empresa
ELSE IF @SubMovTipo = 'CORTE.GENERACORTEIMP'
SELECT @MovGenera = CorteImporte FROM EmpresaCfgMovCorte WHERE Empresa = @Empresa
ELSE IF @SubMovTipo = 'CORTE.GENERACORTEU'
SELECT @MovGenera = CorteUnidades FROM EmpresaCfgMovCorte WHERE Empresa = @Empresa
EXEC @IDGenera = spAfectar 'CORTE', @ID, 'GENERAR', 'Todo', @MovGenera, @Usuario = @Usuario, @Estacion = @Estacion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @IDGenera IS NOT NULL AND @Ok = 80030
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spAfectar 'CORTE', @IDGenera, 'AFECTAR', 'Todo', NULL, @Usuario = @Usuario, @Estacion = @Estacion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
ELSE IF @Fecha > @VigenciaA
BEGIN
EXEC spAfectar 'CORTE', @ID, 'AFECTAR', 'Todo', NULL, @Usuario = @Usuario, @Estacion = @Estacion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END

