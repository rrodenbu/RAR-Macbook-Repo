/**
 * Created by rrodenbu on 5/11/16.
 */
public class Application {
    public static void main(String[] args) {

        int[] values = {3, 4, 5, 6};

        System.out.println(values[2]);

        int[][] grid = { //multidimensional array
                {2, 3, 4, 5},
                {4, 5, 6, 7, 8, 9},
                {2, 3}
        };

        System.out.println(grid[1][1]);

        String[][] texts = new String[2][3];

        texts[0][1] = "Hello There!";

        System.out.println(texts[0][1]);

        for(int row=0; row < grid.length; row++) {
            for(int col=0; col < grid[row].length; col++) {
                System.out.print(grid[row][col] + "\t");
            }
            System.out.println();
        }

    }
}
