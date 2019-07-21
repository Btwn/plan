SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxActivarPOSArtSucursal
@Activar bit

AS
BEGIN
DECLARE
@table_group_Art				varchar(20),
@table_group_POSArtSucursal		varchar(20),
@trigger_id						varchar(50),
@router_id						varchar(50),
@from							varchar(50),
@to								varchar(50)
END

