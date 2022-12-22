
package body App_Model is
   procedure Init (App_State : out State) is
      -- local
   begin
      App_State :=
         ( Common_Set => (1, 2, 3, 4, 5, 6, 7, 8, 9)
         , User_Set => (others => 0)
         , Computer_Set => (others => 0)
         , Match_Status => PLAYING )
      ; -- App_State
   end Init;

   procedure Copy
      ( Clone_State : out State
      ; App_State : in State ) is
   begin
      Clone_State.Common_Set (1 .. 9) := App_State.Common_Set;
      Clone_State.User_Set (1 .. 9) := App_State.User_Set;
      Clone_State.Computer_Set (1 .. 9) := App_State.Computer_Set;
      Clone_State.Match_Status := App_State.Match_Status;
   end Copy;

   procedure Update_User_Set
      ( App_State : out State
      ; User_Move : in Digit )
   is -- local
      Index : Integer := User_Move;
   begin
      App_State.Common_Set (Index) := 0;
      App_State.User_Set (Index) := User_Move;
   end Update_User_Set;

   procedure Update_Computer_Set
      ( App_State : out State
      ; Computer_Move : in Digit )
   is -- local
      Index : Integer := Computer_Move;
   begin
      App_State.Common_Set (Index) := 0;
      App_State.Computer_Set (Index) := Computer_Move;
   end Update_Computer_Set;

   procedure Update_Match_Status (App_State : in out State) is
      -- local
   begin
      if Found_Winning (App_State.User_Set) then
         App_State.Match_Status := USER_WIN;
      elsif Found_Winning (App_State.Computer_Set) then
         App_State.Match_Status := COMPUTER_WIN;
      elsif Found_Empty (App_State.Common_Set) then
         App_State.Match_Status := DRAW;
      else
         App_State.Match_Status := PLAYING;
      end if;
   end Update_Match_Status;

   function Areas_Are_Unique (App_State : State)
      return Boolean
   is -- local
      Origin_Set : Digit_Array;
      Area : Digit;
      Found_Duplicated : Boolean;
      Result : Boolean := TRUE;
   begin
      Origin_Set := (1, 2, 3, 4, 5, 6, 7, 8, 9);
      --
      for Index in Origin_Set'Range loop
         Area := Origin_Set (Index);
         Found_Duplicated := (Found (Area, App_State.Common_Set) and Found (Area, App_State.User_Set))
                          or (Found (Area, App_State.Common_Set) and Found (Area, App_State.Computer_Set))
                          or (Found (Area, App_State.User_Set)   and Found (Area, App_State.Computer_Set));
         if Found_Duplicated then
            Result := FALSE;
         end if;
      end loop;
      --
      return Result;
   end Areas_Are_Unique;

   function Sets_Are_Complement (App_State : State)
      return Boolean
   is -- local
      Merged_Set : Digit_Array := (others => 0);
      Area : Digit := 0;
      Result : Boolean := TRUE;
   begin
      --
      for Index in Merged_Set'Range loop
         Area := App_State.Common_Set (Index);
         if Area /= 0 then
            Merged_Set (Index) := Area;
         end if;
         --
         Area := App_State.User_Set (Index);
         if Area /= 0 then
            Merged_Set (Index) := Area;
         end if;
         --
         Area := App_State.Computer_Set (Index);
         if Area /= 0 then
            Merged_Set (Index) := Area;
         end if;
      end loop;
      --
      for Index in Merged_Set'Range loop
         if Merged_Set (Index) = 0 then
            Result := FALSE;
         end if;
      end loop;
      --
      return Result;
   end Sets_Are_Complement;

   function Found
      ( Area : Digit
      ; Move_Set : Digit_Array )
   return Boolean is
      Result : Boolean := FALSE;
   begin
      for Index in Move_Set'Range loop
         if Area = Move_Set (Index) then
            Result := TRUE;
         end if;
      end loop;
      --
      return Result;
   end Found;

   function Found_Winning (Move_Set : Digit_Array)
      return Boolean
   is -- local
      Total : Integer;
      Result : Boolean := FALSE;
   begin
      for I1 in 1 .. 7 loop
         for I2 in 2 .. 8 loop
            for I3 in 3 .. 9 loop
               Total := Move_Set (I1) + Move_Set (I2) + Move_Set (I3);
               if Total = 15
                  and Move_Set (I1) /= 0
                  and Move_Set (I2) /= 0
                  and Move_Set (I3) /= 0
                  and Move_Set (I1) /= Move_Set (I2)
                  and Move_Set (I2) /= Move_Set (I3)
                  and Move_Set (I3) /= Move_Set (I1)
               then
                  Result := TRUE;
               end if;
            end loop;
         end loop;
      end loop;
      --
      return Result;
   end Found_Winning;

   function Found_Empty (Move_Set : Digit_Array)
      return Boolean
   is -- local
      Result : Boolean := TRUE;
   begin
      for Index in Move_Set'Range loop
         if Move_Set (Index) /= 0 then
            Result := FALSE;
         end if;
      end loop;
      --
      return Result;
   end Found_Empty;
end App_Model;
