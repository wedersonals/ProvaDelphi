unit uspQuery;

interface

uses System.SysUtils, System.Classes, FireDac.Comp.Client;

type
  IspGeradorSQL = interface
  ['{6B87B5C8-916B-4419-9A35-7F8E44CCDAF3}']
    function GetColunas: TStringList;
    function GetTabelas: TStringList;
    function GetCondicoes(): TStringList;
    procedure SetColunas(const Value: TStringList);
    procedure SetTabelas(const Value: TStringList);
    procedure SetCondicoes(const Value: TStringList);
    function GetSQL: String;
    procedure GeraSQL;
    procedure VerificaSQL;

    property Colunas: TStringList read GetColunas write SetColunas;
    property Tabelas: TStringList read GetTabelas write SetTabelas;
    property Condicoes: TStringList read GetCondicoes write SetCondicoes;
  end;

  TspGeradorSQL = class(TInterfacedObject, IspGeradorSQL)
  private
    FspSQL,
    FspCondicoes,
    FspColunas,
    FspTabelas: TStringList;
    FColunasPorLinha: Byte;
    procedure VerificaTabelaNaoInformada;
    procedure VerificaMaisDeUmaTabelaInformada;
    function RetornaTabelas: String;
    function RetornaColunas: String;
    function RetornaCondicoes: String;
    function RetornaListaDelimitada(Lista: TStringList; Delimitador: Char): TStringList;
    procedure AjustaCondicoes;
  protected
    procedure VerificaSQL;
  public
    constructor Create;
    destructor Destroy; override;
    function GetSQL(): String;
    function GetColunas: TStringList;
    function GetTabelas: TStringList;
    function GetCondicoes(): TStringList;
    procedure SetColunas(const Value: TStringList);
    procedure SetTabelas(const Value: TStringList);
    procedure SetCondicoes(const Value: TStringList);
    procedure GeraSQL;

    property ColunasPorLinha: Byte read FColunasPorLinha write FColunasPorLinha;
  end;

  EspGeradorSQLException = class(Exception);

  TspQuery = class(TFDQuery)
  private
    FGeradorSQL: IspGeradorSQL;
    function GetColunas: TStringList;
    function GetTabelas: TStringList;
    function GetCondicoes(): TStringList;
    procedure SetColunas(const Value: TStringList);
    procedure SetTabelas(const Value: TStringList);
    procedure SetCondicoes(const Value: TStringList);
  public
    constructor Create(AOwner: TComponent); override;
    procedure GeraSQL;
  published
    property spCondicoes: TStringList read GetCondicoes write SetCondicoes;
    property spColunas: TStringList read GetColunas write SetColunas;
    property spTabelas: TStringList read GetTabelas write SetTabelas;
  end;

Const
  SQL_INDENTACAO = #32#32;
  SQL_QUEBRA_LINHA = sLineBreak;
  SQL_WHERE  = 'WHERE';
  SQL_AND    = 'AND';
  SQL_SELECT = 'SELECT';
  SQL_FROM   = 'FROM';

implementation

uses System.StrUtils;

{ TspQuery }

constructor TspQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGeradorSQL := TspGeradorSQL.Create;
end;

procedure TspQuery.GeraSQL;
begin
  FGeradorSQL.GeraSQL;
  self.SQL.Text := FGeradorSQL.GetSQL;
end;

function TspQuery.GetColunas: TStringList;
begin
  Result := FGeradorSQL.Colunas;
end;

function TspQuery.GetCondicoes: TStringList;
begin
  Result := FGeradorSQL.Condicoes;
end;

function TspQuery.GetTabelas: TStringList;
begin
  Result := FGeradorSQL.Tabelas;
end;

procedure TspQuery.SetColunas(const Value: TStringList);
begin
  FGeradorSQL.Colunas.SetStrings(Value);
end;

procedure TspQuery.SetCondicoes(const Value: TStringList);
begin
  FGeradorSQL.Condicoes.SetStrings(Value);
end;

procedure TspQuery.SetTabelas(const Value: TStringList);
begin
  FGeradorSQL.Tabelas.SetStrings(Value);
end;

{ TGeradorSQL }

procedure TspGeradorSQL.AjustaCondicoes;
var
  I: Integer;
begin
  for I := 0 to FspCondicoes.Count - 2 do
    if RightStr(FspCondicoes[I].Trim, 1) <> ',' then
      FspCondicoes[I] := FspCondicoes[I] + ',';
end;

constructor TspGeradorSQL.Create;
begin
  FspColunas := TStringList.Create;
  FspTabelas := TStringList.Create;
  FspCondicoes := TStringList.Create;
  FspSQL := TStringList.Create;
  FColunasPorLinha := 5;
end;

destructor TspGeradorSQL.Destroy;
begin
  FreeAndNil(FspSQL);
  FreeAndNil(FspColunas);
  FreeAndNil(FspTabelas);
  FreeAndNil(FspCondicoes);
  inherited;
end;

procedure TspGeradorSQL.GeraSQL;
begin
  FspSQL.Clear;
  VerificaSQL;

  FspSQL.Append(SQL_SELECT);
  FspSQL.Append(RetornaColunas);
  FspSQL.Append(SQL_FROM);
  FspSQL.Append(RetornaTabelas);
  FspSQL.Append(RetornaCondicoes);
end;

function TspGeradorSQL.GetColunas: TStringList;
begin
  Result := FspColunas;
end;

function TspGeradorSQL.GetCondicoes: TStringList;
begin
  Result := FspCondicoes;
end;

function TspGeradorSQL.GetSQL: String;
begin
  Result := FspSQL.Text;
end;

function TspGeradorSQL.GetTabelas: TStringList;
begin
  Result := FspTabelas;
end;

function TspGeradorSQL.RetornaColunas: String;
var
  I: Integer;
  Lista: TStringList;
begin
  Result := '';

  if FspColunas.Count = 0 then
    FspColunas.Append('*');

  Lista := RetornaListaDelimitada(FspColunas, ',');
  for I := 0 to Lista.Count - 1 do
    Result := Result +
              IfThen(I > 0, ', ') +
              IfThen((I mod FColunasPorLinha = 0) and (I > 0), SQL_QUEBRA_LINHA) +
              IfThen(I mod FColunasPorLinha = 0, SQL_INDENTACAO) +
              StringReplace(Lista[I], sLineBreak, '', [rfReplaceAll]);
  Lista.Free;
end;

function TspGeradorSQL.RetornaCondicoes: String;
var
  Lista: TStringList;
  I: Integer;
  ExisteOperador: Boolean;
  Condicao: String;
begin
  Result := '';

  ExisteOperador := ContainsText(FspCondicoes.Text, SQL_WHERE);
  AjustaCondicoes;

  Lista := RetornaListaDelimitada(FspCondicoes, ',');
  for I := 0 to Lista.Count - 1 do
    begin
      Condicao := StringReplace(Lista[I], sLineBreak, '', [rfReplaceAll]).Trim;

      if I > 0 then
        Result := Result + SQL_QUEBRA_LINHA + SQL_INDENTACAO;

      if not ExisteOperador then
        Result := Result +
                  IfThen(I = 0, SQL_WHERE, SQL_AND) + #32;

      Result := Result + Condicao;
    end;
  Lista.Free;
end;

function TspGeradorSQL.RetornaListaDelimitada(Lista: TStringList;
  Delimitador: Char): TStringList;
begin
  Result := TStringList.Create;
  Result.Delimiter := ',';
  Result.StrictDelimiter := True;
  Result.DelimitedText := Lista.Text;
end;

function TspGeradorSQL.RetornaTabelas: String;
begin
  Result := SQL_INDENTACAO +
            StringReplace(FspTabelas.Text, sLineBreak, '', [rfReplaceAll]);
end;

procedure TspGeradorSQL.SetColunas(const Value: TStringList);
begin
  FspColunas := Value;
end;

procedure TspGeradorSQL.SetCondicoes(const Value: TStringList);
begin
  FspColunas := Value;
end;

procedure TspGeradorSQL.SetTabelas(const Value: TStringList);
begin
  FspTabelas := Value;
end;

procedure TspGeradorSQL.VerificaMaisDeUmaTabelaInformada;
begin
  FspTabelas.Delimiter     := ',';
  FspTabelas.DelimitedText := FspTabelas.Text;
  if FspTabelas.Count > 1 then
    raise EspGeradorSQLException.Create('É permitido informar apenas uma tabela para geração do SQL');
end;

procedure TspGeradorSQL.VerificaTabelaNaoInformada;
begin
  if FspTabelas.Count = 0 then
    raise EspGeradorSQLException.Create('É necessário informar uma tabela para geração do SQL');
end;

procedure TspGeradorSQL.VerificaSQL;
begin
  VerificaTabelaNaoInformada;
  VerificaMaisDeUmaTabelaInformada;
end;

end.
