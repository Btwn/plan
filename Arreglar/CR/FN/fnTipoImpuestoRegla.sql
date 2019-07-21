SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTipoImpuestoRegla (@TipoImpuesto varchar(10), @Fecha datetime, @Modulo varchar(5), @ID int, @Mov varchar(20), @CriterioEmpresa varchar(30), @CriterioCliente varchar(30), @CriterioProveedor varchar(30), @RegimenEmpresa varchar(30), @ZonaEmpresa varchar(30), @RegimenSucursal varchar(30), @ZonaSucursal varchar(30), @RegimenCliente varchar(30), @ZonaCliente varchar(30), @RegimenClienteEnviarA varchar(30), @ZonaClienteEnviarA varchar(30), @RegimenProveedor varchar(30), @ZonaProveedor varchar(30))
RETURNS varchar(10)

AS BEGIN
DECLARE
@Resultado			varchar(10),
@ReglaID			int,
@ReglaModulo		varchar(5),
@ReglaMov			varchar(20),
@ReglaRegimenEmpresa	varchar(30),
@ReglaRegimenCliente	varchar(30),
@ReglaRegimenProveedor	varchar(30),
@ReglaZonaEmpresa		varchar(30),
@ReglaZonaCliente		varchar(30),
@ReglaZonaProveedor		varchar(30),
@TipoImpuestoNuevo		varchar(10),
@Tipo					varchar(20)
SELECT @Resultado = NULL
SELECT @Tipo = '('+Tipo+')' FROM TipoImpuesto WHERE TipoImpuesto = @TipoImpuesto
IF NULLIF(RTRIM(@TipoImpuesto), '') IS NULL
RETURN (@Resultado)
DECLARE crRegla CURSOR LOCAL FOR
SELECT ID, NULLIF(RTRIM(Modulo),''), NULLIF(RTRIM(Mov),''), NULLIF(RTRIM(FiscalRegimenEmpresa),''), NULLIF(RTRIM(FiscalRegimenCliente),''), NULLIF(RTRIM(FiscalRegimenProveedor),''), TipoImpuestoNuevo, NULLIF(RTRIM(FiscalZonaEmpresa),''), NULLIF(RTRIM(FiscalZonaCliente),''), NULLIF(RTRIM(FiscalZonaProveedor),'')
FROM FiscalRegimenRegla
WHERE TipoImpuesto IN (@TipoImpuesto, @Tipo) AND Estatus = 'ALTA' AND VigenciaD <= @Fecha AND (VigenciaA IS NULL OR VigenciaA >= @Fecha)
AND NULLIF(RTRIM(Modulo), '') IN (NULL, @Modulo)
AND NULLIF(RTRIM(Mov), '') IN (NULL, @Mov)
AND NULLIF(RTRIM(TipoImpuestoNuevo), '') IS NOT NULL
ORDER BY LEN(ISNULL(Modulo,'') + ISNULL(Mov,'')) DESC
OPEN crRegla
FETCH NEXT FROM crRegla INTO @ReglaID, @ReglaModulo, @ReglaMov, @ReglaRegimenEmpresa, @ReglaRegimenCliente, @ReglaRegimenProveedor, @TipoImpuestoNuevo, @ReglaZonaEmpresa, @ReglaZonaCliente, @ReglaZonaProveedor
WHILE @@FETCH_STATUS <> -1 AND @Resultado IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF (@RegimenEmpresa  = @ReglaRegimenEmpresa AND @ZonaEmpresa = @ReglaZonaEmpresa  AND @CriterioEmpresa IN ('Empresa', 'Empresa/Sucursal')) OR
(@RegimenSucursal = @ReglaRegimenEmpresa AND @ZonaSucursal = @ReglaZonaEmpresa AND @CriterioEmpresa IN ('Sucursal', 'Empresa/Sucursal'))
BEGIN
IF ((@RegimenCliente        = @ReglaRegimenCliente AND @ZonaCliente        = @ReglaZonaCliente AND @CriterioCliente IN ('Cliente', 'Cliente/Sucursal Envio')) OR
(@RegimenClienteEnviarA  = @ReglaRegimenCliente AND @ZonaClienteEnviarA = @ReglaZonaCliente AND @CriterioCliente IN ('Sucursal Envio', 'Cliente/Sucursal Envio')))
AND NULLIF(@ReglaRegimenCliente,'') IS NOT NULL AND NULLIF(@ReglaZonaCliente,'') IS NOT NULL
SELECT @Resultado = @TipoImpuestoNuevo
ELSE
IF RTRIM(@RegimenProveedor) = RTRIM(@ReglaRegimenProveedor) AND RTRIM(@ZonaProveedor) = RTRIM(@ReglaZonaProveedor) AND RTRIM(@CriterioProveedor) = 'Proveedor'
AND NULLIF(@ReglaRegimenProveedor,'') IS NOT NULL AND NULLIF(@ReglaZonaProveedor,'') IS NOT NULL
SELECT @Resultado = @TipoImpuestoNuevo
END
IF NULLIF(@ReglaRegimenEmpresa,'') IS NULL AND NULLIF(@ReglaRegimenCliente,'') IS NULL AND NULLIF(@ReglaRegimenProveedor,'') IS NULL AND NULLIF(@ReglaZonaEmpresa,'') IS NULL AND NULLIF(@ReglaZonaCliente,'') IS NULL AND NULLIF(@ReglaZonaProveedor,'') IS NULL
SELECT @Resultado = @TipoImpuestoNuevo
END
FETCH NEXT FROM crRegla INTO @ReglaID, @ReglaModulo, @ReglaMov, @ReglaRegimenEmpresa, @ReglaRegimenCliente, @ReglaRegimenProveedor, @TipoImpuestoNuevo, @ReglaZonaEmpresa, @ReglaZonaCliente, @ReglaZonaProveedor
END 
CLOSE crRegla
DEALLOCATE crRegla
RETURN (ISNULL(NULLIF(RTRIM(@Resultado), ''), @TipoImpuesto))
END

