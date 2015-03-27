import java.util.Date;
import java.sql.Timestamp;
import java.util.List;

// ---  Configuration  ---

static final String PROTOCOL = "http://";
static final String SERVER_ADDR = "178.62.253.111";
static final String SEP = "/";
static final String LIVE = "live?limit=80";

static final String DATA_ADDR = PROTOCOL + SERVER_ADDR + SEP + LIVE;

// Note: static final = constant, value can not change after declaration => remove if necessary

// ---      Vars       ---

JSONArray jsonArray;
List<Integer> lightValues;
long latestDataTimestamp = 0;

// ---      Main       --- 

void setup()
{  
  initObjects();
  
  size(displayWidth, displayHeight);
  background(0);
  getDatasFromServer();
  
  Timestamp stamp = QSUtils.currentTimestamp();
  Date date = QSUtils.timestampToDate(stamp);
  System.out.println(date);
}

void initObjects()
{
  lightValues = new ArrayList();
}

void getDatasFromServer()
{
  JSONArray values = loadJSONArray(DATA_ADDR);
  parseDatas(values);
  println(values);
}

/**
* Parses the datas of interest 
*/
void parseDatas(JSONArray values)
{
  lightValues.clear();
  //Just getting the timestamps
    for (int i = 0; i < values.size(); i++) 
    {
      JSONObject sensorData = values.getJSONObject(i); 
      long timestamp = sensorData.getJSONObject("timestamp").getLong("$date");
      int value = sensorData.getInt("value");
      latestDataTimestamp = timestamp;
      lightValues.add(new Integer(value));
    }
}

void draw()
{
  int latestValue = lightValues.get(0);
  int b = (int)map(latestValue, -22, 92, 255, 0);
  background(b);
  
  int padding = 20;
  int count = lightValues.size();
  float deltaDistance = (width - padding) / count;
  
  float px = 0;
  float py = 0;
  for (int i = 0; i < count ; i++)
  {
    int value = lightValues.get(i);
    float x = width - (padding + i * deltaDistance);
    // light values are between about 0 - 100
    float y = map(value, -32, 92, padding, height-padding); 
    
    float rad = 5;
    
    fill(0);
    stroke(0);
    ellipse(x, y, rad, rad);
    if (i > 0)
    line(x,y,px,py);
    px = x;
    py = y;
  }
  
  printCurrentTime();
  printLastTimeStamp();
  
  if (frameCount % 30 == 0)
  {
    getDatasFromServer();
  }
}

void printCurrentTime()
{
  fill(0);
  textSize(12);
  text("Current time " + new Date(), 10, height - 15); 
}

void printLastTimeStamp()
{
  fill(0);
  Timestamp t  = new Timestamp(latestDataTimestamp);
  text("Latest value" + lightValues.get(0) + " recieved at " + QSUtils.timestampToDate(t), 10, 15);   
}
