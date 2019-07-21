SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInforValidarArt
(
@AlmacenROP    varchar(20),
@Proveedor         varchar(10),
@Descripcion1   varchar(100),
@UnidadCompra   varchar(50),
@SeCompra       bit
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@Resultado   varchar(100)
SET @Resultado = NULL
IF NULLIF(@AlmacenROP,'') IS NULL
SELECT @Resultado = 'El campo Almacén Orden debe tener valor'
IF NULLIF(@Proveedor,'') IS NULL AND ISNULL(@SeCompra,0)= 1
SELECT @Resultado = 'El campo Proveedor (por omision) debe tener valor'
IF NULLIF(@Descripcion1,'') IS NULL
SELECT @Resultado = 'El campo Descripción debe tener valor'
IF NULLIF(@UnidadCompra,'') IS NULL
SELECT @Resultado ='El campo Unidad Compra/Producción debe tener valor'
RETURN (@Resultado)
END

