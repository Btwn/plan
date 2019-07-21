SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[sp_Obtener_pago_registrado_pendiente]
@Reporte		int,
@linea			int,
@Ejercicio		int,
@Periodo		int,
@Empresa		varchar(5)

AS BEGIN
SELECT ISNULL(importe,0) importe FROM PagosFiscalReporte WITH(NOLOCK)
where idreplinea = @linea
and idpago in(
SELECT max(idpago) FROM pagosfiscales WITH(NOLOCK) WHERE reporte = @Reporte and Ejercicio = @Ejercicio and Periodo = @Periodo and empresa = @Empresa
)
END

