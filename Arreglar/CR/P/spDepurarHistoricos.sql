SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDepurarHistoricos
@MesDepurar		int,
@AnoDepurar		int,
@ConservarEstadistica	bit

AS BEGIN
DECLARE
@FechaDepurar	datetime
DELETE DepurarMov
SELECT @FechaDepurar =  CONVERT(datetime, RTRIM(CONVERT(char, @AnoDepurar)+'.'+RTRIM(CONVERT(char, @MesDepurar))+'.1'), 102)
if exists (select * from sysobjects where id = object_id('dbo.Cont')    	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CONT', ID FROM Cont  		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Venta') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'VTAS', ID FROM Venta 		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Prod') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'PROD', ID FROM Prod		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Compra') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'COMS', ID FROM Compra 		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Inv') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'INV',  ID FROM Inv 		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Cxc') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CXC',  ID FROM Cxc 		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Cxp') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CXP',  ID FROM Cxp 		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Agent') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'AGENT',ID FROM Agent		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Gasto') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'GAS',  ID FROM Gasto		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Dinero') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'DIN',  ID FROM Dinero		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Embarque') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'EMB',  ID FROM Embarque	WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Nomina') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'NOM',  ID FROM Nomina		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.RH') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'RH',   ID FROM RH     		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Asiste') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'ASIS', ID FROM Asiste   	WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.ActivoFijo') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'AF',   ID FROM ActivoFijo 	WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Cambio') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CAM',  ID FROM Cambio		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Capital') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CAP',  ID FROM Capital		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Incidencia') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'INC',  ID FROM Incidencia	WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Conciliacion') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CONC', ID FROM Conciliacion	WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Presup') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'PPTO', ID FROM Presup		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Credito') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CREDI',ID FROM Credito		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.TMA') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'TMA',  ID FROM TMA		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.CRM') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CRM',  ID FROM CRM		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Oportunidad')and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'OPORT', ID FROM Oportunidad		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.PC') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'PC',   ID FROM PC     		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Oferta') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'OFER', ID FROM Oferta 		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.CR') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'CR',   ID FROM CR     		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Vale') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'VALE', ID FROM Vale   		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.Soporte') 	and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'ST',   ID FROM Soporte		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
if exists (select * from sysobjects where id = object_id('dbo.SAUX') 		and type = 'U')   INSERT DepurarMov (Modulo, ID) SELECT 'SAUX', ID FROM SAUX		WHERE Estatus IN ('CONCLUIDO', 'CANCELADO') AND FechaEmision < @FechaDepurar
/* Presupuesto (tg)*/
if exists (select * from sysobjects where id = object_id('dbo.Presupuesto') and type = 'U')
BEGIN
ALTER TABLE Presupuesto DISABLE TRIGGER ALL
DELETE Presupuesto WHERE (Ejercicio < @AnoDepurar) OR (Ejercicio = @AnoDepurar AND Periodo < @MesDepurar)
ALTER TABLE Presupuesto ENABLE TRIGGER ALL
END
/* Acceso */
if exists (select * from sysobjects where id = object_id('dbo.Acceso') and type = 'U')
BEGIN
ALTER TABLE Acceso DISABLE TRIGGER ALL
DELETE Acceso WHERE FechaTrabajo < @FechaDepurar
ALTER TABLE Acceso ENABLE TRIGGER ALL
END
/* DocAuto */
if exists (select * from sysobjects where id = object_id('dbo.DocAuto') and type = 'U')
BEGIN
ALTER TABLE DocAuto DISABLE TRIGGER ALL
DELETE DocAuto WHERE FechaEmision < @FechaDepurar
ALTER TABLE DocAuto ENABLE TRIGGER ALL
END
/* ArtPrecioHist */
if exists (select * from sysobjects where id = object_id('dbo.ArtPrecioHist') and type = 'U')
BEGIN
ALTER TABLE ArtPrecioHist DISABLE TRIGGER ALL
DELETE ArtPrecioHist WHERE Fecha < @FechaDepurar
ALTER TABLE ArtPrecioHist ENABLE TRIGGER ALL
END
/* ArtCostoHist */
if exists (select * from sysobjects where id = object_id('dbo.ArtCostoHist') and type = 'U')
BEGIN
ALTER TABLE ArtCostoHist DISABLE TRIGGER ALL
DELETE ArtCostoHist WHERE Fecha < @FechaDepurar
ALTER TABLE ArtCostoHist ENABLE TRIGGER ALL
END
/* ArtSubCostoHist */
if exists (select * from sysobjects where id = object_id('dbo.ArtSubCostoHist') and type = 'U')
BEGIN
ALTER TABLE ArtSubCostoHist DISABLE TRIGGER ALL
DELETE ArtSubCostoHist WHERE Fecha < @FechaDepurar
ALTER TABLE ArtSubCostoHist ENABLE TRIGGER ALL
END
/* MovFlujo */
if exists (select * from sysobjects where id = object_id('dbo.MovFlujo') and type = 'U')
BEGIN
ALTER TABLE MovFlujo DISABLE TRIGGER ALL
DELETE MovFlujo FROM MovFlujo m, DepurarMov t WHERE m.OModulo = t.Modulo AND m.OID = t.ID
DELETE MovFlujo FROM MovFlujo m, DepurarMov t WHERE m.DModulo = t.Modulo AND m.DID = t.ID
ALTER TABLE MovFlujo ENABLE TRIGGER ALL
END
EXEC spDepurarModulo 'Mov'
EXEC spDepurarModulo 'MovTiempo'
EXEC spDepurarModulo 'MovUsuario'
EXEC spDepurarModulo 'MovBitacora'
EXEC spDepurarModuloID 'MovEstatusLog'
EXEC spDepurarModulo 'GuiaEmbarque'
EXEC spDepurarModulo 'GuiaEmbarqueD'
EXEC spDepurarModulo 'SerieLoteMov'
EXEC spDepurarRama 'AnexoMov'
EXEC spDepurarRama 'AnexoMovD'
EXEC spDepurarAuxiliar @FechaDepurar
EXEC spDepurarAuxiliarU @FechaDepurar
IF @ConservarEstadistica = 0
BEGIN
EXEC spDepurarAuxiliarR @FechaDepurar
EXEC spDepurarAuxiliarRU @FechaDepurar
END
EXEC spDepurarMov 'CXC', 'CxcAplicaDif'
EXEC spDepurarMov 'CXC', 'CxcD'
EXEC spDepurarMov 'CXC', 'Cxc'
EXEC spDepurarMov 'CXP', 'CxpAplicaDif'
EXEC spDepurarMov 'CXP', 'CxpD'
EXEC spDepurarMov 'CXP', 'Cxp'
EXEC spDepurarMov 'VTAS', 'VentaD'
EXEC spDepurarMov 'VTAS', 'VentaCobro'
EXEC spDepurarMov 'VTAS', 'VentaOtros'
EXEC spDepurarMov 'VTAS', 'VentaOrigen'
EXEC spDepurarMov 'VTAS', 'ServicioTarea'
EXEC spDepurarMov 'VTAS', 'Venta'
EXEC spDepurarMov 'COMS', 'CompraD'
EXEC spDepurarMov 'COMS', 'CompraGastoDiverso'
EXEC spDepurarMov 'COMS', 'Compra'
EXEC spDepurarMov 'INV', 'InvD'
EXEC spDepurarMov 'INV', 'Inv'
EXEC spDepurarMov 'DIN', 'DineroD'
EXEC spDepurarMov 'DIN', 'Dinero'
EXEC spDepurarMov 'CONT', 'ContD'
EXEC spDepurarMov 'CONT', 'Cont'
EXEC spDepurarMov 'CAM', 'CambioD'
EXEC spDepurarMov 'CAM', 'Cambio'
EXEC spDepurarMov 'CAP', 'CapitalD'
EXEC spDepurarMov 'CAP', 'Capital'
EXEC spDepurarMov 'INC', 'IncidenciaD'
EXEC spDepurarMov 'INC', 'Incidencia'
EXEC spDepurarMov 'CONC', 'ConciliacionD'
EXEC spDepurarMov 'CONC', 'Conciliacion'
EXEC spDepurarMov 'CREDI', 'Credito'
EXEC spDepurarMov 'TMA', 'TMAD'
EXEC spDepurarMov 'TMA', 'TMA'
EXEC spDepurarMov 'CRM', 'CRMD'
EXEC spDepurarMov 'CRM', 'CRM'
EXEC spDepurarMov 'OPORT', 'OportunidadD'
EXEC spDepurarMov 'OPORT', 'Oportunidad'
EXEC spDepurarMov 'SAUX', 'SAUXD'
EXEC spDepurarMov 'SAUX', 'SAUX'
/* CambioAcum */
if exists (select * from sysobjects where id = object_id('dbo.CambioAcum') and type = 'U')
DELETE CambioAcum WHERE Fecha < @FechaDepurar
EXEC spDepurarMov 'GAS', 'GastoD'
EXEC spDepurarMov 'GAS', 'GastoAplica'
EXEC spDepurarMov 'GAS', 'Gasto'
EXEC spDepurarMov 'EMB', 'EmbarqueD'
EXEC spDepurarMov 'EMB', 'Embarque'
EXEC spDepurarModuloID 'EmbarqueMov'
EXEC spDepurarMov 'AF', 'ActivoFijoD'
EXEC spDepurarMov 'AF', 'ActivoFijo'
EXEC spDepurarMov 'NOM', 'NominaD'
EXEC spDepurarMov 'NOM', 'NominaLog'
EXEC spDepurarMov 'NOM', 'Nomina'
EXEC spDepurarMov 'INC', 'IncidenciaH'
EXEC spDepurarMov 'INC', 'IncidenciaD'
EXEC spDepurarMov 'INC', 'Incidencia'
EXEC spDepurarMov 'CONC', 'ConciliacionD'
EXEC spDepurarMov 'CONC', 'Conciliacion'
EXEC spDepurarMov 'PPTO', 'PresupD'
EXEC spDepurarMov 'PPTO', 'Presup'
EXEC spDepurarMov 'CREDI', 'Credito'
EXEC spDepurarMov 'RH', 'RHD'
EXEC spDepurarMov 'RH', 'RH'
EXEC spDepurarMov 'ASIS', 'AsisteD'
EXEC spDepurarMov 'ASIS', 'Asiste'
EXEC spDepurarMov 'PC', 'PCD'
EXEC spDepurarMov 'PC', 'PC'
EXEC spDepurarMov 'OFER', 'OfertaD'
EXEC spDepurarMov 'OFER', 'Oferta'
EXEC spDepurarMov 'VALE', 'ValeD'
EXEC spDepurarMov 'VALE', 'Vale'
/* PersonalAsiste */
if exists (select * from sysobjects where id = object_id('dbo.PersonalAsiste') and type = 'U')
DELETE PersonalAsiste WHERE Fecha < @FechaDepurar
/* PersonalAsisteDifDia */
if exists (select * from sysobjects where id = object_id('dbo.PersonalAsisteDifDia') and type = 'U')
DELETE PersonalAsisteDifDia WHERE Fecha < @FechaDepurar
/* PersonalAsisteDifMin */
if exists (select * from sysobjects where id = object_id('dbo.PersonalAsisteDifMin') and type = 'U')
DELETE PersonalAsisteDifMin WHERE Fecha < @FechaDepurar
/* PersonalAsisteDif */
if exists (select * from sysobjects where id = object_id('dbo.PersonalAsisteDif') and type = 'U')
DELETE PersonalAsisteDif WHERE Fecha < @FechaDepurar
EXEC spDepurarMov 'AGENT', 'AgentD'
EXEC spDepurarMov 'AGENT', 'Agent'
EXEC spDepurarMov 'ST', 'Soporte'
EXEC spDepurarMov 'PROD', 'ProdD'
EXEC spDepurarMov 'PROD', 'Prod'
EXEC spDepurarModuloID 'ProdSerieLoteCosto'
EXEC spDepurarModulo 'AutoBoletoMov'
EXEC spDepurarModulo 'AuxiliarAlterno'
EXEC spDepurarModulo 'MovForma'
EXEC spDepurarModulo 'MovTarea'
EXEC spDepurarModulo 'SerieLoteD'
EXEC spDepurarModulo 'ValeSerieMov'
EXEC spDepurarMov 'CR', 'CR'
EXEC spDepurarMov 'CR', 'CRAgente'
EXEC spDepurarMov 'CR', 'CRCaja'
EXEC spDepurarMov 'CR', 'CRCobro'
EXEC spDepurarMov 'CR', 'CRInvFisico'
EXEC spDepurarMov 'CR', 'CRSoporte'
EXEC spDepurarMov 'CR', 'CRTrans'
EXEC spDepurarMov 'CR', 'CRVenta'
EXEC spDepurarMov 'COMS', 'CompraCB'
EXEC spDepurarMov 'COMS', 'CompraDProrrateo'
EXEC spDepurarMov 'COMS', 'CompraGastoDiversoD'
EXEC spDepurarMov 'CXC', 'CxcFacturaAnticipo'
EXEC spDepurarMov 'CXC', 'CxcVoucher'
EXEC spDepurarModuloID 'EmbarqueDArt'
EXEC spDepurarMov 'GAS', 'GastoDProrrateo'
EXEC spDepurarMov 'INV', 'InvGastoDiverso'
EXEC spDepurarMov 'INV', 'InvGastoDiversoD'
EXEC spDepurarMov 'NOM', 'NominaPersonal'
EXEC spDepurarMov 'NOM', 'NominaPersonalFecha'
EXEC spDepurarMov 'NOM', 'NominaPersonalProy'
EXEC spDepurarMov 'PROD', 'ProdProgramaMaterial'
EXEC spDepurarMov 'PROD', 'ProdProgramaRuta'
EXEC spDepurarMov 'ST', 'SoporteCambio'
EXEC spDepurarMov 'ST', 'SoporteD'
EXEC spDepurarMov 'VTAS', 'VentaCB'
EXEC spDepurarMov 'VTAS', 'VentaCobroD'
EXEC spDepurarMov 'VTAS', 'VentaDAgente'
EXEC spDepurarMov 'VTAS', 'VentaDLogPicos'
EXEC spDepurarMov 'VTAS', 'VentaFacturaAnticipo'
EXEC spDepurarMov 'VTAS', 'VentaParticipacion'
EXEC spDepurarMov 'VTAS', 'VentaResumen'
EXEC spDepurarMov 'VTAS', 'ServicioAccesorios'
DELETE PVRegistroCaptura WHERE Fecha < @FechaDepurar
/* SincroPaquete */
if exists (select * from sysobjects where id = object_id('dbo.SincroPaquete') and type = 'U')
DELETE SincroPaquete WHERE Fecha < @FechaDepurar
/* SincroLog */
if exists (select * from sysobjects where id = object_id('dbo.SincroLog') and type = 'U')
DELETE SincroLog WHERE Fecha < @FechaDepurar
/* SincroLogAdvertencia */
if exists (select * from sysobjects where id = object_id('dbo.SincroLogAdvertencia') and type = 'U')
DELETE SincroLogAdvertencia WHERE Fecha < @FechaDepurar
/* SincroLogError */
if exists (select * from sysobjects where id = object_id('dbo.SincroLogError') and type = 'U')
DELETE SincroLogError WHERE Fecha < @FechaDepurar
EXEC spDepurarModulo 'SincroMovRegistro'
DELETE DepurarMov
EXEC spReconstruirRamas
EXEC spReconstruirSaldosIniciales
CHECKPOINT
RETURN
END

