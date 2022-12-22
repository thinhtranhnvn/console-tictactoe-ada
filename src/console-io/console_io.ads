
with App_Model; use App_Model;

package Console_IO is
   type Symbol is (X, O);

   SYMBOL_CHOICE_ERROR : exception;
   MOVE_CHOICE_ERROR : exception;
   
   procedure Put_Symbol_Menu;
   procedure Get (User_Symbol : out Symbol);

   procedure Put_Chess_Board
      ( App_State : in State
      ; User_Symbol : in Symbol )
   ; -- return Nothing

   procedure Get (User_Move : out Digit; App_State : State);

   function Area_Image
      ( Area : in Digit
      ; App_State : in State
      ; User_Symbol : in Symbol )
   return String;
end Console_IO;
