SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPrevencionLDVerificar
@ID     		 int
,@Accion		 char(20)
,@Empresa        char(5)
,@Usuario		 char(10)
,@Modulo	       char(5)
,@Mov            char(20)
,@MovID	       varchar(20)
,@MovTipo	       char(20)
,@MovMoneda      char(10)
,@MovTipoCambio	 float
,@FechaEmision	 datetime
,@Estatus		 char(15)
,@EstatusNuevo	 char(15)
,@Acreedor	 varchar(10)
,@Condicion	 varchar(50)
,@Vencimiento	 datetime
,@Conexion	 bit
,@SincroFinal	 bit
,@Sucursal	 int
,@Ok             int OUTPUT
,@OkRef          varchar(255) OUTPUT

AS BEGIN
RETURN
END

