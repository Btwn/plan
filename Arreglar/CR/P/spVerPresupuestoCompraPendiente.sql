SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerPresupuestoCompraPendiente
@Empresa	char(5),
@FechaEmision	datetime,
@FechaRequerida	datetime,
@Articulo	varchar(20),
@SubCuenta	varchar(50),
@MovMoneda	varchar(10),
@ContUso 	varchar(20),
@Categoria	varchar(50),
@ContUso2 	char(20) = NULL,
@ContUso3 	char(20) = NULL

AS BEGIN
SELECT @SubCuenta = NULLIF(NULLIF(RTRIM(@SubCuenta), '0'), ''),
@ContUso = NULLIF(NULLIF(RTRIM(@ContUso), '0'), ''),
@ContUso2 = NULLIF(NULLIF(RTRIM(@ContUso2), '0'), ''),
@ContUso3 = NULLIF(NULLIF(RTRIM(@ContUso3), '0'), ''),
@Categoria = NULLIF(NULLIF(RTRIM(@Categoria), '0'), ''),
@FechaRequerida = ISNULL(@FechaRequerida, @FechaEmision)
IF @Categoria IS NOT NULL
SELECT SUM(d.SubTotal)
FROM Compra e, CompraTCalc d, MovTipo mt, Art a
WHERE e.ID = d.ID AND e.Estatus = 'PENDIENTE' AND DATEPART(year, e.FechaEmision) = DATEPART(year, @FechaEmision) AND DATEPART(month, e.FechaEmision) = DATEPART(month, @FechaEmision)
AND /*d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND */e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.OP', 'COMS.OG', 'COMS.OI')
AND a.Articulo = d.Articulo AND a.Categoria = @Categoria AND d.Empresa = @Empresa
ELSE
SELECT SUM(d.SubTotal)
FROM Compra e, CompraTCalc d, MovTipo mt
WHERE e.ID = d.ID AND e.Estatus = 'PENDIENTE' AND DATEPART(year, e.FechaEmision) = DATEPART(year, @FechaEmision) AND DATEPART(month, e.FechaEmision) = DATEPART(month, @FechaEmision)
AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave IN ('COMS.O', 'COMS.OP', 'COMS.OG', 'COMS.OI') AND d.Empresa = @Empresa
END

