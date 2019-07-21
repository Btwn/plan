SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexCampoOrigen
(@Modulo     varchar(5), @ID  int, @Campo varchar(20))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado      varchar(50),
@Resultado2     varchar(50),
@IDOrigen       int,
@ModuloOrigen   varchar(10),
@Tipo           varchar(20)
SELECT @Resultado2 = dbo.fnCFDFlexIDOrigen(@Modulo,@ID,1)
SELECT @IDOrigen = CONVERT(int,dbo.fnCFDFlexSepararID(@Resultado2,'ID'))
SELECT @ModuloOrigen = dbo.fnCFDFlexSepararID(@Resultado2,'Modulo')
SELECT @Tipo = dbo.fnCFDFlexTipoOrigen(@ModuloOrigen,@IDOrigen)
IF @Campo = 'UUID'
SELECT @Resultado = CONVERT(varchar(50),UUID) FROM CFD WHERE Modulo = @ModuloOrigen AND ModuloID = @IDOrigen
IF @Campo = 'Serie'
SELECT @Resultado = Serie FROM CFD WHERE Modulo = @ModuloOrigen AND ModuloID = @IDOrigen
IF @Campo = 'Folio'
SELECT @Resultado = Folio FROM CFD WHERE Modulo = @ModuloOrigen AND ModuloID = @IDOrigen
IF @Campo = 'FolioFiscalOrig' AND @Tipo = 'CFDI'
SELECT @Resultado = CONVERT(varchar(50),UUID) FROM CFD WHERE Modulo = @ModuloOrigen AND ModuloID = @IDOrigen
ELSE
IF @Campo = 'SerieFolioFiscalOrig' AND @Tipo = 'CFD'
SELECT @Resultado = Serie+CONVERT(varchar,Folio) FROM CFD WHERE Modulo = @ModuloOrigen AND ModuloID = @IDOrigen
IF @Campo = 'FechaFolioFiscalOrig'
SELECT @Resultado = dbo.fneDocFormatoFecha(Fecha,'AAAA-MM-DDTHH:NN:SSZ') FROM CFD WHERE Modulo = @ModuloOrigen AND ModuloID = @IDOrigen
IF @Campo = 'MontoFolioFiscalOrig'
BEGIN
IF @ModuloOrigen = 'VTAS'
SELECT @Resultado = CONVERT(varchar,CONVERT(decimal(20,6),VentaImporteTotal)) FROM CFDVenta WHERE ID = @IDOrigen 
ELSE
IF @ModuloOrigen = 'CXC'
SELECT @Resultado = CONVERT(varchar,CONVERT(decimal(20,6),CxcTotal)) FROM CFDCxc WHERE ID = @IDOrigen 
END
SELECT @Resultado = ISNULL(@Resultado,'')
RETURN (@Resultado)
END

