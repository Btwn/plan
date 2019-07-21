USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[TipoRetencion1]    Script Date: 21/05/2019 06:44:41 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TipoRetencion1]
 
AS
SELECT TipoImpuesto AS TipoRetencion
				,Tasa
FROM TipoImpuesto
WHERE Tipo='Retencion 1'
GO


