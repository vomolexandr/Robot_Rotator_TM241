VAR
	RESET_POSE_TON: TON;
	MC_POWER_DELAY: TON;
	INIT_TRIG: BOOL;
	SM1_START_TRIG: F_TRIG;
	SM1_STOP_RIGHT: F_TRIG;
	SM1_STOP_AUTO: F_TRIG;
	SM1_STOP_LEFT: F_TRIG;
	T1_START: TON;
	SET_MOVE_TRIG: R_TRIG;
	FIRST_MOTOR_ENA: R_TRIG;
	FIRST_MOTOR_ENA_DONE: BOOL;
	TON_RESET_POS: TON;
	SM1_DIRECTION: MC_DIRECTION;
	FIRST_START: BOOL ;
END_VAR

MC_POWER_DELAY(IN:=NOT INIT_TRIG , PT:=T#100MS , Q=> , ET=> ); //Затримка ініціалізації
IF MC_POWER_DELAY.Q THEN INIT_TRIG:=TRUE; END_IF; //Затримка ініціалізації
IF MC_POWER_SM1.Error THEN INIT_TRIG:=FALSE; END_IF; //Ресет при виникненні помилки

IF (NOT FIRST_START AND INIT_TRIG) OR DI_RESET THEN FIRST_START:= TRUE; RESET_POSE:= TRUE; END_IF //Ресет позиції
RESET_POSE_TON(IN:=RESET_POSE , PT:=T#100MS); //Затримка на скидання тригеру ресету позиції
IF RESET_POSE_TON.Q THEN RESET_POSE:= FALSE; END_IF //Скидання тригеру ресету позиції

SM1_SET_POSE:= InRealSET_Pose; //Задання позиції
IF (DI_LEFT OR DI_RIGHT) AND InRealSET_Speed = 0 THEN SM1_SET_SPEED:= 10; ELSE SM1_SET_SPEED:= InRealSET_Speed; END_IF //Логіка задання швидкості
IF DI_LEFT THEN SM1_SET_DIR:= -1; ELSIF DI_RIGHT THEN SM1_SET_DIR:= 1; END_IF //Логіка задання напрямку

SM1_SET_MOVE:= InBoolSET_Move; //Задання старту/стопу
SET_MOVE_TRIG(CLK:= InBoolSET_Move); //Для старту після зупинки, якщо не змінювалась швидкість і позиція
IF ((SM1_SET_POSE <> Previous_SET_Pose OR SM1_SET_SPEED <> Previous_SET_Speed) AND NOT (DI_LEFT OR DI_RIGHT) AND SM1_SET_MOVE) OR SET_MOVE_TRIG.Q THEN //Старт автомат
SM1_ABSOLUTE_START:= TRUE; Previous_SET_Pose:= SM1_SET_POSE; Previous_SET_Speed:= SM1_SET_SPEED; ELSE SM1_ABSOLUTE_START:= FALSE; END_IF //Старт автомат

SM1_STOP_LEFT(CLK:= DI_LEFT); //Тригер стопу в ручному режимі
SM1_STOP_RIGHT(CLK:= DI_RIGHT); //Тригер стопу в ручному режимі
SM1_STOP_AUTO(CLK:= InBoolSET_Move); //Тригер стопу в автоматичному режимі
IF SM1_STOP_LEFT.Q OR SM1_STOP_RIGHT.Q OR SM1_STOP_AUTO.Q THEN SM1_STOP:= TRUE; END_IF //Стоп руху автомат по тригеру
IF MC_Stop_SM1.Done THEN SM1_STOP:=  FALSE; END_IF //Стоп руху

MC_Power_SM1(
	Axis:=SM1 , 
	Enable:=INIT_TRIG , 
	DriveReady:=TRUE , 
	LimP:=TRUE , 
	LimN:=TRUE , 
	Status=> , 
	DriveEnable=> , 
	Error=> , 
	ErrorId=> );

//РУХ В АВТОМАТІ ПО АБСОЛЮТНИХ ПОЗИЦІЯХ	
MC_MoveAbsolute_SM1(
	Axis:=SM1 , 
	Execute:= SM1_ABSOLUTE_START, 
	Position:= REAL_TO_DINT(SM1_SET_POSE * SM1_RESOLUTION), 
	Velocity:= REAL_TO_DINT(SM1_SET_SPEED * SM1_RESOLUTION), 
	Acceleration:= 200, 
	Deceleration:= 200, 
	BufferMode:= , 
	Done=> , 
	Busy=> , 
	Active=> , 
	CommandAborted=> , 
	Error=> , 
	ErrorId=> , 
	JerkRatio:= );
//РУХ В АВТОМАТІ ПО АБСОЛЮТНИХ ПОЗИЦІЯХ	

IF NOT MC_MoveAbsolute_SM1.Busy AND NOT MC_MoveAbsolute_SM1.Active THEN ROTATOR_ACTIVE:=FALSE; ELSE ROTATOR_ACTIVE:=TRUE; END_IF //Фізичний вихід для слідкування зайнятості двигуна

//РУХ В РУЧНОМУ
MC_MoveVelocity_SM1(
	Axis:=SM1 , 
	Execute:= (DI_LEFT OR DI_RIGHT) AND NOT ROTATOR_ACTIVE, 
	ContinuousUpdate:= TRUE, 
	Velocity:= REAL_TO_DINT(SM1_SET_SPEED * SM1_RESOLUTION),
	Acceleration:= 200, 
	Deceleration:= 200, 
	Direction:= SM1_SET_DIR, 
	BufferMode:= , 
	InVelocity=> , 
	Busy=> , 
	Active=> , 
	CommandAborted=> , 
	Error=> , 
	ErrorId=> , 
	JerkRatio:= );
//РУХ В РУЧНОМУ
	
MC_ReadActualPosition_SM1(
	Axis:=SM1 , 
	Enable:=TRUE , 
	Valid=> , 
	Error=> , 
	ErrorId=> ,
	Position=> );
	
SourceGET_Pose:= DINT_TO_REAL(MC_ReadActualPosition_SM1.Position); //Читання поточної позиції

MC_SetPosition_SM1(
	Axis:=SM1 , 
	Execute:= RESET_POSE,
	Position:= 0, 
	Done=> , 
	Error=> , 
	ErrorId=> );
	
MC_Stop_SM1(
	Axis:=SM1 , 
	Execute:= SM1_STOP,
	Deceleration:= , 
	Done=>, 
	Busy=> , 
	CommandAborted=> , 
	Error=> , 
	ErrorId=> , 
	JerkRatio:= );
	
{MC_Home_SM1(
	Axis:=SM1 , 
	Execute:= , 
	Mode:= , 
	Position:= , 
	Direction:= , 
	HighVelocity:= , 
	LowVelocity:= , 
	Acceleration:= , 
	Deceleration:= , 
	Offset:= , 
	Done=> , 
	Busy=> , 
	Active=> , 
	CommandAborted=> , 
	Error=> , 
	ErrorId=> , 
	JerkRatio:= );
	
MC_MoveRelative_SM1(
	Axis:=SM1 , 
	Execute:= , 
	Distance:= ,
	Velocity:= ,
	Acceleration:= , 
	Deceleration:= , 
	BufferMode:= , 
	Done=> , 
	Busy=> , 
	Active=> , 
	CommandAborted=> , 
	Error=> , 
	ErrorId=> , 
	JerkRatio:= );}	
