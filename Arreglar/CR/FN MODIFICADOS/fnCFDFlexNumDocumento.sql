SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexNumDocumento
(@Empresa    varchar(5), @Aplica  varchar(20), @AplicaID varchar(20), @ID varchar(20))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado      varchar(50),
@Referencia     varchar(50),
@Len            int,
@Desde          int,
@Hasta          int,
@NoValidarOrigenDocumento bit,
@ParcialidadNumero        int,
@OrigenSerie          varchar(20),
@OrigenFolio          int,
@FolioFiscalOrig			varchar(50),
@SerieFolioFiscalOrig		varchar(50),
@Mov				    varchar(20),
@CFDEsParcialidad			bit
SELECT @Mov = Mov FROM Cxc WITH (NOLOCK) WHERE ID = @ID
SELECT @CFDEsParcialidad = ISNULL(CFDEsParcialidad,0) FROM MovTipo WITH (NOLOCK) WHERE Modulo = 'CXC' AND Mov = @Mov
SELECT @NoValidarOrigenDocumento = ISNULL(NoValidarOrigenDocumento,0)
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @Aplica IN(SELECT Mov FROM MovTipo WITH (NOLOCK) WHERE Clave = 'CXC.D' AND Modulo = 'CXC')
BEGIN
SELECT @Referencia = Referencia FROM Cxc WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID
SELECT @Len = LEN(@Referencia)
SELECT @Desde = CHARINDEX('(',@Referencia)
IF @Desde > 0
SELECT @Resultado = SUBSTRING(@Referencia,@Desde+1,@Len)
SELECT @Hasta = CHARINDEX(')',@Resultado)
SELECT @Resultado = LEFT(@Resultado,@Hasta-1)
SELECT @Resultado= 'Parcialidad' + ' ' + REPLACE(@Resultado,'/',' de ')
END
ELSE
IF @CFDEsParcialidad = 1
BEGIN
SELECT @FolioFiscalOrig = dbo.fnCFDFlexCampoOrigen('CXC', @ID, 'FolioFiscalOrig')
SELECT @SerieFolioFiscalOrig = dbo.fnCFDFlexCampoOrigen('CXC', @ID, 'SerieFolioFiscalOrig')
SELECT @OrigenSerie = dbo.fnSerieConsecutivo(@SerieFolioFiscalOrig)
SELECT @OrigenFolio = dbo.fnFolioConsecutivo(@SerieFolioFiscalOrig)
SELECT @ParcialidadNumero = ISNULL(MAX(ParcialidadNumero),0) FROM CFD WITH (NOLOCK) WHERE CONVERT(varchar(50),OrigenUUID) = @FolioFiscalOrig AND OrigenUUID IS NOT NULL AND ModuloID <> @ID
IF @ParcialidadNumero = 0 AND NULLIF(@FolioFiscalOrig,'') IS NULL
SELECT @ParcialidadNumero = ISNULL(MAX(ParcialidadNumero),0) FROM CFD WITH (NOLOCK) WHERE OrigenSerie = @OrigenSerie AND OrigenFolio = @OrigenFolio AND OrigenSerie IS NOT NULL AND OrigenFolio IS NOT NULL AND ModuloID <> @ID
SELECT @Resultado= 'Parcialidad' + ' ' + CONVERT(varchar, @ParcialidadNumero + 1)
END
SELECT @Resultado = ISNULL(@Resultado,'')
RETURN (@Resultado)
END

