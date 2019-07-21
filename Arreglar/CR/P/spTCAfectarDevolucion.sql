SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCAfectarDevolucion
@Empresa		varchar(5),
@Sucursal		int,
@Estacion		int,
@FormaPago		varchar(50),
@Modulo			varchar(5),
@ModuloID		int,
@Usuario		varchar(10),
@Importe		float,
@IDOrden		varchar(255),
@Campo			varchar(50),
@Ok				int				= NULL OUTPUT,
@OkRef			varchar(255)	= NULL OUTPUT,
@Generar	    bit				= 0

AS
BEGIN
IF @Campo = 'FormaCobro1'
UPDATE VentaCobro SET Importe1 = @Importe, Referencia1 = @IDOrden WHERE ID = @ModuloID
ELSE IF @Campo = 'FormaCobro2'
UPDATE VentaCobro SET Importe2 = @Importe, Referencia2 = @IDOrden WHERE ID = @ModuloID
ELSE IF @Campo = 'FormaCobro3'
UPDATE VentaCobro SET Importe3 = @Importe, Referencia3 = @IDOrden WHERE ID = @ModuloID
ELSE IF @Campo = 'FormaCobro4'
UPDATE VentaCobro SET Importe4 = @Importe, Referencia4 = @IDOrden WHERE ID = @ModuloID
ELSE IF @Campo = 'FormaCobro5'
UPDATE VentaCobro SET Importe5 = @Importe, Referencia5 = @IDOrden WHERE ID = @ModuloID
EXEC spTCAfectarPinPad @Empresa, @Modulo, @ModuloID, @Sucursal, @Estacion, 'Credit', @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Generar = @Generar
RETURN
END

