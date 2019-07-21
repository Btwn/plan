SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvMatarNotas
@Sucursal		int,
@ID			int,
@Accion			char(20),
@Empresa		char(5),
@Usuario		char(10),
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@FechaAfectacion	datetime,
@Ejercicio		int,
@Periodo		int,
@Ok 			int	     OUTPUT,
@OkRef          	varchar(255) OUTPUT,
@AfectandoNotasSinCobro	bit	     OUTPUT,
@MovTipo                varchar(20)

AS BEGIN
DECLARE
@IDNota			int,
@NotaMov			char(20),
@NotaMovID			varchar(20),
@NotaCliente		char(10),
@NotaEstatus		char(15),
@NotaEstatusNuevo		char(15),
@NotaMovTipo		char(20),
@NotaImporteTotal		money,
@NotaMoneda			char(10),
@NotaTipoCambio		float,
@EsCargo			bit,
@CfgMoverNotasAuto		bit,
@GenerarNCAlProcesar       bit,
@ProcesadoID                int,
@CfgAnticipoArticuloServicio varchar(20),
@ArtOfertaFP                varchar(20),
@ArtOfertaImporte           varchar(20),
@RenglonVal int,
@OrigenIDVal int,
@Renglones int
DECLARE crValidarOrigen CURSOR LOCAL FOR
SELECT RenglonID,OrigenID
FROM VentaOrigen
WHERE ID = @ID
OPEN crValidarOrigen
FETCH NEXT FROM crValidarOrigen INTO @RenglonVal,@OrigenIDVal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglones = COUNT(RenglonID)
FROM VentaOrigen
WHERE ID = @ID AND OrigenID = @OrigenIDVal
IF @Renglones >= 2
BEGIN
DELETE VentaOrigen WHERE ID = @ID AND RenglonID = @RenglonVal
END
SET @Renglones = 0
END
FETCH NEXT FROM crValidarOrigen INTO @RenglonVal,@OrigenIDVal
END
CLOSE crValidarOrigen
DEALLOCATE crValidarOrigen
SELECT @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg WHERE Empresa = @Empresa
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')    FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @CfgMoverNotasAuto = ISNULL(MoverNotasAuto, 0), @GenerarNCAlProcesar = ISNULL(GenerarNCAlProcesar,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @AfectandoNotasSinCobro = 0
IF @Accion <> 'CANCELAR'
BEGIN
IF NOT EXISTS(SELECT * FROM Venta v, VentaOrigen o WHERE v.ID = o.OrigenID AND o.ID = @ID)
SELECT @AfectandoNotasSinCobro = 1
ELSE BEGIN
DECLARE @ChecarNotas TABLE (
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Cantidad		float		NULL)
IF @GenerarNCAlProcesar = 1
BEGIN
IF @MovTipo = 'VTAS.F'
BEGIN
INSERT INTO @ChecarNotas (Articulo, SubCuenta, Cantidad)
SELECT Articulo, SubCuenta, SUM(ISNULL(Cantidad, 0.0))
FROM Venta v, VentaD d, VentaOrigen o
WHERE v.ID = o.OrigenID
AND v.ID = d.ID
AND o.ID = @ID
AND ((d.Cantidad > 0.0)OR d.Articulo IN (@CfgAnticipoArticuloServicio,@ArtOfertaFP,@ArtOfertaImporte ))
GROUP BY Articulo, SubCuenta
UNION
SELECT Articulo, SubCuenta, -SUM(ISNULL(Cantidad, 0.0))
FROM VentaD
WHERE ID = @ID
GROUP BY Articulo, SubCuenta
ORDER BY Articulo, SubCuenta
IF (SELECT ROUND(SUM(Cantidad), 0) FROM @ChecarNotas) <> 0 SELECT @Ok = 20380
END
IF @MovTipo = 'VTAS.D'
BEGIN
INSERT INTO @ChecarNotas (Articulo, SubCuenta, Cantidad)
SELECT Articulo, SubCuenta, -SUM(ISNULL(Cantidad, 0.0))
FROM Venta v, VentaD d, VentaOrigen o
WHERE v.ID = o.OrigenID
AND v.ID = d.ID
AND o.ID = @ID
AND ((d.Cantidad < 0.0) AND d.Articulo NOT IN (@CfgAnticipoArticuloServicio,@ArtOfertaFP,@ArtOfertaImporte ))
GROUP BY Articulo, SubCuenta
UNION
SELECT Articulo, SubCuenta, -SUM(ISNULL(Cantidad, 0.0))
FROM VentaD
WHERE ID = @ID
GROUP BY Articulo, SubCuenta
ORDER BY Articulo, SubCuenta
END
END
ELSE
BEGIN
INSERT INTO @ChecarNotas (Articulo, SubCuenta, Cantidad)
SELECT Articulo, SubCuenta, SUM(ISNULL(Cantidad, 0.0))
FROM Venta v, VentaD d, VentaOrigen o
WHERE v.ID = o.OrigenID
AND v.ID = d.ID
AND o.ID = @ID
GROUP BY Articulo, SubCuenta
UNION
SELECT Articulo, SubCuenta, -SUM(ISNULL(Cantidad, 0.0))
FROM VentaD
WHERE ID = @ID
GROUP BY Articulo, SubCuenta
ORDER BY Articulo, SubCuenta
IF (SELECT ROUND(SUM(Cantidad), 0) FROM @ChecarNotas) <> 0 SELECT @Ok = 20380
END
IF @Ok = 20380 AND EXISTS(SELECT * FROM Venta v, VentaOrigen o, MovTipo mt WHERE v.ID = o.OrigenID AND o.ID = @ID AND mt.Modulo = 'VTAS' AND mt.Mov = v.Mov AND mt.Clave = 'VTAS.NO')
SELECT @Ok = NULL
END
END
IF @Ok IS NULL
BEGIN
IF @CfgMoverNotasAuto = 1 AND @Accion = 'CANCELAR' AND @Ok IS NULL
BEGIN
DECLARE crRegresarNota CURSOR LOCAL FOR
SELECT OrigenID
FROM VentaOrigen
WHERE ID = @ID
OPEN crRegresarNota
FETCH NEXT FROM crRegresarNota INTO @IDNota
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spMoverNota @IDNota, 'REGRESAR'
END
FETCH NEXT FROM crRegresarNota INTO @IDNota
END
CLOSE crRegresarNota
DEALLOCATE crRegresarNota
END
DECLARE crVentaOrigen CURSOR LOCAL FOR
SELECT v.ID, v.Mov, v.MovID, v.Moneda, v.TipoCambio, v.Cliente, ISNULL(v.Importe, 0)+ISNULL(v.Impuestos, 0), v.Estatus, mt.Clave
FROM Venta v, VentaOrigen o, MovTipo mt
WHERE v.ID = o.OrigenID AND o.ID = @ID AND mt.Modulo = 'VTAS' AND mt.Mov = v.Mov
OPEN crVentaOrigen
FETCH NEXT FROM crVentaOrigen INTO @IDNota, @NotaMov, @NotaMovID, @NotaMoneda, @NotaTipoCambio, @NotaCliente, @NotaImporteTotal, @NotaEstatus, @NotaMovTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @NotaMovTipo IN ('VTAS.NO', 'VTAS.NR') SELECT @AfectandoNotasSinCobro = 1
IF (@Accion  = 'CANCELAR' AND @NotaEstatus <> 'CONCLUIDO' AND @MovTipo NOT IN('VTAS.FM')) OR
(@Accion <> 'CANCELAR' AND @NotaEstatus <> 'PROCESAR' AND @MovTipo NOT IN('VTAS.FM'))
SELECT @Ok = 20380, @OkRef = RTRIM(@NotaMov)+' '+RTRIM(Convert(char, @NotaMovID))
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDNota, @NotaMov, @NotaMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
IF @GenerarNCAlProcesar = 1
BEGIN
IF @Accion <> 'CANCELAR'
BEGIN
UPDATE VentaD SET ProcesadoID = vpt.ID
FROM  VentaProcesarNotas vpt JOIN VentaD d ON d.ID = vpt.IDOrigen AND d.Renglon = vpt.Renglon AND d.RenglonSub = vpt.RenglonSub
WHERE  vpt.IDOrigen = @IDNota AND d.ID = @IDNota AND vpt.ID = @ID
IF EXISTS (SELECT * FROM VentaD WHERE ID = @IDNota AND  ProcesadoID  IS NULL)
SELECT @NotaEstatusNuevo = 'PROCESAR'
ELSE
SELECT @NotaEstatusNuevo = 'CONCLUIDO'
END
ELSE
IF @Accion = 'CANCELAR'
BEGIN
UPDATE VentaD SET ProcesadoID = NULL
WHERE ID = @IDNota AND ProcesadoID = @ID
DELETE   VentaProcesarNotas WHERE IDOrigen = @IDNota AND ID = @ID
SELECT @NotaEstatusNuevo = 'PROCESAR'
END
END
ELSE
SELECT @NotaEstatusNuevo = CASE @Accion WHEN 'CANCELAR' THEN 'PROCESAR' ELSE 'CONCLUIDO' END
EXEC spValidarTareas @Empresa, @Modulo, @IDNota, @NotaEstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Venta
SET Saldo = NULL,
Estatus = @NotaEstatusNuevo
WHERE ID = @IDNota
IF @@ERROR <> 0 SELECT @Ok = 1
IF @NotaMovTipo = 'VTAS.NO'
BEGIN
SELECT @EsCargo = 0
IF @Accion = 'CANCELAR' SELECT @EsCargo = ~@EsCargo
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, 'CNO', @NotaMoneda, @NotaTipoCambio, @NotaCliente, NULL, NULL, NULL,
@Modulo, @IDNota, @NotaMov, @NotaMovID, @EsCargo, @NotaImporteTotal, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, 'Consumos', NULL, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @CfgMoverNotasAuto = 1 AND @NotaMovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR') AND @Accion <> 'CANCELAR'
EXEC spMoverNota @IDNota, 'MOVER'
END
IF @Ok IS NULL
FETCH NEXT FROM crVentaOrigen INTO @IDNota, @NotaMov, @NotaMovID, @NotaMoneda, @NotaTipoCambio, @NotaCliente, @NotaImporteTotal, @NotaEstatus, @NotaMovTipo
END
CLOSE crVentaOrigen
DEALLOCATE crVentaOrigen
END
RETURN
END

