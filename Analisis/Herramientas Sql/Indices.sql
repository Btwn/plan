
USE [IntelisisTmp]
GO
CREATE NONCLUSTERED INDEX IND_UsuarioMenuPrincipal_Usuario_item
ON [dbo].[UsuarioMenuPrincipal] ([Usuario],[item])

GO


CREATE NONCLUSTERED INDEX IND_UsuarioReportes_Usuario_item
ON [dbo].UsuarioReportes ([Usuario],[item])

GO


CREATE NONCLUSTERED INDEX IND_UsuarioMovsConsulta_Usuario_item
ON [dbo].UsuarioMovsConsulta ([Usuario],[item])

GO
