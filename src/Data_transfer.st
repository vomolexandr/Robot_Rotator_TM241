VAR
	I: INT;
	FB_6: SE_TBX.FB_Scaling;
	FB_5: SE_TBX.FB_Scaling;
	FB_4: SE_TBX.FB_Scaling;
	FB_3: SE_TBX.FB_Scaling;
	FB_2: SE_TBX.FB_Scaling;
	FB_1: SE_TBX.FB_Scaling;
	FB_0: SE_TBX.FB_Scaling;;
END_VAR

	RS232Send:= FALSE;
	RS232Read:= TRUE; 
	SndRecvRS232(); 
	RS232Read:= FALSE; 
	SndRecvRS232();

		//Reading data
		IF 	InArr[1] = 83 AND InArr[18] = 70 THEN //Умова задання даних
			FOR I:= 1 TO 9 BY 1 DO
				InSET_Pose[I]:= InArr[I+1];
			END_FOR
			FOR I:= 1 TO 6 BY 1 DO
				InSET_Speed[I]:= InArr[I+10];
			END_FOR
			InStrSET_Pose:= ArrayOfByte_TO_String(i_abyIput:= InSET_Pose, i_xOrdr:= TRUE , i_xSpce:=  FALSE);
			InStrSET_Speed:= ArrayOfByte_TO_String(i_abyIput:= InSET_Speed, i_xOrdr:= TRUE , i_xSpce:=  FALSE);
			InRealSET_Pose:= STRING_TO_REAL(InStrSET_Pose); //Set Pose
			InRealSET_Speed:= STRING_TO_REAL(InStrSET_Speed); //Set Speed
			IF InArr[17] = 49 THEN InBoolSET_Move:= TRUE; ELSE InBoolSET_Move:= FALSE; END_IF 
		END_IF
		//Reading data
		
		IF RESET_POSE THEN InArr[17]:= 48; InBoolSET_Move:= FALSE; END_IF //Reset move from button
		
		//Reset speed from button
		IF RESET_POSE THEN 
			FOR I:= 1 TO 6 BY 1 DO
				InArr[11]:= 48; InArr[12]:= 49; InArr[13]:= 48; InArr[14]:= 46; InArr[15]:= 48; InArr[16]:= 48;
				InSET_Speed[I]:= InArr[I+10];
			END_FOR
			InStrSET_Speed:= ArrayOfByte_TO_String(i_abyIput:= InSET_Speed, i_xOrdr:= TRUE , i_xSpce:=  FALSE);
			InRealSET_Speed:= STRING_TO_REAL(InStrSET_Speed); //Set Speed
		END_IF
		//Reset speed from button
		
		//Sending data calculation
		OutArr[1]:= 83;
		RealGET_Pose:= SourceGET_Pose / SM1_RESOLUTION;
		StrGET_Pose:= REAL_TO_STRING(RealGET_Pose);
		ArrGET_Pose:= String_TO_ArrayOfByte(i_sIput:= StrGET_Pose,i_xOrdr:= TRUE);
		FOR I:= 1 TO 9 BY 1 DO
			OutArr[I+1]:= ArrGET_Pose[I];
			IF OutArr[I+1] = 0 THEN OutArr[I+1]:= 48; END_IF
		END_FOR;
		OutArr[11]:= 70;
		//Sending data calculation
		
		//Sending data
		IF InArr[1] = 82 AND InArr[18] = 80 THEN //Умова відправки даних (поточна позиція)
			RS232Read:= FALSE;
			RS232Send:= TRUE;
			SndRecvRS232();
			RS232Send:= FALSE;
			SndRecvRS232();
		END_IF
		//Sending data
