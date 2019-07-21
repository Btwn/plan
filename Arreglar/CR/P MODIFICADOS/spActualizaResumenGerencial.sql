SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizaResumenGerencial
@MovTipo		varchar(30),
@Empresa		varchar(80),
@Mov			varchar(20),
@Mov2			varchar(20),
@Modulo			varchar(20),
@Moneda			varchar(20),
@Moneda1		varchar(20),
@Usuario		varchar(10)

AS
IF @Modulo = 'CXC' AND @MovTipo = 'CXC.F'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'CXC' AND MovTipo = 'CXC.F'
INSERT ResumenGerencial VALUES('CXC','Factura', 0, 0, 0, 0, 0, 0, 'CXC.F', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) SET TotalMov = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
JOIN Cxc WITH(NOLOCK) ON Cxc.ID = CxcInfo.ID
WHERE CxcInfo.Empresa = @Empresa
AND Cxc.Usuario = @Usuario
AND ISNULL(cxcInfo.Saldo,0) > 0),
ImportePesos = (SELECT ISNULL(SUM(CxcInfo.Saldo), 0.0)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Moneda = @Moneda),
ImporteDolares = (SELECT ISNULL(SUM(CxcInfo.Saldo), 0.0)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Moneda = @Moneda1),
TotalVencido = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND ISNULL(CxcInfo.Vencimiento, '19010101') < GETDATE()
AND ISNULL(cxcInfo.Saldo,0) > 0),
TotalPorVencer = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND ISNULL(CxcInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
AND ISNULL(cxcInfo.Saldo,0) > 0),
TotalEnTiempo = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND ISNULL(CxcInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE())
AND ISNULL(cxcInfo.Saldo,0) > 0)
WHERE Modulo = @Modulo AND Mov = @Mov
END
ELSE IF @Modulo = 'CXC' AND @MovTipo = 'CXC.D'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'CXC' AND MovTipo = 'CXC.D'
INSERT ResumenGerencial VALUES('CXC','Documento', 0, 0, 0, 0, 0, 0, 'CXC.D', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) SET TotalMov = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
JOIN Cxc WITH(NOLOCK) ON Cxc.ID = CxcInfo.ID
WHERE CxcInfo.Empresa = @Empresa
AND Cxc.Usuario = @Usuario
AND ISNULL(cxcInfo.Saldo,0) > 0),
ImportePesos = (SELECT ISNULL(SUM(CxcInfo.Saldo), 0.0)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Moneda = @Moneda),
ImporteDolares = (SELECT ISNULL(SUM(CxcInfo.Saldo), 0.0)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Moneda = @Moneda1),
TotalVencido = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND ISNULL(CxcInfo.Vencimiento, '19010101') < GETDATE()
AND ISNULL(cxcInfo.Saldo,0) > 0),
TotalPorVencer = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND ISNULL(CxcInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
AND ISNULL(cxcInfo.Saldo,0) > 0),
TotalEnTiempo = (SELECT COUNT(*)
FROM CxcInfo WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON CxcInfo.Cliente=Cte.Cliente
JOIN MovTipo WITH(NOLOCK) ON MovTipo.Mov = CxcInfo.Mov AND MovTipo.Clave = @MovTipo
WHERE CxcInfo.Empresa = @Empresa
AND ISNULL(CxcInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE())
AND ISNULL(cxcInfo.Saldo,0) > 0)
WHERE Modulo = @Modulo AND Mov = @Mov
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.C'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'VTAS' AND MovTipo = 'VTAS.C'
INSERT ResumenGerencial VALUES('VTAS','Cotizacion', 0, 0, 0, 0, 0, 0, 'VTAS.C', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) SET TotalMov = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND ISNULL(VentaPendiente.Importe, 0) >0 ),
ImportePesos = (SELECT ISNULL(SUM(VentaPendiente.Importe),0)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Moneda=@Moneda),
ImporteDolares = (SELECT ISNULL(SUM(VentaPendiente.Importe),0)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Moneda=@Moneda1),
TotalVencido = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()
AND ISNULL(VentaPendiente.Importe,0) > 0 ),
TotalPorVencer = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
AND ISNULL(VentaPendiente.Importe,0) > 0),
TotalEnTiempo = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE())
AND ISNULL(VentaPendiente.Importe,0) > 0)
WHERE Modulo = @Modulo AND MovTipo = @MovTipo
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.P'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'VTAS' AND MovTipo = 'VTAS.P'
INSERT ResumenGerencial VALUES('VTAS','Pedido', 0, 0, 0, 0, 0, 0, 'VTAS.P', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) SET TotalMov = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Importe > 0),
ImportePesos = (SELECT ISNULL(SUM(VentaPendiente.Importe),0)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Importe > 0
AND VentaPendiente.Moneda=@Moneda),
ImporteDolares = (SELECT ISNULL(SUM(VentaPendiente.Importe),0)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Importe > 0
AND VentaPendiente.Moneda=@Moneda1),
TotalVencido = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Importe > 0
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()),
TotalPorVencer = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Importe > 0
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())),
TotalEnTiempo = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Importe > 0
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()))
WHERE Modulo = @Modulo AND MovTipo = @MovTipo
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.S'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'VTAS' AND MovTipo = 'VTAS.S'
INSERT ResumenGerencial VALUES('VTAS','Servicio', 0, 0, 0, 0, 0, 0, 'VTAS.S', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) SET TotalMov = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Estatus = 'CONFIRMAR'
AND VentaPendiente.Importe > 0),
ImportePesos = (SELECT ISNULL(SUM(VentaPendiente.Importe),0)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Estatus = 'CONFIRMAR'
AND VentaPendiente.Moneda = @Moneda),
ImporteDolares = (SELECT ISNULL(SUM(VentaPendiente.Importe),0)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Estatus = 'CONFIRMAR'
AND VentaPendiente.Moneda = @Moneda1),
TotalVencido = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Estatus = 'CONFIRMAR'
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()
AND VentaPendiente.Importe > 0),
TotalPorVencer = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Estatus = 'CONFIRMAR'
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
AND VentaPendiente.Importe > 0),
TotalEnTiempo = (SELECT COUNT(*)
FROM VentaPendiente WITH(NOLOCK) JOIN Cte WITH(NOLOCK) ON VentaPendiente.Cliente = Cte.Cliente
JOIN Venta WITH(NOLOCK) ON VentaPendiente.ID = Venta.ID
WHERE VentaPendiente.Empresa = @Empresa
AND VentaPendiente.MovTipo = @MovTipo
AND Venta.Usuario = @Usuario
AND VentaPendiente.Estatus = 'CONFIRMAR'
AND ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE())
AND VentaPendiente.Importe > 0)
WHERE Modulo = @Modulo AND MovTipo = @MovTipo
END
ELSE IF @Modulo = 'CXP'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'CXP' AND MovTipo = 'CXP.P'
INSERT ResumenGerencial VALUES('CXP','Pagos', 0, 0, 0, 0, 0, 0, 'CXP.P', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) SET TotalMov = (SELECT COUNT(*)
FROM CxpInfo WITH(NOLOCK) JOIN Prov WITH(NOLOCK) ON CxpInfo.Proveedor = Prov.Proveedor
JOIN Cxp WITH(NOLOCK) ON Cxp.ID = CxpInfo.ID
WHERE CxpInfo.Empresa = @Empresa
AND Cxp.Usuario = @Usuario
AND CxpInfo.Mov IN (@Mov, @Mov2)),
ImportePesos = (SELECT ISNULL(SUM(CxpInfo.Saldo),0)
FROM CxpInfo WITH(NOLOCK) JOIN Prov WITH(NOLOCK) ON CxpInfo.Proveedor = Prov.Proveedor
JOIN Cxp WITH(NOLOCK) ON Cxp.ID = CxpInfo.ID
WHERE CxpInfo.Empresa = @Empresa
AND Cxp.Usuario = @Usuario
AND CxpInfo.Mov IN (@Mov, @Mov2)
AND CxpInfo.Moneda = @Moneda),
ImporteDolares = (SELECT ISNULL(SUM(CxpInfo.Saldo),0)
FROM CxpInfo WITH(NOLOCK) JOIN Prov WITH(NOLOCK) ON CxpInfo.Proveedor = Prov.Proveedor
JOIN Cxp WITH(NOLOCK) ON Cxp.ID = CxpInfo.ID
WHERE CxpInfo.Empresa = @Empresa
AND Cxp.Usuario = @Usuario
AND CxpInfo.Mov IN (@Mov, @Mov2)
AND CxpInfo.Moneda = @Moneda1),
TotalVencido = (SELECT COUNT(*)
FROM CxpInfo WITH(NOLOCK) JOIN Prov WITH(NOLOCK) ON CxpInfo.Proveedor = Prov.Proveedor
JOIN Cxp WITH(NOLOCK) ON Cxp.ID = CxpInfo.ID
WHERE CxpInfo.Empresa = @Empresa
AND Cxp.Usuario = @Usuario
AND CxpInfo.Mov IN (@Mov, @Mov2)
AND ISNULL(CxpInfo.Vencimiento, '19010101') < GETDATE()),
TotalPorVencer = (SELECT COUNT(*)
FROM CxpInfo WITH(NOLOCK) JOIN Prov WITH(NOLOCK) ON CxpInfo.Proveedor = Prov.Proveedor
JOIN Cxp WITH(NOLOCK) ON Cxp.ID = CxpInfo.ID
WHERE CxpInfo.Empresa = @Empresa
AND Cxp.Usuario = @Usuario
AND CxpInfo.Mov IN (@Mov, @Mov2)
AND ISNULL(CxpInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())),
TotalEnTiempo = (SELECT COUNT(*)
FROM CxpInfo WITH(NOLOCK) JOIN Prov WITH(NOLOCK) ON CxpInfo.Proveedor = Prov.Proveedor
JOIN Cxp WITH(NOLOCK) ON Cxp.ID = CxpInfo.ID
WHERE CxpInfo.Empresa = @Empresa
AND Cxp.Usuario = @Usuario
AND CxpInfo.Mov IN (@Mov, @Mov2)
AND ISNULL(CxpInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE()))
WHERE Modulo = @Modulo
END
ELSE IF @Modulo = 'COMS'
BEGIN
DELETE ResumenGerencial WHERE Usuario = @Usuario AND Modulo = 'COMS' AND MovTipo = 'COMS.FL'
INSERT ResumenGerencial VALUES('COMS','Compras', 0, 0, 0, 0, 0, 0, 'COMS.FL', @Usuario)
UPDATE ResumenGerencial WITH(ROWLOCK) set TotalMov = (SELECT COUNT(*)
FROM CompraPendiente WITH(NOLOCK) JOIN Compra WITH(NOLOCK) ON CompraPendiente.ID = Compra.ID
WHERE CompraPendiente.Empresa = @Empresa
AND Compra.Usuario = @Usuario
AND CompraPendiente.Clave LIKE ('COMS.O%')
AND CompraPendiente.Saldo > 0),
ImportePesos = (SELECT ISNULL(SUM(CompraPendiente.Saldo),0)
FROM CompraPendiente WITH(NOLOCK) JOIN Compra WITH(NOLOCK) ON CompraPendiente.ID = Compra.ID
WHERE CompraPendiente.Empresa = @Empresa
AND Compra.Usuario = @Usuario
AND CompraPendiente.Clave LIKE ('COMS.O%')
AND CompraPendiente.Moneda=@Moneda
AND CompraPendiente.Saldo > 0),
ImporteDolares = (SELECT ISNULL(SUM(CompraPendiente.Saldo),0)
FROM CompraPendiente WITH(NOLOCK) JOIN Compra WITH(NOLOCK) ON CompraPendiente.ID = Compra.ID
WHERE CompraPendiente.Empresa = @Empresa
AND Compra.Usuario = @Usuario
AND CompraPendiente.Clave LIKE ('COMS.O%')
AND CompraPendiente.Moneda=@Moneda1
AND CompraPendiente.Saldo > 0),
TotalVencido = (SELECT COUNT(*)
FROM CompraPendiente WITH(NOLOCK) JOIN Compra WITH(NOLOCK) ON CompraPendiente.ID = Compra.ID
WHERE CompraPendiente.Empresa = @Empresa
AND Compra.Usuario = @Usuario
AND CompraPendiente.Clave LIKE ('COMS.O%')
AND ISNULL(CompraPendiente.FechaRequerida, '19010101') < GETDATE()
AND CompraPendiente.Saldo > 0),
TotalPorVencer = (SELECT COUNT(*)
FROM CompraPendiente WITH(NOLOCK) JOIN Compra WITH(NOLOCK) ON CompraPendiente.ID = Compra.ID
WHERE CompraPendiente.Empresa = @Empresa
AND Compra.Usuario = @Usuario
AND CompraPendiente.Clave LIKE ('COMS.O%')
AND ISNULL(CompraPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
AND CompraPendiente.Saldo > 0),
TotalEnTiempo = (SELECT COUNT(*)
FROM CompraPendiente WITH(NOLOCK) JOIN Compra WITH(NOLOCK) ON CompraPendiente.ID = Compra.ID
WHERE CompraPendiente.Empresa = @Empresa
AND Compra.Usuario = @Usuario
AND CompraPendiente.Clave LIKE ('COMS.O%')
AND ISNULL(CompraPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
AND CompraPendiente.Saldo > 0)
WHERE Modulo = @Modulo
END

