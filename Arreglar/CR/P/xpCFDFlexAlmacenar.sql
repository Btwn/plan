SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDFlexAlmacenar
@Modulo			char(5),
@ID				int,
@Usuario		varchar(10),
@Adicional		bit,
@XML			bit OUTPUT,
@PDF			bit OUTPUT,
@Nomarch		varchar(255) OUTPUT,
@Reporte		varchar(100) OUTPUT,
@Ruta			varchar(255) OUTPUT,
@EnviarPara		varchar(255) OUTPUT,
@EnviarAsunto	varchar(255) OUTPUT,
@EnviarMensaje	varchar(255) OUTPUT,
@Cliente		varchar(10)  OUTPUT,
@Sucursal		int OUTPUT,
@Enviar			bit          OUTPUT,
@EnviarXML		bit			 OUTPUT,
@EnviarPDF		bit			 OUTPUT
AS BEGIN
RETURN
END

