SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSugerirCobroxFact]      
      @SugerirPago varchar(20),      
      @Modulo  char(5),      
      @ID   int,      
      @ImporteTotal money, -- = NULL,      
      @Usuario varchar(10),      
   @Estacion int      
      
-- Se cambia el sp para q inserte en la tabla previa para Negociacion y condonacion de Moratorios antes de generar el cobro      
      
--//WITH ENCRYPTION      
AS BEGIN  -- 1      
  DECLARE      
    @Empresa   char(5),      
    @Sucursal   int,      
    @Hoy    datetime,      
    @Vencimiento  datetime,      
    @DiasCredito  int,      
    @DiasVencido  int,      
    @TasaDiaria   float,      
    @Moneda    char(10),      
    @TipoCambio   float,      
    @Contacto   char(10),      
    @Renglon   float,      
    @Aplica    varchar(20),      
    @AplicaID   varchar(20),      
    @AplicaMovTipo  varchar(20),      
    @Capital   money,      
    @Intereses   money,      
    @InteresesOrdinarios money,      
    @InteresesFijos  money,      
    @InteresesMoratorios money,      
    @ImpuestoAdicional  float,      
    @Importe   money,      
    @SumaImporte  money,      
    @Impuestos   money,      
    @DesglosarImpuestos  bit,      
    @LineaCredito  varchar(20),      
    @Metodo    int,      
    @GeneraMoratorioMAVI char(1),      
    @MontoMinimoMor  float,      
    @CondonaMoratorios int,      
    @IDDetalle   int,      
    @ImpReal   money,      
    @ClaveID   int,      
    @Mov    varchar(20),      
    @MovID    varchar(20),      
    @Valor    varchar(50),      
    @MovNC    varchar(20),      
    @MovIDNC   varchar(20),      
    @IdNc    int,      
    @MoratorioAPagar money,      
    @Concepto   varchar(50),      
    @Origen    varchar(20),      
    @OrigenID   varchar(20),    
    @NotaCredxCanc char(1),
    @AplicaNota varchar(20),
    @AplicaIDNota varchar(20),
	@min   int,
	@max   int      
      
  -- Se  hace una primer pasada (cursor) para calculo de moratorios hasta donde cubra el importe del cobro      
  --  si @ImporteTotal > 0 se hace una segunda pasada para ver cuanto de los doctos se alcanza a cubrir      
  DELETE NegociaMoratoriosMAVI With(RoWlock) WHERE IDCobro = @ID --AND Usuario = @Usuario AND Estacion = @Estacion    
  DELETE FROM HistCobroMoratoriosMAVI With(RoWlock) WHERE IDCobro = @ID ---- pzamudio 30 julio 2010                                                   --    
  IF EXISTS(SELECT * FROM TipoCobroMAVI with(Nolock) WHERE IDCobro = @ID)  
    UPDATE TipoCobroMAVI With(Rowlock) SET TipoCobro = 0  WHERE IDCobro = @ID  
  ELSE  
    INSERT INTO TipoCobroMAVI(IDCobro, TipoCobro) VALUES(@ID, 0)  
    

  SELECT @DesglosarImpuestos = 0 , @Renglon = 0.0, @SumaImporte = 0.0, @ImporteTotal = NULLIF(@ImporteTotal, 0.0), @SugerirPago = UPPER(@SugerirPago), @MoratorioAPagar = 0              
    
  SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Hoy = FechaEmision, @Moneda = Moneda, @TipoCambio = TipoCambio, @Contacto = Cliente   FROM Cxc WITH (NOLOCK) WHERE ID = @ID       
  DELETE CxcD WHERE ID = @ID       
  SELECT @MontoMinimoMor = ISNULL(MontoMinMoratorioMAVI,0) FROM EmpresaCfg2 with(Nolock) WHERE Empresa = @Empresa         
--Se comento el prestamo personal porque con la nueva configuracion no aplicara a prestamos personales
   CREATE TABLE #NotaXCanc(Mov varchar(20) NULL,MovID varchar(20) NULL)
  INSERT INTO  #NotaXCanc(Mov,MovID)
  SELECT DISTINCT d.mov,d.movid from negociamoratoriosmavi  c with(Nolock), cxcpendiente d with(Nolock), cxc n WITH (NOLOCK) WHERE c.mov in('Nota Cargo'/*,'Nota Cargo VIU'*/) and d.cliente=@Contacto
  and d.mov=c.mov and d.movid=c.movid and d.padremavi in ('Credilana'/*,'Prestamo Personal'*/) and n.mov=c.mov and n.movid=c.movid
  and n.concepto in ('CANC COBRO CRED Y PP')
        
  -- Tabla donde se inserten las Facturas pendientes de pago del cte (ListaSt)      
   CREATE TABLE #MovsPendientes(ID  int IDENTITY(1,1) NOT NULL,      
          Aplica  varchar(20) NULL,      
          AplicaID  varchar(20) NULL,      
          Vencimiento datetime NULL,      
          Clave   varchar(20) NULL,      
          Saldo   money NULL,      
          Origen  varchar(20) NULL,      
          OrigenId  varchar(20) NULL,     
    NotaCredxCanc char(1) NULL      
          )      
  -- SELECT Clave FROM ListaSt WHERE Estacion = @Estacion    -- yani    
  DECLARE @crLista As Table (ID int identity(1,1), Clave Varchar(255))             
   Insert into @crLista (Clave)
   SELECT Clave FROM ListaSt WITH (NOLOCK) WHERE Estacion = @Estacion      
    
	select @min=MIN(ID), @max=MAX(ID) From @crLista 

      
          
  WHILE @min <= @max AND @ImporteTotal >=  @SumaImporte       
  BEGIN  -- 2      
     select  @ClaveID=Clave From @crLista  Where ID = @min
   
  IF @ImporteTotal >=  @SumaImporte       
   BEGIN  -- 3      
      --select @ClaveID as 'ClaveID'      
      SELECT @Mov = Mov, @MovId = MovId FROM CXC WITH (NOLOCK) WHERE ID = @ClaveID      
      SELECT @Valor = RTRIM(@Mov)+'_'+RTRIM(@MovId)      

      
      -- Se verifica si el mov tiene hijos pendientes       
      INSERT INTO #MovsPendientes(Aplica, AplicaId, Vencimiento, Clave, Saldo, Origen, OrigenID)      
      SELECT c.Mov, c.MovID, c.Vencimiento, mt.Clave, ISNULL(c.Saldo*mt.Factor* c.TipoCambio/@TipoCambio, 0.0), c.PadreMAVI, c.PadreIDMAVI       
        FROM Cxc C with(Nolock)   
        JOIN MovTipo mt with(Nolock) ON mt.Modulo = @Modulo AND mt.Mov = c.Mov             
       WHERE c.Empresa = @Empresa AND c.Cliente = @Contacto AND c.estatus = 'PENDIENTE' AND mt.Clave NOT IN ('CXC.SCH','CXC.SD','CXC.NC') and PadreMAVI = @Mov AND PadreIDMAVI = @MovID            
 
    END -- 3    
    SET @min=@min+1   
  END -- 2    
       

               
      DECLARE @crAplica As Table (ID int Identity(1,1), Aplica Varchar(25), AplicaId Varchar(25), Vencimiento Datetime, Clave Varchar(10),Saldo Money, origen Varchar(25), Origenid Varchar(25), NotaCredxCanc char(1)) 
	  insert into @crAplica (Aplica,AplicaId,Vencimiento,Clave,Saldo,origen,Origenid,NotaCredxCanc)     
       SELECT Aplica, AplicaId, Vencimiento, Clave, Saldo, Origen, OrigenID, NotaCredxCanc      
         FROM #MovsPendientes       
        ORDER BY Vencimiento      
               
      Select @min=MIN(ID), @max=MAX(ID) From @crAplica 
	              
      WHILE @min <= @max AND @ImporteTotal > @SumaImporte      
      BEGIN  -- 7 
		Select  @Aplica=Aplica, @AplicaID=AplicaId, @Vencimiento=Vencimiento, @AplicaMovTipo=Clave, 
		@Capital=Saldo, @Origen=origen, @OrigenID=Origenid, @NotaCredxCanc=NotaCredxCanc 
		
		From @crAplica where ID=@min        
    
       SELECT @CondonaMoratorios = 0, @GeneraMoratorioMAVI = NULL, @IDDetalle = 0, @MoratorioAPagar = 0            
  
          
        SELECT @IDDetalle = ID FROM CXC with(Nolock) WHERE Mov = @Aplica AND MovId = @AplicaID --AND OrigenTipo = 'CXC'          
    
     -- Si el docto esta en tiempo de pagarse no se le generan moratorios solo se traspasa al detalle del cobro      
      -- Verificar si el mov, el canal de venta y el cliente deben generar moratorios      
    SELECT @GeneraMoratorioMAVI = dbo.fnGeneraMoratorioMAVI(@IDDetalle)      
    IF @GeneraMoratorioMAVI = '1' --OR @Aplica = 'Cargo Moratorio'     
    BEGIN  --9      
 
      SELECT @InteresesMoratorios = 0      
  
        SELECT @InteresesMoratorios = dbo.fnInteresMoratorioMAVI(@IDDetalle)      

          
      SELECT @MoratorioAPagar = @InteresesMoratorios             
          
      IF @InteresesMoratorios <= @MontoMinimoMor AND  @InteresesMoratorios > 0      
      BEGIN  -- 10      
        -- Aun cuando el usuario est‚ autorizado a condonar moratorios, si estos son menores al monto m¡nimo se condonan y registran      
    
              IF EXISTS(SELECT * FROM CondonaMorxSistMAVI with(Nolock) WHERE IDCobro = @ID AND IDMov = @IDDetalle AND Estatus = 'ALTA')      
                UPDATE CondonaMorxSistMAVI  WITH (ROWLOCK)    
                   SET MontoOriginal = @InteresesMoratorios,      
                       MontoCondonado =  @InteresesMoratorios      
                 WHERE IDCobro = @ID AND IDMov = @IDDetalle AND Estatus = 'ALTA'      
      
              ELSE      
                INSERT INTO CondonaMorxSistMAVI(Usuario,  FechaAutorizacion, IDMov,   RenglonMov, Mov, MovID,  MontoOriginal,    MontoCondonado, TipoCondonacion, Estatus, IDCobro)      
                                       VALUES(@Usuario, Getdate(),   @IDDetalle, 0,   @Aplica, @AplicaID, @InteresesMoratorios, @InteresesMoratorios, 'Por Sistema', 'ALTA', @ID)       
              SELECT @InteresesMoratorios = 0      
   END  --  10      
                
    END   -- 9      
    ELSE   SELECT @InteresesMoratorios = 0      
     -- Intereses Moratorios                           
          IF @InteresesMoratorios > 0 --OR @Aplica = 'Cargo Moratorio'      
          BEGIN      
      
          IF @SumaImporte + @InteresesMoratorios > @ImporteTotal SELECT @MoratorioAPagar = @ImporteTotal - @SumaImporte      
             SELECT @SumaImporte = @SumaImporte + @MoratorioAPagar      
      
              INSERT NegociaMoratoriosMAVI( IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, MoratorioAPagar, Origen, OrigenID)      
                                    VALUES(@ID, @Estacion, @Usuario, @Aplica, @AplicaId, @Capital, 0, @InteresesMoratorios, 0, @MoratorioAPagar, @Origen, @OrigenId)      

            IF @Aplica IN ('Nota Cargo'/*,'Nota Cargo VIU'*/)
					BEGIN
					  SELECT @AplicaNota= ISNULL(Mov,'NA'), @AplicaIDNota = ISNULL(MovID,'NA') FROM #NotaXCanc WHERE Mov=@Aplica and MovID=@AplicaID 
						  IF @AplicaNota <> 'NA' AND @AplicaIDNota <> 'NA'
							UPDATE NegociaMoratoriosMAVI WITH (ROWLOCK) SET NotaCreditoxCanc = '1' WHERE IDCobro = @ID AND Estacion = @Estacion AND Mov = @Aplica AND MovID = @AplicaID      
					  END     
          END      
           
         Set @min=@min+1       
          
      END --7             
     
  -- 2da  pasada a evaluar doctos mientras alcance el importe del cobro segun la opcion seleccionada             
      IF @Modulo = 'CXC' AND @SumaImporte <=  @ImporteTotal       
      BEGIN  -- 1      
        
        DECLARE @crDocto As Table (ID int identity(1,1), Aplica Varchar(25),AplicaId Varchar(25),Vencimiento datetime,Clave Varchar(10),Saldo money, Origen Varchar(25), Origenid Varchar(25),NotaCredxCanc char(1))      
         Insert into @crDocto (Aplica,AplicaId,Vencimiento,Clave,Saldo,Origen,Origenid,NotaCredxCanc)
		 SELECT Aplica, AplicaId, Vencimiento, Clave, Saldo, Origen, OrigenID, NotaCredxCanc      
           FROM #MovsPendientes       
          ORDER BY Vencimiento      
            
		select @min=MIN(ID), @max=MAX(ID) from  @crDocto	            
						     
             
        WHILE @min <= @max AND @ImporteTotal >= @SumaImporte       
        BEGIN  -- 11      

			
			select  @Aplica=Aplica, @AplicaID=AplicaId, @Vencimiento=Vencimiento, @AplicaMovTipo=Clave, @Capital=Saldo,  @Origen=Origen, @OrigenID=Origenid, @NotaCredxCanc=NotaCredxCanc
			from @crDocto Where ID=@min 
			     
            SELECT @ImpReal = @Capital      
            IF @SumaImporte + @Capital > @ImporteTotal SELECT @Capital = @ImporteTotal - @SumaImporte      
              SELECT @SumaImporte = @SumaImporte + @Capital      
      
              --select @Capital as 'Capital'  -- yrg      
            IF @Capital > 0      
              IF EXISTS(SELECT * FROM NegociaMoratoriosMAVI WITH (NOLOCK) WHERE IDCobro = @ID AND Estacion = @Estacion AND Mov = @Aplica AND MovID = @AplicaID)      
              begin  -- yrg  13      
                --select 'Entra a act Capital de Doctos'      
                UPDATE NegociaMoratoriosMAVI WITH (ROWLOCK)    
                   SET ImporteAPagar = @Capital      
                 WHERE Estacion = @Estacion      
                   AND Mov      = @Aplica      
                   AND MovID    = @AplicaID      

			IF @Aplica IN ('Nota Cargo'/*,'Nota Cargo VIU'*/)
					BEGIN
					  SELECT @AplicaNota= ISNULL(Mov,'NA'), @AplicaIDNota = ISNULL(MovID,'NA') FROM #NotaXCanc WHERE Mov=@Aplica and MovID=@AplicaID 
						  IF @AplicaNota <> 'NA' AND @AplicaIDNota <> 'NA'
							UPDATE NegociaMoratoriosMAVI WITH (ROWLOCK) SET NotaCreditoxCanc = '1' WHERE IDCobro = @ID AND Estacion = @Estacion AND Mov = @Aplica AND MovID = @AplicaID      
					  END 
                   end  -- 13      
            ELSE       
              INSERT NegociaMoratoriosMAVI( IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, Origen, OrigenID, NotaCreditoxCanc)      
              VALUES(@ID, @Estacion, @Usuario, @Aplica, @AplicaId, @ImpReal, @Capital, @InteresesMoratorios, 0, @Origen, @OrigenID, @NotaCredxCanc)      
         
     IF @Aplica IN ('Nota Cargo'/*,'Nota Cargo VIU'*/)
					BEGIN
					  SELECT @AplicaNota= ISNULL(Mov,'NA'), @AplicaIDNota = ISNULL(MovID,'NA') FROM #NotaXCanc WHERE Mov=@Aplica and MovID=@AplicaID 
						  IF @AplicaNota <> 'NA' AND @AplicaIDNota <> 'NA'
							UPDATE NegociaMoratoriosMAVI WITH (ROWLOCK) SET NotaCreditoxCanc = '1' WHERE IDCobro = @ID AND Estacion = @Estacion AND Mov = @Aplica AND MovID = @AplicaID      
					  END     
           
          SET @min=@min+1       
        END -- 11      
   
      END -- 10      
       
  DROP TABLE #NotaXCanc
  DROP TABLE #MovsPendientes  -- yani 23.12.09      
  -- Actualiza el tipo de pago      
  EXEC spTipoPagoBonifMAVI @SugerirPago, @ID      
  EXEC spBonifMonto @ID      
  EXEc spImpTotalBonifMAVI @ID      
  --select * from  NegociaMoratoriosMAVI where IDcobro = @ID      
  RETURN      
END  -- 1      

