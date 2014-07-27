unit Tests;

interface

uses
  Classes, SysUtils, TestFrameWork, Stemming;

type TPortersStemmerTest = class(TTestCase)
  published
    procedure IsVowelAEIOU;
    procedure IsVowelY;
    procedure MofZero;
    procedure MofOne;
    procedure MofTwo;
    procedure EndsIn;
    procedure ContainsVowel;
    procedure EndsInDoubleConsonant;
    procedure EndsInString;
    procedure ORule;
    procedure ReplaceEnding;
    procedure Step1A;

    procedure Step1B_A;
    procedure Step1B_B;
    procedure Step1B_C;
    procedure Step1B_D;
    procedure Step1B_E;
    procedure Step1B_F;
    procedure Step1B_G;
    procedure Step1B_H;

    procedure Step1B;

    procedure Step1C;

    procedure Step2;
    procedure Step3;
    procedure Step4;
    procedure Step5A;
    procedure Step5B;
  end;

implementation

uses
  IWTestFramework;

{ TPortersStemmerTest }

procedure TPortersStemmerTest.ContainsVowel;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.ContainsVowel('Adrian', Length('Adrian')) = True);
    Check(Porters.ContainsVowel('bled', 2) = False);
    Check(Porters.ContainsVowel('ccds', Length('ccds')) = False);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.EndsIn;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.EndsIn('Adrian', 'n'));
    Check(not Porters.EndsIn('Adrian', 'm'));
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.EndsInDoubleConsonant;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.EndsInDoubleConsonant('Bass'));
    Check(Porters.EndsInDoubleConsonant('Bell'));
    Check(not Porters.EndsInDoubleConsonant('Phonemn'));
    Check(not Porters.EndsInDoubleConsonant('Bee'));
    Check(not Porters.EndsInDoubleConsonant('a'));
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.EndsInString;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.EndsInString('Adrian', 'ian'));
    Check(Porters.EndsInString('bass', 'bass'));
    Check(Porters.EndsInString('bass', 's'));

    Check(not Porters.EndsInString('Adrian', 'iana'));
    Check(not Porters.EndsInString('bass', 'basp'));
    Check(not Porters.EndsInString('bass', 'b'));
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.IsVowelAEIOU;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.IsVowel('aeiou', 1) = Porters.IsVowel('aeiou', 2) = Porters.IsVowel('aeiou', 3) =
      Porters.IsVowel('aeiou', 4) = Porters.IsVowel('aeiou', 5) = True);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.IsVowelY;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.IsVowel('baby', 4) = True);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.MofOne;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.M('trouble', Length('trouble')) = 1);
    Check(Porters.M('oats', Length('oats')) = 1);
    Check(Porters.M('trees', Length('trees')) = 1);
    Check(Porters.M('ivy', Length('ivy')) = 1);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.MofTwo;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.M('troubles', Length('troubles')) = 2);
    Check(Porters.M('private', Length('private')) = 2);
    Check(Porters.M('oaten', Length('oaten')) = 2);
    Check(Porters.M('orrery', Length('orrery')) = 2);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.MofZero;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.M('by', Length('by')) = 0);
    Check(Porters.M('y', Length('y')) = 0);
    Check(Porters.M('tree', Length('tree')) = 0);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.ORule;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.ORule('wil') = True);
    Check(Porters.ORule('aborwil') = True);
    Check(Porters.ORule('hissop') = True);
    Check(not Porters.ORule('sissey') = True);
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.ReplaceEnding;
var
  Porters: TPortersStemmer;
  V: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.ReplaceEnding('adrian', 'rian', 'd', V) = 'add');
    Check(Porters.ReplaceEnding('adrian', 'n', 'd', V) = 'adriad');
    Check(Porters.ReplaceEnding('big', 'big', 'bass', V) = 'bass');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1A;
var
  Porters: TPortersStemmer;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1A('caresses') = 'caress');
    Check(Porters.Step1A('ponies') = 'poni');
    Check(Porters.Step1A('caress') = 'caress');
    Check(Porters.Step1A('cats') = 'cat');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B('conflated', Successful) = 'conflate');
    Check(Porters.Step1B('troubled', Successful) = 'trouble');
    Check(Porters.Step1B('sized', Successful) = 'size');
    Check(Porters.Step1B('hopping', Successful) = 'hop');
    Check(Porters.Step1B('tanned', Successful) = 'tan');
    Check(Porters.Step1B('falling', Successful) = 'fall');
    Check(Porters.Step1B('hissing', Successful) = 'hiss');
    Check(Porters.Step1B('fizzed', Successful) = 'fizz');
    Check(Porters.Step1B('failing', Successful) = 'fail');
    Check(Porters.Step1B('filing', Successful) = 'file');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_A;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_A('feed', Successful) = 'feed');
    Check(Porters.Step1B_A('agreed', Successful) = 'agree');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_B;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_B('plastered', Successful) = 'plaster');
    Check(Porters.Step1B_B('bled', Successful) = 'bled');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_C;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_C('sing', Successful) = 'sing');
    Check(Porters.Step1B_C('motoring', Successful) = 'motor');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_D;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_D('conflat', Successful) = 'conflate');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_E;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_E('troubl', Successful) = 'trouble');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_F;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_F('siz', Successful) = 'size');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_G;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_G('hopp', Successful) = 'hop');
    Check(Porters.Step1B_G('tann', Successful) = 'tan');
    Check(Porters.Step1B_G('hiss', Successful) = 'hiss');
    Check(Porters.Step1B_G('fizz', Successful) = 'fizz');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1B_H;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1B_H('fail', Successful) = 'fail');
    Check(Porters.Step1B_H('fil', Successful) = 'file');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step1C;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step1C('happy', Successful) = 'happi');
    Check(Porters.Step1C('sky', Successful) = 'sky');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step2;
var
  Porters: TPortersStemmer;
  Replacements: array [0..19] of array [0..1] of String;
  Successful: Boolean;
  I: Integer;
  Output: String;
begin
  Replacements[0][0] := 'relational';  Replacements[0][1] := 'relate';
  Replacements[1][0] := 'conditional';  Replacements[1][1] := 'condition';
  Replacements[2][0] := 'sensibiliti';  Replacements[2][1] := 'sensible';
  Replacements[3][0] := 'valenci';  Replacements[3][1] := 'valence';
  Replacements[4][0] := 'hesitanci';  Replacements[4][1] := 'hesitance';
  Replacements[5][0] := 'digitizer';  Replacements[5][1] := 'digitize';
  Replacements[6][0] := 'conformabli';  Replacements[6][1] := 'conformable';
  Replacements[7][0] := 'radicalli';  Replacements[7][1] := 'radical';
  Replacements[8][0] := 'differentli';  Replacements[8][1] := 'different';
  Replacements[9][0] := 'vileli';  Replacements[9][1] := 'vile';
  Replacements[10][0] := 'analogousli';  Replacements[10][1] := 'analogous';
  Replacements[11][0] := 'vietnamization';  Replacements[11][1] := 'vietnamize';
  Replacements[12][0] := 'predication';  Replacements[12][1] := 'predicate';
  Replacements[13][0] := 'operator';  Replacements[13][1] := 'operate';
  Replacements[14][0] := 'feudalism';  Replacements[14][1] := 'feudal';
  Replacements[15][0] := 'decisiveness';  Replacements[15][1] := 'decisive';
  Replacements[16][0] := 'hopefulness';  Replacements[16][1] := 'hopeful';
  Replacements[17][0] := 'callousness';  Replacements[17][1] := 'callous';
  Replacements[18][0] := 'formaliti';  Replacements[18][1] := 'formal';
  Replacements[19][0] := 'sensitiviti';  Replacements[19][1] := 'sensitive';


  Porters := TPortersStemmer.Create;
  try
    for I := 0 to 19 do begin
      Output := Porters.Step2(Replacements[I][0], Successful);
      Check(Output = Replacements[I][1], 'Failed for ' + Replacements[I][0] + ', output was ' + Output);
    end;
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step3;
var
  Porters: TPortersStemmer;
  Replacements: array [0..6] of array [0..1] of String;
  Successful: Boolean;
  I: Integer;
  Output: String;
begin
  Replacements[0][0] := 'triplicate';  Replacements[0][1] := 'triplic';
  Replacements[1][0] := 'formative';  Replacements[1][1] := 'form';
  Replacements[2][0] := 'formalize';  Replacements[2][1] := 'formal';
  Replacements[3][0] := 'electriciti';  Replacements[3][1] := 'electric';
  Replacements[4][0] := 'electrical';  Replacements[4][1] := 'electric';
  Replacements[5][0] := 'hopeful';  Replacements[5][1] := 'hope';
  Replacements[6][0] := 'goodness';  Replacements[6][1] := 'good';

  Porters := TPortersStemmer.Create;
  try
    for I := 0 to 6 do begin
      Output := Porters.Step3(Replacements[I][0], Successful);
      Check(Output = Replacements[I][1], 'Failed for ' + Replacements[I][0] + ', output was ' + Output);
    end;
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step4;
var
  Porters: TPortersStemmer;
  Replacements: array [0..18] of array [0..1] of String;
  Successful: Boolean;
  I: Integer;
  Output: String;
begin
  Replacements[0][0] := 'revival';  Replacements[0][1] := 'reviv';
  Replacements[1][0] := 'allowance';  Replacements[1][1] := 'allow';
  Replacements[2][0] := 'inference';  Replacements[2][1] := 'infer';
  Replacements[3][0] := 'airliner';  Replacements[3][1] := 'airlin';
  Replacements[4][0] := 'gyroscopic';  Replacements[4][1] := 'gyroscop';
  Replacements[5][0] := 'adjustable';  Replacements[5][1] := 'adjust';
  Replacements[6][0] := 'defensible';  Replacements[6][1] := 'defens';
  Replacements[7][0] := 'irritant';  Replacements[7][1] := 'irrit';
  Replacements[8][0] := 'replacement';  Replacements[8][1] := 'replac';
  Replacements[9][0] := 'adjustment';  Replacements[9][1] := 'adjust';
  Replacements[10][0] := 'dependent';  Replacements[10][1] := 'depend';
  Replacements[11][0] := 'adoption';  Replacements[11][1] := 'adopt';
  Replacements[12][0] := 'homologou';  Replacements[12][1] := 'homolog';
  Replacements[13][0] := 'communism';  Replacements[13][1] := 'commun';
  Replacements[14][0] := 'activate';  Replacements[14][1] := 'activ';
  Replacements[15][0] := 'angulariti';  Replacements[15][1] := 'angular';
  Replacements[16][0] := 'homologous';  Replacements[16][1] := 'homolog';
  Replacements[17][0] := 'effective';  Replacements[17][1] := 'effect';
  Replacements[18][0] := 'bowdlerize';  Replacements[18][1] := 'bowdler';

  Porters := TPortersStemmer.Create;
  try
    for I := 0 to 18 do begin
      Output := Porters.Step4(Replacements[I][0], Successful);
      Check(Output = Replacements[I][1], 'Failed for ' + Replacements[I][0] + ', output was ' + Output);
    end;
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step5A;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step5A('probate', Successful) = 'probat');
    Check(Porters.Step5A('cease', Successful) = 'ceas');
  finally
    Porters.Free;
  end;
end;

procedure TPortersStemmerTest.Step5B;
var
  Porters: TPortersStemmer;
  Successful: Boolean;
begin
  Porters := TPortersStemmer.Create;
  try
    Check(Porters.Step5B('controll', Successful) = 'control');
    Check(Porters.Step5B('roll', Successful) = 'roll');
  finally
    Porters.Free;
  end;
end;

initialization
  RegisterTest('', TPortersStemmerTest.Suite);
end.