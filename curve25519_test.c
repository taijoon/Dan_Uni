/* The MIT License (MIT)
 * 
 * Copyright (c) 2015 mehdi sotoodeh
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject to 
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included 
 * in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <stdio.h>
#include <stdlib.h>
#include "../include/external_calls.h"
#include "../source/curve25519_mehdi.h"
#include "curve25519_donna.h"
#include "../include/curve25519_dh.h"
#include "../include/ed25519_signature.h"

#ifdef USE_ASM_LIB

/* Defined in ASM library */
U64 readTSC();

#else
#if defined(_MSC_VER)
#include <intrin.h>
U64 readTSC() 
{ 
    return __rdtsc();
}
#else
U64 readTSC()
{
    U64 tsc;
    __asm__ volatile(".byte 0x0f,0x31" : "=A" (tsc));
    return tsc;
}
#endif
#endif

void ecp_PrintBytes(IN const char *name, IN const U8 *data, IN U32 size)
{
    U32 i;
    printf("\nstatic const unsigned char %s[%d] =\n  { 0x%02X", name, size, *data++);
    for (i = 1; i < size; i++)
    {
        if ((i & 15) == 0)
            printf(",\n    0x%02X", *data++);
        else
            printf(",0x%02X", *data++);
    }
    printf(" };\n");
}

void ecp_PrintHexBytes(IN const char *name, IN const U8 *data, IN U32 size)
{
    printf("%s = 0x", name);
    while (size > 0) printf("%02X", data[--size]);
    printf("\n");
}

#ifdef WORDSIZE_64
void ecp_PrintWords(IN const char *name, IN const U64 *data, IN U32 size)
{
    U32 i;
    printf("\nstatic const U64 %s[%d] =\n  { 0x%016llX", name, size, *data++);
    for (i = 1; i < size; i++)
    {
        if ((i & 3) == 0)
            printf(",\n    0x%016llX", *data++);
        else
            printf(",0x%016llX", *data++);
    }
    printf(" };\n");
}

void ecp_PrintHexWords(IN const char *name, IN const U64 *data, IN U32 size)
{
    printf("%s = 0x", name);
    while (size > 0) printf("%016llX", data[--size]);
    printf("\n");
}
#else
void ecp_PrintWords(IN const char *name, IN const U32 *data, IN U32 size)
{
    U32 i;
    printf("\nstatic const U32 %s[%d] = \n  { 0x%08X", name, size, *data++);
    for (i = 1; i < size; i++)
    {
        if ((i & 3) == 0)
            printf(",\n    0x%08X", *data++);
        else
            printf(",0x%08X", *data++);
    }
    printf(" };\n");
}

void ecp_PrintHexWords(IN const char *name, IN const U32 *data, IN U32 size)
{
    printf("%s = 0x", name);
    while (size > 0) printf("%08X", data[--size]);
    printf("\n");
}
#endif

/* Needed for donna */
extern void ecp_TrimSecretKey(U8 *X);
const unsigned char BasePoint[32] = {9};

unsigned char secret_blind[32] =
{
    0xea,0x30,0xb1,0x6d,0x83,0x9e,0xa3,0x1a,0x86,0x34,0x01,0x9d,0x4a,0xf3,0x36,0x93,
    0x6d,0x54,0x2b,0xa1,0x63,0x03,0x93,0x85,0xcc,0x03,0x0a,0x7d,0xe1,0xae,0xa7,0xbb
};

int dh_test() // core code part
{
		int rc = 0;
    unsigned char alice_public_key[32], alice_shared_key[32];
    unsigned char bruce_public_key[32], bruce_shared_key[32];
    unsigned char alice_secret_key[32] = { /* #1234 */
        0x03,0xac,0x67,0x42,0x16,0xf3,0xe1,0x5c,
        0x76,0x1e,0xe1,0xa5,0xe2,0x55,0xf0,0x67,
        0x95,0x36,0x23,0xc8,0xb3,0x88,0xb4,0x45,
        0x9e,0x13,0xf9,0x78,0xd7,0xc8,0x46,0xf5 };

    unsigned char bruce_secret_key[32] = { /* #abcd */
        0x88,0xd4,0x26,0x6f,0xd4,0xe6,0x33,0x8d,
        0x13,0xb8,0x45,0xfc,0xf2,0x89,0x57,0x9d,
        0x20,0x9c,0x89,0x78,0x23,0xb9,0x21,0x7d,
        0xa3,0xe1,0x61,0x93,0x6f,0x03,0x15,0x89 };

    printf("\n-- curve25519 -- key exchange test -----------------------------\n");
    /* Step 1. Alice and Bruce generate their own random secret keys */

    ecp_PrintHexBytes("Alice_secret_key", alice_secret_key, 32);
    ecp_PrintHexBytes("Bruce_secret_key", bruce_secret_key, 32);

    /* Step 2. Alice and Bruce create public keys associated with their secret keys */
    /*         and exchange their public keys */

    curve25519_dh_CalculatePublicKey(alice_public_key, alice_secret_key);
    curve25519_dh_CalculatePublicKey(bruce_public_key, bruce_secret_key);
    ecp_PrintHexBytes("Alice_public_key", alice_public_key, 32);
    ecp_PrintHexBytes("Bruce_public_key", bruce_public_key, 32);

    /* Step 3. Alice and Bruce create their shared key */

    curve25519_dh_CreateSharedKey(alice_shared_key, bruce_public_key, alice_secret_key);
    curve25519_dh_CreateSharedKey(bruce_shared_key, alice_public_key, bruce_secret_key);
    ecp_PrintHexBytes("Alice_shared", alice_shared_key, 32);
		//rc = alice_shared_key;
    ecp_PrintHexBytes("Bruce_shared", bruce_shared_key, 32);
 	    /* Alice and Bruce should end up with idetntical keys */
    if (memcmp(alice_shared_key, bruce_shared_key, 32) != 0)
    {
        rc++;
        printf("DH key exchange FAILED!!\n");
    }
    return rc;
}

int main(int argc, char**argv)
{
    int rc = 0;
    //unsigned char result[32];
#ifdef ECP_SELF_TEST
    if (curve25519_SelfTest(0))
    {
        printf("\n*********** curve25519 selftest FAILED!! ******************\n");
        return 1;
    }
    if (ed25519_selftest())
    {
        printf("\n*********** ed25519 selftest FAILED!! ********************\n");
        return 1;
    }
#endif

   rc += dh_test();

    //rc += signature_test(sk1, pk1, msg1, sizeof(msg1), msg1_sig);

    //speed_test(1000);
//	 ecp_PrintHexBytes("alice_key", result ,32);

    return rc;
}
