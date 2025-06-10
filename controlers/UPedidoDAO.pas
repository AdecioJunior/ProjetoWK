unit UPedidoDAO;

interface

uses
  UPedido, UItemPedido, FireDAC.Comp.Client, FireDAC.DApt, Firedac.Stan.Def, UConexao, System.SysUtils;

type
  TPedidoDAO = class
  public
    class function ProximoNumero: Integer;
    class function BuscarPorNumero(Numero: Integer): TPedido;
    class procedure Gravar(Pedido: TPedido);
    class procedure CancelarPedido(NumeroPedido: Integer);

  end;

implementation
uses
  UprodutoDao;

class function TPedidoDAO.ProximoNumero: Integer;
var
  Conn: TFDConnection;
  Qry: TFDQuery;
begin
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := Conn;
    Qry.SQL.Text := 'SELECT COALESCE(MAX(numero_pedido), 0) + 1 FROM pedidos';
    Qry.Open;
    Result := Qry.Fields[0].AsInteger;
  finally
    Qry.Free;
    Conn.Free;
  end;
end;

class procedure TPedidoDAO.Gravar(Pedido: TPedido);
var
  Conn: TFDConnection;
  Qry: TFDQuery;
  Item: TItemPedido;
begin
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := Conn;

    Conn.Connected := True;

    Conn.StartTransaction;

    if (Assigned(TPedidoDAO.BuscarPorNumero(Pedido.Numero))) then
      TPedidoDAO.CancelarPedido(Pedido.Numero);

    // Gravar pedido
    Qry.SQL.Text :=
      'INSERT INTO pedidos (numero_pedido, data_emissao, codigo_cliente, valor_total) ' +
      'VALUES (:numero, :data, :cliente, :total)';
    Qry.ParamByName('numero').AsInteger := Pedido.Numero;
    Qry.ParamByName('data').AsDate := Pedido.DataEmissao;
    Qry.ParamByName('cliente').AsInteger := Pedido.CodigoCliente;
    Qry.ParamByName('total').AsCurrency := Pedido.ValorTotal;
    Qry.ExecSQL;

    // Gravar itens do pedido
    for Item in Pedido.Itens do
    begin
      Qry.SQL.Text :=
        'INSERT INTO pedido_itens (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
        'VALUES (:numero, :produto, :quantidade, :unitario, :total)';
      Qry.ParamByName('numero').AsInteger := Pedido.Numero;
      Qry.ParamByName('produto').AsInteger := Item.CodigoProduto;
      Qry.ParamByName('quantidade').AsInteger := Item.Quantidade;
      Qry.ParamByName('unitario').AsCurrency := Item.ValorUnitario;
      Qry.ParamByName('total').AsCurrency := Item.ValorTotal;
      Qry.ExecSQL;
    end;

    Conn.Commit;
  except
    on E: Exception do
    begin
      if Conn.InTransaction then
        Conn.Rollback;
      raise Exception.Create('Erro ao gravar pedido: ' + E.Message);
    end;
  end;
  Qry.Free;
  Conn.Free;
end;


class procedure TPedidoDAO.CancelarPedido(NumeroPedido: Integer);
var
  Conn: TFDConnection;
  Qry: TFDQuery;
begin
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);
  try
    Conn.StartTransaction;

    Qry.Connection := Conn;
    Qry.SQL.Text := 'DELETE FROM pedido_itens WHERE numero_pedido = :num';
    Qry.ParamByName('num').AsInteger := NumeroPedido;
    Qry.ExecSQL;

    Qry.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :num';
    Qry.ParamByName('num').AsInteger := NumeroPedido;
    Qry.ExecSQL;

    Conn.Commit;
  except
    on E: Exception do
    begin
      Conn.Rollback;
      raise;
    end;
  end;
  Qry.Free;
  Conn.Free;
end;

class function TPedidoDAO.BuscarPorNumero(Numero: Integer): TPedido;
var
  Conn: TFDConnection;
  Qry: TFDQuery;
  Pedido: TPedido;
  Item: TItemPedido;
begin
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;
    Qry.SQL.Text := 'SELECT * FROM pedidos WHERE numero_pedido = :num';
    Qry.ParamByName('num').AsInteger := Numero;
    Qry.Open;

    if Qry.IsEmpty then
      Exit(nil);

    Pedido := TPedido.Create;
    Pedido.Numero := Qry.FieldByName('numero_pedido').AsInteger;
    Pedido.DataEmissao := Qry.FieldByName('data_emissao').AsDateTime;
    Pedido.CodigoCliente := Qry.FieldByName('codigo_cliente').AsInteger;
    Pedido.ValorTotal := Qry.FieldByName('valor_total').AsCurrency;

    // Carregar itens
    Qry.Close;
    Qry.SQL.Text := 'SELECT * FROM pedido_itens WHERE numero_pedido = :num';
    Qry.ParamByName('num').AsInteger := Pedido.Numero;
    Qry.Open;

    while not Qry.Eof do
    begin
      Item := TItemPedido.Create;
      Item.CodigoProduto := Qry.FieldByName('codigo_produto').AsInteger;
      Item.Quantidade := Qry.FieldByName('quantidade').AsInteger;
      Item.ValorUnitario := Qry.FieldByName('valor_unitario').AsCurrency;
      Item.ValorTotal := Qry.FieldByName('valor_total').AsCurrency;

      Item.DescricaoProduto := TProdutoDAO.BuscarPorCodigo(Item.CodigoProduto).Descricao;

      Pedido.Itens.Add(Item);
      Qry.Next;
    end;

    Result := Pedido;
  finally
    Qry.Free;
    Conn.Free;
  end;
end;

end.

