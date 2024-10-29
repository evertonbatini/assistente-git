unit ufrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, ExtCtrls, uThreadComandos, Buttons,
  frxpngimage, JvExControls, JvXPCore, JvXPContainer, JvExExtCtrls,
  JvExtComponent, JvPanel;

type
  TfrmPrincipal = class(TForm)
    Timer1: TTimer;
    TimerAtualizar: TTimer;
    Panel6: TPanel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Panel7: TPanel;
    Panel1: TPanel;
    Label3: TLabel;
    Shape1: TShape;
    Label1: TLabel;
    lbMerge1: TLabel;
    Label2: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    edPesquisar: TEdit;
    Edit1: TEdit;
    edBranchBase: TEdit;
    edNovaBranch: TEdit;
    CheckVerComandos: TCheckBox;
    Panel8: TPanel;
    ListaBranchs: TListBox;
    Memo1: TMemo;
    pnBotaoAtualizar: TPanel;
    Shape6: TShape;
    JvPanel1: TJvPanel;
    Label8: TLabel;
    Image5: TImage;
    Bevel11: TBevel;
    Bevel2: TBevel;
    Bevel8: TBevel;
    Bevel12: TBevel;
    JvPanel3: TJvPanel;
    Label10: TLabel;
    pnBotaoMesclar: TPanel;
    Shape5: TShape;
    JvPanel2: TJvPanel;
    Label4: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Bevel9: TBevel;
    JvPanel4: TJvPanel;
    Label9: TLabel;
    pnBotaoMudarPara: TPanel;
    Shape7: TShape;
    JvPanel5: TJvPanel;
    Label5: TLabel;
    Image2: TImage;
    Bevel5: TBevel;
    Bevel6: TBevel;
    JvPanel6: TJvPanel;
    Label6: TLabel;
    pnBotaoEnviar: TPanel;
    Shape8: TShape;
    JvPanel7: TJvPanel;
    Label7: TLabel;
    Image3: TImage;
    Bevel7: TBevel;
    Bevel10: TBevel;
    JvPanel8: TJvPanel;
    Label11: TLabel;
    Image4: TImage;
    Bevel14: TBevel;
    lbMerge: TLabel;
    pnBotaoSair: TPanel;
    Shape9: TShape;
    JvPanel9: TJvPanel;
    Label12: TLabel;
    Image6: TImage;
    Bevel13: TBevel;
    Bevel15: TBevel;
    JvPanel10: TJvPanel;
    Label13: TLabel;
    pnLog: TPanel;
    TimerRepaint: TTimer;
    Image7: TImage;
    Timer2: TTimer;
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
    procedure FormCreate(Sender: TObject);
    procedure TimerAtualizarTimer(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure LabelBotaoMouseEnter(Sender: TObject);
    procedure LabelBotaoMouseLeave(Sender: TObject);
    procedure Label10MouseEnter(Sender: TObject);
    procedure Label10MouseLeave(Sender: TObject);
    procedure Label9MouseEnter(Sender: TObject);
    procedure Label9MouseLeave(Sender: TObject);
    procedure Label6MouseEnter(Sender: TObject);
    procedure Label6MouseLeave(Sender: TObject);
    procedure Label11MouseEnter(Sender: TObject);
    procedure Label11MouseLeave(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label13MouseEnter(Sender: TObject);
    procedure Label13MouseLeave(Sender: TObject);
    procedure ListaBranchsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListaBranchsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TimerRepaintTimer(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure edBranchBaseChange(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    sPath:string;
    ComandosThread:TComandos;
    RectAnterior: TRect;
    indiceAnterior: Integer;
    function DataArquivo(arquivo: string): TDateTime;
    function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean;
      ProcID: PDWORD): Longword;
    procedure Comando(comando:String; aguardar: boolean = true; salvarResult: boolean = true);
    function Branch: String;
    procedure Log(sLog: string);
    procedure AddBranch(sBranch: string);
    procedure LimparResult;
    procedure AtualizarListas;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses Types;

{$R *.dfm}

procedure TfrmPrincipal.btnListarClick(Sender: TObject);
begin
  Comando('git branch -a --sort=-committerdate>'+sPath+'branch', true, false);

  TimerAtualizar.Enabled := True;
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

{procedure TfrmPrincipal.Comando(comando:String; aguardar: boolean = true; salvarResult: boolean = true);
var
  ProcID: Cardinal;
  sPath:String;
  sResult:TStringList;
  show:Integer;
begin
  ProcID := 0;
  if (aguardar) then
    Log('Aguarde...');

  Application.ProcessMessages;

  if (CheckVerComandos.Checked) then
  begin
    comando := 'pause & '+comando+' & pause';
    show := SW_SHOWNORMAL;
  end
  else
    show := SW_HIDE;

  comando := ' echo %date% %time% comando: "' + comando + '">>' + sPath + 'result & ' + comando;

  comando := 'cmd.exe /c cd '+Edit1.Text+' & ' + comando;

  if (salvarResult) then
    comando := comando + '>>' + sPath + 'result 2>&1';

  RunProcess(PChar(comando), show, aguardar, @ProcID);

  if FileExists(sPath+'result') then
    Memo1.Lines.LoadFromFile(sPath+'result');
end;}

procedure TfrmPrincipal.Comando(comando:String; aguardar: boolean = true; salvarResult: boolean = true);
var
  commandExec:TCommandoExec;
begin
  commandExec := TCommandoExec.Create;
  commandExec.comando := comando;
  commandExec.sPath := sPath;
  commandExec.repo := Edit1.Text;
  commandExec.salvarResult := salvarResult;
  ComandosThread.addComando(commandExec);
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
  LimparResult;
  Comando('git checkout ' + Branch);
  Comando('git pull origin ' + Branch);
  btnListarClick(Sender);
end;

function TfrmPrincipal.Branch():String;
begin
  Result := ListaBranchs.Items[ListaBranchs.ItemIndex];
  Result := StringReplace(Result, 'remotes/origin/', '', []);
  Result := StringReplace(Result, '* ', '', []);
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  //sem thread
  {
  Timer1.Enabled := False;
  Comando('git fetch', true, false);
  btnListar.Click;
  }

  if (ComandosThread <> nil) then
  begin
    Timer1.Enabled := False;
    Comando('git fetch', true, false);
    btnListarClick(Sender);
  end;
end;

procedure TfrmPrincipal.ListaBranchsDblClick(Sender: TObject);
begin
  // ShowMessage(Branch);
  btnMudarParaClick(Sender);
end;

procedure TfrmPrincipal.ListaBranchsClick(Sender: TObject);
begin
  lbMerge.Caption := 'Merge ' + edBranchBase.Text + ' > ' + Branch; 
end;

procedure TfrmPrincipal.btnMesclarClick(Sender: TObject);
begin
  Comando('git checkout ' + Branch);
  Comando('git pull origin '+Branch);
  Comando('git checkout ' + edBranchBase.Text);
  Comando('git pull');
  Comando('git checkout ' + Branch);
  Comando('git merge ' + edBranchBase.Text);
  btnListarClick(Sender);
end;

procedure TfrmPrincipal.Log(sLog:string);
begin
  Caption := 'Assistente Git - ' + sLog;
  pnLog.Caption := sLog;
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
    LimparResult;
    Comando('git checkout ' + edBranchBase.Text);
    Comando('git pull');
    Comando('git checkout -b ' + edNovaBranch.Text);
    btnListarClick(Sender);
  end;
end;

procedure TfrmPrincipal.ListaBranchsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
  begin
    if (MessageDlg('Deletar '+Branch+'?', mtConfirmation, [mbYes, mbNo], 0)) = mrYes then
    begin
      LimparResult;
      Comando('git checkout ' + edBranchBase.Text);
      Comando('git branch -d ' + Branch);
      btnListarClick(Sender);
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

procedure TfrmPrincipal.LimparResult;
begin
  DeleteFile(sPath+'result');
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  sArquivo:TStringList;
begin
  if (FileExists(sPath+'branch-base')) then
  begin
    sArquivo := TStringList.Create;
    sArquivo.LoadFromFile(sPath+'branch-base');
    edBranchBase.Text := Trim(sArquivo.Strings[0]);
  end;

  Edit1.Text := ExtractFilePath(Application.ExeName);
  lbMerge.Caption := '';
  ComandosThread := TComandos.Create(False);
  AtualizarListas;

  RectAnterior.Left := 0;
  RectAnterior.Top := 0;
  RectAnterior.Right := 0;
  RectAnterior.Bottom := 0;
  indiceAnterior := -1;
end;

procedure TfrmPrincipal.TimerAtualizarTimer(Sender: TObject);
begin
  Log('Aguarde...');
  
  if (ComandosThread <> nil) and (not ComandosThread.executando) then
  begin
    TimerAtualizar.Enabled := False;
    AtualizarListas;
  end;
end;

procedure TfrmPrincipal.AtualizarListas;
var
  sArquivo:TStringList;
  dtArquivo: TDateTime;
  i:Integer;
begin
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

  if FileExists(sPath+'result') then
    Memo1.Lines.LoadFromFile(sPath+'result');
end;

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
begin
  Comando('git checkout ' + edBranchBase.Text); // Branch
  Comando('git pull origin ' + edBranchBase.Text); // Branch
  Comando('git checkout ' + Branch); // edBranchBase.Text
  Comando('git pull');
  Comando('git checkout ' + edBranchBase.Text); // Branch
  Comando('git merge ' + Branch); // edBranchBase.Text
  Comando('git push'); // Branch
  btnListarClick(Sender);
end;

procedure TfrmPrincipal.LabelBotaoMouseEnter(Sender: TObject);
begin
  //TPanel(TLabel(Sender).Parent).Color := $006D9708;
end;

procedure TfrmPrincipal.LabelBotaoMouseLeave(Sender: TObject);
begin
  //TPanel(TLabel(Sender).Parent).Color := $0087BB0A;
end;

procedure TfrmPrincipal.Label10MouseEnter(Sender: TObject);
begin
  Shape6.Brush.Color := $006D9708;
  Shape6.Repaint;
  jvpanel1.Repaint;
  jvpanel3.Repaint;
end;

procedure TfrmPrincipal.Label10MouseLeave(Sender: TObject);
begin
  Shape6.Brush.Color := $0087BB0A;
  Shape6.Repaint;
  jvpanel1.Repaint;
  jvpanel3.Repaint;
end;

procedure TfrmPrincipal.Label9MouseEnter(Sender: TObject);
begin
  Shape5.Brush.Color := $006D9708;
  Shape5.Repaint;
  jvpanel2.Repaint;
  jvpanel4.Repaint;
end;

procedure TfrmPrincipal.Label9MouseLeave(Sender: TObject);
begin
  Shape5.Brush.Color := $0087BB0A;
  Shape5.Repaint;
  jvpanel2.Repaint;
  jvpanel4.Repaint;
end;

procedure TfrmPrincipal.Label6MouseEnter(Sender: TObject);
begin
  Shape7.Brush.Color := $006D9708;
  Shape7.Repaint;
  jvpanel5.Repaint;
  jvpanel6.Repaint;
end;

procedure TfrmPrincipal.Label6MouseLeave(Sender: TObject);
begin
  Shape7.Brush.Color := $0087BB0A;
  Shape7.Repaint;
  jvpanel5.Repaint;
  jvpanel6.Repaint;
end;

procedure TfrmPrincipal.Label11MouseEnter(Sender: TObject);
begin
  Shape8.Brush.Color := $006D9708;
  Shape8.Repaint;
  jvpanel7.Repaint;
  jvpanel8.Repaint;
end;

procedure TfrmPrincipal.Label11MouseLeave(Sender: TObject);
begin
  Shape8.Brush.Color := $0087BB0A;
  Shape8.Repaint;
  jvpanel7.Repaint;
  jvpanel8.Repaint;
end;

procedure TfrmPrincipal.Label13Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.Label13MouseEnter(Sender: TObject);
begin
  Shape9.Brush.Color := $006D9708;
  Shape9.Repaint;
  jvpanel9.Repaint;
  jvpanel10.Repaint;
end;

procedure TfrmPrincipal.Label13MouseLeave(Sender: TObject);
begin
  Shape9.Brush.Color := $0087BB0A;
  Shape9.Repaint;
  jvpanel9.Repaint;
  jvpanel10.Repaint;
end;

procedure TfrmPrincipal.ListaBranchsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Rect: TRect;
  item:Integer;
begin
  item := Y div 30;
  // pnLog.Caption := 'X: '+Inttostr(x)+' Y: '+Inttostr(y);

  {TimerRepaint.Enabled := False;
  TimerRepaint.Enabled := True;}

  //pnLog.Caption := 'item: '+Inttostr(item);

  Rect.Left := 0;
  Rect.Top := item*30;
  Rect.Right := 623;
  Rect.Bottom := Rect.Top+30;

  with ListaBranchs.Canvas do
  begin
    if (indiceAnterior>=0) and (indiceAnterior <> ListaBranchs.ItemIndex) then
    begin
      Brush.Color := $00181818;
      Font.Color := $00CCCCCC;
      ListaBranchs.Canvas.FillRect(RectAnterior);
      if (indiceAnterior < ListaBranchs.Items.Count) then
        TextOut(RectAnterior.left, RectAnterior.top+5, ListaBranchs.Items[indiceAnterior]);
    end;

    if (item <> ListaBranchs.ItemIndex) then
    begin
      Brush.Color := $002E2D2A;
      ListaBranchs.Canvas.FillRect(Rect);
      if (item < ListaBranchs.Items.Count) then
        TextOut(Rect.left, Rect.top+5, ListaBranchs.Items[item]);
    end;

    RectAnterior := Rect;
    indiceAnterior := item;
  end;
end;

procedure TfrmPrincipal.ListaBranchsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Rect2, RectBorda: TRect;
  top, left:Integer;
begin
  {odSelected, odGrayed, odDisabled, odChecked,
    odFocused, odDefault, odHotLight, odInactive, odNoAccel, odNoFocusRect,
    odReserved1, odReserved2, odComboBoxEdit}

  {Memo1.Lines.Add(IntToStr(Rect.Left));
  Memo1.Lines.Add(IntToStr(Rect.Top));
  Memo1.Lines.Add(IntToStr(Rect.Right));
  Memo1.Lines.Add(IntToStr(Rect.Bottom));}

  top := Rect.Top;
  left := Rect.Left;

  Rect2.Left := Rect.Left+2;
  Rect2.Top := Rect.Top+2;
  Rect2.Right := Rect.Right-2;
  Rect2.Bottom := Rect.Bottom-2;

  RectBorda.Left := Rect.Left;
  RectBorda.Top := Rect.Top;
  RectBorda.Right := Rect.Right;
  RectBorda.Bottom := Rect.Bottom;

  with ListaBranchs.Canvas do
  begin
    Font.Color := $00CCCCCC;
    Brush.Color := $00181818;
    // Pen.Color := clBlack;

    if odFocused in State then
    begin
      Brush.Color := $00D47800; // azul claro
      FillRect(RectBorda);

      // Brush.Color := $00D47800; // azul claro
      Brush.Color := $005E3904; // azul escuro
      FillRect(Rect2);

      Font.Color := clWhite;
    end
    else
    if odSelected in State then
    begin
      Brush.Color := $003D3737;
    end;

    if not(odFocused in State) then
    begin
      FillRect(RectBorda);
      FillRect(Rect2);
    end;

    //FillRect(Rect);

    Brush.Style := bsClear;
    TextOut(left, top+5, ListaBranchs.Items[Index]);

    if odFocused in State then
      DrawFocusRect(Rect);
  end;
end;

procedure TfrmPrincipal.TimerRepaintTimer(Sender: TObject);
begin
  TimerRepaint.Enabled := False;
  ListaBranchs.Repaint;
end;

procedure TfrmPrincipal.Image7Click(Sender: TObject);
begin
  if (Panel6.Width = 144) then
    Panel6.Width := 49
  else
    Panel6.Width := 144;
end;

procedure TfrmPrincipal.edBranchBaseChange(Sender: TObject);
var
  sArquivo:TStringList;
begin
  sArquivo := TStringList.Create;
  sArquivo.Text := edBranchBase.Text;
  sArquivo.SaveToFile(sPath+'branch-base');
end;

procedure TfrmPrincipal.Timer2Timer(Sender: TObject);
var
  sArquivo:TStringList;
  result:string;
begin
  if FileExists(sPath+'result') then
  begin
    try
      sArquivo := TStringList.Create;
      sArquivo.LoadFromFile(sPath+'result');

      if (sArquivo.Text <> Memo1.Lines.Text) then
        Memo1.Lines.LoadFromFile(sPath+'result');

      FreeAndNil(sArquivo);
    except
    end;
  end;
end;

end.
