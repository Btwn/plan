SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.pNetProspecto
AS
SELECT
p.Prospecto, p.Nombre, p.Direccion, p.DireccionNumero, p.DireccionNumeroInt, p.EntreCalles, p.Plano, p.Observaciones,
p.Delegacion, p.Colonia, p.Poblacion, p.Estado, p.Pais, p.Zona, p.CodigoPostal, p.RFC, p.CURP, p.Telefonos, p.TelefonosLada, p.Fax,
p.PedirTono, p.Categoria, p.Grupo, p.Familia, p.Tipo, p.Estatus, p.UltimoCambio, p.Agente, a.Nombre AgenteNombre,
p.eMail, p.NombreComercial, p.ReferidoNombre, p.ReferidoMail, p.ReferidoTelefono, p.ReferidoRFC, p.RelacionReferencia,
p.Alta, p.Origen
FROM Prospecto p LEFT JOIN Agente a ON p.Agente = a.Agente

