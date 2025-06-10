program projectwk;

uses
  Vcl.Forms,
  UPrincipal in 'views\UPrincipal.pas',
  UConexao in 'controlers\UConexao.pas',
  UCliente in 'models\UCliente.pas',
  UProduto in 'models\UProduto.pas',
  UItemPedido in 'models\UItemPedido.pas',
  UPedido in 'models\UPedido.pas',
  UClienteDAO in 'controlers\UClienteDAO.pas',
  UProdutoDAO in 'controlers\UProdutoDAO.pas',
  UPedidoDAO in 'controlers\UPedidoDAO.pas',
  FrmPedido in 'views\FrmPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
