SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBorrarMovimientos

AS BEGIN
DECLARE
@WMSAuxiliar	bit 
SELECT @WMSAuxiliar = WMSAuxiliar FROM Version WITH (NOLOCK)
IF (SELECT COUNT(*) FROM Auxiliar WITH (NOLOCK)) > 300
BEGIN
RAISERROR ('Tiene mas de 300 Registros (Auxiliar), no se puede utilizar esta rutina.',16,-1)
RETURN
END
EXEC spBorrarTabla 'FechaTrabajo'
EXEC spBorrarTabla 'Acceso'
EXEC spBorrarTabla 'Saldo'
EXEC spBorrarTabla 'SaldoC'
IF @WMSAuxiliar = 1 
BEGIN
EXEC spBorrarTabla 'SaldoUWMS'
EXEC spBorrarTabla 'SaldoU'
END ELSE
EXEC spBorrarTabla 'SaldoU'
EXEC spBorrarTabla 'SaldoR'
EXEC spBorrarTabla 'SaldoRU'
EXEC spBorrarTabla 'ArtR'
EXEC spBorrarTabla 'Acum'
EXEC spBorrarTabla 'AcumC'
IF @WMSAuxiliar = 1 
BEGIN
EXEC spBorrarTabla 'AcumUWMS'
EXEC spBorrarTabla 'AcumU'
END ELSE
EXEC spBorrarTabla 'AcumU'
EXEC spBorrarTabla 'AcumR'
EXEC spBorrarTabla 'AcumRU'
EXEC spBorrarTabla 'Auxiliar'
IF @WMSAuxiliar = 1 
BEGIN
EXEC spBorrarTabla 'AuxiliarUWMS'
EXEC spBorrarTabla 'AuxiliarU'
END ELSE
EXEC spBorrarTabla 'AuxiliarU'
EXEC spBorrarTabla 'AuxiliarR'
EXEC spBorrarTabla 'AuxiliarRU'
EXEC spBorrarTabla 'InvCapa'
EXEC spBorrarTabla 'InvCapaAux'
EXEC spBorrarTabla 'Mov'
EXEC spBorrarTabla 'MovFlujo'
EXEC spBorrarTabla 'MovTiempo'
EXEC spBorrarTabla 'MovUsuario'
EXEC spBorrarTabla 'MovBitacora'
EXEC spBorrarTabla 'MovEstatusLog'
EXEC spBorrarTabla 'MovRef'
EXEC spBorrarTabla 'MovImpuesto'
EXEC spBorrarTabla 'MovPresupuesto'
EXEC spBorrarTabla 'MovInfoPath'
EXEC spBorrarTabla 'MovReg'
EXEC spBorrarTabla 'MovDReg'
EXEC spBorrarTabla 'Presupuesto'
EXEC spBorrarTabla 'ArtPrecioHist '
EXEC spBorrarTabla 'ArtCosto'
EXEC spBorrarTabla 'ArtCostoHist'
EXEC spBorrarTabla 'ArtSubCostoHist'
EXEC spBorrarTabla 'SerieLote'
EXEC spBorrarTabla 'TarimaSerieLote'
EXEC spBorrarTabla 'SerieLoteD'
EXEC spBorrarTabla 'Cxc'
EXEC spBorrarTabla 'CxcD'
EXEC spBorrarTabla 'CxcVoucher'
EXEC spBorrarTabla 'CxcC'
EXEC spBorrarTabla 'CxcAplicaDif'
EXEC spBorrarTabla 'CxcFacturaAnticipo'
EXEC spBorrarTabla 'Cxp'
EXEC spBorrarTabla 'CxpD'
EXEC spBorrarTabla 'CxpC'
EXEC spBorrarTabla 'CxpAplicaDif'
EXEC spBorrarTabla 'CxReevaluacionLog'
EXEC spBorrarTabla 'CxTasaDiariaLog'
EXEC spBorrarTabla 'DocAuto'
EXEC spBorrarTabla 'Venta'
EXEC spBorrarTabla 'VentaD'
EXEC spBorrarTabla 'VentaDPresupuestoEsp'
EXEC spBorrarTabla 'VentaDAgente'
EXEC spBorrarTabla 'VentaC'
EXEC spBorrarTabla 'VentaCB'
EXEC spBorrarTabla 'VentaResumen'
EXEC spBorrarTabla 'VentaFacturaAnticipo'
EXEC spBorrarTabla 'VentaParticipacion'
EXEC spBorrarTabla 'GuiaEmbarque'
EXEC spBorrarTabla 'GuiaEmbarqueD'
EXEC spBorrarTabla 'VentaCobro'
EXEC spBorrarTabla 'VentaOrigen'
EXEC spBorrarTabla 'ServicioTarea'
EXEC spBorrarTabla 'VentaOtros'
EXEC spBorrarTabla 'VentaProcesarNotas'
EXEC spBorrarTabla 'Compra'
EXEC spBorrarTabla 'CompraD'
EXEC spBorrarTabla 'CompraDProrrateo'
EXEC spBorrarTabla 'CompraDPresupuestoEsp'
EXEC spBorrarTabla 'CompraC'
EXEC spBorrarTabla 'CompraGastoDiverso'
EXEC spBorrarTabla 'CompraGastoDiversoD'
EXEC spBorrarTabla 'Inv'
EXEC spBorrarTabla 'InvD'
EXEC spBorrarTabla 'InvC'
EXEC spBorrarTabla 'InvGastoDiverso'
EXEC spBorrarTabla 'InvGastoDiversoD'
EXEC spBorrarTabla 'SerieLoteMov'
EXEC spBorrarTabla 'SerieLoteProp'
EXEC spBorrarTabla 'Dinero'
EXEC spBorrarTabla 'DineroD'
EXEC spBorrarTabla 'DineroC'
EXEC spBorrarTabla 'Cont'
EXEC spBorrarTabla 'ContD'
EXEC spBorrarTabla 'ContReg'
EXEC spBorrarTabla 'ContC'
EXEC spBorrarTabla 'Cambio'
EXEC spBorrarTabla 'CambioD'
EXEC spBorrarTabla 'CambioC'
EXEC spBorrarTabla 'CambioAcum'
EXEC spBorrarTabla 'Gasto'
EXEC spBorrarTabla 'GastoD'
EXEC spBorrarTabla 'GastoDProrrateo'
EXEC spBorrarTabla 'GastoDPresupuestoEsp'
EXEC spBorrarTabla 'GastoAplica'
EXEC spBorrarTabla 'GastoC'
EXEC spBorrarTabla 'EmbarqueMov'
EXEC spBorrarTabla 'Embarque'
EXEC spBorrarTabla 'EmbarqueD'
EXEC spBorrarTabla 'EmbarqueDArt'
EXEC spBorrarTabla 'EmbarqueC'
EXEC spBorrarTabla 'EmbarqueAsistenteCobro'
EXEC spBorrarTabla 'EmbarqueAsistenteGeneral'
EXEC spBorrarTabla 'ActivoF'
EXEC spBorrarTabla 'ActivoFijo'
EXEC spBorrarTabla 'ActivoFijoD'
EXEC spBorrarTabla 'ActivoFijoC'
EXEC spBorrarTabla 'Nomina'
EXEC spBorrarTabla 'NominaD'
EXEC spBorrarTabla 'NominaC'
EXEC spBorrarTabla 'NominaLog'
EXEC spBorrarTabla 'NominaPersonal'
EXEC spBorrarTabla 'NominaCorrespondeLote'
EXEC spBorrarTabla 'Incidencia'
EXEC spBorrarTabla 'IncidenciaD'
EXEC spBorrarTabla 'IncidenciaH'
EXEC spBorrarTabla 'RH'
EXEC spBorrarTabla 'RHD'
EXEC spBorrarTabla 'RHC'
EXEC spBorrarTabla 'Asiste'
EXEC spBorrarTabla 'AsisteD'
EXEC spBorrarTabla 'AsisteC'
EXEC spBorrarTabla 'PersonalAsiste'
EXEC spBorrarTabla 'PersonalAsisteDifDia'
EXEC spBorrarTabla 'PersonalAsisteDifMin'
EXEC spBorrarTabla 'PersonalAsisteDif'
EXEC spBorrarTabla 'Agent'
EXEC spBorrarTabla 'AgentD'
EXEC spBorrarTabla 'AgentC'
EXEC spBorrarTabla 'Soporte'
EXEC spBorrarTabla 'SoporteD'
EXEC spBorrarTabla 'SoporteC'
EXEC spBorrarTabla 'AnexoMov'
EXEC spBorrarTabla 'AnexoMovD'
EXEC spBorrarTabla 'Prod'
EXEC spBorrarTabla 'ProdD'
EXEC spBorrarTabla 'ProdProgramaMaterial'
EXEC spBorrarTabla 'ProdProgramaRuta'
EXEC spBorrarTabla 'ProdC'
EXEC spBorrarTabla 'ProdSerieLote'
EXEC spBorrarTabla 'ProdSerieLoteCosto'
EXEC spBorrarTabla 'PlanArt'
EXEC spBorrarTabla 'PlanArtOP'
EXEC spBorrarTabla 'PlanBitacora'
EXEC spBorrarTabla 'PlanMensaje'
EXEC spBorrarTabla 'ArtSubCosto'
EXEC spBorrarTabla 'SincroPaquete'
EXEC spBorrarTabla 'SincroLog'
EXEC spBorrarTabla 'SincroLogAdvertencia'
EXEC spBorrarTabla 'SincroLogError'
EXEC spBorrarTabla 'SincroMovRegistro'
EXEC spBorrarTabla 'PC'
EXEC spBorrarTabla 'PCD'
EXEC spBorrarTabla 'PCBoletin'
EXEC spBorrarTabla 'PCC'
EXEC spBorrarTabla 'Vale'
EXEC spBorrarTabla 'ValeD'
EXEC spBorrarTabla 'ValeC'
EXEC spBorrarTabla 'ValeSerie'
EXEC spBorrarTabla 'ValeSerieMov'
EXEC spBorrarTabla 'Anticipo'
EXEC spBorrarTabla 'ConciliacionLog'
EXEC spBorrarTabla 'EspacioResultado'
EXEC spBorrarTabla 'AfectarBitacora'
EXEC spBorrarTabla 'ResumenMov'
EXEC spBorrarTabla 'ResumenMovProyecto'
EXEC spBorrarTabla 'ResumenSaldo'
EXEC spBorrarTabla 'PagadoAux'
EXEC spBorrarTabla 'PersonalUltimoPago'
EXEC spBorrarTabla 'CtePresupuesto'
EXEC spBorrarTabla 'CR'
EXEC spBorrarTabla 'CRVenta'
EXEC spBorrarTabla 'CRAgente'
EXEC spBorrarTabla 'CRCobro'
EXEC spBorrarTabla 'CRCaja'
EXEC spBorrarTabla 'CRInvFisico'
EXEC spBorrarTabla 'CRSoporte'
EXEC spBorrarTabla 'CRTrans'
EXEC spBorrarTabla 'CRC'
EXEC spBorrarTabla 'CRMov'
EXEC spBorrarTabla 'CRMovD'
EXEC spBorrarTabla 'CRMovSoporte'
EXEC spBorrarTabla 'CRBitacora'
EXEC spBorrarTabla 'MovRecibo'
EXEC spBorrarTabla 'Tarea'
EXEC spBorrarTabla 'CtaDineroHist'
EXEC spBorrarTabla 'CteHist'
EXEC spBorrarTabla 'ArtComisionHist'
EXEC spBorrarTabla 'ArtSituacionHist'
EXEC spBorrarTabla 'ArtSubCostoHist'
EXEC spBorrarTabla 'ArtProvHist'
EXEC spBorrarTabla 'VINHist'
EXEC spBorrarTabla 'EvaluacionCtoHist'
EXEC spBorrarTabla 'TablaImpuestoHist'
EXEC spBorrarTabla 'ZonaEconomicaHist'
EXEC spBorrarTabla 'ArtAlmABCHist'
EXEC spBorrarTabla 'MonHist'
EXEC spBorrarTabla 'TablaAmortizacion'
EXEC spBorrarTabla 'TablaAmortizacionGuia'
EXEC spBorrarTabla 'TablaAmortizacionMigracion'
EXEC spBorrarTabla 'Registro'
EXEC spBorrarTabla 'Capital'
EXEC spBorrarTabla 'CapitalD'
EXEC spBorrarTabla 'CapitalC'
EXEC spBorrarTabla 'TMA'
EXEC spBorrarTabla 'TMAD'
EXEC spBorrarTabla 'TMAC'
EXEC spBorrarTabla 'Tarima'
EXEC spBorrarTabla 'AuxiliarAlterno'
EXEC spBorrarTabla 'MovCampoExtra'
EXEC spBorrarTabla 'MovForma'
EXEC spBorrarTabla 'MovTarea'
EXEC spBorrarTabla 'NotaMov'
EXEC spBorrarTabla 'CRM'
EXEC spBorrarTabla 'CRMD'
EXEC spBorrarTabla 'CRMC'
EXEC spBorrarTabla 'Oportunidad'
EXEC spBorrarTabla 'OportunidadD'
EXEC spBorrarTabla 'OportunidadC'
EXEC spBorrarTabla 'AutoBoletoMov'
EXEC spBorrarTabla 'AuxiliarAlterno'
EXEC spBorrarTabla 'CompraCB'
EXEC spBorrarTabla 'InvGastoDiverso'
EXEC spBorrarTabla 'InvGastoDiversoD'
EXEC spBorrarTabla 'NominaPersonal'
EXEC spBorrarTabla 'NominaPersonalFecha'
EXEC spBorrarTabla 'NominaPersonalProy'
EXEC spBorrarTabla 'SoporteCambio'
EXEC spBorrarTabla 'VentaCobroD'
EXEC spBorrarTabla 'VentaDLogPicos'
EXEC spBorrarTabla 'ServicioAccesorios'
EXEC spBorrarTabla 'Gestion'
EXEC spBorrarTabla 'GestionD'
EXEC spBorrarTabla 'GestionPara'
EXEC spBorrarTabla 'GestionC'
EXEC spBorrarTabla 'GestionTarea'
EXEC spBorrarTabla 'GestionPlan'
EXEC spBorrarTabla 'GestionActividad'
EXEC spBorrarTabla 'Act'
EXEC spBorrarTabla 'ActD'
EXEC spBorrarTabla 'ActC'
EXEC spBorrarTabla 'SincroLogLista'
EXEC spBorrarTabla 'RSS'
EXEC spBorrarTabla 'RSSC'
EXEC spBorrarTabla 'Concilicion'
EXEC spBorrarTabla 'ConcilicionD'
EXEC spBorrarTabla 'Fiscal'
EXEC spBorrarTabla 'FiscalD'
EXEC spBorrarTabla 'FiscalC'
EXEC spBorrarTabla 'Oferta'
EXEC spBorrarTabla 'OfertaD'
EXEC spBorrarTabla 'OfertaC'
EXEC spBorrarTabla 'OfertaFiltro'
EXEC spBorrarTabla 'OfertaSucursalEsp'
EXEC spBorrarTabla 'OfertaDVol'
EXEC spBorrarTabla 'OfertaH'
EXEC spBorrarTabla 'OfertaHVol'
EXEC spBorrarTabla 'Contrato'
/*EXEC spBorrarTabla 'vic_Contrato'
EXEC spBorrarTabla 'vic_Condicion'
EXEC spBorrarTabla 'vic_CondicionListado'
EXEC spBorrarTabla 'vic_HistLocal'
EXEC spBorrarTabla 'vic_ContMinuta'*/
EXEC spBorrarTabla 'AuxiliarValeSerie'
EXEC spBorrarTabla 'PeriodoTipoMov'
EXEC spBorrarTabla 'CFD'
EXEC spBorrarTabla 'CFDENviar'
EXEC spBorrarTabla 'Organiza'
EXEC spBorrarTabla 'OrganizaD'
EXEC spBorrarTabla 'Campana'
EXEC spBorrarTabla 'CampanaD'
EXEC spBorrarTabla 'PersonalEntrada'
EXEC spBorrarTabla 'PersonalEntradaH'
EXEC spBorrarTabla 'ReclutaPlaza'
EXEC spBorrarTabla 'Recluta'
EXEC spBorrarTabla 'ReclutaD'
EXEC spBorrarTabla 'SAUX'
EXEC spBorrarTabla 'SAUXD'
EXEC spBorrarTabla 'SAUXC'
EXEC spBorrarTabla 'SAUXDIndicador'
EXEC spBorrarTabla 'Credito' 
EXEC spBorrarTabla 'Conciliacion'
EXEC spBorrarTabla 'ConciliacionD'
EXEC spBorrarTabla 'ConciliacionCompensacion'
EXEC spBorrarTabla 'TarjetaSerieMov'
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Vehiculo' 	and campo = 'Estatus') 		EXEC("UPDATE Vehiculo 		SET Estatus = 'DISPONIBLE'")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'RHPlaza' 	and campo = 'EnUso')    	EXEC("UPDATE RHPlaza 		SET EnUso = NULL")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Cta' 		and campo = 'TieneMovimientos') EXEC("UPDATE Cta 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'ArtAlm' 	and campo = 'TieneMovimientos') EXEC("UPDATE ArtAlm		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'CtaDinero' 	and campo = 'TieneMovimientos') EXEC("UPDATE CtaDinero 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'CtaDinero' 	and campo = 'Cajero')           EXEC("UPDATE CtaDinero 		SET Cajero = NULL")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Cte' 		and campo = 'TieneMovimientos') EXEC("UPDATE Cte 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'CteEnviarA' 	and campo = 'TieneMovimientos') EXEC("UPDATE CteEnviarA 	SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Alm' 		and campo = 'TieneMovimientos') EXEC("UPDATE Alm 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Art' 		and campo = 'TieneMovimientos') EXEC("UPDATE Art 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Prov' 	and campo = 'TieneMovimientos') EXEC("UPDATE Prov 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Agente' 	and campo = 'TieneMovimientos') EXEC("UPDATE Agente 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Usuario' 	and campo = 'TieneMovimientos') EXEC("UPDATE Usuario 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Personal' 	and campo = 'TieneMovimientos') EXEC("UPDATE Personal 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Personal' 	and campo = 'Estatus') 	        EXEC("UPDATE Personal 		SET Estatus = 'ASPIRANTE'")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Personal' 	and campo = 'UltimoPago')       EXEC("UPDATE Personal 		SET UltimoPago = NULL")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'VIN' 		and campo = 'TieneMovimientos') EXEC("UPDATE VIN 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'CentroCostos' and campo = 'TieneMovimientos') EXEC("UPDATE CentroCostos 	SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Vehiculo' 	and campo = 'TieneMovimientos') EXEC("UPDATE Vehiculo 		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'ActivoF' 	and campo = 'TieneMovimientos') EXEC("UPDATE ActivoF		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'ProdRuta' 	and campo = 'TieneMovimientos') EXEC("UPDATE ProdRuta		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'EstacionT' 	and campo = 'TieneMovimientos') EXEC("UPDATE EstacionT		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'Centro' 	and campo = 'TieneMovimientos') EXEC("UPDATE Centro		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'CtaDineroCajero' and campo = 'Cajero')    	EXEC("UPDATE CtaDineroCajero	SET Cajero = NULL")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'CB' 		and campo = 'ModuloID')    	EXEC("UPDATE CB			SET Modulo = NULL, ModuloID = NULL")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'OpcionD' 	and campo = 'TieneMovimientos') EXEC("UPDATE OpcionD		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'ArtOpcion' 	and campo = 'TieneMovimientos') EXEC("UPDATE ArtOpcion		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'ArtOpcionD' 	and campo = 'TieneMovimientos') EXEC("UPDATE ArtOpcionD		SET TieneMovimientos = 0")
if exists(select * from syscampo WITH (NOLOCK) where tabla = 'AlmPos' 	and campo = 'Tarima') 		EXEC("UPDATE AlmPos		SET Tarima = NULL")
/*Vertical Inmobiliaria
if exists(select * from syscampo where tabla = 'vic_local' and campo = 'Estatus') 		EXEC("UPDATE vic_local SET Estatus = 'DESOCUPADO'")
if exists(select * from syscampo where tabla = 'vic_local' and campo = 'Contrato') 		EXEC("UPDATE vic_local SET Contrato = NULL")*/
EXEC xpBorrarMovimientos
END

