SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaPolizaObtener
@ID					int,
@Accion				varchar(20),
@Sucursal			int,
@Usuario			varchar(10),
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@Nivel				varchar(20),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@ISReferencia		varchar(100),
@IDEmpresa			int,
@GeneraEjercicio	int,
@GeneraPeriodo		int,
@GeneraFechaD		datetime,
@GeneraFechaA		datetime,
@GeneraMov			varchar(20),
@GeneraMovID		varchar(20),
@GeneraContMov		varchar(20),
@GeneraContMovID	varchar(20),
@CONTEsCancelacion	bit,
@GeneraContID		int				OUTPUT,
@XML				varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
CREATE TABLE #Mov(
RID					int IDENTITY,
Fecha				datetime,
ContID				int,
ContMov				varchar(20),
ContMovID			varchar(20),
ContFechaEmision	datetime,
ContOrigenTipo		varchar(5)		NULL,
ContOrigen			varchar(20)		NULL,
ContOrigenID		varchar(20)		NULL
)
DELETE ContParalelaD WHERE ID = @ID
INSERT INTO #Mov(
Fecha,        ContID, ContMov, ContMovID, ContFechaEmision, ContOrigenTipo, ContOrigen, ContOrigenID)
SELECT FechaEmision, ID,     Mov,     MovID,     FechaEmision,     OrigenTipo,	  Origen,     OrigenID
FROM Cont
WHERE Empresa = @Empresa
AND FechaEmision BETWEEN @GeneraFechaD AND @GeneraFechaA
AND Estatus = CASE @CONTEsCancelacion WHEN 0 THEN 'CONCLUIDO' ELSE 'CANCELADO' END
AND Mov   = ISNULL(@GeneraContMov, Mov)
AND MovID = ISNULL(@GeneraContMovID, MovID)
INSERT INTO ContParalelaD(
ID,  Renglon,  ContID, ContMov, ContMovID, ContFechaEmision, ContOrigenTipo, ContOrigen, ContOrigenID)
SELECT @ID, RID*2048, ContID, ContMov, ContMovID, ContFechaEmision, ContOrigenTipo, ContOrigen, ContOrigenID
FROM #Mov
IF @GeneraContMov IS NOT NULL AND @GeneraContMovID IS NOT NULL
BEGIN
SELECT @GeneraContID = ContID FROM #Mov
UPDATE ContParalela SET GeneraContID = @GeneraContID WHERE ID = @ID
END
RETURN
END

