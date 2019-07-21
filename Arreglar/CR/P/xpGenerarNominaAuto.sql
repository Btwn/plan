SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpGenerarNominaAuto
@Sucursal			int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@ID				int,
@Mov				char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@MovMoneda	      		char(10),
@MovTipoCambio	 	float,
@FechaAfectacion  		datetime,
@FechaRegistro   		datetime,
@Concepto	      		varchar(50),
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Personal			char(10),
@IDGenerar			int,
@NominaID			int		OUTPUT,
@NominaMov			char(20)	OUTPUT,
@NominaMovID			varchar(20)	OUTPUT,
@Ok		            int         OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
RETURN
END

