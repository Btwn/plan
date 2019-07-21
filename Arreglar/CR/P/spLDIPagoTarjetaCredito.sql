SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIPagoTarjetaCredito
@ID        		int,
@Empresa             varchar(5),
@Sucursal            int,
@Modulo		varchar(5),
@Usuario             varchar(10),
@FormaCobro1         varchar(50),
@FormaCobro2         varchar(50),
@FormaCobro3         varchar(50),
@FormaCobro4         varchar(50),
@FormaCobro5         varchar(50),
@FormaCobroTarjetas  varchar(50),
@Importe1            float,
@Importe2            float,
@Importe3            float,
@Importe4            float,
@Importe5            float,
@Referencia1         varchar(50),
@Referencia2         varchar(50),
@Referencia3         varchar(50),
@Referencia4         varchar(50),
@Referencia5         varchar(50),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@Accion              varchar(20),
@Estatus             varchar(20),
@Estacion            int

AS BEGIN
DECLARE
@LDIServicio         varchar(20),
@EstacionFija        int
SELECT @EstacionFija = EstacionFija FROM LDIEstacionTemp WHERE Estacion = @Estacion
IF EXISTS(SELECT * FROM FormaPago WHERE FormaPago = @FormaCobro1 AND ISNULL(LDI,0) = 1 AND FormaPago NOT IN(@FormaCobroTarjetas) AND NULLIF(LDIServicio,'') IS NOT NULL) AND @Ok IS NULL
BEGIN
SELECT @LDIServicio = LDIServicio FROM FormaPago WHERE FormaPago = @FormaCobro1   AND ISNULL(LDI,0) = 1
EXEC spLDI @LDIServicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe1, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = @Referencia1 , @RIDCobro = NULL, @ADO = 0, @Accion = @Accion, @Estatus = @Estatus, @Estacion = @Estacion, @EstacionFija = @EstacionFija
END
IF EXISTS(SELECT * FROM FormaPago WHERE FormaPago = @FormaCobro2 AND ISNULL(LDI,0) = 1 AND FormaPago NOT IN(@FormaCobroTarjetas)AND NULLIF(LDIServicio,'') IS NOT NULL)  AND @Ok IS NULL
BEGIN
SELECT @LDIServicio = LDIServicio FROM FormaPago WHERE FormaPago = @FormaCobro2  AND ISNULL(LDI,0) = 1
EXEC spLDI @LDIServicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe2, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = @Referencia2 , @RIDCobro = NULL, @ADO = 0, @Accion = @Accion, @Estatus = @Estatus, @Estacion = @Estacion, @EstacionFija = @EstacionFija
END
IF EXISTS(SELECT * FROM FormaPago WHERE FormaPago = @FormaCobro3 AND ISNULL(LDI,0) = 1 AND FormaPago NOT IN(@FormaCobroTarjetas)AND NULLIF(LDIServicio,'') IS NOT NULL)  AND @Ok IS NULL
BEGIN
SELECT @LDIServicio = LDIServicio FROM FormaPago WHERE FormaPago = @FormaCobro3  AND ISNULL(LDI,0) = 1
EXEC spLDI @LDIServicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe3, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = @Referencia3, @RIDCobro = NULL, @ADO = 0, @Accion = @Accion, @Estatus = @Estatus, @Estacion = @Estacion, @EstacionFija = @EstacionFija
END
IF EXISTS(SELECT * FROM FormaPago WHERE FormaPago = @FormaCobro4 AND ISNULL(LDI,0) = 1 AND FormaPago NOT IN(@FormaCobroTarjetas)AND NULLIF(LDIServicio,'') IS NOT NULL)  AND @Ok IS NULL
BEGIN
SELECT @LDIServicio = LDIServicio FROM FormaPago WHERE FormaPago = @FormaCobro4  AND ISNULL(LDI,0) = 1
EXEC spLDI @LDIServicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe4, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = @Referencia4, @RIDCobro = NULL, @ADO = 0, @Accion = @Accion, @Estatus = @Estatus, @Estacion = @Estacion, @EstacionFija = @EstacionFija
END
IF EXISTS(SELECT * FROM FormaPago WHERE FormaPago = @FormaCobro5 AND ISNULL(LDI,0) = 1 AND FormaPago NOT IN(@FormaCobroTarjetas)AND NULLIF(LDIServicio,'') IS NOT NULL)  AND @Ok IS NULL
BEGIN
SELECT @LDIServicio = LDIServicio FROM FormaPago WHERE FormaPago = @FormaCobro5  AND ISNULL(LDI,0) = 1
EXEC spLDI @LDIServicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe5, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = @Referencia5, @RIDCobro = NULL, @ADO = 0, @Accion = @Accion, @Estatus = @Estatus, @Estacion = @Estacion, @EstacionFija = @EstacionFija
END
RETURN
END

