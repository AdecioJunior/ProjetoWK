program projectwk;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {Form1},
  UConexao in 'server\UConexao.pas',
  UCliente in 'classes\UCliente.pas',
  UProduto in 'classes\UProduto.pas',
  UItemPedido in 'classes\UItemPedido.pas',
  UPedido in 'classes\UPedido.pas',
  UClienteDAO in 'server\UClienteDAO.pas',
  UProdutoDAO in 'server\UProdutoDAO.pas',
  UPedidoDAO in 'server\UPedidoDAO.pas',
  FrmPedido in 'FrmPedido.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
