SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpSaldoPMon
@Sucursal                int        ,
@Accion                  varchar(20),
@Empresa                 varchar( 5),
@Rama                    varchar( 5),
@Moneda                  varchar(10),
@TipoCambio              float      ,
@Cuenta                  varchar(20),
@SubCuenta               varchar(50),
@Grupo                   varchar(10),
@Modulo                  varchar( 5),
@ID                      int        ,
@Mov                     varchar(20),
@MovID                   varchar(20),
@Cargo                   money      ,
@Abono                   money      ,
@Fecha                   datetime   ,
@EjercicioAfectacion     int        ,
@PeriodoAfectacion       int        ,
@AcumulaSinDetalles      bit        ,
@AcumulaEnLinea          bit        ,
@GeneraAuxiliar          bit        ,
@GeneraSaldo             bit        ,
@Conciliar               bit        ,
@Aplica                  varchar(20),
@AplicaID                varchar(20),
@EsResultados            bit        ,
@Ok                      int          OUTPUT,
@OkRef                   varchar(255) OUTPUT,
@Renglon                 float        = NULL,
@RenglonSub              int          = NULL,
@RenglonID               int          = NULL
AS
BEGIN
RETURN
END

