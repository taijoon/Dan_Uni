#include "curve25519_mehdi.h"

EDP_BLINDING_CTX edp_custom_blinding = 
{
  W256(0x9665F548,0x42851DAA,0xB7CB22D6,0xB4C81DC8,0x7BE4DCB1,0xE4746972,0x8E331949,0x03FA52A8),
  W256(0xDCB347F2,0x0A397639,0x7095EF5C,0x50A8DF4D,0xD5206C64,0xF9ECA797,0xAB7268D2,0xA6630303),
  {
    W256(0x54D4331A,0x7396A245,0x141946BF,0x14CC9A2C,0xF0B639F2,0xAB7D062F,0xB89EBB6D,0x55B91D18),
    W256(0x5B271052,0xDFB0FC5A,0xA49211A2,0xB7F56D09,0x0E2FA2CD,0x431ABBDA,0x93D9CBE4,0x62780EDE),
    W256(0x6D0E0818,0xF0E40A32,0xEFCD8B16,0xCB69086F,0xA6F96AD2,0x215BDC58,0x3DF31704,0xE891BAC2),
    W256(0xE0965A3C,0xCE1D090D,0xBD62AB21,0x31C4CFFC,0x2318F851,0x96D3CA3D,0x716B453F,0xE4901E01)
  }
};
