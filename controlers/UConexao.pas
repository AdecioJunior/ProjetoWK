unit UConexao;

interface

uses
  FireDAC.Comp.Client, FireDAC.Phys,FireDAC.Phys.MySQL, FireDAC.Stan.Async,
  Firedac.Stan.Option,System.IniFiles, System.SysUtils;

function GetConnection: TFDConnection;

implementation

function GetConnection: TFDConnection;
var
  Ini: TIniFile;
  Conn: TFDConnection;
  FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;

begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'db_config.ini');
  Conn := TFDConnection.Create(nil);
  FDPhysMySQLDriverLink1:= TFDPhysMySQLDriverLink.Create(Conn);
  FDPhysMySQLDriverLink1.VendorLib:= ExtractFilePath(ParamStr(0)) + 'libmysql.dll';

  try
    Conn.DriverName := 'MySQL';
    Conn.Params.DriverID := 'MySQL';
    Conn.Params.Database := Ini.ReadString('DATABASE', 'Database', '');
    Conn.Params.UserName := Ini.ReadString('DATABASE', 'Username', '');
    Conn.Params.Password := Ini.ReadString('DATABASE', 'Password', '');

    Conn.Params.Add('Server=' + Ini.ReadString('DATABASE', 'Server', ''));
    Conn.Params.Add('Port=' + Ini.ReadString('DATABASE', 'Port', ''));

    Conn.TxOptions.AutoCommit:= False;
    Conn.TxOptions.Isolation:= xiReadCommitted;

    Conn.Connected := True;
    Result := Conn;
  finally
    Ini.Free;
  end;
end;

end.
