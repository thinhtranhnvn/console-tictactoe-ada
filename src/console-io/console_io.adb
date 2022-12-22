
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

package body Console_IO is
   procedure Put_Symbol_Menu is
      -- local
   begin
      Put_Line ("Choose your Symbol ...");
      Put_Line ("   1. Letter 'X'");
      Put_Line ("   2. Letter 'O'");
   end Put_Symbol_Menu;

   procedure Get (User_Symbol : out Symbol) is
      User_Input : String := "9";
      Chosen_Number : Integer;
   begin
      Put ("Your choice: "); Get (User_Input);
      Chosen_Number := Integer'Value (User_Input);
      case Chosen_Number is
         when 1 => User_Symbol := X;
         when 2 => User_Symbol := O;
         when others => raise SYMBOL_CHOICE_ERROR;
      end case;
      Put_Line ("You've chosen: " & Symbol'Image (User_Symbol));
   exception
      when others =>
         Put_Line ("Choice number should be 1 or 2 ...");
         Get (User_Symbol);
      -- end when
   end Get;

   procedure Put_Chess_Board
      ( App_State : in State
      ; User_Symbol : in Symbol ) is
   begin
      Put_Line ("+ - - + - - + - - +  ");
      Put_Line ("|  " & Area_Image (2, App_State, User_Symbol) & "  |  "
                      & Area_Image (9, App_State, User_Symbol) & "  |  "
                      & Area_Image (4, App_State, User_Symbol) & "  |  ");
      Put_Line ("+ - - + - - + - - +  ");
      Put_Line ("|  " & Area_Image (7, App_State, User_Symbol) & "  |  "
                      & Area_Image (5, App_State, User_Symbol) & "  |  "
                      & Area_Image (3, App_State, User_Symbol) & "  |  ");
      Put_Line ("+ - - + - - + - - +  ");
      Put_Line ("|  " & Area_Image (6, App_State, User_Symbol) & "  |  "
                      & Area_Image (1, App_State, User_Symbol) & "  |  "
                      & Area_Image (8, App_State, User_Symbol) & "  |  ");
      Put_Line ("+ - - + - - + - - +  ");
   end Put_Chess_Board;

   procedure Get (User_Move : out Digit; App_State : in State) is
      User_Input : String := "0";
      Chosen_Number : Integer;
   begin
      Put ("Your move: "); Get (User_Input);
      Chosen_Number := Integer'Value (User_Input);
      --
      if Chosen_Number = 0 then
         raise MOVE_CHOICE_ERROR with "Choice number should be in 1 .. 9";
      elsif not Found (Chosen_Number, App_State.Common_Set) then
         raise MOVE_CHOICE_ERROR with "The number has been taken before.";
      else
         User_Move := Chosen_Number;
      end if;
   exception
      when Exc : MOVE_CHOICE_ERROR =>
         Put_Line (Exception_Message (Exc));
         Get (User_Move, App_State);
      when others =>
         Put_Line ("Choice number should be in 1 .. 9 and has not been taken.");
         Get (User_Move, App_State);
   end Get;

   function Area_Image
      ( Area : in Digit
      ; App_State : in State
      ; User_Symbol : in Symbol )
   return String is
      Computer_Symbol : Symbol;
      Result : String := "0";
   begin
      Computer_Symbol := (if User_Symbol = X then O else X);
      --
      if Found (Area, App_State.User_Set) then
         Result := Symbol'Image (User_Symbol);
      elsif Found (Area, App_State.Computer_Set) then
         Result := Symbol'Image (Computer_Symbol);
      else -- Found in App_State.Common_Set
         case Area is
            when 1 => Result := "1";
            when 2 => Result := "2";
            when 3 => Result := "3";
            when 4 => Result := "4";
            when 5 => Result := "5";
            when 6 => Result := "6";
            when 7 => Result := "7";
            when 8 => Result := "8";
            when 9 => Result := "9";
            when others => Result := "0";
         end case;
      end if;
      --
      return Result;
   end Area_Image;
end Console_IO;
