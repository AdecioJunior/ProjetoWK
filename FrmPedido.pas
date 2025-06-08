unit FrmPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, VCL.Graphics, Vcl.DBGrids, UPedido, UProduto, UProdutoDAO, UPedidoDAO,
  UItemPedido, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Vcl.ExtCtrls;

type
  TFormPedido = class(TForm)
    edtCodigoCliente: TEdit;
    btnInserirItem: TButton;
    grdItens: TStringGrid;
    lblTotal: TLabel;
    btnGravar: TButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    lblProduto: TLabel;
    edtCodigoProduto: TEdit;
    lblQtd: TLabel;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    lblValorUnit: TLabel;
    cmbCliente: TComboBox;
    cmbProdutos: TComboBox;
    btnCarregarPedido: TButton;
    btnCancelarPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure grdItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbClienteChange(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure cmbProdutosChange(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
  private
    FPedido: TPedido;
    FEditandoIndice: Integer;

    procedure AtualizarGrid;
    procedure AtualizarTotal;
    procedure ExcluirItemSelecionado;
    procedure EditarItemSelecionado;
    procedure BloqueiaSelecionarCliente(Bloqueia: Boolean);
    procedure CarregaListaClientes;
    procedure CarregaListaProdutos;

    procedure ClearHead;
    function DadosPreenchidos: Boolean;

  public
    { Public declarations }
  end;

var
  FormPedido: TFormPedido;

implementation

uses
  UCliente, UClienteDao;

{$R *.dfm}

procedure TFormPedido.FormCreate(Sender: TObject);
begin
  FPedido := TPedido.Create;
  FPedido.Numero := TPedidoDAO.ProximoNumero;
  FPedido.DataEmissao := Date;
  FEditandoIndice := -1;
  BloqueiaSelecionarCliente(False);
  CarregaListaClientes;
  CarregaListaProdutos;
  edtCodigoClienteChange(Self);
end;

procedure TFormPedido.grdItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        EditarItemSelecionado;
      end;

    VK_DELETE:
      begin
        if MessageDlg('Deseja realmente apagar este item do pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          FPedido.Itens.Delete(grdItens.Row - 1);
          AtualizarGrid;
          AtualizarTotal;
          FEditandoIndice := -1;
        end;
      end;
  end;

  Key:= 0;
end;

procedure TFormPedido.BloqueiaSelecionarCliente(Bloqueia: Boolean);
begin
  if (Bloqueia = True) then
  begin
    edtCodigoCliente.ReadOnly := True;
    edtCodigoCliente.Color := cl3DLight;
    edtCodigoCliente.TabStop := False;

    cmbCliente.Style := csOwnerDrawFixed;
    cmbCliente.Color := cl3DLight;
    cmbCliente.TabStop := False;
  end else
  begin
    edtCodigoCliente.ReadOnly := False;
    edtCodigoCliente.Color := clWindow;
    edtCodigoCliente.TabStop := True;

    cmbCliente.Style := csDropDown;
    cmbCliente.Color := clWindow;
    cmbCliente.TabStop := False;
  end;
  cmbCliente.Repaint;
end;

procedure TFormPedido.btnInserirItemClick(Sender: TObject);
var
  Produto: TProduto;
  Item: TItemPedido;
  Quantidade: Integer;
  ValorUnitario: Currency;
begin
  if (DadosPreenchidos = True) then
  begin
    edtCodigoCliente.ReadOnly := True;
    edtCodigoCliente.Color := cl3DLight;
    edtCodigoCliente.TabStop := False;

    Produto := TProdutoDAO.BuscarPorCodigo(StrToInt(edtCodigoProduto.Text));
    if Produto = nil then
      raise Exception.Create('Produto não encontrado');

    Quantidade := StrToInt(edtQuantidade.Text);
    ValorUnitario := StrToCurr(edtValorUnitario.Text);

    if FEditandoIndice >= 0 then
    begin
      Item := FPedido.Itens[FEditandoIndice];

      Item.Quantidade := Quantidade;
      Item.ValorUnitario := ValorUnitario;
      Item.ValorTotal := Quantidade * ValorUnitario;

      ShowMessage('Item atualizado.');
      FEditandoIndice := -1;
    end else
    begin
      Item := TItemPedido.Create;
      Item.CodigoProduto := Produto.Codigo;
      Item.DescricaoProduto := Produto.Descricao;
      Item.Quantidade := Quantidade;
      Item.ValorUnitario := ValorUnitario;
      Item.ValorTotal := Quantidade * ValorUnitario;

      FPedido.Itens.Add(Item);
    end;

    AtualizarGrid;
    AtualizarTotal;
    ClearHead;

    BloqueiaSelecionarCliente(True);
    edtCodigoProduto.SetFocus;
  end;
end;

procedure TFormPedido.CarregaListaClientes;
var
  Clientes: TObjectList<TCliente>;
  Cliente: TCliente;
  FListaClientes: TDictionary<Integer, string>;
begin
  FListaClientes := TDictionary<Integer, string>.Create;

  Clientes := TClienteDAO.Listar;
  try
    for Cliente in Clientes do
    begin
      cmbCliente.Items.Add(Format('%d - %s', [Cliente.Codigo, Cliente.Nome]));
      FListaClientes.Add(Cliente.Codigo, Cliente.Nome);
    end;
  finally
    Clientes.Free;
  end;
end;

procedure TFormPedido.CarregaListaProdutos;
var
  FListaProdutos: TDictionary<Integer, string>;
  Produtos: TObjectList<TProduto>;
  Produto: TProduto;
begin
  FListaProdutos := TDictionary<Integer, string>.Create;

  Produtos := TProdutoDAO.Listar;
  try
    cmbProdutos.Items.Clear;

    for Produto in Produtos do
    begin
      cmbProdutos.Items.Add(Format('%d - %s', [Produto.Codigo, Produto.Descricao]));
      FListaProdutos.Add(Produto.Codigo, Produto.Descricao);
    end;
  finally
    Produtos.Free;
  end;
end;

procedure TFormPedido.ClearHead;
begin
    edtCodigoProduto.Clear;
    cmbProdutos.ItemIndex:= -1;
    edtQuantidade.Clear;
    edtValorUnitario.Clear;
end;

procedure TFormPedido.cmbClienteChange(Sender: TObject);
var
  CodigoStr: string;
  Separador: Integer;
begin
  Separador := Pos(' - ', cmbCliente.Text);
  if Separador > 0 then
  begin
    CodigoStr := Copy(cmbCliente.Text, 1, Separador - 1);
    edtCodigoCliente.Text := CodigoStr;
  end;
end;

procedure TFormPedido.cmbProdutosChange(Sender: TObject);
var
  Separador: Integer;
  CodigoStr: string;
begin
  Separador := Pos(' - ', cmbProdutos.Text);
  if Separador > 0 then
  begin
    CodigoStr := Copy(cmbProdutos.Text, 1, Separador - 1);
    edtCodigoProduto.Text := CodigoStr;
  end;
end;

function TFormPedido.DadosPreenchidos: Boolean;
begin
  Result:= True;

  // Validação dos campos obrigatórios

  if Trim(edtCodigoCliente.Text) = '' then
  begin
    ShowMessage('Informe o código do cliente.');
    edtCodigoCliente.SetFocus;
    Result:= False;
    Exit;
  end;

  if Trim(edtCodigoProduto.Text) = '' then
  begin
    ShowMessage('Informe o código do produto.');
    edtCodigoProduto.SetFocus;
    Result:= False;
    Exit;
  end;

  if Trim(edtQuantidade.Text) = '' then
  begin
    ShowMessage('Informe a quantidade.');
    edtQuantidade.SetFocus;
    Result:= False;
    Exit;
  end;

  if Trim(edtValorUnitario.Text) = '' then
  begin
    ShowMessage('Informe o valor unitário.');
    edtValorUnitario.SetFocus;
    Result:= False;
    Exit;
  end;
end;

procedure TFormPedido.EditarItemSelecionado;
var
  Item: TItemPedido;
begin
  if grdItens.Row <= 0 then Exit;

  FEditandoIndice := grdItens.Row - 1;
  Item := FPedido.Itens[FEditandoIndice];

  edtCodigoProduto.Text := Item.CodigoProduto.ToString;
  edtQuantidade.Text := Item.Quantidade.ToString;
  edtValorUnitario.Text := FormatFloat('0.00', Item.ValorUnitario);

  // Tornar campos somente leitura, exceto quantidade e valor unitário
  edtCodigoProduto.ReadOnly := True;
  edtCodigoProduto.Color := cl3DLight;
  edtCodigoProduto.TabStop := False;

  edtQuantidade.ReadOnly := False;
  edtQuantidade.Color := clWindow;
  edtQuantidade.TabStop := True;

  edtValorUnitario.ReadOnly := False;
  edtValorUnitario.Color := clWindow;
  edtValorUnitario.TabStop := True;

  edtQuantidade.SetFocus;
end;

procedure TFormPedido.edtCodigoClienteChange(Sender: TObject);
var
  ClienteVazio: Boolean;
begin
  ClienteVazio := Trim(edtCodigoCliente.Text) = '';
  btnCarregarPedido.Visible := ClienteVazio;
  btnCancelarPedido.Visible := ClienteVazio;
end;

procedure TFormPedido.edtCodigoClienteExit(Sender: TObject);
var
  Codigo: Integer;
  i: Integer;
begin
  if not TryStrToInt(edtCodigoCliente.Text, Codigo) then Exit;

  for i := 0 to cmbCliente.Items.Count - 1 do
  begin
    if cmbCliente.Items[i].StartsWith(IntToStr(Codigo) + ' -') then
    begin
      cmbCliente.ItemIndex := i;
      Exit;
    end;
  end;
end;

procedure TFormPedido.edtCodigoProdutoExit(Sender: TObject);
var
  Codigo: Integer;
  i: Integer;
begin
  if not TryStrToInt(edtCodigoProduto.Text, Codigo) then Exit;

  for i := 0 to cmbProdutos.Items.Count - 1 do
  begin
    if cmbProdutos.Items[i].StartsWith(IntToStr(Codigo) + ' -') then
    begin
      cmbProdutos.ItemIndex := i;
      Exit;
    end;
  end;
end;

procedure TFormPedido.ExcluirItemSelecionado;
begin

end;

procedure TFormPedido.AtualizarGrid;
var
  i: Integer;
  Item: TItemPedido;
begin
  grdItens.RowCount := FPedido.Itens.Count + 1;
  grdItens.Cells[0, 0] := 'Código';
  grdItens.Cells[1, 0] := 'Descrição';
  grdItens.Cells[2, 0] := 'Qtd';
  grdItens.Cells[3, 0] := 'Unitário';
  grdItens.Cells[4, 0] := 'Total';

  for i := 0 to FPedido.Itens.Count - 1 do
  begin
    Item := FPedido.Itens[i];
    grdItens.Cells[0, i + 1] := Item.CodigoProduto.ToString;
    grdItens.Cells[1, i + 1] := Item.DescricaoProduto;
    grdItens.Cells[2, i + 1] := Item.Quantidade.ToString;
    grdItens.Cells[3, i + 1] := FormatFloat('0.00', Item.ValorUnitario);
    grdItens.Cells[4, i + 1] := FormatFloat('0.00', Item.ValorTotal);
  end;
end;

procedure TFormPedido.AtualizarTotal;
var
  Total: Currency;
  Item: TItemPedido;
begin
  Total := 0;
  for Item in FPedido.Itens do
    Total := Total + Item.ValorTotal;

  FPedido.ValorTotal := Total;
  lblTotal.Caption := 'Total: R$ ' + FormatFloat('0.00', Total);
end;

procedure TFormPedido.btnCancelarPedidoClick(Sender: TObject);
var
  NumPedidoStr: string;
  NumeroPedido: Integer;
begin
  NumPedidoStr := InputBox('Cancelar Pedido', 'Informe o número do pedido a cancelar:', '');

  if Trim(NumPedidoStr) = '' then
    Exit;

  NumeroPedido := StrToIntDef(NumPedidoStr, -1);
  if NumeroPedido <= 0 then
  begin
    ShowMessage('Número inválido.');
    Exit;
  end;

  if MessageDlg('Deseja realmente cancelar o pedido nº ' + IntToStr(NumeroPedido) + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    TPedidoDAO.CancelarPedido(NumeroPedido);
    ShowMessage('Pedido cancelado com sucesso.');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormPedido.btnCarregarPedidoClick(Sender: TObject);
var
  NumPedido: string;
  Pedido: TPedido;
begin
  NumPedido := InputBox('Carregar Pedido', 'Informe o número do pedido:', '');

  if Trim(NumPedido) = '' then
    Exit;

  Pedido := TPedidoDAO.BuscarPorNumero(StrToIntDef(NumPedido, -1));
  if Pedido = nil then
  begin
    ShowMessage('Pedido não encontrado.');
    Exit;
  end;

  // Atualiza o pedido atual
  FPedido := Pedido;

  // Preenche os campos
  edtCodigoCliente.Text := Pedido.CodigoCliente.ToString;
  edtCodigoCliente.OnExit(edtCodigoCliente); // Força sincronizar cmbCliente

  AtualizarGrid;
  AtualizarTotal;
  BloqueiaSelecionarCliente(True);

  ShowMessage('Pedido carregado com sucesso!');
end;

procedure TFormPedido.btnGravarClick(Sender: TObject);
begin
  if (FPedido.Itens.Count > 0) then
  begin
    FPedido.CodigoCliente := StrToInt(edtCodigoCliente.Text);
    TPedidoDAO.Gravar(FPedido);
    ShowMessage('Pedido gravado com sucesso!');
  end else
  begin
    ShowMessage('Não existem dados a serem gravados!');
  end;

  Close;
end;

end.

