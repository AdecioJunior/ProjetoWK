unit UClienteDAO;

interface

uses
  FireDAC.Comp.Client, UCliente, UConexao, System.SysUtils, System.Generics.Collections;

type
  TClienteDAO = class
  public
    class function Listar: TObjectList<TCliente>;
  end;

implementation

class function TClienteDAO.Listar: TObjectList<TCliente>;
var
  Conn: TFDConnection;
  Qry: TFDQuery;
  Cliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create(True);
  Conn := GetConnection;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;
    Qry.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes';
    Qry.Open;
    while not Qry.Eof do
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := Qry.FieldByName('codigo').AsInteger;
      Cliente.Nome := Qry.FieldByName('nome').AsString;
      Cliente.Cidade := Qry.FieldByName('cidade').AsString;
      Cliente.UF := Qry.FieldByName('uf').AsString;
      Result.Add(Cliente);
      Qry.Next;
    end;
  finally
    Qry.Free;
    Conn.Free;
  end;
end;

end.

