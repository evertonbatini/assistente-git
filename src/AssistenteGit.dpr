program AssistenteGit;

uses
  Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  uThreadComandos in 'uThreadComandos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
