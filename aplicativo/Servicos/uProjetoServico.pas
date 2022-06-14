unit uProjetoServico;

interface

uses System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  IProjetoServico = interface
  ['{1013C0F5-1171-40DD-989B-4CC9B499451A}']
    procedure SetDataSet(DataSet: TClientDataSet);
    function GetDataSet: TClientDataSet;
    function ObterTotal: Currency;
    function ObterTotalDivisoes: Currency;
  end;

  TProjetoServico = class(TInterfacedObject, IProjetoServico)
  private
    FDataSet: TClientDataSet;
    function CriarDataSetProjetos: TClientDataSet;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetDataSet(DataSet: TClientDataSet);
    function GetDataSet: TClientDataSet;
    function ObterTotal: Currency;
    function ObterTotalDivisoes: Currency;
  end;


  IProjetoServicoMock = interface
  ['{783F5766-85E9-4440-A7CB-89A0AF94401A}']
    procedure IniciarDadosDeTeste;
    function GetValor: Currency;
  end;

  TProjetoServicoMock = class(TInterfacedObject, IProjetoServicoMock)
  private
    FDataSet: TDataSet;
    FQuantidadeProjetos: Integer;
  protected
    function GetValor: Currency; virtual; abstract;
  public
    constructor Create(DataSet: TDataSet; QuantidadeProjetos: Integer);
    procedure IniciarDadosDeTeste;
  end;

  TProjetoServicoMockRandomico = class(TProjetoServicoMock)
  private
    FValorMaximoProjeto: Currency;
  protected
    function GetValor: Currency; override;
  public
    constructor Create(DataSet: TDataSet; QuantidadeProjetos: Integer; ValorMaximoProjeto: Currency);
  end;

  TProjetoServicoMockMultiploDeNumero = class(TProjetoServicoMock)
  private
    FValorMultiplo: Currency;
  protected
    function GetValor: Currency; override;
  public
    constructor Create(DataSet: TDataSet; QuantidadeProjetos: Integer; ValorMultiplo: Integer);
  end;

implementation

uses Vcl.Forms, WinApi.Windows, uspDataSetUtils;

constructor TProjetoServico.Create;
begin
  FDataSet := CriarDataSetProjetos;
end;

function TProjetoServico.CriarDataSetProjetos: TClientDataSet;
begin
  Result := TClientDataSet.Create(nil);
  with Result.FieldDefs do
    begin
      Add('idProjeto', ftInteger);
      Add('NomeProjeto', ftString, 45);
      Add('Valor', ftCurrency);
    end;
  Result.CreateDataSet;
end;

destructor TProjetoServico.Destroy;
begin
  FreeAndNil(FDataSet);
  inherited;
end;

function TProjetoServico.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

function TProjetoServico.ObterTotal: Currency;
var
  DataSetIteracao: IspDataSetIteration;
  Operacao: IspOperation<Currency>;
begin
  Operacao := TspOperacaoSomaCampo.Create(FDataSet.FindField('Valor'));
  DataSetIteracao := TspDataSetOperationField<Currency>.Create(FDataSet, Operacao);
  DataSetIteracao.Execute;
  Result := Operacao.GetResult;
end;

function TProjetoServico.ObterTotalDivisoes: Currency;
var
  DataSetIteracao: IspDataSetIteration;
  Operacao: IspOperation<Currency>;
begin
  Operacao := TspOperacaoSomaDaDivisaoNumeroAnterior.Create(FDataSet.FindField('Valor'));
  DataSetIteracao := TspDataSetOperationField<Currency>.Create(FDataSet, Operacao);
  try
    DataSetIteracao.Execute;
    Result := Operacao.GetResult;
  except
    on E: EOperationException do
      begin
        Result := 0;
        Application.MessageBox(PWideChar(E.Message), 'Erro', MB_ICONERROR + MB_OK);
      end;
  end;
end;

procedure TProjetoServico.SetDataSet(DataSet: TClientDataSet);
begin
  FDataSet := DataSet;
end;

constructor TProjetoServicoMock.Create(DataSet: TDataSet; QuantidadeProjetos: Integer);
begin
  FDataSet := DataSet;
  FQuantidadeProjetos := QuantidadeProjetos;
end;

procedure TProjetoServicoMock.IniciarDadosDeTeste;
var
  I: Integer;
begin
  FDataSet.DisableControls;
  for I := 1 to FQuantidadeProjetos do
    begin
      FDataSet.Append;
      FDataSet.FieldByName('idProjeto').AsInteger := I;
      FDataSet.FieldByName('NomeProjeto').AsString := Format('Projeto %d', [I]);
      FDataSet.FieldByName('Valor').AsCurrency := GetValor;
      FDataSet.Post;
    end;
  FDataSet.First;
  FDataSet.EnableControls;
end;

{ TProjetoServicoMockRandomico }

constructor TProjetoServicoMockRandomico.Create(DataSet: TDataSet;
  QuantidadeProjetos: Integer; ValorMaximoProjeto: Currency);
begin
  inherited Create(DataSet, QuantidadeProjetos);
  FValorMaximoProjeto := ValorMaximoProjeto;
  Randomize;
end;

function TProjetoServicoMockRandomico.GetValor: Currency;
begin
  Result := Random(Trunc(FValorMaximoProjeto));
end;

{ TProjetoServicoMockMultiploDeNumero }

constructor TProjetoServicoMockMultiploDeNumero.Create(DataSet: TDataSet;
  QuantidadeProjetos, ValorMultiplo: Integer);
begin
  inherited Create(DataSet, QuantidadeProjetos);
  FValorMultiplo := ValorMultiplo;
end;

function TProjetoServicoMockMultiploDeNumero.GetValor: Currency;
begin
  Result := FDataSet.FieldByName('idProjeto').AsInteger * FValorMultiplo;
end;

end.
