SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spACActualizarTasas
@Empresa		char(5),
@Modulo		char(5),
@Hoy			datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@TipoTasa		varchar(20),
@TasaDiariaN 	float,
@TasaDiariaA 	float,
@RamaID             int
IF @Modulo = 'CXC'
DECLARE crActualizarTasas CURSOR FOR
SELECT TipoTasa, TasaDiaria, RamaID
FROM Cxc c
WHERE c.Empresa = @Empresa AND c.Estatus = 'PENDIENTE'
AND c.FechaEmision = @Hoy+0
AND c.RamaID IS NOT NULL AND c.TipoTasa IS NOT NULL
AND TieneTasaEsp = 0
ELSE
DECLARE crActualizarTasas CURSOR FOR
SELECT TipoTasa, TasaDiaria
FROM Cxp c
WHERE c.Empresa = @Empresa AND c.Estatus = 'PENDIENTE'
AND c.FechaEmision = @Hoy+0
AND c.RamaID IS NOT NULL AND c.TipoTasa IS NOT NULL
AND TieneTasaEsp = 0
OPEN crActualizarTasas
FETCH NEXT FROM crActualizarTasas INTO @TipoTasa, @TasaDiariaA, @RamaID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spTipoTasa @TipoTasa, @TasaDiariaN OUTPUT
IF @TasaDiariaN <> @TasaDiariaA
BEGIN
IF @Modulo = 'CXC'
BEGIN
UPDATE Cxc
SET InteresesFijos = dbo.fnR3 (TasaDiaria, InteresesFijos, @TasaDiariaN),
TasaDiaria = @TasaDiariaN
WHERE RamaID  = @RamaID
AND Empresa = @Empresa
AND Estatus = 'PENDIENTE'
AND FechaEmision >= @Hoy
AND Vencimiento > @Hoy
END
ELSE
UPDATE Cxp
SET InteresesFijos = dbo.fnR3 (TasaDiaria, InteresesFijos, @TasaDiariaN),
InteresesFijosRetencion = dbo.fnR3 (TasaDiaria, InteresesFijosRetencion, @TasaDiariaN),
TasaDiaria = @TasaDiariaN
WHERE RamaID  = @RamaID
AND Empresa = @Empresa
AND Estatus = 'PENDIENTE'
AND FechaEmision >= @Hoy
AND Vencimiento > @Hoy
END
END
FETCH NEXT FROM crActualizarTasas INTO @TipoTasa, @TasaDiariaA, @RamaID
END  
CLOSE crActualizarTasas
DEALLOCATE crActualizarTasas
RETURN
END

