SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpSDIFijo
@Empresa   		char(5),
@Sucursal  		int,
@Categoria 		varchar(50),
@Puesto			varchar(50),
@Personal		char(10),
@SueldoDiario  	money,
@SDI     		money		= NULL	OUTPUT
AS BEGIN
DECLARE
@AyudaTransportePct	   float
SELECT @AyudaTransportePct = 0.0
EXEC spPersonalPropValorFloat @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, '% Ayuda Transporte', @AyudaTransportePct OUTPUT, @SinError = 1
SELECT @SDI = @SDI + (@SueldoDiario * (@AyudaTransportePct/100.0))
RETURN
END

