USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[V_MaviCanceladosConcentradoCortesCaja]    Script Date: 04/05/2019 11:44:00 a. m. ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




/*Vista Movimientos Cancelados */
ALTER View [dbo].[V_MaviCanceladosConcentradoCortesCaja] As
Select
	UC.Tienda,UC.UsuarioCancela,TUC.Nombre,UC.Origen,UC.OrigenId,
	UC.FechaCancelacion,UC.UsuCaj,UC.Mov,
	UC.MovId,UC.Importe,
	UC.Contacto, UC.NomCliente, UC.Estatus
From (Select
	D.FechaCancelacion,
	D.FechaRegistro,
	FormaPago=IsNull(D.FormaPago,DD.FormaPago),
	D.Mov, D.MovId, D.Origen,D.OrigenId,
	Importe=IsNull(D.Importe,DD.Importe),
	Tienda=D.Sucursal,
	D.Estatus,
	UsuCaj=D.Usuario,
	UsuarioCancela=IsNull(Isnull(MTG.Usuario,MTCX.Usuario),MTD.Usuario),
	D.Contacto,
	NomCliente=Cte.Nombre
From Dinero D WITH(NOLOCK)
	Left join DineroD DD WITH(NOLOCK) On D.Id = DD.Id
	Left Join Gasto G WITH(NOLOCK) On G.Mov = D.Origen And G.MovId = D.OrigenId --Llave Gastos
	Left Join MovTiempo MTG WITH(NOLOCK) On MTG.ID = G.Id And MTG.Modulo = 'GAS' And MTG.Estatus = 'CANCELADO'
	Left Join CXC WITH(NOLOCK) On CXC.Mov = D.Origen And CXC.MovId = D.OrigenId -- LLave de CXC
	Left Join MovTiempo MTCX WITH(NOLOCK) On MTCX.Id = CXC.Id And MTCX.Modulo = 'CXC' And MTCX.Estatus = 'CANCELADO'
	Left Join MovTiempo MTD WITH(NOLOCK) On MTD.Id = D.Id And MTD.Modulo = 'DIN' And MTD.Estatus = 'CANCELADO'
	Left Join Cte WITH(NOLOCK) ON D.Contacto = Cte.Cliente And D.ContactoTipo = 'Cliente'--Nombre Cliente
Where D.Estatus = 'CANCELADO'
	--And D.OrigenTipo In ('CXC','GAS','DIN')
--	And (D.Mov In ('Ingreso','Egreso')
--	Or D.Mov In ('Corte Caja','Apertura Caja')
--	Or D.Mov In ('Faltante Caja','Sobrante Caja')
--	Or D.Mov In ('Recoleccion Caja','Corte Parcial Caja'))
) As UC
	Left Join Usuario TUC WITH(NOLOCK) ON UC.UsuarioCancela = TUC.Usuario


GO


