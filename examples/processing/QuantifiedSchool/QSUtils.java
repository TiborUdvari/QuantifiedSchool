import java.util.Date;
import java.sql.Timestamp;

/**
*  Quantified School Utils
*/
class QSUtils 
{
  public static Date timestampToDate(Timestamp stamp)
  {
    return new Date(stamp.getTime());
  }
  
  public static Timestamp dateToTimestamp(Date date)
  {
    long time = date.getTime();
    return new Timestamp(time);
  }
  
  public static Timestamp currentTimestamp()
  {
      return new Timestamp(System.currentTimeMillis());
  }
  
  
}
