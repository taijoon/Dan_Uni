#ifdef TEST_VECTOR
#define MSG_LEN 3
#else
#define MSG_LEN 52
#endif

#define MAX_ROUNDS 2
#include "Oscilloscope.h"

module testECDHM{
  uses{
    interface Boot;
    interface NN;
    interface ECC;
    interface ECDH;
    interface Timer<TMilli> as myTimer;
    interface LocalTime<TMilli>;
    interface Random;
    interface Leds;
    interface AMSend as PubKeyMsg;
    interface AMSend as PriKeyMsg;
    interface AMSend as TimeMsg;
    interface AMSend as SndSecret;
    interface SplitControl as SerialControl;
    interface SplitControl as RadioControl;
    interface Timer<TMilli> as rfTimer;
    interface Timer<TMilli> as runTimer;
    interface AMSend;
    interface Receive;
  }
}

implementation {
  message_t report;
  Point PublicKey1, PublicKey2;
  NN_DIGIT PrivateKey1[NUMWORDS], PrivateKey2[NUMWORDS];
  uint8_t Secret1[KEYDIGITS*NN_DIGIT_LEN], Secret2[KEYDIGITS*NN_DIGIT_LEN];
  uint8_t type;
  uint32_t t;
  uint8_t id;
  int round_index = 1;
  uint8_t recv_cnt = 0;
  sec_t local;

  void init_data();
  void ecdh_init();
  void gen_PrivateKey1();
  void gen_PrivateKey2();
  void gen_PublicKey1();
  void gen_PublicKey2();
  void establish1();
  void establish2();

  void init_data(){
    uint32_t time_a, time_b;
    time_msg *pTime;

    call Leds.led2On();
    type = 0;
    t = 0;

    //init private key
    memset(PrivateKey1, 0, NUMWORDS*NN_DIGIT_LEN);
    memset(PrivateKey2, 0, NUMWORDS*NN_DIGIT_LEN);
    //init public key
    memset(PublicKey1.x, 0, NUMWORDS*NN_DIGIT_LEN);
    memset(PublicKey1.y, 0, NUMWORDS*NN_DIGIT_LEN);
    memset(PublicKey2.x, 0, NUMWORDS*NN_DIGIT_LEN);
    memset(PublicKey2.y, 0, NUMWORDS*NN_DIGIT_LEN);

    time_a = call LocalTime.get();

    call ECDH.init();

    time_b = call LocalTime.get();

    t = time_b - time_a;

    pTime = (time_msg *)report.data;
    pTime->type = 0;
    pTime->t = t;
    pTime->pass = 0;
    call TimeMsg.send(1, &report, sizeof(time_msg));
  }

  void gen_PrivateKey1(){
    private_key_msg *pPrivateKey;

    call ECC.gen_private_key(PrivateKey1);

    id = TOS_NODE_ID;
    //report private key
    pPrivateKey = (private_key_msg *)report.data;
    pPrivateKey->len = KEYDIGITS*NN_DIGIT_LEN;
    pPrivateKey->id = id;
    call NN.Encode(pPrivateKey->d, KEYDIGITS*NN_DIGIT_LEN, PrivateKey1, KEYDIGITS);
    call PriKeyMsg.send(1, &report, sizeof(private_key_msg));
  }

  void gen_PublicKey1(){
    uint32_t time_a, time_b;
    public_key_msg *pPublicKey;

    time_a = call LocalTime.get();

    call ECC.gen_public_key(&PublicKey1, PrivateKey1);

    time_b = call LocalTime.get();

    t = time_b - time_a;

    id = TOS_NODE_ID;
    pPublicKey = (public_key_msg *)report.data;
    pPublicKey->len = KEYDIGITS*NN_DIGIT_LEN;
    pPublicKey->id = id;
    call NN.Encode(pPublicKey->x, KEYDIGITS*NN_DIGIT_LEN, PublicKey1.x, KEYDIGITS);
    call NN.Encode(pPublicKey->y, KEYDIGITS*NN_DIGIT_LEN, PublicKey1.y, KEYDIGITS);
    call PubKeyMsg.send(1, &report, sizeof(public_key_msg));
  }

  void gen_PrivateKey2(){
    private_key_msg *pPrivateKey;
    
    call ECC.gen_private_key(PrivateKey2);      

    id = TOS_NODE_ID + 1;
    //report private key
    pPrivateKey = (private_key_msg *)report.data;
    pPrivateKey->len = KEYDIGITS*NN_DIGIT_LEN;
    pPrivateKey->id = id;
    call NN.Encode(pPrivateKey->d, KEYDIGITS*NN_DIGIT_LEN, PrivateKey2, KEYDIGITS);
    call PriKeyMsg.send(1, &report, sizeof(private_key_msg));
  }

  void gen_PublicKey2(){
    uint32_t time_a, time_b;
    public_key_msg *pPublicKey;


    time_a = call LocalTime.get();

    call ECC.gen_public_key(&PublicKey2, PrivateKey2);

    time_b = call LocalTime.get();

    t = time_b - time_a;

    id = TOS_NODE_ID + 1;
    pPublicKey = (public_key_msg *)report.data;
    pPublicKey->len = KEYDIGITS*NN_DIGIT_LEN;
    pPublicKey->id = id;
    call NN.Encode(pPublicKey->x, KEYDIGITS*NN_DIGIT_LEN, PublicKey2.x, KEYDIGITS);
    call NN.Encode(pPublicKey->y, KEYDIGITS*NN_DIGIT_LEN, PublicKey2.y, KEYDIGITS);
    call PubKeyMsg.send(1, &report, sizeof(public_key_msg));
  }

  void establish1(){
    uint32_t time_a, time_b;
    ecdh_key_msg *pSecret;

    time_a = call LocalTime.get();

    call ECDH.key_agree(Secret1, KEYDIGITS*NN_DIGIT_LEN, &PublicKey2, PrivateKey1);
    
    time_b = call LocalTime.get();

    t = time_b - time_a;

    id = TOS_NODE_ID;
    pSecret = (ecdh_key_msg *)report.data;
    pSecret->len = KEYDIGITS*NN_DIGIT_LEN;
    pSecret->id = id;
    memcpy(pSecret->k, Secret1, KEYDIGITS*NN_DIGIT_LEN);
    call SndSecret.send(1, &report, sizeof(ecdh_key_msg));
    
  }

  void establish2(){
    uint32_t time_a, time_b;
    ecdh_key_msg *pSecret;

    time_a = call LocalTime.get();

    call ECDH.key_agree(Secret2, KEYDIGITS*NN_DIGIT_LEN, &PublicKey1, PrivateKey2);
    
    time_b = call LocalTime.get();

    t = time_b - time_a;

    id = TOS_NODE_ID;
    pSecret = (ecdh_key_msg *)report.data;
    pSecret->len = KEYDIGITS*NN_DIGIT_LEN;
    pSecret->id = id;
    memcpy(pSecret->k, Secret2, KEYDIGITS*NN_DIGIT_LEN);
    call SndSecret.send(1, &report, sizeof(ecdh_key_msg));
  }

  event void Boot.booted(){
    call SerialControl.start();
		call RadioControl.start();
  }

  event void SerialControl.startDone(error_t e) {
    call myTimer.startOneShot(8000);
  }
  
  event void SerialControl.stopDone(error_t e) {
  }
  
  event void myTimer.fired(){
    init_data();
  }

  event void PubKeyMsg.sendDone(message_t* sent, error_t success) {
    time_msg *pTime;

    if (id == TOS_NODE_ID)
      type = 1;
    else
      type = 2;

    pTime = (time_msg *)report.data;
    pTime->type = type;
    pTime->id = id;
    pTime->t = t;
    pTime->pass = 0;
    call TimeMsg.send(1, &report, sizeof(time_msg));
  }

  event void SndSecret.sendDone(message_t* sent, error_t error) {
    time_msg *pTime;

    if (id == TOS_NODE_ID)
//      type = 3;
//    else
      type = 4;

    pTime = (time_msg *)report.data;
    pTime->type = type;
    pTime->id = id;
    pTime->t = t;
    call TimeMsg.send(1, &report, sizeof(time_msg));
  }


  event void PriKeyMsg.sendDone(message_t* sent, error_t error) {
    if (id == TOS_NODE_ID)
      gen_PublicKey1();
//    else
//      gen_PublicKey2();
  }

  event void TimeMsg.sendDone(message_t* sent, error_t error) {
    if (type == 0){
      gen_PrivateKey1(); 
    }else if (type == 1){
      recv_cnt = 1;

      local.id = TOS_NODE_ID;
	  	memcpy(local.p_x_key, PublicKey1.x, KEYDIGITS*NN_DIGIT_LEN);
  		memcpy(local.p_y_key, PublicKey1.y, KEYDIGITS*NN_DIGIT_LEN);

	    call rfTimer.startPeriodic(1024);	// RF를 1초마다 전송
      //call rfTimer.startOneShot(1000);
      
      ;//gen_PrivateKey2();
    }else if (type == 2){
      establish1();
    }else if (type == 3){
      establish2();
    }else if (type == 4){
      if(MAX_ROUNDS == 1)
        recv_cnt = 1;
      else if(round_index < MAX_ROUNDS){
	init_data();
	round_index++;
      } else {
        call Leds.led2Off();;
      }
    }
  }

/* RF 보내는 함수 테스트입니다.
	원하는 위치에 post RFsend(); 라고 넣으면 RF를 보내게 될겁니다.
	Led2Toggle();를 넣어두었기 떄문에 파란불이 깜빡일겁니다.
	보내는 데이터는 local에 설정하면 sendBuf 변수에 옴겨서 RF를 보냅니다.
	*/
	uint16_t msec = 0;
	message_t sendBuf;
	//nx_uint8_t local[50];
  sec_t rf_local;

	void create_share_key(uint8_t* pub, uint8_t* pri, uint8_t* share){
		//call runTimer.startPeriodic();
	}

	task void RFSend() {
    local.count++;
	  memcpy(call AMSend.getPayload(&sendBuf, sizeof(local)), &local, sizeof local);
	 	if (call AMSend.send(AM_BROADCAST_ADDR, &sendBuf, sizeof local) == SUCCESS)
	  	call Leds.led1Toggle();
  }

  event void RadioControl.startDone(error_t error) {
    if ( error == SUCCESS )
      call Leds.led1On();
		//call rfTimer.startPeriodic(1024);	// RF를 1초마다 전송
  }

  event void RadioControl.stopDone(error_t error) {
  }

  event void AMSend.sendDone(message_t* msg, error_t error) {
	}

/* Receive 함수입니다. 수신하는 부분이에요 
	rf로 수신한 데이터는
	memcpy(rf_local, payload, len);으로 데이터를 받아서 확인할수 있습니다.
	직접해보면 금방 할수 있을겁니다.
*/
  
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    public_key_msg *pPublicKey;
    if ( recv_cnt == 1 ) {
      recv_cnt = 2;
      memcpy(&rf_local, payload, sizeof(sec_t));
      id = rf_local.id;
      memcpy(PublicKey2.x, rf_local.p_x_key, KEYDIGITS*NN_DIGIT_LEN);
      memcpy(PublicKey2.y, rf_local.p_y_key, KEYDIGITS*NN_DIGIT_LEN);

      pPublicKey = (public_key_msg *)report.data;
      pPublicKey->len = KEYDIGITS*NN_DIGIT_LEN;
      pPublicKey->id = id;
      call NN.Encode(pPublicKey->x, KEYDIGITS*NN_DIGIT_LEN, PublicKey2.x, KEYDIGITS);
      call NN.Encode(pPublicKey->y, KEYDIGITS*NN_DIGIT_LEN, PublicKey2.y, KEYDIGITS);
      call PubKeyMsg.send(1, &report, sizeof(public_key_msg));
    }
		return msg;
	}

  event void rfTimer.fired(){
	  //call Leds.led1Toggle();
		post RFSend();
	}

	event void runTimer.fired(){
		msec++;
	}
}

