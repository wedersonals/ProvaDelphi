unit uTarefa2Servico;

interface

uses System.Classes, Vcl.ComCtrls, Dialogs;

type
  TTarefaServico = class(TThread)
  private
    FBarraProgresso: TProgressBar;
    FIntervalo,
    FIteracoes: Cardinal;
    procedure AtualizaProgresso;
  public
    constructor Create(Intervalo: Cardinal; BarraProgresso: TProgressBar);
    procedure Execute; override;
  end;

implementation

{ TTarefaServico }

constructor TTarefaServico.Create(Intervalo: Cardinal; BarraProgresso: TProgressBar);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FIntervalo := Intervalo;
  FIteracoes := 100;
  FBarraProgresso := BarraProgresso;
  FBarraProgresso.Position := 0;
  FBarraProgresso.Max      := FIteracoes;
end;

procedure TTarefaServico.Execute;
var
  I: Integer;
begin
  inherited;
  for I := 0 to FIteracoes do
    begin
      Sleep(FIntervalo);
      Queue(AtualizaProgresso);
    end;
end;

procedure TTarefaServico.AtualizaProgresso;
begin
  FBarraProgresso.StepBy(1);
end;

end.
