/**
 * @author Mostafa Agourri
 * @date 21/02/2022
 * @description SM_APU100_StringUtils - Utilities to manipulate String
 */
public inherited sharing class SM_APU100_StringUtils {
    
    /**
     * @author Mostafa Agourri
     * @date 21/02/2022
     * @param email email value to validate
     * @description validate email through regexp
     * @return Boolean true if email is valid
     */
    public static Boolean emailAddressIsValid(String email) {
		
        Boolean isValid = true;

        if (String.isEmpty(email)){
            return isValid;
        }
			
		// Regex source: http://www.regular-expressions.info/email.html
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
		Pattern myPattern = Pattern.compile(emailRegex);
		Matcher myMatcher = myPattern.matcher(email);
	
		// on élimine aussi quelques cas non gérés par la regex
        if (!myMatcher.matches() || email.contains('-.') || email.contains('.-') || email.contains('@-') || email.endsWith('.')){
		    isValid = false;
        }

		return isValid;
	}
}