program PortersTests;

uses
  TestFramework,
  GUITestRunner,
  IWInit,
  IWGlobal,
  Tests in 'Tests.pas',
  Stemming in 'Stemming.pas';

{$R *.res}

begin
  TGUITestRunner.runRegisteredTests;
end.
