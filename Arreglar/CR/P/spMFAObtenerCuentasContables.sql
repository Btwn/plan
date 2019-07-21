SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMFAObtenerCuentasContables]

AS
BEGIN
SELECT a.CuentaContable as cuenumero,isnull(a.CuentaControl,'') as cuecontrol,a.nivel as cuenivel,
a.descripcion as cuedescri,isnull(a.tipo,'') as cuetipo,a.clase as cueclase,
'' as cuenatur, 0 as cuedepto,0 as cuecatego,ISNULL(b.Rubro,'') as cuerubro,
'A' as cuestatus,0 as cuecantid,0 as cuedigito,moneda as cuemoneda,'' as cueclasi,
0 as cuesepara,isnull(cr.IdRetencion,10) as cueretenc,0 as cueautonum,0 as cuerubroc
FROM CuentasContables a
left join CuentaRubro b on a.CuentaContable=b.CuentaContable
left join cuentasretenciones cr on a.CuentaContable = cr.CuentaContable
END

