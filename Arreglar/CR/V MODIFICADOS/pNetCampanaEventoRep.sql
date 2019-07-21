SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW pNetCampanaEventoRep
AS
SELECT * FROM pNetCampanaEvento WITH(NOLOCK)
WHERE Estatus NOT IN ('SINAFECTAR', 'CANCELADO')

