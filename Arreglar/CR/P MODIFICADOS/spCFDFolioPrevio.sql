SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFolioPrevio
@Sucursal			int,
@Empresa     		char(5),
@Modulo				char(5),
@Mov      			char(20),
@MovID				varchar(20),
@ModuloAfectacion	varchar(5),
@ID					int,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@IDOrigen			int,
@Origen				varchar(20),
@OrigenID			varchar(20),
@OrigenDAMovID		varchar(20),
@versionCFD         varchar(10)
SELECT @VersionCFD = Version FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF  (SELECT CFDEsPArcialidad FROM MovTipo WITH (NOLOCK) WHERE Modulo = @ModuloAfectacion AND Mov = @Mov )  = 1
BEGIN
IF (SELECT Count(ID) FROM CxcD c WITH (NOLOCK) JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'CXC' AND c.Aplica = mt.Mov WHERE c.ID = @ID AND mt.Clave = 'CXC.D') > 2
SELECT @Ok = 30013, @OkRef = 'Solo se Permite Aplicar una Parcialidad por Comprobante Fiscal Digital '
SELECT @Origen = Origen, @OrigenID = OrigenID FROM CXC WITH (NOLOCK) WHERE ID = @ID
SELECT @IDOrigen = ID FROM CXC WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Origen AND MovId = @OrigenID
IF (SELECT mt.clave FROM CXC c WITH (NOLOCK) JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'CXC' AND c.Mov = mt.Mov WHERE ID = @IDorigen) = 'CXC.D'
BEGIN
SELECT @OrigenDAMovID = d.MovID FROM CXC c
JOIN DocAuto d WITH (NOLOCK) ON c.Empresa = d.Empresa AND c.Origen = d.Mov AND c.OrigenID = d.MovID
WHERE c.ID = @IDOrigen
END
IF @OrigenDAMovID IS NULL
EXEC spCFDActualizaReferenciaDoctos @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @ID IS NOT NULL
BEGIN
IF @VersionCFD = '2.2'
EXEC spGenerarCFDSAT22 1, @ModuloAfectacion, @ID, NULL, 1, @ok OUTPUT, @OkRef OUTPUT
IF @VersionCFD = '3.2'
EXEC spGenerarCFDSAT32 1, @ModuloAfectacion, @ID, NULL, 1, @ok OUTPUT, @OkRef OUTPUT
EXEC xpCFDValidarFolio @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ModuloAfectacion, @ID, @VersionCFD, @ok OUTPUT, @OkRef OUTPUT
END
END

