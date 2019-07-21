SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraCalcPesoVolumen
@Empresa		char(5),
@ID			int,
@CfgMultiUnidades	bit,
@PesoTotal		float	OUTPUT,
@VolumenTotal	float	OUTPUT,
@PesoVolumenTotal	float	OUTPUT,
@PedimentoEspecifico	char(20) = NULL,
@ProrrateoNivel      varchar(20) = NULL

AS BEGIN
DECLARE
@Articulo	char(20),
@CantidadF	float,
@Peso	float,
@Volumen	float
SELECT @PesoTotal = 0.0, @VolumenTotal = 0.0, @PesoVolumenTotal = 0.0
IF @PedimentoEspecifico IS NULL
DECLARE crCompraD CURSOR FOR
SELECT d.Articulo, (d.Cantidad*d.Factor), ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0)
FROM CompraD d, Art a
WHERE d.ID = @ID AND d.Articulo = a.Articulo
ELSE
DECLARE crCompraD CURSOR FOR
SELECT d.Articulo, (d.Cantidad*d.Factor), ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0)
FROM CompraD d, Art a, SerieLoteMov s
WHERE d.ID = @ID AND d.Articulo = a.Articulo
AND s.Empresa = @Empresa AND s.Modulo = 'COMS' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
OPEN crCompraD
FETCH NEXT FROM crCompraD INTO @Articulo, @CantidadF, @Peso, @Volumen
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @CantidadF > 0.0
SELECT @PesoTotal = @PesoTotal + (@Peso * @CantidadF),
@VolumenTotal = @VolumenTotal + (@Volumen * @CantidadF),
@PesoVolumenTotal = @PesoVolumenTotal + (@Peso * @Volumen * @CantidadF)
FETCH NEXT FROM crCompraD INTO @Articulo, @CantidadF, @Peso, @Volumen
END
CLOSE crCompraD
DEALLOCATE crCompraD
RETURN
END

