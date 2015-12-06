/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'packet_msg'
 * message type.
 */

public class packet_msg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 102;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 14;

    /** Create a new packet_msg of size 102. */
    public packet_msg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new packet_msg of the given data_length. */
    public packet_msg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new packet_msg with the given data_length
     * and base offset.
     */
    public packet_msg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new packet_msg using the given byte array
     * as backing store.
     */
    public packet_msg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new packet_msg using the given byte array
     * as backing store, with the given base offset.
     */
    public packet_msg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new packet_msg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public packet_msg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new packet_msg embedded in the given message
     * at the given base offset.
     */
    public packet_msg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new packet_msg embedded in the given message
     * at the given base offset and length.
     */
    public packet_msg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <packet_msg> \n";
      try {
        s += "  [c_len=0x"+Long.toHexString(get_c_len())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [content=";
        for (int i = 0; i < 52; i++) {
          s += "0x"+Long.toHexString(getElement_content(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [r_len=0x"+Long.toHexString(get_r_len())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [r=";
        for (int i = 0; i < 24; i++) {
          s += "0x"+Long.toHexString(getElement_r(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [s=";
        for (int i = 0; i < 24; i++) {
          s += "0x"+Long.toHexString(getElement_s(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: c_len
    //   Field type: short, unsigned
    //   Offset (bits): 0
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'c_len' is signed (false).
     */
    public static boolean isSigned_c_len() {
        return false;
    }

    /**
     * Return whether the field 'c_len' is an array (false).
     */
    public static boolean isArray_c_len() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'c_len'
     */
    public static int offset_c_len() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'c_len'
     */
    public static int offsetBits_c_len() {
        return 0;
    }

    /**
     * Return the value (as a short) of the field 'c_len'
     */
    public short get_c_len() {
        return (short)getUIntElement(offsetBits_c_len(), 8);
    }

    /**
     * Set the value of the field 'c_len'
     */
    public void set_c_len(short value) {
        setUIntElement(offsetBits_c_len(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'c_len'
     */
    public static int size_c_len() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'c_len'
     */
    public static int sizeBits_c_len() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: content
    //   Field type: short[], unsigned
    //   Offset (bits): 8
    //   Size of each element (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'content' is signed (false).
     */
    public static boolean isSigned_content() {
        return false;
    }

    /**
     * Return whether the field 'content' is an array (true).
     */
    public static boolean isArray_content() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'content'
     */
    public static int offset_content(int index1) {
        int offset = 8;
        if (index1 < 0 || index1 >= 52) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 8;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'content'
     */
    public static int offsetBits_content(int index1) {
        int offset = 8;
        if (index1 < 0 || index1 >= 52) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 8;
        return offset;
    }

    /**
     * Return the entire array 'content' as a short[]
     */
    public short[] get_content() {
        short[] tmp = new short[52];
        for (int index0 = 0; index0 < numElements_content(0); index0++) {
            tmp[index0] = getElement_content(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'content' from the given short[]
     */
    public void set_content(short[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_content(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a short) of the array 'content'
     */
    public short getElement_content(int index1) {
        return (short)getUIntElement(offsetBits_content(index1), 8);
    }

    /**
     * Set an element of the array 'content'
     */
    public void setElement_content(int index1, short value) {
        setUIntElement(offsetBits_content(index1), 8, value);
    }

    /**
     * Return the total size, in bytes, of the array 'content'
     */
    public static int totalSize_content() {
        return (416 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'content'
     */
    public static int totalSizeBits_content() {
        return 416;
    }

    /**
     * Return the size, in bytes, of each element of the array 'content'
     */
    public static int elementSize_content() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'content'
     */
    public static int elementSizeBits_content() {
        return 8;
    }

    /**
     * Return the number of dimensions in the array 'content'
     */
    public static int numDimensions_content() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'content'
     */
    public static int numElements_content() {
        return 52;
    }

    /**
     * Return the number of elements in the array 'content'
     * for the given dimension.
     */
    public static int numElements_content(int dimension) {
      int array_dims[] = { 52,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

    /**
     * Fill in the array 'content' with a String
     */
    public void setString_content(String s) { 
         int len = s.length();
         int i;
         for (i = 0; i < len; i++) {
             setElement_content(i, (short)s.charAt(i));
         }
         setElement_content(i, (short)0); //null terminate
    }

    /**
     * Read the array 'content' as a String
     */
    public String getString_content() { 
         char carr[] = new char[Math.min(net.tinyos.message.Message.MAX_CONVERTED_STRING_LENGTH,52)];
         int i;
         for (i = 0; i < carr.length; i++) {
             if ((char)getElement_content(i) == (char)0) break;
             carr[i] = (char)getElement_content(i);
         }
         return new String(carr,0,i);
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: r_len
    //   Field type: short, unsigned
    //   Offset (bits): 424
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'r_len' is signed (false).
     */
    public static boolean isSigned_r_len() {
        return false;
    }

    /**
     * Return whether the field 'r_len' is an array (false).
     */
    public static boolean isArray_r_len() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'r_len'
     */
    public static int offset_r_len() {
        return (424 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'r_len'
     */
    public static int offsetBits_r_len() {
        return 424;
    }

    /**
     * Return the value (as a short) of the field 'r_len'
     */
    public short get_r_len() {
        return (short)getUIntElement(offsetBits_r_len(), 8);
    }

    /**
     * Set the value of the field 'r_len'
     */
    public void set_r_len(short value) {
        setUIntElement(offsetBits_r_len(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'r_len'
     */
    public static int size_r_len() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'r_len'
     */
    public static int sizeBits_r_len() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: r
    //   Field type: short[], unsigned
    //   Offset (bits): 432
    //   Size of each element (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'r' is signed (false).
     */
    public static boolean isSigned_r() {
        return false;
    }

    /**
     * Return whether the field 'r' is an array (true).
     */
    public static boolean isArray_r() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'r'
     */
    public static int offset_r(int index1) {
        int offset = 432;
        if (index1 < 0 || index1 >= 24) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 8;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'r'
     */
    public static int offsetBits_r(int index1) {
        int offset = 432;
        if (index1 < 0 || index1 >= 24) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 8;
        return offset;
    }

    /**
     * Return the entire array 'r' as a short[]
     */
    public short[] get_r() {
        short[] tmp = new short[24];
        for (int index0 = 0; index0 < numElements_r(0); index0++) {
            tmp[index0] = getElement_r(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'r' from the given short[]
     */
    public void set_r(short[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_r(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a short) of the array 'r'
     */
    public short getElement_r(int index1) {
        return (short)getUIntElement(offsetBits_r(index1), 8);
    }

    /**
     * Set an element of the array 'r'
     */
    public void setElement_r(int index1, short value) {
        setUIntElement(offsetBits_r(index1), 8, value);
    }

    /**
     * Return the total size, in bytes, of the array 'r'
     */
    public static int totalSize_r() {
        return (192 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'r'
     */
    public static int totalSizeBits_r() {
        return 192;
    }

    /**
     * Return the size, in bytes, of each element of the array 'r'
     */
    public static int elementSize_r() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'r'
     */
    public static int elementSizeBits_r() {
        return 8;
    }

    /**
     * Return the number of dimensions in the array 'r'
     */
    public static int numDimensions_r() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'r'
     */
    public static int numElements_r() {
        return 24;
    }

    /**
     * Return the number of elements in the array 'r'
     * for the given dimension.
     */
    public static int numElements_r(int dimension) {
      int array_dims[] = { 24,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

    /**
     * Fill in the array 'r' with a String
     */
    public void setString_r(String s) { 
         int len = s.length();
         int i;
         for (i = 0; i < len; i++) {
             setElement_r(i, (short)s.charAt(i));
         }
         setElement_r(i, (short)0); //null terminate
    }

    /**
     * Read the array 'r' as a String
     */
    public String getString_r() { 
         char carr[] = new char[Math.min(net.tinyos.message.Message.MAX_CONVERTED_STRING_LENGTH,24)];
         int i;
         for (i = 0; i < carr.length; i++) {
             if ((char)getElement_r(i) == (char)0) break;
             carr[i] = (char)getElement_r(i);
         }
         return new String(carr,0,i);
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: s
    //   Field type: short[], unsigned
    //   Offset (bits): 624
    //   Size of each element (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 's' is signed (false).
     */
    public static boolean isSigned_s() {
        return false;
    }

    /**
     * Return whether the field 's' is an array (true).
     */
    public static boolean isArray_s() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 's'
     */
    public static int offset_s(int index1) {
        int offset = 624;
        if (index1 < 0 || index1 >= 24) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 8;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 's'
     */
    public static int offsetBits_s(int index1) {
        int offset = 624;
        if (index1 < 0 || index1 >= 24) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 8;
        return offset;
    }

    /**
     * Return the entire array 's' as a short[]
     */
    public short[] get_s() {
        short[] tmp = new short[24];
        for (int index0 = 0; index0 < numElements_s(0); index0++) {
            tmp[index0] = getElement_s(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 's' from the given short[]
     */
    public void set_s(short[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_s(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a short) of the array 's'
     */
    public short getElement_s(int index1) {
        return (short)getUIntElement(offsetBits_s(index1), 8);
    }

    /**
     * Set an element of the array 's'
     */
    public void setElement_s(int index1, short value) {
        setUIntElement(offsetBits_s(index1), 8, value);
    }

    /**
     * Return the total size, in bytes, of the array 's'
     */
    public static int totalSize_s() {
        return (192 / 8);
    }

    /**
     * Return the total size, in bits, of the array 's'
     */
    public static int totalSizeBits_s() {
        return 192;
    }

    /**
     * Return the size, in bytes, of each element of the array 's'
     */
    public static int elementSize_s() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 's'
     */
    public static int elementSizeBits_s() {
        return 8;
    }

    /**
     * Return the number of dimensions in the array 's'
     */
    public static int numDimensions_s() {
        return 1;
    }

    /**
     * Return the number of elements in the array 's'
     */
    public static int numElements_s() {
        return 24;
    }

    /**
     * Return the number of elements in the array 's'
     * for the given dimension.
     */
    public static int numElements_s(int dimension) {
      int array_dims[] = { 24,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

    /**
     * Fill in the array 's' with a String
     */
    public void setString_s(String s) { 
         int len = s.length();
         int i;
         for (i = 0; i < len; i++) {
             setElement_s(i, (short)s.charAt(i));
         }
         setElement_s(i, (short)0); //null terminate
    }

    /**
     * Read the array 's' as a String
     */
    public String getString_s() { 
         char carr[] = new char[Math.min(net.tinyos.message.Message.MAX_CONVERTED_STRING_LENGTH,24)];
         int i;
         for (i = 0; i < carr.length; i++) {
             if ((char)getElement_s(i) == (char)0) break;
             carr[i] = (char)getElement_s(i);
         }
         return new String(carr,0,i);
    }

}