SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPImportarPresupuesto
@Estacion		int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok					int,
@OkRef				varchar(255),
@Proyecto			varchar(50),
@Name				varchar(255),
@Columna			int,
@SQL				nvarchar(255),
@Periodo			varchar(255),
@Clave				varchar(50),
@Descripcion		varchar(250),
@Orden				int,
@EjercicioNumero	int,
@PeriodoNumero		int,
@Importe			money,
@LongitudClave		int,
@Fecha				datetime,
@Concepto			varchar(50),
@Moneda				varchar(10),
@TipoCambio			float,
@Mov				varchar(20),
@IDGenerar			int,
@Renglon			float,
@ClavePresupuestal	varchar(50)
SET @Fecha = dbo.fnFechaSinHora(GETDATE())
SET @Transaccion = 'spCPImportarPresupuesto' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
DECLARE @TablaPeriodo TABLE
(
Columna				int,
Nombre				varchar(50),
Ejercicio				int,
Periodo				int
)
DECLARE @TablaClavePresupuestal TABLE
(
ClavePresupuestal				varchar(50),
Descripcion					varchar(255)
)
DECLARE @TablaPresupuesto TABLE
(
ClavePresupuestal				varchar(50),
Ejercicio						int,
Periodo						int,
Importe						money
)
BEGIN TRANSACTION @Transaccion
SELECT @Mov = cpAnteproyecto FROM EmpresaCfgMovCP WHERE Empresa = @Empresa
SELECT @Proyecto = C2 FROM TempCPImportarPresupuesto WHERE CONVERT(int,Orden) = 1
SELECT @LongitudClave = C2 FROM TempCPImportarPresupuesto WHERE CONVERT(int,Orden) = 2
SELECT @Concepto = C2 FROM TempCPImportarPresupuesto WHERE CONVERT(int,Orden) = 3
SELECT @Moneda = C2 FROM TempCPImportarPresupuesto WHERE CONVERT(int,Orden) = 4
SELECT @TipoCambio = CONVERT(float,C2) FROM TempCPImportarPresupuesto WHERE CONVERT(int,Orden) = 5
SET @Columna = 1
DECLARE crColumnas CURSOR FOR
SELECT Name
FROM SysColumns
WHERE ID = OBJECT_ID('TempCPImportarPresupuesto')
AND Name NOT IN ('Orden','C1','C2', 'RID', 'EstacionTrabajo')
OPEN crColumnas
FETCH NEXT FROM crColumnas INTO @Name
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @SQL = 'SELECT @Periodo = ' + @Name + ' FROM TempCPImportarPresupuesto WHERE Orden = 6'
EXEC sp_executesql @SQL, N'@Periodo varchar(255) OUTPUT', @Periodo = @Periodo OUTPUT
INSERT @TablaPeriodo (Columna, Nombre, Ejercicio, Periodo) VALUES (@Columna, @Name, SUBSTRING(@Periodo, CHARINDEX('-',@Periodo)+1,4),SUBSTRING(@Periodo,1,CHARINDEX('-',@Periodo)-1))
SET @Columna = @Columna + 1
FETCH NEXT FROM crColumnas INTO @Name
END
CLOSE crColumnas
DEALLOCATE crColumnas
DECLARE crClave CURSOR FOR
SELECT CONVERT(int,Orden), C1, C2
FROM TempCPImportarPresupuesto
WHERE Orden NOT IN ('1','2','3','4','5', '6')
ORDER BY CONVERT(int,Orden)
OPEN crClave
FETCH NEXT FROM crClave INTO @Orden, @Clave, @Descripcion
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM @TablaClavePresupuestal WHERE ClavePresupuestal = @Clave)
INSERT @TablaClavePresupuestal (ClavePresupuestal, Descripcion) VALUES (@Clave, @Descripcion)
DECLARE crImporte CURSOR FOR
SELECT Nombre, Ejercicio, Periodo
FROM @TablaPeriodo
OPEN crImporte
FETCH NEXT FROM crImporte INTO @Name, @EjercicioNumero, @PeriodoNumero
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @SQL = 'SELECT @Importe = ' + @Name + ' FROM TempCPImportarPresupuesto WHERE C1 = ' + CHAR(39) + @Clave + CHAR(39) + ' '
EXEC sp_executesql @SQL, N'@Importe money OUTPUT', @Importe = @Importe OUTPUT
INSERT @TablaPresupuesto (ClavePresupuestal, Ejercicio, Periodo, Importe) VALUES (@Clave, @EjercicioNumero, @PeriodoNumero, @Importe)
FETCH NEXT FROM crImporte INTO @Name, @EjercicioNumero, @PeriodoNumero
END
CLOSE crImporte
DEALLOCATE crImporte
FETCH NEXT FROM crClave INTO @Orden, @Clave, @Descripcion
END
CLOSE crClave
DEALLOCATE crClave
DELETE TempCPImportarPresupuesto WHERE EstacionTrabajo = @Estacion
SET @Clave = NULL
SELECT TOP 1 @Clave = tp.ClavePresupuestal
FROM @TablaPresupuesto tp
WHERE LEN(tp.ClavePresupuestal) < @LongitudClave
AND Importe < (SELECT ISNULL(SUM(ISNULL(Importe,0.0)),0.0) FROM @TablaPresupuesto WHERE PATINDEX(tp.ClavePresupuestal + '%', ClavePresupuestal) > 0 AND LEN(ClavePresupuestal) = @LongitudClave AND PATINDEX(tp.ClavePresupuestal + '%', ClavePresupuestal) > 0 AND Ejercicio = tp.Ejercicio AND Periodo = tp.Periodo)
ORDER BY ClavePresupuestal DESC
IF @Clave IS NOT NULL AND @Ok IS NULL SELECT @Ok = 25530, @OkRef = @Clave
IF @Ok IS NULL
BEGIN
INSERT ClavePresupuestal (ClavePresupuestal,     Nombre,          Descripcion,     Estatus, Alta)
SELECT  cpt.ClavePresupuestal, cpt.Descripcion, cpt.Descripcion, 'ALTA',  @Fecha
FROM @TablaClavePresupuestal cpt LEFT OUTER JOIN ClavePresupuestal cp
ON cp.ClavePresupuestal = cpt.ClavePresupuestal
WHERE LEN(cpt.ClavePresupuestal) = @LongitudClave
AND cp.ClavePresupuestal IS NULL
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'ClavePresupuestal'
END
IF @Ok IS NULL
BEGIN
INSERT CP (Empresa,  Sucursal,  Mov,  FechaEmision, Proyecto,  Usuario,  Estatus,      Moneda,  TipoCambio,  Concepto)
VALUES (@Empresa, @Sucursal, @Mov, @Fecha,       @Proyecto, @Usuario, 'SINAFECTAR', @Moneda, @TipoCambio, @Concepto)
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'CP'
SET @IDGenerar = @@IDENTITY
END
IF @Ok IS NULL
BEGIN
SET @Renglon = 2048.0
DECLARE crCPD CURSOR FOR
SELECT ClavePresupuestal, ISNULL(SUM(ISNULL(Importe,0.0)),0.0)
FROM @TablaPresupuesto
WHERE LEN(ClavePresupuestal) = @LongitudClave
GROUP BY ClavePresupuestal
OPEN crCPD
FETCH NEXT FROM crCPD INTO @ClavePresupuestal, @Importe
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT CPD (ID,         Renglon,  ClavePresupuestal,  Tipo,         Importe)
VALUES (@IDGenerar, @Renglon, @ClavePresupuestal, 'Ampliacion', @Importe)
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'CPD'
DECLARE crCPCal CURSOR FOR
SELECT Importe, Periodo, Ejercicio
FROM @TablaPresupuesto
WHERE ClavePresupuestal = @ClavePresupuestal
OPEN crCPCal
FETCH NEXT FROM crCPCal INTO @Importe, @PeriodoNumero, @EjercicioNumero
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT CPCal (ID,         ClavePresupuestal,  Tipo,         Ejercicio,        Periodo,        Importe,  EnMov, Sucursal,  SucursalOrigen)
VALUES (@IDGenerar, @ClavePresupuestal, 'Ampliacion', @EjercicioNumero, @PeriodoNumero, @Importe, 1,     @Sucursal, @Sucursal)
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'CPCal'
FETCH NEXT FROM crCPCal INTO @Importe, @PeriodoNumero, @EjercicioNumero
END
CLOSE crCPCal
DEALLOCATE crCPCal
SET @Renglon = @Renglon + 2048.0
FETCH NEXT FROM crCPD INTO @ClavePresupuestal, @Importe
END
CLOSE crCPD
DEALLOCATE crCPD
END
IF @Ok IS NULL
EXEC spAfectar 'CP', @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, @Fecha, 1, @Estacion
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT dbo.fnIdiomaTraducir(@Usuario,'Proceso Concluido')
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT dbo.fnIdiomaTraducir(@Usuario,'ERROR: ') + CONVERT(varchar,@Ok) + '. ' + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

