/*
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

// @author David Gay

#ifndef OSCILLOSCOPE_H
#define OSCILLOSCOPE_H

enum {
  /* Number of readings per message. If you increase this, you may have to
     increase the message_t size. */
  NREADINGS = 5,

  /* Default sampling period. */
  DEFAULT_INTERVAL = 1024,

  AM_OSCILLOSCOPE = 0x93
};

/*
typedef union
{
    uint32_t u32;
    int32_t s32;
    uint8_t bytes[4];
    struct { uint16_t w1, w0; } u16;
    struct { int16_t w1; U16 w0; } s16;
    struct { uint8_t b3, b2, b1, b0; } u8;
    struct { int16_t hi, lo; } m16;
} M32;

typedef union
{
    uint64_t u64;
    int64_t s64;
    uint8_t bytes[8];
    struct { uint32_t hi, lo; } u32;
    struct { uint32_t hi; U32 lo; } s32;
    struct { uint16_t w3, w2, w1, w0; } u16;
    struct { uint8_t b7, b6, b5, b4, b3, b2, b1, b0; } u8;
    struct { uint32_t hi, lo; } m32;
} M64;

typedef struct
{
    uint32_t X[K_WORDS];
    uint32_t Z[K_WORDS];
} XZ_POINT;
*/
typedef nx_struct public {
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t count; /* The readings are samples count * NREADINGS onwards */
	nx_uint16_t type;
	nx_uint8_t publickey[32];
} public_t;

typedef nx_struct shared {
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t count; /* The readings are samples count * NREADINGS onwards */
	nx_uint16_t type;
	nx_uint8_t sharedkey[32];
} shared_t;

typedef nx_struct sec {
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t count; /* The readings are samples count * NREADINGS onwards */
	nx_uint16_t type;
	nx_uint8_t seckey[32];
} sec_t;

#endif
