unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  FrmPedido;

{$R *.dfm}

procedure TFrmPrincipal.Button1Click(Sender: TObject);
Var
  Pedido: TFormPedido;
begin
  Pedido:= TFormPedido.Create(Self);
  Pedido.ShowModal;
  FreeAndNil(Pedido);
end;

end.
