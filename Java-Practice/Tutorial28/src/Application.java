/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Casting numerical values.
 */
public class Application {

    public static void main(String[] args) {

        byte byteValue = 20;    //4 bits
        short shortValue =  55; //16 bits
        int intValue = 888;     //32 bits
        long longValue = 23555; //64 bits

        float floatValue = 8834.8f; //less precision(must have f)
        float floatValue2 = (float) 99.3;
        double doubleValue = 32.5; //more precision

        System.out.println(Byte.MAX_VALUE);

        //CASTING
        intValue = (int) longValue;
        System.out.println(intValue);

        doubleValue = intValue;
        System.out.println(doubleValue);

        intValue = (int) floatValue; //No rounding
        System.out.println(intValue);

        intValue = (int) Math.round(floatValue) ;
        System.out.println(intValue);

        // The following won't work as expected.
        // 128 is too big for a byte.
        byteValue = (byte)128;
        System.out.println(byteValue); //return -128

    }

}
