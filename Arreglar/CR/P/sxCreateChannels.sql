SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxCreateChannels
AS
BEGIN
IF NOT EXISTS (SELECT * FROM sx_channel WHERE channel_id = 'config')
INSERT INTO sx_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, max_data_to_route, enabled, description)
VALUES('config', 0, 100, 100, 10000, 1, 'Canal de configuracion')
IF NOT EXISTS (SELECT * FROM sx_channel WHERE channel_id = 'reload')
INSERT INTO sx_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, max_data_to_route, enabled, description)
VALUES('reload', 1, 1, 10, 10000, 1, 'Canal de reloads')
IF NOT EXISTS (SELECT * FROM sx_channel WHERE channel_id = 'schema_channel')
INSERT INTO sx_channel (channel_id, processing_order, max_batch_size, enabled, description)
VALUES('schema_channel', 0, 1, 1, 'Canal de cambios en schema')
IF NOT EXISTS (SELECT * FROM sx_channel WHERE channel_id = 'alta')
INSERT INTO sx_channel (channel_id, processing_order, max_batch_size, enabled, description)
VALUES('alta', 2, 1500, 1, 'Canal Alta Prioridad')
IF NOT EXISTS (SELECT * FROM sx_channel WHERE channel_id = 'normal')
INSERT INTO sx_channel (channel_id, processing_order, max_batch_size, enabled, description)
VALUES('normal', 3, 1000, 1, 'Canal Prioridad Normal')
IF NOT EXISTS (SELECT * FROM sx_channel WHERE channel_id = 'baja')
INSERT INTO sx_channel (channel_id, processing_order, max_batch_size, enabled, description)
VALUES('baja', 4, 500, 1, 'Canal Baja Prioridad')
END

