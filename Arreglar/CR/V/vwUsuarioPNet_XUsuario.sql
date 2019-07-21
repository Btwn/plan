SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwUsuarioPNet_XUsuario
AS
SELECT P.IDUsuario, P.Usuario, P.IDUsuarioTipo, T.Descripcion AS DescripcionTipo, P.eMail, P.Nombre AS Apodo, P.UrlImagen, P.Estatus, P.FechaRegistro, U.Nombre, U.Contrasena,
P.IDRole, P.PrimeraVez, P.Empresa, P.Sucursal
FROM dbo.pNetUsuario AS P INNER JOIN
dbo.Usuario AS U ON P.Usuario = U.Usuario INNER JOIN
dbo.pNetUsuarioTipo AS T ON P.IDUsuarioTipo = T.IDUsuarioTipo
WHERE U.Estatus = 'ALTA' AND P.IDUsuarioTipo = 1
UNION
SELECT P.IDUsuario, P.Usuario, P.IDUsuarioTipo, T.Descripcion AS DescripcionTipo, P.eMail, P.Nombre AS Apodo, P.UrlImagen, P.Estatus, P.FechaRegistro, E.Nombre, E.Contrasena,
P.IDRole, P.PrimeraVez, P.Empresa, P.Sucursal
FROM dbo.pNetUsuario AS P INNER JOIN
dbo.Personal AS E ON P.Usuario = E.Personal INNER JOIN
dbo.pNetUsuarioTipo AS T ON P.IDUsuarioTipo = T.IDUsuarioTipo
WHERE E.Estatus = 'ALTA' AND P.IDUsuarioTipo = 2
UNION
SELECT P.IDUsuario, P.Usuario, P.IDUsuarioTipo, T.Descripcion AS DescripcionTipo, P.eMail, P.Nombre AS Apodo, P.UrlImagen, P.Estatus, P.FechaRegistro, C.Nombre, C.Contrasena,
P.IDRole, P.PrimeraVez, P.Empresa, P.Sucursal
FROM dbo.pNetUsuario AS P INNER JOIN
dbo.Cte AS C ON P.Usuario = C.Cliente INNER JOIN
dbo.pNetUsuarioTipo AS T ON P.IDUsuarioTipo = T.IDUsuarioTipo
WHERE C.Estatus = 'ALTA' AND P.IDUsuarioTipo = 3
UNION
SELECT P.IDUsuario, P.Usuario, P.IDUsuarioTipo, T.Descripcion AS DescripcionTipo, P.eMail, P.Nombre AS Apodo, P.UrlImagen, P.Estatus, P.FechaRegistro, R.Nombre, R.Contrasena,
P.IDRole, P.PrimeraVez, P.Empresa, P.Sucursal
FROM dbo.pNetUsuario AS P INNER JOIN
dbo.Prov AS R ON P.Usuario = R.Proveedor INNER JOIN
dbo.pNetUsuarioTipo AS T ON P.IDUsuarioTipo = T.IDUsuarioTipo
WHERE R.Estatus = 'ALTA' AND P.IDUsuarioTipo IN (4,5)
UNION
SELECT P.IDUsuario, P.Usuario, P.IDUsuarioTipo, T.Descripcion AS DescripcionTipo, P.eMail, P.Nombre AS Apodo, P.UrlImagen, P.Estatus, P.FechaRegistro, U.Nombre, U.Contrasena,
P.IDRole, P.PrimeraVez, P.Empresa, P.Sucursal
FROM   dbo.pNetUsuario AS P INNER JOIN
dbo.Usuario AS U ON P.Usuario = U.Usuario INNER JOIN
dbo.pNetUsuarioTipo AS T ON P.IDUsuarioTipo = T.IDUsuarioTipo
WHERE  U.Estatus = 'ALTA' AND P.IDUsuarioTipo = 6

