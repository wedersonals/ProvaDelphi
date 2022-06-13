unit uProvaDelphiApp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TfProvaDelphiApp = class(TForm)
    MainMenu1: TMainMenu;
    arefas1: TMenuItem;
    miTarefa1: TMenuItem;
    miTarefa2: TMenuItem;
    miTarefa3: TMenuItem;
    procedure miTarefa1Click(Sender: TObject);
    procedure miTarefa2Click(Sender: TObject);
    procedure miTarefa3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fProvaDelphiApp: TfProvaDelphiApp;

implementation

uses ufTarefa1, ufTarefa2, ufTarefa3;

{$R *.dfm}

type
  TFormClass = class of TForm;

procedure AppChildFormFactory(InstanceClass: TFormClass; var Form);
begin
  if not Assigned(TForm(Form)) then
    Application.CreateForm(InstanceClass, Form)
  else
    TForm(Form).BringToFront;
end;

procedure TfProvaDelphiApp.miTarefa1Click(Sender: TObject);
begin
  AppChildFormFactory(TFTarefa1, fTarefa1);
end;

procedure TfProvaDelphiApp.miTarefa2Click(Sender: TObject);
begin
  AppChildFormFactory(TFTarefa2, fTarefa2);
end;

procedure TfProvaDelphiApp.miTarefa3Click(Sender: TObject);
begin
  AppChildFormFactory(TFTarefa3, fTarefa3);
end;

end.
