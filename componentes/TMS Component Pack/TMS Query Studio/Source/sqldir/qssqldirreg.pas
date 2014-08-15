unit qssqldirreg;

{$I tmsdefs.inc}
{$I metasql.inc}

interface

procedure Register;

implementation

uses
  {$IFDEF DELPHI6_LVL} Variants, DesignEditors, DesignIntf, {$ELSE} DsgnIntf, {$ENDIF}
  Classes,
  SDEngine, atSQLDirDatabase;

const
  {$IFDEF TMSIWSQL}
  SMetaSQLPaletteName = 'IW Query Builder';
  {$ELSE}
  SMetaSQLPaletteName = 'TMS Query Studio';
  {$ENDIF}

{------------------}
{ property editors }
{------------------}
type
  TatDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;  
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TatSQLDirDatabaseNameProp = class(TatDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

{ TatDBStringProperty }

function TatDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TatDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

{ TatSQLDirDatabaseNameProp }

procedure TatSQLDirDatabaseNameProp.GetValueList(List: TStrings);
begin
  SDEngine.Session.GetDatabaseNames(List);
end;

procedure Register;
begin
  RegisterComponents(SMetaSQLPaletteName, [TatSQLDirDatabase] );
  RegisterPropertyEditor( TypeInfo(string), TatSQLDirDatabase, 'DatabaseName', TatSQLDirDatabaseNameProp);
end;

end.