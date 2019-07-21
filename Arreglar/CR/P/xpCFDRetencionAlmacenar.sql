SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDRetencionAlmacenar
@Empresa		varchar(5),
@Usuario		varchar(10),
@Proveedor		varchar(10),
@ConceptoSAT	varchar(2),
@Version		varchar(5),
@AlmacenarXML	bit OUTPUT,
@AlmacenarPDF	bit OUTPUT,
@NomArch		varchar(255) OUTPUT,
@Reporte		varchar(100) OUTPUT,
@Ruta			varchar(255) OUTPUT,
@EnviarPara		varchar(255) OUTPUT,
@EnviarAsunto	varchar(255) OUTPUT,
@EnviarMensaje	varchar(255) OUTPUT,
@Enviar			bit          OUTPUT,
@EnviarXML		bit          OUTPUT,
@EnviarPDF		bit          OUTPUT,
@Cancelacion	bit			 = 0
AS
BEGIN
RETURN
END

