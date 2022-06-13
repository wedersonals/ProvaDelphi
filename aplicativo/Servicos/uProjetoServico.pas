unit uProjetoServico;

interface

uses System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

function CriarDataSetProjetos(Aowner: TComponent): TClientDataSet;
procedure IniciarDadosDeTeste(DataSet: TDataSet; QuantidadeProjetos: Integer; ValorMaximoProjeto: Currency);
function ObterTotal(DataSet: TDataSet): Currency;
function ObterTotalDivisoes(DataSet: TDataSet): Currency;

implementation

uses Vcl.Forms, WinApi.Windows, uspDataSetUtils;

function CriarDataSetProjetos(Aowner: TComponent): TClientDataSet;
begin
  Result := TClientDataSet.Create(Aowner);
  with Result.FieldDefs do
    begin
      Add('idProjeto', ftInteger);
      Add('NomeProjeto', ftString, 45);
      Add('Valor', ftCurrency);
    end;
  Result.CreateDataSet;
end;

procedure IniciarDadosDeTeste(DataSet: TDataSet; QuantidadeProjetos: Integer; ValorMaximoProjeto: Currency);
var
  I: Integer;
begin
  Randomize;
  DataSet.DisableControls;
  for I := 1 to QuantidadeProjetos do
    begin
      DataSet.Append;
      DataSet.FieldByName('idProjeto').AsInteger := I;
      DataSet.FieldByName('NomeProjeto').AsString := Format('Projeto %d', [I]);
      DataSet.FieldByName('Valor').AsCurrency := Random(Trunc(ValorMaximoProjeto));
      DataSet.Post;
    end;
  DataSet.First;
  DataSet.EnableControls;
end;

function ObterTotal(DataSet: TDataSet): Currency;
var
  DataSetIteracao: IspDataSetIteration;
  Operacao: IspOperation<Currency>;
begin
  Operacao := TspOperacaoSomaCampo.Create(DataSet.FindField('Valor'));
  DataSetIteracao := TspDataSetOperationField<Currency>.Create(DataSet, Operacao);
  DataSetIteracao.Execute;
  Result := Operacao.GetResult;
end;

function ObterTotalDivisoes(DataSet: TDataSet): Currency;
var
  DataSetIteracao: IspDataSetIteration;
  Operacao: IspOperation<Currency>;
begin
  Operacao := TspOperacaoSomaDaDivisaoNumeroAnterior.Create(DataSet.FindField('Valor'));
  DataSetIteracao := TspDataSetOperationField<Currency>.Create(DataSet, Operacao);
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

end.
