{License, info, etc
 ------------------

This implementation is made by me, Walied Othman, to contact me
mail to Walied.Othman@belgacom.net or Triade@ulyssis.org,
always mention wether it 's about the FGInt for Delphi or for
FreePascal, or wether it 's about the 6xs, preferably in the subject line.
If you 're going to use these implementations, at least mention my
name or something and notify me so I may even put a link on my page.
This implementation is freeware and according to the coderpunks'
manifesto it should remain so, so don 't use these implementations
in commercial software.  Encryption, as a tool to ensure privacy
should be free and accessible for anyone.  If you plan to use these
implementations in a commercial application, contact me before
doing so, that way you can license the software to use it in commercial
Software.  If any algorithm is patented in your country, you should
acquire a license before using this software.  Modified versions of this
software must contain an acknowledgement of the original author (=me).
This implementation is available at
http://triade.studentenweb.org

copyright 2000, Walied Othman
This header may not be removed.
}

Unit ECElGamal;

{$H+}

Interface

Uses FGInt, ECGFp, math;

Procedure ECElGamalEncrypt(M : String; P, a, b, k : TFGInt; g, y : TECPoint; Compression : boolean; Var E : String);
Procedure ECElGamalDecrypt(E : String; P, a, b, x : TFGInt; Var D : String);

Implementation


// Encrypt a string M using ECElGamal defined on an elliptic curve
// y^2 = x^3 + a*x + b over GF(p), where 4*a^3 + 27*b^2 mod p doesn 't
// equal zero, g is the base point on the curve and y = x * g
// If you want the output to be compressed, set the parameter Compressed to
// true and false else.  The output is a string E

Procedure ECElGamalEncrypt(M : String; P, a, b, k : TFGInt; g, y : TECPoint; Compression : boolean; Var E : String);
Var
   t, c : longint;
   temp, temp1, temp2 : String;
   ok : boolean;
   ECtemp1, ECtemp2, ECtemp3, ECtemp4 : TECPoint;
   FGtemp, k1, kt : TFGInt;
Begin
   FGIntToBase256String(P, temp);
   t := length(temp) - 3;
   temp := M;
   E := '';
   FGIntCopy(k, k1);
   FGIntRandom1(k1, kt);
   While temp <> '' Do
   Begin
      c := 0;
      ok := false;
      While Not ok Do
      Begin
         temp1 := copy(temp, 1, min((t - c), length(temp)));
         ECInbedStringOnEC(temp1, p, a, b, ECtemp1, ok);
         If ok Then break;
         ECPointDestroy(ECtemp1);
         c := c + 1;
      End;
      delete(temp, 1, min((t - c), length(temp)));
      ECPointkMultiple(y, P, a, k1, ECtemp2);
      ECPointkMultiple(g, P, a, k1, ECtemp3);
      ECAddPoints(ECtemp1, ECtemp2, P, a, ECtemp4);
      ECPointDestroy(ECtemp2);
      ECPointDestroy(ECtemp1);
      ECPointToECPointString(ECtemp4, P, Compression, temp1);
      ECPointToECPointString(ECtemp3, P, Compression, temp2);
      E := E + temp1 + temp2;
      ECPointDestroy(ECtemp3);
      ECPointDestroy(ECtemp4);
      If temp <> '' Then
      Begin
         FGIntRandom1(kt, FGtemp);
         FGIntDestroy(kt);
         FGIntCopy(FGtemp, kt);
         FGIntDestroy(FGtemp);
         FGIntMontgomeryModExp(k1, kt, p, FGtemp);
         FGIntDestroy(k1);
         FGIntCopy(FGtemp, k1);
         FGIntDestroy(FGtemp);
      End;
   End;
   FGIntDestroy(k1);
   FGIntDestroy(kt);
End;

// Decrypt a string E using ECElGamal defined on an elliptic curve
// y^2 = x^3 + a*x + b over GF(p), where 4*a^3 + 27*b^2 mod p doesn 't
// equal zero, x is your private parameter as defined above
// The output is a string D

Procedure ECElGamalDecrypt(E : String; P, a, b, x : TFGInt; Var D : String);
Var
   t, i : longint;
   temp, temp1 : String;
   ECtemp1, ECtemp2, ECtemp3, ECtemp4 : TECPoint;
Begin
   FGIntToBase256String(P, temp);
   t := length(temp);
   temp := E;
   D := '';
   i := length(temp);
   While temp <> '' Do
   Begin
      If temp[1] = chr(0) Then i := 1;
      If temp[1] = chr(4) Then i := 2 * t + 1;
      If (temp[1] = chr(2)) Or (temp[1] = chr(3)) Then i := t + 1;
      temp1 := copy(temp, 1, i);
      delete(temp, 1, i);
      ECPointStringToECPoint(temp1, p, a, b, ECtemp1);
      If temp[1] = chr(0) Then i := 1;
      If temp[1] = chr(4) Then i := 2 * t + 1;
      If (temp[1] = chr(2)) Or (temp[1] = chr(3)) Then i := t + 1;
      temp1 := copy(temp, 1, i);
      delete(temp, 1, i);
      ECPointStringToECPoint(temp1, p, a, b, ECtemp2);

      ECPointkMultiple(ECtemp2, P, a, x, ECtemp3);
      ECPointDestroy(ECtemp2);
      ECPointInverse(ECtemp3, P, ECtemp2);
      ECAddPoints(ECtemp1, ECtemp2, P, a, ECtemp4);
      ECPointDestroy(ECtemp2);
      ECPointDestroy(ECtemp1);
      ECExtractInbeddedString(ECtemp4, temp1);
      D := D + temp1;
      ECPointDestroy(ECtemp3);
      ECPointDestroy(ECtemp4);
   End;
End;

End.
