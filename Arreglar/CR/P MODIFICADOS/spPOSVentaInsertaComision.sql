SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVentaInsertaComision
@ID             varchar(36),
@Servicio		varchar(20),
@Empresa	    varchar(5),
@Usuario	    varchar(10),
@Sucursal	    int,
@Importe        float,
@Codigo         varchar(50)

AS
BEGIN
DECLARE
@RedondeoVenta				bit,
@RedondeoVentaModificar		bit,
@Articulo					varchar(20),
@Unidad						varchar(50),
@Renglon					float,
@RenglonID					int,
@ImporteMov					float,
@Comision					float,
@RedondeoSugerido			float,
@RedondeoActual				float,
@RedondeoMonetarios         int
RETURN
END

