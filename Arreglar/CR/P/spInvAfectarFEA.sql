SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectarFEA
@ID                          int,
@Accion			char(20),
@Empresa                     varchar(5),
@Sucursal                    int,
@Estatus                     varchar(15),
@Modulo	      		char(5),
@Mov                         varchar(20),
@MovTipoConsecutivoFEA	varchar(20),
@FEAConsecutivo		varchar(20),
@FEAReferencia		varchar(50),
@FEASerie		        varchar(20),
@FEAFolio			int,
@Ok                          int	        OUTPUT,
@OkRef		        varchar(255)	OUTPUT

AS BEGIN
SELECT @MovTipoConsecutivoFEA = NULLIF(RTRIM(ConsecutivoFEA), '') FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovTipoConsecutivoFEA IS NOT NULL
BEGIN
IF @Accion = 'AFECTAR' AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND NOT EXISTS(SELECT * FROM VentaFEA WHERE ID = @ID)
BEGIN
EXEC spConsecutivo @MovTipoConsecutivoFEA, @Sucursal, @FEAConsecutivo OUTPUT, @Referencia = @FEAReferencia OUTPUT
EXEC spMovIDEnSerieConsecutivo @FEAConsecutivo, @FEASerie OUTPUT, @FEAFolio OUTPUT
INSERT VentaFEA (
ID,  Serie,     Folio,     Aprobacion,                   Procesar, Cancelada)
SELECT @ID, @FEASerie, @FEAFolio, CONVERT(int, @FEAReferencia), 1,        0
EXEC spPreValidarFEA @ID, 0, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
IF @Accion = 'CANCELAR' AND @Estatus IN ('PENDIENTE', 'CONCLUIDO')
BEGIN
UPDATE VentaFEA SET Procesar = 1, Cancelada = 1 WHERE ID = @ID
END
END
END

