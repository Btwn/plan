SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSIsyncMonitor

AS
SELECT
batch_id as Batch,
node_id as Nodo,
channel_id as Canal,
status as Estatus,
extract_count as ContExtraccion,
sent_count as ContEnvio,
load_count as ContCarga,
sql_state as EstadoSQL,
sql_code as CodigoSQL,
CONVERT(varchar(100),sql_message) as MensajeSQL,
failed_data_id as DataFallido,
last_update_time as UltimaActualizacion,
create_time as FechaCreacion
FROM sx_outgoing_batch WITH(NOLOCK)

