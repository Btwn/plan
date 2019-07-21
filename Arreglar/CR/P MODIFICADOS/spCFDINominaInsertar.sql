SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaInsertar
@ID				int,
@Empresa		varchar(5),
@Sucursal		int,
@Mov			varchar(20),
@MovID			varchar(20),
@Version		varchar(5),
@XML			varchar(max),
@Usuario		varchar(10),
@RFCEmisor		varchar(20),
@Importe		float,
@NoTimbrado		int,
@Ok				int			OUTPUT,
@OkRef			varchar(255)OUTPUT,
@PersonalEsp	varchar(10) = NULL

AS
BEGIN
DECLARE @Personal			varchar(10),
@PersonalAnt		varchar(10),
@Fecha			datetime,
@Ejercicio		int,
@Periodo			int,
@Moneda			varchar(10),
@TipoCambio		float,
@RFCReceptor		varchar(20)
SELECT @Fecha = FechaEmision, @Ejercicio = Ejercicio, @Periodo = Periodo, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Nomina WITH (NOLOCK) WHERE ID = @ID
SELECT @RFCReceptor = Registro2 FROM Personal WITH (NOLOCK) WHERE Personal = @Personal
IF ISNULL(@PersonalEsp, '') = ''
IF EXISTS(SELECT * FROM CFDNomina WITH (NOLOCK) WHERE Modulo = 'NOM' AND ModuloID = @ID) RETURN
SELECT @PersonalAnt = ''
WHILE(1=1)
BEGIN
IF ISNULL(@PersonalEsp, '') = ''
SELECT @Personal = MIN(Personal)
FROM NominaD WITH (NOLOCK)
WHERE ID = @ID
AND Personal > @PersonalAnt
ELSE
SELECT @Personal = MIN(Personal)
FROM NominaD WITH (NOLOCK)
WHERE ID = @ID
AND Personal > @PersonalAnt
AND Personal = @PersonalEsp
IF @Personal IS NULL BREAK
SELECT @PersonalAnt = @Personal
EXEC spCFDINominaActualizar @ID, @Personal, @Empresa, @Mov, @MovID, @Version, @Fecha, @Ejercicio, @Periodo, @RFCEmisor = @RFCEmisor,
@RFCReceptor = @RFCReceptor, @Importe = @Importe, @Moneda =  @Moneda, @TipoCambio = @TipoCambio,
@NoTimbrado = @NoTimbrado,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END

