unit uspDataSetUtils;

interface

uses System.SysUtils, Data.DB;

type
  EOperationException = class(Exception);

  TOnExecuteNotify = procedure (DataSet: TDataSet) of Object;

  IspDataSetIteration = interface
  ['{A6D2DC68-9CCD-4B16-9856-5627D6872101}']
    procedure Execute;
    function GetOnExecute: TOnExecuteNotify;
    procedure SetOnExecute(Value: TOnExecuteNotify);
    property OnExecute: TOnExecuteNotify read GetOnExecute write SetOnExecute;
  end;

  IspOperation<T> = interface
  ['{37113AAF-DBAA-40B7-9748-06079EFE25B6}']
    procedure Execute;
    function GetResult: T;
  end;

  TspDataSetIteration = class(TInterfacedObject, IspDataSetIteration)
  private
    FDataSet: TDataSet;
    FOnExecute: TOnExecuteNotify;
    function GetOnExecute: TOnExecuteNotify;
    procedure SetOnExecute(Value: TOnExecuteNotify);
  public
    constructor Create(DataSet: TDataSet);
    procedure Execute;
    property OnExecute: TOnExecuteNotify read FOnExecute write FOnExecute;
  end;

  TspDataSetOperationField<T> = class(TspDataSetIteration)
  private
    FOperation: IspOperation<T>;
    procedure OnExecuteIteration(DataSet: TDataSet);
  public
    constructor Create(DataSet: TDataSet; Operation: IspOperation<T>);
  end;

  TspOperationField<T> = class(TInterfacedObject, IspOperation<T>)
  protected
    FField: TField;
    FValue: T;
  public
    constructor Create(Field: TField);
    procedure Execute; virtual; abstract;
    function GetResult: T;
  end;

  TspOperacaoSomaCampo = class(TspOperationField<Currency>)
  public
    procedure Execute; override;
  end;

  TspOperacaoSomaDaDivisaoNumeroAnterior = class(TspOperationField<Currency>)
  private
    FNumeroAnterior: Currency;
  public
    procedure Execute; override;
  end;

implementation

{ TspDataSetIteration }

constructor TspDataSetIteration.Create(DataSet: TDataSet);
begin
  FDataSet := DataSet;
end;

procedure TspDataSetIteration.Execute;
var
  RecordNumber: Integer;
begin
  if not Assigned(FDataSet) then
    raise Exception.Create('DataSet não informado');

  if FDataSet.RecordCount = 0 then
    Exit;

  FDataSet.DisableControls;
  RecordNumber := FDataSet.RecNo;
  try
    FDataSet.First;
    while not FDataSet.Eof do
      begin
        if Assigned(FOnExecute) then
          FOnExecute(FDataSet);
        FDataSet.Next;
      end;
  finally
    FDataSet.RecNo := RecordNumber;
    FDataSet.EnableControls;
  end;
end;

function TspDataSetIteration.GetOnExecute: TOnExecuteNotify;
begin
  Result := FOnExecute;
end;

procedure TspDataSetIteration.SetOnExecute(Value: TOnExecuteNotify);
begin
  FOnExecute := Value;
end;

{ TspDataSetOperationField }

constructor TspDataSetOperationField<T>.Create(DataSet: TDataSet; Operation: IspOperation<T>);
begin
  inherited Create(DataSet);
  FOperation := Operation;
  OnExecute := OnExecuteIteration;
end;

procedure TspDataSetOperationField<T>.OnExecuteIteration(DataSet: TDataSet);
begin
  FOperation.Execute;
end;

{ TspOperationField }

constructor TspOperationField<T>.Create(Field: TField);
begin
  FField := Field;
end;

function TspOperationField<T>.GetResult: T;
begin
  Result := FValue;
end;


{ TspOperacaoSomaCampo }

procedure TspOperacaoSomaCampo.Execute;
begin
  FValue := FValue + FField.AsCurrency;
end;

{ TspOperacaoSomaDaDivisaoNumeroAnterior }

procedure TspOperacaoSomaDaDivisaoNumeroAnterior.Execute;
begin
  if FField.DataSet.RecNo > 1 then
    try
      FValue := FValue + (FField.AsCurrency / FNumeroAnterior);
    except
      on E: EZeroDivide do
        raise EOperationException.CreateFmt('Não será possível realizar o cálculo de divisão!' + sLineBreak +
                                  'O registro de número %d possui valor "0".',
                                  [FField.DataSet.RecNo - 1]);
      on E: EInvalidOp do
        raise EOperationException.CreateFmt('Operação inválida ao realizar o cálculo do registro número %d',
                                  [FField.DataSet.RecNo]);
      on E: Exception do
        raise EOperationException.CreateFmt('Erro não identificado ao realizar o cálculo do registro número %d',
                                  [FField.DataSet.RecNo]);
    end;
  FNumeroAnterior := FField.AsCurrency;
end;

end.
