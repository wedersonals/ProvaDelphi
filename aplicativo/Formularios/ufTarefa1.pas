unit ufTarefa1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Vcl.StdCtrls, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDac.Phys.MySQL, uspQuery;

type
  TfTarefa1 = class(TForm)
    spQuery: TspQuery;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTarefa1: TfTarefa1;

implementation

{$R *.dfm}

procedure TfTarefa1.Button1Click(Sender: TObject);
begin
  spQuery.spColunas.SetStrings(memo1.Lines);
  spQuery.spTabelas.SetStrings(memo2.Lines);
  spQuery.spCondicoes.SetStrings(memo3.Lines);
  try
    spQuery.GeraSQL;
    Memo4.Lines.SetStrings(spQuery.SQL);
  except
    on E: EspGeradorSQLException do
      Application.MessageBox(PWideChar(E.Message), 'Erro', MB_ICONERROR + MB_OK);
  end;
end;

procedure TfTarefa1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  fTarefa1 := Nil;
end;

end.
