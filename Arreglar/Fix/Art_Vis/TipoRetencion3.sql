USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[TipoRetencion3]    Script Date: 21/05/2019 06:48:07 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TipoRetencion3]
 
AS
SELECT TipoImpuesto AS TipoRetencion
				,Tasa
FROM TipoImpuesto
WHERE Tipo='Retencion 3'
GO


