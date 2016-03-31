package snake;

import javax.swing.JPanel;
import java.awt.*;

/**
 * Created by rrodenbu on 3/30/16.
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
        //curColor++;
    }
}
