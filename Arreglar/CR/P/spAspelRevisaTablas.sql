SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelRevisaTablas]

AS BEGIN
DECLARE
@Cuenta		varchar(50)
/****** AspelWarnings ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspelWarnings]') AND type in (N'U'))
DROP TABLE [dbo].[AspelWarnings]
CREATE TABLE [dbo].[AspelWarnings](
[Id] [int] IDENTITY(1,1) NOT NULL,
[Descripcion] [varchar](100) COLLATE Database_Default NULL,
CONSTRAINT [PK_AspelWarnings] PRIMARY KEY CLUSTERED
(
[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
SELECT @Cuenta = COUNT(*) FROM AgenteCat
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Categorías de Agentes')
SELECT @Cuenta = COUNT(*) FROM Agente
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Agentes')
SELECT @Cuenta = COUNT(*) FROM AlmGrupo
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Grupos de Almacenes')
SELECT @Cuenta = COUNT(*) FROM Alm
IF @Cuenta > 1
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-1) + ' Registros en el Catálogo de Almacenes')
SELECT @Cuenta = COUNT(*) FROM ArtCat
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Categorías de Artículos')
SELECT @Cuenta = COUNT(*) FROM ArtLinea
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Categorías de Líneas de Artículos')
SELECT @Cuenta = COUNT(*) FROM Art
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Artículos')
SELECT @Cuenta = COUNT(*) FROM CteCat
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Categorías de Clientes')
SELECT @Cuenta = COUNT(*) FROM CteGrupo
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Grupos de Clientes')
SELECT @Cuenta = COUNT(*) FROM Cte
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Clientes')
SELECT @Cuenta = COUNT(*) FROM Condicion
IF @Cuenta > 1
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-1) + ' Registros en el Catálogo de Condiciones')
SELECT @Cuenta = COUNT(*) FROM Descuento
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Descuentos')
SELECT @Cuenta = COUNT(*) FROM CteFam
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Familias de Clientes')
SELECT @Cuenta = COUNT(*) FROM COMPRA
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Compras')
SELECT @Cuenta = COUNT(*) FROM COMPRAD
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalle de Compras')
SELECT @Cuenta = COUNT(*) FROM CTA
IF @Cuenta > 17
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-17) + ' Registros en el Catálogo de Cuentas')
SELECT @Cuenta = COUNT(*) FROM CXC
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en Cuentas por Cobrar')
SELECT @Cuenta = COUNT(*) FROM CXP
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Cuentas por Pagar')
SELECT @Cuenta = COUNT(*) FROM SerieLote
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Series Lote')
SELECT @Cuenta = COUNT(*) FROM INV
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Movimientos de Inventarios')
SELECT @Cuenta = COUNT(*) FROM SerieLoteMov
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Movimientos de Serie Lote')
SELECT @Cuenta = COUNT(*) FROM INVD
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalle de Movimientos de Inventarios')
SELECT @Cuenta = COUNT(*) FROM Mon
IF @Cuenta > 1
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta-1) + ' Registros en Catálogos de Monedas')
SELECT @Cuenta = COUNT(*) FROM CONT
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Pólizas')
SELECT @Cuenta = COUNT(*) FROM CONTD
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalles de Pólizas')
SELECT @Cuenta = COUNT(*) FROM ProvCat
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Categorías de Proveedores')
SELECT @Cuenta = COUNT(*) FROM ProvFam
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Familias de Proveedores')
SELECT @Cuenta = COUNT(*) FROM Prov
IF @Cuenta > 6
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-6) + ' Registros en el Catálogo de Proveedores')
SELECT @Cuenta = COUNT(*) FROM ArtUnidad
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Catálogo de Unidades de Artículos')
SELECT @Cuenta = COUNT(*) FROM VENTA
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Ventas')
SELECT @Cuenta = COUNT(*) FROM VENTAD
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalles de Ventas')
SELECT * FROM aspelwarnings
END

