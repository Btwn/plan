SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaGenerar
@Estacion		int,
@Timbrar		bit,
@Usuario		varchar(10),
@Ok             int	 			= NULL OUTPUT,
@OkRef          varchar(255)	= NULL OUTPUT,
@IDEsp			int				= NULL,
@PersonalEsp	varchar(10)		= NULL

AS
BEGIN
SET NOCOUNT ON
DECLARE @ID							int,
@IDAnt						int,
@Empresa						varchar(5),
@Mov							varchar(20),
@MovID						varchar(20),
@Version						varchar(5),
@OkDesc						varchar(255),
@OkTipo						varchar(50),
@Sucursal						int,
@NominaTimbrar				bit,
@Estatus						varchar(15),
@RFCEmisor					varchar(15)
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
IF @IDEsp IS NULL
SELECT @ID = MIN(l.ID)
FROM ListaModuloID l WITH (NOLOCK)
JOIN Nomina n WITH (NOLOCK) ON l.ID = n.ID
JOIN CFDINominaMov m WITH (NOLOCK) ON n.Mov = m.Mov
WHERE l.Estacion = @Estacion
AND l.ID > @IDAnt
ELSE IF @IDEsp IS NOT NULL
SELECT @ID = MIN(n.ID)
FROM Nomina n WITH (NOLOCK)
JOIN CFDINominaMov m WITH (NOLOCK) ON n.Mov = m.Mov
WHERE ID = @IDEsp
AND ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @Empresa		= n.Empresa,
@Mov			= n.Mov,
@MovID		= n.MovID,
@Version		= m.Version,
@Sucursal	= n.Sucursal,
@Estatus		= n.Estatus,
@RFCEmisor	= e.RFC
FROM Nomina n WITH (NOLOCK)
JOIN CFDINominaMov m WITH (NOLOCK) ON n.Mov = m.Mov
JOIN Empresa e WITH (NOLOCK) ON n.Empresa = e.Empresa
WHERE n.ID = @ID
SELECT @NominaTimbrar = ISNULL(NominaTimbrar, 0) FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Ok = NULL, @OkRef = NULL
EXEC spCFDINominaDProcesar @Estacion, @ID, @Empresa, @Sucursal, @Mov, @MovID, @Version, @Timbrar, @Usuario, @PersonalEsp, @NominaTimbrar, @Estatus, @RFCEmisor, @Ok OUTPUT, @OkRef OUTPUT
END
SELECT NULL, NULL, NULL, NULL, NULL
RETURN
END

