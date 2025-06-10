object FormPedido: TFormPedido
  Left = 0
  Top = 0
  Caption = 'Pedido de Vendas'
  ClientHeight = 400
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object lblCodigoCliente: TLabel
    Left = 25
    Top = 15
    Width = 73
    Height = 13
    Caption = 'C'#243'digo Cliente:'
  end
  object lblTotal: TLabel
    Left = 16
    Top = 370
    Width = 77
    Height = 13
    Caption = 'Total: R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblProduto: TLabel
    Left = 20
    Top = 47
    Width = 78
    Height = 13
    Caption = 'C'#243'digo Produto:'
  end
  object lblQtd: TLabel
    Left = 38
    Top = 86
    Width = 60
    Height = 13
    Caption = 'Quantidade:'
  end
  object lblValorUnit: TLabel
    Left = 186
    Top = 86
    Width = 68
    Height = 13
    Caption = 'Valor Unit'#225'rio:'
  end
  object edtCodigoCliente: TEdit
    Left = 110
    Top = 12
    Width = 60
    Height = 21
    BevelKind = bkFlat
    TabOrder = 0
    OnChange = edtCodigoClienteChange
    OnExit = edtCodigoClienteExit
  end
  object btnInserirItem: TButton
    Left = 500
    Top = 97
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 6
    OnClick = btnInserirItemClick
  end
  object grdItens: TStringGrid
    Left = 16
    Top = 144
    Width = 560
    Height = 220
    DefaultColWidth = 100
    FixedCols = 0
    RowCount = 2
    TabOrder = 7
    OnKeyDown = grdItensKeyDown
  end
  object btnGravar: TButton
    Left = 500
    Top = 370
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 8
    OnClick = btnGravarClick
  end
  object edtCodigoProduto: TEdit
    Left = 110
    Top = 44
    Width = 60
    Height = 21
    BevelKind = bkFlat
    TabOrder = 2
    OnExit = edtCodigoProdutoExit
  end
  object edtQuantidade: TEdit
    Left = 110
    Top = 83
    Width = 60
    Height = 21
    BevelKind = bkFlat
    TabOrder = 4
  end
  object edtValorUnitario: TEdit
    Left = 265
    Top = 83
    Width = 60
    Height = 21
    BevelKind = bkFlat
    TabOrder = 5
  end
  object cmbCliente: TComboBox
    Left = 176
    Top = 12
    Width = 399
    Height = 21
    BevelKind = bkFlat
    TabOrder = 1
    OnChange = cmbClienteChange
  end
  object cmbProdutos: TComboBox
    Left = 176
    Top = 44
    Width = 399
    Height = 21
    BevelKind = bkFlat
    TabOrder = 3
    TabStop = False
    OnChange = cmbProdutosChange
  end
  object btnCarregarPedido: TButton
    Left = 273
    Top = 370
    Width = 94
    Height = 25
    Caption = 'Carregar Pedido'
    TabOrder = 9
    OnClick = btnCarregarPedidoClick
  end
  object btnCancelarPedido: TButton
    Left = 385
    Top = 370
    Width = 94
    Height = 25
    Caption = 'Cancelar Pedido'
    TabOrder = 10
    OnClick = btnCancelarPedidoClick
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 72
    Top = 224
  end
end
