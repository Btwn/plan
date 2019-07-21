SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexCancelar
@Estacion		int,
@Empresa		varchar(5),
@Modulo			varchar(5),
@ID				int,
@Estatus		varchar(15),
@Ok				int OUTPUT,
@OkRef			varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaCancelacion			datetime,
@CFDFecha					datetime,
@CFDEmpresa					varchar(5),
@MovID						varchar(20),
@CFDSerie					varchar(20),
@CFDFolio					varchar(20),
@CFDRFC						varchar(15),
@CFDImporte					float,
@CFDImpuesto1				float,
@CFDImpuesto2				float,
@TipoCambio					float
IF @Estatus = 'CANCELADO'
BEGIN
SET @CFDFecha     = NULL
SET @CFDEmpresa   = NULL
SET @MovID        = NULL
SET @CFDSerie     = NULL
SET @CFDFolio     = NULL
SET @CFDRFC       = NULL
SET @CFDImporte   = NULL
SET @CFDImpuesto1 = NULL
SET @CFDImpuesto2 = NULL
SET @TipoCambio   = NULL
IF @Modulo = 'VTAS' SELECT @FechaCancelacion = ISNULL(v.FechaCancelacion,GETDATE()), @Modulo = 'VTAS', @CFDFecha = v.FechaRegistro, @CFDEmpresa = v.Empresa, @MovID = ISNULL(v.MovID,0.0), @CFDSerie = dbo.fnSerieConsecutivo(ISNULL(v.MovID,0.0)), @CFDFolio = dbo.fnFolioConsecutivo(ISNULL(v.MovID,'')), @CFDRFC = ISNULL(c.RFC,''), @CFDImporte = ISNULL(vtce.TotalNeto,0.0), @CFDImpuesto1 = ISNULL(Impuesto1Total,0.0), @CFDImpuesto2 = ISNULL(Impuesto2Total,0.0), @TipoCambio = v.TipoCambio FROM Venta v JOIN Cte c ON c.Cliente = v.Cliente JOIN VentaTCalcExportacion  vtce ON vtce.ID = v.ID WHERE v.ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @FechaCancelacion = ISNULL(v.FechaCancelacion,GETDATE()), @Modulo = 'CXC',  @CFDFecha = v.FechaRegistro, @CFDEmpresa = v.Empresa, @MovID = ISNULL(v.MovID,0.0), @CFDSerie = dbo.fnSerieConsecutivo(ISNULL(v.MovID,0.0)), @CFDFolio = dbo.fnFolioConsecutivo(ISNULL(v.MovID,'')), @CFDRFC = ISNULL(c.RFC,''), @CFDImporte = ISNULL(v.Importe,0.0),      @CFDImpuesto1 = ISNULL(v.Impuestos,0.0),    @CFDImpuesto2 = 0.0,                        @TipoCambio = v.TipoCambio FROM Cxc v  JOIN Cte c ON c.Cliente = v.Cliente WHERE ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @FechaCancelacion = FechaCancelacion FROM Compra   WHERE ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @FechaCancelacion = FechaCancelacion FROM Cxp      WHERE ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @FechaCancelacion = FechaCancelacion FROM Gasto    WHERE ID = @ID
IF @Modulo IN ('VTAS','CXC')
BEGIN
IF NOT EXISTS(SELECT 1 FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID) 
INSERT CFD (Modulo,  ModuloID, Fecha,     Ejercicio,       Periodo,          Empresa,  MovID,  Serie,     Folio,     RFC,     Importe,     Impuesto1,     Impuesto2,     TipoCambio)
VALUES (@Modulo, @ID,      @CFDFecha, YEAR(@CFDFecha), MONTH(@CFDFecha), @Empresa, @MovID, @CFDSerie, @CFDFolio, @CFDRFC, @CFDImporte, @CFDImpuesto1, @CFDImpuesto2, @TipoCambio)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
UPDATE CFD
SET FechaCancelacion = @FechaCancelacion,
Fecha            = ISNULL(Fecha,@CFDFecha),
Empresa          = ISNULL(Empresa,@CFDEmpresa),
MovID            = ISNULL(MovID,@MovID),
Serie            = ISNULL(Serie,@CFDSerie),
Folio            = ISNULL(Folio,@CFDFolio),
RFC              = ISNULL(RFC,@CFDRFC),
Importe          = ISNULL(Importe,@CFDImporte),
Impuesto1        = ISNULL(Impuesto1,@CFDImpuesto1),
Impuesto2        = ISNULL(Impuesto2,@CFDImpuesto2),
TipoCambio       = ISNULL(TipoCambio,@TipoCambio)
WHERE Modulo = @Modulo
AND ModuloID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

