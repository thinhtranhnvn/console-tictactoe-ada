
with App_Model; use App_Model;

package AI_Mockup is
   procedure Get (Computer_Move : out Digit; App_State : in State);

   procedure Get_Prioritized (Computer_Move : out Digit; App_State : in State);

   procedure Block_Direct_Winning (Computer_Move : in out Digit; App_State : in State);

   procedure Block_Double_Threat (Computer_Move : in out Digit; App_State : in State);

   procedure Redirect_User_Concern (Computer_Move : in out Digit; App_State : in State);

   procedure Get_Double_Threats (User_Moves : in out Digit_Array; App_State : in State);

   procedure Get_Direct_Chance_Inits (Computer_Moves : in out Digit_Array; App_State : in State);

   procedure Get_Direct_Chance (Computer_Move : in out Digit; App_State : in State);

   function Count_Direct_Threats (App_State : State)
   return Integer;

   function Count_Double_Threats (App_State : State)
   return Integer;

   function Count_Direct_Chances (App_State : State)
   return Integer;
end AI_Mockup;
