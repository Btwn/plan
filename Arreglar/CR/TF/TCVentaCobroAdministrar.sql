SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION TCVentaCobroAdministrar (@Modulo char(5), @ModuloID int)
RETURNS @Resultado
TABLE (RID int, Modulo varchar(5), ModuloID int, FormaPago varchar(50), Campo varchar(50), Importe float, Estatus varchar(20), ARQC varchar(255), BancoEmisor varchar(255),
CodigoAutorizacion varchar(255), CodigoError varchar(255), CodigoProcesador varchar(255), E1 varchar(255), E2 varchar(255), E3 varchar(255), EstatusProceso varchar(255),
FechaExpiracion varchar(5), FechaFin datetime, FechaInicio datetime, IDOrden varchar(255), MensajeError varchar(255), MensajeProcesador varchar(255), NumeroTarjeta varchar(4),
SeveridadError varchar(255), Tarjetahabiente varchar(255), Texto varchar(255), TipoOperacion varchar(255), TipoTarjeta varchar(255), TipoTransaccion varchar(255),
Total float, Track1 varchar(255), Track2 varchar(255), Ok int, OkRef varchar(255), TCTipoPlan varchar(20), TCNoMeses int, TCDiferirMeses int, MovEstatus varchar(15), Icono int)

AS BEGIN
INSERT INTO @Resultado(
RID, Modulo, ModuloID, FormaPago, Campo,                                        Importe, ARQC, BancoEmisor, CodigoAutorizacion, CodigoError, CodigoProcesador, E1, E2, E3, EstatusProceso, FechaExpiracion, FechaFin, FechaInicio, IDOrden, MensajeError, MensajeProcesador, NumeroTarjeta,           SeveridadError, Tarjetahabiente, Texto, TipoOperacion, TipoTarjeta, TipoTransaccion, Total, Track1, Track2, Ok, OkRef, TCTipoPlan, TCNoMeses, TCDiferirMeses, Estatus,                                                                                                        Icono)
SELECT RID, Modulo, ModuloID, FormaPago, REPLACE(Campo, 'FormaCobro', 'Forma Cobro '), Importe, ARQC, BancoEmisor, CodigoAutorizacion, CodigoError, CodigoProcesador, E1, E2, E3, Estatus,        FechaExpiracion, FechaFin, FechaInicio, IDOrden, MensajeError, MensajeProcesador, RIGHT(NumeroTarjeta, 4), SeveridadError, Tarjetahabiente, Texto, TipoOperacion, TipoTarjeta, TipoTransaccion, Total, Track1, Track2, Ok, OkRef, TCTipoPlan, TCNoMeses, TCDiferirMeses, CASE Accion WHEN 'Auth' THEN 'Autorizacion' WHEN 'Void' THEN 'Cancelacion' WHEN 'Credit' THEN 'Devolucion' END, CASE Accion WHEN 'Auth' THEN 339 WHEN 'Void' THEN 416 WHEN 'Credit' THEN 339 END
FROM TCTransaccion
WHERE Ok IS NULL
AND Modulo = @Modulo
AND ModuloID = @ModuloID
UPDATE r
SET MovEstatus = v.Estatus
FROM @Resultado r
JOIN Venta v ON r.Modulo = 'VTAS' AND r.ModuloID = v.ID
RETURN
END

