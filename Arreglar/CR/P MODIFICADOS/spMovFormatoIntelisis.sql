SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovFormatoIntelisis
@Empresa     varchar(5),
@Modulo	varchar(5),
@Mov		varchar(20),
@ID		int = NULL

AS BEGIN
DECLARE
@FormatoIntelisis       varchar(30)
SET @FormatoIntelisis = ''
IF @Modulo = 'VTAS'
SELECT @Mov = Mov
FROM Venta WITH(NOLOCK)
WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @Mov = Mov
FROM Cxc WITH(NOLOCK)
WHERE ID = @ID
SELECT @FormatoIntelisis = CFDReporteIntelisis
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = @Modulo AND Mov = @Mov
SET @FormatoIntelisis = ISNULL(@FormatoIntelisis,'')
SELECT 'ReporteIntelisis' = @FormatoIntelisis
RETURN
END

