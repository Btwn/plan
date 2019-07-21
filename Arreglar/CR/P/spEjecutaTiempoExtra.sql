SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spEjecutaTiempoExtra
@rID		int,
@Empresa	varchar(5),
@Sucursal  int,
@Estacion  int,
@Usuario	varchar(10)

AS BEGIN
DECLARE		@ID          int,
@Personal	 varchar(10),
@Semana1Dia1 varchar(5),
@Semana1Dia2 varchar(5),
@Semana1Dia3 varchar(5),
@Semana1Dia4 varchar(5),
@Semana1Dia5 varchar(5),
@Semana1Dia6 varchar(5),
@Semana1Dia7 varchar(5),
@Semana2Dia1 varchar(5),
@Semana2Dia2 varchar(5),
@Semana2Dia3 varchar(5),
@Semana2Dia4 varchar(5),
@Semana2Dia5 varchar(5),
@Semana2Dia6 varchar(5),
@Semana2Dia7 varchar(5),
@Horas       varchar(5),
@Moneda      varchar(20),
@TipoCambio  float,
@Cantidad    money,
@Renglon     float,
@SQL1		 varchar(8000),
@SQL2		 varchar(8000),
@SQLInsert1	 varchar(4000),
@SQLInsert2	 varchar(4000),
@SQLD1		 varchar(8000),
@SQLD2		 varchar(8000),
@SQLD3       varchar(8000),
@HorasCompletas bit,
@RegEncabezado  int,
@IDNomina		int,
@DiaHE			varchar(10),
@Semana1     varchar(17),
@Semana2     varchar(17),
@Dia1        varchar(4),
@Dia2		 varchar(4),
@Dia3        varchar(4),
@Dia4        varchar(4),
@Dia5        varchar(4),
@Dia6        varchar(4),
@Dia7        varchar(4),
@Modulo      varchar(20),
@Mov         varchar(20),
@MovID       varchar(20),
@DMovID      varchar(20),
@Ok			 int
SELECT @Semana1 = 'Horas Extras Sem1',
@Semana2 = 'Horas Extras Sem2',
@Dia1    = 'Dia1',
@Dia2    = 'Dia2',
@Dia3    = 'Dia3',
@Dia4    = 'Dia4',
@Dia5    = 'Dia5',
@Dia6    = 'Dia6',
@Dia7    = 'Dia7'
SELECT @Mov    = ISNULL(A.Mov,''),
@MovID  = ISNULL(A.MovID,''),
@Modulo = ISNULL(MT.Modulo,'')
FROM Asiste A
LEFT JOIN MovTipo MT ON MT.Mov = A.Mov
WHERE A.ID = @rID
AND A.Empresa = @Empresa
AND RTRIM(LTRIM(A.Estatus)) = 'CONCLUIDO'
AND MT.Clave = 'ASIS.C'
AND MT.Modulo = 'ASIS'
SELECT @HorasCompletas = HorasExtrasCompletas
FROM EMPRESACFG
WHERE EMPRESA = @Empresa
SELECT @RegEncabezado = 0
SELECT @Renglon = 0.0
SELECT @SQLInsert1 = 'INSERT INTO Nomina (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, Sucursal, SucursalOrigen, UEN, FechaOrigen, NOI)'
SELECT @SQLInsert2 = 'INSERT INTO NominaD (ID, Renglon, Modulo, Plaza, Personal, Importe, Cuenta, FormaPago, Horas, Cantidad, Porcentaje, Monto, FechaD, FechaA, Movimiento, Saldo, Concepto, Referencia, CantidadPendiente, Activo, Sucursal, SucursalOrigen, Beneficiario, ContUso, CuentaContable, UEN, ObligacionFiscal, ClavePresupuestal)'
/******************************************************************************************************************************************/
SET LANGUAGE ESPAÑOL
/******************************************************************************************************************************************/
DECLARE crHES1D1 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia1,
CONVERT(varchar(10),FechaD,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia1 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D1
FETCH NEXT FROM crHES1D1 INTO @ID, @Personal, @Semana1Dia1, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia1),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia1)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia1+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D1 INTO @ID, @Personal, @Semana1Dia1, @DiaHE
END
CLOSE crHES1D1
DEALLOCATE crHES1D1
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES1D2 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia2,
CONVERT(varchar(10),FechaD+1,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia2 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D2
FETCH NEXT FROM crHES1D2 INTO @ID, @Personal, @Semana1Dia2, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia2),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia2)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia2+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D2 INTO @ID, @Personal, @Semana1Dia2, @DiaHE
END
CLOSE crHES1D2
DEALLOCATE crHES1D2
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES1D3 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia3,
CONVERT(varchar(10),FechaD+2,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia3 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D3
FETCH NEXT FROM crHES1D3 INTO @ID, @Personal, @Semana1Dia3, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia3),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia3)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia3+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D3 INTO @ID, @Personal, @Semana1Dia3, @DiaHE
END
CLOSE crHES1D3
DEALLOCATE crHES1D3
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES1D4 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia4,
CONVERT(varchar(10),FechaD+3,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia4 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D4
FETCH NEXT FROM crHES1D4 INTO @ID, @Personal, @Semana1Dia4, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia4),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia4)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia4+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D4 INTO @ID, @Personal, @Semana1Dia4, @DiaHE
END
CLOSE crHES1D4
DEALLOCATE crHES1D4
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES1D5 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia5,
CONVERT(varchar(10),FechaD+4,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia5 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D5
FETCH NEXT FROM crHES1D5 INTO @ID, @Personal, @Semana1Dia5, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia5),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia5)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia5+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D5 INTO @ID, @Personal, @Semana1Dia5, @DiaHE
END
CLOSE crHES1D5
DEALLOCATE crHES1D5
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES1D6 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia6,
CONVERT(varchar(10),FechaD+5,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia6 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D6
FETCH NEXT FROM crHES1D6 INTO @ID, @Personal, @Semana1Dia6, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia6),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia6)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia6+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D6 INTO @ID, @Personal, @Semana1Dia6, @DiaHE
END
CLOSE crHES1D6
DEALLOCATE crHES1D6
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES1D7 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana1Dia7,
CONVERT(varchar(10),FechaD+6,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana1Dia7 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES1D7
FETCH NEXT FROM crHES1D7 INTO @ID, @Personal, @Semana1Dia7, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana1Dia7),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana1Dia7)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana1+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia7+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES1D7 INTO @ID, @Personal, @Semana1Dia7, @DiaHE
END
CLOSE crHES1D7
DEALLOCATE crHES1D7
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D1 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia1,
CONVERT(varchar(10),FechaD+7,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia1 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D1
FETCH NEXT FROM crHES2D1 INTO @ID, @Personal, @Semana2Dia1, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia1),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia1)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia1+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D1 INTO @ID, @Personal, @Semana2Dia1, @DiaHE
END
CLOSE crHES2D1
DEALLOCATE crHES2D1
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D2 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia2,
CONVERT(varchar(10),FechaD+8,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia2 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D2
FETCH NEXT FROM crHES2D2 INTO @ID, @Personal, @Semana2Dia2, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia2),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia2)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia2+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D2 INTO @ID, @Personal, @Semana2Dia2, @DiaHE
END
CLOSE crHES2D2
DEALLOCATE crHES2D2
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D3 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia3,
CONVERT(varchar(10),FechaD+9,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia3 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D3
FETCH NEXT FROM crHES2D3 INTO @ID, @Personal, @Semana2Dia3, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia3),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia3)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia3+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D3 INTO @ID, @Personal, @Semana2Dia3, @DiaHE
END
CLOSE crHES2D3
DEALLOCATE crHES2D3
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D4 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia4,
CONVERT(varchar(10),FechaD+10,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia4 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D4
FETCH NEXT FROM crHES2D4 INTO @ID, @Personal, @Semana2Dia4, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia4),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia4)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia4+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D4 INTO @ID, @Personal, @Semana2Dia4, @DiaHE
END
CLOSE crHES2D4
DEALLOCATE crHES2D4
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D5 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia5,
CONVERT(varchar(10),FechaD+11,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia5 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D5
FETCH NEXT FROM crHES2D5 INTO @ID, @Personal, @Semana2Dia5, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia5),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia5)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia5+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D5 INTO @ID, @Personal, @Semana2Dia5, @DiaHE
END
CLOSE crHES2D5
DEALLOCATE crHES2D5
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D6 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia6,
CONVERT(varchar(10),FechaD+12,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia6 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D6
FETCH NEXT FROM crHES2D6 INTO @ID, @Personal, @Semana2Dia6, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia6),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia6)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia6+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D6 INTO @ID, @Personal, @Semana2Dia6, @DiaHE
END
CLOSE crHES2D6
DEALLOCATE crHES2D6
/******************************************************************************************************************************************/
SELECT @RegEncabezado = 0
/******************************************************************************************************************************************/
DECLARE crHES2D7 CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID,
Personal,
Semana2Dia7,
CONVERT(varchar(10),FechaD+13,103)
FROM AuxAsistenciaHE
WHERE Generar = 1
AND Semana2Dia7 >= CASE WHEN @HorasCompletas = 1 THEN 60 ELSE 1 END
AND ID = @rID
OPEN crHES2D7
FETCH NEXT FROM crHES2D7 INTO @ID, @Personal, @Semana2Dia7, @DiaHE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = @RegEncabezado + 1
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @Personal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float,@ID)
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Semana2Dia7),'00:00'))
SELECT @Cantidad = CONVERT(MONEY, CONVERT(INT,@Semana2Dia7)/60.00)
IF EXISTS (SELECT HorasExtrasCompletas FROM EMPRESACFG WHERE EMPRESA = @Empresa AND HorasExtrasCompletas = 1)
BEGIN
SELECT @Cantidad = FLOOR(@Cantidad/1.0) 
SELECT @Horas = CONVERT(TIME,DATEADD(HOUR,CONVERT(INT,@Cantidad),'00:00')) 
END
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
SELECT @SQL1 = @SQLInsert1
SELECT @SQLD1 = ' VALUES('+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+@Semana2+CHAR(39)+', NULL, GETDATE(), GETDATE(), '+CHAR(39)+@Dia7+CHAR(39)+', NULL, '
SELECT @SQLD1 = @SQLD1+CHAR(39)+@Moneda+CHAR(39)+','+CHAR(39)+CAST(@TipoCambio AS VARCHAR(10))+CHAR(39)+','+CHAR(39)+@Usuario+CHAR(39)
SELECT @SQLD1 = @SQLD1+', NULL, NULL, NULL, '+CHAR(39)+'SINAFECTAR'+CHAR(39)+', NULL, NULL, NULL, NULL,'+CHAR(39)+@Modulo+CHAR(39)+','+CHAR(39)+@Mov+CHAR(39)+','+CHAR(39)+@MovID+CHAR(39)+',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0)'
SELECT @SQL1 = @SQLInsert1+@SQLD1
EXEC(@SQL1)
SET @IDNomina = @@IDENTITY
END
SELECT @SQL2 = @SQLInsert2
SELECT @SQLD2 = @SQL2+' VALUES('+CONVERT(VARCHAR(5000),@IDNomina)+','+CONVERT(VARCHAR(5000),@Renglon)+','+CHAR(39)+'NOM'+CHAR(39)+','+'NULL,'+CHAR(39)+@Personal+CHAR(39)+','+'NULL, NULL, NULL,'+CHAR(39)+@Horas+CHAR(39)+','+CONVERT(VARCHAR(5000),@Cantidad)+',NULL, NULL,'+CHAR(39)+@DiaHE+CHAR(39)+', NULL, NULL, NULL, NULL, NULL, NULL, 1,'+CONVERT(VARCHAR(5000),@Sucursal)+','+CONVERT(VARCHAR(5000),@Sucursal)+', NULL, NULL, NULL, NULL, NULL, NULL)'
EXEC(@SQLD2)
EXEC spAfectar 'NOM', @IDNomina, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1
UPDATE Nomina SET Estatus = 'PROCESAR' WHERE ID = @IDNomina
SELECT @DMovID = MovID FROM NOMINA WHERE ID = @IDNomina
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @rID, @Mov, @MovID, 'NOM', @IDNomina, @Semana1, @DMovID, @OK OUTPUT
END
FETCH NEXT FROM crHES2D7 INTO @ID, @Personal, @Semana2Dia7, @DiaHE
END
CLOSE crHES2D7
DEALLOCATE crHES2D7
UPDATE AuxAsistenciaHE SET ESTATUS = 'CONCLUIDO' WHERE ID = @ID
SELECT 'Proceso concluido.'
END

