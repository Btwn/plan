SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnBuscaMovs(@Modulo varchar(20), @ID int, @Empresa varchar(5))
RETURNS @MovsA TABLE(Num int IDENTITY(1,1), ID int, Modulo varchar(5), Mov varchar(20),MovID varchar(20),Tipo int)
AS BEGIN
DECLARE @Movs TABLE(Num int IDENTITY(1,1), ID int, Modulo varchar(5), Mov varchar(20),MovID varchar(20),Tipo int)
IF EXISTS (SELECT * FROM MovFlujo WITH (NOLOCK) WHERE OID = @ID AND OModulo = @Modulo AND Empresa = @Empresa)
BEGIN
WITH Cte
AS (
SELECT OID, OModulo, OMov, OMovID, DID, DModulo, DMov, DMovID,  0 AS NIVEL
FROM dbo.movflujo WITH (NOLOCK)
WHERE OID = @ID AND OModulo = @Modulo AND Empresa = @Empresa
UNION ALL
SELECT e.OID, e.OModulo, e.OMov, e.OMovID, e.DID, e.DModulo, e.DMov, e.DMovID, 1+Cte.Nivel
FROM dbo.movflujo AS e WITH (NOLOCK)
JOIN cte ON e.OID = cte.DID AND e.OModulo = cte.DMODULO
)
INSERT @Movs( ID,  Modulo,  Mov,  MovID, Tipo)
SELECT DISTINCT OID, OModulo, OMov, OMovID, 1
FROM Cte WITH (NOLOCK) order by 1,5;
WITH Cte
AS (
SELECT OID, OModulo, OMov, OMovID, DID, DModulo, DMov, DMovID,  0 AS NIVEL
FROM dbo.movflujo WITH (NOLOCK)
WHERE OID = @ID AND OModulo = @Modulo AND Empresa = @Empresa
UNION ALL
SELECT e.OID, e.OModulo, e.OMov, e.OMovID, e.DID, e.DModulo, e.DMov, e.DMovID, 1+Cte.Nivel
FROM dbo.movflujo AS e WITH (NOLOCK)
JOIN cte ON e.OID = cte.DID AND e.OModulo = cte.DMODULO
)
INSERT @Movs( ID,  Modulo,  Mov,  MovID, Tipo)
SELECT DISTINCT DID, DModulo, DMov, DMovID, 1
FROM Cte WITH (NOLOCK)
EXCEPT
SELECT ID,  Modulo,  Mov,  MovID, Tipo
FROM @Movs
END
IF NOT EXISTS (SELECT * FROM @Movs)
BEGIN
IF @Modulo = 'NOM'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM Nomina WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXP'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM CXP WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'VTAS'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM Venta WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXC'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM CXC WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'GAS'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM Gasto WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'COMS'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM Compra WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'DIN'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM Dinero WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CONT'
INSERT INTO @Movs( ID,  Modulo,  Mov,  MovID, Tipo) SELECT ID, @Modulo, Mov, MovID, 2 FROM Cont WITH (NOLOCK) WHERE ID = @ID
END
INSERT INTO @MovsA(ID, Modulo,  Mov,  MovID, Tipo)
SELECT DISTINCT ID, Modulo,  Mov,  MovID, Tipo
FROM @Movs
RETURN
END

