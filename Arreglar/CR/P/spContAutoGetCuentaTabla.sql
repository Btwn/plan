SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoGetCuentaTabla
@Modulo			char(5),
@Clave			varchar(20),
@Nombre			varchar(50),
@Monto			float,
@Importe		float,
@Cta			char(20)	OUTPUT,
@Excento		bit		= 0,
@ContAutoEmpresa	varchar(10)	= '(Todas)'

AS BEGIN
DECLARE
@Porcentaje	money,
@Tolerancia	float
SELECT @Tolerancia = 0.02
SELECT @Porcentaje = ROUND((@Monto * 100.0) / CONVERT(float, NULLIF(@Importe, 0)), 2)
SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje BETWEEN @Porcentaje - @Tolerancia AND @Porcentaje + @Tolerancia AND Excento = @Excento
RETURN
END

