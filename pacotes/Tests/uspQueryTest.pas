unit uspQueryTest;

interface

uses
  DUnitX.TestFramework,
  FireDac.DApt,
  FireDac.Phys.MySQL,
  System.SysUtils,
  System.Classes,
  uspQuery;

type
  [TestFixture]
  TspGeradorSQLTest = class
  private
    GeradorSQL: TspGeradorSQL;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('TestGeraSQL',
              'tabela|campo1,campo2,campo3|WHERE campo1 = 1|' +
              'SELECT[QUEBRA][INDENT]campo1, campo2, campo3[QUEBRA]FROM[QUEBRA][INDENT]tabela[QUEBRA]WHERE campo1 = 1[QUEBRA]','|')]
    [TestCase('TestGeraSQLSemCampoInformado',
              'tabela||WHERE campo1 = 1|' +
              'SELECT[QUEBRA][INDENT]*[QUEBRA]FROM[QUEBRA][INDENT]tabela[QUEBRA]WHERE campo1 = 1[QUEBRA]','|')]
    [TestCase('TestGeraSQLQuebraLinhaDeColunas',
              'tabela|campo1,campo2,campo3,campo4,campo5,campo6|WHERE campo1 = 1|' +
              'SELECT[QUEBRA][INDENT]campo1, campo2, campo3, campo4, campo5, [QUEBRA][INDENT]campo6[QUEBRA]FROM[QUEBRA][INDENT]tabela[QUEBRA]WHERE campo1 = 1[QUEBRA]','|')]
    [TestCase('TestGeraSQLCondicoesSemOperador',
              'tabela|campo1,campo2,campo3|campo1 = 1,campo2 = 2|' +
              'SELECT[QUEBRA][INDENT]campo1, campo2, campo3[QUEBRA]FROM[QUEBRA][INDENT]tabela[QUEBRA]WHERE campo1 = 1[QUEBRA]  AND campo2 = 2[QUEBRA]','|')]
    [TestCase('TestGeraSQLCondicoesSemOperadorESemSeparadorFinalLinha',
              'tabela|campo1,campo2|campo1 = 1' + sLineBreak + 'campo2 = 2|' +
              'SELECT[QUEBRA][INDENT]campo1, campo2[QUEBRA]FROM[QUEBRA][INDENT]tabela[QUEBRA]WHERE campo1 = 1[QUEBRA]  AND campo2 = 2[QUEBRA]','|')]
    procedure TestGeraSQL(const Tabelas, Colunas, Condicoes, Esperado: String);
    [Test]
    procedure TestTabelaNaoInformada;
    [Test]
    procedure TestMaisDeUmaTabelaInformada;
  end;

  [TestFixture]
  TspQueryTest = class
  private
    Query: TspQuery;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestIntegracaoGeradorSQL;
  end;

implementation

procedure TspGeradorSQLTest.Setup;
begin
  GeradorSQL := TspGeradorSQL.Create;
end;

procedure TspGeradorSQLTest.TearDown;
begin
  FreeAndNil(GeradorSQL);
end;

procedure TspGeradorSQLTest.TestGeraSQL(const Tabelas, Colunas, Condicoes, Esperado: String);
var
  resultadoEsperado: String;
begin
  GeradorSQL.GetColunas.Text := Colunas;
  GeradorSQL.GetTabelas.Text := Tabelas;
  GeradorSQL.GetCondicoes.Text := Condicoes;

  GeradorSQL.GeraSQL;

  resultadoEsperado := esperado;
  resultadoEsperado := StringReplace(resultadoEsperado, '[INDENT]', SqlIndentation, [rfReplaceAll]);
  resultadoEsperado := StringReplace(resultadoEsperado, '[QUEBRA]', SqlBreakLine, [rfReplaceAll]);

  Assert.AreEqual(resultadoEsperado, GeradorSQL.GetSQL);
end;

procedure TspGeradorSQLTest.TestTabelaNaoInformada;
begin
  GeradorSQL.GetTabelas.Text := '';
  Assert.WillRaise(GeradorSQL.GeraSQL, EspGeradorSQLException);
end;

procedure TspGeradorSQLTest.TestMaisDeUmaTabelaInformada;
begin
  GeradorSQL.GetTabelas.Text := 'tabela1, tabela2';
  Assert.WillRaise(GeradorSQL.GeraSQL, EspGeradorSQLException);
end;

{ TspQueryTest }

procedure TspQueryTest.Setup;
begin
  Query := TspQuery.Create(nil);
end;

procedure TspQueryTest.TearDown;
begin
  FreeAndNil(Query);
end;

procedure TspQueryTest.TestIntegracaoGeradorSQL;
begin
  Query.spTabelas.Text := 'tabela_teste';
  Query.GeraSQL;
  Assert.AreEqual(True, Query.SQL.Text.Contains('tabela_teste'));
end;

initialization
  TDUnitX.RegisterTestFixture(TspGeradorSQLTest);
  TDUnitX.RegisterTestFixture(TspQueryTest);

end.
