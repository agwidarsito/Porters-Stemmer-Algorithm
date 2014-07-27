unit Stemming;

interface

{
    Stemming.pas

    This file made by A. Grayson-Widarsito released under GPL v2.
    It's a quick, OOP based implementation of the original
    algorithm as described by Porter.

    Simple instantiate the class and call Porter.Stem('Stem this sentence');

    No guarentee this is free from bugs!
    @date 2014

}



uses SysUtils;

type TPortersException = class (Exception);

type TPortersStemmer = class (TObject)
  const
    Vowels = ['a', 'e', 'i', 'o', 'u'];
  strict private
  public
    function IsVowel(Str: String; Index: Integer): Boolean;
    function M(Str: String; StopIndex: Integer): Integer;
    function EndsIn(Str: String; Char: Char): Boolean;
    function ContainsVowel(Str: String; StopIndex: Integer): Boolean;
    function EndsInDoubleConsonant(Str: String): Boolean;
    function ORule(Str: String): Boolean;
    function EndsInString(Str: String; EndingStr: String): Boolean;
    function ReplaceEnding(Subject, Match, Replacement: String; var ReplacementMade: Boolean): String;

    function Step1A(Str: String): String;

    function Step1B_A(Str: String; var Successful: Boolean): String;
    function Step1B_B(Str: String; var Successful: Boolean): String;
    function Step1B_C(Str: String; var Successful: Boolean): String;
    function Step1B_D(Str: String; var Successful: Boolean): String;
    function Step1B_E(Str: String; var Successful: Boolean): String;
    function Step1B_F(Str: String; var Successful: Boolean): String;
    function Step1B_G(Str: String; var Successful: Boolean): String;
    function Step1B_H(Str: String; var Successful: Boolean): String;

    function Step1B(Str: String; var Successful: Boolean): String;

    function Step1C(Str: String; var Successful: Boolean): String;

    function Step2(Str: String; var Successful: Boolean): String;

    function Step3(Str: String; var Successful: Boolean): String;

    function Step4(Str: String; var Successful: Boolean): String;

    function Step5A(Str: String; var Successful: Boolean): String;
    function Step5B(Str: String; var Successful: Boolean): String;    

    function Stem(Str: String): String;

    constructor Create;
    destructor Destroy; override;
end;

implementation

{ TPortersStemmer }

function TPortersStemmer.ContainsVowel(Str: String; StopIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := StopIndex downto 0 do begin
    if Str[I] in Vowels then begin
      Result := True;
      Break;
    end;
  end;
end;

constructor TPortersStemmer.Create;
begin
;
end;

destructor TPortersStemmer.Destroy;
begin
  inherited;
end;

function TPortersStemmer.EndsIn(Str: String; Char: Char): Boolean;
begin
  Result := Str[Length(Str)] = Char;
end;

function TPortersStemmer.EndsInString(Str, EndingStr: String): Boolean;
var
  S: String;
begin
  if (Length(EndingStr) <= Length(Str)) then begin
    Result := Copy(Str, Length(Str) - Length(EndingStr) + 1, Length(EndingStr)) = EndingStr;
  end;
end;

function TPortersStemmer.EndsInDoubleConsonant(Str: String): Boolean;
begin
  Result := (Length(Str) > 1) and (not(Str[Length(Str)] in Vowels)) and (Str[Length(Str)] = Str[Length(Str)-1]);
end;

function TPortersStemmer.IsVowel(Str: String; Index: Integer): Boolean;
begin
  if not (Index > Length(Str)) then begin
    Result := (Str[Index] in Vowels) or ( (Index <> 1) and (Str[Index] = 'y') and (not (Str[Index-1] in Vowels)) );
  end else
    raise TPortersException.Create('Index out of range; index ' + IntToStr(Index) + ' called on string ' + Str);
end;

function TPortersStemmer.M(Str: String; StopIndex: Integer): Integer;
var
  OldMode: boolean;
  NewMode: boolean;
  I: integer;
begin
  OldMode := True;
  result := 0;
  for I := StopIndex downto 1 do begin
    NewMode := IsVowel(Str, I);
     if (NewMode <> OldMode) and NewMode then begin
       Inc(Result);
     end;
     OldMode := NewMode;
  end;
end;

function TPortersStemmer.ORule(Str: String): Boolean;
var
  First, Middle, Last: Char;
begin
  if Length(Str) >= 3 then begin
    First := Str[Length(Str)-2];
    Middle := Str[Length(Str)-1];
    Last := Str[Length(Str)];
    Result := (not(First in Vowels)) and (Middle in Vowels) and (not(Last in Vowels)) and (not(Last in ['w','x','y']));
  end else
    Result := False;
end;

function TPortersStemmer.ReplaceEnding(Subject, Match,
  Replacement: String; var ReplacementMade: Boolean): String;
begin
  Result := Subject;
  ReplacementMade := False;
  if (Self.EndsInString(Subject, Match)) then begin
    Result := Copy(Subject, 0, Length(Subject) - Length(Match)) + Replacement;
    ReplacementMade := True;
  end;
end;

function TPortersStemmer.Stem(Str: String): String;
var 
  T: String;
  S: Boolean;
begin
  T := Self.Step1A(LowerCase(Str));
  T := Self.Step1B(T, S);  
  T := Self.Step1C(T, S);    
  T := Self.Step2(T, S);
  T := Self.Step3(T, S);
  T := Self.Step4(T, S);
  T := Self.Step5A(T, S);
  T := Self.Step5B(T, S);  

  Result := T;
end;

function TPortersStemmer.Step1A(Str: String): String;
var
  ReplacementMade: Boolean;
begin
  Str := Self.ReplaceEnding(Str, 'sses', 'ss', ReplacementMade);
  if not ReplacementMade then begin
    Str := Self.ReplaceEnding(Str, 'ies', 'i', ReplacementMade);
    if not ReplacementMade then begin
      Str := Self.ReplaceEnding(Str, 'ss', 'ss', ReplacementMade);
      if not ReplacementMade then begin
        Str := Self.ReplaceEnding(Str, 's', '', ReplacementMade);
      end;
    end;
  end;

  Result := Str;
end;

function TPortersStemmer.Step1B(Str: String; var Successful: Boolean): String;
var
  Done, SecondThirdDone: Boolean;
  P: String;
begin
  Result := Self.Step1B_A(Str, Done);
  if not Done then begin

    { Start second and third major steps }
    Result := Self.Step1B_B(Result, SecondThirdDone);
    if not SecondThirdDone then Result := Self.Step1B_C(Result, SecondThirdDone);

    if SecondThirdDone then begin
      Result := Self.Step1B_D(Result, Done);
      if not Done then begin
        Result := Self.Step1B_E(Result, Done);
          if not Done then begin
          Result := Self.Step1B_F(Result, Done);
            if not Done then begin
              Result := Self.Step1B_G(Result, Done);
              if not Done then begin
                Result := Self.Step1B_H(Result, Done);
              end;
            end;
          end;
      end;
    end;
  end;

  Successful := Done;
end;

function TPortersStemmer.Step1B_A(Str: String; var Successful: Boolean): String;
var
  M: Integer;
begin
  Result := Str;
  if (Self.M(Str, Length(Str)-3) > 0) then begin
    Result := Self.ReplaceEnding(Str, 'eed', 'ee', Successful);
  end;
end;

function TPortersStemmer.Step1B_B(Str: String; var Successful: Boolean): String;
begin
  Result := Str;
  if Self.ContainsVowel(Result, Length(Result)-2) then begin
      Result := Self.ReplaceEnding(Str, 'ed', '', Successful);
  end;
end;

function TPortersStemmer.Step1B_C(Str: String; var Successful: Boolean): String;
begin
  Result := Str;
  if Self.ContainsVowel(Result, Length(Result)-3) then begin
      Result := Self.ReplaceEnding(Str, 'ing', '', Successful);
  end;
end;

function TPortersStemmer.Step1B_D(Str: String; var Successful: Boolean): String;
begin
  Result := Str;
  if Self.EndsInString(Result, 'at') then begin
      Result := Self.ReplaceEnding(Str, 'at', 'ate', Successful);
  end;
end;

function TPortersStemmer.Step1B_E(Str: String; var Successful: Boolean): String;
begin
  Result := Str;
  if Self.EndsInString(Result, 'bl') then begin
      Result := Self.ReplaceEnding(Str, 'bl', 'ble', Successful);
  end;
end;

function TPortersStemmer.Step1B_F(Str: String; var Successful: Boolean): String;
begin
  Result := Str;
  if Self.EndsInString(Result, 'iz') then begin
      Result := Self.ReplaceEnding(Str, 'iz', 'ize', Successful);
  end;
end;

function TPortersStemmer.Step1B_G(Str: String; var Successful: Boolean): String;
var
  EndsInLSOrZ: Boolean;
begin
  Result := Str;
  Successful := False;
  EndsInLSOrZ := Self.EndsIn(Str, 'l') or Self.EndsIn(Str, 's') or Self.EndsIn(Str, 'z');
  if (Self.EndsInDoubleConsonant(Str) and not (EndsInLSOrZ)) then begin
      Result := Copy(Result, 0, Length(Result)-1);
      Successful := True;
  end;
end;

function TPortersStemmer.Step1B_H(Str: String; var Successful: Boolean): String;
begin
  Result := Str;

  if (Self.M(Str, Length(Str)) = 1) and  (Self.ORule(Str)) then begin
      Result := Result + 'e';
  end;
end;

function TPortersStemmer.Step1C(Str: String; var Successful: Boolean): String;
begin
  Result := Str;

  Successful := False;
  if (Self.ContainsVowel(Result, Length(Result)-1)) then begin
      Result := Self.ReplaceEnding(Result, 'y', 'i', Successful);
  end;
end;

function TPortersStemmer.Step2(Str: String; var Successful: Boolean): String;
var
  Done: Boolean;
  Replacements: array[0..19] of array[0..1] of String;
  I, M: Integer;
begin
  Replacements[0][0] := 'ational';   Replacements[0][1] := 'ate';
  Replacements[1][0] := 'tional';   Replacements[1][1] := 'tion';
  Replacements[2][0] := 'enci';   Replacements[2][1] := 'ence';
  Replacements[3][0] := 'anci';   Replacements[3][1] := 'ance';
  Replacements[4][0] := 'izer';   Replacements[4][1] := 'ize';
  Replacements[5][0] := 'abli';   Replacements[5][1] := 'able';
  Replacements[6][0] := 'alli';   Replacements[6][1] := 'al';
  Replacements[7][0] := 'entli';   Replacements[7][1] := 'ent';
  Replacements[8][0] := 'eli';   Replacements[8][1] := 'e';
  Replacements[9][0] := 'ousli';   Replacements[9][1] := 'ous';
  Replacements[10][0] := 'ization';   Replacements[10][1] := 'ize';
  Replacements[11][0] := 'ation';   Replacements[11][1] := 'ate';
  Replacements[12][0] := 'ator';   Replacements[12][1] := 'ate';
  Replacements[13][0] := 'alism';   Replacements[13][1] := 'al';
  Replacements[14][0] := 'iveness';   Replacements[14][1] := 'ive';
  Replacements[15][0] := 'fulness';   Replacements[15][1] := 'ful';
  Replacements[16][0] := 'ousness';   Replacements[16][1] := 'ous';
  Replacements[17][0] := 'aliti';   Replacements[17][1] := 'al';
  Replacements[18][0] := 'iviti';   Replacements[18][1] := 'ive';
  Replacements[19][0] := 'biliti';   Replacements[19][1] := 'ble';


  Result := Str;
  Successful := False;

  for I := 0 to 19 do begin
    if (Length(Replacements[I][0]) <= Length(Str)) then begin
      M := Self.M(Result, Length(Str) - Length(Replacements[I][0]) + 1);
      if (M > 0) then begin
        Result := Self.ReplaceEnding(Result, Replacements[I][0], Replacements[I][1], Done);
        if Done then begin
          Successful := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TPortersStemmer.Step4(Str: String; var Successful: Boolean): String;
var
  Done: Boolean;
  Replacements: array [0..10] of String;
  Replacements2: array [0..6] of String;
  I, M: Integer;
  ForthLastChar: Char;
begin
  Replacements[0] := 'al';
  Replacements[1] := 'ance';
  Replacements[2] := 'ence';
  Replacements[3] := 'er';
  Replacements[4] := 'ic';
  Replacements[5] := 'able';
  Replacements[6] := 'ible';
  Replacements[7] := 'ant';
  Replacements[8] := 'ement';
  Replacements[9] := 'ment';
  Replacements[10] := 'ent';

  Replacements2[0] := 'ou';
  Replacements2[1] := 'ism';
  Replacements2[2] := 'ate';
  Replacements2[3] := 'iti';
  Replacements2[4] := 'ous';
  Replacements2[5] := 'ive';
  Replacements2[6] := 'ize';  

  Result := Str;
  Successful := False;

  for I := 0 to 10 do begin
    if (Length(Replacements[I]) <= Length(Str)) then begin
      M := Self.M(Result, Length(Result) - Length(Replacements[I]) + 1);
      if (M > 1) then begin
        Result := Self.ReplaceEnding(Result, Replacements[I], '', Done);
        if Done then begin
          Successful := True;
          Break;
        end;
      end;
    end;
  end;

  if ((not Successful) and (Length(Result) >= 4)) then begin
    M := Self.M(Result, Length(Result) - Length('ion') + 1);
    ForthLastChar := Result[Length(Result) - 3];
    if ((M > 1) and ((ForthLastChar = 's') or (ForthLastChar = 't'))) then begin
      Result := Self.ReplaceEnding(Result, 'ion', '', Successful);
    end;
  end;


  if (not Successful) then begin  
  
    for I := 0 to 6 do begin
      if (Length(Replacements2[I]) <= Length(Str)) then begin
        M := Self.M(Result, Length(Result) - Length(Replacements2[I]) + 1);
        if (M > 1) then begin
          Result := Self.ReplaceEnding(Result, Replacements2[I], '', Done);
          if Done then begin
            Successful := True;
            Break;
          end;
        end;
      end;
    end;
    
  end;
end;

function TPortersStemmer.Step5A(Str: String; var Successful: Boolean): String;
var
  M: Integer;
begin
  Result := Str;

  Successful := False;
  M := Self.M(Result, Length(Result) - Length('e') + 1);
  if (M > 1) then begin
      Result := Self.ReplaceEnding(Result, 'e', '', Successful);
  end;

  if not Successful then begin
    if ((M = 1) and (not Self.ORule(Result))) then begin
      Result := Self.ReplaceEnding(Result, 'e', '', Successful);    
    end;  
  end;
end;

function TPortersStemmer.Step5B(Str: String; var Successful: Boolean): String;
var
  M: Integer;
begin
  Result := Str;

  Successful := False;
  M := Self.M(Result, Length(Result) - Length('e') + 1);
  if ((M > 1) and (Self.EndsInDoubleConsonant(Result)) and (Self.EndsIn(Result, 'l'))) then begin
      Result := Copy(Result, 0, Length(Result)-1);
      Successful := True;
  end;     
end;

function TPortersStemmer.Step3(Str: String; var Successful: Boolean): String;
var
  Done: Boolean;
  Replacements: array[0..6] of array[0..1] of String;
  I, M: Integer;
begin
  Replacements[0][0] := 'icate';   Replacements[0][1] := 'ic';
  Replacements[1][0] := 'ative';   Replacements[1][1] := '';
  Replacements[2][0] := 'alize';   Replacements[2][1] := 'al';
  Replacements[3][0] := 'iciti';   Replacements[3][1] := 'ic';
  Replacements[4][0] := 'ical';   Replacements[4][1] := 'ic';
  Replacements[5][0] := 'ful';   Replacements[5][1] := '';
  Replacements[6][0] := 'ness';   Replacements[6][1] := '';

  Result := Str;
  Successful := False;

  for I := 0 to 6 do begin
    if (Length(Replacements[I][0]) <= Length(Str)) then begin
      M := Self.M(Result, Length(Str) - Length(Replacements[I][0]) + 1);
      if (M > 0) then begin
        Result := Self.ReplaceEnding(Result, Replacements[I][0], Replacements[I][1], Done);
        if Done then begin
          Successful := True;
          Break;
        end;
      end;
    end;
  end;
end;

end.
