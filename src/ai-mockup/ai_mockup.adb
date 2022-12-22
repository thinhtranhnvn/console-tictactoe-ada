
with Ada.Text_IO; use Ada.Text_IO;

package body AI_Mockup is
   procedure Get
      ( Computer_Move : out Digit
      ; App_State : in State ) is
   begin
      Get_Prioritized (Computer_Move, App_State);
      Block_Double_Threat (Computer_Move, App_State);
      Redirect_User_Concern (Computer_Move, App_State);
      Block_Direct_Winning (Computer_Move, App_State);
      --
      Put_Line ("Computer move:" & Digit'Image (Computer_Move));
   end Get;

   procedure Get_Prioritized
      ( Computer_Move : out Digit
      ; App_State : in State )
   is -- local
      Prioritized_Set : Digit_Array;
      Area : Digit;
   begin
      Prioritized_Set := (5, 2, 4, 6, 8, 1, 3, 7, 9);
      --
      for Index in Prioritized_Set'Range loop
         Area := Prioritized_Set (Index);
         if Found (Area, App_State.Common_Set) then
            Computer_Move := Area;
            exit;
         end if;
      end loop;
   end Get_Prioritized;

   procedure Block_Direct_Winning
      ( Computer_Move : in out Digit
      ; App_State : in State )
   is -- local
      Foreseen_User_Set : Digit_Array;
   begin
      for Index in App_State.Common_Set'Range loop
         Foreseen_User_Set (1 .. 9) := App_State.User_Set;
         Foreseen_User_Set (Index) := App_State.Common_Set (Index);
         if Found_Winning (Foreseen_User_Set) then
            Computer_Move := App_State.Common_Set (Index);
         end if;
      end loop;
   end Block_Direct_Winning;

   procedure Block_Double_Threat
      ( Computer_Move : in out Digit
      ; App_State : in State )
   is -- local
      Foreseen_App_State : State;
      Foreseen_User_Move : Digit;
   begin
      for Index in App_State.Common_Set'Range loop
         Foreseen_User_Move := App_State.Common_Set (Index);
         if Foreseen_User_Move /= 0 then
            Copy (Foreseen_App_State, App_State);
            Update_User_Set (Foreseen_App_State, Foreseen_User_Move);
            --
            if Count_Direct_Threats (Foreseen_App_State) > 1 then
               Computer_Move := Foreseen_User_Move;
            end if;
         end if;
      end loop;
   end Block_Double_Threat;

   procedure Redirect_User_Concern
      ( Computer_Move : in out Digit
      ; App_State : in State )
   is -- local
      Foreseen_User_Moves : Digit_Array;
      --
      Foreseen_Computer_Moves : Digit_Array;
      Foreseen_App_State : State;
      Computer_After_Next_Move: Digit := 0;
   begin
      if Count_Double_Threats (App_State) > 1 then
         Put_Line ("Double_Threats : " & Integer'Image (Count_Double_Threats (App_State)));
         --
         Foreseen_User_Moves := (others => 0);
         Get_Double_Threats (Foreseen_User_Moves, App_State);
         Put_Line ("Foreseen_User_Moves : " & Digit_Array'Image (Foreseen_User_Moves));
         --
         Foreseen_Computer_Moves := (others => 0);
         Get_Direct_Chance_Inits (Foreseen_Computer_Moves, App_State);
         Put_Line ("Foreseen_Computer_Moves : " & Digit_Array'Image (Foreseen_Computer_Moves));
         --
         for Index in Foreseen_Computer_Moves'Range loop
            if Foreseen_Computer_Moves (Index) /= 0 then
               Copy (Foreseen_App_State, App_State);
               Update_Computer_Set (Foreseen_App_State, Foreseen_Computer_Moves (Index));
               Get_Direct_Chance (Computer_After_Next_Move, Foreseen_App_State);
               --
               if not Found (Computer_After_Next_Move, Foreseen_User_Moves) then
                  Computer_Move := Foreseen_Computer_Moves (Index);
               end if;
            end if;
         end loop;
      end if;
   end Redirect_User_Concern;

   procedure Get_Double_Threats
      ( User_Moves : in out Digit_Array
      ; App_State : in State )
   is -- local
      Foreseen_Move : Digit := 0;
      Foreseen_App_State : State;
   begin
      for Index in App_State.Common_Set'Range loop
         if App_State.Common_Set (Index) /= 0 then
            Foreseen_Move := App_State.Common_Set (Index);
            Copy (Foreseen_App_State, App_State);
            Update_User_Set (Foreseen_App_State, Foreseen_Move);
            --
            if Count_Direct_Threats (Foreseen_App_State) > 1 then
               User_Moves (Index) := Foreseen_Move;
            end if;
         end if;
      end loop;
   end Get_Double_Threats;

   procedure Get_Direct_Chance_Inits
      ( Computer_Moves : in out Digit_Array
      ; App_State : in State )
   is -- local
      Foreseen_Move : Digit := 0;
      Foreseen_App_State : State;
   begin
      for Index in App_State.Common_Set'Range loop
         if App_State.Common_Set (Index) /= 0 then
            Foreseen_Move := App_State.Common_Set (Index);
            Copy (Foreseen_App_State, App_State);
            Update_Computer_Set (Foreseen_App_State, Foreseen_Move);
            --
            if Count_Direct_Chances (Foreseen_App_State) > 0 then
               Computer_Moves (Index) := Foreseen_Move;
            end if;
         end if;
      end loop;
   end Get_Direct_Chance_Inits;

   procedure Get_Direct_Chance
      ( Computer_Move : in out Digit 
      ; App_State : in State )
   is -- local
      Foreseen_Move : Digit := 0;
      Foreseen_App_State : State;
   begin
      for Index in App_State.Common_Set'Range loop
         if App_State.Common_Set (Index) /= 0 then
            Foreseen_Move := App_State.Common_Set (Index);
            Copy (Foreseen_App_State, App_State);
            Update_Computer_Set (Foreseen_App_State, Foreseen_Move);
            --
            if Found_Winning (Foreseen_App_State.Computer_Set) then
               Computer_Move := Foreseen_Move;
            end if;
         end if;
      end loop;
   end Get_Direct_Chance;

   function Count_Direct_Threats (App_State : State)
      return Integer
   is -- local
      Foreseen_User_Set : Digit_Array;
      Counter : Integer := 0;
   begin
      for Index in App_State.Common_Set'Range loop
         if App_State.Common_Set (Index) /= 0 then
            Foreseen_User_Set (1 .. 9) := App_State.User_Set;
            Foreseen_User_Set (Index) := App_State.Common_Set (Index);
            --
            if Found_Winning (Foreseen_User_Set) then
               Counter := Counter + 1;
            end if;
         end if;
      end loop;
      --
      return Counter;
   end Count_Direct_Threats;

   function Count_Double_Threats (App_State : State)
      return Integer
   is -- local
      Foreseen_User_Move : Digit := 0;
      Foreseen_App_State : State;
      Counter : Integer := 0;
   begin
      for Index in App_State.Common_Set'Range loop
         if App_State.Common_Set (Index) /= 0 then
            Copy (Foreseen_App_State, App_State);
            Foreseen_User_Move := App_State.Common_Set (Index);
            Update_User_Set (Foreseen_App_State, Foreseen_User_Move);
            --
            if Count_Direct_Threats (Foreseen_App_State) > 1 then
               Counter := Counter + 1;
            end if;
         end if;
      end loop;
      --
      return Counter;
   end Count_Double_Threats;

   function Count_Direct_Chances (App_State : State)
      return Integer
   is -- local
      Foreseen_Computer_Move : Digit := 0;
      Foreseen_App_State : State;
      Counter : Integer := 0;
   begin
      for Index in App_State.Common_Set'Range loop
         if App_State.Common_Set (Index) /= 0 then
            Foreseen_Computer_Move := App_State.Common_Set (Index);
            Copy (Foreseen_App_State, App_State);
            Update_Computer_Set (Foreseen_App_State, Foreseen_Computer_Move);
            --
            if Found_Winning (Foreseen_App_State.Computer_Set) then
               Counter := Counter + 1;
            end if;
         end if;
      end loop;
      --
      return Counter;
   end Count_Direct_Chances;
end AI_Mockup;
