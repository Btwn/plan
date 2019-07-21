SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInvVerificarWMS
@ID							int,
@Tarima						varchar(20),
@MovTipo					char(20),
@Almacen					char(10),
@CantidadOriginal			float,
@CantidadA					float,
@CantidadPendiente			float,
@Accion						char(20),
@Articulo					char(20),
@FechaCaducidad				datetime,
@FechaEmision				datetime,
@ArtCaducidadMinima			int,
@Modulo						varchar(5),
@EsTransferencia			bit,
@Mov              			char(20),
@AlmacenTipo				char(15),
@AlmacenDestino				char(10),
@AlmacenDestinoTipo			char(15),
@CfgInvPrestamosGarantias	bit,
@Ok               			int           	= NULL OUTPUT,
@OkRef            			varchar(255)  	= NULL OUTPUT
AS BEGIN
RETURN
END

