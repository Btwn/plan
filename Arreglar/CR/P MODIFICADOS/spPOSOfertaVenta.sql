SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSOfertaVenta
@ID		varchar(50)

AS
BEGIN
DECLARE
@Region				varchar(50),
@Alm				varchar(10),
@AlmGrupo			varchar(50),
@Cte				varchar(10),
@CteCategoria		varchar(50),
@CteGrupo			varchar(50),
@CteFamilia			varchar(50),
@CteZona			varchar(50),
@Agente				varchar(10),
@AgenteCategoria	varchar(50),
@AgenteGrupo		varchar(50),
@AgenteFamilia		varchar(50),
@Mov				varchar(20),
@Moneda				varchar(10),
@CondicionPago		varchar(50),
@FormaPagoTipo		varchar(50),
@FormaEnvio			varchar(50),
@ListaPrecios		varchar(50)
SELECT	@Region = s.Region, @Alm = e.Almacen, @AlmGrupo = a.Grupo,
@Cte = e.Cliente, @CteCategoria = c.Categoria, @CteGrupo = c.Grupo, @CteFamilia = c.Familia, @CteZona = c.Zona,
@Mov = e.Mov, @Moneda = e.Moneda, @CondicionPago = e.Condicion, @FormaPagoTipo = NULL, 
@FormaEnvio = e.FormaEnvio, @ListaPrecios = e.ListaPreciosEsp,
@Agente = e.Agente, @AgenteCategoria = ag.Categoria, @AgenteGrupo = ag.Grupo, @AgenteFamilia = ag.Familia
FROM POSL e
JOIN Sucursal s ON s.Sucursal = e.Sucursal
JOIN Cte c ON c.Cliente = e.Cliente
JOIN Alm a ON a.Almacen = e.Almacen
LEFT OUTER JOIN Agente ag ON ag.Agente = e.Agente
WHERE e.ID = @ID
INSERT #Venta (Campo, Valor) VALUES ('Region', 		@Region)
INSERT #Venta (Campo, Valor) VALUES ('Almacen', 		@Alm)
INSERT #Venta (Campo, Valor) VALUES ('Grupo Almacen', 	@AlmGrupo)
INSERT #Venta (Campo, Valor) VALUES ('Cliente', 		@Cte)
INSERT #Venta (Campo, Valor) VALUES ('Categoria Cliente', 	@CteCategoria)
INSERT #Venta (Campo, Valor) VALUES ('Grupo Cliente', 	@CteGrupo)
INSERT #Venta (Campo, Valor) VALUES ('Familia Cliente', 	@CteFamilia)
INSERT #Venta (Campo, Valor) VALUES ('Zona Cliente', 		@CteZona)
INSERT #Venta (Campo, Valor) VALUES ('Agente', 		@Agente)
INSERT #Venta (Campo, Valor) VALUES ('Categoria Agente', 	@AgenteCategoria)
INSERT #Venta (Campo, Valor) VALUES ('Grupo Agente', 		@AgenteGrupo)
INSERT #Venta (Campo, Valor) VALUES ('Familia Agente', 	@AgenteFamilia)
INSERT #Venta (Campo, Valor) VALUES ('Movimiento', 		@Mov)
INSERT #Venta (Campo, Valor) VALUES ('Moneda', 		@Moneda)
INSERT #Venta (Campo, Valor) VALUES ('Condicion Pago',	@CondicionPago)
INSERT #Venta (Campo, Valor) VALUES ('Tipo Forma Pago', 	@FormaPagoTipo)
INSERT #Venta (Campo, Valor) VALUES ('Forma Envio', 		@FormaEnvio)
INSERT #Venta (Campo, Valor) VALUES ('Lista Precios', 	@ListaPrecios)
UPDATE #Venta SET Valor = '' WHERE Valor IS NULL
RETURN
END

