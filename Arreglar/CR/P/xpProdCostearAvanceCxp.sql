SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpProdCostearAvanceCxp
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Modulo		char(5),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@MovMoneda		char(10),
@MovTipoCambio	float,
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Usuario		char(10),
@Proyecto		varchar(50),
@Ejercicio		int,
@Periodo		int,
@Referencia	      	varchar(50),
@Observaciones     	varchar(255),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@Cxp			bit		OUTPUT,
@Proveedor		varchar(10)	OUTPUT,
@CxpMov		varchar(20)	OUTPUT,
@Concepto		varchar(50)	OUTPUT,
@Impuesto1		float		OUTPUT,
@Condicion		varchar(50)	OUTPUT
AS BEGIN
RETURN
END

