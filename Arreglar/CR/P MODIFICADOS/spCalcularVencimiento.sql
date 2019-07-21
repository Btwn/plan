SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalcularVencimiento
@Modulo		char(5),
@Empresa		char(5),
@Contacto		char(10),
@Condicion		varchar(50),
@FechaEmision	datetime,
@Vencimiento	datetime        OUTPUT,
@Dias		int		OUTPUT,
@Ok 		int		OUTPUT

AS BEGIN
DECLARE
@DiasAgregados	 int,
@DiaSemana		 int,
@TipoDias		 char(10),
@DiasHabiles 	 char(10),
@PorMeses		 bit,
@Meses		 int,
@PorSemanas		 bit,
@Semanas		 int,
@RecorrerVencimiento varchar(20),
@Corte		 bit,
@CorteDia		 int,
@CfgRecorrerVenceRevisionPago bit,
@DiaRevision1	 varchar(10),
@DiaRevision2	 varchar(10),
@DiaPago1		 varchar(10),
@DiaPago2		 varchar(10),
@FechaRevision1	 datetime,
@FechaRevision2	 datetime,
@FechaPago1	 	 datetime,
@FechaPago2	 	 datetime
SELECT @Dias = 0, @RecorrerVencimiento = 'NO', @CfgRecorrerVenceRevisionPago = 0, @DiaRevision1 = NULL, @DiaRevision2 = NULL, @DiaPago1 = NULL, @DiaPago2 = NULL
IF UPPER(@Condicion) = '(FECHA)'
BEGIN
IF @Vencimiento IS NULL SELECT @Vencimiento = @FechaEmision
EXEC spExtraerFecha @Vencimiento OUTPUT
END ELSE BEGIN
IF @Modulo IN ('CXC', 'VTAS')
BEGIN
SELECT @CfgRecorrerVenceRevisionPago = ISNULL(CxcRecorrerVenceRevisionPago, 0)
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @RecorrerVencimiento = ISNULL(RTRIM(UPPER(RecorrerVencimiento)), 'NO'),
@DiaRevision1 = NULLIF(RTRIM(DiaRevision1), ''),
@DiaRevision2 = NULLIF(RTRIM(DiaRevision2), ''),
@DiaPago1 = NULLIF(RTRIM(DiaPago1), ''),
@DiaPago2 = NULLIF(RTRIM(DiaPago2), '')
FROM Cte WITH (NOLOCK)
WHERE Cliente = @Contacto
IF @DiaRevision1 IS NULL SELECT @DiaRevision1 = @DiaRevision2
IF UPPER(@RecorrerVencimiento) = '(EMPRESA)'
SELECT @RecorrerVencimiento = ISNULL(RTRIM(UPPER(CxcRecorrerVencimiento)), 'NO')
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
END ELSE
IF @Modulo IN ('CXP', 'COMS', 'GAS')
SELECT @RecorrerVencimiento = ISNULL(RTRIM(UPPER(CxpRecorrerVencimiento)), 'NO')
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @CfgRecorrerVenceRevisionPago = 1 AND @DiaRevision1 IS NOT NULL
BEGIN
SELECT @FechaRevision1 = @FechaEmision
EXEC spRecorrerVencimiento @DiaRevision1, @FechaRevision1 OUTPUT
IF @DiaRevision2 IS NULL
SELECT @FechaRevision2 = @FechaRevision1
ELSE BEGIN
SELECT @FechaRevision2 = @FechaEmision
EXEC spRecorrerVencimiento @DiaRevision2, @FechaRevision2 OUTPUT
END
IF @FechaRevision2 < @FechaRevision1
SELECT @FechaEmision = @FechaRevision2
ELSE
SELECT @FechaEmision = @FechaRevision1
END
SELECT @Vencimiento = @FechaEmision
SELECT @Condicion = NULLIF(RTRIM(@Condicion), '')
IF @Condicion IS NOT NULL
BEGIN
SELECT @Dias                = ISNULL(DiasVencimiento, 0),
@TipoDias            = ISNULL(RTRIM(UPPER(TipoDias)), 'HABILES'),
@DiasHabiles         = ISNULL(RTRIM(UPPER(DiasHabiles)), 'LUN-VIE'),
@PorMeses            = ISNULL(PorMeses, 0),
@Meses	          = ISNULL(Meses, 0),
@PorSemanas          = ISNULL(PorSemanas, 0),
@Semanas	          = ISNULL(Semanas, 0),
@Corte		  = Corte,
@CorteDia		  = ISNULL(CorteDia, 0)
FROM Condicion WITH (NOLOCK)
WHERE Condicion = @Condicion
IF @Corte = 1 AND @CorteDia IS NOT NULL
EXEC spCalcularVencimientoCorte @CorteDia, @FechaEmision OUTPUT
IF @PorMeses = 1
SELECT @Vencimiento = DATEADD(month, @Meses, @FechaEmision)
ELSE
IF @PorSemanas = 1
SELECT @Vencimiento = DATEADD(week, @Semanas, @FechaEmision)
ELSE
IF @Dias > 0
BEGIN
IF @TipoDias = 'HABILES'
EXEC spCalcularDiasHabiles @FechaEmision, @Dias, @DiasHabiles, 1, @Vencimiento OUTPUT
ELSE
SELECT @Vencimiento = DATEADD(day, @Dias, @FechaEmision)
END
IF @RecorrerVencimiento <> 'NO' AND @Vencimiento <> @FechaEmision
EXEC spRecorrerVencimiento @RecorrerVencimiento, @Vencimiento OUTPUT
END
IF @CfgRecorrerVenceRevisionPago = 1 AND @DiaPago1 IS NOT NULL AND @Dias > 0
BEGIN
SELECT @FechaPago1 = @Vencimiento
EXEC spRecorrerVencimiento @DiaPago1, @FechaPago1 OUTPUT
IF @DiaPago2 IS NULL
SELECT @FechaPago2 = @FechaPago1
ELSE BEGIN
SELECT @FechaPago2 = @Vencimiento
EXEC spRecorrerVencimiento @DiaPago2, @FechaPago2 OUTPUT
END
IF @FechaPago2 < @FechaPago1
SELECT @Vencimiento = @FechaPago2
ELSE
SELECT @Vencimiento = @FechaPago1
END
END
RETURN
END

