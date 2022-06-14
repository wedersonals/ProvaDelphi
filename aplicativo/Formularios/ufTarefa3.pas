unit ufTarefa3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient, uProjetoServico;

type
  TfTarefa3 = class(TForm)
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    edtTotal: TEdit;
    edtTotalDivisoes: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    ProjetoServico: IProjetoServico;
    cdsProjeto: TClientDataSet;
    dsProjeto: TDataSource;
    procedure PrepararEstruturaDeDados;
  public
    { Public declarations }
  end;

var
  fTarefa3: TfTarefa3;

implementation

uses uspDataSetUtils;

{$R *.dfm}

procedure TfTarefa3.PrepararEstruturaDeDados;
var
  DataSetMock: IProjetoServicoMock;
begin
  cdsProjeto := ProjetoServico.GetDataSet;

  dsProjeto := TDataSource.Create(Self);
  dsProjeto.DataSet := cdsProjeto;

  DBGrid1.DataSource := dsProjeto;

  DataSetMock := TProjetoServicoMockRandomico.Create(cdsProjeto, 10, 100.00);
  DataSetMock.IniciarDadosDeTeste;
end;

procedure TfTarefa3.Button1Click(Sender: TObject);
begin
  edtTotal.Text := FormatFloat('#0.00', ProjetoServico.ObterTotal);
end;

procedure TfTarefa3.Button2Click(Sender: TObject);
begin
  edtTotalDivisoes.Text := FormatFloat('#0.00', ProjetoServico.ObterTotalDivisoes);
end;

procedure TfTarefa3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(dsProjeto);
  Action := caFree;
  fTarefa3 := Nil;
end;

procedure TfTarefa3.FormCreate(Sender: TObject);
begin
  ProjetoServico := TProjetoServico.Create;
  PrepararEstruturaDeDados;
end;

end.
