SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoAPP
@Empresa char(5),
@Usuario varchar(10)

AS BEGIN
SELECT
GastoT.ID,
GastoT.Empresa,
GastoT.Mov,
GastoT.MovID,
GastoT.FechaEmision,
GastoT.Observaciones,
GastoT.Moneda,
GastoT.TipoCambio,
GastoT.Usuario,
Usuario.Nombre AS NombreUs,
Usuario.eMail,
GastoT.Estatus,
GastoT.Situacion,
GastoT.SituacionFecha,
GastoT.SituacionUsuario,
GastoT.Acreedor,
Prov.Nombre AS NombreProv,
GastoT.Clase,
GastoT.SubClase,
GastoT.Sucursal,
Sucursal.Nombre AS NombreSuc,
GastoT.Renglon,
GastoT.Concepto,
GastoT.Referencia,
GastoT.Cantidad,
ROUND(GastoT.TotalLinea / GastoT.Cantidad,4) Precio,
GastoT.TotalLinea AS ImporteLinea
FROM
GastoT WITH(NOLOCK)
JOIN Prov     WITH(NOLOCK) ON GastoT.Acreedor = Prov.Proveedor
JOIN Sucursal WITH(NOLOCK) ON GastoT.Sucursal = Sucursal.Sucursal
JOIN Usuario  WITH(NOLOCK) ON GastoT.Usuario  = Usuario.Usuario
JOIN MovTipo  WITH(NOLOCK) ON GastoT.Mov = MovTipo.Mov AND MovTipo.Modulo = 'GAS'
WHERE
MovTipo.Clave IN ('GAS.S') AND GastoT.Estatus = 'PENDIENTE'
AND GastoT.Empresa = @Empresa
AND NULLIF(RTRIM(GastoT.Situacion), '') IS NOT NULL
AND dbo.fnSituacionUsuarioAPP(GastoT.Empresa, 'GAS', GastoT.Mov, GastoT.Estatus, GastoT.Situacion, @Usuario) = 1
END
RETURN

