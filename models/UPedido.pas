unit UPedido;

interface

uses
  System.Generics.Collections, UItemPedido;

type
  TPedido = class
  private
    FNumero: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FItens: TObjectList<TItemPedido>;
  public
    constructor Create;
    destructor Destroy; override;

    property Numero: Integer read FNumero write FNumero;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Itens: TObjectList<TItemPedido> read FItens;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  FItens := TObjectList<TItemPedido>.Create(True);
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

end.

