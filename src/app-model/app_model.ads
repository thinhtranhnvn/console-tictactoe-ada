
package App_Model is
   subtype Digit is Integer range 0 .. 9;
   type Digit_Array is array (1 .. 9) of Digit;
   type Status is (PLAYING, DRAW, USER_WIN, COMPUTER_WIN);

   type State is record
      Common_Set : Digit_Array;
      User_Set : Digit_Array;
      Computer_Set : Digit_Array;
      Match_Status : Status;
   end record;

   procedure Init (App_State : out State)
   with Post => Areas_Are_Unique (App_State) and Sets_Are_Complement (App_State);

   procedure Copy (Clone_State : out State; App_State : in State)
   with Post => Areas_Are_Unique (Clone_State) and Sets_Are_Complement (Clone_State);

   procedure Update_User_Set (App_State : out State; User_Move : in Digit)
   with Post => Areas_Are_Unique (App_State) and Sets_Are_Complement (App_State);

   procedure Update_Computer_Set (App_State : out State; Computer_Move : in Digit)
   with Post => Areas_Are_Unique (App_State) and Sets_Are_Complement (App_State);

   procedure Update_Match_Status (App_State : in out State);

   function Areas_Are_Unique (App_State : State)
   return Boolean;

   function Sets_Are_Complement (App_State : State)
   return Boolean;

   function Found (Area : Digit; Move_Set : Digit_Array)
   return Boolean;

   function Found_Winning (Move_Set : Digit_Array)
   return Boolean;

   function Found_Empty (Move_Set : Digit_Array)
   return Boolean;
end App_Model;
