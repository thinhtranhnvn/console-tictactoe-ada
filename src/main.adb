
with Ada.Text_IO; use Ada.Text_IO;
with App_Model; use App_Model;
with Console_IO; use Console_IO;
with AI_Mockup; use AI_Mockup;

procedure Main is
   User_Symbol : Symbol;
   App_State : State;
   User_Move : Digit;
   Computer_Move : Digit;
begin
   Put_Symbol_Menu;
   Get (User_Symbol);

   Init (App_State);
   Put_Chess_Board (App_State, User_Symbol);

   loop
      Console_IO.Get (User_Move, App_State);
      Update_User_Set (App_State, User_Move);
      Update_Match_Status (App_State);
      Put_Line (Status'Image (App_State.Match_Status) & " ...");
      Put_Chess_Board (App_State, User_Symbol);
      --
      if App_State.Match_Status /= PLAYING then exit; end if;
      --
      AI_Mockup.Get (Computer_Move, App_State);
      Update_Computer_Set (App_State, Computer_Move);
      Update_Match_Status (App_State);
      Put_Line (Status'Image (App_State.Match_Status) & " ...");
      Put_Chess_Board (App_State, User_Symbol);
      --
      if App_State.Match_Status /= PLAYING then exit; end if;
   end loop;
end Main;
