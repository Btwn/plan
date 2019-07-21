SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spEstadoCuenta3
@Estacion		int

AS BEGIN
UPDATE RepParam WITH (ROWLOCK) SET  RepParam.InfoCliente ='(Todos)',RepParam.InfoSucursal = NULL,RepParam.InfoMoneda='(Todas)',RepParam.InfoEstatusEspecifico = '(Todos)',RepParam.RepTitulo ='Estado de Cuenta por Sucursal' ,InfoClienteEnviarA = NULL
WHERE Estacion = @Estacion
END

