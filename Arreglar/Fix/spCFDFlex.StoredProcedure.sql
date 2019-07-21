USE [IntelisisTmp]
GO

/****** Object:  StoredProcedure [dbo].[spCFDFlex]    Script Date: 14/06/2019 11:11:23 a.m. ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[spCFDFlex] @Estacion int,
@Empresa varchar(5),
@Modulo varchar(5),
@ID int,
@Estatus varchar(15),
@Ok int OUTPUT,
@OkRef varchar(255) OUTPUT,
@LlamadaExterna bit = 0,
@Mov varchar(20) = NULL,
@MovID varchar(20) = NULL,
@Contacto varchar(10) = NULL,
@CrearArchivo bit = 0,
@Debug bit = 0,
@XMLFinal varchar(max) = NULL OUTPUT,
@Encripcion varchar(20) = NULL,
@EstatusAnterior varchar(15) = NULL

AS
BEGIN
  DECLARE @XMLSAT varchar(max),
          @XMLADENDA varchar(max),
          @XML varchar(max),
          @Temporal varchar(255),
          @RutaTemporal varchar(255),
          @Comprobante varchar(50),
          @Adenda varchar(50),
          @FechaRegistro datetime,
          @OkError int,
          @OkRefError varchar(255),
          @RutaError varchar(255),
          @DocumentoXML varchar(max),
          @iDatos int,
          @CFDFecha datetime,
          @CFDSerie varchar(10),
          @CFDFolio int,
          @CFDRFC varchar(15),
          @CFDAprobacion varchar(15),
          @CFDImporte money,
          @CFDImpuesto1 money,
          @CFDImpuesto2 money,
          @CFDRetencion1 money,
          @CFDRetencion2 money,
          @CFDnoCertificado varchar(20),
          @CFDSello varchar(max),
          @CFDCadenaOriginal varchar(max),
          @MovTipoCFDFlexEstatus varchar(15),
          @Archivo varchar(255),
          @Usuario varchar(10),
          @EnviarAlAfectar bit,
          @AlmacenarTipo varchar(20),
          @TipoCambio float,
          @CFDI bit,
          @TipoCFDI bit,
          @TimbrarEnTransaccion bit,
          @RutaTimbrarCFDI varchar(255),
          @Timbrado bit,
          @PrefijoCFDI varchar(255),
          @RutaCFDI varchar(255),
          @CFDUUID uniqueidentifier,
          @CFDFechaTimbrado datetime,
          @TFDVersion varchar(10),
          @SelloSAT varchar(max),
          @noCertificadoSAT varchar(20),
          @BloquearMovOtraFecha bit,
          @FechaEmision datetime,
          @FechaServidor datetime,
          @Sucursal int,
          @MovTipo varchar(20),
          @OrigenModulo varchar(5),
          @OrigenMovimiento varchar(20),
          @MovOrigen varchar(20),
          @CFDEsParcialidad bit,
          @OrigenUUID uniqueidentifier,
          @OrigenMovID varchar(20),
          @OrigenSerie varchar(10),
          @OrigenFolio varchar(4),
          @Caracter char(1),
          @ParcialidadNumero int,
          @SerieFolioFiscalOrig varchar(50),
          @NoValidarOrigenDocumento bit,
          @FolioFiscalOrig varchar(50),
          @Sellar bit,
          @CFDFlexEstatus varchar(15),
          @Continuar bit,
          @Adenda2 varchar(50),
          @XMLADENDA2 varchar(max),
          @RutaFirmaSAT varchar(255),
          @ExisteFirmaSAT int,
          @Existe int,
   ---------------------------------------
		  @ValidarExisteCFD   bit 

	--INSERT AbrahamTiempos2 (Hora, Texto, Texto2) VALUES (getdate(), @Mov, 'Entro') 
	DELETE CFDFlexSesion WHERE SPID = @@SPID
	INSERT CFDFlexSesion(SPID, Modulo, ModuloID) VALUES(@@SPID, @Modulo, @ID)
  ---------------------------------------

  SELECT
    @Comprobante = NULL,
    @Adenda = NULL,
    @Timbrado = 0,
    @FechaServidor = dbo.fnFechaSinHora(GETDATE())
  EXEC xpCFDFlexAntes @Estacion,
                      @Empresa,
                      @Modulo,
                      @ID,
                      @Estatus,
                      @Ok OUTPUT,
                      @OkRef OUTPUT,
                      @LlamadaExterna,
                      @Mov,
                      @MovID,
                      @Contacto,
                      @CrearArchivo,
                      @Debug,
                      @XMLFinal OUTPUT,
                      @Encripcion
  SELECT @CFDI = ISNULL(CFDI,0)  
		FROM EmpresaGral WITH (NOLOCK)  
	   WHERE Empresa = @Empresa  
  -----------------------------------------------------------------------------	  
  SELECT @ValidarExisteCFD = ISNULL(ValidarExisteCFD,0)  
  FROM EmpresaCFD WITH (NOLOCK)
  WHERE Empresa = @Empresa  
	  
  IF (@ValidarExisteCFD = 1) AND (dbo.fnCFDExisteCFD(@Modulo, @ID) = 1)  
	RETURN  
  -----------------------------------------------------------------------------
  IF @LlamadaExterna = 0
  BEGIN
    IF @Modulo = 'VTAS'
      SELECT
        @Contacto = Cliente,
        @Mov = Mov,
        @MovID = MovID,
        @FechaEmision = FechaEmision,
        @FechaRegistro = FechaRegistro,
        @Usuario = Usuario,
        @TipoCambio = TipoCambio,
        @Sucursal = Sucursal
      FROM Venta
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'CXC'
      SELECT
        @Contacto = Cliente,
        @Mov = Mov,
        @MovID = MovID,
        @FechaEmision = FechaEmision,
        @FechaRegistro = FechaRegistro,
        @Usuario = Usuario,
        @TipoCambio = TipoCambio,
        @Sucursal = Sucursal,
        @MovOrigen = Origen
      FROM Cxc
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'COMS'
      SELECT
        @Contacto = Proveedor,
        @Mov = Mov,
        @MovID = MovID,
        @FechaEmision = FechaEmision,
        @FechaRegistro = FechaRegistro,
        @Usuario = Usuario,
        @TipoCambio = TipoCambio,
        @Sucursal = Sucursal
      FROM Compra
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'CXP'
      SELECT
        @Contacto = Proveedor,
        @Mov = Mov,
        @MovID = MovID,
        @FechaEmision = FechaEmision,
        @FechaRegistro = FechaRegistro,
        @Usuario = Usuario,
        @TipoCambio = TipoCambio,
        @Sucursal = Sucursal
      FROM Cxp
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'GAS'
      SELECT
        @Contacto = Acreedor,
        @Mov = Mov,
        @MovID = MovID,
        @FechaEmision = FechaEmision,
        @FechaRegistro = FechaRegistro,
        @Usuario = Usuario,
        @TipoCambio = TipoCambio,
        @Sucursal = Sucursal
      FROM Gasto
      WHERE ID = @ID
  END
  -----------------------------------------------------------------------------
  ELSE  
  BEGIN  
		IF NULLIF(@Contacto,'') IS NULL SET @Contacto = '(Todos)'  
		  
		IF @Mov IS NULL AND @Ok IS NULL SELECT @Ok = 10160 ELSE  
		IF @Mov IS NOT NULL AND NOT EXISTS(SELECT * FROM MovTipo WITH (NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov) AND @Ok IS NULL SELECT @Ok = 14055 ELSE      
		IF @MovID IS NULL AND @Ok IS NULL SELECT @Ok = 20915 ELSE  
		IF @Contacto IS NOT NULL AND NOT EXISTS(SELECT * FROM MovTipoCFDFlex  WITH (NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov AND Contacto = @Contacto) AND @Ok IS NULL SELECT @Ok = 28020, @OkRef = @Contacto  
  END  
  -----------------------------------------------------------------------------
  
  SET @continuar = 1
  EXEC spCFDFlexTempVerificar @Empresa,
                              @Sucursal,
                              @Modulo,
                              @ID,
                              @Estatus,
                              @EstatusAnterior,
                              @Usuario,
                              @FechaEmision,
                              @FechaRegistro,
                              @Mov,
                              @MovID,
                              @MovTipo,
                              @LlamadaExterna,
                              @Contacto,
                              @Estacion,
                              0,
                              @Continuar OUTPUT,
                              @Ok OUTPUT,
                              @OkRef OUTPUT
  IF @Continuar = 0
    AND @Ok IS NULL
    RETURN
  IF @Continuar = 1
    AND @Ok IS NULL
  BEGIN
    SELECT
      @CFDI = ISNULL(CFDI, 0)
    FROM EmpresaGral
    WHERE Empresa = @Empresa
    SELECT
      @NoValidarOrigenDocumento = ISNULL(NoValidarOrigenDocumento, 0)
    FROM EmpresaCFD
    WHERE Empresa = @Empresa
    SELECT
      @MovTipo = Clave
    FROM MovTipo
    WHERE Modulo = @Modulo
    AND Mov = @Mov
    SELECT
      @Comprobante = Comprobante,
      @Adenda = Adenda,
      @MovTipoCFDFlexEstatus = NULLIF(Estatus, ''),
      @OrigenModulo = NULLIF(OrigenModulo, ''),
      @OrigenMovimiento = NULLIF(OrigenMov, '')
    FROM MovTipoCFDFlex
    WHERE Modulo = @Modulo
    AND Mov = @Mov
    AND Contacto = @Contacto
    IF @Comprobante IS NULL
      AND @Adenda IS NULL
    BEGIN
      SELECT
        @Comprobante = Comprobante,
        @Adenda = Adenda,
        @MovTipoCFDFlexEstatus = NULLIF(Estatus, ''),
        @OrigenModulo = NULLIF(OrigenModulo, ''),
        @OrigenMovimiento = NULLIF(OrigenMov, '')
      FROM MovTipoCFDFlex
      WHERE Modulo = @Modulo
      AND Mov = @Mov
      AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto, ''), '(Todos)'), '(Todos)'), @Contacto) = @Contacto
    END

	---------------------------------------
	IF @OrigenModulo IS NOT NULL AND @OrigenMovimiento IS NOT NULL  
	BEGIN  
    IF NOT EXISTS(SELECT *  
                    FROM  MovFlujo  WITH (NOLOCK)
                   WHERE Empresa = @Empresa  
                     AND DModulo = @Modulo  
                     AND DMov = @Mov  
                     AND DMovID = @MovID  
                     AND Cancelado = 0  
                     AND OModulo = @OrigenModulo  
                     AND OMov = @OrigenMovimiento  
                )  
		RETURN  
	END  
    
	IF @MovTipoCFDFlexEstatus = 'CANCELADO'  
    RETURN  
	---------------------------------------  

    IF @MovOrigen IS NULL
      SELECT
        @MovOrigen = dbo.fnCFDFlexOrigenDetalle(@ID)
    IF @Modulo = 'CXC'
      AND ('CXC.D' IN (SELECT
        Clave
      FROM MovTipo
      WHERE Mov = @MovOrigen
      AND Modulo = @Modulo)
      AND @NoValidarOrigenDocumento = 1)
    BEGIN
      SELECT
        @CFDEsParcialidad = CFDEsParcialidad
      FROM MovTipo
      WHERE Modulo = @Modulo
      AND Mov = @Mov
      IF @CFDEsParcialidad = 0
      BEGIN
        SELECT
          @Ok = 71670
        RETURN
      END
      ELSE
        EXEC spCFDFlexActualizaDocNoAuto @ID
    END


	---------------------------------------	  
		--  IF @Modulo = 'CXC' AND @MovTipo = 'CXC.C'  
		--    IF(SELECT COUNT(*) FROM CxcD WITH (NOLOCK) WHERE ID = @ID) > 1 SELECT @Ok = 60210  
				   
						
		IF @Comprobante IS NULL AND @Adenda IS NULL RETURN  
		  
		IF (@MovTipoCFDFlexEstatus <> @Estatus) OR (@MovTipoCFDFlexEstatus IS NULL) OR (NULLIF(@Estatus,'') IS NULL) RETURN    
		  
	---------------------------------------


    IF @OK IS NULL
      EXEC spCFDFlexValidarPlantillaConfiguracion @Comprobante,
                                                  @Modulo,
                                                  @CFDI,
                                                  @Ok OUTPUT,
                                                  @OkRef OUTPUT
    SELECT
      @RutaTemporal = RutaTemporal,
      @EnviarAlAfectar = EnviarAlAfectar,
      @RutaTimbrarCFDI = RutaTimbrarCFDI
    FROM EmpresaCFD
    WHERE Empresa = @Empresa
    SELECT
      @Temporal = @RutaTemporal + CASE
        WHEN SUBSTRING(REVERSE(@RutaTemporal), 1, 1) <> '\' THEN '\'
        ELSE ''
      END + 'Temporal' + CONVERT(varchar, @Estacion) + '.XML'
    SET @RutaError = REPLACE(@Temporal, 'Temporal' + CONVERT(varchar, @Estacion) + '.XML', 'Error' + CONVERT(varchar, @Estacion) + '.XML')
    SELECT
      @TipoCFDI = ISNULL(TipoCFDI, 0),
      @TimbrarEnTransaccion = ISNULL(TimbrarEnTransaccion, 0),
      @Sellar = ISNULL(Sellar, 0)
    FROM eDoc
    WHERE Modulo = @Modulo
    AND eDoc = @Comprobante
    EXEC spEliminarArchivo @RutaError,
                           @Ok OUTPUT,
                           @OkRef OUTPUT
    IF @Ok IS NULL
      AND @Sellar = 1
    BEGIN
      SELECT
        @RutaFirmaSAT = RutaFirmaSAT
      FROM EmpresaCFD
      WHERE Empresa = @Empresa
      EXEC master.dbo.xp_fileexist @RutaFirmaSAT,
                                   @ExisteFirmaSAT OUTPUT
      IF ISNULL(@ExisteFirmaSAT, 0) = 1
        EXEC spCFDFlexValidarCertificado @Estacion,
                                         @Empresa,
                                         @Sucursal,
                                         'Sucursal',
                                         @FechaRegistro,
                                         @Temporal,
                                         @Ok OUTPUT,
                                         @OkRef OUTPUT
    END
    IF @Ok IS NULL
      EXEC speDocXML @Estacion,
                     @Empresa,
                     @Modulo,
                     @Mov,
                     @ID,
                     @Comprobante,
                     @Estatus,
                     0,
                     1,
                     @XMLSAT OUTPUT,
                     @Ok OUTPUT,
                     @OkRef OUTPUT,
                     @LlamadaExterna,
                     @Contacto
    IF @Ok IS NULL
      EXEC speDocXML @Estacion,
                     @Empresa,
                     @Modulo,
                     @Mov,
                     @ID,
                     @Adenda,
                     @Estatus,
                     0,
                     1,
                     @XMLAdenda OUTPUT,
                     @Ok OUTPUT,
                     @OkRef OUTPUT,
                     @LlamadaExterna,
                     @Contacto
    IF @Ok IS NULL
      EXEC xpeDocAddenda2 @Estacion,
                          @Empresa,
                          @Modulo,
                          @Mov,
                          @ID,
                          @Estatus,
                          @Adenda2 OUTPUT
    IF @Ok IS NULL
      AND @Adenda2 IS NOT NULL
      EXEC speDocXML @Estacion,
                     @Empresa,
                     @Modulo,
                     @Mov,
                     @ID,
                     @Adenda2,
                     @Estatus,
                     0,
                     1,
                     @XMLAdenda2 OUTPUT,
                     @Ok OUTPUT,
                     @OkRef OUTPUT,
                     @LlamadaExterna,
                     @Contacto
    IF @Ok IS NULL
    BEGIN
      SET @XML = REPLACE(@XMLSAT, '_ADDENDA_DOCUMENTO_', ISNULL(@XMLADENDA, ''))
      SET @XML = REPLACE(@XML, '_ADDENDA_DOCUMENTO2_', ISNULL(@XMLADENDA2, ''))
      SET @XML = REPLACE(@XML, '<cfdi:Addenda></cfdi:Addenda>', '')
      SET @XML = REPLACE(@XML, '<Addenda></Addenda>', '')
    END
    IF @Ok IS NULL
      AND CHARINDEX('<FactDocGT xmlns' + CHAR(58) + 'xsi="http' + CHAR(58) + '//www.w3.org/2001/XMLSchema-instance" xmlns="http' + CHAR(58) + '//www.fact.com.mx/schema/gt"', @XMLSAT) = 0
      EXEC spCFDFlexValidarXMLImporte @Empresa,
                                      @XMLSAT,
                                      @RutaError,
                                      @TipoCFDI,
                                      @Ok OUTPUT,
                                      @OkRef OUTPUT
    IF @Ok IS NULL
      AND CHARINDEX('<FactDocGT xmlns' + CHAR(58) + 'xsi="http' + CHAR(58) + '//www.w3.org/2001/XMLSchema-instance" xmlns="http' + CHAR(58) + '//www.fact.com.mx/schema/gt"', @XMLSAT) <> 0
      EXEC spCFDFlexValidarXMLImportefdgt @Empresa,
                                          @XMLSAT,
                                          @RutaError,
                                          @TipoCFDI,
                                          @Ok OUTPUT,
                                          @OkRef OUTPUT
    IF @Ok IS NULL
      EXEC spCFDFlexRegenerarArchivo @Empresa,
                                     @Temporal,
                                     @XML,
                                     @Ok OUTPUT,
                                     @OkRef OUTPUT
    IF @Ok IS NULL
      AND @Sellar = 1
      EXEC spCFDFlexSellarXML @Estacion,
                              @Empresa,
                              @Sucursal,
                              @Temporal,
                              @XML OUTPUT,
                              @Ok OUTPUT,
                              @OkRef OUTPUT,
                              @Encripcion
    IF @Ok IS NULL
      AND @Sellar = 1
      EXEC spCFDFlexInsertarCertificadoXML @Estacion,
                                           @Empresa,
                                           @Sucursal,
                                           'Sucursal',
                                           1,
                                           @Temporal,
                                           @XML OUTPUT,
                                           @Ok OUTPUT,
                                           @OkRef OUTPUT
    IF @Ok IS NULL
      EXEC spCFDFlexRegenerarArchivo @Empresa,
                                     @Temporal,
                                     @XML,
                                     @Ok OUTPUT,
                                     @OkRef OUTPUT
    IF @Ok IS NULL
      AND @Sellar = 1
      EXEC spCFDFlexInsertarNoCertificadoXML @Estacion,
                                             @Empresa,
                                             @Sucursal,
                                             'Sucursal',
                                             @Temporal,
                                             @XML OUTPUT,
                                             @Ok OUTPUT,
                                             @OkRef OUTPUT
    IF @Ok IS NULL
      AND @Sellar = 1
      EXEC spCFDFlexInsertarPipeStringXML @Estacion,
                                          @Empresa,
                                          @Temporal,
                                          @XML OUTPUT,
                                          @CFDCadenaOriginal OUTPUT,
                                          @Ok OUTPUT,
                                          @OkRef OUTPUT
    IF @Ok IS NULL
    BEGIN

	  ---------------------------------------
	  SET @XML = dbo.fneDocXMLAUTF8(@XML,0,0) --ARCC  
	  ---------------------------------------
			
      EXEC spCFDFlexValidarXML @Modulo,
                               @Mov,
                               @Contacto,
                               @XML,
                               @Ok OUTPUT,
                               @OkRef OUTPUT
      IF @Ok IS NOT NULL
        SELECT
          @OkRef = CONVERT(varchar, @Ok) + '. ' + ISNULL(@OkRef, ''),
          @Ok = 71600

    END
    IF @Ok IS NULL
      AND @CFDI = 1
      AND @TipoCFDI = 1
    BEGIN
      EXEC spCFDFlexTimbrarCFDI @Estacion,
                                @Empresa,
                                @Modulo,
                                @Mov,
                                @MovID,
                                @Temporal,
                                @XML OUTPUT,
                                @Ok OUTPUT,
                                @OkRef OUTPUT
    END
    IF @CFDI = 1
      AND @TipoCFDI = 1
      AND @Ok IS NULL
      SELECT
        @Timbrado = 1
    IF @CFDI = 1
      AND @TipoCFDI = 1
      AND ISNULL(@TimbrarEnTransaccion, 0) = 0
      AND @Ok IS NOT NULL
      SELECT
        @Ok = NULL,
        @OkRef = NULL,
        @Timbrado = 0
    IF @Ok IS NULL
      AND @Modulo = 'VTAS'
      UPDATE Venta
      SET CFDTimbrado = @Timbrado
      WHERE ID = @ID
    IF @Ok IS NULL
      AND @Modulo = 'CXC'
      UPDATE Cxc
      SET CFDTimbrado = @Timbrado
      WHERE ID = @ID
    IF @Ok IS NOT NULL
    BEGIN
      SELECT
        @OkError = NULL,
        @OkRefError = NULL
      EXEC spCFDFlexRegenerarArchivo @Empresa,
                                     @RutaError,
                                     @XML,
                                     @OkError OUTPUT,
                                     @OkRefError OUTPUT
    END
    IF @Ok IS NULL
      AND @LlamadaExterna = 0
    BEGIN
      IF EXISTS (SELECT
          1
        FROM MoveDoc
        WHERE ID = @ID
        AND Modulo = @Modulo
        AND Empresa = @Empresa)
      BEGIN
        UPDATE MoveDoc
        SET eDoc = @XML
        WHERE ID = @ID
        AND Modulo = @Modulo
        AND Empresa = @Empresa
        IF @@ERROR <> 0
          SET @Ok = 1
      END
      ELSE
      BEGIN
        INSERT MoveDoc (Empresa, Modulo, ID, eDoc)
          VALUES (@Empresa, @Modulo, @ID, @XML)
        IF @@ERROR <> 0
          SET @Ok = 1
      END
    END
    IF @Ok IS NULL
    BEGIN
      IF @TipoCFDI = 0
        OR @CFDI = 0
        AND @Ok IS NULL
      BEGIN
        SET @DocumentoXML = '<?xml version="1.0" encoding="Windows-1252"?>' + @XML
        SET @DocumentoXML = REPLACE(@XML, 'xmlns=', 'xmlns' + CHAR(58) + 'Temp=')
        EXEC sp_xml_preparedocument @iDatos OUTPUT,
                                    @DocumentoXML
        SELECT
          @CFDFecha = CONVERT(datetime, RTRIM(REPLACE(fecha, 'Z', ''))),
          @CFDSerie = serie,
          @CFDFolio = folio,
          @CFDAprobacion = RTRIM(ISNULL(anoAprobacion, '')) + RTRIM(ISNULL(noAprobacion, '')),
          @CFDnoCertificado = noCertificado,
          @CFDSello = sello,
          @CFDImporte = ISNULL(subTotal, 0.0) - ISNULL(descuento, 0.0),
          @OrigenMovID = SerieFolioFiscalOrig,
          @OrigenUUID = FolioFiscalOrig
        FROM OPENXML(@iDatos, '/Comprobante', 1) WITH (fecha varchar(50), serie varchar(10), folio int, noAprobacion varchar(15), noCertificado varchar(20), sello varchar(255), subTotal money, descuento money, anoAprobacion varchar(15), SerieFolioFiscalOrig varchar(20), FolioFiscalOrig uniqueidentifier)
        SELECT
          @CFDRFC = rfc
        FROM OPENXML(@iDatos, '/Comprobante/Receptor', 1) WITH (rfc varchar(15))
        SELECT
          @CFDImpuesto1 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
        FROM OPENXML(@iDatos, '/Comprobante/Impuestos/Traslados/Traslado', 1) WITH (importe money, impuesto varchar(50))
        WHERE impuesto = 'IVA'
        SELECT
          @CFDImpuesto2 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
        FROM OPENXML(@iDatos, '/Comprobante/Impuestos/Traslados/Traslado', 1) WITH (importe money, impuesto varchar(50))
        WHERE impuesto = 'IEPS'
        SELECT
          @CFDRetencion1 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
        FROM OPENXML(@iDatos, '/Comprobante/Impuestos/Retenciones/Retencion', 1) WITH (importe money, impuesto varchar(50))
        WHERE impuesto = 'ISR'
        SELECT
          @CFDRetencion2 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
        FROM OPENXML(@iDatos, '/Comprobante/Impuestos/Retenciones/Retencion', 1) WITH (importe money, impuesto varchar(50))
        WHERE impuesto = 'IVA'
        EXEC sp_xml_removedocument @iDatos
      END
      ELSE
      IF @Ok IS NULL
      BEGIN
        SET @DocumentoXML = '<?xml version="1.0" encoding="Windows-1252"?>' + @XML
        IF @DocumentoXML NOT LIKE '%<gs1' + CHAR(58) + 'invoice%'
        BEGIN
          SET @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 'cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
          EXEC sp_xml_preparedocument @iDatos OUTPUT,
                                      @DocumentoXML,
                                      @PrefijoCFDI
          SET @DocumentoXML = REPLACE(@DocumentoXML, '<?xml version="1.0" encoding="Windows-1252"?><?xml version="1.0" encoding="Windows-1252"?>', '<?xml version="1.0" encoding="Windows-1252"?>')
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante'
          SELECT
            @CFDFecha = CONVERT(datetime, RTRIM(REPLACE(fecha, 'Z', ''))),
            @CFDSerie = serie,
            @CFDFolio = folio,
            @CFDAprobacion = RTRIM(ISNULL(anoAprobacion, '')) + RTRIM(ISNULL(noAprobacion, '')),
            @CFDnoCertificado = noCertificado,
            @CFDSello = sello,
            @CFDImporte = ISNULL(subTotal, 0.0) - ISNULL(descuento, 0.0),
            @OrigenMovID = SerieFolioFiscalOrig,
            @OrigenUUID = FolioFiscalOrig
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (fecha varchar(50), serie varchar(10), folio int, noAprobacion varchar(15), noCertificado varchar(20), sello varchar(255), subTotal money, descuento money, anoAprobacion varchar(15), SerieFolioFiscalOrig varchar(20), FolioFiscalOrig uniqueidentifier)
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Receptor'
          SELECT
            @CFDRFC = rfc
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (rfc varchar(15))
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Impuestos/cfdi' + CHAR(58) + 'Traslados/cfdi' + CHAR(58) + 'Traslado'
          SELECT
            @CFDImpuesto1 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (importe money, impuesto varchar(50))
          WHERE impuesto = 'IVA'
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Impuestos/cfdi' + CHAR(58) + 'Traslados/cfdi' + CHAR(58) + 'Traslado'
          SELECT
            @CFDImpuesto2 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (importe money, impuesto varchar(50))
          WHERE impuesto = 'IEPS'
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Impuestos/cfdi' + CHAR(58) + 'Retenciones/cfdi' + CHAR(58) + 'Retencion'
          SELECT
            @CFDRetencion1 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (importe money, impuesto varchar(50))
          WHERE impuesto = 'ISR'
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Impuestos/cfdi' + CHAR(58) + 'Retenciones/cfdi' + CHAR(58) + 'Retencion'
          SELECT
            @CFDRetencion2 = ISNULL(SUM(ISNULL(importe, 0.0)), 0.0)
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (importe money, impuesto varchar(50))
          WHERE impuesto = 'IVA'
          SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
          SELECT
            @CFDUUID = UUID,
            @CFDFechaTimbrado = CONVERT(datetime, RTRIM(REPLACE(FechaTimbrado, 'Z', ''))),
            @TFDVersion = version,
            @SelloSAT = selloSAT,
            @noCertificadoSAT = noCertificadoSAT
          FROM OPENXML(@iDatos, @RutaCFDI, 1) WITH (UUID uniqueidentifier, FechaTimbrado varchar(50), version varchar(10), selloSAT varchar(max), noCertificadoSAT varchar(20))
          EXEC sp_xml_removedocument @iDatos
        END
        ELSE
        BEGIN
          SET @DocumentoXML = REPLACE(@DocumentoXML, 'xmlns=', 'Temp=')
          SELECT
            @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 'gs1="urn' + CHAR(58) + 'ean.ucc' + CHAR(58) + 'pay' + CHAR(58) + '2" xmlns' + CHAR(58) + 'xsi="http' + CHAR(58) + '//www.w3.org/2001/XMLSchema-instance" xsi' + CHAR(58) + 'noNamespaceSchemaLocation="http' + CHAR(58) + '//www.mysuitemex.com/fact/schema/gt/DTEgt.xsd"/>'
          EXEC sp_xml_preparedocument @iDatos OUTPUT,
                                      @DocumentoXML,
                                      @PrefijoCFDI
          SET @RutaCFDI = '/DTE/Documento/gs1' + CHAR(58) + 'invoice'
          SELECT
            @CFDFechaTimbrado = CONVERT(datetime, RTRIM(creationDateTime))
          FROM OPENXML(@iDatos, @RutaCFDI, 2) WITH (creationDateTime varchar(50))
          SET @RutaCFDI = '/DTE/Documento/CAE/DCAE'
          SELECT
            @CFDSerie = Serie,
            @CFDFolio = NumeroDocumento,
            @CFDAprobacion = NumeroAutorizacion,
            @CFDRFC = NITReceptor,
            @CFDFecha = FechaEmision,
            @CFDImpuesto1 = ISNULL(IVA, 0.0),
            @CFDImporte = ISNULL(ImporteTotal, 0.0)
          FROM OPENXML(@iDatos, @RutaCFDI, 2) WITH (Serie varchar(10), NumeroDocumento int, NumeroAutorizacion varchar(15), NITReceptor varchar(15), FechaEmision datetime, IVA money, ImporteTotal money)
          SET @RutaCFDI = '/DTE/Documento/CAE/FCAE'
          SELECT
            @SelloSAT = SignatureValue
          FROM OPENXML(@iDatos, @RutaCFDI, 2) WITH (SignatureValue varchar(50))
          EXEC sp_xml_removedocument @iDatos
          UPDATE CFD
          SET SelloSAT = @SelloSAT
          WHERE Modulo = @Modulo
          AND ModuloID = @ID
        END
      END
    END
    IF @Ok IS NULL
    BEGIN
      IF EXISTS (SELECT
          1
        FROM CFD
        WHERE ModuloID = @ID
        AND Modulo = @Modulo)
        DELETE FROM CFD
        WHERE Modulo = @Modulo
          AND ModuloID = @ID
      IF @@ERROR <> 0
        SET @Ok = 1
    END
    IF @Ok IS NULL
    BEGIN
      SELECT
        @FolioFiscalOrig = dbo.fnCFDFlexCampoOrigen('CXC', @ID, 'FolioFiscalOrig')
      SELECT
        @SerieFolioFiscalOrig = dbo.fnCFDFlexCampoOrigen('CXC', @ID, 'SerieFolioFiscalOrig')
      SELECT
        @OrigenSerie = dbo.fnSerieConsecutivo(@SerieFolioFiscalOrig)
      SELECT
        @OrigenFolio = dbo.fnFolioConsecutivo(@SerieFolioFiscalOrig)
      SELECT
        @ParcialidadNumero = dbo.fnCFDFlexParcialidadNumero(@OrigenSerie, @OrigenFolio, @OrigenUUID)
    END
    IF @Ok IS NULL
    BEGIN
      INSERT CFD (Modulo, ModuloID, Fecha, Ejercicio, Periodo, Empresa, MovID, Serie, Folio, RFC, Aprobacion, Importe, Impuesto1, Impuesto2, Retencion1, Retencion2, noCertificado, Sello, CadenaOriginal, Documento, TipoCambio, Timbrado, UUID, FechaTimbrado, TFDVersion, SelloSAT, noCertificadoSAT, OrigenUUID, OrigenSerie, OrigenFolio, ParcialidadNumero)
        VALUES (@Modulo, @ID, @CFDFecha, YEAR(@CFDFecha), MONTH(@CFDFecha), @Empresa, @MovID, @CFDSerie, @CFDFolio, @CFDRFC, @CFDAprobacion, @CFDImporte, @CFDImpuesto1, @CFDImpuesto2, @CFDRetencion1, @CFDRetencion2, @CFDnoCertificado, @CFDSello, @CFDCadenaOriginal, @XML, @TipoCambio, @Timbrado, @CFDUUID, @CFDFechaTimbrado, @TFDVersion, @SelloSAT, @noCertificadoSAT, @OrigenUUID, @OrigenSerie, @OrigenFolio, @ParcialidadNumero)
      UPDATE CFD
      SET TFDCadenaOriginal = dbo.fnCFDFlexCadenaOriginalTFDI(@Modulo, @ID)
      WHERE Modulo = @Modulo
      AND ModuloID = @ID
      IF @@ERROR <> 0
        SET @Ok = 1
    END
    IF @Ok IS NULL
      EXEC xpCFDFlexDespues @Estacion,
                            @Empresa,
                            @Modulo,
                            @ID,
                            @Estatus,
                            @Ok OUTPUT,
                            @OkRef OUTPUT,
                            @LlamadaExterna,
                            @Mov,
                            @MovID,
                            @Contacto,
                            @CrearArchivo,
                            @Debug,
                            @XMLFinal,
                            @Encripcion
    IF @Ok IS NULL
      SELECT
        @CFDFlexEstatus = 'CONCLUIDO'
    ELSE
      SELECT
        @CFDFlexEstatus = 'ERROR'
    IF @Modulo = 'VTAS'
      UPDATE Venta
      SET CFDFlexEstatus = @CFDFlexEstatus
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'CXC'
      UPDATE Cxc
      SET CFDFlexEstatus = @CFDFlexEstatus
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'COMS'
      UPDATE Compra
      SET CFDFlexEstatus = @CFDFlexEstatus
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'CXP'
      UPDATE Cxp
      SET CFDFlexEstatus = @CFDFlexEstatus
      WHERE ID = @ID
    ELSE
    IF @Modulo = 'GAS'
      UPDATE Gasto
      SET CFDFlexEstatus = @CFDFlexEstatus
      WHERE ID = @ID
    IF @Ok IS NULL
      AND @CrearArchivo = 1
    BEGIN
      SELECT
        @Archivo = @RutaTemporal + CASE
          WHEN SUBSTRING(REVERSE(@RutaTemporal), 1, 1) <> '\' THEN '\'
          ELSE ''
        END + @Modulo + '_' + CONVERT(varchar, @ID) + '.XML'
      EXEC spCFDFlexRegenerarArchivo @Empresa,
                                     @Archivo,
                                     @XML,
                                     @Ok OUTPUT,
                                     @OkRef OUTPUT
    END
    IF (@Ok IS NULL
      AND ISNULL(@TipoCFDI, 0) = 0
      AND @EnviarAlAfectar = 1)
      OR (@EnviarAlAfectar = 1
      AND ISNULL(@CFDI, 0) = 1
      AND ISNULL(@TipoCFDI, 0) = 1
      AND @Ok IS NULL
      AND @Timbrado = 1)
    BEGIN
      SELECT
        @AlmacenarTipo = NULL
      SELECT
        @AlmacenarTipo = NULLIF(AlmacenarTipo, '')
      FROM CteCFD
      WHERE Cliente = @Contacto
      EXEC spCFDFlexGenerarPDF @Empresa,
                               @Modulo,
                               @Mov,
                               @ID,
                               @Usuario,
                               0,
                               @Ok = @Ok OUTPUT,
                               @OkRef = @OkRef OUTPUT
      IF @AlmacenarTipo = 'Adicional'
        EXEC spCFDFlexGenerarPDF @Empresa,
                                 @Modulo,
                                 @Mov,
                                 @ID,
                                 @Usuario,
                                 1,
                                 @Ok = @Ok OUTPUT,
                                 @OkRef = @OkRef OUTPUT
      IF @Ok IS NULL
      BEGIN
        UPDATE CFD
        SET GenerarPDF = 1
        WHERE Modulo = @Modulo
        AND ModuloID = @ID
        IF @@ERROR <> 0
          SET @Ok = 1
      END
    END
  END
  IF EXISTS (SELECT
      *
    FROM CFDFlexTemp
    WHERE ID = @ID
    AND Modulo = @Modulo)
    DELETE CFDFlexTemp
    WHERE ID = @ID
      AND Modulo = @Modulo
  IF @Debug = 1
    SELECT
      CONVERT(xml, @XML)
  SELECT
    @XMLFinal = @XML
  IF @Ok IS NULL
    EXEC spVerificarArchivo @Temporal,
                            @Existe OUTPUT,
                            @Ok OUTPUT,
                            @OkRef OUTPUT
  IF ISNULL(@Existe, 0) = 1
    AND @Ok IS NULL
    EXEC spEliminarArchivo @Temporal,
                           @Ok OUTPUT,
                           @OkRef OUTPUT
END
GO