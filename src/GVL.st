VAR_GLOBAL	
	RS232_READ: SEND_RECV_MSG;
	RS232_SEND: SEND_RECV_MSG;
	IX0_0 AT %IX0.0: BOOL;
	DI_LEFT AT %IX0.1: BOOL;
	DI_RIGHT AT %IX0.2: BOOL;
	DI_RESET AT %IX0.3: BOOL;
	ROTATOR_ACTIVE AT %QX0.4: BOOL;
	InArr:ARRAY [1..18] OF BYTE;
	InSET_Pose:ARRAY [1..255] OF BYTE;
	InSET_Speed:ARRAY [1..255] OF BYTE;
	InStrSET_Pose:STRING;
	InStrSET_Speed:STRING;
	InRealSET_Pose:REAL;
	InRealSET_Speed:REAL;
	InBoolSET_Move: BOOL;
	
	RealGET_Pose: REAL;
	StrGET_Pose: STRING;
	OutArr:ARRAY [1..11] OF BYTE;	
	ArrGET_Pose:ARRAY [1..255] OF BYTE;
	
	RS232Read:BOOL;
	RS232Send:BOOL;
	Readed:BOOL;
	Sended:BOOL;
	T0:TON;
	T0_STATE:BOOL;
	T1:TON;
	T1_STATE:BOOL;
	T2:TON;
	T2_STATE:BOOL;
	T3:TON;
	T3_STATE:BOOL;
	T4:TON;
	T4_ActTime:TIME;
	//STOP_Read:BOOL;
	//StopReadTrig:BOOL;
	
	MC_Power_SM1: MC_Power_PTO;
	MC_Home_SM1: MC_Home_PTO;
	MC_MoveVelocity_SM1: MC_MoveVelocity_PTO;
	MC_Stop_SM1: MC_Stop_PTO;
	MC_MoveAbsolute_SM1: MC_MoveAbsolute_PTO;
	MC_MoveRelative_SM1: MC_MoveRelative_PTO;
	MC_ReadActualPosition_SM1: MC_ReadActualPosition_PTO;
	MC_SetPosition_SM1: MC_SetPosition_PTO;	
	SM1_RESOLUTION: REAL; //Кількість імп. на оберт
	SM1_SET_SPEED: REAL; //Фактичне задання швидкості
	SM1_SET_POSE: REAL; //Фактичне задання швидкості
	SM1_SET_MOVE: BOOL; //Фактичне значення старту
	Previous_SET_Pose: REAL; //Відслідковування зміни в позиції
	Previous_SET_Speed: REAL; //Відслідковування зміни в швидкості
	SM1_SET_DIR: MC_DIRECTION; //Фактичне задання напрямку
	SourceGET_Pose: REAL; //Значення MC_ReadActualPosition_SM1
	SM1_ABSOLUTE_START: BOOL; //Старт SM1 в автоматичному режимі
	SM1_STOP: BOOL; //Стоп руху
	RESET_POSE: BOOL; //Ресет позиції
END_VAR

VAR_GLOBAL RETAIN
	
END_VAR     
