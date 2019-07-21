SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilMovilUsuarioCfgListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Usuario     varchar(10),
@ConImpuesto bit,
@Redondeo    int,
@Empresa     char(5),
@FormaCobro  char(50),
@MonedaEspecifica char(10),
@ResultadoFormas varchar(max),
@Moneda      char(10),
@TipoCambio  float
SELECT
@Usuario     = Usuario
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10))
SELECT @ConImpuesto = CAST(VentaPreciosImpuestoIncluido AS bit),
@Empresa = S.Empresa
FROM EmpresaCfg C WITH(NOLOCK)
JOIN MovilUsuarioCfg S WITH(NOLOCK) ON C.Empresa = S.Empresa
WHERE S.Usuario = @Usuario
SELECT @Redondeo = RedondeoMonetarios
FROM Version WITH(NOLOCK)
SET @Redondeo = ISNULL(@Redondeo,2)
SELECT @Resultado = CAST((
SELECT * FROM (
SELECT	M.Agente,
A.Nombre AgteNombre,
M.Usuario,
U.Nombre UsrNombre,
ISNULL(ISNULL(U.eMail, A.eMail), ' ') eMail,
ISNULL(ISNULL(U.Idioma, EG.EDIArtIdioma), ' ') Idioma,
U.Cancelar PermiteCancelar,
U.AgregarCteExpress AgregarClienteExpress,
U.ModificarDatosCliente ModificarDatosCliente,
U.ModificarDescGlobalImporte ModificarDescGlobalImp,
U.BloquearPrecios BloquearPrecios,
U.BloquearDescGlobal BloquearDescGlobal,
U.BloquearDescLinea BloquearDescLinea,
M.PedidosAConsultar PedidosAConsultar,
M.ContrasenaCorta ContrasenaCorta,
M.IntentosBloquear IntentosBloquear,
M.DiasHistorico DiasHistorico,
E.Nombre,
E.RFC,
E.Direccion + ISNULL(' ' + E.DireccionNumero, '') + ISNULL(' ' + E.DireccionNumeroInt, '') Direccion,
E.Colonia,
E.delegacion,
E.Estado,
E.CodigoPostal,
E.Telefonos,
@ConImpuesto TieneImpuesto,
@Redondeo Redondeo,
RTRIM(M.CobrosAConsultar) AS CobrosAConsultar,
RTRIM(M.MonedaBase)AS MonedaBase,
RTRIM(M.MovimientoCobro)AS MovimientoCobro,
RTRIM(M.MovimientoAnticipo)AS MovimientoAnticipo
FROM	MovilUsuarioCfg M WITH(NOLOCK)
JOIN	Agente A WITH(NOLOCK) ON M.Agente = A.Agente
JOIN	Usuario U WITH(NOLOCK) ON M.Usuario = U.Usuario
LEFT	JOIN EmpresaGral EG WITH(NOLOCK) ON M.Empresa = EG.Empresa
LEFT	JOIN Empresa E WITH(NOLOCK) ON E.Empresa = EG.Empresa
WHERE	M.Usuario = @Usuario
) AS MovilUsuarioCfgListado FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF EXISTS(SELECT * FROM CampanaTipoSituacion ST WITH(NOLOCK) JOIN CampanaTipoSubSituacion SB WITH(NOLOCK) ON ST.CampanaTipo = SB.CampanaTipo AND ST.Situacion = SB.Situacion WHERE ST.AccionMovil = 'Cancelado')
SET @Resultado = REPLACE(@Resultado, '</MovilUsuarioCfgListado>',
CAST((
SELECT RTRIM(SB.SubSituacion) MotivoCancelacion
FROM CampanaTipoSituacion ST WITH(NOLOCK)
JOIN CampanaTipoSubSituacion SB WITH(NOLOCK) ON ST.CampanaTipo = SB.CampanaTipo AND ST.Situacion = SB.Situacion
WHERE ST.AccionMovil = 'Cancelado'
ORDER BY SB.Orden, SB.SubSituacion
FOR XML PATH(''), ELEMENTS
) AS NVARCHAR(MAX)) + '</MovilUsuarioCfgListado>')
IF EXISTS(SELECT * FROM Concepto WITH(NOLOCK) WHERE Modulo='CXC')
SET @Resultado = REPLACE(@Resultado, '</MovilUsuarioCfgListado>',
CAST((
SELECT RTRIM(Concepto) AS Concepto
FROM Concepto WITH(NOLOCK)
WHERE Modulo = 'CXC'
ORDER BY Concepto
FOR XML PATH(''), ELEMENTS
) AS NVARCHAR(MAX)) + '</MovilUsuarioCfgListado>')
IF EXISTS(SELECT * FROM MovilFormaPago WITH(NOLOCK) WHERE Empresa =  @Empresa) AND EXISTS(SELECT * FROM MovilMoneda WITH(NOLOCK) WHERE Empresa =  @Empresa)
BEGIN
SET @ResultadoFormas = '<FormasCobro>'
DECLARE crFromaPago CURSOR LOCAL FOR
SELECT RTRIM(m.FormaPago) AS FormaCobro,
RTRIM(f.Moneda)AS Moneda
FROM MovilFormaPago m WITH(NOLOCK)
JOIN FormaPago f WITH(NOLOCK) ON m.FormaPago = f.FormaPago
WHERE m.Empresa = @Empresa
OPEN crFromaPago
FETCH NEXT FROM crFromaPago INTO @FormaCobro,@MonedaEspecifica
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @ResultadoFormas = @ResultadoFormas + '<Tipo>'
SET @ResultadoFormas = @ResultadoFormas + '<Nombre>'+RTRIM(@FormaCobro)+'</Nombre>'
IF ISNULL(@MonedaEspecifica,'') <> '' AND EXISTS(SELECT * FROM MovilMoneda WITH(NOLOCK) WHERE Empresa = @Empresa AND Moneda = @MonedaEspecifica)
BEGIN
SET @ResultadoFormas = @ResultadoFormas + '<Monedas>'
SET @ResultadoFormas = @ResultadoFormas +CAST((SELECT * FROM(SELECT RTRIM(mn.Moneda) AS Moneda, ISNULL(m.TipoCambio,1)AS TipoCambio
FROM MovilMoneda mn WITH(NOLOCK)
JOIN Mon m WITH(NOLOCK) ON mn.Moneda = m.Moneda
WHERE mn.Moneda = @MonedaEspecifica AND mn.Empresa = @Empresa)AS Monedas
FOR XML PATH(''), ELEMENTS) AS NVARCHAR(MAX))
SET @ResultadoFormas = @ResultadoFormas + '</Monedas>'
END
IF ISNULL(@MonedaEspecifica,'') = '' AND EXISTS(SELECT * FROM MovilMoneda WITH(NOLOCK) WHERE Empresa = @Empresa)
BEGIN
DECLARE crMoneda CURSOR LOCAL FOR
SELECT RTRIM(mn.Moneda) AS Moneda,
ISNULL(m.TipoCambio,1)AS TipoCambio
FROM MovilMoneda mn WITH(NOLOCK)
JOIN Mon m WITH(NOLOCK) ON mn.Moneda = m.Moneda
WHERE mn.Empresa = @Empresa
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @Moneda,@TipoCambio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @ResultadoFormas = @ResultadoFormas + '<Monedas>'
SET @ResultadoFormas = @ResultadoFormas + '<Moneda>'+RTRIM(@Moneda)+'</Moneda>'
SET @ResultadoFormas = @ResultadoFormas + '<TipoCambio>'+CONVERT(varchar,ISNULL(@TipoCambio,1))+'</TipoCambio>'
SET @ResultadoFormas = @ResultadoFormas + '</Monedas>'
END
FETCH NEXT FROM crMoneda INTO @Moneda,@TipoCambio
END  
CLOSE crMoneda
DEALLOCATE crMoneda
END
SET @ResultadoFormas = @ResultadoFormas + '</Tipo>'
END
FETCH NEXT FROM crFromaPago INTO @FormaCobro,@MonedaEspecifica
END  
CLOSE crFromaPago
DEALLOCATE crFromaPago
SET @ResultadoFormas = @ResultadoFormas + '</FormasCobro>'
END
IF @ResultadoFormas IS NOT NULL
SET @Resultado = REPLACE(@Resultado, '</MovilUsuarioCfgListado>',@ResultadoFormas+'</MovilUsuarioCfgListado>')
UPDATE MovilUsuarioCfg WITH(ROWLOCK) SET UltimaSincro = getdate() WHERE Usuario = @Usuario
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok)
END

