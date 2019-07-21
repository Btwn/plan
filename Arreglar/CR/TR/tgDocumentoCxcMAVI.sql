SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER [dbo].[tgDocumentoCxcMAVI]
ON [dbo].[Cxc]
FOR INSERT
AS
BEGIN
  DECLARE @Proveedor varchar(10),
          @Mensaje varchar(100),
          @Mov char(20),
          @ID int,
          @RenglonID int,
          @FechaEmision datetime,
          @Clave char(20),
          @Origen varchar(20),
          @OrigenID varchar(20),
          @FechaOriginal datetime,
          @Remanente money,
          @CteFinal varchar(10),
          @CteFinalCXC varchar(10)

  SELECT
    @ID = ID
  FROM Inserted

  SELECT
    @Clave = MovTipo.Clave,
    @Mov = Cxc.Mov,
    @FechaEmision = Cxc.Vencimiento
  FROM Cxc WITH (NOLOCK)
  JOIN MovTipo WITH (NOLOCK)
    ON MovTipo.Mov = Cxc.Mov
    AND MovTipo.Modulo = 'CXC'
  WHERE Cxc.ID = @ID

  IF @Clave IN ('CXC.D', 'CXC.F', 'CXC.CA') -- select * from MovTipo Where Modulo = 'CXC'  and clave in ( 'CXC.D','CXC.F','CXC.CA' )     
  --FOX
  BEGIN
    UPDATE CXC WITH (ROWLOCK)
    SET FechaOriginal = @FechaEmision,
        FechaOriginalAnt = @FechaEmision,
        ReferenciaMAVI = Referencia
    WHERE ID = @ID

    SELECT
      @Origen = Origen,
      @OrigenID = Origenid,
      @CteFinalCXC = CteFinal
    FROM CXC WITH (NOLOCK)
    WHERE ID = @ID

    SELECT
      @CteFinal = CteFinal
    FROM Venta WITH (NOLOCK)
    WHERE Mov = @Origen
    AND MovId = @OrigenID

    UPDATE Cxc WITH (ROWLOCK)
    SET CteFinal = @CteFinal
    WHERE ID = @ID

    IF @CteFinal IS NULL
      AND (@Mov = 'Nota Cargo'
      OR @Mov = 'Nota Cargo VIU')
    BEGIN
      UPDATE Cxc WITH (ROWLOCK)
      SET CteFinal = @CteFinalCXC
      WHERE ID = @ID
    END
  END

  IF @Clave IN ('CXC.CAP') -- select * from MovTipo Where Modulo = 'CXC'  and clave in ( 'CXC.D','CXC.F','CXC.CA' )     
  --ADN
  BEGIN

    SELECT
      @Origen = Origen,
      @OrigenID = Origenid
    FROM CXC WITH (NOLOCK)
    WHERE ID = @ID
    SELECT
      @CteFinal = CteFinal
    FROM Venta WITH (NOLOCK)
    WHERE Mov = @Origen
    AND MovId = @OrigenID
    UPDATE Cxc WITH (ROWLOCK)
    SET CteFinal = @CteFinal
    WHERE ID = @ID

  END



  IF @Mov LIKE '%Contra Recibo%'
  BEGIN
    SELECT
      @Origen = Origen,
      @OrigenID = Origenid
    FROM CXC WITH (NOLOCK)
    WHERE ID = @ID
    SELECT
      @FechaOriginal = FechaOriginal,
      @Remanente = InteresesMoratoriosMAVI
    FROM CXC WITH (NOLOCK)
    WHERE Mov = @Origen
    AND MovId = @OrigenID

    UPDATE CXC WITH (ROWLOCK)
    SET FechaOriginal = @FechaOriginal,
        InteresesMoratoriosMAVI = @Remanente
    WHERE ID = @ID

  END
  RETURN
END
