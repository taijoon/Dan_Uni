
enum {
  /* Number of readings per message. If you increase this, you may have to
     increase the message_t size. */
  NREADINGS = 5,

  /* Default sampling period. */
  DEFAULT_INTERVAL = 1024,

  AM_OSCILLOSCOPE = 0x93
};

typedef nx_struct sec {
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t count; /* The readings are samples count * NREADINGS onwards */
	nx_uint16_t type;
	nx_uint8_t p_x_key[20];
	nx_uint8_t p_y_key[20];
} sec_t;

