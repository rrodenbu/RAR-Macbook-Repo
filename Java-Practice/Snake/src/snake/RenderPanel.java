package snake;

import javax.swing.JPanel;
import java.awt.*;

/**
 * Created by rrodenbu on 3/30/16.
 * Creates the actual game, in a new screen.
 */
@SuppressWarnings("serial")
public class RenderPanel extends JPanel {
    public static int curColor = 0;

    public static Color green = new Color(13434675);

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);     //set color
        g.setColor(green);     //also: new Color(0)
        g.fillRect(0, 0, 800, 700);  //set size of fill
        Snake snake = Snake.snake;
        g.setColor(Color.RED);
        for (Point point: snake.snakeParts){ //loop through all the parts in snakes body (array of parts)
            System.out.println("Printin snake body");
            g.fillRect(point.x * Snake.SCALE, point.y * snake.SCALE, snake.SCALE, snake.SCALE);
        }
        g.fillRect(snake.head.x, snake.head.y, Snake.SCALE, Snake.SCALE);
        //curColor++;
    }
}
