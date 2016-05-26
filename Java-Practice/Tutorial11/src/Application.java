/**
 * Created by rrodenbu on 5/11/16.
 */
public class Application {
    public static void main(String[] args) {
        String[] words = new String[3];

        words[0] = "Hello";
        words[1] = "World";
        words[2] = "!";

        for(int i = 0; i < words.length; i++) {
            System.out.println(words[i]);
        }

        String[] moreWords = {"Other", "Words", "!"};

        for(int i=0; i < moreWords.length; i++) {
            System.out.println(moreWords[i]);
        }

        for(String word: moreWords) {
            System.out.println(word);
        }

        int value = 123;

        String text; //Address of memory that contains string (i.e. null)
        String[] texts = new String[2]; //Default null (2 addresses)
        System.out.println(texts[0]); //Prints "null"

    }
}
