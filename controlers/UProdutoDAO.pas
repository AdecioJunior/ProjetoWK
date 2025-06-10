unit UProdutoDAO;

interface

uses
  FireDAC.Comp.Client, Firedac.Stan.Def, UProduto, UConexao, System.SysUtils, System.Generics.Collections;

type
  TProdutoDAO = class
  public
    class function Listar: TObjectList<TProduto>;
    class function BuscarPorCodigo(Codigo: Integer): TProduto;
  end;

implementation

class function TProdutoDAO.Listar: TObjectList<TProduto>;
var
  Conn: TFDConnection;
  Qry: TFDQuery;
  Produto: TProduto;
begin
  Result := TObjectList<TProduto>.Create(True);
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;
    Qry.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos';
    Qry.Open;
    while not Qry.Eof do
    begin
      Produto := TProduto.Create;
      Produto.Codigo := Qry.FieldByName('codigo').AsInteger;
      Produto.Descricao := Qry.FieldByName('descricao').AsString;
      Produto.PrecoVenda := Qry.FieldByName('preco_venda').AsCurrency;
      Result.Add(Produto);
      Qry.Next;
    end;
  finally
    Qry.Free;
    Conn.Free;
  end;
end;

class function TProdutoDAO.BuscarPorCodigo(Codigo: Integer): TProduto;
var
  Conn: TFDConnection;
  Qry: TFDQuery;
begin
  Result := nil;
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;
    Qry.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :codigo';
    Qry.ParamByName('codigo').AsInteger := Codigo;
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      Result := TProduto.Create;
      Result.Codigo := Qry.FieldByName('codigo').AsInteger;
      Result.Descricao := Qry.FieldByName('descricao').AsString;
      Result.PrecoVenda := Qry.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    Qry.Free;
    Conn.Free;
  end;
end;

end.

