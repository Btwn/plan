SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnBuscadatosdinero (
@Mov     varchar(25),
@MovId   varchar(25),
@Empresa varchar(5),
@Filtro  int,
@CtaDinero varchar(10)
)
RETURNS varchar(100)
AS BEGIN
DECLARE
@Resultado	        varchar(20),
@Fecha              datetime,
@FechaConciliacion  datetime,
@FechaConclusion    datetime,
@TipoCambio			float,
@Ejercicio			int,
@Periodo			int
IF(@Filtro NOT IN (1,2,3,4,5,6))
BEGIN
SET @Resultado = ''
END
IF(@Filtro = 1)
BEGIN
SELECT @Fecha = FECHAEMISION
FROM DINERO D
JOIN MovTipo MT ON MT.Mov = D.Mov AND mt.Modulo = 'DIN'
JOIN MFAIrTesoreria T ON T.Movimiento = MT.Mov AND T.Clave = MT.Clave
WHERE D.MOV   = @Mov
AND D.MOVID = @MovId
AND D.Empresa = @Empresa
AND D.CtaDinero = @CtaDinero
SET @Resultado = CONVERT(VARCHAR(25),@Fecha)
END
IF(@Filtro = 2)
BEGIN
SELECT @TipoCambio = TipoCambio
FROM DINERO D
JOIN MovTipo MT ON MT.Mov = D.Mov AND mt.Modulo = 'DIN'
JOIN MFAIrTesoreria T ON T.Movimiento = MT.Mov AND T.Clave = MT.Clave
WHERE D.MOV   = @Mov
AND D.MOVID = @MovId
AND D.Empresa = @Empresa
AND D.CtaDinero = @CtaDinero
SET @Resultado = @TipoCambio
END
IF(@Filtro = 3)
BEGIN
SELECT @Ejercicio = Ejercicio
FROM DINERO D
JOIN MovTipo MT ON MT.Mov = D.Mov AND mt.Modulo = 'DIN'
JOIN MFAIrTesoreria T ON T.Movimiento = MT.Mov AND T.Clave = MT.Clave
WHERE D.MOV   = @Mov
AND D.MOVID = @MovId
AND D.Empresa = @Empresa
AND D.CtaDinero = @CtaDinero
SET @Resultado = @Ejercicio
END
IF(@Filtro = 4)
BEGIN
SELECT @Periodo = Periodo
FROM DINERO D
JOIN MovTipo MT ON MT.Mov = D.Mov AND mt.Modulo = 'DIN'
JOIN MFAIrTesoreria T ON T.Movimiento = MT.Mov AND T.Clave = MT.Clave
WHERE D.MOV   = @Mov
AND D.MOVID = @MovId
AND D.Empresa = @Empresa
AND D.CtaDinero = @CtaDinero
SET @Resultado = @Periodo
END
IF(@Filtro = 5)
BEGIN
SELECT @FechaConciliacion = FechaConciliacion
FROM DINERO D
JOIN MovTipo MT ON MT.Mov = D.Mov AND mt.Modulo = 'DIN'
JOIN MFAIrTesoreria T ON T.Movimiento = MT.Mov AND T.Clave = MT.Clave
WHERE D.MOV   = @Mov
AND D.MOVID = @MovId
AND D.Empresa = @Empresa
AND D.CtaDinero = @CtaDinero
SET @Resultado = CONVERT(VARCHAR(25),@FechaConciliacion)
END
IF(@Filtro = 6)
BEGIN
SELECT @FechaConclusion = FechaConclusion
FROM DINERO D
JOIN MovTipo MT ON MT.Mov = D.Mov AND mt.Modulo = 'DIN'
JOIN MFAIrTesoreria T ON T.Movimiento = MT.Mov AND T.Clave = MT.Clave
WHERE D.MOV   = @Mov
AND D.MOVID = @MovId
AND D.Empresa = @Empresa
AND D.CtaDinero = @CtaDinero
SET @Resultado = CONVERT(VARCHAR(25),@FechaConclusion)
END
IF(ISNULL(@Resultado,'') = '')
SET @Resultado = ''
RETURN (@Resultado)
END

