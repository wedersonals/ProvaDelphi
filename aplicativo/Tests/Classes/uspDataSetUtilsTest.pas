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
    FProjetoServico: IProjetoServico;
    FDataSetMock: IProjetoServicoMock;
    procedure OnExecuteIteration(DataSet: TDataSet);
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure TestExecute;
  end;

  [TestFixture]
  TspDataSetOperationFieldTest = class
  private
    FDataSet: TDataSet;
    FDataSetIteration: IspDataSetIteration;
    FOperation: IspOperation<Currency>;
    FProjetoServico: IProjetoServico;
    FDataSetMock: TProjetoServicoMock;
    procedure ExecuteComException;
  public
    [Setup]
    procedure Setup;
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

{ TspDataSetUtilsTest }

procedure TspDataSetUtilsTest.OnExecuteIteration(DataSet: TDataSet);
begin
  FCount := DataSet.RecNo;
end;

procedure TspDataSetUtilsTest.Setup;
begin
  FProjetoServico := TProjetoServico.Create;
  FDataSet := FProjetoServico.GetDataSet;

  FDataSetMock := TProjetoServicoMockRandomico.Create(FDataSet, 10, 100.00);
  FDataSetMock.IniciarDadosDeTeste;

  FDataSetIteration := TspDataSetIteration.Create(FDataSet);
  FDataSetIteration.OnExecute := OnExecuteIteration;
end;

procedure TspDataSetUtilsTest.TestExecute;
begin
  FDataSetIteration.Execute;
  Assert.AreEqual(10, FCount);
end;

{ TspDataSetOperationFieldTest }

procedure TspDataSetOperationFieldTest.ExecuteComException;
begin
  FDataSetIteration.Execute;
end;

procedure TspDataSetOperationFieldTest.Setup;
begin
  FProjetoServico := TProjetoServico.Create;
  FDataSet := FProjetoServico.GetDataSet;
end;

procedure TspDataSetOperationFieldTest.TestTspOperacaoSomaCampo;
var
  Valor: Currency;
begin
  FDataSetMock := TProjetoServicoMockMultiploDeNumero.Create(FDataSet, 10, 10);
  FDataSetMock.IniciarDadosDeTeste;

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
  FDataSetMock := TProjetoServicoMockMultiploDeNumero.Create(FDataSet, 10, 10);
  FDataSetMock.IniciarDadosDeTeste;

  FOperation := TspOperacaoSomaDaDivisaoNumeroAnterior.Create(FDataSet.FindField('Valor'));
  FDataSetIteration := TspDataSetOperationField<Currency>.Create(FDataSet, FOperation);
  FDataSetIteration.Execute;
  Valor := 11.829;
  Assert.AreEqual(Valor, FOperation.GetResult);
end;

procedure TspDataSetOperationFieldTest.TestTspOperacaoSomaDaDivisaoNumeroAnteriorComEDivZero;
begin
  FDataSetMock := TProjetoServicoMockMultiploDeNumero.Create(FDataSet, 10, 10);
  FDataSetMock.IniciarDadosDeTeste;

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
  FDataSetMock := TProjetoServicoMockMultiploDeNumero.Create(FDataSet, 10, 10);
  FDataSetMock.IniciarDadosDeTeste;

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
