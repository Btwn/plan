SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW [dbo].[TipoRetencion3]
 
AS
SELECT TipoImpuesto AS TipoRetencion
				,Tasa
FROM TipoImpuesto
WHERE Tipo='Retencion 3'

