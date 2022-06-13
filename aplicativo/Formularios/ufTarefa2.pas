unit ufTarefa2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ComCtrls, uTarefa2Servico;

type
  TfTarefa2 = class(TForm)
    seThread1: TSpinEdit;
    seThread2: TSpinEdit;
    bIniciar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    pbThread1: TProgressBar;
    pbThread2: TProgressBar;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bIniciarClick(Sender: TObject);
  private
    { Private declarations }
    Thread01,
    Thread02: TTarefaServico;
    procedure onThreadTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  fTarefa2: TfTarefa2;

implementation

{$R *.dfm}

procedure TfTarefa2.bIniciarClick(Sender: TObject);
begin
  bIniciar.Enabled := False;

  Thread01 := TTarefaServico.Create(seThread1.Value, pbThread1);
  Thread01.OnTerminate := onThreadTerminate;
  Thread02 := TTarefaServico.Create(seThread2.Value, pbThread2);
  Thread02.OnTerminate := onThreadTerminate;

  Thread01.Start;
  Thread02.Start;
end;

procedure TfTarefa2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  fTarefa2 := Nil;
end;

procedure TfTarefa2.onThreadTerminate(Sender: TObject);
begin
  if (pbThread1.Position = pbThread1.Max) and (pbThread2.Position = pbThread2.Max) then
    bIniciar.Enabled := True;
end;

end.
