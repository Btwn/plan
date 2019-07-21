SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spFacturaAnticipoCXC
@ID INT

AS BEGIN
SELECT	CX.ID,
CX.Mov,
CX.MovID,
CX.FechaEmision,
CX.UEN,
CX.Moneda,
CONVERT(FLOAT, CX.TipoCambio) AS TipoCambioMov,
CX.Cliente,
C.Nombre,
C.RFC,
C.Direccion,
C.DireccionNumero,
C.DireccionNumeroInt,
C.EntreCalles,
C.Observaciones,
C.Delegacion,
C.Colonia,
C.CodigoPostal,
C.Estado,
C.Pais,
C.Telefonos,
C.TelefonosLada,
C.Fax,
C.eMail1,
CA.Nombre AS CteSucNombre,
CA.Direccion AS CteSucDireccion,
CA.DireccionNumero AS CteSucDireccionNum,
CA.DireccionNumeroInt AS CteSucDirNumInt,
CA.EntreCalles AS CteSucEntreCalles,
CA.Observaciones AS CteSucObservaciones,
CA.Delegacion AS CteSucDelegacion,
CA.Colonia AS CteSucColonia,
CA.CodigoPostal AS CteSucCodigoPostal,
CA.Estado AS CteSucEstado,
CA.Pais AS CteSucPais,
CA.Telefonos As CteSucTelefonos,
CA.Fax AS CteSucFax,
CA.eMail1 AS CteSuceMail1,
CONVERT(INT, V.Renglon) AS RENGLON,
CONVERT(INT, V.RenglonID) AS RENGLONID,
ISNULL(NULLIF(V.Articulo, ''), CX.Concepto) AS ARTICULO,
ISNULL(V.Cantidad, 1) AS CANTIDAD,
ISNULL(NULLIF(CX.OBSERVACIONES, ''), A.Descripcion1) AS DESCRIPCIONART,
DATALENGTH(ISNULL(NULLIF(CX.OBSERVACIONES, ''), A.Descripcion1)) AS LARGODESCART,
VD.Precio PrecioME,
VD.PrecioTipoCambio,
ISNULL(VD.Precio * VD.PrecioTipoCambio, CX.Importe) PrecioMN,
(VD.Precio * VD.Cantidad) AS IMPORTETOTALME,
ISNULL(VD.Precio * VD.Cantidad * VD.PrecioTipoCambio, CX.Importe) AS ImporteTotalMN,
VD.DescuentoLinea,
V.SubTotal * V.TipoCambio SubTotalMov,
V.Impuestos * V.TipoCambio ImpuestosMov,
V.DescuentosTotales * V.TipoCambio DescTotalesMov,
V.TotalNeto * V.TipoCambio TotalNetoMov,
'DESCRIPCION' AS RENGLONREPTIPO,
1.0 AS ORDENREP,
V.Empresa,
E.Nombre AS EmpresaNombre,
AC.Direccion AS LOGORUTA,
V.Agente,
AG.Nombre AS AGENTENOMBRE,
VE.EnviarA,
E.RFC EmpresaRFC,
E.Direccion EmpresaDir,
E.DireccionNumero EmpresaDirNum,
E.DireccionNumeroInt EmpresaDirNumInt,
E.Colonia EmpresaColonia,
E.CodigoPostal EmpresaCP,
E.Poblacion EmpresaPoblacion,
E.Delegacion EmpresaDelegacion,
E.Estado EmpresaEDO,
E.Pais EmpresaPais,
E.Telefonos EmpresaTel,
E.Fax EmpresaFax,
V.Sucursal VentaSucursal,
S.Nombre SucursalNombre,
S.Direccion SucursalDir,
S.DireccionNumero SucursalDirNum,
S.DireccionNumeroInt SucursalDirNumInt,
S.Colonia SucursalColonia,
S.CodigoPostal SucursalCP,
S.Delegacion SucursalDelegacion,
S.Estado SucursalEDO,
S.Poblacion SucursalPoblacion,
S.Pais SucursalPais,
S.Telefonos SucursalTel,
S.Fax SucursalFax,
i.Fecha FechaCFD,
i.FechaTimbrado,
i.noCertificado,
i.noCertificadoSAT,
CONVERT(VARCHAR(100), i.UUID) UUID,
i.Sello,
i.SelloSAT,
i.TFDCadenaOriginal,
CONVERT(VARCHAR(50), NULL) AS SERIELOTE,
CONVERT(VARCHAR(100), NULL) AS ADUANA,
CONVERT(DATE, NULL) AS FECHAADUANA,
CONVERT(VARCHAR(50), NULL) AS PEDIMENTO,
(SELECT Direccion FROM AnexoCta WHERE RAMA = 'EMP' AND CUENTA = V.Empresa AND TIPO = 'Imagen' AND Nombre = CONVERT(VARCHAR(10), V.UEN) + 'F') AS CODIGO,
(SELECT NOMBRE FROM FISCALREGIMEN WHERE FiscalRegimen = E.FiscalRegimen) AS REGIMENFISCAL,
CX.FormaCobro1,
CX.FormaCobro2,
CX.FormaCobro3,
CX.FormaCobro4,
CX.FormaCobro5,
CX.Referencia1,
CX.Referencia2,
CX.Referencia3,
CX.Referencia4,
CX.Referencia5,
(CASE WHEN NULLIF(CX.Referencia1, '') IS NOT NULL OR NULLIF(CX.Referencia2, '') IS NOT NULL OR NULLIF(CX.Referencia3, '') IS NOT NULL OR NULLIF(CX.Referencia4, '') IS NOT NULL OR NULLIF(CX.Referencia5, '') IS NOT NULL
THEN 'SI' ELSE NULL END) AS CONDATOSREFCOBRO,
(CASE WHEN NULLIF(CX.FormaCobro1, '') IS NOT NULL OR NULLIF(CX.FormaCobro2, '') IS NOT NULL OR NULLIF(CX.FormaCobro3, '') IS NOT NULL OR NULLIF(CX.FormaCobro4, '') IS NOT NULL OR NULLIF(CX.FormaCobro5, '') IS NOT NULL
THEN 'SI' ELSE NULL END) AS CONDATOSFORMAPAGO,
ISNULL(V.Unidad, 'NO APLICA') UNIDADVTA,
V.ID AS IDVTA,
CX.Importe AS IMPORTECXC,
CX.Impuestos AS IMPUESTOSCXC,
CX.Importe + CX.Impuestos AS TOTALCXC,
CONVERT(FLOAT, CONVERT(FLOAT, CX.Importe) / CONVERT(FLOAT, VE.Importe * VE.TIPOCAMBIO)) AS FACTORIMPORTE
INTO #REPPRESUPUESTO
FROM CXC CX
LEFT OUTER JOIN VENTATCALC V ON CX.Referencia = V.Mov + ' ' + V.MovID
LEFT OUTER JOIN VENTA VE ON V.ID = VE.ID
JOIN Cte C ON CX.CLIENTE = C.Cliente
LEFT OUTER JOIN CteEnviarA CA ON CX.Cliente = CA.Cliente AND CX.ClienteEnviarA = CA.ID
LEFT OUTER JOIN ART A ON V.ARTICULO = A.ARTICULO
LEFT OUTER JOIN VENTAD VD ON V.ID = VD.ID AND V.Renglon = VD.Renglon AND V.RenglonID = VD.RenglonID
JOIN EMPRESA E ON CX.Empresa = E.Empresa
LEFT OUTER JOIN AnexoCta AC ON CX.Empresa = AC.Cuenta AND CONVERT(VARCHAR(10), CX.ContUso) + 'F' = AC.Nombre AND AC.Rama = 'EMP' AND AC.Tipo = 'Imagen'
LEFT OUTER JOIN Agente AG ON CX.Agente = AG.Agente
JOIN Sucursal S ON CX.Sucursal = S.Sucursal
LEFT OUTER JOIN CFD i ON CX.ID = i.ModuloID AND i.Modulo = 'CXC'
LEFT OUTER JOIN VentaCobro VC ON V.ID = VC.ID
WHERE CX.ID = @ID
SELECT * FROM #REPPRESUPUESTO
ORDER BY ID, Renglon, RenglonID, ORDENREP
END

