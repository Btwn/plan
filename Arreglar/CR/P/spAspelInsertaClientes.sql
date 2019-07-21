SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaClientes]

AS BEGIN
DECLARE
@Observaciones	varchar(30),
@Sucursal	varchar(30),
@Moneda		varchar(30),
@Usuario	varchar(30),
@Condicion	varchar(50),
@Orden		int,
@Cuenta		int,
@Descuento	varchar(30),
@Camposae	varchar(5),
@Inicio		tinyint,
@Longitud	tinyint,
@Descrip	varchar(100),
@Cliente	varchar(20),
@Cuentadescuento int
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
IF NOT EXISTS(SELECT Categoria FROM CteCat WHERE Categoria = @Observaciones)
INSERT INTO CteCat (Categoria) VALUES (@Observaciones)
INSERT CteGrupo (Grupo)
SELECT DISTINCT A.Grupo FROM AspelCargaProp A FULL JOIN CteGrupo B
ON A.Grupo = B.Grupo WHERE Campo = 'Cliente' AND A.Grupo <> '' AND B.Grupo = NULL
SELECT @Sucursal = Valor FROM AspelCfg WHERE Descripcion = 'Sucursal'
SELECT @Moneda = Valor FROM AspelCfg WHERE Descripcion = 'Moneda'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
INSERT INTO Cte (Cliente, Nombre, Direccion, Colonia, Poblacion, CodigoPostal, Telefonos, Fax, Contacto1, Email1, RFC, CURP, Estatus, Tipo, UltimoCambio, Alta, Categoria,
PedirTono, VtasConsignacion, Conciliar, wVerDisponible, wVerArtListaPreciosEsp, CreditoEspecial, CreditoConLimite, CreditoConDias, CreditoConCondiciones,
TieneMovimientos, DescuentoRecargos, FormasPagoRestringidas, PreciosInferioresMinimo, PersonalSMS, Fuma, EsProveedor, EsPersonal, EsAgente, EsAlmacen,
EsEspacio, EsCentroCostos, EsProyecto, EsCentroTrabajo, EsEstacionTrabajo, PedidoDef, eMailAuto, Intercompania, Publico, Extranjero, DocumentacionCompleta,
CreditoMoneda, DeducibleMoneda, DefMoneda,
ChecarCredito, BloquearMorosos, ModificarVencimiento, RecorrerVencimiento,
BonificacionTipo, Usuario, PedidosParciales, Observaciones, Grupo, Condicion, CreditoLimite, Agente, Descuento, nombrecorto)
SELECT  Valor, Nombre, Direccion, Colonia, Poblacion, CodigoPostal, Telefonos, Fax, Contacto, Email, RFC, CURP, Estatus, 'Cliente', getdate(), getdate(), @Observaciones,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@Moneda, @Moneda, @Moneda,
'(Empresa)', '(Empresa)', '(Empresa)', '(Empresa)',
'No', @Usuario, 1,  descripcion2, Grupo, Rama, Impuesto1, Proveedor,
CASE WHEN CONVERT(real, Factor) = 0 THEN NULL ELSE Factor END, Tipo
FROM AspelCargaProp
WHERE Campo = 'Cliente'  and Valor not in (select Cliente from cte)
UPDATE Cte
SET CreditoEspecial = 1, CreditoConLimite = 1
WHERE CreditoLimite > 0
SELECT @Orden = MAX(Orden)  FROM Condicion
DECLARE Cur_Condicion CURSOR FOR
SELECT DISTINCT Condicion FROM Cte
WHERE Condicion IS NOT NULL
OPEN Cur_Condicion
FETCH NEXT FROM Cur_Condicion Into @Condicion
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Orden = @Orden + 1
SELECT @Cuenta = COUNT(*) FROM Condicion
WHERE Condicion = @Condicion
IF @Cuenta = 0
BEGIN
INSERT INTO Condicion(Condicion, DiasVencimiento, TipoDias, DiasHabiles, TipoDiasprontoPago, DiasHabilesProntoPago,
ProntoPago, PorMeses, orden, RecorrerVencimiento, DA, DAImpPrimerDoc, ControlAnticipos, Anticipado, Corte,
FechaProntoPago, TipoCondicion, InteresMoratorioBaseTabla, AutoFin, Neteo, Interesesdevengados, DATipoInteres,
FacturaCobroIntegradoParcial, PorSemanas) 
VALUES (@Condicion, CONVERT(Int, SUBSTRING(@Condicion, 1, 2)), 'Naturales ', 'Lun-Vie', 'Habiles', 'Lun-Vie',
0, 0, @Orden, 0, 0, 0, 'No', 0, 0,
'Emision', 'Credito', 0, 0, 0, 0, 'Global',
0, 0) 
END
FETCH NEXT FROM Cur_Condicion Into @Condicion
END
CLOSE Cur_Condicion
DEALLOCATE Cur_Condicion
set @cuentadescuento = 0
DECLARE Cur_Descuento CURSOR FOR
SELECT DISTINCT Descuento,Cliente FROM Cte
WHERE Descuento IS NOT NULL
OPEN Cur_Descuento
FETCH NEXT FROM Cur_Descuento Into @Descuento, @Cliente
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Cuenta = COUNT(*) FROM Descuento
WHERE Descuento = @Descuento
IF @Cuenta = 0
BEGIN
INSERT INTO Precio(Descripcion,Estatus,Ultimocambio,Nivelarticulo,Nivelsubcuenta,Nivelartgrupo,
Nivelartcat,Nivelartfam,Nivelartabc,Nivelfabricante,Nivelartlinea,Nivelartrama,Nivelcliente,
cliente,Nivelctegrupo,nivelctecat,nivelctefam,nivelctezona,nivelmoneda,nivelcondicion,nivelalmacen,
nivelproyecto,nivelagente,nivelformaenvio,nivelmov,nivelserviciotipo,nivelcontratotipo,nivelunidadventa,
nivelempresa,nivelregion,nivelsucursal,tipo,nivel,Listaprecios,convigencia,Logico1,Logico2,wMostrar)
VALUES ('Cliente '  + @Cliente + ' ' + @Descuento + '%' , 'ACTIVA', GETDATE(),0,0,0,
0,0,0,0,0,0,1,@cliente,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'% Descuento','Normal','Todas',0,0,0,0)			
set @cuentadescuento = @cuentadescuento +1
INSERT INTO PRECIOD(ID, Cantidad,Monto, Sucursal)
VALUES(@Cuentadescuento, 1,@Descuento,0)
END
FETCH NEXT FROM Cur_Descuento Into @Descuento, @Cliente
END
CLOSE Cur_Descuento
DEALLOCATE Cur_Descuento
SELECT @Cuenta = COUNT(*)
FROM AspelClasCte
IF @Cuenta > 0
BEGIN
INSERT INTO CteCat (Categoria)
SELECT Descripcion FROM AspelClasCte
WHERE CampoIntelisis  = 'CATEGORIA'
INSERT INTO CteGrupo (Grupo)
SELECT Descripcion FROM AspelClasCte
WHERE CampoIntelisis  = 'GRUPO'
INSERT INTO CteFam (Familia)
SELECT Descripcion FROM AspelClasCte
WHERE CampoIntelisis  = 'FAMILIA'
DECLARE Cur_Agrupadores CURSOR FOR
SELECT CampoSae, Inicio, Longitud, Descripcion
FROM AspelClasCte
WHERE CampoIntelisis  = 'CATEGORIA'
OPEN Cur_Agrupadores
FETCH NEXT FROM Cur_Agrupadores Into @CampoSae, @Inicio, @Longitud, @Descrip
WHILE @@FETCH_STATUS <> -1
BEGIN
UPDATE Cte SET
Categoria = A.Descripcion
FROM Cte C, AspelClasCte A
WHERE SUBSTRING(C.Grupo, @Inicio, @Longitud) = A.CampoSae
FETCH NEXT FROM Cur_Agrupadores Into @CampoSae, @Inicio, @Longitud, @Descrip
END
CLOSE Cur_Agrupadores
DEALLOCATE Cur_Agrupadores
DECLARE Cur_Agrupadores CURSOR FOR
SELECT CampoSae, Inicio, Longitud, Descripcion
FROM AspelClasCte
WHERE CampoIntelisis  = 'FAMILIA'
OPEN Cur_Agrupadores
FETCH NEXT FROM Cur_Agrupadores Into @CampoSae, @Inicio, @Longitud, @Descrip
WHILE @@FETCH_STATUS <> -1
BEGIN
UPDATE Cte SET
Familia = A.Descripcion
FROM Cte C, AspelClasCte A
WHERE SUBSTRING(C.Grupo, @Inicio, @Longitud) = A.CampoSae
FETCH NEXT FROM Cur_Agrupadores Into @CampoSae, @Inicio, @Longitud, @Descrip
END
CLOSE Cur_Agrupadores
DEALLOCATE Cur_Agrupadores
DECLARE Cur_Agrupadores CURSOR FOR
SELECT CampoSae, Inicio, Longitud, Descripcion
FROM AspelClasCte
WHERE CampoIntelisis  = 'GRUPO'
OPEN Cur_Agrupadores
FETCH NEXT FROM Cur_Agrupadores Into @CampoSae, @Inicio, @Longitud, @Descrip
WHILE @@FETCH_STATUS <> -1
BEGIN
UPDATE Cte SET
Grupo = A.Descripcion
FROM Cte C, AspelClasCte A
WHERE SUBSTRING(C.Grupo, @Inicio, @Longitud) = A.CampoSae
FETCH NEXT FROM Cur_Agrupadores Into @CampoSae, @Inicio, @Longitud, @Descrip
END
CLOSE Cur_Agrupadores
DEALLOCATE Cur_Agrupadores
END
END

