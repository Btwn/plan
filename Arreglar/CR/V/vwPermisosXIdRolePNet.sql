SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPermisosXIdRolePNet
AS
SELECT r.IDRole, p.*
FROM pNetPermiso as p
INNER JOIN pNetRolePermiso as r
ON p.IDPermiso = r.IDPermiso

