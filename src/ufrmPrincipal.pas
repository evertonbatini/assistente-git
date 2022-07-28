unit ufrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    btnListar: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    ListaBranchs: TListBox;
    btnMudarPara: TButton;
    Timer1: TTimer;
    btnMesclar: TButton;
    edBranchBase: TEdit;
    lbMerge: TLabel;
    edNovaBranch: TEdit;
    Label2: TLabel;
    edPesquisar: TEdit;
    Label3: TLabel;
    procedure btnListarClick(Sender: TObject);
    procedure btnMudarParaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListaBranchsDblClick(Sender: TObject);
    procedure ListaBranchsClick(Sender: TObject);
    procedure btnMesclarClick(Sender: TObject);
    procedure edNovaBranchChange(Sender: TObject);
    procedure edNovaBranchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListaBranchsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPesquisarChange(Sender: TObject);
  private
    function DataArquivo(arquivo: string): TDateTime;
    function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean;
      ProcID: PDWORD): Longword;
    procedure Comando(comando: String; aguardar: boolean = true);
    function Branch: String;
    procedure Log(sLog: string);
    procedure AddBranch(sBranch: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnListarClick(Sender: TObject);
var
  sArquivo:TStringList;
  sPath:String;
  dtArquivo: TDateTime;
  i:Integer;
begin
  sPath := ExtractFilePath(Application.ExeName);

  Comando('git branch -a --sort=-committerdate>'+sPath+'branch');

  dtArquivo := DataArquivo(sPath+'branch');
  Log('Atualizado: ' + DateTimeToStr(dtArquivo));

  sArquivo := TStringList.Create;
  sArquivo.LoadFromFile(sPath+'branch');
  sArquivo.Text := UTF8Decode(sArquivo.Text);

  ListaBranchs.Items.Text := sArquivo.Text;
  ListaBranchs.Items.Clear;
  for i := 0 to sArquivo.Count-1 do
  begin
    AddBranch(sArquivo[i]);
  end;
end;

procedure TfrmPrincipal.AddBranch(sBranch:string);
var
  i:Integer;
begin
  sBranch := StringReplace(sBranch, 'remotes/origin/', '', []);

  for i := 0 to ListaBranchs.Items.Count-1 do
  begin
    if (ListaBranchs.Items[i] = sBranch) or (ListaBranchs.Items[i] = sBranch) then
      Exit;
  end;

  ListaBranchs.Items.Add(sBranch);
end;

function TfrmPrincipal.DataArquivo(arquivo: string):TDateTime;
var
  F : TSearchRec;
begin
  FindFirst(arquivo,faAnyFile,F);
  Result := fileDateToDateTime(F.Time);
  FindClose(F);
end;

procedure TfrmPrincipal.Comando(comando:String; aguardar: boolean = true);
var
  ProcID: Cardinal;
begin
  ProcID := 0;
  if (aguardar) then
    Log('Aguarde...');
  Application.ProcessMessages;
  RunProcess(PChar('cmd.exe /c cd '+Edit1.Text+' & ' + comando + ''), SW_HIDE, aguardar, @ProcID);
end;

function TfrmPrincipal.RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID:
  PDWORD): Longword;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
  StartupInfo.wShowWindow := ShowCmd;
  if not CreateProcess(nil,
    @FileName[1],
    nil,
    nil,
    False,
    CREATE_NEW_CONSOLE or
    NORMAL_PRIORITY_CLASS,
    nil,
    nil,
    StartupInfo,
    ProcessInfo)
    then
    Result := WAIT_FAILED
  else
  begin
    if wait = FALSE then
    begin
      if ProcID <> nil then
        ProcID^ := ProcessInfo.dwProcessId;
      result := WAIT_FAILED;
      exit;
    end;
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
  end;
  if ProcessInfo.hProcess <> 0 then
    CloseHandle(ProcessInfo.hProcess);
  if ProcessInfo.hThread <> 0 then
    CloseHandle(ProcessInfo.hThread);
end;

procedure TfrmPrincipal.btnMudarParaClick(Sender: TObject);
begin
  Comando('git checkout ' + Branch + ' & git pull origin '+Branch);
  btnListar.Click;
end;

function TfrmPrincipal.Branch():String;
begin
  Result := ListaBranchs.Items[ListaBranchs.ItemIndex];
  Result := StringReplace(Result, 'remotes/origin/', '', []);
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  btnListar.Click;
  Comando('git fetch', false);
end;

procedure TfrmPrincipal.ListaBranchsDblClick(Sender: TObject);
begin
  // ShowMessage(Branch);
  btnMudarPara.Click;
end;

procedure TfrmPrincipal.ListaBranchsClick(Sender: TObject);
begin
  lbMerge.Caption := 'Merge ' + edBranchBase.Text + ' > ' + Branch; 
end;

procedure TfrmPrincipal.btnMesclarClick(Sender: TObject);
begin
  Comando('git checkout ' + Branch + ' & git pull origin '+Branch);
  Comando('git checkout ' + edBranchBase.Text);
  Comando('git pull');
  Comando('git checkout ' + Branch);
  Comando('git merge ' + edBranchBase.Text);
end;

procedure TfrmPrincipal.Log(sLog:string);
begin
  Caption := 'Assistente Git - ' + sLog;
end;

procedure TfrmPrincipal.edNovaBranchChange(Sender: TObject);
begin
  if (edNovaBranch.Text <> '') then
    Label2.Caption := 'Criar Nova Branch [Enter]'
  else
    Label2.Caption := 'Criar Nova Branch';
end;

procedure TfrmPrincipal.edNovaBranchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (edNovaBranch.Text <> '') then
  begin
    Comando('git checkout ' + edBranchBase.Text);
    Comando('git pull');
    Comando('git checkout -b ' + edNovaBranch.Text);
    btnListar.Click;
  end;
end;

procedure TfrmPrincipal.ListaBranchsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
  begin
    if (MessageDlg('Deletar '+Branch+'?', mtConfirmation, [mbYes, mbNo], 0)) = mrYes then
    begin
      Comando('git checkout ' + edBranchBase.Text);
      Comando('git branch -d ' + Branch);
      btnListar.Click;
    end;
  end;
end;

procedure TfrmPrincipal.edPesquisarChange(Sender: TObject);
var
  i:Integer;
begin
  for i := 0 to ListaBranchs.Items.Count-1 do
  begin
    if Pos(edPesquisar.Text, ListaBranchs.Items[i]) > 0 then
    begin
      ListaBranchs.ItemIndex := i;
      Exit;
    end;
  end;
end;

end.
