SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaAgentes]

AS BEGIN
DECLARE	@Observaciones			varchar(30),
@Sucursal				varchar(30)
SELECT @Observaciones = Valor FROM AspelCfg WITH (NOLOCK) WHERE Descripcion = 'Observaciones'
IF NOT EXISTS(SELECT Categoria FROM AgenteCat WITH (NOLOCK) WHERE Categoria = @Observaciones)
INSERT INTO AgenteCat (Categoria) VALUES (@Observaciones)
SELECT @Sucursal = Valor FROM AspelCfg WITH (NOLOCK) WHERE Descripcion = 'Sucursal'
INSERT INTO Agente (Agente, Nombre, Tipo, Estatus, TipoComision, Porcentaje, eMail, UltimoCambio, Categoria, SucursalEmpresa, Familia)
SELECT Valor, Nombre, Tipo, Estatus, TipoComision, Porcentaje*100, eMail, getdate(), @Observaciones, @Sucursal, Familia
FROM AspelCargaProp WITH (NOLOCK)
WHERE Campo = 'Agente' and Valor not in (select Agente from agente WITH (NOLOCK))
END

