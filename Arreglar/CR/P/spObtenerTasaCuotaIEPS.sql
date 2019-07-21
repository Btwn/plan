SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spObtenerTasaCuotaIEPS]
@reporte int,
@ejercicio int,
@tipo varchar(5), 
@periodo int = 0,
@idclasificacionieps int = 0 

AS
BEGIN
DECLARE @tasa as float, @cuota as float
DECLARE @esxperiodo as bit
if lower(@tipo) = 'tasa'
BEGIN
select @esxperiodo = isnull(tasaxperiodo,0) from reportes where reporte = @reporte
if @esxperiodo = 1 select @tasa = isnull(Tasa,0) from Iepstasacuota where reporte = @reporte and ejercicio = @ejercicio and periodo = @periodo and IdClasificacionIeps = @idclasificacionieps
else select @tasa = isnull(Tasa,0) from Iepstasacuota where reporte = @reporte and ejercicio = @ejercicio  and IdClasificacionIeps = @idclasificacionieps 
select @tasa as tasa
END
ELSE
BEGIN
select @esxperiodo = isnull(cuotaxperiodo,0) from reportes where reporte = @reporte
if @esxperiodo = 1 select @cuota = isnull(cuota,0) from Iepstasacuota where reporte = @reporte and ejercicio = @ejercicio and periodo = @periodo and IdClasificacionIeps = @idclasificacionieps
else select @cuota = isnull(cuota,0) from Iepstasacuota where reporte = @reporte and ejercicio = @ejercicio and IdClasificacionIeps = @idclasificacionieps 
select @cuota as cuota
END
END

