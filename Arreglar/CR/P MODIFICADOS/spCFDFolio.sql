SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFolio
@Sucursal		int,
@Empresa     	char(5),
@Modulo		char(5),
@Mov      		char(20),
@MovID		varchar(20)	OUTPUT,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@ModuloAfectacion varchar(5) = NULL,
@ID int = NULL

AS BEGIN
DECLARE
@CFDFolio			int,
@CFDFolioA			int,
@CFDSerie			varchar(10),
@Nivel 				varchar(10),
@Fecha 				datetime,
@noAprobacion 		int,
@fechaAprobacion 	datetime,
@RFC 				varchar(20),
@Cliente			varchar(20), 
@CFDImporte			float, 
@CFDImpuesto1		float, 
@CFDImpuesto2		float, 
@TipoCambio			float,  
@FechaRegistro      datetime
IF @ID IS NOT NULL
SELECT @MovID = MovID FROM CFD WITH (NOLOCK) WHERE Modulo = @ModuloAfectacion AND ModuloID = @ID
IF (SELECT CFD FROM Empresa WITH (NOLOCK) WHERE Empresa = @Empresa) = 1
EXEC spCFDFolioPrevio @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ModuloAfectacion, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @MovID IS NULL
BEGIN
SELECT @CFDFolioA = NULL
SELECT @CFDFolioA = MIN(FolioA), @Nivel = 'Global'
FROM CFDFolio WITH (NOLOCK)
WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND Estatus = 'ALTA' AND ISNULL(Folio, 0) < ISNULL(FolioA, 0) AND Nivel = 'Global'
IF NULLIF(@CFDFolioA, 0) IS NULL
SELECT @CFDFolioA = MIN(FolioA), @Nivel = 'Sucursal'
FROM CFDFolio WITH (NOLOCK)
WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND Estatus = 'ALTA' AND ISNULL(Folio, 0) < ISNULL(FolioA, 0) AND Nivel = 'Sucursal'  AND Sucursal = @Sucursal
IF NULLIF(@CFDFolioA, 0) IS NULL
SELECT @Ok = 30013
ELSE BEGIN
IF @Nivel = 'Global'
UPDATE CFDFolio  WITH (ROWLOCK)
SET @CFDFolio = Folio = ISNULL(Folio, FolioD - 1) + 1, @CFDSerie = Serie, @NoAprobacion = NoAprobacion, @fechaAprobacion = fechaAprobacion
WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND Estatus = 'ALTA' AND FolioA = @CFDFolioA AND Nivel = 'Global'
ELSE IF @Nivel = 'Sucursal'
UPDATE CFDFolio WITH (ROWLOCK)
SET @CFDFolio = Folio = ISNULL(Folio, FolioD - 1) + 1, @CFDSerie = Serie, @NoAprobacion = NoAprobacion, @fechaAprobacion = fechaAprobacion
WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND Estatus = 'ALTA' AND FolioA = @CFDFolioA AND Nivel = 'Sucursal' AND Sucursal = @Sucursal
END
SELECT @MovID = ISNULL(@CFDSerie, '')+CONVERT(varchar, @CFDFolio)
END
IF @ID IS NOT NULL
BEGIN
IF NOT EXISTS (SELECT ModuloID FROM CFD WITH (NOLOCK) WHERE Modulo = @ModuloAfectacion AND ModuloID = @ID)
BEGIN
IF @ModuloAfectacion = 'VTAS'
BEGIN
SELECT @Cliente = v.Cliente, @CFDImporte = ISNULL(vtce.SubTotal,0.0), @CFDImpuesto1 = ISNULL(Impuesto1Total,0.0), @CFDImpuesto2 = ISNULL(Impuesto2Total,0.0), @TipoCambio = v.TipoCambio FROM Venta v WITH (NOLOCK) JOIN VentaTCalcExportacion vtce WITH (NOLOCK) ON vtce.ID = v.ID WHERE v.ID = @ID   
SELECT @FechaRegistro = FechaRegistro FROM Venta WITH (NOLOCK) WHERE ID = @ID
END ELSE
IF @ModuloAfectacion = 'CXC'
BEGIN
SELECT @FechaRegistro = FechaRegistro FROM CXC WITH (NOLOCK) WHERE ID = @ID
SELECT @Cliente = v.Cliente,  @CFDImporte = ISNULL(v.Importe,0.0),      @CFDImpuesto1 = ISNULL(v.Impuestos,0.0),    @CFDImpuesto2 = 0.0,                        @TipoCambio = v.TipoCambio FROM CXC v WITH (NOLOCK) WHERE v.ID = @ID  
END
IF @FEchaRegistro IS NOT NULL SELECT @Fecha = @FechaRegistro ELSE SELECT @Fecha = GETDATE()
SELECT @RFC = RFC FROM Cte WITH (NOLOCK) WHERE Cliente = @Cliente
INSERT CFD (Modulo,            ModuloID, Fecha,  Ejercicio,    Periodo,       Empresa,  MovID,  Serie,     Folio,     RFC,  Aprobacion,                                                               Importe,     Impuesto1,     Impuesto2,     TipoCambio)  
VALUES     (@ModuloAfectacion, @ID,      @Fecha, YEAR(@Fecha), MONTH(@Fecha), @Empresa, @MovID, @CFDSerie, @CFDFolio, @RFC, CONVERT(varchar, YEAR(@fechaAprobacion))+CONVERT(varchar, @noAprobacion), @CFDImporte, @CFDImpuesto1, @CFDImpuesto2, @TipoCambio) 
END
END
END

