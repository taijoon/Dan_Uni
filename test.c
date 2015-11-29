#include <stdio.h>
#include <stdlib.h>
#include "../include/external_calls.h"
#include "../source/curve25519_mehdi.h"
#include "../source/BaseTypes.h"
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



void ecp_PrintHexBytes(IN const char *name, IN const U8 *data, IN U32 size)
{
    printf("%s = 0x", name);
    while (size > 0) printf("%02X", data[--size]);
    printf("\n");
}

int dh_test()
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

    //speed_test(1000);

    return rc;
}

