SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOmisionMensajeLayoutHSBC25

AS BEGIN
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00491', 'REVERSO OTROS ABONOS(00491)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00607', 'REVERSO PAGO DE AVALUO EN EFECTIVO(00607)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00553', 'REVERSO PAGO DE CHEQUES VIAJERO(00553)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '04454', 'REVERSO PAGO DE DINERO EN MINUTOS(04454)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '01160', 'REVERSO PAGO DE INTERESES(01160)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00729', 'REVERSO PAGO DE TELMEX(00729)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00453', 'REVERSO PAGOS DE HIPOTECARIO(00453)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00541', 'REVERSO PAGOS MENSUALES INFONAVIT(00541)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05912', 'REVERSO POR ABONO TRANSFER LINEA BITAL(05912)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00511', 'REVERSO REMESAS RECIBIDAS POR COBRANZA(00511)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05390', 'REVERSO RETIRO EN CAJERO AUTOMATICO (BAT(05390)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05090', 'REVERSO RETIRO EN CAJERO AUTOMATICO (BATCH)(05090)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '01090', 'REVERSO RETIRO EN CAJERO AUTOMATICO ON-LINE(01090)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00489', 'REVERSO SAAC(00489)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00731', 'REVERSO SERVICIOS ESPECIALES(00731)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00369', 'REVERSO SOBRANTES DE CAJERO(00369)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05494', 'REVERSO TRANSFER BICASH TO(05494)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00779', 'REVERSO VENTA DE CHEQUES DE VIAJERO(00779)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00789', 'REVERSO VENTA DE CHEQUES DE VIAJERO A LA(00789)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00488', 'SAAC(00488)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00730', 'SERVICIOS ESPECIALES(00730)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '04605', 'Sin descripcion(04605)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '04607', 'Sin descripcion(04607)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05560', 'Sin descripcion(05560)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05641', 'Sin descripcion(05641)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00212', 'SOBRANTE DE CAJERO AUTOMATICO(00212)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00368', 'SOBRANTE DE CAJEROS(00368)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '03220', 'SUSPENDER PAGO DE INTERSES RETIRO ANTICIPADO(03220)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '01126', 'SUSPENSION DE PAGO DE INTERESES(01126)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '07027', 'TOTAL DE ABONO POR CAJERO EN NUMERO DE OPS(07027)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '07025', 'TOTAL DE CARGO POR CAJERO EN NUMERO DE OPS(07025)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '02371', 'TRANSACCIONES DE LOC(02371)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05465', 'TRANSFER BICASH A(05465)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05473', 'TRANSFER BICASH A(05473)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05475', 'TRANSFER BICASH A(05475)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05471', 'TRANSFER BICASH DE(05471)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05467', 'TRANSFER BICASH FROM(05467)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05425', 'TRANSFER BICASH FROM (ABONO POR TRANSF)(05425)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05491', 'TRANSFER BICASH FROM (CARGO POR TRANSF)(05491)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05469', 'TRANSFER BICASH TO(05469)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05493', 'TRANSFER BICASH TO(05493)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '03228', 'TRANSFERENCIA DE INTERESES DE TDA(03228)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '00778', 'VENTA CHEQUES DE VIAJERO(00778)', 'Tesoreria', NULL, 0)
INSERT INTO MensajeLayout (Layout, Mensaje, Descripcion, TipoMovimiento, NaturalezaMovimiento, ConciliarMismaFecha) VALUES('HSBC2', '05675', 'VENTA GENERICA POR BD(05675)', 'Tesoreria', NULL, 0)
END

