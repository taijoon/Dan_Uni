/*
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * Oscilloscope demo application. See README.txt file in this directory.
 *
 * @author David Gay
 */
#include "Timer.h"
#include "Oscilloscope.h"
#define ECP_ADD32(Z,X,Y) c.u64 = (uint64_t)(X) + (Y); Z = c.u32.lo;

module OscilloscopeC @safe()
{
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface AMSend;
    interface Receive;
    interface Timer<TMilli>;
    interface Read<uint16_t>;
    interface Leds;

		interface StdControl as SerialControl;
		interface UartStream;
  }
}
implementation
{
  message_t sendBuf;
  bool sendBusy;

  /* Current local state - interval, version and accumulated readings */
  shared_t local_shared;
  public_t local_public;
  sec_t local;
	norace uint16_t g_type = 0;

  uint8_t reading; /* 0 to NREADINGS */

  /* When we head an Oscilloscope message, we check it's sample count. If
     it's ahead of ours, we "jump" forwards (set our count to the received
     count). However, we must then suppress our next count increment. This
     is a very simple form of "time" synchronization (for an abstract
     notion of time). */
  bool suppressCountChange;

  // Use LEDs to report various status issues.
  void report_problem() { call Leds.led0Toggle(); }
  void report_sent() { call Leds.led2Toggle(); }
	void report_received() {call Leds.led1Toggle();}

  event void Boot.booted() {
    local.id = TOS_NODE_ID;
    call Timer.startPeriodic(2048);
		call SerialControl.start();
    if (call RadioControl.start() != SUCCESS)
      ;
  }

  void startTimer() {
    reading = 0;
  }

  event void RadioControl.startDone(error_t error) {
    startTimer();
  }

  event void RadioControl.stopDone(error_t error) {
  }

  sec_t* recv_key;
	uint8_t key[32];
	uint8_t rf_public[32];
	uint8_t ppp[8] = "public ";
	uint8_t npp[6] = "none ";
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		recv_key =  payload;
		g_type = recv_key->type;
		memcpy(key, recv_key->seckey, 32);
		
		if(g_type == 2){
			call UartStream.send(ppp, 8);
    	report_received();
			memcpy(rf_public, key, 32);
			call UartStream.send(rf_public, 32);
		}
		else{
			call UartStream.send(npp, 6);
			call Leds.led0Toggle();
			call UartStream.send(key, 32);
		}

    return msg;
  }

  /* At each sample period:
     - if local sample buffer is full, send accumulated samples
     - read next sample
  */
	uint8_t sec[32] = "12345678901234567890123456789012";
	uint8_t public[32] = "22222222222222222222222222222222";
	uint8_t shared[32] = "33333333333333333333333333333333";
	uint8_t uu[8] = "Hello\r\n";
  event void Timer.fired() {
			call Leds.led1Toggle();
			call UartStream.send(uu, 8);

			if (!sendBusy && sizeof local <= call AMSend.maxPayloadLength()){
	    // Don't need to check for null because we've already checked length
	    // above
				if(g_type == 1){
					local.type = 1;
					memcpy(local.seckey, sec, 32);
				}
				else if(g_type == 2){
					local.type = 2;
					memcpy(local.seckey, public, 32);
				}
				else if(g_type == 3){
					local.type = 3;
					memcpy(local.seckey, shared, 32);
				}
	    	memcpy(call AMSend.getPayload(&sendBuf, sizeof(local)), &local, sizeof local);
	    	if (call AMSend.send(AM_BROADCAST_ADDR, &sendBuf, sizeof local) == SUCCESS)
	      sendBusy = TRUE;
		  }


			if (!sendBusy)
				;

			reading = 0;
			if (!suppressCountChange)
			  local.count++;
			suppressCountChange = FALSE;

  }

  event void AMSend.sendDone(message_t* msg, error_t error) {
    if (error == SUCCESS)
      report_sent();

    sendBusy = FALSE;
  }

  event void Read.readDone(error_t result, uint16_t data) {
  }

  async event void UartStream.receivedByte( uint8_t byte ) {
		if(byte == '1'){
			g_type = 1;
    	call Timer.startOneShot(100);
		}
		else if(byte == '2'){
			g_type = 2;
    	call Timer.startOneShot(100);
		}
		else if(byte == '3'){
			g_type = 3;
    	call Timer.startOneShot(100);
		}
		else if(byte == '4'){
			g_type = 4;
			call UartStream.send(sec, 32);
		}
		else if(byte == '5'){
			g_type = 5;
			call UartStream.send(public, 32);
		}
		else if(byte == '6'){
			g_type = 6;
			call UartStream.send(shared, 32);
		}

	}
  async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {
	}
  async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
	}

  void ecp_TrimSecretKey(uint8_t *X)
	{
		X[0] &= 0xf8;
		X[31] = (X[31] | 0x40) & 0x7f;
	}

	uint32_t ecp_BytesToWords(uint32_t *Y, uint8_t *X)
	{
/*
    uint8_t i;
    M32 m;
    for (i = 0; i < 8; i++)
    {
        m.u8.b0 = *X++;
        m.u8.b1 = *X++;
        m.u8.b2 = *X++;
        m.u8.b3 = *X++;
        
        Y[i] = m.u32;
    }
*/
    return 0;
	}

	uint32_t ecp_Add(uint32_t* Z, uint32_t* X, uint32_t* Y) 
	{
/*
    M64 c;
    ECP_ADD32(Z[0], X[0], Y[0]);
    ECP_ADC32(Z[1], X[1], Y[1]);
    ECP_ADC32(Z[2], X[2], Y[2]);
    ECP_ADC32(Z[3], X[3], Y[3]);
    ECP_ADC32(Z[4], X[4], Y[4]);
    ECP_ADC32(Z[5], X[5], Y[5]);
    ECP_ADC32(Z[6], X[6], Y[6]);
    ECP_ADC32(Z[7], X[7], Y[7]);
    return c.u32.hi;
*/
    return 0;
	}

	void ecp_PointMultiply(
    uint8_t *PublicKey, 
    uint8_t *BasePoint, 
    uint8_t *SecretKey, 
    uint16_t len)
	{
/*
    int i, j, k;
    uint32_t X[K_WORDS];
    XZ_POINT P, Q, *PP[2], *QP[2];

    ecp_BytesToWords(X, BasePoint);

    while (len-- > 0)
    {
        k = SecretKey[len];
        for (i = 0; i < 8; i++, k <<= 1)
        {
            if (k & 0x80)
            {
                ecp_Add(P.Z, X, edp_custom_blinding.zr);
                ecp_MulReduce(P.X, X, P.Z);
                ecp_MontDouble(&Q, &P);

                PP[1] = &P; PP[0] = &Q;
                QP[1] = &Q; QP[0] = &P;

                while (++i < 8) { k <<= 1; ECP_MONT(7); }
                while (len > 0)
                {
                    k = SecretKey[--len];
                    ECP_MONT(7);
                    ECP_MONT(6);
                    ECP_MONT(5);
                    ECP_MONT(4);
                    ECP_MONT(3);
                    ECP_MONT(2);
                    ECP_MONT(1);
                    ECP_MONT(0);
                }

                ecp_Inverse(Q.Z, P.Z);
                ecp_MulMod(X, P.X, Q.Z);
                ecp_WordsToBytes(PublicKey, X);
                return;
            }
        }
    }
    mem_fill(PublicKey, 0, 32);
*/
	}


  void curve25519_dh_CreateSharedKey(uint8_t *shared, const uint8_t *pk, uint8_t *sk){
    ecp_TrimSecretKey(sk);
    //ecp_PointMultiply(shared, pk, sk, 32);
	}
}
