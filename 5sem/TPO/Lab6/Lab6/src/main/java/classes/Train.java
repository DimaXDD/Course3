package classes;

import java.sql.Time;
import java.util.Arrays;

public class Train {
    private String endLocation;
    private String number;
    private Time timeToTraveling;
    private int[] countOfPlaces = new int[4];

    public String getEndLocation() {
        return endLocation;
    }

    public void setEndLocation(String endLocation) {
        this.endLocation = endLocation;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Time getTimeToTraveling() {
        return timeToTraveling;
    }

    public void setTimeToTraveling(Time timeToTraveling) {
        this.timeToTraveling = timeToTraveling;
    }

    public int[] getCountOfPlaces() {
        return countOfPlaces;
    }

    public void setCountOfPlaces(int[] countOfPlaces) {
        this.countOfPlaces = countOfPlaces;
    }

    public Train(String endLocation, String number, Time timeToTraveling, int[] countOfPlaces) {
        this.endLocation = endLocation;
        this.number = number;
        this.timeToTraveling = timeToTraveling;
        this.countOfPlaces = countOfPlaces;
    }

    public Train(String endLocation) {
        this.endLocation = endLocation;
    }

    @Override
    public String toString() {
        return "Train{" +
                "endLocation='" + endLocation + '\'' +
                ", number='" + number + '\'' +
                ", timeToTraveling=" + timeToTraveling +
                ", countOfPlaces=" + Arrays.toString(countOfPlaces) +
                '}';
    }
    public static Train[] getArrTrain() {
        Train[] trains = new Train[4];
        for (var i = 3 ; i >= 0; i--)
        {
            if (i %2 == 0) {
                trains[i] = new Train("London", Integer.toString(i), new Time(i,i,i), new int[]{i,i,i+10,i});
                continue;
            }
            trains[i] = new Train("Minsk", Integer.toString(i), new Time(i,i,i), new int[]{i+2,i+12,i,i+13});
            }
        return trains;
    }
    public static void getTrain(Train[] trains,String endLocation) {
        for (var item: trains) {
            if (item.endLocation.equals(endLocation))
                System.out.println(item.toString());
        }
    }
    public static void getTrain(Train[] trains,String endLocation,Time time)
    {
        for (var item: trains) {
            if (item.endLocation.equals(endLocation) & item.timeToTraveling.equals(time))
                System.out.println(item.toString());
        }
    }
    public static void getTrainHasGeneralPlaces(Train[] trains,String endLocation) {
        for (var item: trains) {
            if (item.endLocation.equals(endLocation) & item.countOfPlaces[0] > 0)
                System.out.println(item.toString());
        }
    }

}
