SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaVerRecargaTelefonica
@Empresa		char(5),
@ID				int,
@Articulo		char(20),
@RenglonID		int,
@Campos			varchar(15)

AS BEGIN
IF @Campos = 'Generales'
SELECT 'Número Telefónico: ' + ISNULL(v.RecargaTelefono, ''),
'   Fecha Recarga: ' + dbo.fnFormatoFecha(v.EmidaTransactionDateTime, 'dd/MM/aaaa hh:nn:ss'),
'   Importe: ' + ISNULL(e.Amount, ''),
'   Proveedor: ' + ISNULL(c.Description, ''),
'   Número de Control: ' + ISNULL(v.EmidaCarrierControlNo, '')
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN EmidaProductCfg e ON d.Articulo = e.Articulo
JOIN EmidaCarrierCfg c ON e.CarrierId = c.CarrierId
WHERE v.Empresa = @Empresa
AND v.ID = @ID
AND d.Articulo = @Articulo
AND d.RenglonID = @RenglonID
ELSE IF @Campos = 'Mensaje'
SELECT CONVERT(text, v.EmidaResponseMessage)
FROM Venta v
WHERE v.Empresa = @Empresa
AND v.ID = @ID
RETURN
END

