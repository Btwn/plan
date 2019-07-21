SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFKInsertarRegistro
@TablaOrigen		varchar(100),
@CampoOrigen		varchar(100),
@CampoOrigen2	varchar(100),
@CampoOrigen3	varchar(100),
@CampoOrigen4	varchar(100),
@CampoOrigen5	varchar(100),
@TablaDestino	varchar(100),
@CampoDestino	varchar(100),
@CampoDestino2	varchar(100),
@CampoDestino3	varchar(100),
@CampoDestino4	varchar(100),
@CampoDestino5	varchar(100),
@Eliminar		bit

AS BEGIN
IF (SELECT ISNULL(FK, 0) FROM Version) = 0 RETURN
IF NOT EXISTS(SELECT * FROM FK WHERE TablaOrigen = @TablaOrigen AND CampoOrigen = ISNULL(@CampoOrigen,'') AND CampoOrigen2 = ISNULL(@CampoOrigen2,'') AND CampoOrigen3 = ISNULL(@CampoOrigen3,'') AND CampoOrigen4 = ISNULL(@CampoOrigen4,'') AND CampoOrigen5 = ISNULL(@CampoOrigen5,'') AND TablaDestino = @TablaDestino AND CampoDestino = ISNULL(@CampoDestino,'') AND CampoDestino2 = ISNULL(@CampoDestino2,'') AND CampoDestino3 = ISNULL(@CampoDestino3,'') AND CampoDestino4 = ISNULL(@CampoDestino4,'') AND CampoDestino5 = ISNULL(@CampoDestino5,'') AND Eliminar = @Eliminar)
INSERT FK (TablaOrigen,  CampoOrigen,  CampoOrigen2,             CampoOrigen3,             CampoOrigen4,             CampoOrigen5,             TablaDestino,  CampoDestino,  CampoDestino2,             CampoDestino3,             CampoDestino4,             CampoDestino5,             Eliminar)
VALUES (@TablaOrigen, @CampoOrigen, ISNULL(@CampoOrigen2,''), ISNULL(@CampoOrigen3,''), ISNULL(@CampoOrigen4,''), ISNULL(@CampoOrigen5,''), @TablaDestino, @CampoDestino, ISNULL(@CampoDestino2,''), ISNULL(@CampoDestino3,''), ISNULL(@CampoDestino4,''), ISNULL(@CampoDestino5,''), @Eliminar)
END

