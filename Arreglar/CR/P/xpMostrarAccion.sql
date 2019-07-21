SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMostrarAccion
@Empresa    varchar(5),
@Mov        varchar(20),
@ID         int,
@Modulo           char(5),
@Accion           varchar(20)=NULL
AS BEGIN
DECLARE @MostrarAccion		bit,
@Timbrado				bit,
@EsCFD				bit,
@VersionCFD			varchar(10),
@UUID					varchar(50),
@SelloSAT				varchar(max),
@TFDCadenaOriginal	varchar(max),
@EsCFDFlex				bit,
@Estatus				varchar(20),
@CFDflexEstatus		varchar(20),
@SelloCancelacion      varchar(max),
@ServidorPac			varchar(100),
@CFDI					bit,
@FechaRegistro		datetime,
@VersionFecha			datetime
SELECT @EsCFD = 0, @EsCFDFlex = 0
IF (SELECT ISNULL(CFD, 0) FROM Empresa WHERE Empresa = @Empresa) = 1 AND (SELECT ISNULL(CFD, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1
SELECT @EsCFD = 1
ELSE
IF (SELECT ISNULL(CFDFlex, 0) FROM EmpresaGral WHERE Empresa = @Empresa) = 1 AND (SELECT ISNULL(CFDFlex, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1
SELECT @EsCFD = 1, @EsCFDFlex = 1
IF @Modulo = 'VTAS'
SELECT @Estatus = Estatus, @CFDFlexEstatus = CFDFlexEstatus, @FechaRegistro = FechaRegistro FROM Venta WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @Estatus = Estatus, @CFDFlexEstatus = CFDFlexEstatus, @FechaRegistro = FechaRegistro FROM Cxc WHERE ID = @ID
IF @EsCFD = 0 OR @ID IS NULL 
BEGIN
IF @accion IN ('TIMBRAR', 'GENERARCFDI')
SELECT @MostrarAccion = 0
ELSE
SELECT @MostrarAccion = 1
END
ELSE
BEGIN 
SELECT @VersionCFD = Substring(CadenaOriginal, 3, 3),
@Timbrado = Timbrado,
@UUID = UUID,
@SelloSAT = SelloSAT,
@TFDCadenaOriginal = TFDCadenaOriginal,
@SelloCancelacion = SelloCancelacionSAT
FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
IF NULLIF(@VersionCFD,'') IS NULL OR ISNUMERIC(@VersionCFD)= 0 AND @EsCFDFlex = 0
BEGIN
SELECT @VersionCFD = Version, @VersionFecha = VersionFecha FROM EmpresaCFD WHERE Empresa = @Empresa
IF NOT EXISTS (SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID ) AND @FechaRegistro < @VersionFecha
SELECT @VersionCFD = 0
END
SELECT @CFDI = CFDI FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @ServidorPAC = TimbrarCFDIServidor FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @MostrarAccion = 0
IF @VersionCFD  >= '3.2' OR @CFDI = 1 
BEGIN
IF @Accion IN ('IMPRIMIR')
BEGIN
IF @Timbrado = 1 AND @UUID IS NOT NULL AND NULLIF(@SelloSAT,'') IS NOT NULL AND NULLIF(@TFDCadenaOriginal,'') IS NOT NULL
SELECT @MostrarAccion = 1 ELSE SELECT @MostrarAccion = 0
END
IF @Accion IN ('TIMBRAR')
BEGIN
IF @Timbrado = 0
SELECT @MostrarAccion = 1 ELSE SELECT @MostrarAccion = 0
END
IF @Accion IN ('CANCELAR') AND @Estatus NOT IN ( 'BORRADOR', 'CONFIRMAR', 'SINAFECTAR')
BEGIN
IF @Timbrado = 0  or  (@Timbrado = 1 AND @ServidorPac IN (SELECT Servidor FROM dbo.fnIntelisisCFDIListaPAC(@Empresa)) )
SELECT @MostrarAccion = 1
ELSE  SELECT @MostrarAccion = 0
END
IF @Accion = 'GENERARCFDI' AND @Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
BEGIN
IF (@Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND @UUID IS NULL AND @SelloSAT IS NULL)
OR (@Estatus = 'CANCELADO' AND @ServidorPAC IN (SELECT Servidor FROM dbo.fnIntelisisCFDIListaPAC(@Empresa)) AND @SelloCancelacion IS NULL)
SELECT @MostrarAccion = 1
ELSE SELECT @MostrarAccion = 0
END
END
ELSE
BEGIN 
IF @Accion IN ('IMPRIMIR', 'CANCELAR')
SELECT @MostrarAccion = 1
END
END
SELECT @MostrarAccion
RETURN
END

