import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 10;
private final static int NUM_COLS = 10;
private final static int NUM_MINES = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean wonned = false;
boolean lossed = false;

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r<NUM_ROWS; r++){
     for(int c = 0; c<NUM_COLS ; c++){
        buttons[r][c] = new MSButton(r,c);
     }
    }
    
    setMines();
}
public void setMines()
{
 while(mines.size() < NUM_MINES){
 int r = (int)(Math.random()*NUM_ROWS);
 int c = (int)(Math.random()*NUM_COLS);
 if(!mines.contains((buttons[r][c]))){
 mines.add(buttons[r][c]);
 System.out.println(r + ", " + c);
}
}
}
public void draw ()
{
    background( 255 );
    if(isWon() == true)
        displayWinningMessage();
     fill(0);
    text("win",width/2,height + 70);
    
}
public boolean isWon()
{

       for(int r = 0; r<NUM_ROWS;r++){
        for(int c = 0; c<NUM_COLS;c++){
          if(buttons[r][c].clicked == false && !mines.contains(buttons[r][c]))
            return false;
        }
       }
    return true;
}


public void displayLosingMessage()
{
    System.out.println("loss");
    lossed = true;
}
public void displayWinningMessage()
{
    System.out.println("win");
    wonned = true;
}

public boolean isValid(int r, int c)
{
    //your code here
    if(r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
    return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = -1; i<2; i++){
      for(int j = -1; j<2; j++){
        if(isValid(row+i, col +j) == true && mines.contains(buttons[row+i][col+j]))
        numMines = numMines + 1;
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT){
          if(flagged == true){
            flagged = false;
            clicked = false;
          }
          else
          flagged = true;
        }
        else if(mines.contains(this)){
        displayLosingMessage();
        setLabel("you lost :(");
        
        for(int r = 0; r<NUM_ROWS;r++){
        for(int c = 0; c<NUM_COLS;c++){
          if(mines.contains(buttons[r][c]))
            buttons[r][c].clicked = true;
        }
       }
        }
        else if(countMines(myRow,myCol) > 0){
         setLabel(countMines(myRow,myCol)); 
        }
        else
        for(int i=-1; i<2;i++){
         for(int j = -1; j<2; j++){
          if(isValid(myRow+i,myCol+j) && buttons[myRow + i][myCol + j].clicked == false)
            buttons[myRow + i][myCol + j].mousePressed();
         }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(150,255,150);
        else if( clicked && mines.contains(this) ) 
            fill(255,150,150);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );    
        rect(x, y, width, height);
        fill(0);
        textSize(width/5);
        text(myLabel,x+width/2,y+height/2);
        
        if(wonned == true){
        textSize(width/4);
        setLabel("you won!");
        }
       
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
