public with sharing class SM_AP22_ImpersonationEncryption {

    //private String modulus;
    Decimal modDec;
    //private String exponent;
    Integer expDec;

    // Hex digits
    private static final String DIGITS = '0123456789abcdef';
    private static final String[] codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='.split('');
    private static final Decimal HEX_BASE = 16;

    public SM_AP22_ImpersonationEncryption(String modulus, String exponent) {
        this.modDec = hexToDecimal(modulus);
        system.debug('modulus: ' + modDec);
        expDec = Integer.valueOf(exponent);
        System.debug('exp: ' + expDec);
    }

    public String encrypt(String input) {
        // Pad password
        Decimal pnDec = pkcs1Pad15v2(input,256); 
		system.debug('padded : ' + pnDec);
        // Calcluate padded^exp % mod and convert to hex
        Decimal result = modPow(pnDec, expDec, modDec);
        system.debug('modpow in dec: ' + result);
        String resb64 = decimaltob64(result);
        system.debug('modpow in b64: ' + resb64);


        return resb64;
    }
    
    
        @testVisible
    public static Decimal hexToDecimal(String hex) {
        Decimal result = 0;
        integer length = hex.length();
        integer i = 0;
        while(i < length) {
            integer hexByte = DIGITS.indexOf(hex.substring(i, i + 1).toLowerCase());
            i++;
            result = result*16 + hexByte ;
        }
        return result;
    }
    

	// origine par https://salesforce.stackexchange.com/questions/148350/integer-array-to-base64-string
	// key size = 2048 bits - hardcoded
    private static String decimaltob64(Decimal token) {
        // Preallocate memory for speed
        String[] result = new String[(256+2)/3];
        // dernier bloc de 1 octet + padding base64
        Decimal tokdiv = token.divide(256, 0, RoundingMode.FLOOR);
        Integer temp = (token - (tokdiv * 256)).intValue();
        // dernier bloc sur 1 byte, donc two bytes padding
        temp = (temp<<16);
        result[85] = codes[temp>>18]+(codes[(temp>>12)&63])+codes[64]+codes[64];
		// maintenant on boucle sur les 84 autres blocs
        // Every three bytes input becomes four bytes output
        for(Integer index = 84; index > -1 ; index--) {
            token = tokdiv;
	        tokdiv = token.divide(256*256*256, 0, RoundingMode.FLOOR);
	        temp = (token - (tokdiv * 256 * 256 * 256)).intValue();
            // Extract four values from 0-63, and use the code from the base 64 index
            result[index]=codes[temp>>18]+(codes[(temp>>12)&63])+(codes[(temp>>6)&63])+codes[temp&63];
        }
        // Join into a single string
        return String.join(result, '');
    }



    // base^exp % mod
    // cf: https://stackoverflow.com/questions/8496182/calculating-powa-b-mod-n
    @testVisible
    private static Decimal modPow(Decimal base, Integer exp, Decimal mod) {
        if (base < 1 || exp < 0 || mod < 1) {
            return -1;
        }
        base = modulus(base,mod);

        Decimal result = 1;
        while (exp > 0) {
           if ((exp & 1) == 1) {
               result = modulus((result * base), mod);
           }
           base = modulus((base * base), mod);
           exp = exp/2;
        }
        return result;
    }

    // dividend % divisor
    @testVisible
    private static Decimal modulus(Decimal dividend, Decimal divisor) {
        Decimal d = dividend.divide(divisor, 0, RoundingMode.FLOOR);
        return dividend - (d * divisor);
    }
  

    // Pad using PKCS#1 v.1.5
    // Pad format  : 0x00 | 2 | Padding... | 0x00 | data...data
    // total length=modulus length
    // result  transformed to decimal
    // input = String to pad
    // len = length of modulus
    @testVisible
    private static Decimal pkcs1Pad15v2(string input, integer len) {
        integer inputlen = input.length();
        integer padlen = len - inputlen -3;
        // padval holds the padding value
        Decimal padval=2;
        // adding the padding 
        for(integer loop1=0;loop1<padlen;loop1++){
            padval = padval *256 + Math.round(Math.random() * (127 - 32) + 32) ;
        }
        // adding the 0 at the end of the padding
        padval = padval *256;
        // adding the string
        integer cval = 0;
        for(integer loop2=0 ;loop2<inputlen;loop2++){
            cval = input.charAt(loop2);
            padval = padval *256 + cval ;
        }
        return padval;
    }    
}