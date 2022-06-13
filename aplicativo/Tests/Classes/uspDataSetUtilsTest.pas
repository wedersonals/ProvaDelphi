unit uspDataSetUtilsTest;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  Data.DB,
  uspDataSetUtils,
  uProjetoServico;

type
  [TestFixture]
  TspDataSetUtilsTest = class
  private
    FDataSet: TDataSet;
    FDataSetIteration: IspDataSetIteration;
    FCount: Integer;
    procedure OnExecuteIteration(DataSet: TDataSet);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestExecute;
  end;

  [TestFixture]
  TspDataSetOperationFieldTest = class
  private
    FDataSet: TDataSet;
    FDataSetIteration: IspDataSetIteration;
    FOperation: IspOperation<Currency>;

    procedure AjustarValoresMultiplosDeDez;
    procedure ExecuteComException;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestTspOperacaoSomaCampo;
    [Test]
    procedure TestTspOperacaoSomaDaDivisaoNumeroAnterior;
    [Test]
    procedure TestTspOperacaoSomaDaDivisaoNumeroAnteriorComEDivZero;
    [Test]
    procedure TestTspOperacaoSomaDaDivisaoNumeroAnteriorComInvalidOp;
  end;

implementation

procedure TspDataSetUtilsTest.OnExecuteIteration(DataSet: TDataSet);
begin
  FCount := DataSet.RecNo;
end;

procedure TspDataSetUtilsTest.Setup;
begin
  FDataSet := CriarDataSetProjetos(nil);
  IniciarDadosDeTeste(FDataSet, 10, 100);

  FDataSetIteration := TspDataSetIteration.Create(FDataSet);
  FDataSetIteration.OnExecute := OnExecuteIteration;
end;

procedure TspDataSetUtilsTest.TearDown;
begin
  FreeAndNil(FDataSet);
end;

procedure TspDataSetUtilsTest.TestExecute;
begin
  FDataSetIteration.Execute;
  Assert.AreEqual(10, FCount);
end;

{ TspDataSetOperationFieldTest }

procedure TspDataSetOperationFieldTest.AjustarValoresMultiplosDeDez;
begin
  FDataSet.First;
  while not FDataSet.Eof do
    begin
      FDataSet.Edit;
      FDataSet.FieldByName('Valor').AsCurrency := FDataSet.RecNo * 10;
      FDataSet.Post;
      FDataSet.Next;
    end;
  FDataSet.First;
end;

procedure TspDataSetOperationFieldTest.ExecuteComException;
begin
  FDataSetIteration.Execute;
end;

procedure TspDataSetOperationFieldTest.Setup;
begin
  FDataSet := CriarDataSetProjetos(nil);
  IniciarDadosDeTeste(FDataSet, 10, 100);
end;

procedure TspDataSetOperationFieldTest.TearDown;
begin
  FreeAndNil(FDataSet);
end;

procedure TspDataSetOperationFieldTest.TestTspOperacaoSomaCampo;
var
  Valor: Currency;
begin
  AjustarValoresMultiplosDeDez;
  FOperation := TspOperacaoSomaCampo.Create(FDataSet.FindField('Valor'));
  FDataSetIteration := TspDataSetOperationField<Currency>.Create(FDataSet, FOperation);
  FDataSetIteration.Execute;
  Valor := 550.00;
  Assert.AreEqual(Valor, FOperation.GetResult);
end;

procedure TspDataSetOperationFieldTest.TestTspOperacaoSomaDaDivisaoNumeroAnterior;
var
  Valor: Currency;
begin
  AjustarValoresMultiplosDeDez;
  FOperation := TspOperacaoSomaDaDivisaoNumeroAnterior.Create(FDataSet.FindField('Valor'));
  FDataSetIteration := TspDataSetOperationField<Currency>.Create(FDataSet, FOperation);
  FDataSetIteration.Execute;
  Valor := 11.829;
  Assert.AreEqual(Valor, FOperation.GetResult);
end;

procedure TspDataSetOperationFieldTest.TestTspOperacaoSomaDaDivisaoNumeroAnteriorComEDivZero;
begin
  FDataSet.RecNo := 2;
  FDataSet.Edit;
  FDataSet.FieldByName('Valor').AsCurrency := 0;
  FDataSet.Post;
  FOperation := TspOperacaoSomaDaDivisaoNumeroAnterior.Create(FDataSet.FindField('Valor'));
  FDataSetIteration := TspDataSetOperationField<Currency>.Create(FDataSet, FOperation);
  Assert.WillRaise(ExecuteComException, EOperationException);
end;

procedure TspDataSetOperationFieldTest.TestTspOperacaoSomaDaDivisaoNumeroAnteriorComInvalidOp;
begin
  FDataSet.Append;
  FDataSet.Post;
  FDataSet.Append;
  FDataSet.Post;
  FOperation := TspOperacaoSomaDaDivisaoNumeroAnterior.Create(FDataSet.FindField('Valor'));
  FDataSetIteration := TspDataSetOperationField<Currency>.Create(FDataSet, FOperation);
  Assert.WillRaise(ExecuteComException, EOperationException);
end;

initialization
  TDUnitX.RegisterTestFixture(TspDataSetUtilsTest);
end.
