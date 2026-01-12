public int rownum = 32;
public boolean[][] minefield;
public boolean[][] cover = new boolean[rownum][rownum];
public boolean[][] flags = new boolean[rownum][rownum];
public int gamestate = 0;
public void setup()
{
    minefield = GenerateMinefield();
    cover = fill2D(cover, true);
    flags = fill2D(flags,false);
    size(800,800);
}
public void draw()
{
    for(int i = 0; i<minefield.length;i++)
    {
        for(int j = 0; j<minefield[i].length;j++)
        {
           fill(150);
           if(cover[i][j] || gamestate==-1)fill(100);
           if(cover[i][j]&&flags[i][j]) fill(150,100,100);
           if(minefield[i][j] && gamestate==-1)
           {
            if(frameCount%40<20) fill(150,100,100);
           }
           rect(i*800/rownum, j*800/rownum, 800/rownum, 800/rownum);
           fill(0);
           textSize(15);
           if(!minefield[i][j]&&!cover[i][j])text(Integer.toString(countNeighborTrues(i,j)), i*800/rownum+800/rownum/2, j*800/rownum+800/rownum/2);
        }
  }
}
public boolean[][] GenerateMinefield()
{
    boolean[][] field = new boolean[rownum][rownum];

    for(int i = 0; i<field.length;i++)
    {
        for(int j = 0; j<field[i].length;j++)
        {
            if(Math.random()>.13)field[i][j]=false; else field[i][j]=true;
        }
  }
  return field;
}
public int countNeighborTrues(int row, int col){
  int[][] adj = {{1,0},{-1,0},{0,1},{0,-1},{1,1},{-1,-1},{1,-1},{-1,1}};
  int count =0;
  for(int[] n:adj)
  {
    if(isValidOnNbyN(rownum, rownum, row+n[1], col+n[0]) && minefield[row+n[1]][col+n[0]])count++;
  }
  return count;
}
public boolean isValidOnNbyN(int NUM_ROWS, int NUM_COLS, int row, int col){
    return (row>=0 && row<NUM_ROWS)&&(col>=0 && col<NUM_COLS);
}
public boolean[][] fill2D(boolean[][] vals, boolean val){
  for(int i = 0; i<vals.length;i++)
  {
    for(int j = 0; j<vals[i].length;j++)
    {
      vals[i][j]=val;
    }
  }
  return vals;
}
public void clear(int row, int col, int it)
{
    if(it==0)
    {
        cover[row][col] = false;
    }
    if(it<5 && countNeighborTrues(row, col)==0)
    {
    int[][] adj = {{1,0},{-1,0},{0,1},{0,-1},{1,1},{-1,-1},{1,-1},{-1,1}};
    for(int[] n:adj)
    {
        int newRow = row+n[1];
        int newCol = col+n[0];
        if(isValidOnNbyN(rownum, rownum, newRow, newCol))
        {
            cover[newRow][newCol] = false;
            clear(newRow, newCol, it +1);
        }
    }
    }

}
public void mousePressed()
{
    if(gamestate==-1)
    {
        cover = fill2D(cover, true);
        flags = fill2D(flags,false);
        minefield = GenerateMinefield();
        gamestate = 0;
    }
    if (gamestate==0)
    {
    int y=(int)(mouseY/(800/rownum));
    int x=(int)(mouseX/(800/rownum));
    if(mouseButton==LEFT)
    {
        if(minefield[x][y])
        {
            gamestate = -1;
        }
        else clear(x,y,0);
    }
    else
    {
        flags[x][y]=!flags[x][y];
    }
    boolean win = true;
    for(int i = 0; i<rownum;i++)
    {
        for(int j = 0; j<rownum;j++)
        {
            if(cover[i][j] && !minefield[i][j])win=false;   
        }
    }
    if(win==true)
    {
        cover = fill2D(cover, true);
        flags = fill2D(flags,false);
        minefield = GenerateMinefield();
    }
    }
}
