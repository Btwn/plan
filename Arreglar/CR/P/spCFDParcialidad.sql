SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDParcialidad
@ID					int,
@Modulo				varchar(20),
@Empresa				varchar(20),
@Mov					varchar(20),
@MovTipo			    varchar(20),
@Concepto				varchar(50) OUTPUT,
@FormadePago			varchar(255) OUTPUT,
@FolioFiscalOrig		varchar(50) OUTPUT,
@SerieFolioFiscalOrig	varchar(20) OUTPUT,
@FechaFolioFiscalOrig	datetime OUTPUT,
@MontoFolioFiscalOrig	float OUTPUT,
@Ok					int OUTPUT,
@OkRef					varchar(255) OUTPUT

AS BEGIN
DECLARE
@Origen						varchar(20),
@OrigenID					varchar(20),
@Referencia					varchar(50),
@IdOrigen					int,
@OrigenDAMov				varchar(20),
@OrigenDAMovID				varchar(20),
@IdFacturaVta				int,
@Resultado					varchar(50),
@Len						int,
@Desde						int,
@Hasta						int,
@NoValidarOrigenDocumento	bit,
@AplicaMov					varchar(20),
@AplicaMovID				varchar(20),
@IDAplica					int,
@AplicaMovTipo				varchar(20),
@Parcialidad				int,
@IDFacturaCxc				int
SELECT @NoValidarOrigenDocumento = ISNULL(NoValidarOrigenDocumento,0)
FROM EmpresaCFD
WHERE Empresa = @Empresa
IF @Modulo = 'CXC'
BEGIN
IF (SELECT Count(ID) FROM CxcD c JOIN MovTipo mt ON mt.Modulo = 'CXC' AND c.Aplica = mt.Mov WHERE c.ID = @ID AND mt.Clave IN ('CXC.D','CXC.F')) > 2
SELECT @Ok = 30013, @OkRef = 'Solo se Permite Aplicar una Parcialidad por Comprobante Fiscal Digital '
IF @NoValidarOrigenDocumento = 0
BEGIN
SELECT @Origen = Origen, @OrigenID = OrigenID, @Referencia = Referencia FROM CXC WHERE ID = @ID
SELECT @IDOrigen = ID FROM CXC WHERE Empresa = @Empresa AND Mov = @Origen AND MovId = @OrigenID
IF (SELECT mt.clave FROM CXC c JOIN MovTipo mt ON mt.Modulo = 'CXC' AND c.Mov = mt.Mov WHERE ID = @IDorigen) = 'CXC.D'
SELECT @OrigenDAMov = d.Mov, @OrigenDAMovID = d.MovID FROM CXC c
JOIN DocAuto d ON c.Empresa = d.Empresa AND c.Origen = d.Mov AND c.OrigenID = d.MovID
WHERE c.ID = @IDOrigen
IF @OrigenDAMovID IS NOT NULL
BEGIN
SELECT @IDFacturaVta = ID FROM Venta WHERE Empresa = @Empresa AND Mov = @OrigenDAMov AND MovID = @OrigenDAMovID
IF @OK IS NULL AND @IDFacturaVta IS NOT NULL
BEGIN
SELECT @FechaFolioFiscalOrig = Fecha, @FolioFiscalOrig = UUID,  @SerieFolioFiscalOrig = Serie,
@MontoFolioFiscalOrig = ISNULL(Importe,0.0)+ISNULL(Impuesto1,0.0)+ISNULL(Impuesto2,0.0)-ISNULL(Retencion1,0.0)-ISNULL(Retencion2,0.0)
FROM CFD WHERE Modulo = 'VTAS' AND ModuloID = @IDFacturaVta
SELECT @Len = LEN(@Referencia)
SELECT @Desde=CHARINDEX('(',@Referencia)
SELECT @Resultado = SUBSTRING(@Referencia,@Desde+1,@Len)
SELECT @Hasta=CHARINDEX(')',@Resultado)
SELECT @Resultado = LEFT(@Resultado,@Hasta-1)
SELECT @FormadePago= 'Parcialidad'+' '+REPLACE(@Resultado,'/',' de ')
SELECT @Concepto = @FormadePago
END
END
END ELSE
IF @NoValidarOrigenDocumento = 1
BEGIN
SELECT @AplicaMov = Aplica, @AplicaMovID = AplicaID, @AplicaMovTipo = Clave FROM CxcD d
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = d.Aplica
WHERE mt.Clave IN ('CXC.F', 'CXC.D') AND ID = @ID
SELECT @IDAplica = ID FROM Cxc WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID
IF @AplicaMovTipo = 'CXC.F'
SELECT @IdFacturaVta = OID FROM MovFlujo WHERE DModulo = 'CXC' AND DID = @IDAplica AND OModulo = 'VTAS'
IF @AplicaMovTipo = 'CXC.D'
BEGIN
SELECT @IDFacturaCXC = mf.OID FROM MovFlujo mf
JOIN MovTipo mt ON mf.OMov = mt.Mov AND mf.OModulo = mt.Modulo AND mt.Clave = 'CXC.F'
WHERE mf.DModulo = 'CXC' AND mf.DID = @IDAplica AND mf.OModulo ='CXC' AND mf.Cancelado = 0
SELECT @IDFacturaVta = mf.OID FROM MovFlujo mf
JOIN MovTipo mt ON mf.OMov = mt.Mov AND mf.OModulo = mt.Modulo AND mt.Clave = 'VTAS.F'
WHERE mf.DModulo = 'CXC' AND mf.DID = @IDFacturaCxc AND mf.OModulo ='VTAS' AND mf.Cancelado = 0
END
IF @OK IS NULL AND @IDFacturaVta IS NOT NULL
BEGIN
SELECT @FechaFolioFiscalOrig = Fecha, @FolioFiscalOrig = UUID,  @SerieFolioFiscalOrig = Serie,
@MontoFolioFiscalOrig = ISNULL(Importe,0.0)+ISNULL(Impuesto1,0.0)+ISNULL(Impuesto2,0.0)-ISNULL(Retencion1,0.0)-ISNULL(Retencion2,0.0)
FROM CFD WHERE Modulo = 'VTAS' AND ModuloID = @IDFacturaVta
IF (SELECT NULLIF(ParcialidadNumero,'') FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID) IS NULL
BEGIN
SELECT @Parcialidad = MAX(ParcialidadNumero) FROM CFD WHERE Empresa = @Empresa AND @Modulo ='CXC' AND OrigenSerie = @SerieFolioFiscalOrig AND OrigenUUID = @FolioFiscalOrig
SELECT @Parcialidad = ISNULL(@Parcialidad,0) + 1
END ELSE
SELECT @Parcialidad = NULLIF(ParcialidadNumero,'') FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
UPDATE CFD SET OrigenSerie = @SerieFolioFiscalOrig, OrigenUUID = @FolioFiscalOrig, ParcialidadNumero = @Parcialidad WHERE Modulo = @Modulo AND ModuloID = @ID
SELECT @FormadePago = 'Parcialidad '+convert(varchar,@Parcialidad)
SELECT @Concepto = @FormadePago
END
END
END
EXEC xpCFDParcialidad @ID, @Modulo, @Empresa, @Mov, @MovTipo, @Concepto OUTPUT, @FormadePago OUTPUT, @FolioFiscalOrig OUTPUT, @SerieFolioFiscalOrig OUTPUT, @FechaFolioFiscalOrig OUTPUT, @MontoFolioFiscalOrig OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END

