SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeImporteCobrado
@Empresa	char(5),
@Modulo		char(5),
@ID		int,
@CxcImpuesto	float = NULL,
@TipoTarjeta	bit = 0

AS BEGIN
DECLARE
@ConDesglose	bit,
@ImporteVales	money,
@FormaCobroVales	varchar(50),
@FormaCobroTarjetas varchar(50),
@Importe		money,
@Impuestos		money,
@Importe1		money,
@Importe2		money,
@Importe3		money,
@Importe4		money,
@Importe5		money,
@FormaCobro 	varchar(50),
@FormaCobro1	varchar(50),
@FormaCobro2	varchar(50),
@FormaCobro3	varchar(50),
@FormaCobro4	varchar(50),
@FormaCobro5	varchar(50),
@Referencia		varchar(50),
@Referencia1	varchar(50),
@Referencia2	varchar(50),
@Referencia3	varchar(50),
@Referencia4	varchar(50),
@Referencia5	varchar(50),
@MovTipo		char(10)
SELECT @ImporteVales = NULL, @CxcImpuesto = ISNULL(@CxcImpuesto, 0)
IF @TipoTarjeta = 0
SELECT @ImporteVales = SUM(s.Precio)
FROM ValeSerieMov m, ValeSerie s
WHERE m.Empresa = @Empresa AND m.Modulo = @Modulo AND m.ID = @ID AND m.Serie = s.Serie
ELSE
SELECT @ImporteVales = SUM(m.Importe)
FROM TarjetaSerieMov m, ValeSerie s
WHERE m.Empresa = @Empresa AND m.Modulo = @Modulo AND m.ID = @ID AND m.Serie = s.Serie
IF NULLIF(@ImporteVales, 0) IS NULL RETURN
SELECT @FormaCobroVales = CxcFormaCobroVales, @FormaCobroTarjetas = CxcFormaCobroTarjetas
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Modulo = 'CXC'
BEGIN
SELECT @ConDesglose = ConDesglose,
@Importe  = ISNULL(Importe, 0),  @FormaCobro  = FormaCobro,  @Referencia  = Referencia,
@Importe1 = ISNULL(Importe1, 0), @FormaCobro1 = FormaCobro1, @Referencia1 = Referencia1,
@Importe2 = ISNULL(Importe2, 0), @FormaCobro2 = FormaCobro2, @Referencia2 = Referencia2,
@Importe3 = ISNULL(Importe3, 0), @FormaCobro3 = FormaCobro3, @Referencia3 = Referencia3,
@Importe4 = ISNULL(Importe4, 0), @FormaCobro4 = FormaCobro4, @Referencia4 = Referencia4,
@Importe5 = ISNULL(Importe5, 0), @FormaCobro5 = FormaCobro5, @Referencia5 = Referencia5
FROM Cxc
WHERE ID = @ID
IF @ConDesglose = 0 AND @Importe > 0.0
BEGIN
SELECT @Importe1 = @Importe, @FormaCobro1 = @FormaCobro, @Referencia1 = @Referencia
END
END
IF @Modulo = 'VTAS'
SELECT @Importe1 = ISNULL(Importe1, 0), @FormaCobro1 = FormaCobro1, @Referencia1 = Referencia1,
@Importe2 = ISNULL(Importe2, 0), @FormaCobro2 = FormaCobro2, @Referencia2 = Referencia2,
@Importe3 = ISNULL(Importe3, 0), @FormaCobro3 = FormaCobro3, @Referencia3 = Referencia3,
@Importe4 = ISNULL(Importe4, 0), @FormaCobro4 = FormaCobro4, @Referencia4 = Referencia4,
@Importe5 = ISNULL(Importe5, 0), @FormaCobro5 = FormaCobro5, @Referencia5 = Referencia5
FROM VentaCobro
WHERE ID = @ID
IF @TipoTarjeta = 0
BEGIN
IF @Importe1 = 0.0 OR @FormaCobro1 = @FormaCobroVales SELECT @Importe1 = @ImporteVales, @FormaCobro1 = @FormaCobroVales, @Referencia1 = NULL ELSE
IF @Importe2 = 0.0 OR @FormaCobro2 = @FormaCobroVales SELECT @Importe2 = @ImporteVales, @FormaCobro2 = @FormaCobroVales, @Referencia2 = NULL ELSE
IF @Importe3 = 0.0 OR @FormaCobro3 = @FormaCobroVales SELECT @Importe3 = @ImporteVales, @FormaCobro3 = @FormaCobroVales, @Referencia3 = NULL ELSE
IF @Importe4 = 0.0 OR @FormaCobro4 = @FormaCobroVales SELECT @Importe4 = @ImporteVales, @FormaCobro4 = @FormaCobroVales, @Referencia4 = NULL ELSE
IF @Importe5 = 0.0 OR @FormaCobro5 = @FormaCobroVales SELECT @Importe5 = @ImporteVales, @FormaCobro5 = @FormaCobroVales, @Referencia5 = NULL
END
ELSE
BEGIN
IF @Importe1 = 0.0 OR @FormaCobro1 = @FormaCobroTarjetas SELECT @Importe1 = @ImporteVales, @FormaCobro1 = @FormaCobroTarjetas, @Referencia1 = NULL ELSE
IF @Importe2 = 0.0 OR @FormaCobro2 = @FormaCobroTarjetas SELECT @Importe2 = @ImporteVales, @FormaCobro2 = @FormaCobroTarjetas, @Referencia2 = NULL ELSE
IF @Importe3 = 0.0 OR @FormaCobro3 = @FormaCobroTarjetas SELECT @Importe3 = @ImporteVales, @FormaCobro3 = @FormaCobroTarjetas, @Referencia3 = NULL ELSE
IF @Importe4 = 0.0 OR @FormaCobro4 = @FormaCobroTarjetas SELECT @Importe4 = @ImporteVales, @FormaCobro4 = @FormaCobroTarjetas, @Referencia4 = NULL ELSE
IF @Importe5 = 0.0 OR @FormaCobro5 = @FormaCobroTarjetas SELECT @Importe5 = @ImporteVales, @FormaCobro5 = @FormaCobroTarjetas, @Referencia5 = NULL
END
IF @Modulo = 'CXC'
BEGIN
EXEC spMovInfo @ID, @Modulo, @MovTipo = @MovTipo OUTPUT
SELECT @Importe = @Importe1 + @Importe2 + @Importe3 + @Importe4 + @Importe5
IF @MovTipo <> 'CXC.DC'
BEGIN
SELECT @Impuestos = @Importe * (@CxcImpuesto / 100)
UPDATE Cxc
SET ConDesglose = 1,
Importe  = @Importe-@Impuestos, Impuestos = @Impuestos, FormaCobro = NULL,
Importe1 = NULLIF(@Importe1, 0), FormaCobro1 = @FormaCobro1, Referencia1 = @Referencia1,
Importe2 = NULLIF(@Importe2, 0), FormaCobro2 = @FormaCobro2, Referencia2 = @Referencia2,
Importe3 = NULLIF(@Importe3, 0), FormaCobro3 = @FormaCobro3, Referencia3 = @Referencia3,
Importe4 = NULLIF(@Importe4, 0), FormaCobro4 = @FormaCobro4, Referencia4 = @Referencia4,
Importe5 = NULLIF(@Importe5, 0), FormaCobro5 = @FormaCobro5, Referencia5 = @Referencia5
WHERE ID = @ID
END
ELSE
BEGIN
UPDATE Cxc SET ConDesglose = 0, Importe  = @Importe, Impuestos = NULL, FormaCobro = @FormaCobroTarjetas
WHERE ID = @ID
END
END
IF @Modulo = 'VTAS'
UPDATE VentaCobro
SET Importe1 = NULLIF(@Importe1, 0), FormaCobro1 = @FormaCobro1, Referencia1 = @Referencia1,
Importe2 = NULLIF(@Importe2, 0), FormaCobro2 = @FormaCobro2, Referencia2 = @Referencia2,
Importe3 = NULLIF(@Importe3, 0), FormaCobro3 = @FormaCobro3, Referencia3 = @Referencia3,
Importe4 = NULLIF(@Importe4, 0), FormaCobro4 = @FormaCobro4, Referencia4 = @Referencia4,
Importe5 = NULLIF(@Importe5, 0), FormaCobro5 = @FormaCobro5, Referencia5 = @Referencia5
WHERE ID = @ID
END

