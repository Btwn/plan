SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaPagoComparaMes
@Empresa        varchar(5)

AS
BEGIN
DECLARE
@Servidor         varchar(50),
@BD               varchar(50),
@Comando          varchar(1000)
SELECT @Servidor = ecm.Servidor, @BD = ecm.BD
FROM EmpresaCfgMES ecm  WITH (NOLOCK)
WHERE ecm.Empresa = @Empresa
CREATE TABLE #FPMES
(Codigo varchar(50))
SELECT @Comando = 'INSERT INTO #FPMES(Codigo) SELECT Codigo FROM  WITH (NOLOCK)  [' + @Servidor + '].' + @BD + '.dbo.MFormaPago'
EXEC(@Comando)
SELECT fp.FormaPago, f.Codigo
FROM FormaPago fp  WITH (NOLOCK)
LEFT OUTER JOIN #FPMES f ON fp.FormaPago = f.Codigo
ORDER BY fp.FormaPago
RETURN
END

