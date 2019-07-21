USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[TipoRetencion2]    Script Date: 21/05/2019 06:45:06 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TipoRetencion2]
 
AS
SELECT TipoImpuesto AS TipoRetencion
				,Tasa
FROM TipoImpuesto
WHERE Tipo='Retencion 2'
GO


