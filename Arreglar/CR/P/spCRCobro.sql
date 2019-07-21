SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCRCobro
@CRID			int,
@Sucursal		int,
@CRProcesoDistribuido	bit,
@CRServidorOperaciones	varchar(50),
@CRBaseDatosOperaciones	varchar(50),
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Renglon		float,
@Cxc		bit,
@FormaPago		varchar(50),
@Referencia		varchar(50),
@Importe		money,
@Moneda		varchar(10),
@TipoCambio		float,
@Cliente		varchar(10),
@ClienteEnviarA	int,
@CFDSerie		varchar(20), 
@CFDFolio		varchar(20), 
@Vencimiento	datetime,
@SQL		nvarchar(4000),
@Params		nvarchar(4000)
SELECT @Renglon = 0.0
DECLARE crCRCobro CURSOR LOCAL FOR
SELECT FormaPago, Referencia, Moneda, TipoCambio, Cliente, ISNULL(Cxc, 0), Vencimiento, Importe, ISNULL(CFDSerie,''), ISNULL(CFDFolio,'') 
FROM #CRCobro
OPEN crCRCobro
FETCH NEXT FROM crCRCobro INTO @FormaPago, @Referencia, @Moneda, @TipoCambio, @Cliente, @Cxc, @Vencimiento, @Importe, @CFDSerie, @CFDFolio 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0
SELECT @SQL = N'EXEC '
IF @CRProcesoDistribuido = 1 SELECT @SQL = @SQL + @CRServidorOperaciones+'.'+@CRBaseDatosOperaciones+'.dbo.'
SELECT @SQL = @SQL + N'spInsertarCRCobro @CRID, @Sucursal, @Renglon, @FormaPago, @Referencia, @Moneda, @TipoCambio, @Cliente, @Cxc, @Vencimiento, @Importe, @CFDSerie, @CFDFolio, @Ok OUTPUT, @OkRef OUTPUT' 
SELECT @Params = N'@CRID int, @Sucursal int, @Renglon float, @FormaPago varchar(50), @Referencia varchar(50), @Moneda varchar(10), @TipoCambio float, @Cliente varchar(10), @Cxc bit, @Vencimiento datetime, @Importe money, @CFDSerie varchar(20), @CFDFolio varchar(20), @Ok int OUTPUT, @OkRef varchar(255) OUTPUT' 
EXEC sp_executesql @SQL, @Params, @CRID, @Sucursal, @Renglon, @FormaPago, @Referencia, @Moneda, @TipoCambio, @Cliente, @Cxc, @Vencimiento, @Importe, @CFDSerie, @CFDFolio, @Ok OUTPUT, @OkRef OUTPUT 
END
FETCH NEXT FROM crCRCobro INTO @FormaPago, @Referencia, @Moneda, @TipoCambio, @Cliente, @Cxc, @Vencimiento, @Importe, @CFDSerie, @CFDFolio 
END 
CLOSE crCRCobro
DEALLOCATE crCRCobro
RETURN
END

