/*
Cuando se dispara el trigger busca si existe otro cliente con rfc repetido, y si encuentra otro manda un error
como tenemos muchos clientes con este caso
SELECT RFC,COUNT(Cliente)
FROM Cte
GROUP BY RFC
HAVING COUNT(Cliente) > 1
ORDER BY 2 DESC
*/
DISABLE TRIGGER tgCteAC ON Cte
GO

/*
Esta desabilitado tambien en produccion
*/
DISABLE TRIGGER tgCtePerfil ON Cte
GO

/*
Trigger que no permite volver a dar de alta a un usuario
*/
DISABLE TRIGGER tgInforUsuarioABC ON Usuario