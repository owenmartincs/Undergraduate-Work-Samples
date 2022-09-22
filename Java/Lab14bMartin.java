import java.awt.*;
import java.applet.*;
import java.util.ArrayList;


public class Lab14bMartin extends Applet
{
	public void paint(Graphics g)
	{
      Train train = new Train(100,300);
      train.addCar("Locomotive",Color.blue);
      train.addCar("PassengerCar",Color.gray);
      train.addCar("PassengerCar",Color.gray);
      train.addCar("FreightCar",Color.green);
      train.addCar(3,"PassengerCar",Color.gray);
      train.addCar("FreightCar",Color.green);
      train.addCar("Caboose",Color.red);
      train.addCar(6,"FreightCar",Color.green);
      train.showCars(g);
	}
}

class Train
{
   ArrayList<RailCar> railCars;
   ArrayList<String> carTypes;
   ArrayList<Color> carColors;
   int start, xPos, yPos;
   
   public Train(int start, int yPos)
   {
      railCars = new ArrayList<RailCar>();
      carTypes = new ArrayList<String>();
      carColors = new ArrayList<Color>();
      this.start = start;
      this.yPos = yPos;
   }
   
   public void addCar(String type, Color color)
   {
      addCar(railCars.size(),type,color);
   }
   
   public void addCar(int index, String type, Color color)
   {
      carTypes.add(index,type);     //    Documents the new car's
      carColors.add(index,color);   //    type and color.
      
      ArrayList<RailCar> railCarsTemp = new ArrayList<RailCar>(); //    Removes objects from the railCars array 
      xPos = start;                                               //    and places them in the new railCarsTemp array 
      for (int x = 0; x < index; x++)                             //    if they occur before the index specified.
      {                                                           //    Simultaneously tracks where the xPos of each 
         railCarsTemp.add(railCars.remove(0));                    //    car should be.
         xPos += 175;                                             //
      }                                                           //
      
      switch (type)                                                                              //    Adds a new object (of the appropriate
      {                                                                                          //    car type and color) into the railcarsTemp
         case "Locomotive":   railCarsTemp.add(index,new Locomotive(color,xPos,yPos));    break; //    array using the calculated xPos, and increments
         case "PassengerCar": railCarsTemp.add(index,new PassengerCar(color,xPos,yPos));  break; //    xPos.
         case "FreightCar":   railCarsTemp.add(index,new FreightCar(color,xPos,yPos));    break; //
         case "Caboose":      railCarsTemp.add(index,new Caboose(color,xPos,yPos));       break; //
      }                                                                                          //
      xPos += 175;                                                                               //
            
      for (int x = index+1; x < carTypes.size(); x++)                                                       //    Adds objects into the railCarsTemp array
      {                                                                                                     //    that match the appropriate types of cars
         switch (carTypes.get(x))                                                                           //    documented by the carTypes array, but moves
         {                                                                                                  //    them to the correct xPos.
            case "Locomotive":   railCarsTemp.add(x,new Locomotive(carColors.get(x),xPos,yPos));    break;  //
            case "PassengerCar": railCarsTemp.add(x,new PassengerCar(carColors.get(x),xPos,yPos));  break;  //    This does not remove the remaining cars in the
            case "FreightCar":   railCarsTemp.add(x,new FreightCar(carColors.get(x),xPos,yPos));    break;  //    railCars array, but essentially copies what was
            case "Caboose":      railCarsTemp.add(x,new Caboose(carColors.get(x),xPos,yPos));       break;  //    left in it to the temp. Their xPos, however, are 
         }                                                                                                  //    shifted over one index to accomodate the new
         xPos += 175;                                                                                       //    car.
      }                                                                                                     //
      
      while (railCars.size() > 0) {railCars.remove(0);}  //    Clears the railCars array and 
      for (RailCar railcar : railCarsTemp)               //    refills it with the objects in
         railCars.add(railcar);                          //    the railCarsTemp array.
   }
   
   public void showCars(Graphics g)
   {
      for (RailCar railCar : railCars)
         railCar.drawCar(g);
   }
}
	