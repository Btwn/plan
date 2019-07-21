SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaCierrePeriodo
@ID						int,
@Accion					varchar(20),
@Sucursal				int,
@Usuario				varchar(10),
@Empresa				varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@FechaEmision			datetime,
@Referencia				varchar(50),
@MovTipo				varchar(20),
@BaseDatos				varchar(255),
@EmpresaOrigen			varchar(5),
@CuentaD				varchar(20),
@CuentaA				varchar(20),
@Nivel					varchar(20),
@CPBaseLocal			bit,
@CPBaseDatos			varchar(255),
@CPURL					varchar(255),
@CPCentralizadora		bit,
@CPUsuario				varchar(10),
@CPContrasena			varchar(32),
@ISReferencia			varchar(100),
@IDEmpresa				int,
@GeneraEjercicio		int,
@GeneraPeriodo			int,
@GeneraFechaD			datetime,
@GeneraFechaA			datetime,
@GeneraEmpresaOrigen	int,
@XML					varchar(max)	OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE @IDEmpresaAux			int,
@IDEmpresaAuxAnt		int
SELECT @IDEmpresaAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDEmpresaAux = MIN(ID)
FROM ContParalelaEmpresa
WHERE Empresa = @Empresa
AND ID = ISNULL(@GeneraEmpresaOrigen, ID)
AND ID > @IDEmpresaAuxAnt
IF @IDEmpresaAux IS NULL BREAK
SELECT @IDEmpresaAuxAnt = @IDEmpresaAux
IF @Accion = 'AFECTAR'
BEGIN
IF NOT EXISTS(SELECT * FROM ContParalelaPeriodoCierre WHERE IDEmpresa = @IDEmpresaAux AND Ejercicio = @GeneraEjercicio AND Periodo = @GeneraPeriodo)
INSERT INTO ContParalelaPeriodoCierre(IDEmpresa, Ejercicio, Periodo) SELECT @IDEmpresaAux, @GeneraEjercicio, @GeneraPeriodo
END
ELSE IF @Accion = 'CANCELAR'
DELETE ContParalelaPeriodoCierre WHERE IDEmpresa = @IDEmpresaAux AND Ejercicio = @GeneraEjercicio AND Periodo = @GeneraPeriodo
END
RETURN
END

