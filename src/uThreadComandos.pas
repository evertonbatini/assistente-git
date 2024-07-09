unit uThreadComandos;

interface

uses Classes, Windows;

type
  TCommandoExec = class
  public
    comando:String;
    sPath:String;
    repo:String;
    salvarResult: Boolean;
  end;


type
  TComandos = class(TThread)
  public
    destructor Destroy; override;
    procedure addComando(comando:TCommandoExec);
    function executando:Boolean;
  private
    comandosExec:TList;
    procedure Comando(comandoExec:TCommandoExec);
    function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean;
      ProcID: PDWORD): Longword;
  protected
    procedure Execute; override;
  end;

implementation

uses Contnrs;



{ TComandos }

destructor TComandos.Destroy;
begin
  inherited;
end;

procedure TComandos.Execute;
var
  commandoExec:TCommandoExec;
begin
  comandosExec := TList.Create;

  while not Terminated do
  begin
    if (comandosExec.Count > 0) then
    begin
      Comando(comandosExec[0]);
      comandosExec.Delete(0);
    end;
    Sleep(1000);
  end;
  Terminate;
end;

procedure TComandos.Comando(comandoExec:TCommandoExec);
var
  ProcID: Cardinal;
  sResult:TStringList;
  show:Integer;
  comando, sPath, repo: String;
  salvarResult: boolean;
begin
  comando := comandoExec.comando;
  sPath := comandoExec.sPath;
  repo := comandoExec.repo;
  salvarResult := comandoExec.salvarResult;
  
  ProcID := 0;
  //if (aguardar) then
  //  Log('Aguarde...');

  //Application.ProcessMessages;

  // sPath := ExtractFilePath(Application.ExeName);

  {if (CheckVerComandos.Checked) then
  begin
    comando := 'pause & '+comando+' & pause';
    show := SW_SHOWNORMAL;
  end
  else
    show := SW_HIDE;}

  show := SW_HIDE;

  comando := ' echo %date% %time% comando: "' + comando + '">>' + sPath + 'result & ' + comando;

  comando := 'cmd.exe /c cd '+repo+' & ' + comando;

  if (salvarResult) then
    comando := comando + '>>' + sPath + 'result 2>&1';

  RunProcess(PChar(comando), show, true, @ProcID);

  {if FileExists(sPath+'result') then
    Memo1.Lines.LoadFromFile(sPath+'result');}
end;

function TComandos.RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID:
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

procedure TComandos.addComando(comando: TCommandoExec);
begin
  comandosExec.Add(comando);
end;

function TComandos.executando: Boolean;
begin
  Result := comandosExec.Count > 0;
end;

end.
