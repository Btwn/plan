SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReplicaTema
@Tema		varchar(50),
@Tabla		varchar(100),
@Campo		varchar(100),
@Campo2		varchar(100) = NULL,
@Valor2		varchar(100) = NULL,
@Campo3		varchar(100) = NULL,
@Valor3		varchar(100) = NULL,
@Campo4		varchar(100) = NULL,
@Valor4		varchar(100) = NULL,
@Campo5		varchar(100) = NULL,
@Valor5		varchar(100) = NULL,
@Principal	bit	= 0

AS BEGIN
DECLARE
@SQL	varchar(8000),
@WHERE	varchar(8000),
@Trigger	varchar(255)
IF (SELECT ModuloCentral FROM Version) = 0 RETURN
SELECT @Campo2 = NULLIF(RTRIM(@Campo2), ''), @Valor2 = NULLIF(RTRIM(@Valor2), ''),
@Campo3 = NULLIF(RTRIM(@Campo3), ''), @Valor3 = NULLIF(RTRIM(@Valor3), ''),
@Campo4 = NULLIF(RTRIM(@Campo4), ''), @Valor4 = NULLIF(RTRIM(@Valor4), ''),
@Campo5 = NULLIF(RTRIM(@Campo5), ''), @Valor5 = NULLIF(RTRIM(@Valor5), '')
IF @Principal = 1 DELETE CfgModuloCentralReplicaTabla WHERE Tema = @Tema
INSERT CfgModuloCentralReplicaTabla (
Tema,  Tabla,  Principal,  Campo,  Campo2,  Valor2,  Campo3,  Valor3,  Campo4,  Valor4,  Campo5,  Valor5)
VALUES (@Tema, @Tabla, @Principal, @Campo, @Campo2, @Valor2, @Campo3, @Valor3, @Campo4, @Valor4, @Campo5, @Valor5)
SELECT @Trigger = 'dbo.tg'+@Tabla+'Replica'+@Tema
SELECT @WHERE = ''
IF @Campo2 IS NOT NULL SELECT @WHERE = 'WHERE ' + @Campo2 + '=' + @Valor2
IF @Campo3 IS NOT NULL SELECT @WHERE = @WHERE + ' AND ' + @Campo3 + '=' + @Valor3
IF @Campo4 IS NOT NULL SELECT @WHERE = @WHERE + ' AND ' + @Campo4 + '=' + @Valor4
IF @Campo5 IS NOT NULL SELECT @WHERE = @WHERE + ' AND ' + @Campo5 + '=' + @Valor5
SELECT @SQL = 'spDROP_TRIGGER '''+@Trigger+''''
EXEC (@SQL)
SELECT @SQL =
'CREATE TRIGGER '+@Trigger+' ON '+@Tabla+'

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@Llave varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF (SELECT Replica FROM Version) = 1 AND EXISTS(SELECT * FROM CfgModuloCentralReplica WHERE Tema = "'+@Tema+'" AND Estatus="ACTIVO")
BEGIN
SELECT @Llave = '+@Campo+' FROM INSERTED '+@WHERE+'
IF @@ROWCOUNT = 0
SELECT @Llave = '+@Campo+' FROM DELETED '+@WHERE+'
IF NOT EXISTS(SELECT * FROM mcReplicaSalida WHERE Tema="'+@Tema+'" AND Llave=@Llave AND Estatus="SINPROCESAR")
BEGIN
INSERT mcReplicaSalida (Tema, Llave, Estatus,EstatusFecha) VALUES ("'+@Tema+'", @Llave, "SINPROCESAR", GETDATE())
END
END
END'
EXEC (@SQL)
RETURN
END

