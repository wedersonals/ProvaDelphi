program ProvaDelphiApp;

uses
  Vcl.Forms,
  uProvaDelphiApp in 'Formularios\uProvaDelphiApp.pas' {fProvaDelphiApp},
  ufTarefa1 in 'Formularios\ufTarefa1.pas' {fTarefa1},
  ufTarefa2 in 'Formularios\ufTarefa2.pas' {fTarefa2},
  ufTarefa3 in 'Formularios\ufTarefa3.pas' {fTarefa3},
  uTarefa2Servico in 'Servicos\uTarefa2Servico.pas',
  uspDataSetUtils in 'Classes\uspDataSetUtils.pas',
  uProjetoServico in 'Servicos\uProjetoServico.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfProvaDelphiApp, fProvaDelphiApp);
  Application.Run;
end.
