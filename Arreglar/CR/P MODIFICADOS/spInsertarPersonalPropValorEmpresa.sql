SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarPersonalPropValorEmpresa
@Empresa		char(5)

AS BEGIN
IF NOT EXISTS(SELECT * FROM PersonalPropValor with(nolock) WHERE Rama = 'EMP' AND Cuenta = @Empresa  )
BEGIN
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Aguinaldo','15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% SAR Retiro Patron','2')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% SHCP Tope Horas Extras Excentas','9')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Subsidio Acreditable','100')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Vales Despensa',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'12 X 12','84')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'24 X 24','72')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'44 HRS','44')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'48 HRS','48')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acredor Afore','Afore')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor 2%',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Aguinaldo','Aguinaldo')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'ACREEDOR AYUDA EMPLEADO',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Caja de Ahorro','CAJAAHORRO')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor CDVFAE','CDVFAE')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'ACREEDOR CREDITO INFONAVIT',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Fonacot','FONACOT')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Fondo de Ahorro','FON AHORRO')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor IMSS','IMSS')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor SAR','SAR')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Infonavit','INFONAVIT')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Nomina','NOMINA')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Retiro',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor SHCP','ISRNOM')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Sueldos y Salarios','BITAL')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor TF','TF')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Ajuste Anual ISR','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Ajuste Mensual ISR','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Ayuda Familiar',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Ayuda Familiar Factor Ausentismo(S/N)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Bono Vespertino / Nocturno',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Caja de Ahorro Desde (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Caja de Ahorro Hasta (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Caja de Ahorro Ingreso Tope',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Caja de Ahorro Interes a Repartir',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Caja de Ahorro Intereses a Repartir',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Cantidad a Repartir','3066.64')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Compensacion 12 X 12','2000')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Compensacion 24 X 24','2250')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Credito al salario como Percepcion','No')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Dias Trabajados','24574')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Dias Vacaciones Aniversario (S/N)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fecha Inicio Premios','16/11/2004')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fin Fondo de Ahorro','31/12/2006')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'FONACOT',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo Ahorro en el Finiquito(S/N)','N')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo Ahorro Factor Ausentismo(S/N)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo Ahorro Tipo Contrato',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo de Ahorro',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo de Ahorro Desde (DD/MM/AAAA)','01/01/2006')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo de Ahorro Hasta (DD/MM/AAAA)','31/12/2006')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo de Ahorro Ingreso Tope',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo de Ahorro Interes a Repartir',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Importe Total Pagado a los Trabajadores','7940483.90')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Inicio Fondo de Ahorro',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Medio Turno C','24')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Medio Turno T','24')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Monto Total Fondo de Ahorro',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Pagar Impuesto Sustitutivo','No')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Pagos IMSS en Nomina','Si')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Percepciones No Registradas en Nomina','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Premio Asistencia Si','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Premio Puntualidad Si','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Prestamo Fondo de Ahorro Desde (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Prestamo Fondo de Ahorro Hasta (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Prima Vacacional Aniversario (S/N)','S')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Prima Vacacional Tipo Aguinaldo (S/N)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'PTU Desde (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'PTU Hasta (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'PTU Importe a Repartir',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'PTU Ingreso Tope',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Registro Infonavit',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'SDI Desde (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'SDI Hasta (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Seguro Riesgo Infonavit','8')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sem. Reducida','24')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Separa Nominas Por UEN','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'SubsidioProporcionalAusentismo(S/N)','N')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo maximo anual Para Ajuste',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo Maximo para Ajuste de ISR','300000')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo Topado mas 20%',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo Variable Aguinaldo Desde (DD/MM/AAAA)','01/01/2005')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo Variable Aguinaldo Hasta (DD/MM/AAAA)','31/12/2005')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo Variable PTU Desde (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Sueldo Variable PTU Hasta (DD/MM/AAAA)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Suma Porcentaje Incapacidades Permanentes /100','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Tope Fondo de Ahorro','1.3')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Totad  Dias Subsidiados','137')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Total de Dias Trabajados','60')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Total de Intereses','50000')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Total de Sueldos Pagados','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Utilidad a Repartir','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'vales despensa % sueldo',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Vales Despensa (S/N)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Vales Despensa Factor Ausentismo(S/N)',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Vales Despensa Importe',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Años Prima Antiguedad','14')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Defunciones Anuales','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Ano','365')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Año Trabajado','20')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias con Diferente Salario',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Mes','30')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Mes Sueldo','30')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Prima Antiguedad','12')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Tope Prima Vacacional','15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Obrero CV','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Obrero EM Excente','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Obrero Gastos Medicos','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Obrero IV','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Obrero Prestaciones Dinero','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Patron Infonavit','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Patron Retiro','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# IMSS Tope Salarios Minimos Exentos','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Maximas Horas Dobles','9')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Meses Indemnizacion','3')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Retardos Generan Falta','3')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SAR Tope Salarios Minimos','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Exento Año Antiguedad','90')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Exento PTU','15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Exentos Aguinaldo','30')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Exentos Vacaciones','15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Prima Antiguedad','2')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Tope Horas Dobles','5')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Trabajadores Expuesto a riesgo','59.6')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# VSM SDI Maximo','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'$ Premio Puntualidad','61')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'$ SDI Minimo','45.62')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Anticipo Fondo de Ahorro','90')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Ayuda Familiar',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Comedor','20')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Credito Infonavit','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Desc ISR Ajuste Anual (Sueldo Dias Trabajados)','5')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Fondo de Ahorro','10')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Horas Extras Gravable',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Impuesto Sustitutivo','3')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Obrero CV','1.125')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Obrero EM Excedente','0.4')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Obrero Gastos Medicos','0.375')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Obrero IV','0.625')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Obrero Prestaciones Dinero','0.25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron CV','3.15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron EM Cuota Fija','20.4')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron EM Excedente','1.1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron Gastos Medicos','1.05')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron Guarderias','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron IV','1.75')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron Prestaciones Dinero','0.7')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron Retiro','2')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Patron Riesgo',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Tope Premio Puntualidad Asistencia','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IMSS Tope Vales Despensa Exentos','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Infonavit Patron','5')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% IVA','15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Maximo Descuento','35')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Premio Asistencia','10')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% PREMIO BODEGAS',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% PREMIO DESEMPEÑO','.13')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Premio Puntualidad','10')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Prima Dominical','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Prima Vacacional','25')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Retencion ISR','10')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'% Retencion IVA','10')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# Dias Agui Sindicato','7.5')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'# SMZ Exentos Prima Vacacional','15')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Impuesto Estatal','TDF')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Transferencia Nomina','NOMINA')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Acreedor Vales Despensa',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Calc. Aguinaldo Automatico','SI')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Calc. PTU Automatico','SI')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Calculo Automatico de Horas D y T','SI')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Calculo de ISR de Aguinaldo segun Ley','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Calculo de ISR de PTU segun Ley','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Factor Ausentismo Catorcenal','1.4')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Factor Ausentismo Quincenal','1.4')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Factor Ausentismo Semanal','1.1667')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Factor Mensualizacion','30')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Faltas Proproprcional Segun Jornada','SI')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo Ahorro de Empleado','13')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Fondo Ahorro de Empresa','13')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Limitar Prestacion al Tope Fondo A','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Numero Guia',NULL)
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Pago PrimaVac Automatica','SI')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Premio Asistencia','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Premio Puntualidad','1')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Prestacion Fondo de Ahorro','0')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Registro Patronal','B613902410')
INSERT INTO PersonalPropValor (Rama,Cuenta,Propiedad,Valor) VALUES ('EMP',@Empresa,'Seguro Vivienda','13')
END
RETURN
END

