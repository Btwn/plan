SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.sppNetConDin (@IDUsuario int, @IDUsuarioTipo int)
AS
BEGIN
SET NOCOUNT ON
SELECT	DISTINCT
ISNULL(F.ID,		ISNULL(U.ID,		M.ID))			ID,
ISNULL(F.name,		ISNULL(U.name,		M.name))		name,
ISNULL(F.DBoBJECT,	ISNULL(U.DBoBJECT,	M.DBoBJECT))	dbObject,
isnull(F.Fav, 0) Fav,
isnull(U.Users, 0) Users,
isnull(M.Me, 0) Me,
ISNULL(F.API,		ISNULL(U.API,		M.API))			API,
ISNULL(F.metaData,	ISNULL(U.metaData,	M.metaData))	metaData
FROM	(
SELECT	DISTINCT
Q.IDpNetConDin ID,
Q.Nombre name,
Q.ObjetoBase DBoBJECT,
Q.APIGetString API,
Q.JSONMetaData metaData,
1 Fav
FROM	pNetConDin Q LEFT JOIN pNetConDinFavs F ON Q.IDpNetConDin = F.IDpNetConDin
WHERE	(F.IDUsuario = @IDUsuario OR q.IDUsuario = @IDUsuario) AND (F.IDUsuarioTipo = @IDUsuarioTipo OR Q.IDUsuarioTipo = @IDUsuarioTipo) AND ISNULL(Q.Favorito, 0) = 1
) AS F
FULL JOIN (
SELECT	DISTINCT
Q.IDpNetConDin ID,
Q.Nombre name,
Q.ObjetoBase DBoBJECT,
Q.APIGetString API,
Q.JSONMetaData metaData,
1 Users
FROM	pNetConDin Q LEFT JOIN pNetConDinFavs F ON Q.IDpNetConDin = F.IDpNetConDin
WHERE	ISNULL(Q.Privado, 0) = 0
) AS U ON F.ID = U.ID
FULL JOIN (
SELECT	DISTINCT
Q.IDpNetConDin ID,
Q.Nombre name,
Q.ObjetoBase DBoBJECT,
Q.APIGetString API,
Q.JSONMetaData metaData,
1 Me
FROM	pNetConDin Q LEFT JOIN pNetConDinFavs F ON Q.IDpNetConDin = F.IDpNetConDin
WHERE	(F.IDUsuario = @IDUsuario OR q.IDUsuario = @IDUsuario) AND (F.IDUsuarioTipo = @IDUsuarioTipo OR Q.IDUsuarioTipo = @IDUsuarioTipo) AND ISNULL(Q.Privado, 0) = 1
) AS M ON U.ID = M.ID OR F.ID = M.ID
ORDER BY name
SET NOCOUNT OFF
RETURN
END

