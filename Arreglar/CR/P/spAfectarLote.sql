SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarLote
@Empresa char(5),
@Usuario char(10),
@Modulo  char(5),
@Mov     char(20) = NULL,
@IDD     int	= NULL,
@IDA     int	= NULL

AS BEGIN
SET NOCOUNT ON
DECLARE
@Cuantos 	int,
@ID 	int
IF @Mov IS NULL
BEGIN
IF @Modulo = 'CONT'  DECLARE crModulo CURSOR FOR SELECT ID FROM Cont         WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'VTAS'  DECLARE crModulo CURSOR FOR SELECT ID FROM Venta        WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'COMS'  DECLARE crModulo CURSOR FOR SELECT ID FROM Compra       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'INV'   DECLARE crModulo CURSOR FOR SELECT ID FROM Inv          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CXC'   DECLARE crModulo CURSOR FOR SELECT ID FROM Cxc          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CXP'   DECLARE crModulo CURSOR FOR SELECT ID FROM Cxp          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'GAS'   DECLARE crModulo CURSOR FOR SELECT ID FROM Gasto        WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'DIN'   DECLARE crModulo CURSOR FOR SELECT ID FROM Dinero       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'EMB'   DECLARE crModulo CURSOR FOR SELECT ID FROM Embarque     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'AF'    DECLARE crModulo CURSOR FOR SELECT ID FROM ActivoFijo   WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'NOM'   DECLARE crModulo CURSOR FOR SELECT ID FROM Nomina       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'RH'    DECLARE crModulo CURSOR FOR SELECT ID FROM RH           WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ASIS'  DECLARE crModulo CURSOR FOR SELECT ID FROM Asiste       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CAP'   DECLARE crModulo CURSOR FOR SELECT ID FROM Capital      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'INC'   DECLARE crModulo CURSOR FOR SELECT ID FROM Incidencia   WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CONC'  DECLARE crModulo CURSOR FOR SELECT ID FROM Conciliacion WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PPTO'  DECLARE crModulo CURSOR FOR SELECT ID FROM Presup       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PC'    DECLARE crModulo CURSOR FOR SELECT ID FROM PC           WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'OFER'  DECLARE crModulo CURSOR FOR SELECT ID FROM Oferta       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CREDI' DECLARE crModulo CURSOR FOR SELECT ID FROM Credito	 WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'TMA'   DECLARE crModulo CURSOR FOR SELECT ID FROM TMA          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'RSS'   DECLARE crModulo CURSOR FOR SELECT ID FROM RSS          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CMP'   DECLARE crModulo CURSOR FOR SELECT ID FROM Campana      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'FIS'   DECLARE crModulo CURSOR FOR SELECT ID FROM Fiscal       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CONTP' DECLARE crModulo CURSOR FOR SELECT ID FROM ContParalela WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'OPORT' DECLARE crModulo CURSOR FOR SELECT ID FROM Oportunidad  WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CORTE' DECLARE crModulo CURSOR FOR SELECT ID FROM Corte        WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ORG'   DECLARE crModulo CURSOR FOR SELECT ID FROM Organiza     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'RE'    DECLARE crModulo CURSOR FOR SELECT ID FROM Recluta      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ISL'   DECLARE crModulo CURSOR FOR SELECT ID FROM ISL		     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'FRM'   DECLARE crModulo CURSOR FOR SELECT ID FROM FormaExtra   WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CAPT'  DECLARE crModulo CURSOR FOR SELECT ID FROM Captura      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'GES'   DECLARE crModulo CURSOR FOR SELECT ID FROM Gestion      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CP'    DECLARE crModulo CURSOR FOR SELECT ID FROM CP           WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PCP'   DECLARE crModulo CURSOR FOR SELECT ID FROM PCP          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CAM'   DECLARE crModulo CURSOR FOR SELECT ID FROM Cambio       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PACTO' DECLARE crModulo CURSOR FOR SELECT ID FROM Contrato     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'SAUX'  DECLARE crModulo CURSOR FOR SELECT ID FROM SAUX         WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'DOC'   DECLARE crModulo CURSOR FOR SELECT ID FROM Doc          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR'
ELSE BEGIN
RAISERROR ('El Modulo No Existe',16,-1)
RETURN
END
END ELSE
BEGIN
IF @Modulo = 'CONT'  DECLARE crModulo CURSOR FOR SELECT ID FROM Cont         WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'VTAS'  DECLARE crModulo CURSOR FOR SELECT ID FROM Venta        WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'COMS'  DECLARE crModulo CURSOR FOR SELECT ID FROM Compra       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'INV'   DECLARE crModulo CURSOR FOR SELECT ID FROM Inv          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CXC'   DECLARE crModulo CURSOR FOR SELECT ID FROM Cxc          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CXP'   DECLARE crModulo CURSOR FOR SELECT ID FROM Cxp          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'GAS'   DECLARE crModulo CURSOR FOR SELECT ID FROM Gasto        WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'DIN'   DECLARE crModulo CURSOR FOR SELECT ID FROM Dinero       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'EMB'   DECLARE crModulo CURSOR FOR SELECT ID FROM Embarque     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'AF'    DECLARE crModulo CURSOR FOR SELECT ID FROM ActivoFijo   WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'NOM'   DECLARE crModulo CURSOR FOR SELECT ID FROM Nomina       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'RH'    DECLARE crModulo CURSOR FOR SELECT ID FROM RH           WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'ASIS'  DECLARE crModulo CURSOR FOR SELECT ID FROM Asiste       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CAP'   DECLARE crModulo CURSOR FOR SELECT ID FROM Capital      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'INC'   DECLARE crModulo CURSOR FOR SELECT ID FROM Incidencia   WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CONC'  DECLARE crModulo CURSOR FOR SELECT ID FROM Conciliacion WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'PPTO'  DECLARE crModulo CURSOR FOR SELECT ID FROM Presup       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'PC'    DECLARE crModulo CURSOR FOR SELECT ID FROM PC           WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'OFER'  DECLARE crModulo CURSOR FOR SELECT ID FROM Oferta       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CREDI' DECLARE crModulo CURSOR FOR SELECT ID FROM Credito	 WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'TMA'   DECLARE crModulo CURSOR FOR SELECT ID FROM TMA          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'RSS'   DECLARE crModulo CURSOR FOR SELECT ID FROM RSS          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CMP'   DECLARE crModulo CURSOR FOR SELECT ID FROM Campana      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'FIS'   DECLARE crModulo CURSOR FOR SELECT ID FROM Fiscal       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CONTP' DECLARE crModulo CURSOR FOR SELECT ID FROM ContParalela WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'OPORT' DECLARE crModulo CURSOR FOR SELECT ID FROM Oportunidad  WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CORTE' DECLARE crModulo CURSOR FOR SELECT ID FROM Corte        WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'ORG'   DECLARE crModulo CURSOR FOR SELECT ID FROM Organiza     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'RE'	 DECLARE crModulo CURSOR FOR SELECT ID FROM Recluta	     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'ISL'   DECLARE crModulo CURSOR FOR SELECT ID FROM ISL		     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'FRM'   DECLARE crModulo CURSOR FOR SELECT ID FROM FormaExtra   WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CAPT'  DECLARE crModulo CURSOR FOR SELECT ID FROM Captura      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'GES'   DECLARE crModulo CURSOR FOR SELECT ID FROM Gestion      WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CP'    DECLARE crModulo CURSOR FOR SELECT ID FROM CP           WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'PCP'   DECLARE crModulo CURSOR FOR SELECT ID FROM PCP          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'CAM'   DECLARE crModulo CURSOR FOR SELECT ID FROM Cambio       WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'PACTO' DECLARE crModulo CURSOR FOR SELECT ID FROM Contrato     WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'SAUX'  DECLARE crModulo CURSOR FOR SELECT ID FROM SAUX         WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov ELSE
IF @Modulo = 'DOC'   DECLARE crModulo CURSOR FOR SELECT ID FROM Doc          WHERE Empresa = @Empresa AND Estatus = 'SINAFECTAR' AND Mov = @Mov
ELSE BEGIN
RAISERROR ('El Modulo No Existe',16,-1)
RETURN
END
END
SELECT @Cuantos = 0
OPEN crModulo
FETCH NEXT FROM crModulo INTO @ID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND (@IDD IS NULL OR @ID >= @IDD) AND (@IDA IS NULL OR @ID <= @IDA)
BEGIN
EXEC spAfectar @Modulo, @ID, NULL, NULL, NULL, @Usuario
SELECT @Cuantos = @Cuantos + 1
END
FETCH NEXT FROM crModulo INTO @ID
END
CLOSE crModulo
DEALLOCATE crModulo
SELECT LTRIM(CONVERT(char, @Cuantos))+' Movimiento(s) Afectado(s).'
RETURN
END

