SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE ActualizaGerenciaDetalle
@MovTipo	 varchar(30),
@Empresa	 varchar(80),
@Mov		 varchar(20),
@Mov2		 varchar(20),
@Modulo		 varchar(20),
@Moneda		 varchar(20),
@Moneda1	 varchar(20),
@Usuario	 varchar(20),
@Grupo	 	 varchar(20)

AS
BEGIN
DELETE ResumenGerencialDetalle
IF @Modulo = 'CXC' AND @Grupo NOT IN ('Direccion', 'Sistemas')
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxc', CxcInfo.Id, CxcInfo.Mov, CxcInfo.MovID, Cte.Cliente, Cte.Nombre, Cxc.FechaEmision, Cxc.Concepto, Cxc.Proyecto, Cxc.Uen, Cxc.TipoCambio, Cxc.Usuario, Cxc.Autorizacion, Cxc.Referencia, Cxc.Observaciones, Cxc.CtaDinero, Cxc.Condicion, Cxc.FormaCobro, Cxc.Importe, Cxc.Impuestos, Cxc.Retencion, Cxc.MovAplica, Cxc.MovAplicaID, Cxc.Origen, Cxc.OrigenID,CxcInfo.Vencimiento, CxcInfo.DiasMoratorios, CxcInfo.Saldo, 'ROJO2', Cxc.Moneda
FROM CxcInfo, Cte, Cxc
WHERE CxcInfo.Cliente=Cte.Cliente AND
CxcInfo.ID = Cxc.Id AND
Cxc.Usuario = @Usuario AND
CxcInfo.Empresa=@Empresa AND
ISNULL(CxcInfo.Vencimiento, '19010101') < GETDATE()  AND
CxcInfo.Mov=@Mov AND
ISNULL(cxcInfo.Saldo,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxc', CxcInfo.Id, CxcInfo.Mov, CxcInfo.MovID, Cte.Cliente, Cte.Nombre, Cxc.FechaEmision, Cxc.Concepto, Cxc.Proyecto, Cxc.Uen, Cxc.TipoCambio, Cxc.Usuario, Cxc.Autorizacion, Cxc.Referencia, Cxc.Observaciones, Cxc.CtaDinero, Cxc.Condicion, Cxc.FormaCobro, Cxc.Importe, Cxc.Impuestos, Cxc.Retencion, Cxc.MovAplica, Cxc.MovAplicaID, Cxc.Origen, Cxc.OrigenID,CxcInfo.Vencimiento, CxcInfo.DiasMoratorios, CxcInfo.Saldo, 'AMARILLO2', Cxc.Moneda
FROM CxcInfo, Cte, Cxc
WHERE CxcInfo.Cliente=Cte.Cliente AND
CxcInfo.ID = Cxc.Id AND
Cxc.Usuario = @Usuario AND
CxcInfo.Empresa=@Empresa AND
ISNULL(CxcInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
CxcInfo.Mov=@Mov AND
ISNULL(cxcInfo.Saldo,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxc', CxcInfo.Id, CxcInfo.Mov, CxcInfo.MovID, Cte.Cliente, Cte.Nombre, Cxc.FechaEmision, Cxc.Concepto, Cxc.Proyecto, Cxc.Uen, Cxc.TipoCambio, Cxc.Usuario, Cxc.Autorizacion, Cxc.Referencia, Cxc.Observaciones, Cxc.CtaDinero, Cxc.Condicion, Cxc.FormaCobro, Cxc.Importe, Cxc.Impuestos, Cxc.Retencion, Cxc.MovAplica, Cxc.MovAplicaID, Cxc.Origen, Cxc.OrigenID,CxcInfo.Vencimiento, CxcInfo.DiasMoratorios, CxcInfo.Saldo, 'VERDE2', Cxc.Moneda
FROM CxcInfo, Cte, Cxc
WHERE CxcInfo.Cliente=Cte.Cliente AND
CxcInfo.ID = Cxc.Id AND
Cxc.Usuario = @Usuario AND
CxcInfo.Empresa=@Empresa AND
ISNULL(CxcInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE()) AND
CxcInfo.Mov=@Mov AND
ISNULL(cxcInfo.Saldo,0) > 0
END
ELSE IF @Modulo = 'CXC' AND @Grupo IN ('Direccion', 'Sistemas')
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxc', CxcInfo.Id, CxcInfo.Mov, CxcInfo.MovID, Cte.Cliente, Cte.Nombre, Cxc.FechaEmision, Cxc.Concepto, Cxc.Proyecto, Cxc.Uen, Cxc.TipoCambio, Cxc.Usuario, Cxc.Autorizacion, Cxc.Referencia, Cxc.Observaciones, Cxc.CtaDinero, Cxc.Condicion, Cxc.FormaCobro, Cxc.Importe, Cxc.Impuestos, Cxc.Retencion, Cxc.MovAplica, Cxc.MovAplicaID, Cxc.Origen, Cxc.OrigenID,CxcInfo.Vencimiento, CxcInfo.DiasMoratorios, CxcInfo.Saldo, 'ROJO2', Cxc.Moneda
FROM CxcInfo, Cte, Cxc
WHERE CxcInfo.Cliente=Cte.Cliente AND
CxcInfo.ID = Cxc.Id AND
CxcInfo.Empresa=@Empresa AND
ISNULL(CxcInfo.Vencimiento, '19010101') < GETDATE()  AND
CxcInfo.Mov=@Mov AND
ISNULL(cxcInfo.Saldo,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxc', CxcInfo.Id, CxcInfo.Mov, CxcInfo.MovID, Cte.Cliente, Cte.Nombre, Cxc.FechaEmision, Cxc.Concepto, Cxc.Proyecto, Cxc.Uen, Cxc.TipoCambio, Cxc.Usuario, Cxc.Autorizacion, Cxc.Referencia, Cxc.Observaciones, Cxc.CtaDinero, Cxc.Condicion, Cxc.FormaCobro, Cxc.Importe, Cxc.Impuestos, Cxc.Retencion, Cxc.MovAplica, Cxc.MovAplicaID, Cxc.Origen, Cxc.OrigenID,CxcInfo.Vencimiento, CxcInfo.DiasMoratorios, CxcInfo.Saldo, 'AMARILLO2', Cxc.Moneda
FROM CxcInfo, Cte, Cxc
WHERE CxcInfo.Cliente=Cte.Cliente AND
CxcInfo.ID = Cxc.Id AND
CxcInfo.Empresa=@Empresa AND
ISNULL(CxcInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
CxcInfo.Mov=@Mov AND
ISNULL(cxcInfo.Saldo,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxc', CxcInfo.Id, CxcInfo.Mov, CxcInfo.MovID, Cte.Cliente, Cte.Nombre, Cxc.FechaEmision, Cxc.Concepto, Cxc.Proyecto, Cxc.Uen, Cxc.TipoCambio, Cxc.Usuario, Cxc.Autorizacion, Cxc.Referencia, Cxc.Observaciones, Cxc.CtaDinero, Cxc.Condicion, Cxc.FormaCobro, Cxc.Importe, Cxc.Impuestos, Cxc.Retencion, Cxc.MovAplica, Cxc.MovAplicaID, Cxc.Origen, Cxc.OrigenID,CxcInfo.Vencimiento,
CxcInfo.DiasMoratorios, CxcInfo.Saldo, 'VERDE2', Cxc.Moneda
FROM CxcInfo, Cte, Cxc
WHERE CxcInfo.Cliente=Cte.Cliente AND
CxcInfo.ID = Cxc.Id AND
CxcInfo.Empresa=@Empresa AND
ISNULL(CxcInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE()) AND
CxcInfo.Mov=@Mov AND
ISNULL(cxcInfo.Saldo,0) > 0
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.C'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'ROJO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta, Usuario
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = @Usuario AND
Venta.Usuario = Usuario.Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()  AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'AMARILLO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta, Usuario
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = @Usuario AND
Venta.Usuario = Usuario.Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID  AND
ISNULL(VentaPendiente.Importe,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario,
Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'VERDE2', Venta.Moneda
FROM VentaPendiente, Cte, Venta, Usuario
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = @Usuario AND
Venta.Usuario = Usuario.Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.C'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'ROJO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta, Usuario
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = Usuario.Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()  AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'AMARILLO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta, Usuario
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = Usuario.Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID  AND
ISNULL(VentaPendiente.Importe,0) > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica,
MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'VERDE2', Venta.Moneda
FROM VentaPendiente, Cte, Venta, Usuario
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = Usuario.Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.P'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'ROJO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = @Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()  AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0 AND
CAST(RTRIM(VentaPendiente.Mov) AS varchar(20))+VentaPendiente.MovID NOT IN (
SELECT RTRIM(od.Destino)+od.DestinoID FROM Compra o, CompraD od, MovTipo omt
WHERE o.ID = od.ID AND omt.Mov = o.Mov AND omt.Clave like ('COMS.O%') AND o.Estatus = 'PENDIENTE'
AND od.Destino IS NOT NULL AND od.DestinoID IS NOT NULL )
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'AMARILLO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = @Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID  AND
ISNULL(VentaPendiente.Importe,0) > 0 AND
CAST(RTRIM(VentaPendiente.Mov) AS varchar(20))+VentaPendiente.MovID NOT IN (
SELECT RTRIM(od.Destino)+od.DestinoID FROM Compra o, CompraD od, MovTipo omt
WHERE o.ID = od.ID AND omt.Mov = o.Mov AND omt.Clave like ('COMS.O%') AND o.Estatus = 'PENDIENTE'
AND od.Destino IS NOT NULL AND od.DestinoID IS NOT NULL )
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'VERDE2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
Venta.Usuario = @Usuario AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0 AND
CAST(RTRIM(VentaPendiente.Mov) AS varchar(20))+VentaPendiente.MovID NOT IN (
SELECT RTRIM(od.Destino)+od.DestinoID FROM Compra o, CompraD od, MovTipo omt
WHERE o.ID = od.ID AND omt.Mov = o.Mov AND omt.Clave like ('COMS.O%') AND o.Estatus = 'PENDIENTE'
AND od.Destino IS NOT NULL AND od.DestinoID IS NOT NULL )
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.P' AND @Grupo IN ('Direccion', 'Sistemas')
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'ROJO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()  AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0 AND
CAST(RTRIM(VentaPendiente.Mov) AS varchar(20))+VentaPendiente.MovID NOT IN (
SELECT RTRIM(od.Destino)+od.DestinoID FROM Compra o, CompraD od, MovTipo omt
WHERE o.ID = od.ID AND omt.Mov = o.Mov AND omt.Clave like ('COMS.O%') AND o.Estatus = 'PENDIENTE'
AND od.Destino IS NOT NULL AND od.DestinoID IS NOT NULL )
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'AMARILLO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID  AND
ISNULL(VentaPendiente.Importe,0) > 0 AND
CAST(RTRIM(VentaPendiente.Mov) AS varchar(20))+VentaPendiente.MovID NOT IN (
SELECT RTRIM(od.Destino)+od.DestinoID FROM Compra o, CompraD od, MovTipo omt
WHERE o.ID = od.ID AND omt.Mov = o.Mov AND omt.Clave like ('COMS.O%') AND o.Estatus = 'PENDIENTE'
AND od.Destino IS NOT NULL AND od.DestinoID IS NOT NULL )
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'VERDE2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.Empresa=@Empresa AND
VentaPendiente.MovTipo=@MovTipo AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.ID=Venta.ID AND
ISNULL(VentaPendiente.Importe,0) > 0 AND
CAST(RTRIM(VentaPendiente.Mov) AS varchar(20))+VentaPendiente.MovID NOT IN (
SELECT RTRIM(od.Destino)+od.DestinoID FROM Compra o, CompraD od, MovTipo omt
WHERE o.ID = od.ID AND omt.Mov = o.Mov AND omt.Clave like ('COMS.O%') AND o.Estatus = 'PENDIENTE'
AND od.Destino IS NOT NULL AND od.DestinoID IS NOT NULL )
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.S'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'ROJO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.ID = Venta.ID AND
Venta.Usuario = @Usuario AND
VentaPendiente.Empresa=@Empresa AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()  AND
VentaPendiente.MovTipo=@MovTipo AND
VentaPendiente.Estatus='CONFIRMAR'
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'AMARILLO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.ID = Venta.ID AND
Venta.Usuario = @Usuario AND
VentaPendiente.Empresa=@Empresa AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.MovTipo=@MovTipo AND
VentaPendiente.Estatus='CONFIRMAR'
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'VERDE2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.ID = Venta.ID AND
Venta.Usuario = @Usuario AND
VentaPendiente.Empresa=@Empresa AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.MovTipo=@MovTipo AND
VentaPendiente.Estatus='CONFIRMAR'
END
ELSE IF @Modulo = 'VTAS' AND @MovTipo = 'VTAS.S'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'ROJO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.ID = Venta.ID AND
VentaPendiente.Empresa=@Empresa AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') < GETDATE()  AND
VentaPendiente.MovTipo=@MovTipo AND
VentaPendiente.Estatus='CONFIRMAR'
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'AMARILLO2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.ID = Venta.ID AND
VentaPendiente.Empresa=@Empresa AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.MovTipo=@MovTipo AND
VentaPendiente.Estatus='CONFIRMAR'
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Venta', VentaPendiente.Id, VentaPendiente.Mov, VentaPendiente.MovID, Cte.Cliente, Cte.Nombre, Venta.FechaEmision, Venta.Concepto, Venta.Proyecto, Venta.Uen, Venta.TipoCambio, Venta.Usuario, Venta.Autorizacion, Venta.Referencia, Venta.Observaciones, Venta.CtaDinero, Venta.Condicion, NULL, Venta.Importe, Venta.Impuestos, Venta.Retencion, NULL, NULL, Venta.Origen, Venta.OrigenID, VentaPendiente.FechaRequerida, DATEDIFF(dd,VentaPendiente.FechaEmision,VentaPendiente.FechaRequerida), VentaPendiente.Saldo, 'VERDE2', Venta.Moneda
FROM VentaPendiente, Cte, Venta
WHERE VentaPendiente.Cliente=Cte.Cliente AND
VentaPendiente.ID = Venta.ID AND
VentaPendiente.Empresa=@Empresa AND
ISNULL(VentaPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
VentaPendiente.MovTipo=@MovTipo AND
VentaPendiente.Estatus='CONFIRMAR'
END
ELSE IF @Modulo = 'CXP'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxp', CxpInfo.Id, CxpInfo.Mov, CxpInfo.MovID, Prov.Proveedor, Prov.Nombre, Cxp.FechaEmision, Cxp.Concepto, Cxp.Proyecto, Cxp.Uen, Cxp.TipoCambio, Cxp.Usuario, Cxp.Autorizacion, Cxp.Referencia, Cxp.Observaciones, Cxp.CtaDinero, Cxp.Condicion, Cxp.FormaPago, Cxp.Importe, Cxp.Impuestos, Cxp.Retencion, Cxp.MovAplica, Cxp.MovAplicaID, Cxp.Origen, Cxp.OrigenID, CxpInfo.Vencimiento, CxpInfo.DiasMoratorios, CxpInfo.Saldo, 'ROJO2', Cxp.Moneda
FROM CxpInfo, Prov, Cxp
WHERE CxpInfo.Proveedor=Prov.Proveedor AND
CxpInfo.ID = Cxp.ID AND
Cxp.Usuario = @Usuario AND
CxpInfo.Empresa=@Empresa AND
ISNULL(CxpInfo.Vencimiento, '19010101') < GETDATE()  AND
CxpInfo.Mov IN ('Entrada Compra',  'Importacion')
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxp', CxpInfo.Id, CxpInfo.Mov, CxpInfo.MovID, Prov.Proveedor, Prov.Nombre, Cxp.FechaEmision, Cxp.Concepto, Cxp.Proyecto, Cxp.Uen, Cxp.TipoCambio, Cxp.Usuario, Cxp.Autorizacion, Cxp.Referencia, Cxp.Observaciones, Cxp.CtaDinero, Cxp.Condicion, Cxp.FormaPago, Cxp.Importe, Cxp.Impuestos, Cxp.Retencion, Cxp.MovAplica, Cxp.MovAplicaID, Cxp.Origen, Cxp.OrigenID, CxpInfo.Vencimiento, CxpInfo.DiasMoratorios, CxpInfo.Saldo, 'AMARILLO2', Cxp.Moneda
FROM CxpInfo, Prov, Cxp
WHERE CxpInfo.Proveedor=Prov.Proveedor AND
CxpInfo.ID = Cxp.ID AND
Cxp.Usuario = @Usuario AND
CxpInfo.Empresa=@Empresa AND
ISNULL(CxpInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
CxpInfo.Mov IN ('Entrada Compra',  'Importacion')
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxp', CxpInfo.Id, CxpInfo.Mov, CxpInfo.MovID, Prov.Proveedor, Prov.Nombre, Cxp.FechaEmision, Cxp.Concepto, Cxp.Proyecto, Cxp.Uen, Cxp.TipoCambio, Cxp.Usuario, Cxp.Autorizacion, Cxp.Referencia, Cxp.Observaciones, Cxp.CtaDinero, Cxp.Condicion, Cxp.FormaPago, Cxp.Importe, Cxp.Impuestos, Cxp.Retencion, Cxp.MovAplica, Cxp.MovAplicaID, Cxp.Origen, Cxp.OrigenID, CxpInfo.Vencimiento, CxpInfo.DiasMoratorios, CxpInfo.Saldo, 'VERDE2', Cxp.Moneda
FROM CxpInfo, Prov, Cxp
WHERE CxpInfo.Proveedor=Prov.Proveedor AND
CxpInfo.ID = Cxp.ID AND
Cxp.Usuario = @Usuario AND
CxpInfo.Empresa=@Empresa AND
ISNULL(CxpInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE()) AND
CxpInfo.Mov IN ('Entrada Compra',  'Importacion')
END
ELSE IF @Modulo = 'CXP'  AND @Grupo IN ('Direccion', 'Sistemas')
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxp', CxpInfo.Id, CxpInfo.Mov, CxpInfo.MovID, Prov.Proveedor, Prov.Nombre, Cxp.FechaEmision, Cxp.Concepto, Cxp.Proyecto, Cxp.Uen, Cxp.TipoCambio, Cxp.Usuario, Cxp.Autorizacion, Cxp.Referencia, Cxp.Observaciones, Cxp.CtaDinero, Cxp.Condicion, Cxp.FormaPago, Cxp.Importe, Cxp.Impuestos, Cxp.Retencion, Cxp.MovAplica, Cxp.MovAplicaID, Cxp.Origen, Cxp.OrigenID, CxpInfo.Vencimiento, CxpInfo.DiasMoratorios, CxpInfo.Saldo, 'ROJO2', Cxp.Moneda
FROM CxpInfo, Prov, Cxp
WHERE CxpInfo.Proveedor=Prov.Proveedor AND
CxpInfo.ID = Cxp.ID AND
CxpInfo.Empresa=@Empresa AND
ISNULL(CxpInfo.Vencimiento, '19010101') < GETDATE()  AND
CxpInfo.Mov IN ('Entrada Compra',  'Importacion')
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxp', CxpInfo.Id, CxpInfo.Mov, CxpInfo.MovID, Prov.Proveedor, Prov.Nombre, Cxp.FechaEmision, Cxp.Concepto, Cxp.Proyecto, Cxp.Uen, Cxp.TipoCambio, Cxp.Usuario, Cxp.Autorizacion, Cxp.Referencia, Cxp.Observaciones, Cxp.CtaDinero, Cxp.Condicion, Cxp.FormaPago, Cxp.Importe, Cxp.Impuestos, Cxp.Retencion, Cxp.MovAplica, Cxp.MovAplicaID, Cxp.Origen, Cxp.OrigenID, CxpInfo.Vencimiento, CxpInfo.DiasMoratorios, CxpInfo.Saldo, 'AMARILLO2', Cxp.Moneda
FROM CxpInfo, Prov, Cxp
WHERE CxpInfo.Proveedor=Prov.Proveedor AND
CxpInfo.ID = Cxp.ID AND
CxpInfo.Empresa=@Empresa AND
ISNULL(CxpInfo.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
CxpInfo.Mov IN ('Entrada Compra',  'Importacion')
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT 'Cxp', CxpInfo.Id, CxpInfo.Mov, CxpInfo.MovID, Prov.Proveedor, Prov.Nombre, Cxp.FechaEmision, Cxp.Concepto, Cxp.Proyecto, Cxp.Uen, Cxp.TipoCambio, Cxp.Usuario, Cxp.Autorizacion, Cxp.Referencia, Cxp.Observaciones, Cxp.CtaDinero, Cxp.Condicion, Cxp.FormaPago, Cxp.Importe, Cxp.Impuestos, Cxp.Retencion, Cxp.MovAplica, Cxp.MovAplicaID, Cxp.Origen, Cxp.OrigenID, CxpInfo.Vencimiento, CxpInfo.DiasMoratorios, CxpInfo.Saldo, 'VERDE2', Cxp.Moneda
FROM CxpInfo, Prov, Cxp
WHERE CxpInfo.Proveedor=Prov.Proveedor AND
CxpInfo.ID = Cxp.ID AND
CxpInfo.Empresa=@Empresa AND
ISNULL(CxpInfo.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE()) AND
CxpInfo.Mov IN ('Entrada Compra',  'Importacion')
END
ELSE IF @Modulo = 'COMS'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT DISTINCT 'Compra', CompraPendiente.Id, CompraPendiente.Mov, CompraPendiente.MovID, Prov.Proveedor, Prov.Nombre, Compra.FechaEmision, Compra.Concepto, Compra.Proyecto, Compra.Uen, Compra.TipoCambio, Compra.Usuario, Compra.Autorizacion, Compra.Referencia, Compra.Observaciones, NULL, Compra.Condicion, NULL, Compra.Importe, Compra.Impuestos, NULL, NULL, NULL, CompraD.Destino+Space(2)+CompraD.DestinoID, NULL, CompraPendiente.FechaRequerida, DATEDIFF(dd,CompraPendiente.FechaEmision,CompraPendiente.FechaRequerida), CompraPendiente.Saldo, 'ROJO2', Compra.Moneda
FROM CompraPendiente, Compra,Comprad, Prov
WHERE CompraPendiente.Empresa= @Empresa AND
Compra.ID = Comprad.ID AND
CompraPendiente.ID = Compra.ID AND
Compra.Proveedor=Prov.Proveedor AND
Compra.Usuario = @Usuario AND
CompraPendiente.Clave LIKE ('COMS.O%') AND
ISNULL(CompraPendiente.FechaRequerida, '19010101') < GETDATE()  AND
CompraPendiente.Saldo > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT DISTINCT 'Compra', CompraPendiente.Id, CompraPendiente.Mov, CompraPendiente.MovID, Prov.Proveedor, Prov.Nombre, Compra.FechaEmision, Compra.Concepto, Compra.Proyecto, Compra.Uen, Compra.TipoCambio, Compra.Usuario, Compra.Autorizacion, Compra.Referencia, Compra.Observaciones, NULL, Compra.Condicion, NULL, Compra.Importe, Compra.Impuestos, NULL, NULL, NULL, CompraD.Destino+Space(2)+CompraD.DestinoID, NULL, CompraPendiente.FechaRequerida, DATEDIFF(dd,CompraPendiente.FechaEmision,CompraPendiente.FechaRequerida), CompraPendiente.Saldo, 'AMARILLO2', Compra.Moneda
FROM CompraPendiente, Compra, Comprad, Prov
WHERE CompraPendiente.Empresa= @Empresa AND
Compra.ID = Comprad.ID AND
CompraPendiente.ID = Compra.ID AND
Compra.Proveedor=Prov.Proveedor AND
Compra.Usuario = @Usuario AND
CompraPendiente.Clave LIKE ('COMS.O%') AND
ISNULL(CompraPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
CompraPendiente.Saldo > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT DISTINCT 'Compra', CompraPendiente.Id, CompraPendiente.Mov, CompraPendiente.MovID, Prov.Proveedor, Prov.Nombre, Compra.FechaEmision, Compra.Concepto, Compra.Proyecto, Compra.Uen, Compra.TipoCambio, Compra.Usuario, Compra.Autorizacion, Compra.Referencia, Compra.Observaciones, NULL, Compra.Condicion, NULL, Compra.Importe, Compra.Impuestos, NULL, NULL, NULL, Comprad.Destino+Space(2)+CompraD.DestinoID, NULL, CompraPendiente.FechaRequerida, DATEDIFF(dd,CompraPendiente.FechaEmision,CompraPendiente.FechaRequerida), CompraPendiente.Saldo, 'VERDE2', Compra.Moneda
FROM CompraPendiente, Compra, Comprad, Prov
WHERE CompraPendiente.Empresa= @Empresa AND
Compra.ID = Comprad.ID AND
CompraPendiente.ID = Compra.ID AND
Compra.Proveedor=Prov.Proveedor AND
Compra.Usuario = @Usuario AND
CompraPendiente.Clave LIKE ('COMS.O%') AND
ISNULL(CompraPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
CompraPendiente.Saldo > 0
END
ELSE IF @Modulo = 'COMS'
BEGIN
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT DISTINCT 'Compra', CompraPendiente.Id, CompraPendiente.Mov, CompraPendiente.MovID, Prov.Proveedor, Prov.Nombre, Compra.FechaEmision, Compra.Concepto, Compra.Proyecto, Compra.Uen, Compra.TipoCambio, Compra.Usuario, Compra.Autorizacion, Compra.Referencia, Compra.Observaciones, NULL, Compra.Condicion, NULL, Compra.Importe, Compra.Impuestos, NULL, NULL, NULL, Comprad.Destino+Space(2)+CompraD.DestinoID, NULL, CompraPendiente.FechaRequerida, DATEDIFF(dd,CompraPendiente.FechaEmision,CompraPendiente.FechaRequerida), CompraPendiente.Saldo, 'ROJO2', Compra.Moneda
FROM CompraPendiente, Compra, Comprad, Prov
WHERE CompraPendiente.Empresa= @Empresa AND
Compra.ID = Comprad.ID AND
CompraPendiente.ID = Compra.ID AND
Compra.Proveedor=Prov.Proveedor AND
CompraPendiente.Clave LIKE ('COMS.O%') AND
ISNULL(CompraPendiente.FechaRequerida, '19010101') < GETDATE()  AND
CompraPendiente.Saldo > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT DISTINCT 'Compra', CompraPendiente.Id, CompraPendiente.Mov, CompraPendiente.MovID, Prov.Proveedor, Prov.Nombre, Compra.FechaEmision, Compra.Concepto, Compra.Proyecto, Compra.Uen, Compra.TipoCambio, Compra.Usuario, Compra.Autorizacion, Compra.Referencia, Compra.Observaciones, NULL, Compra.Condicion, NULL, Compra.Importe, Compra.Impuestos, NULL, NULL, NULL, Comprad.Destino+Space(2)+CompraD.DestinoID, NULL, CompraPendiente.FechaRequerida, DATEDIFF(dd,CompraPendiente.FechaEmision,CompraPendiente.FechaRequerida), CompraPendiente.Saldo, 'AMARILLO2', Compra.Moneda
FROM CompraPendiente, Compra, Comprad, Prov
WHERE CompraPendiente.Empresa= @Empresa AND
Compra.ID = Comprad.ID AND
CompraPendiente.ID = Compra.ID AND
Compra.Proveedor=Prov.Proveedor AND
CompraPendiente.Clave LIKE ('COMS.O%') AND
ISNULL(CompraPendiente.FechaRequerida, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE()) AND
CompraPendiente.Saldo > 0
INSERT INTO ResumenGerencialDetalle
(Modulo, ID, Mov, MovID, Cliente, Nombre, FechaEmision, Concepto, Proyecto, Uen, TipoCambio, Usuario, Autorizacion, Referencia, Observaciones, CtaDinero, Condicion, FormaCobro, Importe, Impuestos, Retencion, MovAplica, MovAplicaID, Origen, OrigenID, Vencimiento, DiasMoratorios, Saldo, Estatus, Moneda)
SELECT DISTINCT 'Compra', CompraPendiente.Id, CompraPendiente.Mov, CompraPendiente.MovID, Prov.Proveedor, Prov.Nombre, Compra.FechaEmision, Compra.Concepto, Compra.Proyecto, Compra.Uen, Compra.TipoCambio, Compra.Usuario, Compra.Autorizacion, Compra.Referencia, Compra.Observaciones, NULL, Compra.Condicion, NULL, Compra.Importe, Compra.Impuestos, NULL, NULL, NULL, Comprad.Destino+Space(2)+CompraD.DestinoID, NULL, CompraPendiente.FechaRequerida, DATEDIFF(dd,CompraPendiente.FechaEmision,CompraPendiente.FechaRequerida), CompraPendiente.Saldo, 'VERDE2', Compra.Moneda
FROM CompraPendiente, Compra, Comprad, Prov
WHERE CompraPendiente.Empresa= @Empresa AND
Compra.ID = Comprad.ID AND
CompraPendiente.ID = Compra.ID AND
Compra.Proveedor=Prov.Proveedor AND
CompraPendiente.Clave LIKE ('COMS.O%') AND
ISNULL(CompraPendiente.FechaRequerida, '19010101') > DATEADD(DAY,2,GETDATE()) AND
CompraPendiente.Saldo > 0
END
ELSE IF @Modulo = 'Soporte'
BEGIN
INSERT INTO ResumenGerencialDetalle
SELECT 'Soporte', Soporte.Id, Soporte.Mov, Soporte.MovID, Cte.Cliente, Cte.Nombre, Soporte.FechaEmision, Soporte.Concepto, Soporte.Proyecto, Soporte.Uen, NULL, Soporte.Usuario, Soporte.Autorizacion, Soporte.Referencia, Soporte.Observaciones, NULL, NULL, NULL, Soporte.Importe, NULL, NULL, NULL, NULL, Soporte.Origen, Soporte.OrigenID, Soporte.FechaRequerida, DATEDIFF(dd,Soporte.FechaEmision,Soporte.FechaRequerida), Soporte.Importe, 'ROJO2', NULL
FROM
Soporte
LEFT OUTER JOIN Cte ON Soporte.Cliente = Cte.Cliente
LEFT OUTER JOIN Agente ON Soporte.Agente = Agente.Agente
LEFT OUTER JOIN Prov ON Soporte.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Personal ON Soporte.Personal = Personal.Personal
LEFT OUTER JOIN Proy ON Soporte.Proyecto = Proy.Proyecto
LEFT OUTER JOIN Rep ON Soporte.Reporte = Rep.Reporte
JOIN Usuario UsuarioRelacion ON Soporte.Usuario=UsuarioRelacion.Usuario
WHERE Soporte.Empresa = @Empresa AND
Soporte.Estatus = 'PENDIENTE' AND
Soporte.Usuario=@Usuario AND
ISNULL(Soporte.Vencimiento, '19010101') < GETDATE()
INSERT INTO ResumenGerencialDetalle
SELECT 'Soporte', Soporte.Id, Soporte.Mov, Soporte.MovID, Cte.Cliente, Cte.Nombre, Soporte.FechaEmision, Soporte.Concepto, Soporte.Proyecto, Soporte.Uen, NULL, Soporte.Usuario, Soporte.Autorizacion, Soporte.Referencia, Soporte.Observaciones, NULL, NULL, NULL, Soporte.Importe, NULL, NULL, NULL, NULL, Soporte.Origen, Soporte.OrigenID, Soporte.FechaRequerida, DATEDIFF(dd,Soporte.FechaEmision,Soporte.FechaRequerida), Soporte.Importe, 'AMARILLO2', NULL
FROM
Soporte
LEFT OUTER JOIN Cte ON Soporte.Cliente = Cte.Cliente
LEFT OUTER JOIN Agente ON Soporte.Agente = Agente.Agente
LEFT OUTER JOIN Prov ON Soporte.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Personal ON Soporte.Personal = Personal.Personal
LEFT OUTER JOIN Proy ON Soporte.Proyecto = Proy.Proyecto
LEFT OUTER JOIN Rep ON Soporte.Reporte = Rep.Reporte
JOIN Usuario UsuarioRelacion ON Soporte.Usuario=UsuarioRelacion.Usuario
WHERE Soporte.Empresa = @Empresa AND
Soporte.Estatus = 'PENDIENTE' AND
Soporte.Usuario=@Usuario AND
ISNULL(Soporte.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
INSERT INTO ResumenGerencialDetalle
SELECT 'Soporte', Soporte.Id, Soporte.Mov, Soporte.MovID, Cte.Cliente, Cte.Nombre, Soporte.FechaEmision, Soporte.Concepto, Soporte.Proyecto, Soporte.Uen, NULL, Soporte.Usuario, Soporte.Autorizacion, Soporte.Referencia, Soporte.Observaciones, NULL, NULL, NULL, Soporte.Importe, NULL, NULL, NULL, NULL, Soporte.Origen, Soporte.OrigenID, Soporte.FechaRequerida, DATEDIFF(dd,Soporte.FechaEmision,Soporte.FechaRequerida), Soporte.Importe, 'VERDE2', NULL
FROM
Soporte
LEFT OUTER JOIN Cte ON Soporte.Cliente = Cte.Cliente
LEFT OUTER JOIN Agente ON Soporte.Agente = Agente.Agente
LEFT OUTER JOIN Prov ON Soporte.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Personal ON Soporte.Personal = Personal.Personal
LEFT OUTER JOIN Proy ON Soporte.Proyecto = Proy.Proyecto
LEFT OUTER JOIN Rep ON Soporte.Reporte = Rep.Reporte
JOIN Usuario UsuarioRelacion ON Soporte.Usuario=UsuarioRelacion.Usuario
WHERE Soporte.Empresa = @Empresa AND
Soporte.Estatus = 'PENDIENTE' AND
Soporte.Usuario=@Usuario AND
ISNULL(Soporte.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE())
END
ELSE IF @Modulo = 'Soporte'
BEGIN
INSERT INTO ResumenGerencialDetalle
SELECT 'Soporte', Soporte.Id, Soporte.Mov, Soporte.MovID, Cte.Cliente, Cte.Nombre, Soporte.FechaEmision, Soporte.Concepto, Soporte.Proyecto, Soporte.Uen, NULL, Soporte.Usuario, Soporte.Autorizacion, Soporte.Referencia, Soporte.Observaciones, NULL, NULL, NULL, Soporte.Importe, NULL, NULL, NULL, NULL, Soporte.Origen, Soporte.OrigenID, Soporte.FechaRequerida, DATEDIFF(dd,Soporte.FechaEmision,Soporte.FechaRequerida), Soporte.Importe, 'ROJO2', NULL
FROM
Soporte
LEFT OUTER JOIN Cte ON Soporte.Cliente = Cte.Cliente
LEFT OUTER JOIN Agente ON Soporte.Agente = Agente.Agente
LEFT OUTER JOIN Prov ON Soporte.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Personal ON Soporte.Personal = Personal.Personal
LEFT OUTER JOIN Proy ON Soporte.Proyecto = Proy.Proyecto
LEFT OUTER JOIN Rep ON Soporte.Reporte = Rep.Reporte
JOIN Usuario UsuarioRelacion ON Soporte.Usuario=UsuarioRelacion.Usuario
WHERE Soporte.Empresa = @Empresa AND
Soporte.Estatus = 'PENDIENTE' AND
ISNULL(Soporte.Vencimiento, '19010101') < GETDATE()
INSERT INTO ResumenGerencialDetalle
SELECT 'Soporte', Soporte.Id, Soporte.Mov, Soporte.MovID, Cte.Cliente, Cte.Nombre, Soporte.FechaEmision, Soporte.Concepto, Soporte.Proyecto, Soporte.Uen, NULL, Soporte.Usuario, Soporte.Autorizacion, Soporte.Referencia, Soporte.Observaciones, NULL, NULL, NULL, Soporte.Importe, NULL, NULL, NULL, NULL, Soporte.Origen, Soporte.OrigenID, Soporte.FechaRequerida,
DATEDIFF(dd,Soporte.FechaEmision,Soporte.FechaRequerida), Soporte.Importe, 'AMARILLO2', NULL
FROM
Soporte
LEFT OUTER JOIN Cte ON Soporte.Cliente = Cte.Cliente
LEFT OUTER JOIN Agente ON Soporte.Agente = Agente.Agente
LEFT OUTER JOIN Prov ON Soporte.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Personal ON Soporte.Personal = Personal.Personal
LEFT OUTER JOIN Proy ON Soporte.Proyecto = Proy.Proyecto
LEFT OUTER JOIN Rep ON Soporte.Reporte = Rep.Reporte
JOIN Usuario UsuarioRelacion ON Soporte.Usuario=UsuarioRelacion.Usuario
WHERE Soporte.Empresa = @Empresa AND
Soporte.Estatus = 'PENDIENTE' AND
ISNULL(Soporte.Vencimiento, '19010101') BETWEEN GETDATE() AND DATEADD(DAY,2,GETDATE())
INSERT INTO ResumenGerencialDetalle
SELECT 'Soporte', Soporte.Id, Soporte.Mov, Soporte.MovID, Cte.Cliente, Cte.Nombre, Soporte.FechaEmision, Soporte.Concepto, Soporte.Proyecto, Soporte.Uen, NULL, Soporte.Usuario, Soporte.Autorizacion, Soporte.Referencia, Soporte.Observaciones, NULL, NULL, NULL, Soporte.Importe, NULL, NULL, NULL, NULL, Soporte.Origen, Soporte.OrigenID, Soporte.FechaRequerida, DATEDIFF(dd,Soporte.FechaEmision,Soporte.FechaRequerida), Soporte.Importe, 'VERDE2', NULL
FROM
Soporte
LEFT OUTER JOIN Cte ON Soporte.Cliente = Cte.Cliente
LEFT OUTER JOIN Agente ON Soporte.Agente = Agente.Agente
LEFT OUTER JOIN Prov ON Soporte.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Personal ON Soporte.Personal = Personal.Personal
LEFT OUTER JOIN Proy ON Soporte.Proyecto = Proy.Proyecto
LEFT OUTER JOIN Rep ON Soporte.Reporte = Rep.Reporte
JOIN Usuario UsuarioRelacion ON Soporte.Usuario=UsuarioRelacion.Usuario
WHERE Soporte.Empresa = @Empresa AND
Soporte.Estatus = 'PENDIENTE' AND
ISNULL(Soporte.Vencimiento, '19010101') > DATEADD(DAY,2,GETDATE())
END
END

