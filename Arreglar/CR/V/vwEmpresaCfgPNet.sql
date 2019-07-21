SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwEmpresaCfgPNet
AS
SELECT * FROM (
SELECT	E.*, 'rs_' + S.Descripcion Descripcion, ES.URL
FROM	(
SELECT E.*, 'cfg_' + C.Descripcion Descripcion, EC.Value
FROM	(SELECT	E.Empresa, ISNULL(PN.Nombre, E.Nombre) Nombre, ISNULL(PN.Telefonos, E.Telefonos) Telefonos,
ISNULL(PN.Direccion, ISNULL(E.Direccion, '') + ISNULL(' ' + E.DireccionNumero, '') + ISNULL(' ' + E.DireccionNumeroInt, '') + ISNULL(E.Colonia, '') + ISNULL(', ' +E.Delegacion, '') + ISNULL(', ' +E.Estado, '') + ISNULL(', CP. ' + E.CodigoPostal, '')) Direccion,
PN.ImagenPath, PN.Email, PN.MapaLatitud, PN.MapaLongitud, PN.MapaPrecision, PN.Mision,
PN.Vision, PN.Nosotros, PN.AvisoPrivacidad, PN.URLIntranet, PN.URLExtranet, CASE ISNULL(PN.Nombre, '') WHEN '' THEN 0 ELSE 1 END Configurada
FROM	Empresa E
LEFT	JOIN EmpresaCfgPNet PN ON E.Empresa = PN.Empresa
WHERE	E.Estatus = 'ALTA') AS E
CROSS	JOIN pNetOpcionMostrar C
LEFT	JOIN pNetEmpresaOpcionMostrar EC ON E.Empresa = EC.Empresa and C.OpcionMostrarID = EC.OpcionMostrarID) p
PIVOT	(MAX (Value)FOR Descripcion IN ([cfg_Comunicados],[cfg_Noticias],[cfg_Destacados],[cfg_BolsaTrabajo],[cfg_CaptarContactos],[cfg_RegCV],[cfg_Email Contacto])) AS E
CROSS JOIN pNetRedSocialCat S
LEFT JOIN pNetEmpresaRedSocial ES ON E.Empresa = ES.Empresa and S.RedSocialID = ES.RedSocialID) p
PIVOT (MAX (URL)FOR Descripcion IN ([rs_Facebook],[rs_Twitter],[rs_Google],[rs_Instagram],[rs_LinkedIn],[rs_YouTube],[rs_Vine],[rs_FourSquare],[rs_Pinterest],[rs_Blogger])) AS Vw

